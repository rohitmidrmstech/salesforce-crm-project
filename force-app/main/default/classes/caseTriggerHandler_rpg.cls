/**
* @author: Mukesh Bhardwaj
* @date: 5/9/2013
* @description: Handler class for CaseTrigger. Used to control all Case trigger events.
* @history:
    1. 05/09/2013: Mukesh Bhardwaj: Added beforeUpdateAction1 method
*/
    
public with sharing class caseTriggerHandler_rpg {
    
    public void updateBusinessHours(List<Case> caseListNew){
        // Query for the default business hours
        BusinessHours bh = [SELECT Id FROM BusinessHours WHERE IsDefault=true];
        
        if(bh != null)
        {
            for (Case c : caseListNew)
            {
                c.BusinessHoursId = bh.Id;
            }
        }
    }
    
    //Before Insert/Update action : update RMATo
    public void updateRelatedUsersForRMATo(List<Case> caseListNew, Map<Id,Case> oldMap)
    {
		Map<Id,Plants__c> RMAToPlantMap = new Map<Id,Plants__c>(); 
        Set<Id> plantsIdSet = new Set<Id>();
        List<Case> caseListToIterate = new List<Case>();
        for(Case newCase : caseListNew){
            if(newCase.RMA_To__c != NULL && newCase.RMA_To__c != oldMap.get(newCase.Id).RMA_To__c){
                plantsIdSet.add(newCase.RMA_To__c);
                caseListToIterate.add(newCase);
            }
    	}
        
        for(Plants__c rmaPlant : [Select Id, Logistics_Coordinator__c, Dispatch_User__c, Dispatch_Email__c from Plants__c where Id In: plantsIdSet]){
            RMAToPlantMap.put(rmaPlant.Id, rmaPlant);
        }
        
        for(Case newCase : caseListToIterate){
            newCase.Warehouse_User__c = RMAToPlantMap.get(newCase.RMA_To__c).Logistics_Coordinator__c;
            newCase.Dispatch_User__c = RMAToPlantMap.get(newCase.RMA_To__c).Dispatch_User__c;
            newCase.Dispatch_Email__c = RMAToPlantMap.get(newCase.RMA_To__c).Dispatch_Email__c;
        }
    }
    
    //Before Insert/Update action : update VP
    public void updateVP(List<Case> caseListNew, Map<Id,Case> oldMap)
    {
        Map<String, User> userMap = new Map<String, User>();
        for(Case newCase : caseListNew)
        {
            if(String.isNotBlank(newCase.RSM__c))
            {
                userMap.put(newCase.RSM__c,null);
            }
        }
        for(User usersData :[Select id,ManagerId from user where id IN : userMap.keySet()])
        {
            userMap.put(usersData.id,usersData);
        }
        if(oldMap == null) //for Insert
        {
            for(case c : caseListNew)
            {
            if(userMap.containsKey(c.RSM__c) && userMap.get(c.RSM__C) != null) 
            	{
                
            	if(String.isNotBlank(userMap.get(c.RSM__c).ManagerId) && c.Product_Category__c == 'Residential BE' && (c.Sales_Org__c == '1501' || c.Sales_Org__c =='1102'))
                	{
                            c.VP__c = userMap.get(c.RSM__c).ManagerId;
                    }
                    
        		}
            }
        }
        else //for Update
        {
            for(Case c: caseListNew)
            {
                if(c.RSM__c != null && c.RSM__c != oldMap.get(c.Id).RSM__c)
                {
                    if(userMap.containsKey(c.RSM__c) && userMap.get(c.RSM__c) != null) 
                    {
                        if(String.isNotBlank(userMap.get(c.RSM__c).ManagerId) && c.Product_Category__c == 'Residential BE' && (c.Sales_Org__c == '1501' || c.Sales_Org__c =='1102'))
                        {
                            c.VP__c = userMap.get(c.RSM__c).ManagerId;
                        }
                    }
                } 
                if(c.RSM__c == null && oldMap.get(c.Id).RSM__c != null)
                {
                   c.VP__c = null; 
                }
        	}
        }
    }
    
    //Before insert Action 2: Update TM and Warehouse User
    @Testvisible
    public void updateTM(List<Case> caseListNew, Map<Id,Case> oldMap){
        Map<String, Order> orderMap = new Map<String, Order>();
        Set<Id> caseIdSet = new Set<Id>();//created by Gaurav
        
        Set<Id> accountIdSet = new Set<Id>();
        Map<Id,Account> idToAccountMap = new Map<Id,Account>();
        Set<Id> caseRecordTypeIds = new Set<Id>();
        //Id cbiRMACaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CBI RMA Case').getRecordTypeId();
        
        for(Case record : caseListNew){
            
            caseRecordTypeIds.add(record.RecordTypeId);
            if(String.isNotBlank(record.Order__c)){
                orderMap.put(record.Order__c, null);
            }
        }
        
        Map<Id, String> caseRecordTypeDetailsMap = new Map<Id, String>();
        for(RecordType recType : [select Id, Name from RecordType where Id IN:caseRecordTypeIds]) {
            caseRecordTypeDetailsMap.put(recType.Id, recType.Name);
        }
        
        for(Order record : [SELECT Id, TM__c, Manufacturing_Plant__r.Dispatch_Email__c,Manufacturing_Plant__r.Dispatch_User__c, Region_rpg__r.Pricing_Coordinator__c, 
                            Region_rpg__r.Regional_Sales_Manager__c, Manufacturing_Plant__r.Logistics_Coordinator__c/*, 
                            Ship_To__r.Res_TM__c, Ship_To__r.Com_TM__c*/ FROM Order WHERE Id IN : orderMap.keySet()]){
            orderMap.put(record.Id, record);
        }
         //List<CasePricingCordinator__mdt> userConfigList= [SELECT Id, Label, UserName__c FROM CasePricingCordinator__mdt];//use getAll function instead of SOQL    
        Map<String, CasePricingCordinator__mdt> salesOrgANDRecordTypeDetailsMap = CasePricingCordinator__mdt.getAll();
        
        Map<String, String> RecordTypeNameDetailsMap = new Map<String, String>();
        Map<String,String> userConfigMap = new Map<String,String>();
        Map<String,Id> salesOrgUserIdMap = new Map<String,Id>();
        List<String> userNameList = new List<String>();
        
        for(CasePricingCordinator__mdt rec : salesOrgANDRecordTypeDetailsMap.values()) {
            userConfigMap.put(rec.UserName__c,rec.label);
            RecordTypeNameDetailsMap.put(rec.label, rec.Case_RecordType_Names__c);
            userNameList.add(rec.UserName__c);
        }
        
        for(user ur : [Select id, Name from user where name in :userNameList]){
            if(userConfigMap.containsKey(ur.Name)){
                salesOrgUserIdMap.put(userConfigMap.get(ur.Name), ur.Id); 
            }
            
        }
        
        if(oldMap == null) //in case of insert
        {
            Set<Id> accIdSet = new Set<Id>();
            Map<Id, Id> caseTMMap = new Map<Id,Id>();
            for(Case c : caseListNew)
            {
                /*GI-97 : Start*/
                 if(!caseRecordTypeDetailsMap.isEmpty() && !RecordTypeNameDetailsMap.isEmpty() && caseRecordTypeDetailsMap.containsKey(c.RecordTypeId)) {
                    String recordTypeName = caseRecordTypeDetailsMap.get(c.RecordTypeId);
                     
                    if(recordTypeName == RecordTypeNameDetailsMap.get(recordTypeName)) {
                        if(c.Sales_Org__c == '1111') 
                            c.Pricing_Coordinator__c = salesOrgUserIdMap.get(c.Sales_Org__c); 
                        else if(c.Sales_Org__c == '1021') 
                            c.Pricing_Coordinator__c = salesOrgUserIdMap.get(c.Sales_Org__c);
                        else 
                            c.Pricing_Coordinator__c = NULL;
                    } 
                }
                /*GI-97 : End*/
               
                /*if(c.TM_Calc__c != null && c.TM_Calc__c != '')
                {
                    System.debug('c.TM_Calc__c:::'+c.TM_Calc__c);
                    c.TM__c = c.TM_Calc__c;
                }
                if(c.Warehouse_User_Calc__c != null && c.Warehouse_User_Calc__c != '')
                    c.Warehouse_User__c = c.Warehouse_User_Calc__c;
                if(c.Regional_Manager_Calc__c != null && c.Regional_Manager_Calc__c != '')
                    c.RSM__c = c.Regional_Manager_Calc__c;
                if(c.Pricing_Coordinator_Calc__c != null && c.Pricing_Coordinator_Calc__c != '')
                    c.Pricing_Coordinator__c = c.Pricing_Coordinator_Calc__c;
                if(c.Dispatch_Email_Calc__c != null && c.Dispatch_Email_Calc__c != '')
                    c.Dispatch_Email__c = c.Dispatch_Email_Calc__c;*/
                    
                
                if(orderMap.containsKey(c.Order__c) && orderMap.get(c.Order__c) != null) {
                    /*if(String.isBlank(orderMap.get(c.Order__c).Ship_To__r.Res_TM__c)){
                        c.TM__c = orderMap.get(c.Order__c).Ship_To__r.Com_TM__c;
                    }else{
                        c.TM__c = orderMap.get(c.Order__c).Ship_To__r.Res_TM__c;
                    }   */                 
                    
                    if(String.isNotBlank(orderMap.get(c.Order__c).Manufacturing_Plant__r.Logistics_Coordinator__c))
                        c.Warehouse_User__c = orderMap.get(c.Order__c).Manufacturing_Plant__r.Logistics_Coordinator__c;
                    if(String.isNotBlank(orderMap.get(c.Order__c).Region_rpg__r.Regional_Sales_Manager__c))
                        c.RSM__c = orderMap.get(c.Order__c).Region_rpg__r.Regional_Sales_Manager__c;
                    if(String.isNotBlank(orderMap.get(c.Order__c).Region_rpg__r.Pricing_Coordinator__c))
                        c.Pricing_Coordinator__c = orderMap.get(c.Order__c).Region_rpg__r.Pricing_Coordinator__c;
                    if(String.isNotBlank(orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_Email__c))
                        c.Dispatch_Email__c = orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_Email__c;
                    if(String.isNotBlank(orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_User__c))
                        c.Dispatch_User__c   = orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_User__c;
                    System.debug('Hello I am in 205 ::: '+orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_User__c);
                    /*if(String.isNotBlank(orderMap.get(c.Order__c).TM__c))
                            c.TM__c = orderMap.get(c.Order__c).TM__c;*/
                    if(String.isNotBlank(orderMap.get(c.Order__c).TM__c) && c.Product_Category__c == 'Roofing'){
                            c.TM__c = orderMap.get(c.Order__c).TM__c;
                    }
                    else if(c.Product_Category__c != 'Roofing'){
                        //caseIdSet.add(c.Id);
                        //accountIdSet.add(c.Sold_to_Name__c);
                        accountIdSet.add(c.AccountId);
                        System.debug('Hello Account details INSERT :: '+c.AccountId);
                    }
                }
            }
        }
        else  // in case of update
        {
            //Set<Id> caseIdSet = new Set<Id>();
            for(Case c: caseListNew)
            {
                /*GI-97 : Start*/
                if(!caseRecordTypeDetailsMap.isEmpty() && !RecordTypeNameDetailsMap.isEmpty() && caseRecordTypeDetailsMap.containsKey(c.RecordTypeId)) {
                    String recordTypeName = caseRecordTypeDetailsMap.get(c.RecordTypeId);
                    
                    if(recordTypeName == RecordTypeNameDetailsMap.get(recordTypeName)) {
                        if(c.Sales_Org__c == '1111') {
                            c.Pricing_Coordinator__c = salesOrgUserIdMap.get(c.Sales_Org__c); // Jennifer Herder
                            
                        }
                        else if(c.Sales_Org__c == '1021') {
                            c.Pricing_Coordinator__c = salesOrgUserIdMap.get(c.Sales_Org__c); // Jody Mischik
                             System.debug('Hello c.Pricing_Coordinator__c 1021 ::'+c.Pricing_Coordinator__c);
                        }
                        else 
                            c.Pricing_Coordinator__c = NULL;
                    } 
                }
                /*GI-97 : End*/
                
                
                if(c.Order__c != null)
                {
                    /*if(c.TM_Calc__c != null && c.TM_Calc__c != '')
                    {
                        System.debug('c.TM_Calc__c:::'+c.TM_Calc__c);
                        c.TM__c = c.TM_Calc__c;
                    }
                    if(c.Warehouse_User_Calc__c != null && c.Warehouse_User_Calc__c != '')
                        c.Warehouse_User__c = c.Warehouse_User_Calc__c;
                    if(c.Regional_Manager_Calc__c != null && c.Regional_Manager_Calc__c != '')
                        c.RSM__c = c.Regional_Manager_Calc__c;
                    if(c.Pricing_Coordinator_Calc__c != null && c.Pricing_Coordinator_Calc__c != '')
                        c.Pricing_Coordinator__c = c.Pricing_Coordinator_Calc__c;
                    if(c.Dispatch_Email_Calc__c != null && c.Dispatch_Email_Calc__c != '')
                        c.Dispatch_Email__c = c.Dispatch_Email_Calc__c;*/
                        
                    if(orderMap.containsKey(c.Order__c) && orderMap.get(c.Order__c) != null) {
                        /*if(String.isBlank(orderMap.get(c.Order__c).Ship_To__r.Res_TM__c)){
                            c.TM__c = orderMap.get(c.Order__c).Ship_To__r.Com_TM__c;
                        }else{
                            c.TM__c = orderMap.get(c.Order__c).Ship_To__r.Res_TM__c;
                        }  */                  
                        
                        if(String.isNotBlank(orderMap.get(c.Order__c).Manufacturing_Plant__r.Logistics_Coordinator__c))
                            c.Warehouse_User__c = orderMap.get(c.Order__c).Manufacturing_Plant__r.Logistics_Coordinator__c;
                        if(String.isNotBlank(orderMap.get(c.Order__c).Region_rpg__r.Regional_Sales_Manager__c))
                            c.RSM__c = orderMap.get(c.Order__c).Region_rpg__r.Regional_Sales_Manager__c;
                        if(String.isNotBlank(orderMap.get(c.Order__c).Region_rpg__r.Pricing_Coordinator__c))
                            c.Pricing_Coordinator__c = orderMap.get(c.Order__c).Region_rpg__r.Pricing_Coordinator__c;
                        if(String.isNotBlank(orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_User__c))
                        	c.Dispatch_User__c   = orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_User__c;
                        System.debug('Hello I am in 255 ::: '+orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_User__c);
                        if(String.isNotBlank(orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_Email__c))
                            c.Dispatch_Email__c = orderMap.get(c.Order__c).Manufacturing_Plant__r.Dispatch_Email__c;
                        if(String.isNotBlank(orderMap.get(c.Order__c).TM__c) && c.Product_Category__c == 'Roofing'){
                            c.TM__c = orderMap.get(c.Order__c).TM__c;
                        }
                        else if(c.Product_Category__c != 'Roofing'){
                            //caseIdSet.add(c.Id);
                            //accountIdSet.add(c.Sold_to_Name__c);
                            accountIdSet.add(c.AccountId);
                            System.debug('Hello sold name UPDATE :: '+c.AccountId);
                        }   
                    }
                }
            }
        }
        
        if(accountIdSet != NULL && accountIdSet.size() > 0){
            System.debug('accountIdSet '+accountIdSet);
        	List<Account> accountList = [Select id, Z3_Partner__c, Finishing_Territory__c, Mechanical_Territory__c, Z5_Territory__c, Z6_Territory__c, Z6_Territory__r.Sales_Rep__c, Z5_Territory__r.Sales_Rep__c, Mechanical_Territory__r.Sales_Rep__c,Finishing_Territory__r.Sales_Rep__c, Z3_Partner__r.Sales_Rep__c
                                   from Account 
                                   where  Id in: accountIdSet];
            
            for(Account acc : accountList){
                idToAccountMap.put(acc.Id,acc);
            }
            
           /* Map<Id,Case> caseIdToCaseMap = new Map<Id,Case>();
            for(Case cse : caseList){
                caseIdToCaseMap.put(cse.Id,cse);
            }*/
            for(Case caseFromTrigger : caseListNew){
                
                //Case cs = caseIdToCaseMap.get(caseFromTrigger.Id);
                /*if(caseFromTrigger.Product_Category__c == 'Residential BE' && caseFromTrigger.Sold_to_Name__c != NULL &&  idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Z6_Territory__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Z6_Territory__r.Sales_Rep__c;
                    System.debug('Hello I am in Residential BE :: '+caseFromTrigger.TM__c);
                }else if(caseFromTrigger.Product_Category__c == 'Building Envelope' && caseFromTrigger.Sold_to_Name__c != NULL &&  idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Z5_Territory__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Z5_Territory__r.Sales_Rep__c;
                }else if(caseFromTrigger.Product_Category__c == 'Fireproofing' && caseFromTrigger.Sold_to_Name__c != NULL &&  idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Mechanical_Territory__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Mechanical_Territory__r.Sales_Rep__c;
                }else if(caseFromTrigger.Product_Category__c == 'DeNeef' && caseFromTrigger.Sold_to_Name__c != NULL &&  idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Finishing_Territory__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Finishing_Territory__r.Sales_Rep__c;
                }else if(caseFromTrigger.Product_Category__c == 'Infrastructure' && caseFromTrigger.Sold_to_Name__c != NULL &&  idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Z3_Partner__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.Sold_to_Name__c).Z3_Partner__r.Sales_Rep__c;
                }*/
                if(caseFromTrigger.Product_Category__c == 'Residential BE' && caseFromTrigger.AccountId != NULL &&  idToAccountMap.get(caseFromTrigger.AccountId).Z6_Territory__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.AccountId).Z6_Territory__r.Sales_Rep__c;
                    //System.debug('Hello I am in Residential BE :: '+caseFromTrigger.TM__c);
                }else if(caseFromTrigger.Product_Category__c == 'Building Envelope' && caseFromTrigger.AccountId != NULL &&  idToAccountMap.get(caseFromTrigger.AccountId).Z5_Territory__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.AccountId).Z5_Territory__r.Sales_Rep__c;
                }else if(caseFromTrigger.Product_Category__c == 'Fireproofing' && caseFromTrigger.AccountId != NULL &&  idToAccountMap.get(caseFromTrigger.AccountId).Mechanical_Territory__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.AccountId).Mechanical_Territory__r.Sales_Rep__c;
                }else if(caseFromTrigger.Product_Category__c == 'DeNeef' && caseFromTrigger.AccountId != NULL &&  idToAccountMap.get(caseFromTrigger.AccountId).Finishing_Territory__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.AccountId).Finishing_Territory__r.Sales_Rep__c;
                }else if(caseFromTrigger.Product_Category__c == 'Infrastructure' && caseFromTrigger.AccountId != NULL &&  idToAccountMap.get(caseFromTrigger.AccountId).Z3_Partner__c != NULL){
                    caseFromTrigger.TM__c = idToAccountMap.get(caseFromTrigger.AccountId).Z3_Partner__r.Sales_Rep__c;
                }
                 
            }
        }        
    }
    
    // method to apply assignment rules for portal cases
     public void portalCaseAssignment(List<Case> cases){
        List<case> portalCases = new List<case>();
         SET<Id> set_reportTypeIds = new SET<Id>();
         //for(RecordType portalRecortType : [SELECT Id,Name FROM RecordType WHERE SobjectType='Case' AND Name in ('Portal', 'Service Case')]){
         for(RecordType portalRecortType : [SELECT Id, Name FROM RecordType WHERE SobjectType='Case' AND Name ='Portal']){
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
}