/**************************************************************************************************
* Controller Class: ProductSummaryBatch
* Created by Sudhandshu Dwivedi(Navivo), DateCreated: 10/21/2014
---------------------------------------------------------------------------------------------------
* Purpose:
* - This controller is used to show the Product Summary on the Yearly basis of all four 
    Business Plans.
  - This controller shows the information from the Business Plan object. 
---------------------------------------------------------------------------------------------------
* Unit Test: TestProductSummaryBatch
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME        		      DATE            DETAIL FEATURES
    1.0      Sudhandshu Dwivedi (Navivo)      10/21/2014      INITIAL DEVELOPMENT
**************************************************************************************************/
global class ProductSummaryBatch implements Database.Batchable<Sobject> {
	public String curYear {get;set;}
	
	//constructor
	public ProductSummaryBatch(){
		Integer year;
		if(System.today().month()<11){
			year = System.today().year();
		}else if(System.today().month()>= 11){
			year = System.today().year() + 1;
		}
		this.curYear = year.format();
	}
	
	// The start method is called at the beginning of a sharing calculation.
    global  Database.QueryLocator start(Database.BatchableContext BC){
    	
    	return Database.getQueryLocator([select Budget_All_Boards__c, Budget_Finishing__c, Budget_Tape__c, Budget_VAP__c, Planned_All_Boards__c, Planned_Finishing__c, Planned_Tape__c, Planned_VAP__c, Total_YTD_All_Board__c, Total_YTD_Finishing__c, Total_YTD_Tape__c, Total_YTD_VAP__c from Business_Plan__c Where Year__c =: curYear]);
     }
    
     // The executeBatch method is called for each chunk of records returned from start.  
    global void execute(Database.BatchableContext BC, List<sObject> scope){
    	
    	List<ProductSummary__c> summaryObj = [Select p.Year__c, p.Actual_VAP__c, p.Actual_Tape__c, p.Actual_Finishing__c, p.Actual_All_Board__c, p.Planned_VAP__c, p.Planned_Tape__c, p.Planned_Finishing__c, p.Planned_All_Boards__c, p.Name, p.Id, p.Budget_VAP__c, p.Budget_Tape__c, p.Budget_Finishing__c, p.Budget_All_Boards__c From ProductSummary__c p Where Year__c =: curYear];
    	for(sObject obj : scope){
    		Business_Plan__c bPlan = (Business_Plan__c) obj;
    		if(bPlan.Budget_All_Boards__c != null) summaryObj[0].Budget_All_Boards__c += bPlan.Budget_All_Boards__c;
    		if(bPlan.Budget_Finishing__c != null) summaryObj[0].Budget_Finishing__c += bPlan.Budget_Finishing__c;
    		if(bPlan.Budget_Tape__c != null) summaryObj[0].Budget_Tape__c += bPlan.Budget_Tape__c;
    		if(bPlan.Budget_VAP__c != null) summaryObj[0].Budget_VAP__c += bPlan.Budget_VAP__c;
    		if(bPlan.Planned_All_Boards__c != null) summaryObj[0].Planned_All_Boards__c += bPlan.Planned_All_Boards__c;
    		if(bPlan.Planned_Finishing__c != null) summaryObj[0].Planned_Finishing__c += bPlan.Planned_Finishing__c;
    		if(bPlan.Planned_Tape__c != null) summaryObj[0].Planned_Tape__c += bPlan.Planned_Tape__c;
    		if(bPlan.Planned_VAP__c != null) summaryObj[0].Planned_VAP__c += bPlan.Planned_VAP__c;
    		if(bPlan.Total_YTD_All_Board__c != null) summaryObj[0].Actual_All_Board__c += bPlan.Total_YTD_All_Board__c;
    		if(bPlan.Total_YTD_Finishing__c != null) summaryObj[0].Actual_Finishing__c += bPlan.Total_YTD_Finishing__c;
    		if(bPlan.Total_YTD_Tape__c != null) summaryObj[0].Actual_Tape__c += bPlan.Total_YTD_Tape__c;
    		if(bPlan.Total_YTD_VAP__c != null) summaryObj[0].Actual_VAP__c += bPlan.Total_YTD_VAP__c;
    	}
    	update summaryObj;
    }
    // The finish method is called at the end of a sharing calculation.
    global void finish(Database.BatchableContext BC){  
        
    }
}