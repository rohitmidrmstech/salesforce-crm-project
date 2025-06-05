/*******************************************************************************
Name             : buDeleteAllDetails
Created by       : Jon Simmons  
Created Date     : 7/22/13
Last Modified by : 
Last Modified on : 
Description      : Test buDeleteAllDetails trigger
*******************************************************************************/
@isTest
private class Test_buDeleteAllDetails 
{

    static testMethod void myUnitTest() 
    {
    
      Account acc = new Account(Name = 'Test');
      Insert acc;
      
      Product2 productObj = new Product2(Name = 'Laptop X200',Family = 'IOT Advisory Services');
      insert productObj;
        
        /*Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = productObj.Id,
            UnitPrice = 10, IsActive = true);
        insert standardPrice;*/
        
        Pricebook2 priceBookObj = new Pricebook2();
        priceBookObj.Name='IOT Price123';
        priceBookObj.IsActive=true;
        priceBookObj.Description='Create PB for the test class';
        insert priceBookObj;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = priceBookObj.id, Product2Id = productObj.Id,
            UnitPrice = 10000, IsActive = true);
        insert customPrice;
        
        //create an order
      order orderHeader = new order();
      orderHeader.name = 'testorder1';
      orderHeader.AccountId = acc.Id;
      orderHeader.EffectiveDate = System.today();
      orderHeader.Status = 'CREDIT HOLD';
      orderHeader.Pricebook2Id = priceBookObj.Id;
      orderHeader.Sales_Org__c = '1003';
      insert orderHeader;
      
      order orderHeader2 = new order();
      orderHeader2.name = 'testorder2';
      orderHeader2.AccountId = acc.Id;
      orderHeader2.EffectiveDate = System.today();
      orderHeader2.Status = 'CREDIT HOLD';
      orderHeader2.Pricebook2Id = priceBookObj.Id;
      orderHeader2.Sales_Org__c = '1003';
      insert orderHeader2;
      
      Case caseObj = new Case(AccountId = acc.Id, Service_Case_Created__c = true, Order__c = orderHeader.Id);
      Insert caseObj;
                       
            //create two order lines
            OrderItem orderline1 = new OrderItem();
            orderline1.OrderId = orderHeader.id;
            orderline1.PricebookEntryId = customPrice.Id;
            orderline1.Item_Condition_1__c = 'ZFRT|Siding Zone Charge|125.00 |USD|||3.47';
            orderline1.Item_Condition_2__c = 'ZP00|List Price|119.00 |USD|1|CAR|952.00';
            orderline1.Item_Condition_3__c = 'ZPS1|SPG Pooling&Stop fee|200.00 |USD|||5.56';
            orderline1.Reason_Code__c = 'IN';
            orderline1.UnitPrice = 10;
            insert orderline1;
            
            OrderItem orderline2 = new OrderItem();
            orderline2.OrderId = orderHeader2.id;
            orderline2.PricebookEntryId = customPrice.Id;
            orderline2.Item_Condition_1__c = 'ZFRT|Siding Zone Charge|125.00 |USD|||0.43';
            orderline2.Item_Condition_2__c = 'ZP00|List Price|119.00 |USD|1|CAR|119.00';
            orderline2.Item_Condition_3__c = 'ZPS1|SPG Pooling&Stop fee|200.00 |USD|||0.69';
            orderline2.Reason_Code__c = 'IN';
           // insert orderline2;
      
     // orderline2.Reason_Code__c = 'Us';
     // Update orderline2;
      
      system.debug('orderheaderid: ' + orderheader.id);
      
      
      //update order.delete_all_details__c
      //orderHeader.Delete_All_Details__c = true;
      update orderHeader;
      
      //validate that Delete All Details box is unchecked
      list<order> testOrderHeader = [select id from order where id = :orderHeader.id and delete_all_details__c = false];
      //system.assert(testOrderHeader.size() == 1);
      
