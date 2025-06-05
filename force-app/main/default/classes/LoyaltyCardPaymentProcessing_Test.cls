@IsTest
public class LoyaltyCardPaymentProcessing_Test {
    
    
    @testSetup 
    static void setup() {
         automation_Controller__c automationController = new automation_Controller__c(Name = 'Automation', LoyaltyAutomatedPaymentProcessing__c = true);
        insert automationController;
        
         // Create common test account
        Account acc = new Account(Name = 'TestAcct');
        insert acc;
   
         // Create common test Contact
         Contact con = new Contact (LastName='TestCont',Contractor_ID__c='8971487',MailingStreet='Moore road',MailingCity='Arizona',MailingState='PA',Email='donotreply@domaion.com');
         insert con;
        
         
        // Create common test Loyalty_Card_Payment_Detail__c
        List<Loyalty_Card_Payment_Detail__c> testRecords = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testRecords.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =TRUE,Business_Unit__c='Roofing',Claim_Currency__c='CAD',SF_CardRequestId__c = '20230814044922256CCBNCCAD',SF_RequestId__c='20230814044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10));
        }
        for(Integer i=0;i<2;i++) {
            testRecords.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =TRUE,Business_Unit__c='Roofing',Claim_Currency__c='USD',SF_CardRequestId__c = '20230814044922256CCBNCCAD',SF_RequestId__c='20230814044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10));
        }
         for(Integer i=0;i<2;i++) {
            testRecords.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =TRUE,Business_Unit__c='Siding',Claim_Currency__c='CAD',SF_CardRequestId__c = '20230814044922256CCBNCCAD',SF_RequestId__c='20230814044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10));
        }
         for(Integer i=0;i<2;i++) {
            testRecords.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =TRUE,Business_Unit__c='Siding',Claim_Currency__c='USD',SF_CardRequestId__c = '20230814044922256CCBNCCAD',SF_RequestId__c='20230814044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10));
        }
        insert testRecords;
         
