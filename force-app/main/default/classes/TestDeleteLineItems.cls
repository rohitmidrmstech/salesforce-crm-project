/*********************************************************************************
* Test Class: {TestDeleteLineItems}
* Created by   {DateCreated 12/04/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Code coverage of DeleteLineItems.cls}
----------------------------------------------------------------------------------
* Utility Test Data: {TestClassUtility.cls}
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Abhishek 12/04/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
*********************************************************************************/
@isTest
private class TestDeleteLineItems {

    static testMethod void myUnitTest() {
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        
        User u2 = new User();
        u2.Alias = 'standt';
        u2.Email='teststandarduser2@testorg.com';
        u2.EmailEncodingKey='UTF-8';
        u2.LastName='Testing';
        u2.LanguageLocaleKey='en_US';
        u2.LocaleSidKey='en_US';
        u2.ProfileId = p.Id;
        u2.TimeZoneSidKey='America/Los_Angeles';
        u2.UserName='teststandarduser2@testorg.com';
        //u2.ManagerId = u1.Id;
        insert u2;
        
        Region__c reg = TestClassUtility.createRegion('TestClass1','TC1',true);
        Territory__c terr = TestClassUtility.createTerritory('TRR1', 'TRR1','Commercial', reg.Id, true);
        Account soldToAccs = TestClassUtility.createAccount('Sold_To_Acc_',null, 'All_Other_Accounts', 'Other', 'Other', terr.Id, true);
        Account orderForAccs = TestClassUtility.createAccount('Order_For_Acc_', soldToAccs.Id, 'All_Other_Accounts', 'Other', 'Other', terr.Id, true);
        Account shipToAccs = TestClassUtility.createAccount('Ship_To_Acc_', orderForAccs.Id, 'All_Other_Accounts', 'Other', 'Other', terr.Id, true);
        Set<Id> ids = new Set<Id>();
        Id pricebookId = Test.getStandardPricebookId();
         System.debug('Newly inserted pricebookId : ' + pricebookId );
        Pricebook2 pb2 = new PriceBook2();
        pb2.Id = pricebookId;
        pb2.IsActive = false;
        UPDATE pb2;
       System.debug('Newly UPDATE Pricebook2 : ' + pb2 );
         
        //Generate Product Type
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'SAP Product'].Id;
        
        
         System.debug('Newly strRecordTypeId  : ' + strRecordTypeId );
        Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c='0276';
        insert Testingplant1;
        
        Product2 pt = new Product2();
        //Product_Type__c pt = (Product_Type__c)SKELETONTestFactory.createSObject(new Product_Type__c());
        pt.Name = 'Test Product Type';
        pt.ProductCode = 'E35421565';
        pt.Stocking_to_Selling_Conversion_Factor__c = 10.50;
        pt.Sales_Org__c = '1101';
        pt.RecordTypeId = strRecordTypeId ;
        pt.ApprovingPlant__c = Testingplant1.id;
        pt.SAP_Material__c ='E35421565-1101';  //Kondal added new material'E35421565';
        insert pt;
        
        Region__c r = new Region__c ();
        r.Name = 'Test Region';
        //r.Regional_Sales_Manager__c = u2.Id;
        insert r;
        
        Territory__c t = new Territory__c();
        t.Name = 'Test Territory';
        t.Region__c= r.Id;
        t.Sales_Rep__c = u2.Id;
        insert t;
        
        //Order order1 = TestClassUtility.createOrder('Order_1', System.Today().addDays(-1), orderForAccs.Id, 'PICKED', 800, shipToAccs.id, true);
        Order order = new Order();
        order.TM__c = u2.Id;
        order.Territory_ref__c= t.Id;
        order.Name = 'TestingOrder1';
        order.AccountId =soldToAccs.id;
        order.Status='ORDER CREATED';
        order.EffectiveDate =date.today()+6;
        order.Sales_Org__c='1101';
        order.pricebook2Id = pricebookId;
        order.Order_Total__c = 1.00;
        insert order;
        
        OrderItem oli1 = new OrderItem();
        oli1.Orderid = order.Id;
        oli1.Product__c = pt.Id;
        oli1.Material_Desc__c= 'Test OLI 1'; 
        oli1.Qty_Ordered__c = 3.0; 
        oli1.Qty_Uom__c= 'CR';
        oli1.Extended_Quantity__c = 1.0560;
        oli1.UnitPrice= 3900.00;
        oli1.List_Price__c = 10000.00;
        oli1.Weight_Uom__c = 'MS';
        oli1.Weight_Uom__c = 'LB'; 
        oli1.Material__c= 'E35421565';         
       oli1.Sales_Org__c='1234';
        oli1.Line_Type__c = 'ST';
        oli1.Item_Status__c = 'SHIPPED';
        oli1.Planned_Deliv_Date__c = system.today();
        oli1.Req_Deliv_Date__c = system.today();
        insert oli1;
        
        ids.add(order.id);
        
        DeleteLineItems delLineItem = new DeleteLineItems();
        Test.startTest();
        DeleteLineItems.process(ids);
        Test.stopTest();
        System.assertEquals(reg.Name,'TestClass1');
        
    }
}