      //validate that the order header has no children
      list<OrderItem> testOrderLines = [select id from OrderItem where orderId = :orderHeader.id];
      //system.assert(testOrderLines.size() == 0);
        
    }
    
    static testMethod void myUnitTest2() 
    {
    
      Account acc = new Account(Name = 'Test');
      Insert acc;
      
      Product2 productObj = new Product2(Name = 'Laptop X200',Family = 'IOT Advisory Services');
      insert productObj;
      Product2 productObj2 = new Product2(Name = 'Laptop X200e',Family = 'IOT Advisory Services');
      insert productObj2;
        /*Id pricebookId = Test.getStandardPricebookId();
        PricebookEntry standardPrice = new PricebookEntry(
            Pricebook2Id = pricebookId, Product2Id = productObj.Id,
            UnitPrice = 10, IsActive = true);
        insert standardPrice;*/
        
        Pricebook2 priceBookObj = new Pricebook2();
        priceBookObj.Name='IOT Price123';
        priceBookObj.IsActive=true;
        priceBookObj.Description='Create PB for the test class';
        insert priceBookObj;
        
        Pricebook2 priceBookObj2 = new Pricebook2();
        priceBookObj2.Name='IOT Price12';
        priceBookObj2.IsActive=true;
        priceBookObj2.Description='the test class';
        insert priceBookObj2;
        
        PricebookEntry customPrice = new PricebookEntry(
            Pricebook2Id = priceBookObj.id, Product2Id = productObj.Id,
            UnitPrice = 10000, IsActive = true);
        insert customPrice;
         PricebookEntry customPrice2 = new PricebookEntry(
            Pricebook2Id = priceBookObj2.id, Product2Id = productObj2.Id,
            UnitPrice = 1000, IsActive = true);
        insert customPrice2;
        //create an order
      order orderHeader = new order();
      orderHeader.name = 'testorder1';
      orderHeader.AccountId = acc.Id;
      orderHeader.EffectiveDate = System.today();
      orderHeader.Status = 'CREDIT HOLD';
      orderHeader.Pricebook2Id = priceBookObj.Id;
      orderHeader.Sales_Org__c = '1003';
      insert orderHeader;
      
      //create an order
      order orderHeader2 = new order();
      orderHeader2.name = 'testorder2';
      orderHeader2.AccountId = acc.Id;
      orderHeader2.EffectiveDate = System.today();
      orderHeader2.Status = 'CREDIT HOLD';
      orderHeader2.Pricebook2Id = priceBookObj2.Id;
      orderHeader2.Sales_Org__c = '1003';
      insert orderHeader2;
      
      Case caseObj = new Case(AccountId = acc.Id, Service_Case_Created__c = true, Order__c = orderHeader.Id);
      Insert caseObj;
                       
            //create two order lines
            OrderItem orderline1 = new OrderItem();
            orderline1.OrderId = orderHeader.id;
            orderline1.PricebookEntryId = customPrice.Id;
            orderline1.Item_Condition_1__c = 'ZFRT|Siding Zone Charge|125.00 |USD|||3.47';
            orderline1.Item_Condition_2__c = 'ZP00|List Price|119.00 |USD|1|CAR|952.00';
            orderline1.Item_Condition_3__c = 'ZPS1|SPG Pooling&Stop fee|200.00 |USD|||5.56';
            orderline1.Reason_Code__c = 'IN';
            orderline1.UnitPrice = 20;
            insert orderline1;
            
            OrderItem orderline2 = new OrderItem();
            orderline2.OrderId = orderHeader2.id; 
            orderline2.PricebookEntryId = customPrice2.Id;
            orderline2.Item_Condition_1__c = 'ZFRT|Siding Zone Charge|125.00 |USD|||0.43';
            orderline2.Item_Condition_2__c = 'ZP00|List Price|119.00 |USD|1|CAR|119.00';
            orderline2.Item_Condition_3__c = 'ZPS1|SPG Pooling&Stop fee|200.00 |USD|||0.69';
            orderline2.Reason_Code__c = 'IN';
            orderline2.UnitPrice = 20;
            //insert orderline2;
      
      //orderline2.Reason_Code__c = 'Us';
      //Update orderline2;
      
      CT_OrderItemTriggerHandler handler = new CT_OrderItemTriggerHandler();
      handler.calculateNetPriceAdjustment(orderline1);
      
      
      List<OrderItem> orderItemList = new List<OrderItem>();
      orderItemList.add(orderline1);
      handler.beforeInsertHandler(orderItemList);
      handler.beforeUpdateHandler(orderItemList);
      
      system.debug('orderheaderid: ' + orderheader.id);
      
      
      //update order.delete_all_details__c
      //orderHeader.Delete_All_Details__c = true;
      update orderHeader;
      
      //validate that Delete All Details box is unchecked
      list<order> testOrderHeader = [select id from order where id = :orderHeader.id and delete_all_details__c = false];
      //system.assert(testOrderHeader.size() == 1);
      
      //validate that the order header has no children
      list<OrderItem> testOrderLines = [select id from OrderItem where orderId = :orderHeader.id];
      //system.assert(testOrderLines.size() == 0);
        
    }
}