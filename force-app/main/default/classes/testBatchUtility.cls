//======================================================================
//  Object: testBatchUtility
// Company: CT-SPG
//  Author: Sales Optimizer (John Westenhaver)
// Comment: Tests the batchUtilty class.
//======================================================================
//          Date       Purpose
// Changes: 04/05/2012 Initial version
//======================================================================

@isTest
private class testBatchUtility
{
    public static testmethod void unitTest()
    {
        batchUtility.sendExceptionEmailAllAdmin('Test Email', 'Email Body');
        batchUtility.sendMissingWTUEmail('john.westenhaver@salesoptimizer.com');

        // Create account
        Account a = new Account(Name = 'Test Account', Type = 'Test');
        insert a;
        // Create product
        Product2 p = new Product2();
        p.Name = 'Test';
        p.PROD_TYPE__c = 'F1';
        p.DIV_DESC__c = 'Test';
        insert p;
        
        // create order
        Order o = new Order();
        o.Order_Num__c = 'test';
        o.AccountId = a.Id;
        o.EffectiveDate = System.today();
        o.Status = 'CREDIT HOLD';
        insert o;
        
        // Create invoice
        Invoice__c i = new Invoice__c();
        i.Ship_To_Lookup__c = a.Id;
        i.Sold_To__c = '123';
        i.Invoice_Number__c = '123';
        i.Order_Number__c = '123';
        i.Ship_To__c = '123';
        i.Billing_Date__c = system.today();
        i.Ship_Date__c = system.today();
        i.Order__c = o.Id;
        insert i;
        // Create invoice line item
        Invoice_Line_Item__c ii = new Invoice_Line_Item__c();
        ii.Invoice__c = i.Id;
        ii.Product__c = p.Id;
        ii.Material__c = '123';
        ii.SKU__c = '123';
        insert ii; 
    } 
}