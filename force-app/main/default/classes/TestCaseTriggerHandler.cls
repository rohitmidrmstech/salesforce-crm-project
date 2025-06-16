/*********************************************************************************
* Test Class: {TestCaseTriggerHandler}
* Created by {Abhishek Pareek}, Navivo, {DateCreated 12/26/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Covering Code of CaseTriggerHandler}
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Abhishek 12/26/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
*********************************************************************************/

@isTest
private class TestCaseTriggerHandler {
	@TestSetup
    static void makeData(){
        Region__c reg = TestClassUtility.createRegion('TestClass1','TC1',true);
        Territory__c terr = TestClassUtility.createTerritory('TRR1', 'TRR1','Commercial', reg.Id, true);
        User us=  TestClassUtility.createTestUser('Contract Manager','Danthony','rbommareddy@thresholdcs.com','Anthony','rbommareddy@thresholdcs.com','PC',true);
        User us2=  TestClassUtility.createTestUser('Contract Manager','Dan','rbommareddy2@thresholdcs.com','Anthony2','rbommareddy2@thresholdcs.com','PC',true);
        //us.ManagerId = us2.Id;
        //update us;
        terr.Sales_Rep__c = us.id;
        update terr;
        Plants__c wh =  TestClassUtility.createWarehouse('TEST',us.id, true);
        Plants__c wh2 =  TestClassUtility.createWarehouse('TEST2',us.id, true);
        wh.Logistics_Coordinator__c = us.id;
        wh.Dispatch_User__c = us.id;
        wh.Dispatch_Email__c = 'rbommareddy@thresholdcs.com';
        update wh;
        wh2.Logistics_Coordinator__c = us.id;
        wh2.Dispatch_User__c = us.id;
        wh2.Dispatch_Email__c = 'rbommareddy11@thresholdcs.com';
        update wh2;
        
        Account soldToAccs = TestClassUtility.createAccount('Sold_To_Acc_',null, 'All_Other_Accounts', 'Other', 'Other', terr.Id, true);
        soldToAccs.Territory__c = terr.id;
        soldToAccs.Z3_Partner__c = terr.id;
        soldToAccs.Finishing_Territory__c = terr.id;
        soldToAccs.Z3_Partner__c = terr.id;
        soldToAccs.Z5_Territory__c = terr.id;
        soldToAccs.Z6_Territory__c = terr.id;
        Account orderForAccs = TestClassUtility.createAccount('Order_For_Acc_', soldToAccs.Id, 'All_Other_Accounts', 'Other', 'Other', terr.Id, true);
        
        Account shipToAccs = TestClassUtility.createAccount('Ship_To_Acc_', orderForAccs.Id, 'All_Other_Accounts', 'Other', 'Other', terr.Id, true);
        Contact con = TestClassUtility.createcontact('test',orderForAccs.Id,'AL','test@test.com','9899898899',true);        
        Region__c region = TestClassUtility.createReg('TestClass1','TST',us.id,us.id,true);
        Order order1 = TestClassUtility.createOrder('Order_1', System.Today().addDays(-1), orderForAccs.Id, 'PICKED', 800, shipToAccs.id, true);
        order1.Manufacturing_Plant__c = wh.Id;
        order1.region_rpg__c = region.Id;
        update order1; 
        Order order2 = TestClassUtility.createOrder('Order_2', System.Today().addDays(-1), orderForAccs.Id, 'PICKED', 700, shipToAccs.id, true);
        Order order3 = TestClassUtility.createOrder('Order_3', System.Today().addDays(-1), orderForAccs.Id, 'PICKED', 700, shipToAccs.id, true);
        Order order4 = TestClassUtility.createOrder('Order_4', System.Today().addDays(-1), orderForAccs.Id, 'INVOICED', 700, shipToAccs.id, true);
        Invoice__c invoice = new Invoice__c(Name = 'TEST', Order__c = order4.id);
        insert invoice;
                
    }
    
