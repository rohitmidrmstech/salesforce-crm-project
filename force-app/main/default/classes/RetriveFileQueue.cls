public class RetriveFileQueue implements System.Queueable, Database.AllowsCallouts {
    private Id destinationRecordId;
    private FoundFiles.cvRecords cvRecord;
    private String sourceSessionId;
    private String sourceDomainURL;

    public RetriveFileQueue(Id destinationRecordId, FoundFiles.cvRecords cvRecord, String sourceSessionId, String sourceDomainURL) {
        this.destinationRecordId = destinationRecordId;
        this.cvRecord = cvRecord;
        this.sourceSessionId = sourceSessionId;
        this.sourceDomainURL = sourceDomainURL;
    }

    public void execute(System.QueueableContext context) {
        String getVersionDataURL = sourceDomainURL + '/services/data/v54.0/sobjects/ContentVersion/' +cvRecord.Id+ '/VersionData';
        HttpRequest req0 = new HttpRequest();
        req0.setEndpoint(getVersionDataURL);
        req0.setMethod('GET');
        req0.setHeader('Content-Type','application/json');
        req0.setHeader('Authorization','OAuth '+sourceSessionId);
        HTTPResponse res0 = new Http().send(req0);
        if (res0.getStatusCode() == 200) {
            // Process the response and update records, etc.

            // Create CV
            String pathOnClient = cvRecord.Title + '.' + cvRecord.FileExtension;

            ContentVersion cv = new ContentVersion(
                Title= cvRecord.Title,
                PathOnClient= pathOnClient,
                ContentLocation= 'S',
                VersionData= res0.getBodyAsBlob()
            );

            insert cv;

            System.debug(cv);
            ContentVersion newCVRecord = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE id = :cv.id LIMIT 1];

            ContentDocumentLink cdl = new ContentDocumentLink(
                ContentDocumentId=newCVRecord.ContentDocumentId,
                LinkedEntityId=destinationRecordId,
                ShareType='I',
                Visibility='AllUsers'
            );

            insert cdl;
            
            Opportunity opp = [SELECT Id, Processed_ids__c FROM Opportunity WHERE Id = :destinationRecordId LIMIT 1];
            
            if(opp.Processed_ids__c!=null) {
                opp.Processed_ids__c += ';'+cvRecord.Id;
            } else {
                opp.Processed_ids__c = cvRecord.Id;
            }
            
            update opp;
        }

    }

    public class CDRecordsWrapper{
        public CDRecords[] records;
        
        public CDRecordsWrapper parse(String json){
            return (CDRecordsWrapper) System.JSON.deserialize(json, CDRecordsWrapper.class);
        }
    }
    
    class CDRecords {
        public String ContentDocumentId;
    }
    
}