        List<Loyalty_Card_Payment_Detail__c> testUSDRecords1 = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testUSDRecords1.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =FALSE,Claim_Currency__c='USD',BH_Order_Status__c = 'INCOMPLETE',SF_CardRequestId__c='20230815044922256CCBNCCAD',SF_RequestId__c='20230815044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10,BH_Order_Number__c =null,Hold_Payment__c=false,Sent_To_PO__c = True, SF_Batch_Number__c = '12345',BH_TransactionId__c='147852369',SF_Card_RequestId_Date__c=system.today()));
        }
        insert testUSDRecords1;
        
        List<Loyalty_Card_Payment_Detail__c> testUSDRecords2 = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testUSDRecords2.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =FALSE,Claim_Currency__c='USD',BH_Order_Status__c = null,SF_CardRequestId__c='20230815044922256CCBNCCAD',SF_RequestId__c='20230815044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10,BH_Order_Number__c =null,Hold_Payment__c=false,Sent_To_PO__c = True, SF_Batch_Number__c = '12345',BH_TransactionId__c='147852369',SF_Card_RequestId_Date__c=system.today()));
        }
        insert testUSDRecords2;
        
        List<Loyalty_Card_Payment_Detail__c> testUSDRecords3 = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testUSDRecords3.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =FALSE,Claim_Currency__c='USD',BH_Order_Status__c = 'ORDERSUBMITTED',SF_CardRequestId__c='20230815044922256CCBNCCAD',SF_RequestId__c='20230815044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10,BH_Order_Number__c =null,Hold_Payment__c=false,Sent_To_PO__c = True, SF_Batch_Number__c = '12345',BH_TransactionId__c='147852369',SF_Card_RequestId_Date__c=system.today(),Card_Shipped_Date__c = null));
        }
        insert testUSDRecords3;
        
        List<Loyalty_Card_Payment_Detail__c> testUSDRecords4 = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testUSDRecords4.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =FALSE,Claim_Currency__c='USD',BH_Order_Status__c = 'ORDERSUBMITTED',BH_Order_Number__c= '12345',SF_CardRequestId__c='20230815044922256CCBNCCAD',SF_RequestId__c='20230815044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10,Hold_Payment__c=false,Sent_To_PO__c = True, SF_Batch_Number__c = '12345',BH_TransactionId__c='147852369',SF_Card_RequestId_Date__c=system.today(),Card_Shipped_Date__c = null));
        }
        insert testUSDRecords4;
         
        List<Loyalty_Card_Payment_Detail__c> testCADRecords1 = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testCADRecords1.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =FALSE,Claim_Currency__c='CAD',BH_Order_Status__c = 'INCOMPLETE',SF_CardRequestId__c='20230815044922256CCBNCCAD',SF_RequestId__c='20230815044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10,BH_Order_Number__c=null,Hold_Payment__c=False,Sent_To_PO__c = True, SF_Batch_Number__c = '12345',BH_TransactionId__c='147852369',SF_Card_RequestId_Date__c=system.today()));
        }
        insert testCADRecords1;
        
        List<Loyalty_Card_Payment_Detail__c> testCADRecords2 = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testCADRecords2.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =FALSE,Claim_Currency__c='CAD',BH_Order_Status__c = null,SF_CardRequestId__c='20230815044922256CCBNCCAD',SF_RequestId__c='20230815044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10,BH_Order_Number__c=null,Hold_Payment__c=False,Sent_To_PO__c = True, SF_Batch_Number__c = '12345',BH_TransactionId__c='147852369',SF_Card_RequestId_Date__c=system.today()));
        }
        insert testCADRecords2;
        
        List<Loyalty_Card_Payment_Detail__c> testCADRecords3 = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testCADRecords3.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =FALSE,Claim_Currency__c='CAD',BH_Order_Status__c = 'ORDERSUBMITTED',SF_CardRequestId__c='20230815044922256CCBNCCAD',SF_RequestId__c='20230815044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10,BH_Order_Number__c=null,Hold_Payment__c=False,Sent_To_PO__c = True, SF_Batch_Number__c = '12345',BH_TransactionId__c='147852369',SF_Card_RequestId_Date__c=system.today(),Card_Shipped_Date__c = null));
        }
        insert testCADRecords3;
        
        List<Loyalty_Card_Payment_Detail__c> testCADRecords4 = new List<Loyalty_Card_Payment_Detail__c>();
        for(Integer i=0;i<2;i++) {
            testCADRecords4.add(new Loyalty_Card_Payment_Detail__c(Contact_Card_Active__c =FALSE,Claim_Currency__c='CAD',BH_Order_Status__c = 'ORDERSUBMITTED',BH_Order_Number__c= '12345',SF_CardRequestId__c='20230815044922256CCBNCCAD',SF_RequestId__c='20230815044922256CCBNCCAD',Contact__c=con.id,Rebate_Amount__c=10,Hold_Payment__c=False,Sent_To_PO__c = True, SF_Batch_Number__c = '12345',BH_TransactionId__c='147852369',SF_Card_RequestId_Date__c=system.today(),Card_Shipped_Date__c = null));
        }
        insert testCADRecords4;
        
    }
    
    
    @IsTest
    static void getNewCardCADTest1() {
       
        Test.startTest();
        LoyaltyCardPaymentProcessing.getNewCardCAD();
        Test.stopTest();
    }
    
    @IsTest
    static void getNewCardCADTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.getNewCardCAD();
        Test.stopTest();
    }
    
    @IsTest
    static void getNewCardUSDTest1() {
      
        Test.startTest();
        LoyaltyCardPaymentProcessing.getNewCardUSD();
        Test.stopTest();
    }
    
    @IsTest
    static void getNewCardUSDTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.getNewCardUSD();
        Test.stopTest();
    }
   
    @isTest
    static void updateCardOrderInfoTest()
    {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        profile profiledetails = [SELECT id from profile where name = 'System Administrator' Limit 1];
        User newuser = new User(Alias = 'standt',Email='standarduser@testorg.com',
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', ProfileId = profiledetails.Id,
                                TimeZoneSidKey='America/Los_Angeles',UserName=uniqueUserName);
        insert newuser;
        system.runas(newuser)
        {
            Test.starttest();
            LoyaltyCardPaymentProcessing.updateCardOrderInfo('20230815044922256CCBNCCAD', '','INCOMPLETE');
            LoyaltyCardPaymentProcessing.updateCardOrderInfo('20230815044922256CCBNCCAD1', '','INCOMPLETE');
            LoyaltyCardPaymentProcessing.updateCardOrderInfo(null, null,null);
            test.StopTest();
        }
       
    }
    
    @isTest
    static void updateCardOrderInfoTest2()
    {
        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        profile profiledetails = [SELECT id from profile where name = 'System Administrator' Limit 1];
        User newuser = new User(Alias = 'standt',Email='standarduser@testorg.com',
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', ProfileId = profiledetails.Id,
                                TimeZoneSidKey='America/Los_Angeles',UserName=uniqueUserName);
        insert newuser;
        
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        system.runas(newuser)
        {
            Test.starttest();
            LoyaltyCardPaymentProcessing.updateCardOrderInfo('20230815044922256CCBNCCAD', '','INCOMPLETE');
            test.StopTest();
        }
       
    }
    
    @IsTest
    static void queryCardOrderInfoCADTest1() {
          Test.startTest();
        LoyaltyCardPaymentProcessing.queryCardOrderInfoCAD();
        Test.stopTest();
    }
    
    @IsTest
    static void queryCardOrderInfoCADTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.queryCardOrderInfoCAD();
        Test.stopTest();
    }
    
    @IsTest
    static void queryCardOrderInfoUSDTest1(){
        
        Test.startTest();
        LoyaltyCardPaymentProcessing.queryCardOrderInfoUSD();
        Test.stopTest();
    }
    
    @IsTest
    static void queryCardOrderInfoUSDTest2(){
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.queryCardOrderInfoUSD();
        Test.stopTest();
    }
    
    @IsTest
    static void queryCardShipInfoUSDTest1()
    {
        Test.StartTest();
        LoyaltyCardPaymentProcessing.queryCardShipInfoUSD();
        Test.stopTest();
    }
    
    @IsTest
    static void queryCardShipInfoUSDTest2()
    {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.StartTest();
        LoyaltyCardPaymentProcessing.queryCardShipInfoUSD();
        Test.stopTest();
    }
    
    @isTest
    static void queryCardShipInfoCADTest1()
    {
        Test.startTest();
        LoyaltyCardPaymentProcessing.queryCardShipInfoCAD();
        Test.stopTest();
    }
    
     @isTest
    static void queryCardShipInfoCADTest2()
    {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.queryCardShipInfoCAD();
        Test.stopTest();
    }
    
    @IsTest
    static void updateCardShipStatusTest1() {
        Test.startTest();
        LoyaltyCardPaymentProcessing.updateCardShipStatus('12345','ORDERSUBMITTED',null);
        Test.stopTest();
    }
    
    @IsTest
    static void updateCardShipStatusTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.updateCardShipStatus(null,null,null);
        Test.stopTest();
    }
    
  	 @IsTest
    static void updateCardShipStatusCsvTest1()
    {
         List<LoyaltyCardPaymentProcessing.CompleteOrderInfo> sampleList = new List<LoyaltyCardPaymentProcessing.CompleteOrderInfo>();
         LoyaltyCardPaymentProcessing.CompleteOrderInfo order = new LoyaltyCardPaymentProcessing.CompleteOrderInfo();
         order.CompleteDate = system.Today();
         order.Name = 'Test';
         LoyaltyCardPaymentProcessing.updateCardShipStatusCsv(sampleList);
         
    }
    
     @IsTest
    static void updateCardShipStatusCsvTest2()
    {
         automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
         automationController.LoyaltyAutomatedPaymentProcessing__c = false;
         update automationController; 
         List<LoyaltyCardPaymentProcessing.CompleteOrderInfo> sampleList = new List<LoyaltyCardPaymentProcessing.CompleteOrderInfo>();
         LoyaltyCardPaymentProcessing.CompleteOrderInfo order = new LoyaltyCardPaymentProcessing.CompleteOrderInfo();
         order.CompleteDate = null;
         order.Name = 'Test';
         LoyaltyCardPaymentProcessing.updateCardShipStatusCsv(sampleList);
         
    }
    
    @IsTest
    static void getCCBRoofingFundingCADTest1() {
        Test.startTest();
        LoyaltyCardPaymentProcessing.getCCBRoofingFundingCAD();
        Test.stopTest();
    }
    
     @IsTest
    static void getCCBRoofingFundingCADTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController; 
        Test.startTest();
        LoyaltyCardPaymentProcessing.getCCBRoofingFundingCAD();
        Test.stopTest();
    }
    
    @IsTest
    static void getCCBRoofingFundingUSDTest1() {
        Test.startTest();
        LoyaltyCardPaymentProcessing.getCCBRoofingFundingUSD();
        Test.stopTest();
    }
    
    @IsTest
    static void getCCBRoofingFundingUSDTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.getCCBRoofingFundingUSD();
        Test.stopTest();
    }
    
    @IsTest
    static void getCCBSidingFundingCADTest1() {
        Test.startTest();
        LoyaltyCardPaymentProcessing.getCCBSidingFundingCAD();
        Test.stopTest();
    }
    
    @IsTest
    static void getCCBSidingFundingCADTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.getCCBSidingFundingCAD();
        Test.stopTest();
    }
    
    @IsTest
    static void getCCBSidingFundingUSDTest1() {
        Test.startTest();
        LoyaltyCardPaymentProcessing.getCCBSidingFundingUSD();
        Test.stopTest();
    }
    
    @IsTest
    static void getCCBSidingFundingUSDTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.getCCBSidingFundingUSD();
        Test.stopTest();
    }
    
    @isTest
    static void updateOrderFundingInfoTest1()
    {
        Test.startTest();
        LoyaltyCardPaymentProcessing.updateOrderFundingInfo('20230815044922256CCBNCCAD', '', 'INCOMPLETE');
        Test.stopTest();
    }
    
    @isTest
    static void updateOrderFundingInfoTest2()
    {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.updateOrderFundingInfo('20230815044922256CCBNCCAD', '', 'INCOMPLETE');
        Test.stopTest();
    }
    
    @IsTest
    static void queryOrderFundingInfoUSDTest1()
    {
        Test.startTest();
        LoyaltyCardPaymentProcessing.queryOrderFundingInfoUSD();
        Test.StopTest();
    }
    
    @IsTest
    static void queryOrderFundingInfoUSDTest2()
    {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.queryOrderFundingInfoUSD();
        Test.StopTest();
    }
    
    @isTest
    static void queryOrderFundingInfoCADTest1()
    {
        Test.StartTest();
        LoyaltyCardPaymentProcessing.queryOrderFundingInfoCAD();
        Test.StopTest();
    }
    
    @isTest
    static void queryOrderFundingInfoCADTest2()
    {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.StartTest();
        LoyaltyCardPaymentProcessing.queryOrderFundingInfoCAD();
        Test.StopTest();
    }
    
    @IsTest
    static void queryShipFundingInfoUSDTest1()
    {
        Test.StartTest();
        LoyaltyCardPaymentProcessing.queryShipFundingInfoUSD();
        Test.StopTest();
    }
    
    @IsTest
    static void queryShipFundingInfoUSDTest2()
    {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.StartTest();
        LoyaltyCardPaymentProcessing.queryShipFundingInfoUSD();
        Test.StopTest();
    }
    
    @IsTest
    static void queryShipFundingInfoCADTest1()
    {
        Test.StartTest();
        LoyaltyCardPaymentProcessing.queryShipFundingInfoCAD();
        Test.StopTest();
    }
    
    @IsTest
    static void queryShipFundingInfoCADTest2()
    {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.StartTest();
        LoyaltyCardPaymentProcessing.queryShipFundingInfoCAD();
        Test.StopTest();
    }
    
    @IsTest
    static void uupdateFundingShipStatusTest1() {
        Test.startTest();
        LoyaltyCardPaymentProcessing.updateFundingShipStatus('12345','ORDERSUBMITTED',System.today());
        Test.stopTest();
    }
    
    @IsTest
    static void uupdateFundingShipStatusTest2() {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController;
        Test.startTest();
        LoyaltyCardPaymentProcessing.updateFundingShipStatus('36542',null,null);
        Test.stopTest();
    }
    
    @IsTest
    static void updateFundingShipStatusCsvTest1()
    {
         List<LoyaltyCardPaymentProcessing.CompleteOrderInfo> sampleList = new List<LoyaltyCardPaymentProcessing.CompleteOrderInfo>();
         LoyaltyCardPaymentProcessing.CompleteOrderInfo order = new LoyaltyCardPaymentProcessing.CompleteOrderInfo();
         order.CompleteDate = system.Today();
         order.Name = 'Test';
        Test.startTest();
        LoyaltyCardPaymentProcessing.updateFundingShipStatusCsv(sampleList);
        Test.stopTest();
        
    }
    @IsTest
    static void updateFundingShipStatusCsvTest2()
    {
        automation_Controller__c automationController =  [select id, name,LoyaltyAutomatedPaymentProcessing__c from automation_Controller__c where Name = 'Automation' limit 1];
        automationController.LoyaltyAutomatedPaymentProcessing__c = false;
        update automationController; 
        List<LoyaltyCardPaymentProcessing.CompleteOrderInfo> sampleList = new List<LoyaltyCardPaymentProcessing.CompleteOrderInfo>();
         LoyaltyCardPaymentProcessing.CompleteOrderInfo order = new LoyaltyCardPaymentProcessing.CompleteOrderInfo();
         order.CompleteDate = system.Today();
         order.Name = 'Test';
        Test.startTest();
        LoyaltyCardPaymentProcessing.updateFundingShipStatusCsv(sampleList);
        Test.stopTest();
        
    }
}