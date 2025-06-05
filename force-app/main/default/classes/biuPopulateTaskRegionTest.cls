@isTest
public class biuPopulateTaskRegionTest {
    @testSetup static void setupMethod(){
        //insert Account record
        Account accObj = new Account();
        accObj.Name = 'Test';
        insert accObj;
        
        Contact conObj = new Contact();
        conObj.lastName = 'Test';
        conObj.MailingStreet = 'Test Street';
        conObj.MailingCity = 'Ajmer';
        conObj.MailingState = 'rajasthan';
        conObj.MailingPostalCode = '987654321a';
        conObj.Phone = '1234567890';    
        insert conObj;
        
        //insert Task record
        Task taskObj = new Task();
        taskObj.Status = 'Not Started';
        taskObj.Subject = 'Test';
        taskObj.WhatId = accObj.id;
        taskObj.WhoId = conObj.id;
        taskObj.Category__c = 'New Product Idea';
        taskObj.Sub_Category__c = 'ASTM';
        taskObj.Sub_Category_Ins__c = 'CT Building Insulation';
        taskObj.Comments__c = 'testing';
        taskObj.Source__c = 'Test';
        insert taskObj;
        
        //insert opportunity records
        opportunity oppObj = new opportunity();
        oppObj.Name = 'Test';
        oppObj.StageName = 'prospecting';
        oppObj.CloseDate = date.parse('02/13/2020');
        insert oppObj;
        
       Task taskObj1 = new Task();
        taskObj1.Status = 'Not Started';
        taskObj1.Subject = 'Test';
        taskObj1.WhatId = oppObj.id;
        insert taskObj1;
        //insert RecordType
       ProDialogue_Input__c pD_InputObj = new ProDialogue_Input__c();
       pD_InputObj.Activities_Id__c = taskObj.id;
       pD_InputObj.City__c = 'Test';
       pD_InputObj.City_State__c = 'Test';
       insert pD_InputObj;
        
        //insert rcTypeObj;
    }
    @isTest static void TestTaskTrigger(){
        Test.startTest();
        List<Task> taskList = new List<Task>();
        taskList = [select status, subject from task];
        RecordType rcTypeObj = [Select Id From RecordType Where Name = 'USA Task' AND SObjectType = 'Task' ];
        Task taskObject = new Task();
        taskObject.id = taskList.get(0).id;
        taskObject.RecordTypeId = rcTypeObj.id;
        taskObject.Category__c = 'New Product Idea';
        taskObject.Sub_Category__c = 'Testupdate';
        taskObject.Comments__c = 'Testupdate';
        taskObject.Source__c = 'Testupdate';
        update taskObject;
        Test.stopTest();
    }
    @isTest static void TestTaskUpdateTrigger(){
        Test.startTest();
        List<Task> updatetaskList = new List<Task>();
        List<Task> taskList = new List<Task>();
        taskList = [select status, subject,Sub_Category_Ins__c from task];
        System.debug('taskList'+taskList[0]);
        RecordType rcTypeObj = [Select Id from RecordType where sObjectType='Task' and Name='Sales Task' ];
        for(Task tObj : taskList){
            Task taskObject = new Task();
            taskObject.id = tObj.id;
            taskObject.RecordTypeId = rcTypeObj.id;
            taskObject.Category__c = 'New Product Idea';
            taskObject.Sub_Category__c = 'ASTM';
            taskObject.Comments__c = 'Testupdate';
            taskObject.Sub_Category_Ins__c = 'CT Building Insulation';
            taskObject.Source__c = 'Testupdate';
            updatetaskList.add(taskObject);
        }
       update updatetaskList;
        //List<ProDialogue_Input__c> lstpdObj = [Select Activities_Id__c, Category__c, Sub_Category__c, Notes__c, Information_Source__c, Priority__c 
        List<ProDialogue_Input__c> lstpdObj = [Select Activities_Id__c, Category__c, Sub_Category__c, Information_Source__c, Priority__c 
            from ProDialogue_Input__c];
        delete taskList;
       Test.stopTest();
    }
    @isTest static void TestEventTrigger(){
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
        
        //Creating an Account For BAP.    
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        
        //Creating BAP Record                                                                                   //date.valueOf(sep1.Year__c + '-1-1 00:00:00');
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2012',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep;
        
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1',*/ Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;  
        
        string myYear1 = '2012';
        string month1 = '1';
        string day1 = '5';
        string hour1 = '11';
        string minute1 = '46';
        string second1 = '20';
        string stringDate1 = myYear1 + '-' + month1 + '-' + day1 + ' ' + hour1 + ':' + minute1 +  ':' + second1;
        Datetime myDate1 = datetime.valueOf(stringDate1);
        Date myDate11 = date.valueOf(stringDate1);
        
        Id bufftechFenceSalesCallId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Bufftech Fence Sales Call').getRecordTypeId();
        
        List<Event> eventList = new List<Event>();    
        Event ev1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',*/RecordTypeId=bufftechFenceSalesCallId, StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Comments__c = 'test',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate11,SEP_activity__c=True,*/OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev1);
        
        Event ev11 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',*/StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,*/OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev11);
        
        Event evNew = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',*/StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,*/OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew);
        
        Event evNew1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',*/StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,*/OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew1);
        
        if(eventList.size() > 0)
            insert eventList;
    }
    
