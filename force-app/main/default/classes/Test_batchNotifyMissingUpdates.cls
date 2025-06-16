@isTest
private class Test_batchNotifyMissingUpdates {
	
	public static testmethod void DoTest(){
		 
		Test.startTest();
		  
		// call batch apex
	    batchNotifyMissingUpdates batchObj = new batchNotifyMissingUpdates();
	    
	    ID batchprocessid = Database.executeBatch(batchObj,1);
    
		Test.stopTest();
		
	}
}