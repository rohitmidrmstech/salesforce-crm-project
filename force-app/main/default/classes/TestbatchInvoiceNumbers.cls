// ==================================================================================
//   Object: TestbatchInvoiceNumbers
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Testing of batchInvoiceNumbers class
// ==================================================================================
//  Changes: 2013-04-30 Initial version.
// ==================================================================================

@isTest
private class TestbatchInvoiceNumbers {

    static testMethod void myUnitTest() {
        User u1 = TestCaseUtil.sampleUser();
        
    	Account a1;
    	System.runAs(u1) {
			a1 = TestCaseUtil.sampleAccount('Test Account1');
    	}
    	Case c = TestCaseUtil.sampleCase();
		c.AccountId = a1.Id;
        c.Campaign__c = 'RES';
		insert c;
		
		Order o = new Order();
        o.Order_Num__c = 'test';
        o.AccountId = a1.Id;
        o.EffectiveDate = System.today();
        o.Status = 'CREDIT HOLD';
        insert o;
		
        Invoice__c inv = new Invoice__c();
        inv.Invoice_Number__c = '2121';
        inv.Order__c = o.id;
        insert inv;
		
		c.Invoice_Number__c = inv.Invoice_Number__c;
		update c;
		
		batchInvoiceNumbers batchObj = new batchInvoiceNumbers();
		Test.StartTest();
		database.executebatch(batchObj, 100);
		
		batchInvoiceNumbersSchedule schedule = new batchInvoiceNumbersSchedule();
		SchedulableContext context; 
        schedule.execute(context);
		Test.StopTest();
    }
}