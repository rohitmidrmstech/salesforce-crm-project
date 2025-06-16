public class CustomerOnboardingController {
    /*This method is to get a new instance of account object*/
    @AuraEnabled    
    public static Account getAccount(){ 
        Account newRec= new Account();
        return newRec;
    }
    /*This method is to search for the accounts for the given criteria on the search form*/
    @AuraEnabled    
    public static List<Account> searchAccountsData(String prospectData){ 
        List<Account> searchResults= new List<Account>();                
        String accountNo;
        String businessname;
        String street;
        String city;
        String state;
        String zip;
        String SalesOrg; 
        Account currentProspect= (Account) JSON.deserialize(prospectData, Account.class);
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Id recTypeIdShipTo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship-To').getRecordTypeId();
        Id recTypeIdSoldTo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        Id recTypeIdPayer = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payer').getRecordTypeId();
        
        if(currentProspect!=null){            
            accountNo = currentProspect.SAP_ACCOUNT__c;
            businessname=currentProspect.name;
            street=currentProspect.ShippingStreet;
            city=currentProspect.ShippingCity;
            state=currentProspect.ShippingState;
            zip=currentProspect.ShippingPostalCode;
            SalesOrg=currentProspect.LOB__c;
            if(businessname != ''  && businessname != null)
                businessname = '\'%'+businessname+'%\'';
            string shipTo = '3-Ship To';
            //string query = 'Select Id,Name,SAP_ACCOUNT__c,RecordType.Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,Type,Site,Status_Code_BPCS__c,LOB__c from Account WHERE RecordTypeId = \'' + string.valueOf(recordTypeId) + '\' AND  Hierarchy_Level_BPCS__c =\'' + shipTo + '\'';
            //string query = 'Select Id,Name,SAP_ACCOUNT__c,RecordType.Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,Type,Site,Status__c,LOB__c from Account WHERE (RecordTypeId = \'' + string.valueOf(recordTypeId) + '\' OR RecordTypeId = \'' + string.valueOf(recTypeIdShipTo) + '\' OR RecordTypeId = \'' + string.valueOf(recTypeIdSoldTo) + '\' OR RecordTypeId = \'' + string.valueOf(recTypeIdPayer) + '\') AND  Hierarchy_Level_BPCS__c =\'' + shipTo + '\'';
            string query = 'Select Id,Name,SAP_ACCOUNT__c,RecordType.Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,Type,Site,Status__c,LOB__c,Status_Flag__c from Account WHERE (RecordTypeId = \'' + string.valueOf(recordTypeId) + '\' OR RecordTypeId = \'' + string.valueOf(recTypeIdShipTo) + '\' OR RecordTypeId = \'' + string.valueOf(recTypeIdSoldTo) + '\' OR RecordTypeId = \'' + string.valueOf(recTypeIdPayer) + '\')';
            string condition = '';
            string strb = '\'%b%\'';
            string stro = '\'%o%\'';
            string str = '\'%-%\'';
            query = query + ' AND (NOT SAP_ACCOUNT__c like ' + strb + ')';
              query = query + ' AND (NOT SAP_ACCOUNT__c like ' + stro+ ')';
              query = query + ' AND (NOT SAP_ACCOUNT__c like ' + str+ ')';
           
            if(accountNo != '' && accountNo != null){
                accountNo = accountNo.trim();
                accountNo = '\'%'+accountNo+'%\'';                  
                query = query + ' AND SAP_ACCOUNT__c like ' + accountNo;
            }
            else{               
                if(businessname != '' && businessname != null){
                    // condition = (condition == '' ? (condition + 'WHERE Name like ' + businessname) : (condition + ' AND Name like ' + businessname));
                    condition = condition + ' AND Name like ' + businessname;
                }
                if(street != '' && street != null){                                       
                    condition = condition + ' AND ShippingStreet like \'%' + street + '%\'';
                }
                if(city != '' && city != null){  
                    city = city.trim();
                    condition = condition + ' AND ShippingCity = \'' + city + '\'';
                }
                if(state != '' && state != null){                                        
                    condition = condition + ' AND ShippingState = \'' + state + '\'';
                }
                if(zip != '' && zip != null){                                        
                    condition = condition + ' AND ShippingPostalCode like \'' + zip + '%\'';
                }
                if(SalesOrg != '' && SalesOrg != null){
                    condition = condition +  'AND LOB__c like \'' + SalesOrg + '%\'';
                }                
            }            
            query = query + condition;  
            system.debug('query==>' + query);
            searchResults = Database.query(query);
            for(Account act : searchResults){
               // act.Site = URL.getSalesforceBaseUrl().toExternalForm() + '/' + act.id;  
				  act.Site = URL.getOrgDomainUrl().toExternalForm() + '/' + act.id;            
            }          
        }
        return searchResults;        
    } 
    
    
    /*This method is to get the customer master requests of the logged in user*/
    @AuraEnabled    
    public static List<Account> searchAccountsRequests(){ 
        List<Account> searchResults= new List<Account>();                                           
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        string query = 'Select Id,Name,SAP_ACCOUNT__c,RecordType.Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Phone,' + 
            'No_of_deliveries_Accepted_per_day__c,BrokerID__c,Delivery_Instructions_1__c,Cont_setup_with_SAP_already_existing__c,' + 
            'Will_Customer_Use_EDI__c,Solar__c,Job_Site__c,Price_Sheet__c,Delete_all_notes__c,Type,Site,Status__c,Residential__c,GCP_Residential__c,Commercial__c,Be_Eligible__c,BE_Limited_Product__c,' + 
            'LOB__c,Freight_Type__c,Order_Type__c, Last_4_digits_could_not_be_found_on_USPS__c, Customer_Origin__c, Structus_Price_Code__c, AEB_Check_Completed__c, Commercial_Price_Zone__c from Account WHERE  Hierarchy_Level_BPCS__c = \'3-Ship To\' AND RecordTypeId = \'' + string.valueOf(recordTypeId) + '\'';
        
        
        
        
        //   string condition = '';
        //   if(string.isNotBlank(status)){                
        //       condition = condition + ' AND Status_Code_BPCS__c = \'' + status + '\'';                
        //   }                
        // query = query + condition;           
        system.debug('Query==>' + query);
        searchResults = Database.query(query);
        for(Account act : searchResults){
           // act.Site = URL.getSalesforceBaseUrl().toExternalForm() + '/' + act.id; 
            act.Site = URL.getOrgDomainUrl().toExternalForm() + '/' + act.id;
        }                  
        system.debug('searchResults==>' + searchResults);
        return searchResults;        
    }
    /*This method is to get the customer master requests of the logged in user*/
    @AuraEnabled    
    public static List<Case> searchCustomerRequests(){ 
        List<Case> searchResults= new List<Case>();                                           
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        
        /*
        string query = 'Select Id, ReportedPersonPhNo__c,CaseNumber,Type,Status, RecordType.Name,AccountId,Account.Name,Account.SAP_ACCOUNT__c,Account.RecordType.Name,Account.ShippingStreet,Change_Info_Account__c,' +
            'Account.ShippingCity,Account.ShippingState,Account.ShippingPostalCode,Account.ShippingCountry, Account.Site,Account.Type,Account.Status_Code_BPCS__c,Account.LOB__c ' +
            ' from Case WHERE CreatedById = \'' + userInfo.getUserId() + '\' AND RecordTypeId = \'' + string.valueOf(recordTypeId) + '\' ORDER BY CreatedDate DESC';
        */
        
        string query = 'Select Id, ReportedPersonPhNo__c,CaseNumber,Type,Status, RecordType.Name,AccountId,Account.Name,Account.SAP_ACCOUNT__c,Account.RecordType.Name,Account.ShippingStreet,Change_Info_Account__c,' +
            'Account.ShippingCity,Account.ShippingState,Account.ShippingPostalCode,Account.ShippingCountry, Account.Site,Account.Type,Account.Status__c,Account.LOB__c ' +
            ' from Case WHERE (CreatedById = \'' + userInfo.getUserId() + '\' OR OwnerId = \'' + userInfo.getUserId() + '\' OR Sales_Rep__c = \'' + userInfo.getUserId() + '\') AND RecordTypeId = \'' + string.valueOf(recordTypeId) + '\' ORDER BY CreatedDate DESC';        
                
        system.debug('Query==>' + query);
        searchResults = Database.query(query);
        for(Case objCs : searchResults){
            if(objCs.AccountId != null)
               // objCs.Account.Site = URL.getSalesforceBaseUrl().toExternalForm() + '/' + objCs.Account.Id;   
                objCs.Account.Site = URL.getOrgDomainUrl().toExternalForm() + '/' + objCs.Account.Id;
              // objCs.ReportedPersonPhNo__c = URL.getSalesforceBaseUrl().toExternalForm() + '/' + objCs.Id;
				objCs.ReportedPersonPhNo__c = URL.getOrgDomainUrl().toExternalForm() + '/' + objCs.Id; 
        }                  
        system.debug('searchResults==>' + searchResults.size());
        return searchResults;        
    }
    /*This method is to get the Account details*/
    @AuraEnabled
    public static Account getAccountDetails(Id accountId){
        string query = 'Select Id,Name,SAP_ACCOUNT__c,RecordType.Name,ShippingStreet,ShippingCity,ShippingState,ShippingPostalCode,ShippingCountry,Phone,' + 
            'No_of_deliveries_Accepted_per_day__c,BrokerID__c,Delivery_Instructions_1__c,Cont_setup_with_SAP_already_existing__c,Be_Eligible__c,' + 
            'Will_Customer_Use_EDI__c,Solar__c,Job_Site__c,Price_Sheet__c,Delete_all_notes__c,Type,Site,Status__c,Sales_Group__c,Residential__c,GCP_Residential__c,Commercial__c,' + 
            'Order_For__c, Order_For__r.Name, Order_For__r.ShippingCity, Order_For__r.SAP_ACCOUNT__c,Price_List_BE_Full_Product_Line__c,' +
            'Default_Plant__c, Default_Plant__r.Name, Default_Plant__r.Warehouse_Description__c,BE_Limited_Product__c,' +
            'EDPAR__c, Delete_all_notes_and_add_notes__c, Keep_existing_notes_and_add_notes__c,Territory_Manager__r.Name,Territory_Manager__r.Role__c,Territory_Manager__r.Email,' +
            'LOB__c,Z2_Commercial__c,Z1_Residential__c,Freight_Type__c,Z3_Solar__c,Order_Type__c, Last_4_digits_could_not_be_found_on_USPS__c, Sales_office__c,Sales_District__c,' +
            'Z6_GCP_Res_Territory__c,Z5_BE_Territory__c,Customer_Origin__c, Structus_Price_Code__c, AEB_Check_Completed__c, Commercial_Price_Zone__c from ' +
            'Account WHERE Id = \'' + string.valueOf(accountId) + '\'';
        system.debug('query==>'+ query);
        Account actDetails = Database.query(query);
        system.debug('actDetails==>'+ actDetails);
        //uppercaseText(actDetails);
        return actDetails;
    }
    /*This method is to get the case/request details*/
    @AuraEnabled
    public static Case getCaseDetails(Id caseId){
        string query = 'Select Id,CaseNumber,Description,Origin,Sales_Rep__c, AccountId,Account.Name,Account.SAP_ACCOUNT__c,Account.Phone, Reason, Comments__c, Status,PartnerTo_UnPartner_from_Sold_To_Account__c,Change_Info_Account__c,PartnerTo_UnPartner_from_Sold_To_Account__r.Name,PartnerTo_UnPartner_from_Sold_To_Account__r.SAP_ACCOUNT__c,PartnerTo_UnPartner_from_Sold_To_Account__r.ShippingCity,Type, CreatedBy.Profile.Name,CreatedById,CreatedDate,Account.Commercial_Price_Zone__c from Case WHERE Id = \'' + string.valueOf(caseId) + '\'';        
        Case  csDetails = Database.query(query);    
        system.debug('csDetails==>' + csDetails);
        return csDetails;
    }
    /*This method is to create the New Ship-To Account request/Change ship-To inofrmation*/
    @AuraEnabled
    public static string createAccount(String accountDetails,Id csId,Boolean isSubmitted, Id acctId, String region, boolean isActSave, boolean isCSRSubmitted){
        Account newAccount= (Account) JSON.deserialize(accountDetails, Account.class);
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        string strCaseId;
        if(newAccount!=null){
            newAccount.RecordTypeId = recordTypeId;             
            newAccount.Hierarchy_Level_BPCS__c = '3-Ship To';
            if(isSubmitted){
                newAccount.Status__c = 'Submitted';    
            }
            else{
                newAccount.Status__c = 'Saved';
            }              
            uppercaseText(newAccount);
            upsert newAccount;      
            System.debug('>>>>>>>>>>'+newAccount.Id);
            if(!isActSave){
                if(acctId == null){
                  strCaseId =  createCase(newAccount.Id, csId,isSubmitted,newAccount.Request_Type__c,null,null,null,null, region);
                }else{
                  strCaseId =  createCase(acctId, csId,isSubmitted,newAccount.Request_Type__c,null,null,null,newAccount.Id, region);                  
                }
            }    
            if(csId != null){
                strCaseId =csId;
            }
                
            if(isCSRSubmitted != null && isCSRSubmitted && csId != null){                   
                submitApprovalRequest(csId);
            }            
            
        }  
        return strCaseId;
    }
    /*This method is to Activate/De-Activate the accounts*/
    @AuraEnabled
    public static Id  createActivateorDeactivateAccountRequest(Id actId,Id csId, Boolean isSubmitted, string requestType, string reason, string reasonText){
        system.debug('csId==>' + csId);
       return createCase(actId, csId,isSubmitted, requestType,reason,reasonText,null,null, null);
    }
    /*This method is to partner shipto account with Sold to account*/
    @AuraEnabled
    public static Id createPartnerShipToRequest(Id actId,Id csId, Boolean isSubmitted, string requestType, Id partnerTo){
        return createCase(actId, csId,isSubmitted, requestType,null,null,partnerTo,null, null);
    }
    /*This method is to unpartner shipto account from Sold to account*/
    @AuraEnabled
    public static Id createUnPartnerfromSoldToRequest(Id actId, Id csId,Boolean isSubmitted, string requestType, Id unpartnerFrom){
        return createCase(actId, csId,isSubmitted, requestType,null,null,unpartnerFrom,null, null);
    }
    /*This method is to create a case for Inquiry requests*/
    @AuraEnabled
    public static void createInquiryRequest(string requestType, string inquiryText){
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        Case newCase = new Case();           
        newCase.RecordTypeId = recordTypeId;
        newCase.Status = 'New';                                
        newCase.Subject = 'REQUEST TYPE : ' + requestType.toUpperCase();
        newCase.Description = inquiryText;
        newCase.Origin = 'Customer Request';
        newCase.Type = requestType;
        newCase.isSubmitted__c = true;
        insert newCase;
    }
    /*This method is to create/update the case for all types of customer master requests*/
    private static Id createCase(Id actId,Id csId, Boolean isSubmitted, string requestType, string reason, string reasonText, Id partner_unpartnerAccount, Id changeAccountId, String region){        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        User usr = [SELECT Id, Name, Profile.Name, Role__c FROM User Where Id =: userInfo.getUserId()];
        Account act;
        string requestTypeSubject;
        if(requestType == 'Change Ship-To Account Information Request'){
             act = [SELECT Id, name, Customer_Origin__c, Territory_Manager__c FROM Account Where Id =: changeAccountId];
        }else{
             act = [SELECT Id, name, Customer_Origin__c, Territory_Manager__c FROM Account Where Id =: actId];
        }
        if(String.isBlank(region)){
            region = 'Customer Request';
        }
       system.debug('region==>' + region);
        if(csId != null){
            List<Case> lst_Cases = [SELECT Id, AccountId, RecordTypeId, Status,Type FROM Case Where Id =: csId];   
             lst_Cases[0].isSubmitted__c = isSubmitted;
           
                lst_Cases[0].Origin = region; 
                lst_Cases[0].Reason = reason;
                lst_Cases[0].Comments__c = reasonText;
                lst_Cases[0].PartnerTo_UnPartner_from_Sold_To_Account__c= partner_unpartnerAccount;
                lst_Cases[0].Change_Info_Account__c =changeAccountId;
                lst_Cases[0].Sales_Rep__c = act.Territory_Manager__c;
                system.debug('lst_Cases==>' + lst_Cases);
                update lst_Cases[0];
          //  }            
        }else{
             if(requestType != 'New Ship-To Account Request'){
                 Account actToChnage = [SELECT Id, SAP_ACCOUNT__c FROM Account Where Id =: actId];
                  if(requestType == 'Change Ship-To Account Information Request'){
                      requestTypeSubject = 'CHANGE SHIP-TO (SAP Account # ' + actToChnage.SAP_ACCOUNT__c + ')';
                  }else{
                      requestTypeSubject = requestType + ' (SAP Account # ' + actToChnage.SAP_ACCOUNT__c + ')';     
                  }
                 
             }            
            else{
                 requestTypeSubject = 'NEW SHIP-TO (' + act.Name + ')';
             }                
            requestTypeSubject = requestTypeSubject.toUpperCase();
            Case newCase = new Case();
            newCase.AccountId = actId;
            newCase.RecordTypeId = recordTypeId;
            newCase.isSubmitted__c = isSubmitted;            
            newCase.Status = 'New';
            newCase.Origin = region;            
            newCase.Reason = reason;
            newCase.Comments__c = reasonText;
            newCase.PartnerTo_UnPartner_from_Sold_To_Account__c= partner_unpartnerAccount;
            newCase.Change_Info_Account__c =changeAccountId;
            newCase.Subject = 'REQUEST TYPE : ' + requestTypeSubject;
            newCase.Description = 'REQUEST TYPE : ' + requestTypeSubject;
            newCase.Type = requestType;
            newCase.Sales_Rep__c = act.Territory_Manager__c;
            system.debug('newCase==>' + newCase);
            insert newCase;   
            csId = newCase.Id;
        } 
        return csId;
    }
    /* This method is to re-open the closed Customer Master requests*/
    @AuraEnabled
    public static void reopenCase(Id caseId){
        Case reopenCase = [SELECT Id, Status FROM Case Where Id=:caseId];
        reopenCase.Status = 'Re-Opened';
        update reopenCase;
    }
    /* This method is to check, is there any other pending request is there on the same account*/
    @AuraEnabled
    public static List<case> checkforInprogressRequestsOnAccount(Id actId){
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        List<Case> lst_Cases = [SELECT ID FROM Case Where RecordTypeId =:recordTypeId AND AccountId =:actId AND Status != 'Closed'];     
        return lst_Cases;
    }
    /* This method is to get the logged in user profile name*/
    @AuraEnabled
    public static User getLoggedinUserDetails(){
        return [SELECT Id, Name, Profile.Name FROM User WHERE Id=:userInfo.getUserId()];
    }
    @AuraEnabled
    public static User getTMUserDetails(String email){
        try{
            return [SELECT Id, Name, Role__c FROM User WHERE email=:email AND isActive = true AND Role__c='TM'];    
        }
        catch(Exception ex){
            return null;
        }
        
    }
    /* This method is to change all the text/picklist field values to upper case*/
    private static sObject uppercaseText(Account sObj){            
        Schema.DescribeSObjectResult acctDesc= Account.sObjectType.getDescribe();        
        for(string apiName : acctDesc.fields.getMap().keySet()){               
            try{     
                Schema.DisplayType fielddataType = acctDesc.fields.getMap().get(apiName).getDescribe().getType();
                if(fielddataType == Schema.DisplayType.TextArea || fielddataType == Schema.DisplayType.String 
                   || fielddataType == Schema.DisplayType.PICKLIST) {                          
                       string val = (String)sObj.get(apiName);
                       sObj.put(apiName, val.toUpperCase()); 
                   }              
            }
            catch(Exception ex){
                 
            }                           
        }
        return sobj;
    }
      private static void submitApprovalRequest(Id caseId) {  
        User loggedInUser = getLoggedinUserDetails();
        System.Debug('The User:' + loggedInUser);
        // Create an approval request for the account
        Approval.ProcessSubmitRequest req1 = 
            new Approval.ProcessSubmitRequest();
       // req1.setComments('Submitting request for approval.');
        req1.setObjectId(caseId);      
        // Submit on behalf of a specific submitter
        req1.setSubmitterId(UserInfo.getUserId()); 
           
        req1.setSkipEntryCriteria(false);
        
        // Submit the approval request for the customer onboarding request
        Approval.ProcessResult result = Approval.process(req1);                
    }   
    
     @AuraEnabled
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }

    private static final String getAlphaChars = '' +
        'ABCDEFGHIJKLMNOPQRSTUVWXYZ' +
        'abcdefghijklmnopqrstuvwxyz' +
        '0123456789+/';
 
    @AuraEnabled
    public static List<customPicklistWrapper> customDependablePicklist(String strObjectName, string strparentField, string strchildField) {
        Map<String,List<String>> pickListMap = NEW Map<String,List<String>>();
        Map<String,List<String>> pickListMapSD = NEW Map<String,List<String>>();
        Map<String,List<String>> pickListMapSG = NEW Map<String,List<String>>();
        Map<String,List<String>> pickListMapPL = NEW Map<String,List<String>>();
        Map<String,List<String>> pickListMapz1 = NEW Map<String,List<String>>();
        Map<String,List<String>> pickListMapz2 = NEW Map<String,List<String>>();
        Map<String,List<String>> pickListMapz3 = NEW Map<String,List<String>>();
        Map<String,List<String>> pickListMapz5 = NEW Map<String,List<String>>();
        Map<String,List<String>> pickListMapz6 = NEW Map<String,List<String>>();
        
        List<customPicklistWrapper> pwLst = NEW List<customPicklistWrapper>();
        customPicklistWrapper pw = NEW customPicklistWrapper();
        pw.pickListMap = pickListMap;
        String[] childFieldsArray = strchildField.split(',');
        /*IF (Schema.getGlobalDescribe().get(strObjectName) ==NULL || String.isBlank(strparentField) || String.isBlank(strChildField)){
RETURN pw;
}
*/
        Schema.sObjectType objType = Schema.getGlobalDescribe().get(strObjectName).newSObject().getSObjectType();
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        
        /*IF (!objFieldMap.containsKey(strparentField) || !objFieldMap.containsKey(strchildField)){
RETURN pw;     
}*/
        
        List<customPicklistEntryWrapper> depEntriesList = new List<customPicklistEntryWrapper>();
        List<String> controllingValues = NEW List<String>();
        FOR (Schema.PicklistEntry ple : objFieldMap.get(strparentField).getDescribe().getPicklistValues()) {
            Integer val = Integer.valueOf(ple.getLabel());
            if( val==1501 || val==1102)
            {
                pickListMap.put(ple.getLabel(), NEW List<String>());
                pickListMapSD.put(ple.getLabel(), NEW List<String>());
                pickListMapSG.put(ple.getLabel(), NEW List<String>());
                pickListMapPL.put(ple.getLabel(), NEW List<String>());
                pickListMapz1.put(ple.getLabel(), NEW List<String>());
                pickListMapz2.put(ple.getLabel(), NEW List<String>());
                pickListMapz3.put(ple.getLabel(), NEW List<String>());
         		pickListMapz5.put(ple.getLabel(), NEW List<String>());
                pickListMapz6.put(ple.getLabel(), NEW List<String>());
                
                controllingValues.add(ple.getLabel());
            }
        }
        for(String str :childFieldsArray){
            depEntriesList = (List<customPicklistEntryWrapper>)JSON.deserialize(JSON.serialize(objFieldMap.get(str).getDescribe().getPicklistValues()), List<customPicklistEntryWrapper>.class);
            FOR (customPicklistEntryWrapper plew : depEntriesList) {
                String validForBits = alphaBaseToBits(plew.validFor);
                //FOR (INTEGER i = 0; i < validForBits.length(); i++) {
                if(str =='Sales_district__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMapSD.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    if(pickListMapSD.size()>0){
                        pw.pickListMapSD =pickListMapSD;
                    }
                    
                }
                if(str =='Sales_Group__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMapSG.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    if(pickListMapSG.size()>0){
                        pw.pickListMapSG =pickListMapSG;
                    }
                    
                }
                else if(str =='Z1_Residential__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMapz1.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    if(pickListMapSG.size()>0){
                        pw.pickListMapz1 =pickListMapz1;
                    }
                    
                }
                else if(str =='Z2_Commercial__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMapz2.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    if(pickListMapz2.size()>0){
                        pw.pickListMapz2 =pickListMapz2;
                    }
                    
                }
                else if(str =='Z3_Solar__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMapz3.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    if(pickListMapz2.size()>0){
                        pw.pickListMapz3 =pickListMapz3;
                    }
                    
                }
                else if(str =='Z5_BE_Territory__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMapz5.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    if(pickListMapz5.size()>0){
                        pw.pickListMapz5 =pickListMapz5;
                    }
                    
                }
                else if(str =='Z6_GCP_Res_Territory__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMapz6.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    if(pickListMapz6.size()>0){
                        pw.pickListMapz6 =pickListMapz6;
                    }
                    
                }
                else if(str =='Price_List_BE_Full_Product_Line__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMapPL.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    if(pickListMapPL.size()>0){
                        pw.pickListMapPL =pickListMapPL;
                    }
                }
                else if(str == 'Commercial_Price_Zone__c'){
                    FOR (INTEGER i = 0; i < controllingValues.size(); i++) {
                        String bit = validForBits.mid(i, 1);
                        IF (bit == '1') {
                            pickListMap.get(controllingValues.get(i)).add(plew.label);
                        }
                    }
                    pw.pickListMap = pickListMap;
                    //pw.parentFieldLabel = objFieldMap.get(strparentField).getDescribe().getLabel();
                    //pw.childFieldLabel = objFieldMap.get(str).getDescribe().getLabel();
                }
            }
        }
        pwLst.add(pw);
        return pwLst;
        //RETURN pw;
    }
 
 
    public static String decimalToBinary(INTEGER val) {
        String bits = '';
        while (val > 0) {
            INTEGER remainder = Math.mod(val, 2);
            val = INTEGER.valueOf(Math.floor(val / 2));
            bits = String.valueOf(remainder) + bits;
        }
        RETURN bits;
    }
 
    public static String alphaBaseToBits(String validFor) {
        IF (String.isEmpty(validFor)) RETURN '';
 
        String validForBits = '';
 
        FOR (INTEGER i = 0; i < validFor.length(); i++) {
            String thisChar = validFor.mid(i, 1);
            INTEGER val = getAlphaChars.indexOf(thisChar);
            String bits = decimalToBinary(val).leftPad(6, '0');
            validForBits += bits;
        }
 
        RETURN validForBits;
    }
 
    public class customPicklistWrapper{
    	@AuraEnabled
        public Map<String, List<String>> pickListMap;
        @AuraEnabled
        public Map<String, List<String>> pickListMapSD;
        @AuraEnabled
        public Map<String, List<String>> pickListMapSG;
        @AuraEnabled
        public Map<String, List<String>> pickListMapz1;
        @AuraEnabled
        public Map<String, List<String>> pickListMapz2;
        @AuraEnabled
        public Map<String, List<String>> pickListMapz3;
        @AuraEnabled
        public Map<String, List<String>> pickListMapz5;
        @AuraEnabled
        public Map<String, List<String>> pickListMapz6;
        @AuraEnabled
        public Map<String, List<String>> pickListMapPL;
        
        /*@AuraEnabled
        public String parentFieldLabel;
        @AuraEnabled
        public String childFieldLabel; */
    }
 
    public class customPicklistEntryWrapper{
        public String active;
        public String defaultValue;
        public String label;
        public String VALUE;
        public String validFor;
 
    }
}