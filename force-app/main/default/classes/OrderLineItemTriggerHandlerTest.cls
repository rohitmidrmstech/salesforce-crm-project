/* Kondal # 1/18/2019 # FieldApi has been updated */
@isTest
public class OrderLineItemTriggerHandlerTest {
    
    static testMethod void testprocessItemConditions(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User usr = new User();
        usr.Alias = 'standt';
        usr.Email='teststandarduser2@testorg.com';
        usr.EmailEncodingKey='UTF-8';
        usr.LastName='Testing';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.ProfileId = p.Id;
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.UserName='teststandarduser2@testorg.com';      
        insert usr;
        
        system.debug('*****user****'+usr);
        Account acc= new Account();
        acc.name='test account';
        insert acc;
        system.debug('*****acc****'+acc);
        
        
 Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c = 'test SAP';        
        insert Testingplant1;
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
        Product2 prod = new Product2();       
        prod.Name = 'Test Product';
        prod.ProductCode = '123456';
        prod.SAP_Material__c ='640230-1111';
        prod.Stocking_to_Selling_Conversion_Factor__c = 0.50;
        prod.RecordTypeId =strRecordTypeId;
        prod.Sales_Org__c ='1234';
        prod.ApprovingPlant__c =Testingplant1.id;
        insert prod;
        system.debug('*****prod****'+prod);     
        Region__c region = new Region__c ();
        region.Name = 'Test Region';
        region.Regional_Sales_Manager__c = usr.Id;
        insert region;
        system.debug('*****region****'+region);  
        //Generate Territory
        Territory__c terr = new Territory__c();
        terr.Name = 'Test Territory';
        terr.Region__c= region.Id;
        insert terr;
        system.debug('*****terr****'+terr); 
        
        
        //Generate the JDE_Order_Line_Item__c
        List<OrderItem> olisToInsert = new List<OrderItem>();
        
       // OrderItem oli1 = (OrderItem)SKELETONTestFactory.createSObject(new OrderItem());
       // Pricebook2[]  standardPb = [select id, name, isActive from Pricebook2 where IsStandard = true limit 1];
      
        //PricebookEntry standardPrice = new PricebookEntry();
        //standardPrice.Pricebook2Id = '01sd0000000afMyAAI';
        //standardPrice.Product2Id = prod.Id;
        //standardPrice.UnitPrice = 1;
        //standardPrice.IsActive = true;
        //standardPrice.UseStandardPrice = false;
        //insert standardPrice ;
        
        //Generate the Order
       //Order order = (Order)SKELETONTestFactory.createSObject(new Order());
        Order order = new Order();
        order.TM__c = usr.Id;
        order.Name ='Test Order';
        order.Territory_ref__c= terr.Id;
         order.Sales_Org__c ='1003';
        //order.AccountId = '0013F00000GIvYx';
        order.AccountId=acc.id;
        order.EffectiveDate= date.today();
        order.Status = 'INCOMPLETE';   
        //order.Pricebook2Id = '01sd0000000afMyAAI';
        insert order;
        System.debug('*****Newly inserted Order:**** ' + order);
        
        OrderItem oli1 = new OrderItem();
        oli1.Orderid= order.Id;
        oli1.Product2Id = prod.id;
        oli1.Material_Desc__c= 'Test OLI 1'; 
        oli1.Qty_Ordered__c = 10.0; 
        oli1.Qty_UOM__c = 'CR';      
        oli1.UnitPrice= 3900.00;
        oli1.List_Price__c = 10000.00;
      //  oli1.PricebookEntryId =standardPrice.ID;
        oli1.Weight_Uom__c = 'MS';
        oli1.Weight_Uom__c = 'LB'; 
        oli1.Material__c = '640230-1111';
        oli1.Line_Type__c = 'ST';
        oli1.Extended_Quantity__c=5.0;
        oli1.Item_Condition_1__c = 'ZP00|List Price|200.00|USD|1|MF|3000.00';
        oli1.Item_Condition_2__c = 'ZP01|List Price|-100.00|USD|1|MF|1000.00';
        olisToInsert.add(oli1);
        system.debug('*****olisToInsert****'+olisToInsert); 
        system.debug('*****oli1****'+oli1); 
       // OrderItem oli2 = (OrderItem)SKELETONTestFactory.createSObject(new OrderItem());
        OrderItem oli2 = new OrderItem();
        oli2.Orderid= order.Id;
        oli2.Product2Id = prod.id;
        oli2.Material_Desc__c= 'Test OLI 2'; 
        oli2.Qty_Ordered__c = 20.0; 
        oli2.Qty_UOM__c = 'CR';     
        oli2.UnitPrice= 900.00;
        oli2.List_Price__c = 10000.00;
        oli2.Weight_Uom__c = 'MS';
        oli2.Weight_Uom__c = 'LB'; 
        oli2.Material__c = '640230-1114';
        oli2.Line_Type__c = 'ST';
        oli2.Extended_Quantity__c=10.0;
        oli2.Item_Condition_1__c = 'ZP00|List Price|300.00|USD|1|MF|2000.00';
        oli2.Item_Condition_2__c = 'ZP01|List Price|200.00|USD|1|MF|-500.00';
        olisToInsert.add(oli2);
        system.debug('*****oli2****'+oli2); 
        
 try{
    insert olisToInsert;
    }
    catch (Exception e)
    {
        e.getMessage();
    }
        
        Integer i =0;
        for(OrderItem orderLineItem : [SELECT Id,  Qty_Ordered__c,Extended_Quantity__c,/*Kondal Unit_Price__c,Kondal*/List_Price__c,Extended_Amount__c FROM OrderItem]){
        system.debug('@@@@@'+orderLineItem.Qty_Ordered__c);
        system.debug('@@@@@'+orderLineItem.Extended_Quantity__c);
            system.assertEquals(orderLineItem.Qty_Ordered__c/2, orderLineItem.Extended_Quantity__c);
            system.debug('#####'+orderLineItem.Qty_Ordered__c);
            system.debug('####'+orderLineItem.Extended_Quantity__c);
            if(i==0){
                system.assertEquals(100.00, orderLineItem.UnitPrice);
                system.assertEquals(4000.00, orderLineItem.Extended_Amount__c);
                system.assertEquals(100.00, orderLineItem.List_Price__c);
            }
            else{
                system.assertEquals(500.00, orderLineItem.UnitPrice); 
                system.assertEquals(1500.00, orderLineItem.Extended_Amount__c);
                system.assertEquals(500.00, orderLineItem.List_Price__c);
            }
            i++;
        }
        
    }
    
}