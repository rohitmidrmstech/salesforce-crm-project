/*
 * If Process Builder: Case - Find Sales Rep User Record is activated, the test throws the error:
 * "The record couldn’t be saved because it failed to trigger a flow. 
 * A flow trigger failed to execute the flow with version ID 3014B0000008qcX."
 * Kondal # 1/18/2019 # FieldApi has been updated 
 */

/*
 * Author : Raja Jaswani
 * Date   : 11/02/2020
 * Description : Test Class For AdjustOrderLineItemsController
 * 
*/

@isTest
public class TestAdjustOrderLineItemsController {
    @testSetup static void loadTestData(){
        //Generate User
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        //User u1 = (User)SKELETONTestFactory.createSObject(new User());
        User u1 = new User();
        u1.Alias = 'standt';
        u1.Email='teststandarduser1@testorg.com';
        u1.EmailEncodingKey='UTF-8';
        u1.LastName='Testing';
        u1.LanguageLocaleKey='en_US';
        u1.LocaleSidKey='en_US';
        u1.ProfileId = p.Id;
        u1.TimeZoneSidKey='America/Los_Angeles';
        u1.UserName='teststandarduser1@testorg.com';
        insert u1;
        
        system.debug('Newly inserted User: '+u1);
        //User u2 = (User)SKELETONTestFactory.createSObject(new User());
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
        u2.ManagerId = u1.Id;
        insert u2;
        System.debug('Newly inserted User: ' + u2);
        
        Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c='0276';
        insert Testingplant1;
         System.debug('Newly inserted Testingplant1: ' + Testingplant1);
        
        //order.Pricebook2Id = piceBookObj.Pricebook2Id;
        //
        //UPDATE Standard Price book
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
        
        List<Product2> prodList = new List<Product2>();
        Product2 pt = new Product2();
        //Product_Type__c pt = (Product_Type__c)SKELETONTestFactory.createSObject(new Product_Type__c());
        pt.Name = 'Test Product Type';
        pt.ProductCode = 'E35421565';
        pt.Stocking_to_Selling_Conversion_Factor__c = 10.50;
        pt.Sales_Org__c = '1101';
        pt.RecordTypeId = strRecordTypeId ;
        pt.ApprovingPlant__c = Testingplant1.id;
        pt.SAP_Material__c ='E35421565-1101';  //Kondal added new material'E35421565';
        prodList.add(pt);
        
        Product2 pt1 = new Product2();
        //Product_Type__c pt = (Product_Type__c)SKELETONTestFactory.createSObject(new Product_Type__c());
        pt1.Name = 'Test Product Type1';
        pt1.ProductCode = 'E354215651';
        pt1.Stocking_to_Selling_Conversion_Factor__c = 10.51;
        pt1.Sales_Org__c = '1102';
        pt1.RecordTypeId = strRecordTypeId ;
        pt1.ApprovingPlant__c = Testingplant1.id;
        pt1.SAP_Material__c ='E35421565-1102';  //Kondal added new material'E35421565';
        prodList.add(pt1);
        
        
         Product2 pt2 = new Product2();
        //Product_Type__c pt = (Product_Type__c)SKELETONTestFactory.createSObject(new Product_Type__c());
        pt2.Name = 'Test Product Type3';
        pt2.ProductCode = 'E354215652';
        pt2.Stocking_to_Selling_Conversion_Factor__c = 10.53;
        pt2.Sales_Org__c = '1103';
        pt2.RecordTypeId = strRecordTypeId ;
        pt2.ApprovingPlant__c = Testingplant1.id;
        pt2.SAP_Material__c ='E35421565-1103';  //Kondal added new material'E35421565';
        prodList.add(pt2);
        
        
        insert prodList ;
        system.debug('prodList @@@'+prodList[0]);
        system.debug('prodList @@@'+prodList[1]);
        system.debug('prodList @@@'+prodList[2]);
      
        System.debug('Newly inserted Product Type: ' + [select id,name,Pricebook2Id, PriceBook2.isStandard, PriceBook2.IsActive from PriceBookEntry]);
        
        System.debug('###' + pricebookId);
        //PriceBookEntry pbEntry = [select id,name, Pricebook2Id from PriceBookEntry WHERE Product2Id = :pt.Id LIMIT 1];
        /*pbEntry.Pricebook2Id = pricebookId;
        //pbEntry.Product2Id = pt.id;
        //pbEntry.unitprice  = 50;
        UPSERT pbEntry;*/
        
        //System.debug('pbEntry>>'+ pbEntry);
        

        account a = new account();
        a.name ='+++++Test adjustment order';
        insert a;
        account a1 = new account();
        a1.name ='+++++Test adjustment order1';
        insert a1;
         account a2 = new account();
        a2.name ='+++++Test adjustment order2';
        insert a2;
       System.debug('+++++Newly inserted account   : ' + a);
        //Generate Region
        Region__c r = new Region__c ();
        r.Name = 'Test Region';
        r.Regional_Sales_Manager__c = u2.Id;
        insert r;
           System.debug('+++++Newly inserted region: ' + r);
        //Generate Territory
        Territory__c t = new Territory__c();
        t.Name = 'Test Territory';
        t.Region__c= r.Id;
        t.Sales_Rep__c = u2.Id;
        insert t;
        System.debug('+++++Newly inserted Territory__c : ' + t);
        //Generate the JDE_Order__c
       // Order order = (Order)SKELETONTestFactory.createSObject(new Order());
        List<Order > orderList = new List<Order>();
        Order order = new order();
        order.TM__c = u2.Id;
        order.Territory_ref__c= t.Id;
        order.Name = 'TestingOrder1';
        order.AccountId =a.id;
        order.Status='ORDER CREATED';
        order.EffectiveDate =date.today()+6;
        order.Sales_Org__c='1101';
        order.pricebook2Id = pricebookId;
        order.Order_Total__c = 1.00;
        //order.Ship_To__c = a.Id;
        //order.Sold_To__c = a.Id;
         //insert order;
         orderList.add(order);
        System.debug('+++++Newly inserted Order: ' + orderList[0]);
        Order order1 = new order();
        order1.TM__c = u2.Id;
        order1.Territory_ref__c= t.Id;
        order1.Name = 'TestingOrder2';
        order1.AccountId =a1.id;
        order1.Status='Incomplete';
        order1.EffectiveDate =date.today()+8;
        order1.Sales_Org__c='1101';
        order1.pricebook2Id = pricebookId;
        order1.Order_Total__c=2.00;
        //order1.Ship_To__c = a.Id;
        //order1.Sold_To__c = a.Id;
         //insert order;
         orderList.add(order1);
         System.debug('+++++Newly inserted Order: ' + orderList[1]);  
         
          Order order3 = new order();
        order3.TM__c = u2.Id;
        order3.Territory_ref__c= t.Id;
        order3.Name = 'TestingOrder3';
        order3.AccountId =a2.id;
        order3.Status='Invoiced';
        order3.EffectiveDate =date.today()+10;
        order3.Sales_Org__c='1101';
        order3.pricebook2Id = pricebookId;
        order3.Order_Total__c=6.00;
        //order3.Ship_To__c = a.Id;
        //order3.Sold_To__c = a.Id;
         //insert order;
         orderList.add(order3);
         //insert orderList;
         System.debug('+++++Newly inserted Order: ' + orderList[2]);  
         
         Order order4 = new order();
        order4.TM__c = u2.Id;
        //order4.Territory_ref__c= t.Id;
        order4.Name = 'TestingOrder4';
        order4.AccountId =a2.id;
        order4.Status='Invoiced';
        order4.EffectiveDate =date.today()+10;
        order4.Sales_Org__c='1101';
        order4.pricebook2Id = pricebookId;
        order4.Order_Total__c=6.00;
        //order4.Ship_To__c = a.Id;
        //order4.Sold_To__c = a.Id;
         //insert order;
         orderList.add(order4);
         insert orderList;
         System.debug('+++++Newly inserted Order: ' + orderList[3]);    
        //Generate the JDE_Order_Line_Item__c
        List<OrderItem> olisToInsert = new List<OrderItem >();
        
       // OrderItem oli1 = (OrderItem )SKELETONTestFactory.createSObject(new OrderItem ());
       OrderItem oli1 = new OrderItem();
        oli1.Orderid = orderList[0].Id;
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
        //oli1.PriceBookEntryId = pbEntry.Id;  
        olisToInsert.add(oli1);
        
       // OrderItem oli2 = (OrderItem)SKELETONTestFactory.createSObject(new OrderItem ());
        OrderItem oli2 = new OrderItem();
        oli2.Orderid = orderList[1].Id;
        oli2.Product__c = pt1.Id;
        oli2.Material_Desc__c= 'Test OLI 2'; 
        oli2.Qty_Ordered__c = 11.0; 
        oli2.Qty_Uom__c= 'CR';
        oli2.Extended_Quantity__c = 1.0560;
        oli2.UnitPrice= 900.00;
        oli2.List_Price__c = 10000.00;
        oli2.Weight_Uom__c = 'MS';
        oli2.Weight_Uom__c = 'LB'; 
        oli2.Material__c= 'E354215651';
       oli2.Sales_Org__c='1255';
        oli2.Line_Type__c = 'ST';
       oli2.Item_Status__c  = 'INVOICED';
        oli2.Planned_Deliv_Date__c = system.today()+2;
        oli2.Req_Deliv_Date__c = system.today()+20;
        //oli2.PriceBookEntryId = pbEntry.Id;  
        olisToInsert.add(oli2);
        
       // OrderItem oli3 = (OrderItem )SKELETONTestFactory.createSObject(new OrderItem ());
        OrderItem oli3 = new OrderItem();
        oli3.Orderid = orderList[2].Id;
        oli3.Product__c = pt2.Id;
        oli3.Material_Desc__c= 'Test OLI 3'; 
        oli3.Qty_Ordered__c = 5.0; 
        oli3.Qty_Uom__c= 'CR';
        oli3.Extended_Quantity__c = 1.0560;
        oli3.UnitPrice= 900.00;
        oli3.List_Price__c = 10000.00;
        oli3.Weight_Uom__c = 'MS';
        oli3.Weight_Uom__c = 'LB'; 
        oli3.Material__c= 'E354215652';
        oli3.Sales_Org__c='1235';
       oli3.Item_Status__c  = 'ORDER CREATED';
        oli3.Line_Type__c = 'F';
        oli3.Planned_Deliv_Date__c = system.today()+3;
        oli3.Req_Deliv_Date__c = system.today()+30;
        //oli3.PriceBookEntryId = pbEntry.Id;  
        olisToInsert.add(oli3);
        
        // OrderItem oli4 = (OrderItem )SKELETONTestFactory.createSObject(new OrderItem ());
        OrderItem oli4 = new OrderItem();
        oli4.Orderid= orderList[3].Id;
        oli4.Product__c = pt2.Id;
        oli4.Material_Desc__c= 'Test OLI 4'; 
        oli4.Qty_Ordered__c = 5.0; 
        oli4.Qty_Uom__c= 'CR';
        oli4.Extended_Quantity__c = 1.0560;
        oli4.UnitPrice= 900.00;
        oli4.List_Price__c = 10000.00;
        oli4.Weight_Uom__c = 'MS';
        oli4.Weight_Uom__c = 'LB'; 
        oli4.Material__c= 'E35421565';
        oli4.Sales_Org__c='1235';
       oli4.Item_Status__c  = 'REJECTED';
        oli4.Line_Type__c = 'F';
        oli4.Planned_Deliv_Date__c = system.today()+3;
        oli4.Req_Deliv_Date__c = system.today()+30;
        //oli3.PriceBookEntryId = pbEntry.Id;  
        olisToInsert.add(oli4);
         system.debug('+++++olisToInsert'+olisToInsert);
        try{
            insert olisToInsert;
       }
        catch (Exception e)
    {
        system.debug('++++ error on oli insert :' + e.getMessage());
    }
        system.debug('+++++olisToInsertSize'+olisToInsert.size());
        System.debug('+++++Newly inserted Order Line Items: ' + olisToInsert);
       
          
         System.debug('pricebookId'+pricebookId);
         //Pricebook2[] stdPriceBookRecId = [SELECT Id, isstandard FROM Pricebook2 where IsStandard=true];
        List<PriceBookEntry> pbe = [Select id from PriceBookEntry where Product2Id=:pt.id and Pricebook2Id=:pricebookId LIMIT 1];
        system.debug('+++++test div'+pbe);
        //Generate the Case
        RecordType caseRT = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'Service'];
        Case cse = (Case)SKELETONTestFactory.createSObject(new Case());
        cse.RecordTypeId = caseRT.Id;
        cse.Order__c = order4.Id;
        //cse.Order__c = order.Id;
        insert cse;
        System.debug('+++++Newly inserted Case: ' + cse);
        Adjustment__c adjObj = new Adjustment__c(Case__c=cse.id,Type__c = 'Credit',Adjusted_Amount__c=10);
        insert adjObj;
        //Generate the Adjustment__c
        Adjustment__c adjustment1 = (Adjustment__c)SKELETONTestFactory.createSObject(new Adjustment__c());
        // Adjustment__c adjustment1 = new Adjustment__c();
        adjustment1.Case__c = cse.Id;
        adjustment1.Order__c = oli3.Orderid;
        adjustment1.Order_Line_Item__c = oli3.Id;
        adjustment1.Type__c = 'Credit';
        adjustment1.Adjusted_Amount__c=10;
        insert adjustment1;
        System.debug('Newly inserted Adjustment: ' + adjustment1);
        Test.startTest();
        list<Adjustment__c>listExistingAdjustments = new list<Adjustment__c>();
        listExistingAdjustments.add(adjustment1);
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment1);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
        //myClass.existingAdjustmentsList=listExistingAdjustments;
        System.debug(listExistingAdjustments);
        Test.stopTest();
    }
    
    static List<Adjustment__c> createExistingAdjustments()
    {
        //test.startTest();
        Set<Id> adjustmentIds = new Set<Id>();
        
        Case cse = [SELECT Id FROM Case LIMIT 1];
        list<OrderItem>  oli2= new list<OrderItem> ();
        for(OrderItem  orditm : [SELECT Id, Orderid, UnitPrice,Material_Desc__c , Material__c, List_Price__c, Line_Type__c  FROM OrderItem limit 4])
        {
            if(orditm.Material_Desc__c.contains('Test OLI 2')) 
            {
              oli2.add(orditm );
            }
        }
        
        list<OrderItem>  oli3= new list<OrderItem> ();
        for(OrderItem  orditms : [SELECT Id, Orderid, UnitPrice , Material__c,Material_Desc__c, List_Price__c, Line_Type__c  FROM OrderItem ])
        {
            if(orditms.Material_Desc__c.contains('Test OLI 3')) 
            {
              oli3.add(orditms);
            }
        }
        /* Konda OrderItem oli2 = [SELECT Id, Orderid, UnitPrice , Material__c, List_Price__c, Line_Type__c
                                       FROM OrderItem  WHERE Item_Description__c = 'Test OLI 2'Kondal LIMIT 1];
        OrderItem oli3 = [SELECT Id, Orderid, UnitPrice , Material__c, List_Price__c, Line_Type__c 
                                       FROM OrderItem  WHERE Item_Description__c = 'Test OLI 3' LIMIT 1]; Kondal*/
        if(oli3.size()>0){
        list<Product2> pt = [SELECT Id FROM Product2 WHERE ProductCode = :oli3[0].Material__c LIMIT 1];
        
        
            if(pt.size()>0){
        
         System.debug('oli3==>' + oli3);
        //Generate existing Adjustment__c
        Adjustment__c adjustment1 = (Adjustment__c)SKELETONTestFactory.createSObject(new Adjustment__c());
        adjustment1.Case__c = cse.Id;
        adjustment1.Order__c = oli3[0].orderid;
        adjustment1.Order_Line_Item__c = oli3[0].Id;
        adjustment1.Type__c = 'Credit';
        adjustment1.Additional_Product1__c = pt[0].Id;
        adjustment1.Adjusted_Amount__c = -35100.00;
        adjustment1.Adjusted_Price__c = 3900.00;
        adjustment1.Adjusted_Quantity__c = -9;
        adjustment1.Adjusted_Discount__c = 0.0;
        adjustment1.Unit_PRC__c = oli3[0].UnitPrice ;
        insert adjustment1;
        adjustmentIds.add(adjustment1.Id);
        System.debug('Newly inserted Adjustment: ' + adjustment1);
        
        //Generate existing Adjustment__c
        Adjustment__c adjustment2 = (Adjustment__c)SKELETONTestFactory.createSObject(new Adjustment__c());
        adjustment2.Case__c = cse.Id;
        adjustment2.Order__c = oli2[0].orderid;
        adjustment2.Order_Line_Item__c = oli2[0].Id;
        adjustment2.Type__c = 'Rebill';
        adjustment2.Additional_Product1__c = pt[0].Id;
        adjustment2.Adjusted_Amount__c = 35100.00;
        adjustment2.Adjusted_Price__c = 3900.00;
        adjustment2.Adjusted_Quantity__c = 9;
        adjustment2.Adjusted_Discount__c = 0.0;
        adjustment2.Unit_PRC__c = oli2[0].UnitPrice ;
        insert adjustment2;
        adjustmentIds.add(adjustment2.Id);
        System.debug('Newly inserted Adjustment: ' + adjustment2);
        
        //Generate existing Adjustment__c
        Adjustment__c adjustment3 = (Adjustment__c)SKELETONTestFactory.createSObject(new Adjustment__c());
        adjustment3.Case__c = cse.Id;
        adjustment3.Order__c = oli3[0].Orderid;
        adjustment3.Type__c = 'Rebill';
        adjustment3.Additional_Product1__c = pt[0].Id;
        adjustment3.Adjusted_Amount__c = 35100.00;
        adjustment3.Adjusted_Price__c = 3900.00;
        adjustment3.Adjusted_Quantity__c = 9;
        adjustment3.Adjusted_Discount__c = 0.0;
        adjustment3.Unit_PRC__c = oli3[0].UnitPrice;
        insert adjustment3;
        adjustmentIds.add(adjustment3.Id);
        System.debug('Newly inserted Adjustment: ' + adjustment3);
            
        
        //Generate existing Adjustment__c
        Adjustment__c adjustment4 = (Adjustment__c)SKELETONTestFactory.createSObject(new Adjustment__c());
        adjustment4.Case__c = cse.Id;
        adjustment4.Order__c = oli3[0].Orderid;
        adjustment4.Type__c = 'Rebill';
        adjustment4.Adjusted_Amount__c = 35100.00;
        adjustment4.Additional_Product1__c = pt[0].Id;
        adjustment4.Adjusted_Price__c = 3900.00;
        adjustment4.Adjusted_Quantity__c = 9;
        adjustment4.Adjusted_Discount__c = 0.0;
        adjustment4.Unit_PRC__c = oli3[0].UnitPrice ;
        insert adjustment4;
        adjustmentIds.add(adjustment4.Id);
            
        
        System.debug('Newly inserted Adjustment: ' + adjustment4);
            }
        }
        List<Adjustment__c> existingAdjustmentsList = [SELECT Id, Name, Case__c, Additional_Product1__c, Product_Number__c, Adjusted_Quantity__c, Adjusted_Price__c, 
                   Adjusted_Discount__c, Adjusted_Amount__c, Order__c, Order_Qty__c, EXT_QTY__c, Ext_Amt__c, 
                   QTY_ORD__c, Unit_PRC__c, Conversion_Rate__c, Type__c, Order_Line_Item__c,
                   Order_Line_Item__r.List_Price__c, Order_Line_Item__r.Material__c, Order_Line_Item__r.UnitPrice,
                   Order_Line_Item__r.Line_Type__c
                   FROM Adjustment__c WHERE Id IN :adjustmentIds LIMIT 1];
        //System.debug(existingAdjustmentsList);
        
      //  System.debug(existingAdjustmentsList[1].Order_Line_Item__r.List_Price__c + ' ' + existingAdjustmentsList[1].Order_Line_Item__r.Material__c
          //           + ' ' + existingAdjustmentsList[1].Order_Line_Item__r.UnitPrice + ' ' + existingAdjustmentsList[1].Order_Line_Item__r.Line_Type__c);
          System.debug('@@@@@existingAdjustmentsList'+existingAdjustmentsList.size());
        //test.stopTest(); 
        return existingAdjustmentsList;
            
               
        
    }
    
    @isTest
    public static void testButtons(){
        
        Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Adjustment__c adjustment = [SELECT Id,Order_Line_Item__c,Order_Line_Item__r.Line_Type__c,Order_Line_Item__r.Material__c, Case__c FROM Adjustment__c LIMIT 1];
        //Product2 pt = [SELECT Id FROM Product2 LIMIT 1];
        
        
        Product2 pt = [SELECT Id FROM Product2 LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
        
        myclass.editCredits = false;
        myclass.editRebills = false;
        myclass.firstPage = false;
        myClass.back();
        myClass.next();
        /*myClass.addNewCredit();
        myClass.updateExistingAdjustments();
        myClass.recalculateAllExistingAdjustmentAmounts();
        myClass.recalculateAllExistingAdjustmentAmounts();
        myClass.recalculateExistingRebillUnitPrice();
        Adjustment__c adjustmentTest = [SELECT Id, Case__c,Order_Line_Item__r.UnitPrice,Adjusted_Discount__c FROM Adjustment__c LIMIT 1];  
        list<Adjustment__c>listOfAdjustments = new list<Adjustment__c>();
        listOfAdjustments.add(adjustmentTest);
        myClass.existingAdjustmentsList=listOfAdjustments;
        myClass.recalculateExistingAdjustmentDiscount(listOfAdjustments);
        myClass.cancel();
        myClass.next();
        myClass.back();
        myClass.recalculateCreditAdjustmentDiscount();
        myClass.recalculateRebillAdjustmentDiscount();
        myClass.recalculateCreditUnitPrice();
        myClass.recalculateRebillUnitPrice();
        myClass.recalculateExistingCreditUnitPrice();
        myClass.getWrappersWeCareAbout();
        
        list<AdjustOrderLineItemsController.OLIWrapperClass>ListOfOLIWrapperClass = new list<AdjustOrderLineItemsController.OLIWrapperClass>();
        AdjustOrderLineItemsController.OLIWrapperClass  WrObjTest1 = new AdjustOrderLineItemsController.OLIWrapperClass();
        ListOfOLIWrapperClass.add(WrObjTest1);
        myClass.createNewAdjustments(ListOfOLIWrapperClass);
        myClass.creditWrappers[0].adjustment.Adjusted_Quantity__c = -5;
        myClass.creditWrappers[0].adjustment.Adjusted_Price__c = 5000;
        myClass.creditWrappers[0].adjustment.Adjusted_Discount__c = 50.5;
        myClass.creditWrappers[0].adjustment.Additional_Product1__c = pt.Id;
        myClass.recalculateCreditAdjustmentAmount();
        myClass.createNewAdjustments(myClass.creditWrappers);
        myClass.save();
        List<Adjustment__c> adjustmentList = [SELECT Id, Case__c, Type__c FROM Adjustment__c WHERE Case__c = :myClass.creditWrappers[0].adjustment.Case__c LIMIT 1];
        System.assertEquals(adjustmentList.size(), 1);
        System.assertEquals(myClass.creditWrappers.size(), 1);
		*/
        Test.stopTest();
        
        /*
        Set<Id> adjustmentIds = new Set<Id>();
        Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        list<OrderItem>  oli2= new list<OrderItem> ();
        list<OrderItem>  oli3= new list<OrderItem> ();
        for(OrderItem  orditm : [SELECT Id, Orderid, UnitPrice,Material_Desc__c , Material__c, List_Price__c, Line_Type__c  
                                 FROM OrderItem])
        {
            if(orditm.Material_Desc__c.contains('Test OLI 2')) 	oli2.add(orditm );
            
            if(orditm.Material_Desc__c.contains('Test OLI 3')) oli3.add(orditm);
          
        }
        System.debug('+++++oli3==>' + oli3);
        
        
        list<Product2> pt = [SELECT Id FROM Product2 WHERE ProductCode = :oli3[0].Material__c LIMIT 1];  
         
        
         
        //Generate existing Adjustment__c
        Adjustment__c adjustment1 = (Adjustment__c)SKELETONTestFactory.createSObject(new Adjustment__c());
        adjustment1.Case__c = cse.Id;
        adjustment1.Order__c = oli3[0].orderid;
        adjustment1.Order_Line_Item__c = oli3[0].Id;
        adjustment1.Type__c = 'Credit';
        adjustment1.Additional_Product1__c = pt[0].Id;
        adjustment1.Adjusted_Amount__c = -35100.00;
        adjustment1.Adjusted_Price__c = 3900.00;
        adjustment1.Adjusted_Quantity__c = -9;
        adjustment1.Adjusted_Discount__c = 0.0;
        adjustment1.Unit_PRC__c = oli3[0].UnitPrice ;
        insert adjustment1;
        
        
            adjustmentIds.add(adjustment1.Id);
         
        List<Adjustment__c>  existingAdjustmentList = new list<Adjustment__c>();
        existingAdjustmentList = [SELECT Id, Case__c, Name, Additional_Product1__c, Product_Number__c, Adjusted_Quantity__c, Adjusted_Price__c, 
                                  Adjusted_Discount__c, Adjusted_Amount__c, Order__c, Order_Qty__c, EXT_QTY__c, Ext_Amt__c, 
                                  QTY_ORD__c, Unit_PRC__c, Conversion_Rate__c, Type__c, Order_Line_Item__c,
                                  Order_Line_Item__r.List_Price__c, Order_Line_Item__r.Material__c, Order_Line_Item__r.UnitPrice,
                                  Order_Line_Item__r.Line_Type__c
                                  FROM Adjustment__c WHERE Id IN :adjustmentIds LIMIT 4];
        System.debug(existingAdjustmentList);
        
        PageReference pageRef = Page.AdjustOrderLineItems;
        Test.setCurrentPage(pageRef);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(existingAdjustmentList[0]);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
        myclass.editCredits = false;
        myclass.editRebills = false;
        myclass.firstPage = false;
        myClass.back();
        myClass.next();
        Test.stopTest();
*/
    }
    
    // working
    @isTest
    public static void testAdjustOrderLineItems(){
        Test.startTest();
       
        Case cse = [SELECT Id FROM Case LIMIT 1];
         
        Adjustment__c adjustment = [SELECT Id, Case__c,Name, Additional_Product1__c, Product_Number__c, Adjusted_Quantity__c, Adjusted_Price__c, 
                                   Adjusted_Discount__c, Adjusted_Amount__c, Order__c , Order_Qty__c, EXT_QTY__c, Ext_Amt__c, 
                                   QTY_ORD__c, Unit_PRC__c, Conversion_Rate__c, Type__c, Order_Line_Item__c,
                                   Order_Line_Item__r.List_Price__c, Order_Line_Item__r.Material__c, Order_Line_Item__r.UnitPrice,
                                   Order_Line_Item__r.Line_Type__c FROM Adjustment__c LIMIT 1];  
        list<Adjustment__c>listOfAdjustments = new list<Adjustment__c>();
        listOfAdjustments.add(adjustment);
        Order order = [SELECT Id,Pricebook2Id  FROM Order LIMIT 1];
        system.debug('order working'+order);
       
        PricebookEntry  piceBookObj = [SELECT Id, Pricebook2Id, Product2Id, UnitPrice FROM PricebookEntry limit 1];
        order.Pricebook2Id = piceBookObj.Pricebook2Id;
        if(order != null)
            update order;   
        system.debug('PricebookEntry working'+piceBookObj);
       
        OrderItem oli1 = new OrderItem();
        oli1.Orderid = order.Id;
        //  oli1.Product__c = p1.Id;
        oli1.Material_Desc__c= 'Test OLI 1'; 
        oli1.Qty_Ordered__c = 3.0; 
        oli1.Qty_Uom__c= 'CR';
        oli1.Extended_Quantity__c = 1.0560;
        oli1.UnitPrice= 3900.00;
        oli1.List_Price__c = 10000.00;
        oli1.Weight_Uom__c = 'MS';
        oli1.Weight_Uom__c = 'LB'; 
        oli1.Material__c= 'E35421569'; 
        oli1.PriceBookEntryId = piceBookObj.id;        
        // oli1.Sales_Org__c='1234';
        oli1.Line_Type__c = 'ST';
        
       insert oli1;
           
       
       system.debug('oli1 working'+oli1);
       
     
        List<OrderItem> olis = [SELECT Id, Material_Desc__c, Qty_Ordered__c, Qty_UOM__c, 
                                                Extended_Quantity__c, UnitPrice, List_Price__c, Extended_Amount__c, Weight_Uom__c, 
                                                Material__c FROM OrderItem LIMIT 3];
        system.debug('OrderItem  working'+olis);
        
        
        
        

        list<OrderItem> ol = [SELECT Id,Material_Desc__c, Qty_Ordered__c, Qty_Uom__c, 
                   Extended_Quantity__c, UnitPrice, List_Price__c, Extended_Amount__c, Weight_Uom__c, 
                   Material__c, Price_Uom__c, Line_Type__c,Item_Status__c 
                   FROM OrderItem WHERE Orderid = :order.id ];
      
          system.debug('olis'+olis);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
      
        list<string>listOfTest = new list<string>();
        listOfTest.add('st1');
        listOfTest.add('st2');
   
        list<AdjustOrderLineItemsController.OLIWrapperClass>ListOfOLIWrapperClass = new list<AdjustOrderLineItemsController.OLIWrapperClass>();
        myClass.adjustmentOLIItemNumber=listOfTest;
        myClass.OLIUnitPrice=15.25;
        myClass.oldExistingCreditAdjustmentsList = createExistingAdjustments();
        myClass.oldExistingRebillAdjustmentsList = createExistingAdjustments();  
        myClass.existingAdjustmentsList = createExistingAdjustments();
             
       // myClass.recalculateExistingAdjustmentDiscount();
        
        
        AdjustOrderLineItemsController.OLIWrapperClass  WrObjTest1 = new AdjustOrderLineItemsController.OLIWrapperClass(oli1,false,true,'WrObjTest1');
        AdjustOrderLineItemsController.OLIWrapperClass  WrObjTest2 = new AdjustOrderLineItemsController.OLIWrapperClass(oli1,true,true,'WrObjTest1');
        ListOfOLIWrapperClass.add(WrObjTest1);
        ListOfOLIWrapperClass.add(WrObjTest2);
        try {
            myClass.recalculateAdjustmentDiscount(ListOfOLIWrapperClass);
        }catch(Exception e){}
        myClass.recalculateOLIUnitPrice(ListOfOLIWrapperClass);
        myClass.recalculateExistingAdjustmentAmount(listOfAdjustments);
        myClass.recalculateOLIUnitPrice(listOfAdjustments);
        Product2 pTest = [SELECT Id, ProductCode, Stocking_to_Selling_Conversion_Factor__c FROM Product2 limit 1];
        myClass.wrapperList = ListOfOLIWrapperClass;
        myClass.queryProductType(pTest.id);
        myClass.getWrappersWeCareAbout();
        myClass.createNewAdjustments(ListOfOLIWrapperClass);
        Map<String, Product2> t = AdjustOrderLineItemsController.map_ptList;
      //  myClass.getWrappersWeCareAbout(listOfAdjustments);
        
        
       /* AdjustOrderLineItemsController.OLIWrapperClass w1 = new AdjustOrderLineItemsController.OLIWrapperClass(olis[0], TRUE, TRUE, olis[0].Id);
        AdjustOrderLineItemsController.OLIWrapperClass w2 = new AdjustOrderLineItemsController.OLIWrapperClass(olis[1], TRUE, FALSE, olis[1].Id);
        AdjustOrderLineItemsController.OLIWrapperClass w3 = new AdjustOrderLineItemsController.OLIWrapperClass(olis[2], FALSE, TRUE, olis[2].Id);
        List<AdjustOrderLineItemsController.OLIWrapperClass> wrapperList = new List<AdjustOrderLineItemsController.OLIWrapperClass>();
        wrapperList.add(w1);
        wrapperList.add(w2);
        wrapperList.add(w3);*/
        List<AdjustOrderLineItemsController.OLIWrapperClass> wrapperList = new List<AdjustOrderLineItemsController.OLIWrapperClass>();
        if(wrapperList.size()>0)
        {
        myClass.wrapperList = wrapperList;
        myClass.getWrappersWeCareAbout();
        myClass.wrapperList[1].adjustment.Adjusted_Discount__c = 50.5;
        myClass.wrapperList[2].adjustment.Adjusted_Discount__c = 60.0;
        myClass.wrapperList[1].adjustment.Adjusted_Quantity__c = -10;
        myClass.wrapperList[2].adjustment.Adjusted_Quantity__c = 10;
        myClass.recalculateAllAdjustmentAmounts();
        myClass.recalculateCreditAdjustmentDiscount();
        myClass.recalculateRebillAdjustmentDiscount();
        myClass.recalculateCreditUnitPrice();
        myClass.recalculateRebillUnitPrice();
        PageReference nextPageRef = myClass.next();
        PageReference backPageRef = myClass.back();
        myClass.createNewAdjustments(myClass.wrapperList);
        PageReference savePageRef = myClass.save();
            
            PageReference pref = Page.AdjustOrderLineItems;  
            
            pref.getParameters().put('id',adjustment.id);
           
            Test.setCurrentPage(pref);
           
           
        
        System.debug(myClass.wrapperList);
        List<Adjustment__c> adjustmentList = [SELECT Id, Case__c, Type__c FROM Adjustment__c];
        System.debug(adjustmentList);
        System.debug('Newly Created Adjustments: ' + adjustmentList);
        System.assertEquals(8, adjustmentList.size());
        System.assertEquals(myClass.caseId, cse.Id);
        test.stopTest();     
        }
    }
    
    //working
    @isTest
    public static void testAddManualCreditAdjustment(){
        Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Adjustment__c adjustment = [SELECT Id,Order_Line_Item__c,Order_Line_Item__r.Line_Type__c,Order_Line_Item__r.Material__c, Case__c FROM Adjustment__c LIMIT 1];
        //Product2 pt = [SELECT Id FROM Product2 LIMIT 1];
        
        
        Product2 pt = [SELECT Id FROM Product2 LIMIT 1];
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
            
        myClass.addNewCredit();
        myClass.updateExistingAdjustments();
        myClass.recalculateAllExistingAdjustmentAmounts();
        myClass.recalculateAllExistingAdjustmentAmounts();
        myClass.recalculateExistingRebillUnitPrice();
        Adjustment__c adjustmentTest = [SELECT Id, Case__c,Order_Line_Item__r.UnitPrice,Adjusted_Discount__c FROM Adjustment__c LIMIT 1];  
        list<Adjustment__c>listOfAdjustments = new list<Adjustment__c>();
        listOfAdjustments.add(adjustmentTest);
        myClass.existingAdjustmentsList=listOfAdjustments;
        myClass.recalculateExistingAdjustmentDiscount(listOfAdjustments);
        myClass.cancel();
        myClass.next();
        myClass.back();
        myClass.recalculateCreditAdjustmentDiscount();
        myClass.recalculateRebillAdjustmentDiscount();
        myClass.recalculateCreditUnitPrice();
        myClass.recalculateRebillUnitPrice();
        myClass.recalculateExistingCreditUnitPrice();
        myClass.getWrappersWeCareAbout();
        
        list<AdjustOrderLineItemsController.OLIWrapperClass>ListOfOLIWrapperClass = new list<AdjustOrderLineItemsController.OLIWrapperClass>();
        AdjustOrderLineItemsController.OLIWrapperClass  WrObjTest1 = new AdjustOrderLineItemsController.OLIWrapperClass();
        ListOfOLIWrapperClass.add(WrObjTest1);
        myClass.createNewAdjustments(ListOfOLIWrapperClass);
        myClass.creditWrappers[0].adjustment.Adjusted_Quantity__c = -5;
        myClass.creditWrappers[0].adjustment.Adjusted_Price__c = 5000;
        myClass.creditWrappers[0].adjustment.Adjusted_Discount__c = 50.5;
        myClass.creditWrappers[0].adjustment.Additional_Product1__c = pt.Id;
        myClass.recalculateCreditAdjustmentAmount();
        myClass.createNewAdjustments(myClass.creditWrappers);
        myClass.save();
        List<Adjustment__c> adjustmentList = [SELECT Id, Case__c, Type__c FROM Adjustment__c WHERE Case__c = :myClass.creditWrappers[0].adjustment.Case__c LIMIT 1];
        System.assertEquals(adjustmentList.size(), 1);
        System.assertEquals(myClass.creditWrappers.size(), 1);
        Test.stopTest();
   
    }
    
    @isTest
    public static void testAddManualRebillAdjustment(){
       Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Adjustment__c adjustment = [SELECT Id, Case__c FROM Adjustment__c LIMIT 1];
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
        
        myClass.addNewRebill();
        myClass.rebillWrappers[0].adjustment.Adjusted_Quantity__c = 5;
        myClass.rebillWrappers[0].adjustment.Adjusted_Price__c = 5000;
        myClass.rebillWrappers[0].adjustment.Adjusted_Discount__c = 50.5;
        myClass.recalculateRebillAdjustmentAmount();
        myClass.createNewAdjustments(myClass.rebillWrappers);
        myClass.save();
        List<Adjustment__c> adjustmentList = [SELECT Id, Case__c, Type__c FROM Adjustment__c WHERE Case__c = :myClass.rebillWrappers[0].adjustment.Case__c LIMIT 1];
        System.assertEquals(adjustmentList.size(), 1);
        System.assertEquals(myClass.rebillWrappers.size(), 1);
        Test.stopTest();
        
        
    }
    
    public static testMethod void testRemoveManualCreditAdjustment(){
        Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Adjustment__c adjustment = [SELECT Id, Case__c FROM Adjustment__c LIMIT 1];
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
                
        myClass.addNewCredit();
        myClass.creditWrappers[0].adjustment.Adjusted_Amount__c = -4589.00;
        myClass.creditId = myClass.creditWrappers[0].wrapperid;
        myClass.removeCredit();
        Test.stopTest();
        
        System.assertEquals(myClass.creditWrappers.size(), 0);
    }
    
    public static testMethod void testRemoveManualRebillAdjustment(){
        Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Adjustment__c adjustment = [SELECT Id, Case__c FROM Adjustment__c LIMIT 1];
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
        
        myClass.addNewRebill();
        myClass.rebillWrappers[0].adjustment.Adjusted_Amount__c = 4589.00;
        myClass.rebillId = myClass.rebillWrappers[0].wrapperid;
        PageReference removeRebillRef = myClass.removeRebill();
        Test.stopTest();
        
        System.assertEquals(myClass.rebillWrappers.size(), 0);
    }
    
    public static testMethod void testRemoveAdjustmentCreditOrderLineItem(){
        Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Adjustment__c adjustment = [SELECT Id, Case__c FROM Adjustment__c LIMIT 1];
        Order order = [SELECT Id FROM Order LIMIT 1];
        
        List<OrderItem> olis = [SELECT Id, Material_Desc__c, Qty_Ordered__c, Qty_UOM__c, 
                                                Extended_Quantity__c, UnitPrice, Extended_Amount__c, Weight_Uom__c, 
                                                Material__c FROM OrderItem LIMIT 2];
       if(olis.size()>0){
        
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
            
        myClass.selectOLI(cse.Id);
        
        myClass.wrapperList[0].rebill = FALSE;
        myClass.wrapperList[1].rebill = FALSE;
        myClass.wrapperList[0].credit = TRUE;
        myClass.wrapperList[1].credit = TRUE;
        
        myClass.getWrappersWeCareAbout();
        myClass.creditId = myClass.wrapperList[0].wrapperid;
        myClass.removeCredit();
        Test.stopTest();
        
        System.assertEquals(myClass.creditId, olis[0].id);
        System.assertEquals(myClass.creditWrappers.size(), 1);
        }
    }
    
    public static testMethod void testRemoveAdjustmentRebillOrderLineItem(){
        Test.startTest();
        Case cse = [SELECT Id FROM Case where order__c != null LIMIT 1];
        Adjustment__c adjustment = [SELECT Id, Case__c FROM Adjustment__c LIMIT 1];
        Order order = [SELECT Id FROM Order LIMIT 1];
        List<OrderItem> olis = [SELECT Id, Material_Desc__c, Qty_Ordered__c, Qty_UOM__c, 
                                                Extended_Quantity__c, UnitPrice, Extended_Amount__c,Weight_Uom__c, Item_Status__c,
                                                Material__c FROM OrderItem LIMIT 2];
       if(olis.size()>0){
        
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
            
        myClass.selectOLI(cse.Id);
        myClass.wrapperList[0].rebill = TRUE;
        myClass.wrapperList[1].rebill = TRUE;
        myClass.wrapperList[0].credit = FALSE;
        myClass.wrapperList[1].credit = FALSE;
        myClass.getWrappersWeCareAbout();
        myClass.rebillId = myClass.wrapperList[0].wrapperid;
        myClass.removeRebill();
        Test.stopTest();
        
        System.assertEquals(myClass.rebillId, olis[0].id);
        System.assertEquals(myClass.rebillWrappers.size(), 1);
    }
    }
    
    public static testMethod void testRemoveAdjustOrderLineItems(){
        Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Adjustment__c adjustment = [SELECT Id, Case__c FROM Adjustment__c LIMIT 1];
        Order order = [SELECT Id FROM Order LIMIT 1];
        List<OrderItem> olis = [SELECT Id, Material_Desc__c , Qty_Ordered__c, Qty_UOM__c, 
                                                Extended_Quantity__c, UnitPrice, Extended_Amount__c, Weight_Uom__c, 
                                                Material__c FROM OrderItem LIMIT 2];
        if(olis.size()>0){
        
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
            
        myClass.selectOLI(cse.Id);
        myClass.wrapperList[0].rebill = TRUE;
        myClass.wrapperList[1].rebill = TRUE;
        myClass.wrapperList[0].credit = TRUE;
        myClass.wrapperList[1].credit = TRUE;
        myClass.getWrappersWeCareAbout();
        myClass.rebillId = myClass.wrapperList[0].wrapperid;
        myClass.creditId = myClass.wrapperList[0].wrapperid;
        myClass.removeRebill();
        myClass.removeCredit();
        myClass.creditId = myClass.wrapperList[1].wrapperid;
        myClass.rebillId = myClass.wrapperList[1].wrapperid;
        myClass.removeCredit();
        myClass.removeRebill();
        myClass.cancel();
        
        Test.stopTest();
        
        System.assertEquals(myClass.rebillWrappers.size(), 0);
        System.assertEquals(myClass.creditWrappers.size(), 0);
    }
    }
    public static testMethod void testInvalidCaseId(){
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(new Adjustment__c());
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
        Test.stopTest();
        
        Boolean msg = FALSE;
        for(ApexPages.Message m : ApexPages.getMessages()){
            if(m.getDetail() == myClass.MSG_CASEID_ERROR){
                msg = TRUE;
            }
        }
        
        System.assert(msg);
    }
    @isTest
    public static void testEmptyCreditAndRebillWrappers(){
        Test.startTest();
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Order order = [SELECT Id FROM Order LIMIT 1];
        List<OrderItem> olis = [SELECT Id FROM OrderItem LIMIT 1];
       if(olis.size()>0){
           //WHERE Order_Line_Item__c = :olis[0].Id
        Adjustment__c adjustment = [SELECT Id, Case__c FROM Adjustment__c  LIMIT 1];
        System.debug('Case: ' + cse);
        System.debug('Order: ' + order);
        System.debug('OLIs: ' + olis);
        System.debug('Adjustment: ' + adjustment);
        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(adjustment);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
        
        myClass.next();
        myClass.back();
        Test.stopTest();
                
        System.assertEquals(myClass.creditWrappers.size(), 0);
        System.assertEquals(myClass.rebillWrappers.size(), 0);
        }
    }
    
    public static testMethod void testExistingAdjustments(){
       test.startTest();
        List<Adjustment__c> adjustments = createExistingAdjustments();
        test.stopTest();
        if(adjustments.size()>0)
        {
        Set<Id> adjustmentIds = new Set<Id>();
        for(Adjustment__c a : adjustments){
            adjustmentIds.add(a.Id);
        }
        
        Case cse = [SELECT Id FROM Case LIMIT 1];
        System.debug('Case: ' + cse);
            List<Adjustment__c>  existingAdjustmentList = new list<Adjustment__c>();
            existingAdjustmentList = [SELECT Id, Case__c, Name, Additional_Product1__c, Product_Number__c, Adjusted_Quantity__c, Adjusted_Price__c, 
                                      Adjusted_Discount__c, Adjusted_Amount__c, Order__c, Order_Qty__c, EXT_QTY__c, Ext_Amt__c, 
                                      QTY_ORD__c, Unit_PRC__c, Conversion_Rate__c, Type__c, Order_Line_Item__c,
                                                      Order_Line_Item__r.List_Price__c, Order_Line_Item__r.Material__c, Order_Line_Item__r.UnitPrice,
                                                      Order_Line_Item__r.Line_Type__c
                                                      FROM Adjustment__c WHERE Id IN :adjustmentIds LIMIT 4];
        System.debug(existingAdjustmentList);
        
        if(existingAdjustmentList.size()>0)
        {
        
        Set<Id> existingAdjustmentOrderIds = new Set<Id>();
        Set<Id> existingAdjustmentListOLIIds = new Set<Id>();
        for(Adjustment__c a : existingAdjustmentList){
            if(a.Order__c != null){
                existingAdjustmentOrderIds.add(a.Order__c);
            }
            if(a.Order_Line_Item__c != null){
                existingAdjustmentListOLIIds.add(a.Order_Line_Item__c);
            }
        }
        
        Order order = [SELECT Id FROM Order WHERE Id IN :existingAdjustmentOrderIds LIMIT 1];
        System.debug('Order: ' + order);
        
        List<OrderItem> olis = [SELECT Id FROM OrderItem WHERE Id IN :existingAdjustmentListOLIIds LIMIT 1];
        System.debug('OLIs: ' + olis);
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(existingAdjustmentList[0]);
        AdjustOrderLineItemsController myClass = new AdjustOrderLineItemsController(sc);
        
        adjustments[0].Adjusted_Amount__c = -5873.00;
        adjustments[1].Adjusted_Amount__c = 5873.00;
        adjustments[2].Adjusted_Amount__c = 5873.00;
        
        myClass.recalculateAllExistingAdjustmentAmounts();
        myClass.recalculateExistingAdjustmentDiscount(existingAdjustmentList);
        myClass.recalculateExistingCreditUnitPrice();
        myClass.recalculateExistingRebillUnitPrice();
        myClass.next();
        myClass.back();
            myclass.editCredits = false;
            myclass.editRebills = false;
            myclass.firstPage = false;
        myClass.next();
        myClass.next();
            myclass.editCredits = false;
            myclass.editRebills = false;
            myclass.firstPage = false;
        myClass.back();
        myClass.next();
        myClass.save();
       Test.stopTest();
        
        existingAdjustmentList = [SELECT Id, Case__c, Order__c, Order_Line_Item__c, Adjusted_Amount__c
                                        FROM Adjustment__c 
                                        WHERE Id IN :adjustmentIds LIMIT 4];
        System.debug(existingAdjustmentList);
        
        System.assertEquals(4, myClass.existingAdjustmentsList.size());
        }
        }
    }
    
    
    
}