    static testMethod void myUnitTest() { 
        User user1 = [SELECT Id, Name From User Where Email='rbommareddy@thresholdcs.com' limit 1];
        List<CasePricingCordinator__mdt> mtdList = [SELECT id FROM CasePricingCordinator__mdt];
		CasePricingCordinator__mdt nameOne = new CasePricingCordinator__mdt(Label= '1111', UserName__c = user1.Name);
        
        Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Reconsignment Case').getRecordTypeId();
        Id servicerecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        Id portalRecortType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Debit Request').getRecordTypeId();
		Contact con = [SELECT Id From Contact Where LastName='test' limit 1];
        Order order1 = [SELECT Id From Order Where Name='Order_1' limit 1];
        Order order2 = [SELECT Id From Order Where Name='Order_2' limit 1];
        Order order3 = [SELECT Id From Order Where Name='Order_3' limit 1];
        Account soldToAccs = [SELECT Id From Account Where Name='Sold_To_Acc_' limit 1];
        List<Case> csList = new List<Case>();
        csList.add(TestClassUtility.createCase('Order Change', 'test', 'Changed Request Date', 'Closed', con.Id, order1.Id, false));
        csList[0].Campaign__c = 'RES';
        csList[0].Sold_to_Name__c = soldToAccs.id;
        csList[0].recordTypeId= portalRecortType;
        csList[0].Order__c = order2.Id;
        csList[0].Product_Category__c = 'Board';
        csList[0].Country__c = 'USA';
        //csList[0].RSM__c = 'Agree';
        insert csList; 
         
        /*Case caseRec = new Case();
        caseRec.Campaign__c = 'RES';
        caseRec.Plant_Manager__c = UserInfo.getUserId();
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        insert caseRec;*/
        
        
        csList[0].Product_Category__c = 'Roofing';
        caseTriggerHandler_rpg cth = new caseTriggerHandler_rpg();
        cth.updateBusinessHours(csList);
        //cth.updateTM(csList, null);
		cth.portalCaseAssignment(csList);
        
        
        
        Map<Id, Case> oldCaseMap = new Map<Id, Case>();
        List<case> insertedCase = [Select id from case];
        oldCaseMap.put(insertedCase[0].id,insertedCase[0]);
        insertedCase[0].Product_Category__c = 'Roofing';
        insertedCase[0].Order__c = order2.Id;
        insertedCase[0].country__c = 'USA';
        //insertedCase[0].recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('RMA').getRecordTypeId();
        update insertedCase[0];
        //cth.updateTM(insertedCase, oldCaseMap);
        insertedCase[0].recordTypeId=portalRecortType;
        insertedCase[0].Sales_Org__c = '1502';
        insertedCase[0].Product_Category__c = 'Board';
        insertedCase[0].Order__c = order1.Id;
        Test.StartTest();
        update insertedCase[0];
        Test.StopTest(); 
        //cth.updateTM(insertedCase, oldCaseMap);
        csList[0].Order__c = Order3.Id;
        csList[0].RSM__c = user1.Id;
        cth.updateVP(csList, null);
        Map<Id,Case> oldMap = new Map<Id,Case>();
        oldMap.put(csList[0].Id,csList[0]);
        cth.updateVP(csList, oldMap);
        csList[0].Documents__c = 'sfdc.co/img.png';
        caseTriggerHandler_rpg.formatDocumentData(csList[0],csList[0]);
        biuCaseUtil.formatDocumentData(csList[0],csList[0]);
    
    }
    
    static testMethod void myUnitTestOne(){
        Order order3 = [SELECT Id From Order Where Name='Order_3' limit 1];
        Order order2 = [SELECT Id From Order Where Name='Order_2' limit 1];
        Case caseRec = new Case();
        caseRec.Campaign__c = 'RES';
        caseRec.Plant_Manager__c = UserInfo.getUserId();
        caseRec.Order__c = order2.Id;
        caseRec.Country__c = 'USA';
        caseRec.Sales_Org__c = '1502';
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portal').getRecordTypeId();        
        insert caseRec;
        
        Test.startTest();
        Case existingCase = [SELECT Id, Order__c FROM Case WHERE Id =:caseRec.Id];
        existingCase.Order__c = order3.Id;
        update existingCase;
        Test.stopTest();
        
    }
    
    static testMethod void myUnitTestSeven(){
        Order order2 = [SELECT Id From Order Where Name='Order_2' limit 1];
        Case caseRec = new Case();
        caseRec.Campaign__c = 'RES';
        caseRec.Plant_Manager__c = UserInfo.getUserId();
        caseRec.Order__c = order2.Id;
        caseRec.Country__c = 'USA';
        caseRec.Sales_Org__c = '1111';
        caseRec.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CBI RMA Case').getRecordTypeId();
        Test.StartTest();
        insert caseRec;
        Test.StopTest();
    }
    
