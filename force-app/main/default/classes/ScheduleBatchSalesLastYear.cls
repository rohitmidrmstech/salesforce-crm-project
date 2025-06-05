global class ScheduleBatchSalesLastYear implements Schedulable {
	
  global void execute(SchedulableContext context) {
  	        
  	// call batch apex 
  	       
    BatchSalesLastYear batchObj = new BatchSalesLastYear();
        
    ID batchprocessid = Database.executeBatch(batchObj, 50 );
    
  }   
    
}