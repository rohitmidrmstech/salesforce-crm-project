@isTest
private class Test_aiuEvent {
	
	public static testmethod void DoTest(){
		 
		// create account
		Account a = new Account();
		
		a.Name = 'Test3';
 
		insert a;
		
		// create event
		Event e = new Event();
		
		e.Subject = 'Test';
		e.WhatId = a.Id;
		e.ActivityDateTime = system.now();
		e.DurationInMinutes = 60;
		
		insert e; 
		
		
		for(Event t : [Select Id, Subject From Event Where Id = : e.Id Limit 1]){
			t.Subject = 'Call';
			
			update t;
		} 
	}
	
	
	public static testmethod void DoTest2(){
		
		// create account
		Account a = new Account();
		
		a.Name = 'Test3';
 
		insert a;
		
		
		Event e = new Event();
		
		e.Subject = 'Test';
		e.WhatId = a.Id;
		e.ActivityDateTime = system.now();
		e.DurationInMinutes = 60;
		
		insert e; 
	} 
}