    static testMethod void myUnitTestTwo(){
            Order order4 = [SELECT Id From Order Where Name='Order_4' limit 1];
        
        Account soldToAccs = [SELECT Id From Account Where Name='Sold_To_Acc_' limit 1];
        
        Invoice__c invoice = [SELECT Id From Invoice__c Where Name='TEST' limit 1];
        Case caseRec1 = new Case();
        caseRec1.Product_Category__c = 'Finishing';
        caseRec1.Campaign__c = 'RES';
        caseRec1.Plant_Manager__c = UserInfo.getUserId();
        caseRec1.Order__c = order4.Id;
        caseRec1.Invoice__c = invoice.Id;
        caseRec1.Country__c = 'USA';
        caseRec1.Ship_To_Company__c = soldToAccs.Id;
        caseRec1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Case').getRecordTypeId();
        insert caseRec1;
    }
    
    static testMethod void myUnitTestThree(){
        Account soldToAccs = [SELECT Id From Account Where Name='Sold_To_Acc_' limit 1];
        Order order4 = [SELECT Id From Order Where Name='Order_4' limit 1];
        Invoice__c invoice = [SELECT Id From Invoice__c Where Name='TEST' limit 1];
        Case caseRec1 = new Case();
        caseRec1.Product_Category__c = 'Milled Gypsum';
        caseRec1.Campaign__c = 'RES';
        caseRec1.Plant_Manager__c = UserInfo.getUserId();
        caseRec1.Order__c = order4.Id;
        caseRec1.Invoice__c = invoice.Id;
        caseRec1.Country__c = 'USA';
        caseRec1.Ship_To_Company__c = soldToAccs.Id;
        caseRec1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Case').getRecordTypeId();
        insert caseRec1;
    }
    
    static testMethod void myUnitTestFour(){
        Account soldToAccs = [SELECT Id From Account Where Name='Sold_To_Acc_' limit 1];
        Order order4 = [SELECT Id From Order Where Name='Order_4' limit 1];
        Invoice__c invoice = [SELECT Id From Invoice__c Where Name='TEST' limit 1];
        Case caseRec1 = new Case();
        caseRec1.Product_Category__c = 'Finishing';
        caseRec1.Campaign__c = 'RES';
        caseRec1.Plant_Manager__c = UserInfo.getUserId();
        caseRec1.Order__c = order4.Id;
        caseRec1.Invoice__c = invoice.Id;
        caseRec1.Country__c = 'USA';
        caseRec1.Ship_To_Company__c = soldToAccs.Id;
        caseRec1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Credit Request').getRecordTypeId();
        insert caseRec1;
    }
    
    static testMethod void myUnitTestFive(){
        Account soldToAccs = [SELECT Id From Account Where Name='Sold_To_Acc_' limit 1];
        Order order4 = [SELECT Id From Order Where Name='Order_4' limit 1];
        Invoice__c invoice = [SELECT Id From Invoice__c Where Name='TEST' limit 1];
        Case caseRec1 = new Case();
        caseRec1.Product_Category__c = 'Corners/Tape/International';
        caseRec1.Campaign__c = 'RES';
        caseRec1.Plant_Manager__c = UserInfo.getUserId();
        caseRec1.Order__c = order4.Id;
        caseRec1.Invoice__c = invoice.Id;
        caseRec1.Country__c = 'USA';
        caseRec1.Ship_To_Company__c = soldToAccs.Id;
        caseRec1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Credit Request').getRecordTypeId();
        insert caseRec1;
    }
    
    static testMethod void myUnitTestForMilledGypsum(){
        Account soldToAccs = [SELECT Id From Account Where Name='Sold_To_Acc_' limit 1];
        Order order4 = [SELECT Id From Order Where Name='Order_4' limit 1];
        Invoice__c invoice = [SELECT Id From Invoice__c Where Name='TEST' limit 1];
        Case caseRec1 = new Case();
        caseRec1.Product_Category__c = 'Milled Gypsum';
        caseRec1.Campaign__c = 'RES';
        caseRec1.Plant_Manager__c = UserInfo.getUserId();
        caseRec1.Order__c = order4.Id;
        caseRec1.Invoice__c = invoice.Id;
        caseRec1.Country__c = 'USA';
        caseRec1.Ship_To_Company__c = soldToAccs.Id;
        caseRec1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment Credit Request').getRecordTypeId();
        insert caseRec1;
    }
    
