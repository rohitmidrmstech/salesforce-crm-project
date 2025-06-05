/*********************************************************************************
* Test Class: {TestProductSummaryBatch}
* Created by {Sudhanshu Dwivedi}, Navivo, {DateCreated 11/05/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Unit test for class ProductSummaryBatch}
----------------------------------------------------------------------------------
* Utility Test Data: 
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Sudhanshu Dwivedi 11/05/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
********************************************************************************/
@isTest
private class TestProductSummaryBatch {
    
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
    
    //ApexPages.currentPage().getParameters().put('curYear','2014');
    
        Account a = new Account();
        /*a.Name = 'Test Account';
        a.BillingState = 'North York';
        a.BillingCity = 'ON';
        */
        a.Name = 'Test';
        a.BillingState = 'Test State';
        a.BillingCity = 'Test City';
        insert a;
        ProductSummaryBatch psb = new ProductSummaryBatch();
        //System.debug(psb.curYear);
       // psb.curYear = '2015';
        psb.curYear = string.valueof(system.today().Year());
        Business_Plan__c bp = new Business_Plan__c();
        bp.Account__c = a.id;
        bp.Planned_All_Boards__c = 1000;
        bp.Planned_Finishing__c =  1000;
        bp.Planned_Tape__c = 1000;
        bp.Planned_VAP__c =  1000;
        bp.Budget_All_Boards__c =  1000;
        bp.Budget_Finishing__c = 1000;
        bp.Budget_Tape__c = 1000;
        bp.Budget_VAP__c = 1000;
        bp.Total_YTD_All_Board__c =  1000;
        bp.Total_YTD_Finishing__c =  1000;
        bp.Total_YTD_Tape__c =  1000;
        bp.Total_YTD_VAP__c =  1000;
        //bp.Year__c = '2016';
        bp.Year__c =string.valueof(system.today().Year());
        insert bp;
        System.debug(psb.curYear);
        ProductSummary__c ps = new ProductSummary__c();
        ps.Actual_All_Board__c = 1000; 
        ps.Actual_Finishing__c = 1000;
        ps.Actual_Tape__c = 1000;
        ps.Actual_VAP__c = 1000;
        ps.Budget_All_Boards__c = 1000;
        ps.Budget_Finishing__c = 1000;
        ps.Budget_Tape__c = 1000;
        ps.Budget_VAP__c = 1000;
        ps.Planned_All_Boards__c = 1000;
        ps.Planned_Finishing__c = 1000;
        ps.Planned_Tape__c = 1000;
        ps.Planned_VAP__c = 1000;
        ps.Year__c = '2015';
        ps.Name = 'Test';
        if(System.today().month()<11){
            ps.Year__c = String.valueOf(System.today().year());
        }else if(System.today().month()>= 11){
            ps.Year__c = String.valueOf(System.today().year() + 1);
         }
        insert ps;
        Database.executeBatch(psb,5);
    }
    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
    
    //ApexPages.currentPage().getParameters().put('curYear','2014');
    
        Account a = new Account();
        /*a.Name = 'Test Account';
        a.BillingState = 'North York';
        a.BillingCity = 'ON';
        */
        a.Name = 'Test';
        a.BillingState = 'Test State';
        a.BillingCity = 'Test City';
        insert a;
        ProductSummaryBatch psb = new ProductSummaryBatch();
        //System.debug(psb.curYear);
        //psb.curYear = '2016';
        psb.curYear = string.valueof(system.today().Year());
        Business_Plan__c bp = new Business_Plan__c();
        bp.Account__c = a.id;
        bp.Planned_All_Boards__c = 1000;
        bp.Planned_Finishing__c =  1000;
        bp.Planned_Tape__c = 1000;
        bp.Planned_VAP__c =  1000;
        bp.Budget_All_Boards__c =  1000;
        bp.Budget_Finishing__c = 1000;
        bp.Budget_Tape__c = 1000;
        bp.Budget_VAP__c = 1000;
        bp.Total_YTD_All_Board__c =  1000;
        bp.Total_YTD_Finishing__c =  1000;
        bp.Total_YTD_Tape__c =  1000;
        bp.Total_YTD_VAP__c =  1000;
       // bp.Year__c = '2015';
       bp.Year__c =string.valueof(system.today().Year());
        insert bp;
        System.debug(psb.curYear);
        ProductSummary__c ps = new ProductSummary__c();
        ps.Actual_All_Board__c = 1000; 
        ps.Actual_Finishing__c = 1000;
        ps.Actual_Tape__c = 1000;
        ps.Actual_VAP__c = 1000;
        ps.Budget_All_Boards__c = 1000;
        ps.Budget_Finishing__c = 1000;
        ps.Budget_Tape__c = 1000;
        ps.Budget_VAP__c = 1000;
        ps.Planned_All_Boards__c = 1000;
        ps.Planned_Finishing__c = 1000;
        ps.Planned_Tape__c = 1000;
        ps.Planned_VAP__c = 1000;
       // ps.Year__c = '2015';
       ps.Year__c = string.valueof(system.today().Year());
        ps.Name = 'Test';
        if(System.today().month()<11){
            ps.Year__c = String.valueOf(System.today().year());
        }else if(System.today().month()>= 11){
            ps.Year__c = String.valueOf(System.today().year() + 1);
         }
        insert ps;
        Test.StartTest();
        ProductSummarySchedule schedule = new ProductSummarySchedule();
        SchedulableContext context; 
        schedule.execute(context);
        Test.StopTest();
    }
}