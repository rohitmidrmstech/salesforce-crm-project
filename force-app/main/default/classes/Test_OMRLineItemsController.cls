@isTest
private class Test_OMRLineItemsController {
   @testSetup
   private static void testSetupMethod(){
        
        Account accountRecord = new Account();
        accountRecord.Name = 'TestAccount';
        INSERT accountRecord ;
        
        Case caseRecord = new Case();
        caseRecord.AccountId = accountRecord.id;
        caseRecord.Subject = 'TestCase';
        caseRecord.Campaign__c = 'MECH';
        INSERT caseRecord;
        
       product2 productRecord = new product2();
       productRecord.Name = ' TestProduct1';
       productRecord.ProductCode = '12345';
       productRecord.Description = 'This is product Test';
       productRecord.Item_Class__c = ' Test Prodcut';
       productRecord.Item_Class_Description__c = ' Test Description';
       INSERT productRecord ;
       
        
        product2 productRecord1 = new product2();
        productRecord1.Name = ' TestProduct';
        productRecord1.ProductCode = 'p12345';
        productRecord1.Description = 'Test Product';
        productRecord1.Item_Class_Description__c = ' Test class';
        productRecord1.Item_Class__c =  ' Test Prodcut1';
        INSERT productRecord1 ;
        
        Order_Mgmt_Request_Item__c orderRequestRecord = new Order_Mgmt_Request_Item__c();
        orderRequestRecord.Item__c = productRecord1.id;
        orderRequestRecord.Invoice__c = 23455;
        orderRequestRecord.OM_Request__c = caseRecord.id;
        orderRequestRecord.Suggested__c = 12345;
        orderRequestRecord.Quantity__c = 123456; 
        orderRequestRecord.Warehouse_Rec_d__c = 23456;
        orderRequestRecord.Warehouse_Acpt__c = 2345;
        INSERT orderRequestRecord ;
        
        
    }
    private static testMethod  void omrLineMethod(){
       System.debug('in omrLineMethod');
      

        
        List<Case> caseRecordList = new List<Case>([SELECT id, Accountid, Subject, Campaign__c FROM case]);
        List<product2> productRecordList = new List<product2>([SELECT Id, Name, ProductCode, Description, Item_Class__c, Item_Class_Description__c FROM Product2 ]);
        System.debug('productRecordList ###'+ productRecordList);
        ApexPages.currentPage().getParameters().put('id',caseRecordList[0].id);
        Apexpages.StandardController stdController = new Apexpages.StandardController(caseRecordList[0]);
     
        OMRLineItemsController omrLineItemObject = new OMRLineItemsController(stdController);
        List<Order_Mgmt_Request_Item__c> orderMgmtRecord = new List<Order_Mgmt_Request_Item__c>([SELECT Id,Item__c, Promo_No__c, OM_Request__c, Warehouse_Acpt__c, Warehouse_Rec_d__c, Invoice__c, Suggested__c, Quantity__c FROM Order_Mgmt_Request_Item__c
                                                                                                 where Item__c  =: productRecordList[0].id]);
        omrLineItemObject.addRow();
        omrLineItemObject.indexNum = 0;
        omrLineItemObject.productId = productRecordList[0].id;
         
        omrLineItemObject.setSelectedProduct();
        omrLineItemObject.saveRecords();
           
       
        
    }

}