/*********************************************************************************
* Test Class: {TestBusinessPlan}
* Created by Yogesh Kumar(Navivo), DateCreated: 11/28/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Unit test for class BusinessPlanReport}
----------------------------------------------------------------------------------
* Utility Test Data: 
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Yogesh Kumar(Navivo)   11/28/2014       INITIAL DEVELOPMENT
2.0 Name                   MM/DD/YYYY      UDAC WIRE FRAME CHANGES
3.0 Christian Belko        06/23/2017      Updated Profile Names and Test Data.
4.0 Hithesh                15/05/2025      Commented the class as part of Legacy api change. As no one has claimed the class assuming it is not getting used.
********************************************************************************/
@isTest
private class TestBusinessPlanReport {
/*
    static testMethod void myUnitTest() {
        test.startTest();
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;
        
        Account a = new Account();
        Business_Plan__c bpObj = new Business_Plan__c();
        a.Name = 'Test Account';
        a.BillingState = 'North York';
        a.BillingCity = 'ON';
        a.Name = 'Test';
        a.BillingState = 'Test State';
        a.BillingCity = 'Test City';
        insert a;
        bpObj.Previous_Year_Actual_Finishing__c = 10;
        bpObj.Previous_Year_Actual_All_Boards__c = 10;
        bpObj.Previous_Year_Actual_Tape__c = 10;
        bpObj.Previous_Year_Actual_VAP__c = 10;
        bpObj.Budget_VAP_of_Boards__c = 10;
        bpObj.Actual_VAP_of_Boards__c = 10;
        bpObj.VAP_Actual_to_Budget__c = 10;
        bpObj.Planned_VAP__c = 10;
        bpObj.Planned_Tape__c = 10;
        bpObj.Planned_Finishing__c = 10;
        bpObj.Tape_Actual_to_Budget__c = 10;
        bpObj.Finishing_Actual_to_Budget__c = 10;
        bpObj.All_Board_Actual_to_Budget__c = 10;
        bpObj.Total_YTD_Finishing__c = 10;
        bpObj.Q4_Finishing__c = 10;
        bpObj.Q3_Finishing__c = 10;
        bpObj.Q2_Finishing__c = 10;
        bpObj.Q1_Finishing__c = 10;
        bpObj.Budget_Finishing__c = 10;
        bpObj.Total_YTD_Tape__c = 10;
        bpObj.Q4_Tape__c = 10;
        bpObj.Q3_Tape__c = 10;
        bpObj.Q2_Tape__c = 10;
        bpObj.Q1_Tape__c = 10;
        bpObj.Budget_Tape__c = 10;
        bpObj.Total_YTD_VAP__c = 10;
        bpObj.Q4_VAP__c = 10;
        bpObj.Q3_VAP__c = 10;
        bpObj.Q2_VAP__c = 10;
        bpObj.Q1_VAP__c = 10;
        bpObj.Budget_VAP__c = 10;
        bpObj.Total_YTD_All_Board__c = 10;
        bpObj.Q4_All_Boards__c = 10;
        bpObj.Q3_All_Boards__c = 10;
        bpObj.Q2_All_Boards__c = 10;
        bpObj.Q1_All_Boards__c = 10;
        bpObj.Planned_All_Boards__c = 10;
        bpObj.Account__c = a.Id; 
        bpObj.User_Id__c = UserInfo.getUserId();
        bpObj.Budget_All_Boards__c = 10;
        //bpObj.Year__c = String.valueOf(2015);
        if(System.today().month()<11){
            bpObj.Year__c = String.valueOf(System.today().year());
        }else if(System.today().month()>= 11){
            bpObj.Year__c = String.valueOf(System.today().year() + 1);
        }
        insert bpObj;
        system.debug('BPObjIs'+bpObj);
        Business_Plan_Others__c   bpo = new Business_Plan_Others__c ();
        bpo.Account_Id__c = a.id;
        bpo.Year__c =String.valueOf(System.today().year() + 1);
        bpo.Name = u1.id;
        insert bpo;
        system.debug('BPOther'+bpo);
        system.debug('UserId'+u1);
        CTG_Strategy__c ctg = new CTG_Strategy__c ();
        ctg.Account__c = a.id;
        insert ctg;
        
        Customer_Strategy__c  cs = new Customer_Strategy__c ();
        cs.Account__c = a.id;
        insert cs;
        
        Integer testYear;
        if(System.today().month()<11){
            testYear = System.today().year();
        }else if(System.today().month()>= 11){
            testYear = System.today().year() + 1;
        }
        BusinessPlanReport bp = new BusinessPlanReport();
        bp.year = testYear;
        bp.userId = u1.Id;
        bp.fetchAccountId();
        bp.searchReport();
        bp.userDetail();
        
        apexpages.currentpage().getparameters().put('uId', u1.Id);
        apexpages.currentpage().getparameters().put('year', String.valueOf(testYear));
        apexpages.currentpage().getparameters().put('tmName', u1.Id);
        apexpages.currentpage().getparameters().put('tmCode', u1.User_Territory_Code__c);
        apexpages.currentpage().getparameters().put('tmUserName', u1.Name);
        
        bp = new BusinessPlanReport();
        test.stopTest();
    }
     static testMethod void myUnitTest1() {
        test.startTest();
        String profileName = 'USA RM User'; //S-493803 [Hemant 9/8/2017] - Fix Test Failures 
        if(URL.getSalesforceBaseUrl().toExternalForm().contains('na')){
           profileName = 'USA RM User';
       }
        Profile p1 = [SELECT Id FROM Profile WHERE Name =:profileName];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'USA TM User'];
        // Create a new System Administrator user.
        User u = new User();
        u.Email = 'email11@email.com';
        u.Alias = 'Alias211';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'ca';
        u.EmailEncodingKey = 'UTF-8';
        u.ProfileId = p2.id;
        u.LanguageLocaleKey = 'en_US';
        u.FirstName = 'firstname11';
        u.LastName = 'lastname121';
        u.username= 'username11@first.com';
        u.ManagerId = u1.id;
        insert u;
        
        Account a = new Account();
        Business_Plan__c bpObj = new Business_Plan__c();
        a.Name = 'Test Account';
        a.BillingState = 'North York';
        a.BillingCity = 'ON';
        a.Name = 'Test';
        a.BillingState = 'Test State';
        a.BillingCity = 'Test City';
        insert a;
        bpObj.Previous_Year_Actual_Finishing__c = 10;
        bpObj.Previous_Year_Actual_All_Boards__c = 10;
        bpObj.Previous_Year_Actual_Tape__c = 10;
        bpObj.Previous_Year_Actual_VAP__c = 10;
        bpObj.Budget_VAP_of_Boards__c = 10;
        bpObj.Actual_VAP_of_Boards__c = 10;
        bpObj.VAP_Actual_to_Budget__c = 10;
        bpObj.Planned_VAP__c = 10;
        bpObj.Planned_Tape__c = 10;
        bpObj.Planned_Finishing__c = 10;
        bpObj.Tape_Actual_to_Budget__c = 10;
        bpObj.Finishing_Actual_to_Budget__c = 10;
        bpObj.All_Board_Actual_to_Budget__c = 10;
        bpObj.Total_YTD_Finishing__c = 10;
        bpObj.Q4_Finishing__c = 10;
        bpObj.Q3_Finishing__c = 10;
        bpObj.Q2_Finishing__c = 10;
        bpObj.Q1_Finishing__c = 10;
        bpObj.Budget_Finishing__c = 10;
        bpObj.Total_YTD_Tape__c = 10;
        bpObj.Q4_Tape__c = 10;
        bpObj.Q3_Tape__c = 10;
        bpObj.Q2_Tape__c = 10;
        bpObj.Q1_Tape__c = 10;
        bpObj.Budget_Tape__c = 10;
        bpObj.Total_YTD_VAP__c = 10;
        bpObj.Q4_VAP__c = 10;
        bpObj.Q3_VAP__c = 10;
        bpObj.Q2_VAP__c = 10;
        bpObj.Q1_VAP__c = 10;
        bpObj.Budget_VAP__c = 10;
        bpObj.Total_YTD_All_Board__c = 10;
        bpObj.Q4_All_Boards__c = 10;
        bpObj.Q3_All_Boards__c = 10;
        bpObj.Q2_All_Boards__c = 10;
        bpObj.Q1_All_Boards__c = 10;
        bpObj.Planned_All_Boards__c = 10;
        bpObj.Account__c = a.Id; 
        bpObj.User_Id__c = UserInfo.getUserId();
        bpObj.Budget_All_Boards__c = 10;
        //bpObj.Year__c = String.valueOf(2015);
        if(System.today().month()<11){
            bpObj.Year__c = String.valueOf(System.today().year());
        }else if(System.today().month()>= 11){
            bpObj.Year__c = String.valueOf(System.today().year() + 1);
        }
        insert bpObj;
        
        Business_Plan_Others__c   bpo = new Business_Plan_Others__c ();
        bpo.Account_Id__c = a.id;
        bpo.Year__c =String.valueOf(System.today().year() + 1);
        bpo.Name = u1.id;
        insert bpo;
        
        CTG_Strategy__c ctg = new CTG_Strategy__c ();
        ctg.Account__c = a.id;
        insert ctg;
        
        Customer_Strategy__c  cs = new Customer_Strategy__c ();
        cs.Account__c = a.id;
        insert cs;
        
        Integer testYear;
        if(System.today().month()<11){
            testYear = System.today().year();
        }else if(System.today().month()>= 11){
            testYear = System.today().year() + 1;
        }
        BusinessPlanReport bp = new BusinessPlanReport();
        bp.year = testYear;
        bp.userId = u1.Id;
        bp.userSelected = u1.id;
        bp.fetchAccountId();
        bp.searchReport();
        bp.userDetail();
        test.stopTest();
    }
    
    static testMethod void myUnitTest2() {
        test.startTest();
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingState = 'North York';
        a.BillingCity = 'ON';
        insert a;
        
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.BillingState = 'Test State';
        a1.BillingCity = 'Test City';
        insert a1;
        
        Contact c = new Contact();
        c.FirstName = 'test';
        c.LastName = 'test';
        c.Email = 'test@test.com'; 
        c.AccountId = a.Id;
        //START S-493803 [Hemant 9/8/2017] - Fix Test Failures
        c.MailingStreet='20 moores Road';
        c.MailingCity='Malvern';
        c.MailingState='PA';
        c.MailingPostalCode='19355';
        c.Phone='6101234545';
        //END S-493803 [Hemant 9/8/2017] - Fix Test Failures
        insert c;
        
        Contact c1 = new Contact();
        c1.FirstName = 'test1';
        c1.LastName = 'test1';
        c1.Email = 'test1@test.com'; 
        c1.AccountId = a.Id;
        //START S-493803 [Hemant 9/8/2017] - Fix Test Failures
        c1.MailingStreet='19 moores Road';
        c1.MailingCity='Malvern';
        c1.MailingState='PA';
        c1.MailingPostalCode='19344';
        c1.Phone='6102224444';
        //END S-493803 [Hemant 9/8/2017] - Fix Test Failures
        insert c1;
        
        Business_Plan__c bpObj = new Business_Plan__c();
        bpObj.Previous_Year_Actual_Finishing__c = 10;
        bpObj.Previous_Year_Actual_All_Boards__c = 10;
        bpObj.Previous_Year_Actual_Tape__c = 10;
        bpObj.Previous_Year_Actual_VAP__c = 10;
        bpObj.Budget_VAP_of_Boards__c = 10;
        bpObj.Actual_VAP_of_Boards__c = 10;
        bpObj.VAP_Actual_to_Budget__c = 10;
        bpObj.Planned_VAP__c = 10;
        bpObj.Planned_Tape__c = 10;
        bpObj.Planned_Finishing__c = 10;
        bpObj.Tape_Actual_to_Budget__c = 10;
        bpObj.Finishing_Actual_to_Budget__c = 10;
        bpObj.All_Board_Actual_to_Budget__c = 10;
        bpObj.Total_YTD_Finishing__c = 10;
        bpObj.Q4_Finishing__c = 10;
        bpObj.Q3_Finishing__c = 10;
        bpObj.Q2_Finishing__c = 10;
        bpObj.Q1_Finishing__c = 10;
        bpObj.Budget_Finishing__c = 10;
        bpObj.Total_YTD_Tape__c = 10;
        bpObj.Q4_Tape__c = 10;
        bpObj.Q3_Tape__c = 10;
        bpObj.Q2_Tape__c = 10;
        bpObj.Q1_Tape__c = 10;
        bpObj.Budget_Tape__c = 10;
        bpObj.Total_YTD_VAP__c = 10;
        bpObj.Q4_VAP__c = 10;
        bpObj.Q3_VAP__c = 10;
        bpObj.Q2_VAP__c = 10;
        bpObj.Q1_VAP__c = 10;
        bpObj.Budget_VAP__c = 10;
        bpObj.Total_YTD_All_Board__c = 10;
        bpObj.Q4_All_Boards__c = 10;
        bpObj.Q3_All_Boards__c = 10;
        bpObj.Q2_All_Boards__c = 10;
        bpObj.Q1_All_Boards__c = 10;
        bpObj.Planned_All_Boards__c = 10;
        bpObj.Account__c = a.Id; 
        bpObj.User_Id__c = UserInfo.getUserId();
        bpObj.Budget_All_Boards__c = 10;
        //bpObj.Year__c = String.valueOf(2015);
        if(System.today().month()<11){
            bpObj.Year__c = String.valueOf(System.today().year());
        }else if(System.today().month()>= 11){
            bpObj.Year__c = String.valueOf(System.today().year() + 1);
        }
        insert bpObj;
        system.debug('BPObjIs'+bpObj);
        Business_Plan_Others__c   bpo = new Business_Plan_Others__c ();
        bpo.Account_Id__c = a.id;
        bpo.Year__c =String.valueOf(System.today().year() + 1);
        bpo.Name = u1.id;
        insert bpo;
        system.debug('BPOther'+bpo);
        system.debug('UserId'+u1);
        CTG_Strategy__c ctg = new CTG_Strategy__c ();
        ctg.Account__c = a.id;
        insert ctg;
        
        Customer_Strategy__c  cs = new Customer_Strategy__c ();
        cs.Account__c = a.id;
        insert cs;
        
        EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = UserInfo.getUserId(), TemplateType= 'Text', Name = 'test'); 
        //insert e;
        
        ApexPages.currentPage().getParameters().put('accountRecId', a.Id);
        ApexPages.currentPage().getParameters().put('urlHierarchy', 'yes');
        
        BusinessPlanAccountReport bpa = new BusinessPlanAccountReport(new Apexpages.Standardcontroller(a));
        bpa.viewHierarchy();
        bpa.contSelected = c.Id;
        bpa.sendEmail();
        
        
        ApexPages.currentPage().getParameters().put('id',a.Id);
        BusinessPlanAccountReport bpa1 = new BusinessPlanAccountReport();
        bpa.sendEmail();
    }
    
    static testMethod void myUnitTest3() {
        test.startTest();
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;
        
        User u2 = new User();
        u2.Email = 'email1@email.com';
        u2.Alias = 'Alias3';
        u2.TimeZoneSidKey = 'America/New_York';
        u2.LocaleSidKey = 'ca';
        u2.EmailEncodingKey = 'UTF-8';
        u2.ProfileId = p1.id;
        u2.LanguageLocaleKey = 'en_US';
        u2.FirstName = 'firstname1';
        u2.LastName = 'lastname1';
        u2.username= 'username2@first.com';
        u2.ManagerId = u1.Id;
        insert u2;
        
        Account a = new Account();
        Business_Plan__c bpObj = new Business_Plan__c();
        a.Name = 'Test Account';
        a.BillingState = 'North York';
        a.BillingCity = 'ON';
        a.Name = 'Test';
        a.BillingState = 'Test State';
        a.BillingCity = 'Test City';
        insert a;
        bpObj.Previous_Year_Actual_Finishing__c = 10;
        bpObj.Previous_Year_Actual_All_Boards__c = 10;
        bpObj.Previous_Year_Actual_Tape__c = 10;
        bpObj.Previous_Year_Actual_VAP__c = 10;
        bpObj.Budget_VAP_of_Boards__c = 10;
        bpObj.Actual_VAP_of_Boards__c = 10;
        bpObj.VAP_Actual_to_Budget__c = 10;
        bpObj.Planned_VAP__c = 10;
        bpObj.Planned_Tape__c = 10;
        bpObj.Planned_Finishing__c = 10;
        bpObj.Tape_Actual_to_Budget__c = 10;
        bpObj.Finishing_Actual_to_Budget__c = 10;
        bpObj.All_Board_Actual_to_Budget__c = 10;
        bpObj.Total_YTD_Finishing__c = 10;
        bpObj.Q4_Finishing__c = 10;
        bpObj.Q3_Finishing__c = 10;
        bpObj.Q2_Finishing__c = 10;
        bpObj.Q1_Finishing__c = 10;
        bpObj.Budget_Finishing__c = 10;
        bpObj.Total_YTD_Tape__c = 10;
        bpObj.Q4_Tape__c = 10;
        bpObj.Q3_Tape__c = 10;
        bpObj.Q2_Tape__c = 10;
        bpObj.Q1_Tape__c = 10;
        bpObj.Budget_Tape__c = 10;
        bpObj.Total_YTD_VAP__c = 10;
        bpObj.Q4_VAP__c = 10;
        bpObj.Q3_VAP__c = 10;
        bpObj.Q2_VAP__c = 10;
        bpObj.Q1_VAP__c = 10;
        bpObj.Budget_VAP__c = 10;
        bpObj.Total_YTD_All_Board__c = 10;
        bpObj.Q4_All_Boards__c = 10;
        bpObj.Q3_All_Boards__c = 10;
        bpObj.Q2_All_Boards__c = 10;
        bpObj.Q1_All_Boards__c = 10;
        bpObj.Planned_All_Boards__c = 10;
        bpObj.Account__c = a.Id; 
        bpObj.User_Id__c = UserInfo.getUserId();
        bpObj.Budget_All_Boards__c = 10;
        //bpObj.Year__c = String.valueOf(2015);
        if(System.today().month()<11){
            bpObj.Year__c = String.valueOf(System.today().year());
        }else if(System.today().month()>= 11){
            bpObj.Year__c = String.valueOf(System.today().year() + 1);
        }
        insert bpObj;
        system.debug('BPObjIs'+bpObj);
        Business_Plan_Others__c   bpo = new Business_Plan_Others__c ();
        bpo.Account_Id__c = a.id;
        //bpo.Year__c =String.valueOf(System.today().year() + 1);
        if(System.today().month()<11){
            bpo.Year__c = String.valueOf(System.today().year());
        }else if(System.today().month()>= 11){
            bpo.Year__c = String.valueOf(System.today().year() + 1);
        }
        bpo.Name = u1.id;
        insert bpo;
        system.debug('BPOther'+bpo);
        system.debug('UserId...'+u2.Id);
        CTG_Strategy__c ctg = new CTG_Strategy__c ();
        ctg.Account__c = a.id;
        insert ctg;
        
        Customer_Strategy__c  cs = new Customer_Strategy__c ();
        cs.Account__c = a.id;
        insert cs;
        
        Integer testYear;
        if(System.today().month()<11){
            testYear = System.today().year();
        }else if(System.today().month()>= 11){
            testYear = System.today().year() + 1;
        }
        system.runAs(u1){
            BusinessPlanReport bp = new BusinessPlanReport();
            bp.year = testYear;
            bp.userId = u1.Id;
            bp.fetchAccountId();
            bp.searchReport();
            bp.userDetail();
            test.stopTest();
        }
    }
    
    static testMethod void myUnitTest4() {
        test.startTest();
        String profileName = 'USA RM User'; //S-493803 [Hemant 9/8/2017] - Fix Test Failures
       if(URL.getSalesforceBaseUrl().toExternalForm().contains('na')){
           profileName = 'USA RM User';
       }
        Profile p1 = [SELECT Id FROM Profile WHERE Name =:profileName];
        UserRole ur = [Select Id from UserRole where Name = 'RSM - South Central'];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'RSM';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.UserRoleId = ur.Id;
        insert u1;
            
        System.runAs(u1) {
            Set<Id> setAccountIDs = new Set<Id>();
            Account a = new Account();
            a.Name = 'Test Account';
            a.BillingCity = 'Lewiston';
            a.BillingStreet = 'test';
            a.BillingState = 'New York';
            a.BillingPostalCode = '10254';
            
            insert a;
            setAccountIDs.add(a.Id);
            
            Account a1 = new Account();
            a1.Name = 'Test';
            a1.BillingState = 'Test State';
            a1.BillingCity = 'Test City';
            a1.BillingStreet = 'test';
            a1.BillingPostalCode = '10254';
            insert a1;
            setAccountIDs.add(a1.Id);
            
            Contact c = new Contact();
            c.FirstName = 'test';
            c.LastName = 'test';
            c.Email = 'test@test.com'; 
            c.AccountId = a.Id;
            c.MailingStreet = 'Test';
            c.MailingCity = 'Test';
            c.MailingState = 'Test';
            //START S-493803 [Hemant 9/8/2017] - Fix Test Failures
            c.MailingPostalCode = '19345';
            c.Phone='6101234567';
            //END S-493803 [Hemant 9/8/2017] - Fix Test Failures
            insert c;
            
            
            Contact c1 = new Contact();
            //START S-493803 [Hemant 9/8/2017] - Fix Test Failures
            c1.FirstName = 'test1 c1';
            c1.LastName = 'test1 c1c1';
            c1.Email = 'test1@saint-gobain.com'; 
            c1.AccountId = a.Id;
            c1.MailingStreet = 'Test c1';
            c1.MailingCity = 'Test c2';
            c1.MailingState = 'Test c3';
            c1.MailingPostalCode = '10254';
            c1.Phone='6101233535';
            //END S-493803 [Hemant 9/8/2017] - Fix Test Failures
            insert c1;
            
            
            Business_Plan__c bpObj = new Business_Plan__c();
            bpObj.Previous_Year_Actual_Finishing__c = 10;
            bpObj.Previous_Year_Actual_All_Boards__c = 10;
            bpObj.Previous_Year_Actual_Tape__c = 10;
            bpObj.Previous_Year_Actual_VAP__c = 10;
            bpObj.Budget_VAP_of_Boards__c = 10;
            bpObj.Actual_VAP_of_Boards__c = 10;
            bpObj.VAP_Actual_to_Budget__c = 10;
            bpObj.Planned_VAP__c = 10;
            bpObj.Planned_Tape__c = 10;
            bpObj.Planned_Finishing__c = 10;
            bpObj.Tape_Actual_to_Budget__c = 10;
            bpObj.Finishing_Actual_to_Budget__c = 10;
            bpObj.All_Board_Actual_to_Budget__c = 10;
            bpObj.Total_YTD_Finishing__c = 10;
            bpObj.Q4_Finishing__c = 10;
            bpObj.Q3_Finishing__c = 10;
            bpObj.Q2_Finishing__c = 10;
            bpObj.Q1_Finishing__c = 10;
            bpObj.Budget_Finishing__c = 10;
            bpObj.Total_YTD_Tape__c = 10;
            bpObj.Q4_Tape__c = 10;
            bpObj.Q3_Tape__c = 10;
            bpObj.Q2_Tape__c = 10;
            bpObj.Q1_Tape__c = 10;
            bpObj.Budget_Tape__c = 10;
            bpObj.Total_YTD_VAP__c = 10;
            bpObj.Q4_VAP__c = 10;
            bpObj.Q3_VAP__c = 10;
            bpObj.Q2_VAP__c = 10;
            bpObj.Q1_VAP__c = 10;
            bpObj.Budget_VAP__c = 10;
            bpObj.Total_YTD_All_Board__c = 10;
            bpObj.Q4_All_Boards__c = 10;
            bpObj.Q3_All_Boards__c = 10;
            bpObj.Q2_All_Boards__c = 10;
            bpObj.Q1_All_Boards__c = 10;
            bpObj.Planned_All_Boards__c = 10;
            bpObj.Account__c = a.Id; 
            bpObj.User_Id__c = UserInfo.getUserId();
            bpObj.Budget_All_Boards__c = 10;
            //bpObj.Year__c = String.valueOf(2015);
            if(System.today().month()<11){
                bpObj.Year__c = String.valueOf(System.today().year());
            }else if(System.today().month()>= 11){
                bpObj.Year__c = String.valueOf(System.today().year() + 1);
            }
            insert bpObj;
            system.debug('BPObjIs'+bpObj);
            Business_Plan_Others__c   bpo = new Business_Plan_Others__c ();
            bpo.Account_Id__c = a.id;
            bpo.Year__c =String.valueOf(System.today().year() + 1);
            bpo.Name = u1.id;
            insert bpo;
            system.debug('BPOther'+bpo);
            system.debug('UserId'+u1);
            CTG_Strategy__c ctg = new CTG_Strategy__c ();
            ctg.Account__c = a.id;
            insert ctg;
            
            Customer_Strategy__c  cs = new Customer_Strategy__c ();
            cs.Account__c = a.id;
            insert cs;
            
        
            ApexPages.currentPage().getParameters().put('accountRecId', a.Id);
            ApexPages.currentPage().getParameters().put('hierarchy', 'yes');
            ApexPages.currentPage().getParameters().put('uId', a.Id);
            ApexPages.currentPage().getParameters().put('year', String.valueOf(System.today().year()));
            
            BusinessPlanAccountReport bpa = new BusinessPlanAccountReport(new Apexpages.Standardcontroller(a));
            bpa.viewHierarchy();
            bpa.viewHierarchyChk = false;
            bpa.fetchBPDetails();
            bpa.sendEmail();
            
            ApexPages.currentPage().getParameters().put('id',a.Id);
            BusinessPlanAccountReport bpa1 = new BusinessPlanAccountReport();
            bpa.viewHierarchyChk = false;
            bpa1.fetchBPDetails();
            bpa.sendEmail();
            String aid = bpa.getAccountRecId();
            bpa.setAccountRecId(aId);
            BusinessPlanAccountReport.NotShared thisnotshared = new BusinessPlanAccountReport.NotShared();
            Set<Id> someTestIDs = thisnotshared.queryOnAccounts(setAccountIDs);
            List<Account> listsomeAccounts = thisnotshared.getAccount('SELECT ID FROM Account', setAccountIDs);
            
            ApexPages.currentPage().getParameters().put('uId', '65365435');
            ApexPages.currentPage().getParameters().put('id','65365435');
            bpa1 = new BusinessPlanAccountReport();
            bpa.viewHierarchyChk = true;
            bpa1.fetchBPDetails();
            bpa.userSelected = '65365435';
            bpa.viewHierarchy();
        }
        
    } */
}