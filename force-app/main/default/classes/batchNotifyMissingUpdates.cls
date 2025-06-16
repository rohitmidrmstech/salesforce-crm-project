/*********************************************************************************
Requirement:
1.	Create a schedulable Apex class, batchNotifyMissingUpdates, which runs at midnight GMT Fridays and looks at every User record with a User_Type__c value. (This is a multi-picklist.)
2.	For the list of users who have a User_Type__c defined, construct a list of all users who have not yet created a WTU__c record for this week, as defined by the period between the current date minus seven days.
3.	Send a reminder email TBD to each user who has not yet created a WTU__c record. (We will get you the text of the email.) If practical, use a template for this email.
4.	Create an Apex class, runBatchNotifyMissingUpdates, which can be run to start the batchNotifyMissingUpdates class on the correct schedule.
5.	In case of error, send an email to all System Administrators notifying them that an error happened.

*********************************************************************************/
 
global class batchNotifyMissingUpdates implements Database.Batchable<SObject>, Database.AllowsCallouts{
    
	global database.Querylocator start(Database.BatchableContext BC){
		if(Test.isRunningTest()){
			return Database.getQueryLocator([Select u.User_Type__c, u.Id, u.Email From User u Where Id =: UserInfo.getUserId() Limit 1]);
		}
		
		// Fetch active users with a batch size of 1  
		return Database.getQueryLocator([Select u.User_Type__c, u.Id, u.Email From User u Where u.User_Type__c != null AND IsActive = true  ]);
	}


	global void execute(Database.BatchableContext BC,Sobject[] scope){
      try{
 
		for(sobject s : scope){
			
			User u = (User)s;
			
	        // Date variable to hold past 7 days ago date time 
	        Date dtPast7Days = system.today().addDays(-7);
			DateTime dtCreated = DateTime.newInstance(dtPast7Days.year(), dtPast7Days.month(), dtPast7Days.day(), 0, 0, 0);
			 
			// Fetch Weekly_Territory_Update__c record with matching weekend date as today
			List<Weekly_Territory_Update__c> listWTU = [Select Id From Weekly_Territory_Update__c Where TM__c = : u.Id AND Week_Ends__c = : system.today() Limit 1];
			
			if(listWTU.size() == 0){
				
				// Send an notification email
				batchUtility.sendMissingWTUEmail(u.Email);
				 
			}
			 
		} 
		 
      }
      catch(Exception ex){
      	
      	system.debug('==========' + ex.getMessage());
      	// Send exception email to all admin
      	batchUtility.sendExceptionEmailAllAdmin('Exception in batch process : batchNotifyMissingUpdates', ex.getMessage());
      	 
      }	
      
	}
  
	global void finish(Database.BatchableContext BC){
		
	}
}