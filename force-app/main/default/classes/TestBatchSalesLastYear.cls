@isTest
private class TestBatchSalesLastYear {

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
		
 
		Test.StartTest();
		
		BatchSalesLastYear batchObj = new BatchSalesLastYear();
        
   		 ID batchprocessid = Database.executeBatch(batchObj, 50 );
    
		Test.StopTest();
    }
}