/* Kondal # 1/18/2019 # FieldApi has been updated */
@isTest
public class DisplayOrderLineItemsControllerTest {
    public static void loadTestData(){
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
        
        //Generate Product Type
        /* START : Commented by Purnima for Story S-488381
        Product_Type__c pt = new Product_Type__c();
        //Product_Type__c pt = (Product_Type__c)SKELETONTestFactory.createSObject(new Product_Type__c());
        pt.Name = 'Test Product Type';
        pt.Product_Type_Code__c = 'E35421565';
        pt.Stocking_to_Selling_Conversion_Factor__c = 10.50;
        insert pt;
        System.debug('Newly inserted Product Type: ' + pt);
        END : Commented by Purnima for Story S-488381*/
        
         Id pricebookId = Test.getStandardPricebookId();
         
      Plants__c  Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing232434345';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c='0402';
        insert Testingplant1;
        
         String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
        Product2 prod = new Product2();       
        prod.Name = 'Test Product';
        prod.ProductCode = '123456';
        prod.SAP_Material__c ='E35421565';
        prod.Stocking_to_Selling_Conversion_Factor__c = 0.50;
        prod.RecordTypeId =strRecordTypeId;
        prod.ApprovingPlant__c = Testingplant1.Id;
        
        insert prod;
        
        PricebookEntry pbEntry = new PricebookEntry();
         pbEntry.Pricebook2Id = pricebookId;
         pbEntry.Product2Id = prod.Id;
         pbEntry.UnitPrice = 150000.00;
         pbEntry.IsActive = true;
         try{
         insert pbEntry;
         }
         catch (DMLException e) {}

        //Generate Region
        Region__c r = new Region__c ();
        r.Name = 'Test Region';
        r.Regional_Sales_Manager__c = u2.Id;
        insert r;

        //Generate Territory
        Territory__c t = new Territory__c();
        t.Name = 'Test Territory';
        t.Region__c= r.Id;
        insert t;

        Account a3 = new account();
        a3.name ='Test Acc11';        
        insert a3;
        //Generate the JDE_Order__c
       // Order order = (Order)SKELETONTestFactory.createSObject(new Order());
        Order order = new Order();
        order.TM__c = u2.Id;
        order.Territory_ref__c= t.Id;
        order.Name ='Testing';
        order.AccountId =a3.Id;
        order.EffectiveDate =date.today();
        order.Status ='ORDER CREATED';
        order.Sales_Org__c='1234';
        order.Order_Num__c ='2345234';
      
        insert order;
        System.debug('Newly inserted Order: ' + order);
                
        //Generate the JDE_Order_Line_Item__c
        List<OrderItem> olisToInsert = new List<OrderItem>();
        
       // OrderItem  oli1 = (OrderItem )SKELETONTestFactory.createSObject(new OrderItem ());
        OrderItem  oli1 = new OrderItem();
        oli1.Orderid = order.Id;
        oli1.Material_Desc__c= 'Test OLI 1'; 
        oli1.Qty_Ordered__c = 3.0; 
        oli1.Qty_Uom__c = 'CR';
        oli1.Extended_Quantity__c = 1.0560;
        oli1.UnitPrice= 3900.00;
        oli1.List_Price__c = 10000.00;
        oli1.Volume_UOM__c = 'PC';
        oli1.Weight_Uom__c = 'LB'; 
        oli1.Material__c= 'E35421565';
        oli1.Line_Type__c = 'ST';
        oli1.EndDate = date.today()+5;
        oli1.Item_Status__c ='ORDER CREATED';
        oli1.PriceBookEntryId=pbEntry.id;
        //olisToInsert.add(oli1);
        try{
        insert oli1;
        }
        catch (DMLException e) {}
        
        //START : Commented by Purnima for Story S-488381
        /*JDE_Order_Line_Item__c oli2 = (JDE_Order_Line_Item__c)SKELETONTestFactory.createSObject(new JDE_Order_Line_Item__c());
        oli2.JDE_Order__c = order.Id;
        oli2.Item_Description__c = 'Test OLI 2'; 
        oli2.Quantity_Ordered__c = 11.0; 
        oli2.Quantity_UOM__c = 'CR';
        oli2.Extended_Quantity__c = 1.0560;
        oli2.Unit_Price__c = 900.00;
        oli2.List_Price__c = 10000.00;
        oli2.Volume_UOM__c = 'MS';
        oli2.Weight_UOM__c = 'LB'; 
        oli2.Item_Number__c = 'E35421565';
        oli2.Line_Type__c = 'ST';
        olisToInsert.add(oli2);
        
        JDE_Order_Line_Item__c oli3 = (JDE_Order_Line_Item__c)SKELETONTestFactory.createSObject(new JDE_Order_Line_Item__c());
        oli3.JDE_Order__c = order.Id;
        oli3.Item_Description__c = 'Test OLI 3'; 
        oli3.Quantity_Ordered__c = 5.0; 
        oli3.Quantity_UOM__c = 'CR';
        oli3.Extended_Quantity__c = 1.0560;
        oli3.Unit_Price__c = 900.00;
        oli3.List_Price__c = 10000.00;
        oli3.Volume_UOM__c = 'MS';
        oli3.Weight_UOM__c = 'LB'; 
        oli3.Item_Number__c = 'E35421565';
        oli3.Line_Type__c = 'F';
        olisToInsert.add(oli3);*/
        //END : Commented by Purnima for Story S-488381
        
        //insert olisToInsert;
        //System.debug('Newly inserted Order Line Items: ' + olisToInsert);
        
        //Generate the Case
        RecordType caseRT = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'Service'];
        //Case cse = (Case)SKELETONTestFactory.createSObject(new Case());
        Case cse = new case();
        cse.RecordTypeId = caseRT.Id;
        cse.Order__c= order.Id;
        insert cse;
        System.debug('Newly inserted Case: ' + cse);
       
    }
    
    public static testMethod void testOrderLineItemsExistPositive(){
        loadTestData();
        
        Case cse = [SELECT Id FROM Case LIMIT 1];
        Order order = [SELECT Id FROM Order LIMIT 1];
        List<OrderItem > olis = [SELECT Id, Material_Desc__c, Qty_Ordered__c, Qty_Uom__c,
                                             Extended_Quantity__c,  unitprice, List_Price__c, Extended_Amount__c, 
                                              Weight_Uom__c, Material__c
                                             FROM OrderItem LIMIT 3];
        
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(cse);
        DisplayOrderLineItemsController myClass = new DisplayOrderLineItemsController(sc);
        Test.stopTest();
        
        //System.assertEquals(1, myClass.wrapperList.size());        //Modified by Purnima for Story S-488381
    }
    
    public static testMethod void testOrderLineItemsExistNegative(){
        RecordType caseRT = [SELECT Id FROM RecordType WHERE RecordType.DeveloperName = 'Service'];

        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(new Case(RecordTypeId = caseRT.Id));
        DisplayOrderLineItemsController myClass = new DisplayOrderLineItemsController(sc);
        Test.stopTest();
        
        for(ApexPages.Message msg : ApexPages.getMessages()){
            System.assertEquals('No Case record found for Case with Id: null', msg.getSummary());
        }
        
        System.assertEquals(0, myClass.wrapperList.size());
    }
}