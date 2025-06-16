@isTest
private class IncentiveLoadToSAPTest {

    private static testMethod void testIncentiveProduct() {
    
       // List<Incentive__c> incentiveList = new List<Incentive__c>();
        //List<Incentive_Product__c> incentiveProductList = new List<Incentive_Product__c>();
        //List<Incentive_Gate__c> incentiveGateList = new List<Incentive_Gate__c>();
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
           
           Contact con4 = new Contact();
           con4.AccountId = accountsList[0].Id;
           con4.FirstName = 'TestContact';
           con4.LastName = 'Sample01';
           
           Contact con5 = new Contact();
           con5.AccountId = accountsList[0].Id;
           //END S-490566 
           con5.FirstName = 'TestContact';
           con5.LastName = 'Sample02';
           
           contactsList.add(con1);
           contactsList.add(con2);
           contactsList.add(con3);
           contactsList.add(con4);
           contactsList.add(con5);
           
           insert contactsList;
           
           // Create Incentive record of type Payer
          /* Incentive__c incentivePayer = new Incentive__c();
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
           incentivePayer.Type__c = 'Payer';
           incentivePayer.Contact_1__c = con1.Id;
           incentivePayer.Contact_2__c = con2.Id;
           incentivePayer.Contact_3__c = con3.Id;
                                
           incentiveList.add(incentivePayer);
                     
           insert incentiveList;*/
           
          /* Incentive_Customer__c incentiveCustomer = new Incentive_Customer__c();
           incentiveCustomer.Customer__c = accPayer.Id;
           incentiveCustomer.Incentive__c = incentivePayer.Id;
           
           insert incentiveCustomer;*/
           
           Price_Group__c customerGroup = new Price_Group__c();
           customerGroup.Name = 'A1';
          // customerGroup.Associated_Payer__c = accPayer.Id;
           customerGroup.Price_Group_Code__c = 'A1';
           customerGroup.Type__c = 'Pricing Group';
           
           insert customerGroup;
           
           // Incentive Products for Payer Type
           /*Incentive_Product__c incentiveProduct1 = new Incentive_Product__c();
           incentiveProduct1.Name = 'S2 SPG Cedar Impressions Panels & Access';
           incentiveProduct1.Product_Level__c = 'Corporate Class';
           incentiveProduct1.Percent_of_Rebate_Sales__c = 3;
           incentiveProduct1.Has_Gates__c = false;
           incentiveProduct1.Send_to_SAP__c = true;
           incentiveProduct1.Sent_to_SAP__c = false;
          //
          //  incentiveProduct1.Incentive__c = incentivePayer.Id;
           
           Incentive_Product__c incentiveProduct2 = new Incentive_Product__c();
           incentiveProduct2.Name = '17 SPG Fence';
           incentiveProduct2.Product_Level__c = 'Division';
           incentiveProduct2.Percent_of_Rebate_Sales__c = 3;
           incentiveProduct2.Has_Gates__c = false;
           incentiveProduct2.Send_to_SAP__c = true;
           incentiveProduct2.Sent_to_SAP__c = false;
          // incentiveProduct2.Incentive__c = incentivePayer.Id;
           
           Incentive_Product__c incentiveProduct3 = new Incentive_Product__c();
           incentiveProduct3.Name = '11 SPG Siding / SPG Accessories';
           incentiveProduct3.Product_Level__c = 'Division / Product Type';
           incentiveProduct3.Percent_of_Rebate_Sales__c = 3;
           incentiveProduct3.Has_Gates__c = false;
           incentiveProduct3.Send_to_SAP__c = false;
           incentiveProduct3.Sent_to_SAP__c = false;
          // incentiveProduct3.Incentive__c = incentivePayer.Id;
           
           Incentive_Product__c incentiveProduct4 = new Incentive_Product__c();
           incentiveProduct4.Name = 'S03 SPG CT Siding Beaded Soffit';
           incentiveProduct4.Product_Level__c = 'Market Family';
           incentiveProduct4.Percent_of_Rebate_Sales__c = 3;
           incentiveProduct4.Has_Gates__c = false;
           incentiveProduct4.Send_to_SAP__c = true;
           incentiveProduct4.Sent_to_SAP__c = true;
          // incentiveProduct4.Incentive__c = incentivePayer.Id;
           
           Incentive_Product__c incentiveProduct5 = new Incentive_Product__c();
           incentiveProduct5.Name = 'S3 SPG Restoration Millwork';
           incentiveProduct5.Product_Level__c = 'Corporate Class';
           incentiveProduct5.Has_Gates__c = true;
           incentiveProduct5.Send_to_SAP__c = true;
           incentiveProduct5.Sent_to_SAP__c = false;
         //  incentiveProduct5.Incentive__c = incentivePayer.Id;
           
           incentiveProductList.add(incentiveProduct1);
           incentiveProductList.add(incentiveProduct2);
           incentiveProductList.add(incentiveProduct3);
           incentiveProductList.add(incentiveProduct4);
           incentiveProductList.add(incentiveProduct5);           
           
           insert incentiveProductList;
           
           // Incentive Gates for Payer Type
           /*Incentive_Gate__c incentiveGate1 = new Incentive_Gate__c();
           incentiveGate1.Amount__c = 34;
           incentiveGate1.Percent_of_Rebate_Sales__c = 5;
          // incentiveGate1.Incentive__c = incentivePayer.Id;
           incentiveGate1.Type__c = 'Annual';
           incentiveGate1.Incentive_Product__c = incentiveProduct5.Id;
          // incentiveGateList.add(incentiveGate1);
           Incentive_Gate__c incentiveGate2 = new Incentive_Gate__c();
           incentiveGate2.Amount__c = 34;
           incentiveGate2.Percent_of_Rebate_Sales__c = 5;
       //    incentiveGate2.Incentive__c = incentivePayer.Id;
           incentiveGate2.Type__c = 'Annual';
           incentiveGate2.Incentive_Product__c = incentiveProduct5.Id;
           //incentiveGateList.add(incentiveGate2);
           Incentive_Gate__c incentiveGate3 = new Incentive_Gate__c();
           incentiveGate3.Amount__c = 34;
           incentiveGate3.Percent_of_Rebate_Sales__c = 5;
         //  incentiveGate3.Incentive__c = incentivePayer.Id;
           incentiveGate3.Type__c = 'Annual';
           incentiveGate3.Incentive_Product__c = incentiveProduct5.Id;
           //incentiveGateList.add(incentiveGate3);
           Incentive_Gate__c incentiveGate4 = new Incentive_Gate__c();
           incentiveGate4.Amount__c = 34;
           incentiveGate4.Percent_of_Rebate_Sales__c = 5;
          // incentiveGate4.Incentive__c = incentivePayer.Id;
           incentiveGate4.Type__c = 'Annual';
           incentiveGate4.Incentive_Product__c = incentiveProduct5.Id;
          // incentiveGateList.add(incentiveGate4);
           Incentive_Gate__c incentiveGate5 = new Incentive_Gate__c();
           incentiveGate5.Amount__c = 34;
           incentiveGate5.Percent_of_Rebate_Sales__c = 5;
          // incentiveGate5.Incentive__c = incentivePayer.Id;
           incentiveGate5.Type__c = 'Annual';
           incentiveGate5.Incentive_Product__c = incentiveProduct5.Id;          
           //incentiveGateList.add(incentiveGate5);
           
           //insert incentiveGateList;*/
           
            Test.startTest();
        
            IncentiveLoadToSAP.getIncentiveDetails();

            Test.stopTest();
        }
    }
}