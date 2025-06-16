global class BatchSalesLastYear  implements Database.Batchable<SObject>, Database.AllowsCallouts {
	
	global database.Querylocator start(Database.BatchableContext BC) {
    	
        if(Test.isRunningTest()) {
            return Database.getQueryLocator([Select Id,Volume_Last_Year__c From Account Limit 1 ]);
        }
         
        return Database.getQueryLocator([Select Id,Volume_Last_Year__c From Account Order By LastModifiedDate DESC ]);
    }
    
    global void execute(Database.BatchableContext BC,Sobject[] scope) {
		try { 
			
			List<Account> listAccountUpdate = new List<Account>();
			
			Date dtLastYearStart = Date.newInstance(system.today().year()-1, 1, 1);
			Date dtLastYearEnd = Date.newInstance(system.today().year()-1, 12, 31);
			  
			for(sobject s : scope) {
				
				Account  a = (Account)s;
				
				double SalesLastYear = 0;
				 
				AggregateResult[] groupedResults = [SELECT SUM(Squares__c)	FROM Invoice__c 
													Where Ship_To_Lookup__c = : a.Id AND Squares__c != null AND
													Billing_Date__c >=: dtLastYearStart AND Billing_Date__c <=: dtLastYearEnd ];
				
				for (AggregateResult ar : groupedResults) {
					
					SalesLastYear =  double.valueof( ar.get('expr0'));
				}
				
				if(a.Volume_Last_Year__c == null || a.Volume_Last_Year__c != SalesLastYear ){
					
					a.Volume_Last_Year__c = SalesLastYear;
					
					listAccountUpdate.add(a);
				}
			}
			
			if(listAccountUpdate.size() > 0){
				update listAccountUpdate;
			} 
			
		} 
		catch(Exception ex) {
			system.debug(ex.getMessage());
		}
		
    }
    
   global void finish(Database.BatchableContext BC) {
 
    }
}