    @isTest static void TestEventTrigger2(){
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
        
        //Creating an Account For BAP.    
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        
        Contact con = new Contact(LastName = 'Testing');
        Insert con;
        
        Opportunity opp = new Opportunity(Name = 'Test Opportunity', AccountId = acc.Id, StageName='Design', CloseDate = system.today().addDays(2));
        Insert opp;
        
        Weekly_Territory_Update__c wtuRecord = new Weekly_Territory_Update__c(Week_Ends__c = system.today().addDays(7).toStartOfWeek());
        Insert wtuRecord;
        
        //Creating BAP Record                                                                                   //date.valueOf(sep1.Year__c + '-1-1 00:00:00');
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2012',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep;
        
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1',*/ Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;  
        
        string myYear1 = '2012';
        string month1 = '1';
        string day1 = '5';
        string hour1 = '11';
        string minute1 = '46';
        string second1 = '20';
        string stringDate1 = myYear1 + '-' + month1 + '-' + day1 + ' ' + hour1 + ':' + minute1 +  ':' + second1;
        Datetime myDate1 = datetime.valueOf(stringDate1);
        Date myDate11 = date.valueOf(stringDate1);
        
        Id bufftechFenceSalesCallId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Bufftech Fence Sales Call').getRecordTypeId();
        Id usaEventId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('USA Event').getRecordTypeId();
        Id newEventId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('New Event').getRecordTypeId();
        
        List<Event> eventList = new List<Event>();    
        Event ev1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',*/RecordTypeId=bufftechFenceSalesCallId, WTU_Notes__c= 'Test Notes', StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Comments__c = 'test',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate11,SEP_activity__c=True,*/OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev1);
        
        Event ev11 = new Event(WhatId=acc.Id,/*Goal_Number__c='1',*/RecordTypeId = usaEventId, StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,*/OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev11);
        
        Event evNew = new Event(WhoId = con.Id, Category__c = 'New Product Idea', RecordTypeId = usaEventId, StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew);
        
        Event evNew1 = new Event(WhatId=opp.Id, RecordTypeId = usaEventId, StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,*/OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew1);
        
        Event evNew2 = new Event(WhoId=con.Id, Category__c = 'New Product Idea', RecordTypeId = newEventId, StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,*/OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew2);
        
        if(eventList.size() > 0)
            insert eventList;
            
        evNew2 = eventList[4];
        evNew2.Category__c = 'CT Product Comment';
        Update evNew2;
    }
}