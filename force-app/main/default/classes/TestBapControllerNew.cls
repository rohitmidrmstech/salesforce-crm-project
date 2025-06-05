// ==================================================================================
// Name: TestBapControllerNew
// Company: SalesOptimizer
// Author: Megha 
// Comments: Test class of BapController
// ==================================================================================
//  Changes: 2012-12-27 Initial version.
//History:
//* - VERSION  DEVELOPER NAME                  DATE            DETAIL FEATURES/CSR/TTP
//    1.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
// ==================================================================================
@isTest (seeAllData=true)
private class TestBapControllerNew 
{
/*
    //Method for Existing Mode
    static testMethod void myUnitTestExistingOne(){
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
        
        //Creating an Account For BAP.    
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        Contact con = new Contact(LastName = 'test');
        con.Email='fdfdfxzcx@ffff.com';
        con.MailingCountry='zxcv';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test2';
        con.MailingCity = 'Newyork';
        con.MailingState = 'rajasthan';
        con.otherphone='123465';
        con.Phone = '123456766890';
        con.MailingPostalCode = '98766654321a';
        
        INSERT con;
        //Creating BAP Record                                                                                   //date.valueOf(sep1.Year__c + '-1-1 00:00:00');
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2012',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep;
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
       //START Commneted by Kritika Bhati on 31/7/2017 for S-490568

        //END S-490568

        List<Event> eventList = new List<Event>();                        
        string myYear1 = '2012';
        string month1 = '1';
        string day1 = '5';
        string hour1 = '11';
        string minute1 = '46';
        string second1 = '20';
        string stringDate1 = myYear1 + '-' + month1 + '-' + day1 + ' ' + hour1 + ':' + minute1 +  ':' + second1;
        Datetime myDate1 = datetime.valueOf(stringDate1);
        Date myDate11 = date.valueOf(stringDate1);
        
        Event ev1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Comments__c = 'test',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev1);
        
        Event ev11 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev11);
        
        Event evNew = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew);
        
        Event evNew1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew1);
        
        if(eventList.size() > 0)
            insert eventList;
        
        System.debug('eventList::' + eventList);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c; 
        controller.getcertainTeedName();  
        //controller.goalModelList[0].sepGoal.Id = null;   
        controller.save();
        controller.saveAndClose();
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
        }
        controller.save();
        
        sep.Year__c = '2014';
        update sep;
        controller.save();
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            //b.evnt.Goal_Number__c = 'Planning';
        }
        controller.save();
        
       
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'sda';
            //b.evnt.Goal_Date__c = System.today();
            b.evnt.Comments__c = 'dsf';
        }
        controller.save();
        
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
        }
        controller.save();
        
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            //b.evnt.Goal_Date__c = Null;
        }        
        controller.save();
        Test.stopTest();   
    }
    
    static testMethod void myUnitTestExistingTwo(){
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
        
        //Creating an Account For BAP.    
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        Contact con = new Contact(LastName = 'test');
        con.Email='fdfdfxzcx@ffff.com';
        con.MailingCountry='zxcv';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test2';
        con.MailingCity = 'Newyork';
        con.MailingState = 'rajasthan';
        con.otherphone='123465';
        con.Phone = '123456766890';
        con.MailingPostalCode = '98766654321a';
        
        INSERT con;
        //Creating BAP Record                                                                                   //date.valueOf(sep1.Year__c + '-1-1 00:00:00');
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2012',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep;
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
       //START Commneted by Kritika Bhati on 31/7/2017 for S-490568

        //END S-490568

        List<Event> eventList = new List<Event>();                        
        string myYear1 = '2012';
        string month1 = '1';
        string day1 = '5';
        string hour1 = '11';
        string minute1 = '46';
        string second1 = '20';
        string stringDate1 = myYear1 + '-' + month1 + '-' + day1 + ' ' + hour1 + ':' + minute1 +  ':' + second1;
        Datetime myDate1 = datetime.valueOf(stringDate1);
        Date myDate11 = date.valueOf(stringDate1);
        
        Event ev1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Comments__c = 'test',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev1);
        
        Event ev11 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev11);
        
        Event evNew = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew);
        
        Event evNew1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew1);
        
        if(eventList.size() > 0)
            insert eventList;
        
        System.debug('eventList::' + eventList);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c; 
        controller.getcertainTeedName();  
        //controller.goalModelList[0].sepGoal.Id = null;   
        controller.save();
        controller.saveAndClose();
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
        }
        controller.save();
        
        sep.Year__c = '2014';
        update sep;
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = null;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = 'test';
            //b.evnt.Goal_Date__c = date.newinstance(2014, 2, 17);
        }
        controller.save();
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = null;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = null;
           // b.evnt.Goal_Date__c = date.newinstance(2014, 2, 17);
        }
        controller.save();
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = con.Id;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = 'test';
            //b.evnt.Goal_Date__c = date.newinstance(2014, 2, 17);
        }
        controller.save(); 
        Test.stopTest();
    }
    
    static testMethod void myUnitTestExistingThree(){
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
        
        //Creating an Account For BAP.    
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        Contact con = new Contact(LastName = 'test');
        con.Email='fdfdfxzcx@ffff.com';
        con.MailingCountry='zxcv';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test2';
        con.MailingCity = 'Newyork';
        con.MailingState = 'rajasthan';
        con.otherphone='123465';
        con.Phone = '123456766890';
        con.MailingPostalCode = '98766654321a';
        INSERT con;
        //Creating BAP Record                                                                                   //date.valueOf(sep1.Year__c + '-1-1 00:00:00');
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2012',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep;
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
       //START Commneted by Kritika Bhati on 31/7/2017 for S-490568

        //END S-490568

        List<Event> eventList = new List<Event>();                        
        string myYear1 = '2012';
        string month1 = '1';
        string day1 = '5';
        string hour1 = '11';
        string minute1 = '46';
        string second1 = '20';
        string stringDate1 = myYear1 + '-' + month1 + '-' + day1 + ' ' + hour1 + ':' + minute1 +  ':' + second1;
        Datetime myDate1 = datetime.valueOf(stringDate1);
        Date myDate11 = date.valueOf(stringDate1);
        
        Event ev1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Comments__c = 'test',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev1);
        
        Event ev11 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(ev11);
        
        Event evNew = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew);
        
        Event evNew1 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate1,EndDateTime=myDate1,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate11,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventList.add(evNew1);
        
        if(eventList.size() > 0)
            insert eventList;
        
        System.debug('eventList::' + eventList);
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c; 
        controller.getcertainTeedName();  
        //controller.goalModelList[0].sepGoal.Id = null;   
        controller.save();
        controller.saveAndClose();
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
        }
        controller.save();
        
        sep.Year__c = '2014';
        update sep;
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = null;
            //b.evnt.Goal_Number__c = null;
            b.evnt.Comments__c = 'test';
            //b.evnt.Goal_Date__c = date.newinstance(2014, 2, 17);
        }
        controller.save();
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = null;
            b.evnt.whatId = null;
           // b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = null;
            //b.evnt.Goal_Date__c = date.newinstance(2014, 2, 17);
        }
        controller.save();
        
        for(BapController.BapObjectiveModel b: controller.Q1)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = con.Id;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = 'test';
            //b.evnt.Goal_Date__c = date.newinstance(2014, 12, 17);
        }
        controller.save();   
        Test.stopTest();
    }
    
    static testMethod void myUnitTestExistingOneQ2() 
    {
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
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
        //START Commneted by Kritika Bhati on 31/7/2017 for S-490568

        //END S-490568
        //For Quater 2        
        string myYear2 = '2012';
        string month2 = '6';
        string day2 = '5';
        string hour2 = '11';
        string minute2 = '46';
        string second2 = '20';
        string stringDate2 = myYear2 + '-' + month2 + '-' + day2 + ' ' + hour2 + ':' + minute2 +  ':' + second2;
        
        Datetime myDate2 = datetime.valueOf(stringDate2);  
        Date myDate22 = date.valueOf(stringDate2);      
        List<Event> eventListQ2 = new List<Event>();        
        Event ev21 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev21);
        
        Event ev22 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev22);
        
        Event ev23 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev23);
        
        Event ev24 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev24);
          
        if(eventListQ2.size() > 0)
            insert eventListQ2;
            
        system.debug('=======>Q2'+eventListQ2);    
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c; 
        controller.getcertainTeedName();          
        controller.save();
        controller.saveAndClose();
        
        for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = 'Planning';
        }
        controller.save();
        Test.stopTest();
    }
    static testMethod void myUnitTestExistingOneQ2Copy() 
    {
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
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
        //START Commneted by Kritika Bhati on 31/7/2017 for S-490568

        //END S-490568
        //For Quater 2        
        string myYear2 = '2012';
        string month2 = '6';
        string day2 = '5';
        string hour2 = '11';
        string minute2 = '46';
        string second2 = '20';
        string stringDate2 = myYear2 + '-' + month2 + '-' + day2 + ' ' + hour2 + ':' + minute2 +  ':' + second2;
        
        Datetime myDate2 = datetime.valueOf(stringDate2);  
        Date myDate22 = date.valueOf(stringDate2);      
        List<Event> eventListQ2 = new List<Event>();        
        Event ev21 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev21);
        
        Event ev22 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev22);
        
        Event ev23 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev23);
        
        Event ev24 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev24);
          
        if(eventListQ2.size() > 0)
            insert eventListQ2;
            
        system.debug('=======>Q2'+eventListQ2);    
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c; 
        controller.getcertainTeedName();          
        controller.save();
        controller.saveAndClose();
        
        for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = null;
            //b.evnt.Goal_Number__c = null;
            b.evnt.Comments__c = null;
            //b.evnt.Goal_Date__c = date.newinstance(2014, 2, 17);
        }
        controller.save();
        
        for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = null;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = null;
            //b.evnt.Goal_Date__c =null;
        }
        controller.save();
         for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = null;
            b.evnt.whatId = null;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = null;
            //b.evnt.Goal_Date__c =date.newinstance(2014, 2, 17);
        }
        controller.save();
         for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = null;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = 'test';
            //b.evnt.Goal_Date__c =date.newinstance(2014, 2, 17);
        }
        controller.save();
        Test.stopTest();
    }
    
    static testMethod void myUnitTestExistingOneQ2Copy1() 
    {
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
            
        //Creating an Account For BAP.    
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        Contact con = new Contact(LastName = 'test',AccountId = acc.Id);
        con.Email='fdfdsvfxzcx@ffff.com';
        con.MailingCountry='zxcv';
        con.AccountId = acc.Id;
        con.MailingStreet = 'Test2';
        con.MailingCity = 'Newyork';
        con.MailingState = 'rajasthan';
        con.otherphone='123465';
        con.Phone = '123456766890';
        con.MailingPostalCode = '98766654321a';
        INSERT con;
        //Creating BAP Record                                                                                   //date.valueOf(sep1.Year__c + '-1-1 00:00:00');
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2012',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep;
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
        //START Commneted by Kritika Bhati on 31/7/2017 for S-490568

        //END S-490568
        //For Quater 2        
        string myYear2 = '2012';
        string month2 = '6';
        string day2 = '5';
        string hour2 = '11';
        string minute2 = '46';
        string second2 = '20';
        string stringDate2 = myYear2 + '-' + month2 + '-' + day2 + ' ' + hour2 + ':' + minute2 +  ':' + second2;
        
        Datetime myDate2 = datetime.valueOf(stringDate2);  
        Date myDate22 = date.valueOf(stringDate2);      
        List<Event> eventListQ2 = new List<Event>();        
        Event ev21 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev21);
        
        Event ev22 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev22);
        
        Event ev23 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate22,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev23);
        
        Event ev24 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate2,EndDateTime=myDate2,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ2.add(ev24);
          
        if(eventListQ2.size() > 0)
            insert eventListQ2;
            
        system.debug('=======>Q2'+eventListQ2);    
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c; 
        controller.getcertainTeedName();          
        controller.save();
        controller.saveAndClose();
        Boolean isFirst = true;
         for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = null;
            //b.evnt.Goal_Number__c = '1';
            if(isFirst){
                b.evnt.Comments__c = null;
                isFirst = false;
            }else{
                b.evnt.Comments__c = 'test';    
            }
            
            //b.evnt.Goal_Date__c =date.newinstance(2012, 5, 17);
        }
        controller.save();
        for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = con.Id;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = 'test';
            //b.evnt.Goal_Date__c =null;
        }
        controller.save();
        
        for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = con.Id;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = null;
            //b.evnt.Goal_Date__c =date.newinstance(2012, 5, 17);
        }
        controller.save();
        
        for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = null;
            b.evnt.whatId = con.Id;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = null;
            //b.evnt.Goal_Date__c =date.newinstance(2012, 5, 17);
        }
        controller.save();
        
        for(BapController.BapObjectiveModel b: controller.Q2)
        {
            b.evnt.Action_Plan__c  = 'Planning';
            b.evnt.whatId = con.Id;
            //b.evnt.Goal_Number__c = '1';
            b.evnt.Comments__c = null;
            //b.evnt.Goal_Date__c =date.newinstance(2012, 1, 17);
        }
        controller.save();
        Test.stopTest();
    }
    static testMethod void myUnitTestExistingOneQ3() 
    {
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
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
        //START Commneted by Kritika Bhati on 31/7/2017 for S-490568

        //END S-490568
        //For Quater 3
        string myYear3 = '2012';
        string month3 = '8';
        string day3 = '5';
        string hour3 = '11';
        string minute3 = '46';
        string second3 = '20';
        string stringDate3 = myYear3 + '-' + month3 + '-' + day3 + ' ' + hour3 + ':' + minute3 +  ':' + second3;
        
        Datetime myDate3 = datetime.valueOf(stringDate3);
        Date myDate33 = date.valueOf(stringDate3);
        
        List<Event> eventListQ3 = new List<Event>();
        Event ev31 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate3,EndDateTime=myDate3,Subject='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate33,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ3.add(ev31);
        
        Event ev32 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate3,EndDateTime=myDate3,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate33,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ3.add(ev32);
        
        Event ev33 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate3,EndDateTime=myDate3,Subject='Account Planning',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate33,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ3.add(ev33);
        
        Event ev34 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate3,EndDateTime=myDate3,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ3.add(ev34);
        
        if(eventListQ3.size() > 0)
            insert eventListQ3;
        Test.startTest();   
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c; 
        controller.getcertainTeedName();          
        controller.save();
        controller.saveAndClose();
        for(BapController.BapObjectiveModel b: controller.Q3)
        {
            b.evnt.Action_Plan__c  = 'Planning';
        }
        controller.save();
        Test.stopTest();
    }
    static testMethod void myUnitTestExistingOneQ4() 
    {
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
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
        //START Commneted by Kritika Bhati on 31/7/2017 for S-490568

        //S-490568
        //For Quater 4        
        string myYear4 = '2012';
        string month4 = '10';
        string day4 = '5';
        string hour4 = '11';
        string minute4 = '46';
        string second4 = '20';
        string stringDate4 = myYear4 + '-' + month4 + '-' + day4 + ' ' + hour4 + ':' + minute4 +  ':' + second4;
        
        List<Event> eventListQ4 = new List<Event>();
        
        Datetime myDate4 = datetime.valueOf(stringDate4);
        Date myDate44 = date.valueOf(stringDate4);
        
        Event ev41 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate4,EndDateTime=myDate4,Subject='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate44,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ4.add(ev41);
        
        Event ev42 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate4,EndDateTime=myDate4,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate44,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ4.add(ev42);
        
        Event ev43 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate4,EndDateTime=myDate4,Subject='Account Planning',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate44,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ4.add(ev43);
        
        Event ev44 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate4,EndDateTime=myDate4,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ4.add(ev44);
        if(eventListQ4.size() > 0)
            insert eventListQ4;
        Test.startTest();    
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep.Year__c; 
        controller.getcertainTeedName();         
        controller.save();
        controller.saveAndClose();
        for(BapController.BapObjectiveModel b: controller.Q4)
        {
            b.evnt.Action_Plan__c  = 'Planning';
        }
        controller.save();
         //START Added by Kritika Bhati for S-510717
         SEP_Goal__c goal2 = new SEP_Goal__c(Name='2', /*Goal_Number__c='2', Start_Date__c=sep.Start_Date__c,End_Date__c=sep.End_Date__c,SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal2;
        
        Integer  i = 2;
        SEP_Goal__c scGoal = goal1;    
        List<BapController.GoalClass> goalList = new   List<BapController.GoalClass>();
      
        BapController.GoalClass newGoalClass = new BapController.GoalClass(i, scGoal);
        newGoalClass.indexNo = 1;
        newGoalClass.sepGoal = goal2;
        BapController.GoalClass newGoalClass1 = new BapController.GoalClass(i, scGoal);
        newGoalClass1.indexNo = 3;
        newGoalClass1.sepGoal = goal1;
        goalList.add(newGoalClass);
        goalList.add(newGoalClass1);
        goalList = controller.sortByGoalNumber(goalList);
        controller.goalModelList = goalList;
        //END S-510717
       Test.stopTest();
    }
    
    static testMethod void myUnitTestNewOne() {
    
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
            
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2012');        
        
        SEP_Goal__c goal1 = new SEP_Goal__c(Strategy__c='Goal1');
        
        SEP_Goal__c goal2 = new SEP_Goal__c(Strategy__c='Goal2');        
        
        integer year1 = system.today().Year();
        //string myYear1 = string.valueOf(year1);
        string myYear1 = sep.Year__c;
        string month1 = '5';
        string day1 = '5';
        string hour1 = '11';
        string minute1 = '46';
        string second1 = '20';
        string stringDate1 = myYear1 + '-' + month1 + '-' + day1 + ' ' + hour1 + ':' + minute1 +  ':' + second1;
        
        Datetime myDate1 = datetime.valueOf(stringDate1);
        Date myDate11 = date.valueOf(stringDate1);
                
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','5');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','2');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','2');
        
        Event ev3 = new Event(Comments__c = 'test',/*Goal_Date__c = myDate11,Goal_Number__c='1',Subject='Account Planning',Status__c='Planning',StartDateTime=myDate1); 
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(sep);         
        BapController controller = new BapController(sc);        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = '2014';
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;        
        controller.getcertainTeedName();         
        controller.save();
        controller.saveAndClose();
        
        controller = new BapController(sc);
        controller.sep1.Year__c = null;
        controller.save();
   		Test.stopTest();
    }   
    //START Added by Kritika Bhati for S-510717
    static testMethod void myUnitTestExistingOneQ5() 
    {
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
        SEP__c sep1 = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep1;
                
        List<Stratum_Data__c> sdList = new List<Stratum_Data__c>();
        //Sets of Stratum Data
        Stratum_Data__c sd1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                  User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd1);
        
        //Creating Stratum Data Record
        Stratum_Data__c sd2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                  User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd2);
        
        Stratum_Data__c sd3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                  User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd3);
        
        Stratum_Data__c sd4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                  User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd4);
        
        //Sets of dummy Stratum data
        Stratum_Data__c sd11 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=2,Year__c=sep.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=2,User_Target_Pounds_NY__c=2,User_Target_Pounds_2YO__c=2);
        sdList.add(sd11);
        
        Stratum_Data__c sd22 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sep.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sdList.add(sd22);
        
        Stratum_Data__c sd33 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=4,Year__c=sep.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=4,User_Target_Pounds_NY__c=4,User_Target_Pounds_2YO__c=4);
        sdList.add(sd33);
        
        Stratum_Data__c sd44 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=5,Year__c=sep.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=5,User_Target_Pounds_NY__c=5,User_Target_Pounds_2YO__c=5);
        sdList.add(sd44);
        
        insert sdList;    //Inserting the List of Stratum Data.
                                                                        //Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        //Bap Goals :-
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='1', /*Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;        
        system.debug('1========>'+goal1);
        
        SEP_Goal__c goal2 = new SEP_Goal__c(Name='2', /*Goal_Number__c='2', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal2;
        system.debug('2========>'+goal2);
        
        //For Quater 3
        string myYear3 = '2012';
        string month3 = '8';
        string day3 = '5';
        string hour3 = '11';
        string minute3 = '46';
        string second3 = '20';
        string stringDate3 = myYear3 + '-' + month3 + '-' + day3 + ' ' + hour3 + ':' + minute3 +  ':' + second3;
        
        Datetime myDate3 = datetime.valueOf(stringDate3);
        Date myDate33 = date.valueOf(stringDate3);
        
        List<Event> eventListQ3 = new List<Event>();
        Event ev31 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate3,EndDateTime=myDate3,Subject='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate33,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ3.add(ev31);
        
        Event ev32 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate3,EndDateTime=myDate3,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',/*Goal_Date__c = myDate33,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ3.add(ev32);
        
        Event ev33 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate3,EndDateTime=myDate3,Subject='Account Planning',Action_Plan__c='Account Planning',/*Goal_Date__c = myDate33,SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ3.add(ev33);
        
        Event ev34 = new Event(WhatId=goal1.Id,/*Goal_Number__c='1',StartDateTime=myDate3,EndDateTime=myDate3,Subject='Account Planning',Action_Plan__c='Account Planning',Comments__c = 'test',SEP_activity__c=True,OwnerId=UserInfo.getUserId(),Status__c='Planning');
                              
        eventListQ3.add(ev34);
        
        if(eventListQ3.size() > 0)
            insert eventListQ3;
        Test.startTest();    
        ApexPages.StandardController sc = new ApexPages.StandardController(sep1); 
        BapController controller = new BapController(sc);         
        controller.sep1 = sep1;
        
        controller.save();
        controller.cloneBap(); 
        controller.closeProcess();
        controller.setHeadingsAccordingToYear();        
        controller.getcertainTeedName();
        
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v1','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v2','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:0:v3','23');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:1:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:2:v3','3');
        ApexPages.CurrentPage().getParameters().put('pg:frm:pb1:rpt:3:v3','3');
        
        controller.closeProcess(); 
        controller.getYear = '2014';
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep1.Year__c;
        controller.setHeadingsAccordingToYear(); 
        controller.sep1.Account__c = acc.Id;
        controller.sep1.Year__c = sep1.Year__c; 
        controller.getcertainTeedName();          
        controller.save();
        controller.saveAndClose();
       // Integer i =controller.rowIndex ;
        Id sepIDs = controller.sepId ;
        String st = controller.sepAccountId;
        String st1 = controller.p1;
         String st2 = controller.p2;
         SEP_Goal__c sepG =controller.oldGoal ;
        List<BapController.BapObjectiveModel> newList = new List<BapController.BapObjectiveModel>();
        newList = controller.BapObjectiveModelList1;
        newList = controller.BapObjectiveModelList2;
        newList= controller.BapObjectiveModelList3;
    
        for(BapController.BapObjectiveModel b: controller.Q3)
        {
            b.evnt.Action_Plan__c  = 'Planning';
        }
        controller.save();
        Test.stopTest();
    }
    //END S-510717
    @isTest
    public static void getStratumDateRecordsTest(){
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
        
        //Creating an Account For BAP.    
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        
        //Creating BAP Record                                                                                   //date.valueOf(sep1.Year__c + '-1-1 00:00:00');
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2009',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep;
        Test.startTest();
        ApexPages.StandardController sc = new ApexPages.StandardController(sep); 
        BapController controller = new BapController(sc);
        controller.getStratumDateRecords();
        Test.stopTest();
    }
    */
}