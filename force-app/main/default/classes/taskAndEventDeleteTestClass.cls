@isTest
public class taskAndEventDeleteTestClass {
    static testMethod void taskAndEventDeleteTest() {
        Case cs= new Case();
        insert cs;
        
        
        //String userid = UserInfo.getUserId();
        /*
        Task casetask = [SELECT Id, Subject 
                            FROM Task 
                            WHERE WhatId LIKE '500'
                            AND CreatedById != :userid 
                            LIMIT 1];
        */
        Task t = new Task(WhatId=cs.Id);
        insert t;
        
        Event ev = new Event(DurationInMinutes=5, ActivityDateTime=Datetime.now(), WhatId=cs.Id);
        insert ev;
        
        Profile p = [select id from profile where  name='System Administrator'];
        User user= new User();
        list<User> userList = new List<User>();
        user= new User(alias = 'standt', email='standarduser@certainteed.com',emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US',
        localesidkey='en_US', profileid = t.CreatedById,timezonesidkey='America/New_york', username='standarduser@certainteed.com');
        UserList.add(user);
        user= new User(alias = 'sysadmin', email='SysAdmin@certainteed.com',emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',
            localesidkey='en_US', profileid = p.Id,timezonesidkey='America/New_York', username='SysAdmin@certainteed.com');
        userList.add(user);
        insert user;              
        DmlException expectedException; 
        
        
        Test.startTest();
        system.runAs(user)
        {
        
        try         		{ 
        			delete t; 
        	
        		}
        			catch (DmlException dmlExc)
         			{ 
         				expectedException = dmlExc;
         	 	}
        }
        //delete t;

/*
        Task t2 = new Task(WhatId=cs.Id);
        insert t2;
        try
        {
            delete t2;
        }
        catch (DMLException dlme)
        {
        
        }    
        */

        delete ev;
        
        Test.stopTest();

        
    }
}