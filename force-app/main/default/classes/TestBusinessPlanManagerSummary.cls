/*********************************************************************************
* Test Class: {TestBusinessPlanManagerSummary}
* Created by Arpit Vashishtha(Navivo), DateCreated: 12/01/2014
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Unit test for class BusinessPlanManagerSummary}
----------------------------------------------------------------------------------
* Utility Test Data: 
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Arpit Vashishtha(Navivo)   12/01/2014       INITIAL DEVELOPMENT
2.0 Name                       MM/DD/YYYY      UDAC WIRE FRAME CHANGES
3.0 Christian Belko            07/18/2017      Updated Ln 21 profileName
4.0 Hithesh                    15/05/2025      Commented the class as part of Legacy api change. As no one has claimed the class assuming it is not getting used.
********************************************************************************/
@isTest
private class TestBusinessPlanManagerSummary {
/*
    static testMethod void myUnitTest() {
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
            List<User> managerUsers = new List<User>();
            managerUsers.add(u1);
            managerUsers.add(u);
        
        System.runAs(u1){
            //----------------------------------------------------------------------------------------------------
            Account a = new Account();
            
            a.Name = 'Test Account';
            a.BillingState = 'North York';
            a.BillingCity = 'ON';
            a.Name = 'Test';
            a.BillingStreet = 'Test';
            a.BillingCity = 'Lewiston';
            a.BillingState = 'New York';
            a.BillingPostalCode = '10254';
            insert a;
            
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
            bpObj.Budget_All_Boards__c = 10;
            //bpObj.Year__c = '2015';
            bpObj.User_Id__c = u1.Id;
            if(System.today().month()<11){
                bpObj.Year__c = String.valueOf(System.today().year());
            }else if(System.today().month()>= 11){
                bpObj.Year__c = String.valueOf(System.today().year() + 1);
            }
            insert bpObj;
            Business_Plan_Others__c   bpo = new Business_Plan_Others__c ();
            bpo.Account_Id__c = a.id;
            //bpo.Year__c =String.valueOf(System.today().year() + 1);
            if(System.today().month()<11){
                bpo.Year__c = String.valueOf(System.today().year());
            }else if(System.today().month()>= 11){
                bpo.Year__c = String.valueOf(System.today().year() + 1);
            }
            bpo.Name = u.id;
            System.debug('NameIS-=='+u1.Id);
            System.debug('NameIS---'+u.Id);
            insert bpo;
            List<Business_Plan__c> bpList = new List<Business_Plan__c>();
            Set<Id> userIdSet = new Set<Id>();
            userIdSet.add(u1.id);
            bpList = [Select b.All_Board_Actual_to_Budget__c, b.VAP_Actual_to_Budget__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.Total_YTD_VAP__c, b.Total_YTD_Tape__c, b.Total_YTD_Finishing__c, b.Total_YTD_All_Board__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Planned_All_Boards__c, b.Id,b.Year__c From Business_Plan__c b  where b.User_Id__c IN: userIdSet];
            //-----------------------------------------------------------------------------------------------------
            System.debug('debug 1:::'+bpObj);
            System.debug('debug 2:::'+bpList);
            BusinessPlanManagerSummary bpms = new BusinessPlanManagerSummary();
            bpms.year = 2015;
            bpms.userId = u1.Id;
            
            system.debug('UserDetailIs-----'+u1.Id+'------'+bpms.year+'----'+u1+'----'+u+'---'+ bpms.userId);
        }
        test.stopTest();
    } */
}