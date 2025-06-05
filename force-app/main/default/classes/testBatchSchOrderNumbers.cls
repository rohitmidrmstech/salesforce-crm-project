/***************************************************************************************************
Author : Mukesh Bhardwaj.
Company : Threshold Consulting
Description : Test class for batchOrderNumbers & scheduleOrderNumbers Class.
Date On : 3rd May 2013.
Initial Version
****************************************************************************************************/
@isTest(seeAllData = false)
private class testBatchSchOrderNumbers  
{ 
    static testMethod void testBatchClass() 
    {
        Id accRtId = TestClassUtility.recordTypeMap.get('Account').get('ReadOnlyBPCSRecord');
        Id caseRtId = TestClassUtility.recordTypeMap.get('Case').get('General_Case');
        
        Test.startTest();
        Account a = new Account();
        a.Name = 'Test Acc';
        a.Type = 'Customer';
        a.Account_Sub_Type__c = 'Customer';
        a.RecordTypeId = accRtId;
        a.SAP_ACCOUNT__c = '12345';
        insert a;
        
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.FirstName = 'test';
        c.LastName = 'Mukesh';
        c.Email = 'a@gmail.com';
        c.MailingState = 'CA';
        c.MailingStreet = 'Mailing Street';
        insert c;

        Case ca = new Case();
        ca.ContactId = c.Id;
        //ca.Type = 'Account Maintenance';
        ca.SubType__c = 'Change Quantity';
        ca.Resolution__c = 'General Case';
        ca.Origin = 'Email';
        ca.Status = 'Re-Opened';
        ca.Order_Number__c = '123456';
        ca.AccountId = a.Id;
        ca.Campaign__c = 'RES';
        insert ca;
        
        Order o = new Order();
        o.Name = '123456';
        o.AccountId = a.Id;
        o.Status = 'CREDIT HOLD';
        o.EffectiveDate = System.today();
        insert o;
        
        batchOrderNumbers  bc = new batchOrderNumbers();
        Database.executeBatch(bc, 200);
        Test.stopTest();
    }
   
    static testMethod void testschedule() 
    {
        Test.startTest();
        scheduleOrderNumbers  sh1 = new scheduleOrderNumbers();
        String sch = '0 0 23 * * ?';
        system.schedule('Test Case Update', sch, sh1);
        Test.stopTest();
    }
}