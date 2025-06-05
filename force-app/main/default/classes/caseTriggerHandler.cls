public without sharing class caseTriggerHandler {
    // method to apply assignment rules for portal cases
     public static void portalCaseAssignment(List<Case> cases){
        List<case> portalCases = new List<case>();
         SET<Id> set_reportTypeIds = new SET<Id>();
         //for(RecordType portalRecortType : [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' AND Name in ('Portal', 'Service Case')]){
         for(RecordType portalRecortType : [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' AND Name ='Portal']){
             set_reportTypeIds.add(portalRecortType.id);
         }
         for(Case c : cases){
             if(set_reportTypeIds.contains(c.RecordTypeId)){             
                 portalCases.add(new Case(id = c.id));      
             } 
         }         
        if(portalCases.size() > 0){
            Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            Database.update(portalCases, dmo); 
        }        
    }
    
   //This method is to format the Documents__c field data into Html format
    public static void formatDocumentData(case csNew, case csOld){
        String fileName;
        String htmlUrl = '';
        String documentdata;
        String[] urls;              
        if(csNew.Documents__c != null && csNew.Documents__c != ''){
            
            documentdata = csNew.Documents__c;           
            if(!documentdata.contains('<a')){
                urls = documentdata.split(',');
                if(urls.size()>0){
                    for(String strUrl : urls){
                        if(strUrl != ''){
                            strUrl = strUrl.replace('<br>', '');
                            fileName = getFileName(strUrl); 
                            if(htmlUrl == ''){
                                htmlUrl = getHtmlLink(strUrl,fileName);
                            }
                            else{
                                htmlUrl = htmlUrl + '<br>' + getHtmlLink(strUrl,fileName);
                            } 
                        }
                        
                    }
                }
                if(csOld != null){
                    if(csOld.Documents__c != '' && csOld.Documents__c != null){
                     csNew.Documents__c = csOld.Documents__c + '<br>' +  htmlUrl;
                    }
                    else{
                         csNew.Documents__c = htmlUrl;
                    }
                }
                else{
                    csNew.Documents__c = htmlUrl;
                }
              
               
            }
            
        }
    }
  //This method is to get the file name from the document url  
    private static string getFileName(String url){
        Integer startIndex;
        Integer endIndex;
        string strFileName;
        system.debug('url-->' + url);
        startIndex= url.lastindexOf('/');
        endIndex = url.indexOf('?');
        if(startIndex != -1 && endIndex != -1){
            strFileName =  url.substring(startIndex + 1,endIndex);
        }
        else if(startIndex != -1){
            strFileName =  url.substring(startIndex + 1);
        }
        else{
            strFileName = url;
        }
        return strFileName;
    }
    //This method is to format the url into html format
    private static string getHtmlLink(String url, String fileName){
        string strHtmlUrl;
        strHtmlUrl = '<a href="' + url + '" target="_blank">' + fileName + '</a>';       
        return strHtmlUrl;
    }
    
    //THis method to assign warehouse manager to Service cases
    public static void serviceCaseAssignment(List<Case> cases){
  
        System.debug('*** starting assignment');
         Set<Id> set_CaseIds = new Set<Id>();
         SET<Id> set_reportTypeIds = new SET<Id>();         
         Map<String, Service_Case_Assignment_Rule__c> map_rulesmdt = new  Map<String, Service_Case_Assignment_Rule__c>();
        
        for(RecordType portalRecortType : [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' AND Name ='Service']){
             set_reportTypeIds.add(portalRecortType.id);
         }
        
        for(Case c : cases){
             if(set_reportTypeIds.contains(c.RecordTypeId)){             
                 set_CaseIds.add(c.id);      
             } 
         }    
         System.debug('*** case set size is ' + set_CaseIds.size());
        string key;
        for(Service_Case_Assignment_Rule__c rulemdt : [SELECT ID, Issue_Category__c,Issue_Problem__c, Manager__c, 
                                                                    Plant__c, Case_Field_API_Name__c 
                                                                  FROM Service_Case_Assignment_Rule__c]){
           key = rulemdt.Issue_Category__c + '-' + rulemdt.Issue_Problem__c + '-' + rulemdt.Plant__c;
            //This condition is set key as 'No warehouse' when below service case assignment rules are null to set CSM as a first approver when warehouse is blank on Order.
            if(rulemdt.Issue_Category__c == null && rulemdt.Issue_Problem__c == null && rulemdt.Plant__c == null){
               key = 'No warehouse';        
            }
            
            map_rulesmdt.put(key, rulemdt);                                                                      
        } 
        System.debug('*** alan1');       
        List<Case> lst_updCases = new List<Case>();
        for(Case obj_Cs : [SELECT ID,Issue_Category__c,Issue_Problem__c,RSM__c, Order__r.Manufacturing_Plant__c, Order__r.Territory_ref__r.Region__r.Regional_Sales_Manager__C FROM Case WHERE ID in: set_CaseIds]){
            System.debug('*** alan2');       
        
            key = obj_Cs.Issue_Category__c + '-' + obj_Cs.Issue_Problem__c + '-' + obj_Cs.Order__r.Manufacturing_Plant__c;                                                                       
            obj_Cs.RSM__c = obj_Cs.Order__r.Territory_ref__r.Region__r.Regional_Sales_Manager__C;   
            
            System.debug('*** key is ' + key);
            if(map_rulesmdt.containsKey(key) && obj_Cs.Order__r.Manufacturing_Plant__c!= null){
                Service_Case_Assignment_Rule__c srulemdt = map_rulesmdt.get(key);
                if(srulemdt != null && srulemdt.Manager__c != null){
                    System.debug('*** warehouse mgr being set');
                    obj_Cs.Warehouse_Manager__c = srulemdt.Manager__c;  
                }
                else if(srulemdt != null && srulemdt.Case_Field_API_Name__c != null && (ID)obj_Cs.get(srulemdt.Case_Field_API_Name__c) != null){
                    System.debug('*** warehouse mgr being set 2');
                    obj_Cs.Warehouse_Manager__c = (ID)obj_Cs.get(srulemdt.Case_Field_API_Name__c);
                }
               lst_updCases.add(obj_Cs);
            } 
            //This condition is to set CSM as a 1st approver when warehouse is blank on Order.
            else if(obj_Cs.Order__r.Manufacturing_Plant__c == null){  
                System.debug('*** warehouse mgr is not being set by finding a matching rule.  May use No Warehouse rule');              
                Service_Case_Assignment_Rule__c srulemdt = map_rulesmdt.get('No warehouse');
                if(srulemdt!= null && srulemdt.Manager__c != null){
                    obj_Cs.Warehouse_Manager__c = srulemdt.Manager__c;  
                }
                lst_updCases.add(obj_Cs);
            }         
            
        }
        update lst_updCases;
    }
    
    // Code Merged Source(Outmerge) to Target(Inmerge)
    public static void aiuCreateCaseVOC(List<Case> newList, Boolean isInsert, Boolean isUpdate){
        //System.debug('VOCUtil.aiuCreateCaseVOCProcessed: '+VOCUtil.aiuCreateCaseVOCProcessed);
        if(VOCUtil.aiuCreateCaseVOCProcessed) return;
        List<ProDialogue_Input__c> vocList  = new List<ProDialogue_Input__c>();
        List<ProDialogue_Input__c> vocToUdate  = new List<ProDialogue_Input__c>();
        Map<string, string> commentMap = new Map<string, string>();
        Map<string, string> subCatMap = new Map<string, string>();
        Map<string, string> catMap = new Map<string, string>();
        Map<string, string> vocSourMap = new Map<string, string>();
        Set<Id> caseIdSet = new Set<Id>();
        Map<Id, ProDialogue_Input__c> existingVOC = new Map<Id, ProDialogue_Input__c>();
        
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GeneralCall').getRecordTypeId();
        
        if(isUpdate)
        {
            for(Case c: newList)
            {
                /*if(c.RecordTypeId == rtId && (c.Category__c !=  trigger.oldMap.get(c.Id).Category__c || c.Sub_Category__c !=  trigger.oldMap.get(c.Id).Sub_Category__c || c.Comments__c !=  trigger.oldMap.get(c.Id).Comments__c || c.VOC_Source__c !=  trigger.oldMap.get(c.Id).VOC_Source__c) && ((c.Category__c != null && c.Category__c != '') || (c.Sub_Category__c != null && c.Sub_Category__c != '') || (c.Comments__c != null && c.Comments__c != '') || (c.VOC_Source__c != null && c.VOC_Source__c != '')))
                    caseIdSet.add(c.Id);
                    commentMap.put(c.Id, c.Comments__c);
                    subCatMap.put(c.Id, c.Sub_Category__c);
                    catMap.put(c.Id, c.Category__c);*/
                    //vocSourMap.put(c.Id, c.VOC_Source__c);
            }
            System.debug('caseIdSet: '+caseIdSet);
            if(caseIdSet.size() > 0)
            {
                //This query is to retrieve the 18 digit ID of the Case since the Cases_id__c field on the ProDialogue_Input__c object stores 
                //18 digit ID and the field type is String. If only 15 digit Case ID is passed to the ProDialogue_Input__c query then the matching
                //VOC related to Case is not retrieved and the duplicate VOC's are getting created.
                Map<Id, Case> caseMap = new Map<Id, Case>([Select Id From Case Where Id IN: caseIdSet]);
                /*
                
                vocList = [Select Cases_id__c, Category__c, Sub_Category__c, Notes__c, Source__c, Priority__c from ProDialogue_Input__c where Cases_id__c in :caseMap.keyset()];
                for(ProDialogue_Input__c v : vocList) {
                    existingVOC.put(v.Cases_id__c, v);
                }*/
            }
        }
        System.debug('newList'+newList);
        System.debug('rtId'+rtId);
        for(Case c : newList)
        {
            if((isInsert || caseIdSet.size() > 0) && !existingVOC.containsKey(c.Id) && c.RecordTypeId == rtId && ((c.Category__c != null && c.Category__c != '') || (c.Sub_Category__c != null && c.Sub_Category__c != '') || (c.Comments__c != null && c.Comments__c != '')))
            {
                ProDialogue_Input__c voc = new ProDialogue_Input__c();
                voc.Cases_id__c = c.Id;
                voc.Category__c = c.Category__c;
                voc.Sub_Category__c = c.Sub_Category__c;
                //voc.Source__c = c.VOC_Source__c;
                voc.Notes__c= c.Comments__c;
                if(c.AccountId!=null)
                    voc.Account__c = c.AccountId;
                if(c.ContactId!=null)
                    voc.Contact__c = c.contactId;
                vocToUdate.add(voc);
            }       
        }
        if(vocList.size()>0)
        {   
            for(ProDialogue_Input__c v : vocList)
            {
                if(v.Id == null) continue;
                
                if(commentMap.containsKey(v.Cases_id__c))
                    v.Notes__c = commentMap.get(v.Cases_id__c);
                
                if(catMap.containsKey(v.Cases_id__c))
                    v.Category__c = catMap.get(v.Cases_id__c);
                if(subCatMap.containsKey(v.Cases_id__c))
                    v.Sub_Category__c = subCatMap.get(v.Cases_id__c);
                if(vocSourMap.containsKey(v.Cases_id__c))
                    //v.Source__c = vocSourMap.get(v.Cases_id__c);    
                vocToUdate.add(v);  
            }
        }
        if(vocToUdate.size() > 0)
        {
            try 
            {
                
                upsert vocToUdate;
                VOCUtil.aiuCreateCaseVOCProcessed = true;
            }
            catch (Exception Ex)
            {
                system.debug('Exception:::'+ Ex);
            }
        }
    }
}