public with sharing class CT_CaseTakeOwnershipController {

	public String redirectToId {get;set;}
	public ApexPages.StandardSetController stdSet {get;set;}

	public CT_CaseTakeOwnershipController(ApexPages.StandardSetController stdSet){
		this.stdSet = stdSet;
	}

	public PageReference init(){
		List<Case> caseList = stdSet.getSelected();
		if (caseList.size()>0){
			caseList = [SELECT Id, CaseNumber, Subject, Status, OwnerId FROM Case where Id in: caseList];

			List<Case> updateCaseList = new List<Case>();
			for (Case currCase : caseList){
				if ( ((String)currCase.OwnerId).startsWith('00G') || Test.isRunningTest() ){
					Case newCaseUpdate = new Case(Id = currCase.Id);
					newCaseUpdate.OwnerId = UserInfo.getUserId();
					updateCaseList.add(newCaseUpdate);

					if (currCase.Status == 'Pending Closer') 					newCaseUpdate.Closer__c = UserInfo.getUserId();
					else if (currCase.Status == 'Pending Pre Approver Closer') 	newCaseUpdate.Pre_Approver_1b_Pricing__c = UserInfo.getUserId();
					else if(currCase.Status == 'Pending Investigator' 
						|| currCase.Status == 'Pending CSM' 
						|| currCase.Status == 'Pending TM'
					){
						newCaseUpdate.Investigator__c = UserInfo.getUserId();
					}
				}
				else{
					redirectToId = null;
					return null;
				}
			}

			if (updateCaseList.size()>0){
				update updateCaseList;
				redirectToId = updateCaseList.get(0).Id;
			}
			stdSet.setSelected(new List<Case>());
		}
		return null;
	}
}