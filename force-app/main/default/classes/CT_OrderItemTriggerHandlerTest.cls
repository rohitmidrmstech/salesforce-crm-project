/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test for OrderItem object Trigger. 
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Vincent Ip (vip@liquidhub.com)
* @version      1.0
* @created      2017-08-08
*
* NOTE : the Trigger REQUIRES that a Standard Price Book exists. 
* (i.e. any price book marked with the "Is Standard Price Book" check box on)
*/
@isTest
private class CT_OrderItemTriggerHandlerTest {

    // see all data is needed as the trigger testing needs to see the Standard price book entry 
    //  that was created in the setup by the CT_Product2 trigger.  For some odd reason Salesforce
    //  testing does not allow that to be visibile
   
    @isTest(SeeAllData=true)
    static void testTrigger(){
    Test.startTest();
    Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2122324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c ='0276';
        insert Testingplant1;

        Product2 newProduct = new Product2(
            Name = 'Test Product'
            ,ProductCode = '123'
            ,Sales_Org__c = '1'
            ,SAP_Material__c = '123-1'
            ,IsActive = true
            ,ApprovingPlant__c = Testingplant1.id
        );
        insert newProduct;

        // ensure there is a standard price book entry
        List<PriceBookEntry> pbeList = [SELECT Id, PriceBook2.Name 
                                        FROM PriceBookEntry 
                                        WHERE PriceBook2.isStandard = true 
                                        AND Product2Id = :newProduct.Id];
        System.assertNotEquals(0, pbeList.size());


        // create an account
        Account newAccount = new Account(
            Name = 'Test Account'
        );
        insert newAccount;

        // create the new order
        Order newOrder = new Order(
            Name = 'Test Order'
            ,AccountId = newAccount.Id
            ,Sales_Org__c = '1003'
            ,EffectiveDate = Date.today()
            ,Status = 'Draft'
            ,PriceBook2Id = Test.getStandardPricebookId()
            //,Header_Condition_1__c = 'ZENG|Engineering Fees|20.00'
        );
        insert newOrder;

        // create the order line item
        OrderItem newOrderItem = new OrderItem(
            OrderId = newOrder.Id
            ,Quantity = 1
            ,UnitPrice = 1
            ,Material__c = '123'
            ,pricebookEntryId = pbeList[0].id
            ,Reason_Code__c = 'IN'
            ,Sales_Org__c = '1003',
            Item_Condition_1__c = '23'
        );

        insert newOrderItem;
        
       
        //System.assertEquals(pbeList.get(0).Id, newOrderItem.PriceBookEntryId);
        
        newOrderItem = [SELECT Id, PriceBookEntryId, Reason_code__c, Material__c, Item_Condition_1__c, Item_Condition_2__c, Item_Condition_3__c, Item_Condition_4__c,
                        Item_Condition_5__c, Item_Condition_6__c, Item_Condition_7__c, Item_Condition_8__c, Item_Condition_9__c, Item_Condition_10__c,
                        Quantity from OrderItem where Id = :newOrderItem.Id];
        newOrderItem.Reason_code__c = 'IN';
        
        update newOrderItem;
       
        List<OrderItem> orderItemLst = new List<OrderItem>();
        orderItemLst.add(newOrderItem );
        
        CT_OrderItemTriggerHandler CT_OrderObj = new CT_OrderItemTriggerHandler();
        CT_OrderObj.beforeInsertHandler(orderItemLst);
        CT_OrderObj.beforeUpdateHandler(orderItemLst);
        Test.stopTest();
    }
    
    @isTest(SeeAllData=true)
    static void testTrigger1(){
    Test.startTest();
    Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2122324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c ='0276';
        insert Testingplant1;

        Product2 newProduct = new Product2(
            Name = 'Test Product'
            ,ProductCode = '123'
            ,Sales_Org__c = '1'
            ,SAP_Material__c = '123-1'
            ,IsActive = true
            ,ApprovingPlant__c = Testingplant1.id
        );
        insert newProduct;

        // ensure there is a standard price book entry
        List<PriceBookEntry> pbeList = [SELECT Id, PriceBook2.Name 
                                        FROM PriceBookEntry 
                                        WHERE PriceBook2.isStandard = true 
                                        AND Product2Id = :newProduct.Id];
        System.assertNotEquals(0, pbeList.size());


        // create an account
        Account newAccount = new Account(
            Name = 'Test Account'
        );
        insert newAccount;

        // create the new order
        Order newOrder = new Order(
            Name = 'Test Order'
            ,AccountId = newAccount.Id
            ,Sales_Org__c = '1003'
            ,EffectiveDate = Date.today()
            ,Status = 'Draft'
            ,PriceBook2Id = Test.getStandardPricebookId()
            //,Header_Condition_1__c = 'ZENG|Engineering Fees|20.00'
        );
        insert newOrder;

        // create the order line item
        OrderItem newOrderItem = new OrderItem(
            OrderId = newOrder.Id
            ,Quantity = 1
            ,UnitPrice = 1
            ,Material__c = '123'
            ,pricebookEntryId = pbeList[0].id
            ,Reason_Code__c = 'NA'
            ,Sales_Org__c = '1003'
        );

        insert newOrderItem;
        
       
        //System.assertEquals(pbeList.get(0).Id, newOrderItem.PriceBookEntryId);
        
        newOrderItem = [SELECT Id, PriceBookEntryId, Reason_code__c, Material__c, Item_Condition_1__c, Item_Condition_2__c, Item_Condition_3__c, Item_Condition_4__c,
                        Item_Condition_5__c, Item_Condition_6__c, Item_Condition_7__c, Item_Condition_8__c, Item_Condition_9__c, Item_Condition_10__c,
                        Quantity from OrderItem where Id = :newOrderItem.Id];
        newOrderItem.Reason_code__c = 'NA';
        
        update newOrderItem;
       
        List<OrderItem> orderItemLst = new List<OrderItem>();
        orderItemLst.add(newOrderItem );
        
        CT_OrderItemTriggerHandler CT_OrderObj = new CT_OrderItemTriggerHandler();
        CT_OrderObj.beforeInsertHandler(orderItemLst);
        CT_OrderObj.beforeUpdateHandler(orderItemLst);
        Test.stopTest();
    }
   
   
}