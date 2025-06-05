@isTest
public class CT_OrderTriggerHandler_Test {
    
    public static testMethod void testMyController() {
       
        Map<String, OrderItem> conditionMaterials = new Map<String, OrderItem>();
        Account acct = new Account(Name='tAccount');
        insert acct;
        
         Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c='0276';
        insert Testingplant1;
         System.debug('Newly inserted Testingplant1: ' + Testingplant1);
         
         //Generate Product Type
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'SAP Product'].Id;
         
          Product2 prodt = new Product2();
        //Product_Type__c pt = (Product_Type__c)SKELETONTestFactory.createSObject(new Product_Type__c());
        prodt.Name = 'Test Product Type';
        prodt.ProductCode = 'E35421565';
        prodt.Stocking_to_Selling_Conversion_Factor__c = 10.50;
        prodt.Sales_Org__c = '1101';
        prodt.RecordTypeId = strRecordTypeId ;
        prodt.ApprovingPlant__c = Testingplant1.id;
        prodt.SAP_Material__c ='E35421565-1101';  //Kondal added new material'E35421565';
        //prodList.add(pt);
        insert prodt;
        
        Contract ct = new Contract();
        ct.AccountId = acct.Id;
        ct.Status = 'Draft';
        ct.StartDate = Date.Today();
        ct.Estimated_Turns_per_Month__c  = '8';
        ct.ContractTerm = 12;
        //insert ct;
        
         Id pricebookId = Test.getStandardPricebookId();
         //List<PricebookEntry> pbe =  [select id,product2Id,pricebook2Id,Product2.Name,PriceBook2.isStandard from PricebookEntry  limit 1];
         List<PricebookEntry> pbe =  [select id,name from PricebookEntry  limit 1];
         system.debug('+++++ pbe @@@'+pbe[0]);
         
         
          Pricebook2 pb2 = new PriceBook2();
        pb2.Id = pricebookId;
        pb2.IsActive = false;
        upsert pb2;
        
        
        Order orderObj = new Order();
        orderObj.Name = '14TPE000001';
        orderObj.AccountId = acct.Id;
        orderObj.EffectiveDate = Date.Today();
        orderObj.Pricebook2Id =pb2.id;
        orderObj.Order_Num__c = '14TPE000001';
        
       // orderObj.ContractId = ct.Id;
        orderObj.Status = 'Draft';
        orderObj.Sales_Org__c='1503';    
        //orderObj.Header_Condition_1__c = '[code] | [description] |10.00';
        orderObj.Header_Condition_1__c = 'ZFS3|Freight Charge|122.20';
        insert orderObj;
        
       
         
         
        
        /*
        orderItem oi1 = new orderItem();
        oi1.orderId = orderObj.id;
        oi1.quantity = 201;
        oi1.unitPrice = 331;
        oi1.Material__c = '90806384451';
        oi1.Sales_Org__c = '1502';
        oi1.PricebookEntryId =pbe[0].id;
        //orderItemList.add(oi1);
        upsert oi1;
        */
        OrderItem oi1 = [SELECT Id, Material__c, Sales_Org__c FROM OrderItem LIMIT 1];
        // conditionMaterials.put(currOrderItem.Material__c+'-'+currOrder.Sales_Org__c, currOrderItem);
        conditionMaterials.put(oi1.Material__c+'-'+orderObj.Sales_Org__c,oi1 );
        system.debug('conditionMaterials####'+conditionMaterials);
        CT_OrderTriggerHandler obj = new CT_OrderTriggerHandler();
        obj.processHeaderString('+++++test',orderObj ,34); 
    }
    
    public static testMethod void testCT_OrderTrigger() {
        Territory__c territory = new Territory__c(Name = 'Test', Territory_Code__c = 'EWEF');
        insert territory;
        
        Map<String, OrderItem> conditionMaterials = new Map<String, OrderItem>();
        Account acct = new Account(Name='tAccount', Finishing_Territory__c = territory.Id);
        insert acct;
        
        Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing2324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c='0276';
        insert Testingplant1;
        
        System.debug('Newly inserted Testingplant1: ' + Testingplant1);
         
        //Generate Product Type
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'SAP Product'].Id;
         
        Product2 prodt = new Product2();
        //Product_Type__c pt = (Product_Type__c)SKELETONTestFactory.createSObject(new Product_Type__c());
        prodt.Name = 'Test Product Type';
        prodt.ProductCode = 'E35421565';
        prodt.Stocking_to_Selling_Conversion_Factor__c = 10.50;
        prodt.Sales_Org__c = '1101';
        prodt.RecordTypeId = strRecordTypeId ;
        prodt.ApprovingPlant__c = Testingplant1.id;
        prodt.SAP_Material__c ='E35421565-1101';  //Kondal added new material'E35421565';
        //prodList.add(pt);
        insert prodt;
        
        Contract ct = new Contract();
        ct.AccountId = acct.Id;
        ct.Status = 'Draft';
        ct.StartDate = Date.Today();
        ct.Estimated_Turns_per_Month__c  = '8';
        ct.ContractTerm = 12;
        //insert ct;
        
        Id pricebookId = Test.getStandardPricebookId();
        //List<PricebookEntry> pbe =  [select id,product2Id,pricebook2Id,Product2.Name,PriceBook2.isStandard from PricebookEntry  limit 1];
        List<PricebookEntry> pbe =  [select id,name from PricebookEntry  limit 1];
        system.debug('+++++ pbe @@@'+pbe[0]);
         
         
        Pricebook2 pb2 = new PriceBook2();
        pb2.Id = pricebookId;
        pb2.IsActive = false;
        upsert pb2;
        
        
        Order orderObj = new Order();
        orderObj.Name = '14TPE000001';
        orderObj.AccountId = acct.Id;
        orderObj.Ship_To__c = acct.Id;
        orderObj.EffectiveDate = Date.Today();
        orderObj.Pricebook2Id =pb2.id;
        orderObj.Order_Num__c = '14TPE000001';
        orderObj.Status = 'Draft';
        orderObj.Sales_Org__c='1501';    
        orderObj.Header_Condition_1__c = 'ZFS3|Freight Charge|122.20';
       
        insert orderObj;
        
        OrderItem oi1 = [SELECT Id, Material__c, Sales_Org__c FROM OrderItem LIMIT 1];
        // conditionMaterials.put(currOrderItem.Material__c+'-'+currOrder.Sales_Org__c, currOrderItem);
        conditionMaterials.put(oi1.Material__c+'-'+orderObj.Sales_Org__c,oi1 );
        system.debug('conditionMaterials####'+conditionMaterials);
        CT_OrderTriggerHandler obj = new CT_OrderTriggerHandler();
        obj.processHeaderString('+++++test',orderObj ,34); 
    }
    
}