    static testMethod void myUnitTestSix(){
        Account soldToAccs = [SELECT Id From Account Where Name='Sold_To_Acc_' limit 1];
        Order order4 = [SELECT Id From Order Where Name='Order_4' limit 1];
        Invoice__c invoice = [SELECT Id From Invoice__c Where Name='TEST' limit 1];
        Case caseRec1 = new Case();
        caseRec1.Product_Category__c = 'Corners/Tape/International';
        caseRec1.Campaign__c = 'RES';
        caseRec1.Plant_Manager__c = UserInfo.getUserId();
        caseRec1.Order__c = order4.Id;
        caseRec1.Invoice__c = invoice.Id;
        caseRec1.Country__c = 'USA';
        caseRec1.Ship_To_Company__c = soldToAccs.Id;
        caseRec1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Case').getRecordTypeId();
        insert caseRec1;
    }
    
    @isTest
    //Assiging users to Pricing_Coordinator__c field
    static void updateTM_Before_Insert_for_1111_SalesOrg() {
        Contact con = [SELECT Id From Contact Where LastName='test' limit 1];
        User jenUser = [SELECT Id, Name FROM User WHERE Name = 'Jen Herder' and isActive=true LIMIT 1];
        Plants__c plantlist = [Select Id, Name from Plants__c limit 1];
        Account orderForAccs = [SELECT Id, Name From Account Where Name='Order_For_Acc_' limit 1];
        orderForAccs.LOB__c = '1111';
        update orderForAccs;
        
        try {
            Case newCase = new Case();
            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CBI RMA Case').getRecordTypeId();
            newCase.ContactId = con.Id;
            newCase.Status = 'New';
            newCase.Origin = 'Email';
            newCase.Type = 'Residential BE';
            newCase.SubType__c='Claim';
            newCase.Product_Category__c = 'Fence';
            newCase.Sales_Org__c = '1021';
            newCase.Subject = 'TestCase-1021-Insert';
            newCase.RMA_Number__c = '1234';
            newCase.Restocking_Charged__c = 'Yes';
            newCase.Restocking_Percentage__c = 2.4;
            newCase.RMA_To__c = plantlist.Id;
            newCase.RMA_Freight__c = 2.4;
            newCase.RMAFreightCharged__c = 'No';
            newCase.Ship_Date__c = System.today();
            newCase.Invoice_Number__c = '1234';
            Test.StartTest();
            INSERT newCase;
            Test.StopTest();   
            
            Case insertedCase = [SELECT Id, Sales_org__c, Pricing_Coordinator__r.Name FROM Case WHERE Id =: newCase.Id];
            System.debug('An error occured :: '+insertedCase);
            //Assert.areEqual(jenUser.Name, insertedCase.Pricing_Coordinator__r.Name,'Pricing Coordinator should be Jen Herder');
        } catch(exception e) {
            System.debug('An error occured :: '+e.getMessage());
        }
    }
    
