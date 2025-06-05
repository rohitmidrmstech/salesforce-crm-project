/*********************************************************************************
* Test Class: {TestAccountBusinessPlanSummaryCon}
* Created by {Arpit Vashishtha}, Navivo, {DateCreated 11/17/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Unit test for class AccountBusinessPlanSummaryCon}
----------------------------------------------------------------------------------
* Utility Test Data: 
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Arpit Vashishtha 11/17/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
********************************************************************************/

@isTest
private class TestAccountBusinessPlanSummaryCon {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingState = 'North York';
        a.BillingCity = 'ON';
        insert a;
        
        //------------------------------------------ Edited by Abhishek on Nov 28, 2014 ----------------------------------
        //Create Test Data for Business Plan
        Business_Plan__c bsp = new Business_Plan__c();
        bsp.Account__c = a.Id;
        bsp.All_Board_Actual_to_Budget__c = 100;
		bsp.VAP_Actual_to_Budget__c = 100;
		bsp.Tape_Actual_to_Budget__c = 100;
		bsp.Finishing_Actual_to_Budget__c = 100;
		bsp.Total_YTD_VAP__c = 100;
		bsp.Total_YTD_Tape__c = 100;
		bsp.Total_YTD_Finishing__c = 100;
		bsp.Total_YTD_All_Board__c = 100;
		bsp.Planned_VAP__c = 100;
		bsp.Planned_Tape__c = 100;
		bsp.Planned_Finishing__c = 100;
		bsp.Planned_All_Boards__c = 100;
		bsp.Year__c = '2015';
        insert bsp;
        
        List<Account> accList = new List<Account>();
        accList.add(a);
        ApexPages.currentPage().getParameters().put('id',bsp.id);
        ApexPages.StandardController stdController = new ApexPages.StandardController(bsp);
        AccountBusinessPlanSummaryCon ts = new AccountBusinessPlanSummaryCon(stdController);
        System.assertEquals(bsp.Year__c,'2015');
        //----------------------------------------------------------------------------------------------------------------
    }
}