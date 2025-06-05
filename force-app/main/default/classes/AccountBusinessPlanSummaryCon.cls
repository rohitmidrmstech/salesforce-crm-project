/**************************************************************************************************
* Controller Class: AccountBusinessPlanSummaryCon
* Created by Arpit Vashishtha(Navivo), DateCreated: 10/27/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - The page is used to show the Business Plan Summary on the Business Plan Detail page.
  - This page shows all the four Business plan information regarding that Business Plan. 
---------------------------------------------------------------------------------------------------
* Unit Test: TestAccountBusinessPlanSummaryCon
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME        			DATE            DETAIL FEATURES
    1.0      Arpit Vashishtha (Navivo)      10/27/2014      INITIAL DEVELOPMENT
**************************************************************************************************/
public with sharing class AccountBusinessPlanSummaryCon {
	public Business_Plan__c bp{get;set;}
	public Business_Plan__c bpTemp{get;set;}
	public Business_Plan_Others__c bpo{get;set;} 
	public Integer bpYear {get;set;}
	public Account acc {get;set;}
	public List<CTG_Strategy__c> CTList {get;set;}
	public List<Customer_Strategy__c> CustomerList {get;set;}
	
	//private String accId{get;set;}
	
	public AccountBusinessPlanSummaryCon(ApexPages.StandardController sc){
		
		//run a query on CTG and Customer Strategies.
		//----------------------------------------------------------- Edited by Abhishek on Nov 28,2014 -----------------------------------------------------------------------------------------------------------------------------------------
		System.debug(sc.getId());
		Id accId;
		bpTemp = [Select b.Id, b.Account__c From Business_Plan__c b where b.Id = :sc.getId()];
		if(bpTemp!=null) accId = bpTemp.Account__c;
		System.debug(accId);
		acc = new Account();
		acc = [Select a.Name, a.Id From Account a where a.Id = :accId];
		CTList = new List<CTG_Strategy__c>();
		System.debug('accId------'+accId);
		CTList = [Select c.Name, c.LastModifiedDate, c.Item__c, c.Id, c.Due_Date__c, c.CreatedBy.Name, c.Action_Item__c, c.Account__c From CTG_Strategy__c c where c.Account__c = :accId order by Item__c];
		
		CustomerList = new List<Customer_Strategy__c>();	
		
		CustomerList = [Select c.Name, c.LastModifiedDate, c.Item__c, c.Id, c.Due_Date__c, c.CreatedBy.Name, c.Action_Item__c, c.Account__c From Customer_Strategy__c c where c.Account__c = :accId order by Item__c];
		//---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		
		//run a query on Businessplan 
		for(Business_Plan__c obj: [Select b.All_Board_Actual_to_Budget__c, b.VAP_Actual_to_Budget__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.Total_YTD_VAP__c, b.Total_YTD_Tape__c, b.Total_YTD_Finishing__c, b.Total_YTD_All_Board__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Planned_All_Boards__c, b.Id,b.Year__c From Business_Plan__c b  where b.Id =: sc.getId()]){
			bp = obj;
		}
		//run a query on BusinessplanOthers
		List<Business_Plan_Others__c> bpoList = [Select bo.Budget_All_Boards__c,bo.Budget_Finishing__c, bo.Budget_Tape__c, bo.Budget_VAP__c from Business_Plan_Others__c bo where bo.CreatedById =: UserInfo.getUserId()];
		for(Business_Plan_Others__c objBPO: bpoList){
			bpo = objBPO;
		}
	}
}