    @isTest
    //Assiging users to Pricing_Coordinator__c field
    static void updateTM_Before_Insert_for_1021_SalesOrg() {
        Contact con = [SELECT Id From Contact Where LastName='test' limit 1];
        User jodyUser = [SELECT Id, Name FROM User WHERE Name = 'Jody Mischik' and isActive=true LIMIT 1];
        Plants__c plantlist = [Select Id, Name from Plants__c limit 1];
        Account orderForAccs = [SELECT Id,Name From Account Where Name='Order_For_Acc_' limit 1];
        orderForAccs.LOB__c = '1021';
        update orderForAccs;
        
        try {
            Case newCase = new Case();
            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CBI RMA Case').getRecordTypeId();
            newCase.ContactId = con.Id;
            newCase.Status = 'New';
            newCase.Origin = 'Email';
            newCase.Type = 'Residential BE';
            newCase.SubType__c='Claim';
            newCase.Product_Category__c = 'Fence';
            newCase.Sales_Org__c = '1021';
            newCase.Subject = 'TestCase-1021-Insert';
            newCase.RMA_Number__c = '1234';
            newCase.Restocking_Charged__c = 'Yes';
            newCase.Restocking_Percentage__c = 2.4;
            newCase.RMA_To__c = plantlist.Id;
            newCase.RMA_Freight__c = 2.4;
            newCase.RMAFreightCharged__c = 'No';
            newCase.Ship_Date__c = System.today();
            newCase.Invoice_Number__c = '1234';
            Test.StartTest();
            INSERT newCase;
            Test.StopTest();   
            
            Case insertedCase = [SELECT Id, Sales_org__c, Pricing_Coordinator__r.Name FROM Case WHERE Id =: newCase.Id];
            //Assert.areEqual(JodyUser.Name , insertedCase.Pricing_Coordinator__r.Name,'Pricing Coordinator should be Jody Mischik');
        } catch(exception e) {
            System.debug('An error occured :: '+e.getMessage());
        }
    }
    
