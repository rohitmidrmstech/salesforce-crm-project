/**************************************************************************************************
* Controller Class: ProductSummaryCon
* Created by Sudhandshu Dwivedi(Navivo), DateCreated: 10/21/2014
---------------------------------------------------------------------------------------------------
* Purpose:
* - This controller is used to show the data on Product Summary table on the Yearly basis of all four 
    Business Plans.
  - This table will be showed to page by the batch class. 
---------------------------------------------------------------------------------------------------
* Unit Test: TestProductSummaryCon
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME        		      DATE            DETAIL FEATURES
    1.0      Sudhandshu Dwivedi (Navivo)      10/21/2014      INITIAL DEVELOPMENT
**************************************************************************************************/
public with sharing class ProductSummaryCon {
	public String curYear {get;set;}
	public Integer year{get;set;}
	public String ytdActualPercentToBudget{get;set;}
	public ProductSummary__c pSummary{get;set;}
	public Decimal percentPlanAllBoards {get;set;}
	public Decimal percentPlanVAP {get;set;}
	public Decimal percentPlanTape {get;set;}	
	public Decimal percentPlanFinishing {get;set;}
	
	public ProductSummaryCon(ApexPages.StandardSetController sc){
		if(System.today().month()<11){
			year = System.today().year();
		}else if(System.today().month()>= 11){
			year = System.today().year() + 1;
		}
		curYear = String.valueOf(year);
		pSummary = new ProductSummary__c();
    	List<ProductSummary__c> summaryObj = [Select p.Year__c, p.Actual_VAP__c, p.Actual_Tape__c, p.Actual_Finishing__c, p.Actual_All_Board__c, p.Planned_VAP__c, p.Planned_Tape__c, p.Planned_Finishing__c, p.Planned_All_Boards__c, p.Name, p.Id, p.Budget_VAP__c, p.Budget_Tape__c, p.Budget_Finishing__c, p.Budget_All_Boards__c From ProductSummary__c p Where Year__c =:curYear];
    	if(summaryObj.size() > 0)pSummary = summaryObj[0];
    	System.debug('test'+pSummary.Actual_All_Board__c);
    	System.debug('test'+pSummary.Budget_All_Boards__c);
    	if(pSummary.Budget_All_Boards__c != null && pSummary.Budget_All_Boards__c > 0 ) percentPlanAllBoards = Math.floor(((pSummary.Actual_All_Board__c * 100) / pSummary.Budget_All_Boards__c));
	    if(pSummary.Budget_VAP__c != null && pSummary.Budget_All_Boards__c > 0 )percentPlanVAP = Math.floor(((pSummary.Actual_VAP__c * 100) / pSummary.Budget_VAP__c));
	    if(pSummary.Budget_Tape__c != null && pSummary.Budget_All_Boards__c > 0 )percentPlanTape = Math.floor(((pSummary.Actual_Tape__c * 100) / pSummary.Budget_Tape__c));
	   	if(pSummary.Budget_Finishing__c != null && pSummary.Budget_Finishing__c > 0 )percentPlanFinishing = Math.floor(((pSummary.Actual_Finishing__c * 100) / pSummary.Budget_Finishing__c));
    	
	}
}