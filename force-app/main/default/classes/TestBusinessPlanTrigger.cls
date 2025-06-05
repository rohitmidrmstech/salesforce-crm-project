/*********************************************************************************
* Test Class: {TestBusinessPlanTrigger}
* Created by {Arpit Vashishtha}, Navivo, {DateCreated 12/04/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Unit test for class BusinessPlanTrigger}
----------------------------------------------------------------------------------
* Utility Test Data: BusinessPlanTrigger
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Arpit Vashishtha 12/04/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
********************************************************************************/
@isTest
private class TestBusinessPlanTrigger {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        
        
         Account a = new Account();
        Business_Plan__c bpObj = new Business_Plan__c();
        
        a.Name = 'Test';
        a.BillingState = 'Test State';
        a.BillingCity = 'Test City';
        insert a;
        
        
        bpObj.Account__c = a.Id;
        bpObj.Budget_VAP_of_Boards__c = 10;
        bpObj.Actual_VAP_of_Boards__c = 10;
        bpObj.VAP_Actual_to_Budget__c = 10;
        bpObj.Planned_VAP__c = 100;
        bpObj.Planned_Tape__c = 100;
        bpObj.Planned_Finishing__c = 100;
        bpObj.Planned_All_Boards__c = 100;
        bpObj.Tape_Actual_to_Budget__c = 10;
        bpObj.Finishing_Actual_to_Budget__c = 10;
        bpObj.All_Board_Actual_to_Budget__c = 10;
        bpObj.Total_YTD_Finishing__c = 10;
        bpObj.Q4_Finishing__c = 10;
        bpObj.Q3_Finishing__c = 10;
        bpObj.Q2_Finishing__c = 10;
        bpObj.Q1_Finishing__c = 10;
        bpObj.Total_YTD_Tape__c = 10;
        bpObj.Q4_Tape__c = 10;
        bpObj.Q3_Tape__c = 10;
        bpObj.Q2_Tape__c = 10;
        bpObj.Q1_Tape__c = 10;
        bpObj.Total_YTD_VAP__c = 10;
        bpObj.Q4_VAP__c = 10;
        bpObj.Q3_VAP__c = 10;
        bpObj.Q2_VAP__c = 10;
        bpObj.Q1_VAP__c = 10;
        bpObj.Total_YTD_All_Board__c = 10;
        bpObj.Q4_All_Boards__c = 10;
        bpObj.Q3_All_Boards__c = 10;
        bpObj.Q2_All_Boards__c = 10;
        bpObj.Q1_All_Boards__c = 10;
        
        insert bpObj;
    }
}