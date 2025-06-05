@isTest
private class IncentiveHeaderToSAPTest {

    
       
    private static testMethod void testIncentive() {
    
      //  List<Incentive__c> incentiveList = new List<Incentive__c>();
        List<Account> accountsList = new List<Account>();
        List<Contact> contactsList = new List<Contact>();
    
        // CREATE TEST DATA
       Profile p = [SELECT Id FROM Profile WHERE Name='Integration User']; 
       User u = new User(Alias = 'standt', Email='demo3@randomdemodomain.com', 
       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
       LocaleSidKey='en_US', ProfileId = p.Id, User_Territory_Code__c = 'TS07400', 
       TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo3@camfed.org');
        
       System.runAs(u) {
           Id payerRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payer').getRecordTypeId();
                      
           // Create Account 
           Account accPayer = new Account();
           accPayer.Name = 'ALLIED BUILDING PRODUCTS CORP';
           accPayer.RecordTypeId = payerRecordTypeId;
           accPayer.AccountNumber = '3001425';
           accPayer.Site = 'test';
           accPayer.AccountSource = 'Other';
           accPayer.AnnualRevenue = 346775;
           accPayer.Type = 'Payer';
           accPayer.Phone = '7014764403';
           accPayer.Fax = '2016355080';
           accPayer.Status__c = 'Active';
           accPayer.Planning_Account__c = 'No';
           accPayer.Currency__c = 'USD';           
           
           //insert accBuyingGrup; //kb
           accountsList.add(accPayer);           
           insert accountsList;
           
                   // List of Contacts to associated to an Incentive
           Contact con1 = new Contact();
           con1.AccountId = accountsList[0].Id; //kb
           con1.FirstName = 'TestContact';
           con1.LastName = 'Sample01';
           
           Contact con2 = new Contact();
           con2.AccountId = accountsList[0].Id;//kb
           con2.FirstName = 'TestContact';
           con2.LastName = 'Sample02';
           
           Contact con3 = new Contact();
           con3.AccountId = accountsList[0].Id;
           con3.FirstName = 'TestContact';
           con3.LastName = 'Sample03';
           
                      
           contactsList.add(con1);
           contactsList.add(con2);
           contactsList.add(con3);
                      
           insert contactsList;
           
           // Create Incentive record of type Payer
         /*  Incentive__c incentivePayer = new Incentive__c();
           incentivePayer.Name = 'ALLIED BUILDING PRODUCTS CORP - 3001394 - 2016';
           incentivePayer.Additional_Conditions_Misc__c = 'Test';
           incentivePayer.Competitive_Info_Date_Received__c = Date.today();
           incentivePayer.Competitive_Info_Provided_By__c = 'Test User';
           incentivePayer.Competitive_Info_Received_By__c = 'Sample123';
           incentivePayer.End_Date__c = Date.today();
           incentivePayer.Estimated_Payout__c = 34;
           incentivePayer.Notes__c = 'Note test incentive Payer';
           incentivePayer.Payment_Type__c = 'Check';
           incentivePayer.Period__c = 'Annual';
           incentivePayer.Previous_Years_Sales_Volume__c = 89;
           incentivePayer.SAP_Contract_Number__c = 'I-00345';
           incentivePayer.Start_Date__c = Date.today();
           incentivePayer.Status__c = 'Approved';
           incentivePayer.Send_to_SAP__c= true;
           incentivePayer.Sent_to_SAP__c= false;
           incentivePayer.Type__c = 'Payer';
           incentivePayer.Contact_1__c = con1.Id;
           incentivePayer.Contact_2__c = con2.Id;
           incentivePayer.Contact_3__c = con3.Id;
                                
           incentiveList.add(incentivePayer);
                     
           insert incentiveList;*/
           
                      
            Test.startTest();
        
            IncentiveHeaderToSAP.getIncentiveHeaderDetails();

            Test.stopTest();
        }
    }
}