public class UserTriggerHandler {
    public static void createExperianceUserShares(List<User> users, Map<Id,User> OldUserMap){
        Set<Id> contactIds = new Set<Id>();
        for(User u: users){
            //updates
            if(OldUserMap != null){
                if(u.ContactId!= null && u.IsActive && u.IsActive != OldUserMap.get(u.Id).IsActive){
                    contactIds.add(u.ContactId);
                }
            }
            else if(u.ContactId != null && u.IsActive){
                contactIds.add(u.ContactId);
            }
        }
        if(!contactIds.isEmpty()){
            //programs that need Member shares
            List<String> programsList = new List<String>{CCBClaimFormController.CCB_PROGRAM_IDENTIFIER , CCBClaimFormController.CP_PROGRAM_IDENTIFIER};
            Map<Id,Id> rebateProgramMemberToContactMap = new Map<Id,Id>();
            for(RebateProgramMember programMember: [Select Id, Contact__c from RebateProgramMember 
                                                    where Contact__c in: contactIds and MemberStatus =: RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE
                                                    and Program_Type__c in: programsList]){
                rebateProgramMemberToContactMap.put(programMember.Id, programMember.Contact__c);
            }
            if(!rebateProgramMemberToContactMap.isEmpty()){
                RebateProgramMemberTriggerHandler.createExperienceUserShares(rebateProgramMemberToContactMap);
            }
        }
    }
}