    @isTest
    //Assiging users to Pricing_Coordinator__c field by changing salesorg
    static void updateTM_After_Update_By_changing_SalesOrg() {
        Contact con = [SELECT Id From Contact Where LastName='test' limit 1];
        User JodyUser = [SELECT Id, Name FROM User WHERE Name = 'Jody Mischik' and isActive=true LIMIT 1]; // 1021 salesorg
        User jenUser = [SELECT Id, Name FROM User WHERE Name = 'Jen Herder' and isActive=true LIMIT 1];    // 1111 salesorg
        Id cbiRMACaseId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CBI RMA Case').getRecordTypeId();
        Plants__c plantlist = [Select Id, Name from Plants__c limit 1];
        Account orderForAccs = [SELECT Id,Name From Account Where Name='Order_For_Acc_' limit 1];
        orderForAccs.LOB__c = '1021';
        update orderForAccs;
        
        try {
            Case newCase = new Case();
            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CBI RMA Case').getRecordTypeId();
            newCase.ContactId = con.Id;
            newCase.Status = 'New';
            newCase.Origin = 'Email';
            newCase.Type = 'Residential BE';
            newCase.SubType__c='Claim';
            newCase.Product_Category__c = 'Fence';
            newCase.Sales_Org__c = '1021';
            newCase.Subject = 'TestCase-1021-Insert';
            newCase.RMA_Number__c = '1234';
            newCase.Restocking_Charged__c = 'Yes';
            newCase.Restocking_Percentage__c = 2.4;
            newCase.RMA_To__c = plantlist.Id;
            newCase.RMA_Freight__c = 2.4;
            newCase.RMAFreightCharged__c = 'No';
            newCase.Ship_Date__c = System.today();
            newCase.Invoice_Number__c = '1234';
            INSERT newCase;
            
            //Asserting insert scenario
			Case insertedCase = [SELECT Id, Sales_org__c, Pricing_Coordinator__r.Name FROM Case WHERE Id =: newCase.Id];

            //Assert.areEqual(JodyUser.Name , insertedCase.Pricing_Coordinator__r.Name,'Pricing Coordinator should be Jody Mischik');
            
            Test.StartTest();
            orderForAccs.LOB__c = '1111';
            update orderForAccs; 
            //insertedCase.Sales_org__c = '1111';
            insertedCase.Subject = 'TestCase-1111-Updated';
            UPDATE insertedCase;
            Test.StopTest();  
            
            // Changing the Salesorg to 1111
            Case updatedCase = [SELECT Id, Subject, RecordTypeId, Pricing_Coordinator__r.Name, Sales_org__c FROM Case WHERE Id =:insertedCase.Id];    
            //Assert.areEqual(jenUser.Name , updatedCase.Pricing_Coordinator__r.Name,'Pricing Coordinator should be Jen Herder');
        } catch(exception e) {
            System.debug('An error occured :: '+e.getMessage());
        }
    }
    @isTest
    static void testupdateRelatedUsersForRMATo(){
        //Plants__c plantlist = [Select Id, Name from Plants__c where Name = 'TEST'];
        Plants__c plantlist1 = [Select Id,Dispatch_Email__c,Dispatch_User__c,Logistics_Coordinator__c, Name from Plants__c LIMIT 1];
        Plants__c plantlist2 = [Select Id,Dispatch_Email__c,Dispatch_User__c,Logistics_Coordinator__c, Name from Plants__c where Dispatch_Email__c = 'rbommareddy11@thresholdcs.com' LIMIT 1];
        Contact con = [SELECT Id From Contact Where LastName='test' limit 1];
        User us =[Select id,Email from User where Email = 'rbommareddy2@thresholdcs.com'limit 1];
        User us2 =[Select id,Email from User where Email = 'rbommareddy@thresholdcs.com'limit 1];
        Case newCase = new Case();
            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('CBI RMA Case').getRecordTypeId();
            newCase.ContactId = con.Id;
            newCase.Status = 'New';
            newCase.Origin = 'Email';
            newCase.Type = 'Residential BE';
            newCase.SubType__c='Claim';
            newCase.Product_Category__c = 'Residential BE';
            newCase.Sales_Org__c = '1501';
            newCase.Subject = 'TestCase-1021-Insert';
            newCase.RMA_Number__c = '1234';
            newCase.Restocking_Charged__c = 'Yes';
            newCase.Restocking_Percentage__c = 2.4;
            newCase.RMA_To__c = plantlist1.Id;
            newCase.RMA_Freight__c = 2.4;
            newCase.RMAFreightCharged__c = 'No';
            newCase.Ship_Date__c = System.today();
            newCase.Invoice_Number__c = '1234';
            newCase.RSM__c = us.Id;
            INSERT newCase;
               
        Case insertedCase = [SELECT Id, Sales_org__c, RMA_To__c, RMA_To__r.Logistics_Coordinator__c, Pricing_Coordinator__r.Name FROM Case WHERE Id =: newCase.Id];
        Test.StartTest();
        insertedCase.RMA_To__c = plantlist2.Id;
        insertedCase.RSM__c = us2.Id;
        update insertedcase;
        Test.StopTest(); 
        Case updatedCase = [SELECT Id, Sales_org__c, RMA_To__c, RMA_To__r.Logistics_Coordinator__c,RMA_To__r.Dispatch_User__c,RMA_To__r.Dispatch_Email__c, Pricing_Coordinator__r.Name FROM Case WHERE Id =: newCase.Id];
        //Assert.areEqual(plantlist2.Logistics_Coordinator__c , updatedCase.RMA_To__r.Logistics_Coordinator__c,'Logistics Coordinator should be Danthony');
        //Assert.areEqual(plantlist2.Dispatch_User__c , updatedCase.RMA_To__r.Dispatch_User__c,'Dispatch_User__c should be Danthony');
        //Assert.areEqual(plantlist2.Dispatch_Email__c , updatedCase.RMA_To__r.Dispatch_Email__c,'Dispatch_Email__c should be Danthony');
       
    }
    @isTest
    static void testPortalCaseAssignment()
    {
       Contact con = [SELECT Id From Contact Where LastName='test' limit 1];
        User us =[Select id,Email from User where Email = 'rbommareddy2@thresholdcs.com'limit 1];
        Plants__c plantlist1 = [Select Id,Dispatch_Email__c,Dispatch_User__c,Logistics_Coordinator__c, Name from Plants__c LIMIT 1];
        Case newCase = new Case();
            newCase.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portal').getRecordTypeId();
            newCase.ContactId = con.Id;
            newCase.Status = 'New';
            newCase.Origin = 'Email';
            newCase.Type = 'Residential BE';
            newCase.SubType__c='Claim';
            newCase.Product_Category__c = 'Gypsum';
            newCase.Sales_Org__c = '1501';
            newCase.Subject = 'TestCase-1021-Insert';
            newCase.RMA_Number__c = '1234';
            newCase.Restocking_Charged__c = 'Yes';
            newCase.Restocking_Percentage__c = 2.4;
            newCase.RMA_To__c = plantlist1.Id;
            newCase.RMA_Freight__c = 2.4;
            newCase.RMAFreightCharged__c = 'No';
            newCase.Ship_Date__c = System.today();
            newCase.Invoice_Number__c = '1234';
            newCase.RSM__c = us.Id;
            Test.StartTest();
            INSERT newCase; 
            Test.StopTest();
    }
}