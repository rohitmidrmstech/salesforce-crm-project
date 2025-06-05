// ==================================================================================
//   Object: TestbatchOrderNumbers
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Testing of batchOrderNumbers class
// ==================================================================================
//  Changes: 2013-04-30 Initial version.
// ==================================================================================

@isTest
private class TestbatchOrderNumbers {

    static testMethod void myUnitTest() {
        User u1 = TestCaseUtil.sampleUser();
        
        Account a1;
        System.runAs(u1) {
            a1 = TestCaseUtil.sampleAccount('Test Account1');
        }
        
        Id RecordTypeIdCase = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Incident').getRecordTypeId();
        
        Case c = TestCaseUtil.sampleCase();
        c.AccountId = a1.Id;
        c.RecordTypeId = RecordTypeIdCase;
        c.Product_Dollars__c = 1;
        insert c;
        
        Order oder = TestCaseUtil.sampleOrder();
        
        c.Order_Number__c = oder.Order_Num__c;
        update c;
        
        batchOrderNumbers_Siding batchObj = new batchOrderNumbers_Siding();
        Test.StartTest();
        database.executebatch(batchObj, 100);
        
        batchOrderNumbersSchedule schedule = new batchOrderNumbersSchedule();
        SchedulableContext context; 
        schedule.execute(context);
        Test.StopTest();
        
        
    }
    
    
}