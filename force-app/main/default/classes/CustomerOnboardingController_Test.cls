@isTest
public class CustomerOnboardingController_Test {
    @testSetup static void setupData() {
        // Create common test accounts
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();       
        List<Account> ship_To_Accts = new List<Account>();
        for(Integer i=0;i<10;i++) {
            Account act = new Account();
            act.Name = 'TestAcct'+i;
            act.ShippingStreet ='Test Address' + i;
            act.ShippingCity = 'Houston';
            act.ShippingState = 'TX';
            act.ShippingCountry ='United States';
            act.ShippingPostalCode = '77002';
            act.RecordTypeId = recordTypeId;
            act.SAP_ACCOUNT__c = 'TST' + i;
            act.Hierarchy_Level_BPCS__c = '3-Ship To';
            ship_To_Accts.add(act);
        }
        insert ship_To_Accts;
        Test.startTest();
       Id CMrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
       List<Account> CM_Accts = new List<Account>();
        for(Integer i=0;i<10;i++) {
            Account act = new Account();
            act.Name = 'TestAcct'+i;
            act.ShippingStreet ='Test Address' + i;
            act.ShippingCity = 'Houston';
            act.ShippingState = 'TX';
            act.ShippingCountry ='United States';
            act.ShippingPostalCode = '77002';
            act.RecordTypeId = CMrecordTypeId;
            act.SAP_ACCOUNT__c = 'TST' + i;
            act.Hierarchy_Level_BPCS__c = '3-Ship To';
            act.SFDCCMID__c = 'ABCD-'+i;
            CM_Accts.add(act);
        }
        insert CM_Accts;
        //Test.stopTest();
       
       //Test.startTest();
       Id caseCMrecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
       List<Case> CM_cases = new List<Case>();
        for(Integer i=0;i<10;i++) {
            Case cs = new Case();
            cs.AccountId = CM_Accts[i].Id;
            cs.RecordTypeId = caseCMrecordTypeId;
            cs.isSubmitted__c = false;
            cs.Status = 'New';
            cs.Subject = 'Request Type : New Ship-To Account Request';
            cs.Description = 'Request Type : New Ship-To Account Request';
            cs.Type = 'New Ship-To Account Request';
            cs.Plant_Quality_Review_Complete__c = true;
            cs.Investigation_Complete__c = true;
            CM_cases.add(cs);
        }
       insert CM_cases;
       Test.stopTest();
    }
    @isTest static void getAccountTest(){       
        CustomerOnboardingController.getAccount();
    }
    @isTest static void searchAccountsDataWithActNoTest(){
        Account act = new Account();      
        act.SAP_ACCOUNT__c ='TST1';
        String prospectData= Json.serialize(act);       
        CustomerOnboardingController.searchAccountsData(prospectData);
    }
    @isTest static void searchAccountsDataTest(){
        Account act = new Account();      
        act.Name = 'Test';
        act.ShippingStreet ='Test Address';
        act.ShippingCity = 'Houston';
        act.ShippingState = 'TX';
        act.ShippingCountry ='United States';
        act.ShippingPostalCode = '77002';
        String prospectData= Json.serialize(act);       
        CustomerOnboardingController.searchAccountsData(prospectData);
    }
    //searchAccountsRequests
  	 @isTest static void searchAccountsRequestsTest(){
        CustomerOnboardingController.searchAccountsRequests();
    }
    @isTest static void getAccountDetailsTest(){
        List<Account> lst_Accounts = [SELECT ID FROM Account];
        CustomerOnboardingController.getAccountDetails(lst_Accounts[0].Id);
    }
    @isTest static void searchCustomerRequestsTest(){
        CustomerOnboardingController.searchCustomerRequests();
    }
    @isTest static void getCaseDetailsTest(){
         List<Case> lst_Cases = [SELECT ID FROM Case];
        CustomerOnboardingController.getCaseDetails(lst_Cases[0].Id);
    }
    @isTest static void createAccountNewTest(){
        Id CMrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        List<Account> CM_Accts = [SELECT ID,Name,ShippingStreet,SAP_ACCOUNT__c FROM Account Where RecordTypeId =: CMrecordTypeId];
        string accountDetails = Json.serialize(CM_Accts[0]);
        CustomerOnboardingController.createAccount(accountDetails, null, false, null, 'Northeastqueue', false,true);
    }
    @isTest static void createAccountNewSubmittedTest(){
        Id CMrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        List<Account> CM_Accts = [SELECT ID,Name,ShippingStreet,SAP_ACCOUNT__c FROM Account Where RecordTypeId =: CMrecordTypeId];
        string accountDetails = Json.serialize(CM_Accts[0]);
        List<Case> lst_Cases = [SELECT ID FROM Case];
        //CustomerOnboardingController.createAccount(accountDetails, lst_Cases[0].id, true, CM_Accts[0].Id, 'Northeastqueue', false,true);
    }
    @isTest static void createChangeAccountSubmittedTest(){
         List<Account> lst_Accounts = [SELECT ID FROM Account];
        Id CMrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        Account act = new Account();
        act.Name = 'TestAcct';
        act.ShippingStreet ='Test Address';
        act.ShippingCity = 'Houston';
        act.ShippingState = 'TX';
        act.ShippingCountry ='United States';
        act.ShippingPostalCode = '77002';
        act.RecordTypeId = CMrecordTypeId;
        act.SAP_ACCOUNT__c = 'TST';
        act.Hierarchy_Level_BPCS__c = '3-Ship To';
        act.Request_Type__c = 'Change Ship-To Account Information Request';
        string accountDetails = Json.serialize(act);
        CustomerOnboardingController.createAccount(accountDetails, null, false, lst_Accounts[0].id, 'Northeastqueue', false,true);
    }
    @isTest static void reopenCaseTest(){
        List<Case> lst_Cases = [SELECT ID FROM Case];
        CustomerOnboardingController.reopenCase(lst_Cases[0].id);
    }
    @isTest static void checkforInprogressRequestsOnAccountTest(){
        Id CMrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        List<Account> CM_Accts = [SELECT ID,Name,ShippingStreet,SAP_ACCOUNT__c FROM Account Where RecordTypeId =: CMrecordTypeId];
        CustomerOnboardingController.checkforInprogressRequestsOnAccount(CM_Accts[0].id);
    }
    @isTest static void getLoggedinUserDetailsTest(){
        CustomerOnboardingController.getLoggedinUserDetails();
    }
    @isTest static void createInquiryRequestTest(){
        CustomerOnboardingController.createInquiryRequest('Customer Master Inquiry Request', 'Test Inquiry');
    }
    @isTest static void createActivateorDeactivateAccountRequestTest(){
        List<Account> lst_Accounts = [SELECT ID FROM Account];
        //CustomerOnboardingController.createActivateorDeactivateAccountRequest(lst_Accounts[0].Id, null, true, 'Deactivate a Ship-To Account Request', 'DUPLICATE ACCT', 'Test Reason');
        CustomerOnboardingController.createActivateorDeactivateAccountRequest(lst_Accounts[0].Id, null, false, 'Deactivate a Ship-To Account Request', 'DUPLICATE ACCT', 'Test Reason');
    }
    @isTest static void createPartnerShipToRequestTest(){
        List<Account> lst_Accounts = [SELECT ID FROM Account];
        Id CMrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        List<Account> CM_Accts = [SELECT ID,Name,ShippingStreet,SAP_ACCOUNT__c FROM Account Where RecordTypeId =: CMrecordTypeId];
        //CustomerOnboardingController.createPartnerShipToRequest(lst_Accounts[0].Id, null, true, 'Partner Ship-To Account Request', CM_Accts[0].Id);
        CustomerOnboardingController.createPartnerShipToRequest(lst_Accounts[0].Id, null, false, 'Partner Ship-To Account Request', CM_Accts[0].Id);
    }
    @isTest static void createUnPartnerfromSoldToRequestTest(){
        List<Account> lst_Accounts = [SELECT ID FROM Account];
        Id CMrecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        List<Account> CM_Accts = [SELECT ID,Name,ShippingStreet,SAP_ACCOUNT__c FROM Account Where RecordTypeId =: CMrecordTypeId];
        //CustomerOnboardingController.createUnPartnerfromSoldToRequest(lst_Accounts[0].Id, null, true, 'Un-Partner Ship-To Account Request', CM_Accts[0].Id);
        CustomerOnboardingController.createUnPartnerfromSoldToRequest(lst_Accounts[0].Id, null, false, 'Un-Partner Ship-To Account Request', CM_Accts[0].Id);
    }
    @isTest static void getTMUserDetailsTest(){
        User u = new User(
         ProfileId = [Select Id from profile where Name='System Administrator'].Id,
         LastName = 'last',
         Email = 'puser000@amamama.com',
         Username = 'puser000@amamama.com' + System.currentTimeMillis(),
         CompanyName = 'TEST',
         Title = 'title',
         Alias = 'alias',
         Role__c ='TM',
         TimeZoneSidKey = 'America/Los_Angeles',
         EmailEncodingKey = 'UTF-8',
         LanguageLocaleKey = 'en_US',
         LocaleSidKey = 'en_US'
        );
        insert u;
        CustomerOnboardingController.getTMUserDetails('puser000@amamama.com');
    }
    @isTest static void customDependablePicklistTest(){
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Commercial_Price_Zone__c') ;
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Sales_district__c') ;
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Sales_Group__c') ;
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Z1_Residential__c') ;
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Z2_Commercial__c') ;
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Z5_BE_Territory__c') ;
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Z3_Solar__c') ;
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Z6_GCP_Res_Territory__c') ;
        CustomerOnboardingController.customDependablePicklist('Account', 'Sales_Org__c', 'Price_List_BE_Full_Product_Line__c') ;
    }
}