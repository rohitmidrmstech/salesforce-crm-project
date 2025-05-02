public class EmployeeTriggerHandler {
    public static void beforeDelteEmployee(List<Employee__c> oldList){
        for(Employee__c emp :oldList){
            if(emp.isActive__c == true){
                emp.addError('You cannot delte Active Employee');
            }
        }
    }
    public static void afterDeleteEmployee(List<Employee__c> oldList){
        Set<Id> AccountIds = new Set<Id>();
        List<Account> accTobeUpdated = new List<Account>();
        Map<Id, Account> accIdtoAccMap;
        Map<Id, Decimal> accIdCountUpdate = new Map<Id, Decimal>();
		List<Employee__c> empList = new List<Employee__c>();
        for(Employee__c emp : oldList){
            if(emp.Account__c != null){
               AccountIds.add(emp.Account__c);
			   empList.add(emp);
            }
        }
        if(!AccountIds.isEmpty()){
		 accIdtoAccMap = new Map<Id,Account>([SELECT Id ,Left_Employee_Count__c FROM Account WHERE Id IN :AccountIds]);
            
        }
		
		if(!empList.isEmpty()){
		for(Employee__c emp :empList){
		if(accIdtoAccMap.containsKey(emp.Account__c)){
		if(accIdCountUpdate.containsKey(emp.Account__c)){
		Decimal count = accIdCountUpdate.get(emp.Account__c) +1;
		accIdCountUpdate.put(emp.Account__c ,count); 
		}
		else{
		accIdCountUpdate.put(emp.Account__c , accIdtoAccMap.get(emp.Account__c).Left_Employee_Count__c + 1);
		}
}		
    
}
}

for(Id accId :accIdCountUpdate.KeySet()){
  Account acc = new Account();
  acc.Id = accId;
  acc.Left_Employee_Count__c = accIdCountUpdate.get(accId);
  accTobeUpdated.add(acc);
  }
  if(!accTobeUpdated.isEmpty()){
  update accTobeUpdated;
  }
  }
    Public static void undeleteEmployee(List<Employee__c> newList){
        List<Employee__c> updateEmpList = new List<Employee__c> ();
          Set<Id> AccountIds = new Set<Id>();
        List<Account> accTobeUpdated = new List<Account>();
        Map<Id, Account> accIdtoAccMap;
        Map<Id, Decimal> accIdCountUpdate = new Map<Id, Decimal>();
		List<Employee__c> empList = new List<Employee__c>();
        for(Employee__c emp : newList){
           Employee__c em = new Employee__c();
            em.Id = emp.Id;
            em.isActive__c = true;
            updateEmpList.add(em);
            if(emp.Account__c != null){
              AccountIds.add(emp.Account__c) ;
               empList.add(emp);
            }
        }
        
        if(!AccountIds.isEmpty()){
		 accIdtoAccMap = new Map<Id,Account>([SELECT Id ,Left_Employee_Count__c FROM Account WHERE Id IN :AccountIds]);
            
        }
		
		if(!empList.isEmpty()){
		for(Employee__c emp :empList){
		if(accIdtoAccMap.containsKey(emp.Account__c)){
		if(accIdCountUpdate.containsKey(emp.Account__c)){
		Decimal count = accIdCountUpdate.get(emp.Account__c) - 1;
		accIdCountUpdate.put(emp.Account__c ,count); 
		}
		else{
		accIdCountUpdate.put(emp.Account__c , accIdtoAccMap.get(emp.Account__c).Left_Employee_Count__c - 1);
		}
}		
    
}
}

for(Id accId :accIdCountUpdate.KeySet()){
  Account acc = new Account();
  acc.Id = accId;
  acc.Left_Employee_Count__c = accIdCountUpdate.get(accId);
  accTobeUpdated.add(acc);
  }
 
        if(!updateEmpList.isEmpty()){
           update  updateEmpList;
        }
         if(!accTobeUpdated.isEmpty()){
  update accTobeUpdated;
  }
        
    }

}