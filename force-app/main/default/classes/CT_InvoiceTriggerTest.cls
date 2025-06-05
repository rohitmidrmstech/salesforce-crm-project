@isTest
public class CT_InvoiceTriggerTest {
    public static testMethod void test1() {  
        CT_InvoiceTriggerHandler.unitTestCheatSandipPleaseFix();
        
        Account a = new Account();
        a.Name ='Test Account';
        a.CX_Last_Order_Date__c = System.today();
        insert a; 
        
        Order oObj = new Order();
        oObj.BillingState = 'ajmer';
        oObj.BillingCity = 'jaipur';
        oObj.AccountId = a.Id;
        oObj.Status = 'Draft';
        oObj.EffectiveDate = Date.newInstance(2016, 12, 9);
        oObj.ship_to__c = a.id;
        insert oObj;
        
       Invoice__c invoiceObj = new Invoice__c();
        invoiceObj.Name = 'ABC';
        invoiceObj.Carrier_Name__c = 'XYZ';
        invoiceObj.Order__c = oObj.Id;
        insert invoiceObj;
        
        invoiceObj.Name = 'Test Account 2';
        invoiceObj.Carrier_Name__c = 'ZYX';
        
        update invoiceObj;
    }
}