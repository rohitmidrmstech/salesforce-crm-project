@isTest
private class Test_aiInvoiceLineItem {
    
    public static testmethod void DoTest(){
        
        
        // create account
        Account a = new Account();
        
        a.Name = 'Test3';
        a.LOB__c = '1502';
        
        insert a;
        
        // Create product
        Product2 p = new Product2();
        
        p.Name = 'Test';
        p.Family = 'F1';
        p.DIV_DESC__c = 'Test'; 
        
        insert p;
        order ord = new order();
        ord.Name = 'test';
        ord.status ='SHIPPED';
        ord.EffectiveDate =  Date.parse('12/15/21');
        ord.AccountId = a.Id;
        insert ord;
        // create invoice
        Invoice__c i = new Invoice__c();
        
        i.Ship_To_Lookup__c = a.Id;
        i.Sold_To__c = '123';
        i.Invoice_Number__c = '123';
        i.Order_Number__c = '123';
        i.Ship_To__c = '123';
        i.Billing_Date__c = system.today();
        i.Ship_Date__c = system.today();
        i.Order__c = ord.id;
        insert i;
        
        
        // create invoice item
        
        Invoice_Line_Item__c ii = new Invoice_Line_Item__c();
        
        ii.Invoice__c = i.Id;
        ii.Product__c = p.Id;
        ii.Material__c = '123';
        ii.SKU__c = '123';
        
        insert ii;
        
        
        for(Product2 pp : [Select Id, Family From Product2 Where Id = : p.Id Limit 1]){
            pp.Family = 'Test2';
            
            update pp;
        }
        
        ii = new Invoice_Line_Item__c();
        
        ii.Invoice__c = i.Id;
        ii.Product__c = p.Id;
        ii.Material__c = '1234';
        ii.SKU__c = '1234' ;
        
        insert ii;
        
    }
    
    
    public static testmethod void DoTest2(){
        
        
        // create account
        Account a = new Account();
        
        a.Name = 'Test3';
        
        insert a;
        
        // Create product
        Product2 p = new Product2();
        
        p.Name = 'Test';
        p.Family = 'F1';
        p.DIV_DESC__c = 'Test';
        
        insert p;
        order ord = new order();
        ord.Name = 'test';
        ord.status ='SHIPPED';
        ord.EffectiveDate =  Date.parse('12/15/21');
        ord.AccountId = a.Id;
        insert ord;
        
        // create invoice
        Invoice__c i = new Invoice__c();
        
        i.Ship_To_Lookup__c = a.Id;
        i.Sold_To__c = '123';
        i.Invoice_Number__c = '123';
        i.Order_Number__c = '123';
        i.Ship_To__c = '123';
        i.Billing_Date__c = system.today();
        i.Ship_Date__c = system.today();
        i.Order__c = ord.id;
        insert i;
        
        
        // create invoice item
        
        Invoice_Line_Item__c ii = new Invoice_Line_Item__c();
        
        ii.Invoice__c = i.Id;
        ii.Product__c = p.Id;
        ii.Material__c = '123';
        ii.SKU__c = '123';
        
        insert ii;
        
        
    } 
}