@isTest
private class DeleteCaseTest {
    static testMethod void forCaseDeletion() {
        
        Group gp = [select Id, Name from Group where Type = 'Queue' and Name = 'Record Deletion'];
        
        Case cs = new Case();
        //Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing Case').getRecordTypeId();
        RecordType caseRecordTypeId =[select id,Name from RecordType where SobjectType='Case' and Name='Pricing Case' Limit 1];
        
        cs.RecordTypeId = caseRecordTypeId.Id;
        cs.Subject = 'test';
        cs.Issue_Category__c = 'Discounts';
        cs.Issue_Problem__c = 'Face of Invoice Incorrect';
        //cs.Portal_Subject__c = 'Pricing';
        cs.Status = 'New';
        cs.Origin = 'Phone';
        cs.OwnerId = gp.Id;
        system.debug('===============cs================='+cs);
        Test.startTest();
       
        insert cs;
        
        DeleteCase be = new DeleteCase();
        database.executeBatch(be);
        
        Test.stopTest();
    }
    
    static testmethod void  testschedule(){
        Test.StartTest();
        DeleteCaseScheduler sh1 = new DeleteCaseScheduler();     
        String sch = '0  00 1 3 * ?';
        system.schedule('Test', sch, sh1);
        
        Test.stopTest();
    }
}