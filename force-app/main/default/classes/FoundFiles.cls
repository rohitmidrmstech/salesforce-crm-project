global class FoundFiles implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global Set<Id> destinationRecordIds;
    global String sourceSessionId;
    global String sourceDomainURL;

    global FoundFiles(Set<Id> destinationRecordIds, String sourceSessionId, String sourceDomainURL){
        this.destinationRecordIds = destinationRecordIds;
        this.sourceSessionId = sourceSessionId;
        this.sourceDomainURL = sourceDomainURL;
    }

   
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'SELECT ID, GCP_ID__c, Processed_ids__c FROM Opportunity WHERE id IN :destinationRecordIds';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Opportunity> oppList) {

        try {
            System.debug('@@@ BATCH STARTED...');
            Opportunity record = oppList[0];
            System.debug('@@@ FoundFiles: '+record);
            String externalRecordId = record.GCP_ID__c;
            String destinationRecordId = record.id;
            
    
            String query_CDL_URL = sourceDomainURL + '/services/data/v58.0/query?q=SELECT+id,ContentDocumentId+FROM+ContentDocumentLink+WHERE+LinkedEntityId=\''+externalRecordId+'\'';
            Http ht = new Http();
            HttpRequest cdlReq = new HttpRequest();
            cdlReq.setMethod('GET');
            cdlReq.setEndpoint(query_CDL_URL);
            cdlReq.setHeader('Content-Type','application/json');
            cdlReq.setHeader('Authorization','OAuth '+sourceSessionId);
            HttpResponse cdlRes = ht.send(cdlReq);
            System.debug('Response body: '+cdlRes.getBody());
    
            FoundFiles.CDLRecordsWrapper cdlObj = new FoundFiles.CDLRecordsWrapper();
            FoundFiles.CDLRecordsWrapper resCDL = cdlObj.parse(cdlRes.getBody());
            System.debug('Response body: '+resCDL);
            
            String cdIds = '(';
            for(cdlRecords cdl : resCDL.records) {
                cdIds += '\'' + cdl.ContentDocumentId + '\',';
            }
            if(cdIds.endsWith(',')) {
                cdIds = cdIds.substring(0, cdIds.length() - 1);
            }
            cdIds += ')';
    
            String query_CV_URL = '';
            if(record.Processed_ids__c!=null) {
                String processedCVId = '(';
                for(String cvId : record.Processed_ids__c.split(';')) {
                    processedCVId += '\'' + cvId + '\',';
                }
                if(processedCVId.endsWith(',')) {
                    processedCVId = processedCVId.substring(0, processedCVId.length() - 1);
                }
                processedCVId += ')';
                query_CV_URL = sourceDomainURL + '/services/data/v58.0/query?q=SELECT+id,+title,+FileExtension+FROM+ContentVersion+WHERE+ContentDocumentId+IN+'+cdIds+'+AND+ID+NOT+IN+'+processedCVId+'+LIMIT+1';
            } else {
                query_CV_URL = sourceDomainURL + '/services/data/v58.0/query?q=SELECT+id,+title,+FileExtension+FROM+ContentVersion+WHERE+ContentDocumentId+IN+'+cdIds+'+LIMIT+1';
            }
            System.debug('@@@ query_CV_URL: '+ query_CV_URL);
            Http ht2 = new Http();
            HttpRequest cvReq = new HttpRequest();
            cvReq.setMethod('GET');
            cvReq.setEndpoint(query_CV_URL);
            cvReq.setHeader('Content-Type','application/json');
            cvReq.setHeader('Authorization','OAuth '+sourceSessionId);
            HttpResponse cvRes = ht.send(cvReq);
            System.debug('Response body: '+cvRes.getBody());
    
            FoundFiles.CVRecordsWrapper cvObj = new FoundFiles.CVRecordsWrapper();
            FoundFiles.CVRecordsWrapper resCV = cvObj.parse(cvRes.getBody());
            System.debug('Response body: '+resCV);
            // cvRecords = resCV.records[0]
            System.enqueueJob(new RetriveFileQueue(destinationRecordId, resCV.records[0], sourceSessionId, sourceDomainURL));
            
            // for(cvRecords cvRecord : resCV.records) {
            //     System.enqueueJob(new RetriveFileQueue(destinationRecordId, resCV.records[0], sourceSessionId, sourceDomainURL));
            // }
        } catch (Exception ex) {
            System.debug('NO CV FOUND....'+ ex);
            
        }
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }

    public class CDLRecordsWrapper{
        public cdlRecords[] records;
        public CDLRecordsWrapper parse(String json){
            return (CDLRecordsWrapper) System.JSON.deserialize(json, CDLRecordsWrapper.class);
        }
    }

    public class cdlRecords {
        public String Id;   //06A5g00000ONMaKEAX
        public String ContentDocumentId;    //0695g00000Fxse8AAB
    }

    
    public class CVRecordsWrapper{
        public cvRecords[] records;
        public CVRecordsWrapper parse(String json){
            return (CVRecordsWrapper) System.JSON.deserialize(json, CVRecordsWrapper.class);
        }
    }

    public class cvRecords {
        public String Id;   //0685g00000GfIpmAAF
        public String Title;
        public String FileExtension;
    }
}