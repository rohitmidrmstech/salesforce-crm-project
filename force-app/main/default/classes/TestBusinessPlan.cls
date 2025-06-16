/*********************************************************************************
* Test Class: {TestBusinessPlan}
* Created by {Arpit Vashishtha}, Navivo, {DateCreated 11/05/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Unit test for class BusinessPlan}
----------------------------------------------------------------------------------
* Utility Test Data: 
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Arpit Vashishtha 11/05/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
3.0 Hithesh Commented the class as part of Legacy api change. As no one has claimed the class assuming it is not getting used.
********************************************************************************/
@isTest
private class TestBusinessPlan {
/*
    static testMethod void myUnitTest() {
        
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
       u1.LastName = 'lastname12';
       u1.username= 'username1@first.com';
       insert u1;
       
       
       Profile p2 = [SELECT Id FROM Profile WHERE Name = 'USA TM User'];
       // Create a new System Administrator user.
       User u = new User();
       u.Email = 'email11@email.com';
       u.Alias = 'Alias21';
       u.TimeZoneSidKey = 'America/New_York';
       u.LocaleSidKey = 'ca';
       u.EmailEncodingKey = 'UTF-8';
       u.ProfileId = p2.id;
       u.LanguageLocaleKey = 'en_US';
       u.FirstName = 'firstname11';
       u.LastName = 'lastname11';
       u.username= 'username11@first.com';
       u.ManagerId = u1.id;
       insert u;
        
        
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
       
       List<Account> accList = new List<Account>();
       
       accList.add(a);
       accList.add(a1);
       
       Test.startTest();
       
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
       if(System.today().month()<11){
            bpObj.Year__c = String.valueOf(System.today().year());
       }else if(System.today().month()>= 11){
            bpObj.Year__c = String.valueOf(System.today().year() + 1);
       }
       insert bpObj;
          
       
       List<Business_Plan__c> bPlanList = new List<Business_Plan__c>();
       
       bPlanList.add(bpObj); 
       
       Test.setCurrentPage(Page.BusinessPlan);
       ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(accList);
       
       stdController.setSelected(accList);
       
       Integer testYear;
       if(System.today().month()<11){
            testYear = System.today().year();
       }else if(System.today().month()>= 11){
            testYear = System.today().year() + 1;
       }
       
       BusinessPlan bp = new BusinessPlan(stdController); 
       
       bp.bpYear = testYear;
       
       bp.addAccountToPlan();
       bp.saveCalling();
       bp.saveAndClose();
       bp.deleteId = a.Id;
       bp.deleteRecord();
       bp.saveButton();
       bp.deleteId = '';
       bp.deleteRecord();
       bp.searchBusinessPlan();
       bp.userDetail();
       Test.stopTest();
       
       //CF S-490560 Get error page messages to stop masking errors
       if(ApexPages.hasMessages()){
        for(ApexPages.Message tmpMsg : ApexPages.getMessages()){
          System.assertNotEquals(tmpMsg.getSeverity(), ApexPages.severity.ERROR, tmpMsg.getDetail());
        }
       }
       //CF S-490560 End
    }
    
    
    
    static testMethod void myUnitTest1() {
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
       
       List<Account> accList = new List<Account>();
       
       accList.add(a);
       accList.add(a1);
       
       Test.startTest();
       
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
       if(System.today().month()<11){
            bpObj.Year__c = String.valueOf(System.today().year() - 1);
       }else if(System.today().month()>= 11){
            bpObj.Year__c = String.valueOf(System.today().year() + 1 - 1);
       }
       insert bpObj;
          
       
       List<Business_Plan__c> bPlanList = new List<Business_Plan__c>();
       
       bPlanList.add(bpObj); 
       
       Test.setCurrentPage(Page.BusinessPlan);
       ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(accList);
       
       stdController.setSelected(accList);
       
       Integer testYear;
       if(System.today().month()<11){
            testYear = System.today().year() - 1;
       }else if(System.today().month()>= 11){
            testYear = System.today().year() + 1 - 1;
       }
       
       BusinessPlan bp = new BusinessPlan(stdController); 
       
       bp.bpYear = testYear;
       
       bp.addAccountToPlan();
       bp.saveCalling();
       bp.saveAndClose();
       bp.deleteId = a.Id;
       bp.deleteRecord();
       bp.saveButton();
       bp.deleteId = '';
       bp.deleteRecord();
       Test.stopTest();
       //CF S-490560 Get error page messages to stop masking errors
       if(ApexPages.hasMessages()){
        for(ApexPages.Message tmpMsg : ApexPages.getMessages()){
          System.assertNotEquals(tmpMsg.getSeverity(), ApexPages.severity.ERROR, tmpMsg.getDetail());
        }
       }
       //CF S-490560 End     
    }
    
    static testMethod void myUnitTest2(){
        
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
       u1.username= 'username1@first.com.test';
       insert u1;
       
       
       Profile p2 = [SELECT Id FROM Profile WHERE Name = 'USA TM User'];
       // Create a new System Administrator user.
       User u = new User();
       u.Email = 'email11@email.com';
       u.Alias = 'Alias21';
       u.TimeZoneSidKey = 'America/New_York';
       u.LocaleSidKey = 'ca';
       u.EmailEncodingKey = 'UTF-8';
       u.ProfileId = p2.id;
       u.LanguageLocaleKey = 'en_US';
       u.FirstName = 'firstname11';
       u.LastName = 'lastname11';
       u.username= 'username11@first.com';
       u.ManagerId = u1.id;
       insert u;
      
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
       
       List<Account> accList = new List<Account>();
       
       accList.add(a);
       accList.add(a1);
       
       Test.startTest();
       
       System.runas(u1){
       
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
           if(System.today().month()<11){
                bpObj.Year__c = String.valueOf(System.today().year() - 1);
           }else if(System.today().month()>= 11){
                bpObj.Year__c = String.valueOf(System.today().year() + 1 - 1);
           }
           insert bpObj;
              
           
           List<Business_Plan__c> bPlanList = new List<Business_Plan__c>();
           
           bPlanList.add(bpObj); 
           
           Test.setCurrentPage(Page.BusinessPlan);
           ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(accList);
           
           stdController.setSelected(accList);
           
           Integer testYear;
           if(System.today().month()<11){
                testYear = System.today().year() - 1;
           }else if(System.today().month()>= 11){
                testYear = System.today().year() + 1 - 1;
           }
           
           BusinessPlan bp = new BusinessPlan(stdController); 
           
           bp.bpYear = testYear;
           
           bp.addAccountToPlan();
           bp.saveCalling();
           bp.saveAndClose();
           bp.deleteId = a.Id;
           bp.deleteRecord();
           bp.saveButton();
           bp.deleteId = '';
           bp.deleteRecord();
        
       }
       
       
       Test.stopTest();
        //CF S-490560 Start Get error page messages to stop masking errors
       if(ApexPages.hasMessages()){
        for(ApexPages.Message tmpMsg : ApexPages.getMessages()){
          System.assertNotEquals(tmpMsg.getSeverity(), ApexPages.severity.ERROR, tmpMsg.getDetail());
        }
       }
       //CF S-490560 End             
    }
    
    static testMethod void myUnitTest3(){
        
       
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
       
       List<Account> accList = new List<Account>();
       
       accList.add(a);
       accList.add(a1);
       
       Test.startTest();
       
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
       if(System.today().month()<11){
            bpObj.Year__c = String.valueOf(System.today().year() - 1);
       }else if(System.today().month()>= 11){
            bpObj.Year__c = String.valueOf(System.today().year() + 1 - 1);
       }
       insert bpObj;
          
       
       List<Business_Plan__c> bPlanList = new List<Business_Plan__c>();
       
       bPlanList.add(bpObj); 
       
       Test.setCurrentPage(Page.BusinessPlan);
       ApexPages.currentPage().getParameters().put('bp','new');
       ApexPages.currentPage().getParameters().put('aid',a.Id);
       ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(accList);
       
       stdController.setSelected(accList);
       
       Integer testYear;
       if(System.today().month()<11){
            testYear = System.today().year() - 1;
       }else if(System.today().month()>= 11){
            testYear = System.today().year() + 1 - 1;
       }
       User thisUser = [ select Id from User where Id = :UserInfo.getUserId() AND Profile.Name=: 'System Administrator' ];
       String profileName = 'Canada Standard Profile';

       // Updated by Liquidhub during deployment for Gypsum 12/15/2017 - Vincent Ip
     //  Id productionId = '00Dd0000000h748';
       Id productionId = '00D3F0000000zt2UAA';
        
       if(URL.getSalesforceBaseUrl().toExternalForm().contains('ctgypsum.my.salesforce.com') || 
          UserInfo.getOrganizationId() == productionId){
          profileName = 'Canada Standard Profile';
       }
        User objUser = [SELECT Id FROM User WHERE Id =: UserInfo.getUserId() LIMIT 1];
        System.runAs(objUser){
           User thisUser1 = [ select Id from User where Profile.Name=:profileName Limit 1];
      	 //User thisUser1 = [ select Id from User where Profile.Name= 'Customer Service Canada'];
      	 thisUser1.ManagerId = thisUser.ID;
      	 thisUser1.isActive = true;
       		Update thisUser1; 
        }
       
        
       BusinessPlan bp = new BusinessPlan(stdController); 
       ApexPages.currentPage().getParameters().put('bp','edit');
       bp = new BusinessPlan(stdController);
   
       bp.bpYear = testYear;
       
       bp.addAccountToPlan();
       bp.saveCalling();
       bp.saveAndClose();
       bp.deleteId = a.Id;
       bp.deleteRecord();
       bp.saveButton();
       bp.deleteId = '';
       bp.deleteRecord();
       bp.budget = '';
       bp.planned = '';
       bp.q1 = '';
       bp.q2 = '';
       bp.q3 = '';
       bp.q4 = '';
       bp.totalYTD = '';
       bp.previousYearActual = '';
       bp.ytdActualPercentToBudget = '';
       bp.firstDate = System.Today();
       bp.lastDate = System.Today();
       bp.budgetAllBoards = 5;
       bp.abc = true;
       bp.showManagerPanel = true;
       bp.userOption = new list<selectoption>();
       bp.userName = '';
       bp.userCode = '';
       bp.searchBusinessPlan();
       //CF S-490560 Start
       bp.Wrapper[0].viewAccHierarchy = true;
       bp.accountId = a.Id;
       bp.viewHierarchy(); 
       a.BillingCity = null;

       //CF S-490560 ENd
       Test.stopTest();

        //CF S-490560 Start Get error page messages to stop masking errors
       if(ApexPages.hasMessages()){
        for(ApexPages.Message tmpMsg : ApexPages.getMessages()){
          System.assertNotEquals(tmpMsg.getSeverity(), ApexPages.severity.ERROR, tmpMsg.getDetail());
        }
       }
       //CF S-490560 End

    } */
}