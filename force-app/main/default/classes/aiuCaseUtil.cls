// ==================================================================================
//   Object: aiuCaseUtil
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Future method to create a CaseShare record for the Account owner.
// ==================================================================================
//  Changes: 2013-04-26 Initial version.
//			 2013-08-02 Mohan Kumar
//						Added a new static variable to support the Case trigger.
// ==================================================================================

public with sharing class aiuCaseUtil {
	
	public static boolean hasInsertProcessed = false;
	
	//@future
	public static void caseSharing(Set<String> shareList) {
		System.debug('shareList: '+shareList);
		Set<String> cIds = new Set<String>();
		Set<String> uIds = new Set<String>();
		//extract the Case Id and User Id from the parameter
		for(String s : shareList) {
			List<String> sList = s.split('::::');
			cIds.add(sList[0]);
			uIds.add(sList[1]);
		}
		//checking if the Case is already shared with the specific user and prepare a map out of the result
		List<CaseShare> caseShareList = [Select Id, CaseId, UserOrGroupId From CaseShare Where CaseId IN :cIds AND UserOrGroupId IN :uIds];
		Map<String, CaseShare> caseShareMap = new Map<String, CaseShare>();
		for(CaseShare cs : caseShareList) {
			caseShareMap.put(cs.CaseId + '::::' + cs.UserOrGroupId, cs);
		}
		
		//create new CaseShare records
		List<CaseShare> insertCaseShare = new List<CaseShare>();
		for(String s : shareList) {
			//create a CaseShare record only if the caseShareMap doesn't contain the key value.
			if(!caseShareMap.containsKey(s)) {
				List<String> sList = s.split('::::');
				CaseShare cShare = new CaseShare();
				cShare.CaseId = sList[0];
				cShare.UserOrGroupId = sList[1];
				cShare.CaseAccessLevel = 'Read';
				//cShare.RowCause = 'Manual';
				insertCaseShare.add(cShare);
			}
		}
		insert insertCaseShare;
	}
    
    public static void portalCaseAssignment(List<Case> cases){
        if(cases.size() > 0){
            system.debug('cases-->' + cases);
			Database.DMLOptions dmo = new Database.DMLOptions();
            dmo.assignmentRuleHeader.useDefaultRule = true;
            Database.update(cases, dmo); 
		}        
    }
}