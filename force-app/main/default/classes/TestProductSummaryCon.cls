/*********************************************************************************
* Test Class: {TestProductSummaryCon}
* Created by {Sudhanshu Dwivedi}, Navivo, {DateCreated 11/05/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Unit test for class ProductSummaryCon}
----------------------------------------------------------------------------------
* Utility Test Data: 
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Sudhanshu Dwivedi 11/05/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
********************************************************************************/
@isTest
private class TestProductSummaryCon {

    static testMethod void myUnitTest() {
    	 
        // TO DO: implement unit test
        
        
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
        ps.Year__c = '2014';
        ps.Name = 'Test';
        if(System.today().month()<11){
            ps.Year__c = String.valueOf(System.today().year());
        }else if(System.today().month()>= 11){
            ps.Year__c = String.valueOf(System.today().year() + 1);
         }
        insert ps;
        List<Account> accList = new List<Account>();
        ApexPages.StandardSetController stdController = new ApexPages.StandardSetController(accList);
        ProductSummaryCon psc = new ProductSummaryCon(stdController);
        //stdController.setSelected(accList);
        
        //BusinessPlan bp = new BusinessPlan(stdController);
    }
}