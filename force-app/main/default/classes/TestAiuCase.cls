// ==================================================================================
//   Object: TestAiuCase
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Testing of aiuCase trigger
// ==================================================================================
//  Changes: 2013-04-29 Initial version.
// ==================================================================================

@isTest
private class TestAiuCase {

    static testMethod void myUnitTest() {
        User u1 = TestCaseUtil.sampleUser();
        User u2 = TestCaseUtil.sampleUser();
        
    	Account a1;
    	System.runAs(u1) {
			a1 = TestCaseUtil.sampleAccount('Test Account1');
    	}
    	Account a2;
    	System.runAs(u1) {
			a2 = TestCaseUtil.sampleAccount('Test Account1');
    	}
    	
		Case c = TestCaseUtil.sampleCase();
		c.AccountId = a1.Id;
        c.Campaign__c = 'RES';
		insert c;
		
		c.AccountId = a2.Id;
		update c;
    }
}