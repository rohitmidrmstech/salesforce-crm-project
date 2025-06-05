global class scheduleBatchNotifyMissingUpdates implements Schedulable {
	
  global void execute(SchedulableContext context) {
  	       
  	// call batch apex 
  	      
    batchNotifyMissingUpdates batchObj = new batchNotifyMissingUpdates();
        
    ID batchprocessid = Database.executeBatch(batchObj, 1 );
    
  }   
    
}