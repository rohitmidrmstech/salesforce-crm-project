public class ContactTriggerHandler {
    public static void createProgramMemberSharesOnAccountChange(List<Contact> contacts, Map<Id,Contact> oldContactMap){
        Set<Id> contactIds = new Set<Id>();
        for(Contact c: contacts){
            //Account changed           
            if(c.AccountId != null && c.AccountId!= oldContactMap.get(c.Id).AccountId){
                contactIds.add(c.Id);
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