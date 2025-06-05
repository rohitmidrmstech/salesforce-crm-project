/*
        Name           : TestBapController2
        Author         : Mukesh Bhardwaj 
        Date           : 20th February 2013
        Description    : Test Class Which show the behaviour of BapController2 class.
*/
@isTest (seeAllData=true)
public class TestBapController2{ 
    public static TestMethod void unitTestQ1(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true limit 10];// Modified by Kritika Bhati on 31/7/2017 for S-490568
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect'
                                  /*,
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer')*/
                                  ,
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today(),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today(),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        List<Stratum_Data__c> sDataList = new List<Stratum_Data__c>();
        
        Stratum_Data__c sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='62',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        Stratum_Data__c sDataObj2 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='78',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj2);
        Stratum_Data__c sDataObj3 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='61',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj3);
        Stratum_Data__c sDataObj4 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='64',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj4);
        
        insert sDataList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);  
        BapClsObj.cloneBap();
        BapClsObj.setHeadingsAccordingToYear2();
        BapClsObj.getTMnamefromTerritory();
        BapClsObj.getcertainTeedName();
        BapClsObj.saveAndClose();
        BapClsObj.closeProcess();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ1();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ2();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ3();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ4();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteGoal();
    }    
        
    public static TestMethod void unitTestQ2(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today().addMonths(2),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today().addMonths(2),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        insert evtList;  
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);          
        BapClsObj.saveAndClose();        
    }    
    public static TestMethod void unitTestQ3(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                /* Goal_Date__c = system.today().addMonths(6),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today().addMonths(6),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);          
        BapClsObj.saveAndClose();
        
    }
    public static TestMethod void unitTestQ4(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today().addMonths(9),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today().addMonths(9),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);          
        BapClsObj.saveAndClose();       
    }    
    
    //Mechanica 
    public static TestMethod void unitTestQ5(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect', Market_Class_Desc__c = 'MECH', 
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today(),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today(),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        List<Stratum_Data__c> sDataList = new List<Stratum_Data__c>();
        
        Stratum_Data__c sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='11',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='06',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='74',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='87',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='56',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='84',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='86',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='70',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='18',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        sDataObj1 = new Stratum_Data__c(Account_Name__c=acc.Id,Actual_Pounds_CY__c=3,Year__c=sepObj.Year__c,Product_Class__c='51',
                                                   User_Target_Pounds_CY__c=3,User_Target_Pounds_NY__c=3,User_Target_Pounds_2YO__c=3);
        sDataList.add(sDataObj1);
        
        insert sDataList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);  
        BapClsObj.cloneBap();
        BapClsObj.setHeadingsAccordingToYear2();
        BapClsObj.getTMnamefromTerritory();
        BapClsObj.getcertainTeedName();
        BapClsObj.saveAndClose();
        BapClsObj.closeProcess();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ1();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ2();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ3();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ4();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteGoal();
    }
    
    //Mechanica 
    public static TestMethod void unitTestQ6(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect', Market_Class_Desc__c = 'MECH', 
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today(),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today(),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);  
        BapClsObj.cloneBap();
        BapClsObj.setHeadingsAccordingToYear2();
        BapClsObj.getTMnamefromTerritory();
        BapClsObj.getcertainTeedName();
        BapClsObj.saveAndClose();
        BapClsObj.closeProcess();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ1();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ2();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ3();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteEventQ4();
        BapClsObj.rIndex = 1;
        BapClsObj.deleteGoal();
    }
    //START Added by Kritika Bhati for S-510717
    public static TestMethod void unitTestQ7(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),
                                 /*Goal_Date__c = system.today().addMonths(9),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),
                                 /*Goal_Date__c = system.today().addMonths(9),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);          
        BapClsObj.saveAndClose();       
    }    
    
    public static TestMethod void unitTestQ8(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 WhatId=sepGoalObj.Id ,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);          
        BapClsObj.saveAndClose();       
    }    
    
    public static TestMethod void unitTestQ9(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 WhatId=sepGoalObj.Id,/*Goal_Date__c = system.today().addMonths(9),*/
                                 Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 WhatId=sepGoalObj.Id/*,Goal_Date__c = system.today().addMonths(9)*/
                                 );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);          
        BapClsObj.saveAndClose();       
    }    
    public static TestMethod void unitTestQ10(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),
                                 /*Goal_Date__c = system.today().addMonths(6),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning',Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),
                                 /*Goal_Date__c = system.today().addMonths(6),*/WhatId=sepGoalObj.Id,
                                 Action_Plan__c='Account Planning' );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);          
        BapClsObj.saveAndClose();
        
    }
      public static TestMethod void unitTestQ11(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
       
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',
                                  RecordTypeId=rTypMap.get('New Prospect, Target, Customer'),
                                  Information_Date__c=system.today()); 
        insert acc;
        
        SEP__c sepObj = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',
                                Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sepObj;
        
        SEP_Goal__c sepGoalObj = new SEP_Goal__c(SEP__c=sepObj.Id,Goal_Number1__c= 1,
                                                 Start_Date__c=System.today(),SepName__c = 'TestSep',
                                                 End_Date__c=system.today().addDays(1));
        insert sepGoalObj;
        
        List<Event> evtList = new List<Event>();
        
        Event evtObj1 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today().addMonths(6),*/WhatId=sepGoalObj.Id,
                                 Comments__c = 'test' );
        evtList.add(evtObj1);
        Event evtObj2 = new Event(StartDateTime=Datetime.now(),EndDateTime=Datetime.now(),/*Goal_Number__c = '1',*/
                                 /*Goal_Date__c = system.today().addMonths(6),*/WhatId=sepGoalObj.Id
                                  );
        evtList.add(evtObj2);
        
        
        insert evtList;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(sepObj); 
        BapController2 BapClsObj = new BapController2(sc);          
        BapClsObj.saveAndClose();
        
    }
  //END S-510717
}