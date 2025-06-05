@isTest
private class Test_scheduleBatchNotifyMissingUpdates {
	
	public static testmethod void DoTest(){
		
		Test.startTest();
		 
		scheduleBatchNotifyMissingUpdates cls = new scheduleBatchNotifyMissingUpdates();
		
		SchedulableContext context;
		
		cls.execute(context);
		
		Test.stopTest();
		
	}
}