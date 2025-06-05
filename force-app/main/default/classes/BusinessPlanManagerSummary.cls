/**************************************************************************************************
* Controller Class: BusinessPlanManagerSummary
* Created by Arpit Vashishtha(Navivo), DateCreated: 12/01/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - The page is used to create Business Plan Summary for Manager.
---------------------------------------------------------------------------------------------------
* Unit Test: 
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME        			DATE            DETAIL FEATURES
    1.0      Arpit Vashishtha(Navivo)      12/01/2014      INITIAL DEVELOPMENT
    2.0 	 Arpit Vashishtha(Navivo)	   09/02/2014	   Add a logic in the Accounts Table to include columns next to the
    													   individual accounts to show totals for budge, planned, ytd actual,
    													   ytd % to plan so next to account name we add the 4 columns that will show account totals
    3.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
**************************************************************************************************/

public with sharing class BusinessPlanManagerSummary {
/*
	public String userId{get;set;}
	public Integer year{get;set;}
	public Set<Id> userIdSet{get;set;}
	public Business_Plan_Others__c bpo{get;set;}
	public Business_Plan__c bp{get;set;}
	public List<Business_Plan__c> bpList{get;set;}
	public List<Business_Plan_Others__c> bpoList{get;set;}
	public Set<Id> accountIds {get;set;}
	public List<Account> accList {get;set;}
	public Boolean isManager {get;set;}
	public List<BusinessPlanManagerSummaryWrapper> wrapper{get;set;}
	private Map<String, Business_Plan__c> tempWrapperMap = new Map<String, Business_Plan__c>();
	
	
	
	public BusinessPlanManagerSummary(){
		bpList = new List<Business_Plan__c>();
		bpoList = new List<Business_Plan_Others__c>();
		isManager = false;
		wrapper = new List<BusinessPlanManagerSummaryWrapper>();
		
		if(System.today().month()<11){
			year = System.today().year();
		}else if(System.today().month()>= 11){
			year = System.today().year() + 1;
		}
		userIdSet = new Set<Id>();
		try{
				userId = UserInfo.getUserId();
				User u = [select id, Name, ManagerId, User_Territory_Code__c from user where id = :userId];
				system.debug('UserDetailIs'+u);
				List<User> managerUsers = [Select id, Name, ManagerId, User_Territory_Code__c from user where ManagerId =: userId];
				if(managerUsers.size() > 0) {
					isManager =  true;
					system.debug('UserDetailIs-----'+managerUsers.size());
					for(User uIds : managerUsers){
						userIdSet.add(u.Id); 
						userIdSet.add(uIds.Id);
					}
					system.debug('userIdSet:::::'+userIdSet+'-----'+year);
					
					
					bpoList = [Select bo.CreatedBy.Name,bo.Name,bo.Account_Id__c,bo.Budget_All_Boards__c,bo.Budget_Finishing__c, bo.Budget_Tape__c, bo.Budget_VAP__c,bo.Budget_VAP_of_Boards__c from Business_Plan_Others__c bo where bo.Name IN: userIdSet and bo.Year__c =: String.valueOf(year)];
					System.debug('bpoList::::'+bpoList);
					accountIds = new Set<Id>();
					if(bpoList.size() > 0){
						for(Business_Plan_Others__c bpoId : bpoList){
							if(bpoId.Account_Id__c != null){
								//condition for check that Account__Id__c contains comma or not
								if(String.valueOf(bpoId.Account_Id__c).contains(',')){
									System.debug('bpoId.Account_Id__c::::'+bpoId.Account_Id__c);
									List<String> accIdsLst = bpoId.Account_Id__c.split(',');
									System.debug('AccIdsLst::::'+accIdsLst);
									for(String s : accIdsLst){
										accountIds.add(s);
									}
								} else {
										accountIds.add(String.valueOf(bpoId.Account_Id__c));
								}
							}
						}
					}
					
					bpo = new Business_Plan_Others__c();
					bpo.Budget_All_Boards__c = 0;
					bpo.Budget_Finishing__c = 0;
					bpo.Budget_Tape__c = 0;
					bpo.Budget_VAP__c = 0;
					bpo.Budget_VAP_of_Boards__c = 0;
					
					for(Business_Plan_Others__c bpoId : bpoList){
						//bpList.add(bpoId);
						System.debug('rrrr---::::'+bpoId+'------'+year);
						System.debug('bpo---::::'+bpoList+'------'+bpoId.Budget_All_Boards__c+'------'+bpoId.Budget_VAP__c+'------'+bpoId.Budget_Finishing__c+'------'+bpoId.Budget_Tape__c+'------'+bpoId.Budget_VAP_of_Boards__c);
						if(bpoId.Budget_All_Boards__c != null) bpo.Budget_All_Boards__c += bpoId.Budget_All_Boards__c;
						if(bpoId.Budget_VAP__c != null) bpo.Budget_VAP__c += bpoId.Budget_VAP__c;
						if(bpoId.Budget_Finishing__c != null) bpo.Budget_Finishing__c += bpoId.Budget_Finishing__c;
						if(bpoId.Budget_Tape__c != null) bpo.Budget_Tape__c += bpoId.Budget_Tape__c;
						if(bpoId.Budget_VAP_of_Boards__c != null) bpo.Budget_VAP_of_Boards__c += bpoId.Budget_VAP_of_Boards__c;
						System.debug('bpo---::::'+bpoList+'------'+bpoId.Budget_All_Boards__c+'------'+bpoId.Budget_VAP__c+'------'+bpoId.Budget_Finishing__c+'------'+bpoId.Budget_Tape__c+'------'+bpoId.Budget_VAP_of_Boards__c);
					}System.debug('bpoList---::::'+bpo+'------'+year);
					
					//run a query on Account Obj
					
					accList = [Select a.Name From Account a where a.id IN :accountIds order By a.Name ASC];
					System.debug('Account Detail::'+accList);
					//Arpit 07/02/2015 : fetching records from BP to show on page with respect to Account table
					List<Business_Plan__c> wrBpList = [Select b.VAP_Actual_to_Budget__c, 
															  b.Total_YTD_VAP__c,
															  b.Total_YTD_Tape__c,
															  b.Total_YTD_Finishing__c,
															  b.Total_YTD_All_Board__c,
															  b.Tape_Actual_to_Budget__c,
															  b.Planned_VAP__c,
															  b.Planned_Tape__c,
															  b.Planned_Finishing__c,
															  b.Planned_All_Boards__c,
															  b.Finishing_Actual_to_Budget__c,
															  b.Budget_VAP__c,
															  b.Budget_Tape__c,
															  b.Budget_Finishing__c,
															  b.Budget_All_Boards__c,
															  b.All_Board_Actual_to_Budget__c,
															  b.Account__c,
															  b.Account__r.Name,
															  b.CreatedBy.Name
															  From Business_Plan__c b where b.Account__c IN :accountIds order By b.Name ASC];
					
					
					//run a query on Bp 
					bpList = [Select b.Account__c, b.All_Board_Actual_to_Budget__c, b.VAP_Actual_to_Budget__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.Total_YTD_VAP__c, b.Total_YTD_Tape__c, b.Total_YTD_Finishing__c, b.Total_YTD_All_Board__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Planned_All_Boards__c, b.Id,b.Year__c From Business_Plan__c b  where b.User_Id__c IN: userIdSet and b.Year__c =: String.valueOf(year) and Account__c IN: accountIds];
					System.debug('bpList::::'+bpList);
					
					bp = new Business_Plan__c();
					bp.All_Board_Actual_to_Budget__c = 0;
					bp.VAP_Actual_to_Budget__c = 0;
					bp.Tape_Actual_to_Budget__c =0;
					bp.Finishing_Actual_to_Budget__c = 0;
					bp.Total_YTD_VAP__c = 0;
					bp.Total_YTD_Tape__c = 0;
					bp.Total_YTD_Finishing__c = 0;
					bp.Total_YTD_All_Board__c = 0;
					bp.Planned_VAP__c = 0;
					bp.Planned_Tape__c = 0;
					bp.Planned_Finishing__c = 0;
					bp.Planned_All_Boards__c = 0;
					
					for(Business_Plan__c bpId : bpList){
						System.debug('bpId.Id::::'+bpId.Planned_All_Boards__c);
						//Arpit 07/02/2015 : Adding code to store value in a temp variable so as to keep track in the calculations for showing total values in account table on page.
						Business_Plan__c tempBP = tempWrapperMap.get(bpId.Account__c);
						if(tempBP == null) {
							tempBP = new Business_Plan__c();
							tempBP.All_Board_Actual_to_Budget__c = 0;
							tempBP.VAP_Actual_to_Budget__c = 0;
							tempBP.Tape_Actual_to_Budget__c =0;
							tempBP.Finishing_Actual_to_Budget__c = 0;
							tempBP.Total_YTD_VAP__c = 0;
							tempBP.Total_YTD_Tape__c = 0;
							tempBP.Total_YTD_Finishing__c = 0;
							tempBP.Total_YTD_All_Board__c = 0;
							tempBP.Planned_VAP__c = 0;
							tempBP.Planned_Tape__c = 0;
							tempBP.Planned_Finishing__c = 0;
							tempBP.Planned_All_Boards__c = 0;
						}
						
						if(bpId.Total_YTD_VAP__c != null) { 
							bp.Total_YTD_VAP__c += bpId.Total_YTD_VAP__c; 
							tempBP.Total_YTD_VAP__c += bpId.Total_YTD_VAP__c;
							System.debug('tempBP.Total_YTD_VAP__c::::'+tempBP.Total_YTD_VAP__c); 
						}
						if(bpId.Total_YTD_Tape__c != null) { 
							bp.Total_YTD_Tape__c += bpId.Total_YTD_Tape__c; 
							tempBP.Total_YTD_Tape__c += bpId.Total_YTD_Tape__c; 
						}
						if(bpId.Total_YTD_Finishing__c != null) { 
							bp.Total_YTD_Finishing__c += bpId.Total_YTD_Finishing__c; 
							tempBP.Total_YTD_Finishing__c += bpId.Total_YTD_Finishing__c; 
						}
						if(bpId.Total_YTD_All_Board__c != null) { 
							bp.Total_YTD_All_Board__c += bpId.Total_YTD_All_Board__c; 
							tempBP.Total_YTD_All_Board__c += bpId.Total_YTD_All_Board__c; 
						}
						if(bpId.Planned_VAP__c != null) { 
							bp.Planned_VAP__c += bpId.Planned_VAP__c; 
							tempBP.Planned_VAP__c += bpId.Planned_VAP__c; 
						}
						if(bpId.Planned_Tape__c != null) { 
							bp.Planned_Tape__c += bpId.Planned_Tape__c; 
							tempBP.Planned_Tape__c += bpId.Planned_Tape__c; 
						}
						if(bpId.Planned_Finishing__c != null) { 
							bp.Planned_Finishing__c += bpId.Planned_Finishing__c; 
							tempBP.Planned_Finishing__c += bpId.Planned_Finishing__c; 
						}
						if(bpId.Planned_All_Boards__c != null) { 
							bp.Planned_All_Boards__c += bpId.Planned_All_Boards__c; 
							tempBP.Planned_All_Boards__c += bpId.Planned_All_Boards__c; 
							System.debug('tempBP.Total_YTD_VAP__c::::'+tempBP.Total_YTD_VAP__c);
						}
						bp.Year__c = String.valueOf(year);
						tempWrapperMap.put(bpId.Account__c, tempBP);
						System.debug('bpoList1111::::'+bp);
					}
					System.debug('tempWrapperMap::::'+tempWrapperMap);
					for(Account a : accList){
						BusinessPlanManagerSummaryWrapper wr = new BusinessPlanManagerSummaryWrapper();
						wr.acc = a;
						wr.wBPlan = tempWrapperMap.get(a.Id);
						System.debug('In Wrapper Class'+wr.wBPlan);
						wrapper.add(wr);
					}
					
					for(BusinessPlanManagerSummaryWrapper w : wrapper){
						w = calculatePercentageWrap(w);
					}
					
					//bp.All_Board_Actual_to_Budget__c = ((bp.Total_YTD_All_Board__c/bp.Planned_All_Boards__c)*100);
					if(bp.All_Board_Actual_to_Budget__c != null && bp.Planned_All_Boards__c != 0 && bp.Planned_All_Boards__c != null){
						bp.All_Board_Actual_to_Budget__c += ((bp.Total_YTD_All_Board__c / bp.Planned_All_Boards__c)*100);
						System.debug('bp.Id:---:::'+bp.All_Board_Actual_to_Budget__c);
					}
					if(bp.VAP_Actual_to_Budget__c != null && bp.Planned_VAP__c != 0 && bp.Planned_VAP__c != null){
						 bp.VAP_Actual_to_Budget__c += ((bp.Total_YTD_VAP__c / bp.Planned_VAP__c)*100);
					}
					if(bp.Tape_Actual_to_Budget__c != null && bp.Planned_Tape__c != 0 && bp.Planned_Tape__c != null){
						 bp.Tape_Actual_to_Budget__c += ((bp.Total_YTD_Tape__c/bp.Planned_Tape__c)*100);
					}
					if(bp.Finishing_Actual_to_Budget__c != null && bp.Planned_Finishing__c != 0 && bp.Planned_Finishing__c != null) {
						bp.Finishing_Actual_to_Budget__c += ((bp.Total_YTD_Finishing__c/bp.Planned_Finishing__c)*100);
					}
			} // end of if(managerUsers.size() > 0)
		} catch(Exception e){
			ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage())); 
		}
	}
	
	
	// Arpit 07/02/2015 : method to calculate YTD % value on page in account table
	//Mohan 02/23/2015: adding w.wBPlan null condition
	private BusinessPlanManagerSummaryWrapper calculatePercentageWrap(BusinessPlanManagerSummaryWrapper w) {
		if(w.wBPlan != null) {
			w.wBPlan.All_Board_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(w.wBPlan.Total_YTD_All_Board__c, w.wBPlan.Planned_All_Boards__c);
			w.wBPlan.VAP_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(w.wBPlan.Total_YTD_VAP__c, w.wBPlan.Planned_VAP__c);
			w.wBPlan.Tape_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(w.wBPlan.Total_YTD_Tape__c, w.wBPlan.Planned_Tape__c);
			w.wBPlan.Finishing_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(w.wBPlan.Total_YTD_Finishing__c,w.wBPlan.Planned_Finishing__c);
		}
		return w;
	}
	
	
	//--------------------------------------------Wrapper class-----------------------------------
	public class BusinessPlanManagerSummaryWrapper {
		public Business_Plan_Others__c wBpo{get;set;} 
		public Business_Plan__c wBPlan{get;set;}
		public Account acc {get;set;}
		
		public BusinessPlanManagerSummaryWrapper(){
			acc = new Account();
		}
	} */
}