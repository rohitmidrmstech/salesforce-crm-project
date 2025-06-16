// ==================================================================================
//   Object: TestCaseUtil
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Sample data creation methods 
// ==================================================================================
//  Changes: 2013-04-29 Initial version.
// ==================================================================================

public with sharing class TestCaseUtil {
    
    public static User sampleUser() {
        Profile profileUsed;
        String ret = 'word' + math.rint(math.random() * 100000);
        for( Profile p : [ Select Id, PermissionsModifyAllData, Name from Profile WHERE PermissionsModifyAllData = true limit 100 ] ){
             if( p.PermissionsModifyAllData ){
                 profileUsed = p;
                 break;
             }
        }
        User testUser = new User();
        testUser.Email = 'test@test.com';
        testUser.Username = ret + '@testuser45qwe.com';
        testUser.LastName = 'test';
        testUser.Alias = 'test';
        testUser.ProfileId = profileUsed.Id;
        testUser.LanguageLocaleKey = 'en_US';
        testUser.LocaleSidKey = 'en_US';
        testUser.TimeZoneSidKey = 'America/Chicago';
        testUser.EmailEncodingKey = 'UTF-8';
        insert testUser;  
        
        return testUser;
    }
    
    public static Account sampleAccount(String aName) {
        Account a = new Account();
        a.Name = aName;
        a.SAP_ACCOUNT__c = '123';
        a.AccountNumber = '123';
        a.Short_Name__c = 'TA';
        insert a;
        return a;
    }
    
    public static Contact sampleContact(String cName, String accountId) {
        Contact c = new Contact();
        c.LastName = cName;
        c.AccountId = accountId;
        c.Phone = '9999900000';
        insert c;
        return c;
    }
    
    public static Case sampleCase() {
        Case c = new Case();
        c.Reason = 'FRD Credits';
        //c.Type = '07 - Pallet Reconciliation Credit';
        c.Status = 'New';
        c.Origin = 'Email';
        return c;
    }
    
    public static Order sampleOrder() {
        Account acc = sampleAccount('Test Account1234');
        Order o = new Order();
        o.Order_Num__c = 'test';
        o.AccountId = acc.Id;
        o.EffectiveDate = System.today();
        o.Status = 'CREDIT HOLD';
        insert o;
        return [Select Id, Name, Order_Num__c From Order Where Id =: o.Id];
    }
    
    public static Invoice__c sampleInvoice() {
    Account acc = sampleAccount('Test Account1234');
        Order o = new Order();
        o.Order_Num__c = 'test';
        o.AccountId = acc.Id;
        o.EffectiveDate = System.today();
        o.Status = 'CREDIT HOLD';
        insert o;
        Invoice__c i = new Invoice__c();
        i.Invoice_Number__c = '2121';
        i.order__c = o.id;
        insert i;
        return [Select Id, Name, Invoice_Number__c From Invoice__c Where Id =: i.Id];
    }
}