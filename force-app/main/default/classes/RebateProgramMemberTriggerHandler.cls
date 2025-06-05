public class RebateProgramMemberTriggerHandler {
    public static void createExperienceUserShares(Map<Id,Id> rebateProgramMemberToContactMap){
        Map<Id,Id> contactToUserIdMap = new Map<Id,Id>();
        List<RebateProgramMemberShare> sharesToCreate = new List<RebateProgramMemberShare>();

        for(User u: [Select Id,ContactId from User where ContactId in: rebateProgramMemberToContactMap.values() and IsActive = true]){
            contactToUserIdMap.put(u.ContactId, u.Id);
        }

        for(Id rebateProgramMemberId: rebateProgramMemberToContactMap.keySet()){
            if(contactToUserIdMap.containsKey(rebateProgramMemberToContactMap.get(rebateProgramMemberId)) ){
                RebateProgramMemberShare share = new RebateProgramMemberShare();
                share.ParentId = rebateProgramMemberId;
                share.UserOrGroupId = contactToUserIdMap.get(rebateProgramMemberToContactMap.get(rebateProgramMemberId));
                share.AccessLevel = RebateUtility.SHARING_ACCESS_LEVEL_READ;
                sharesToCreate.add(share);
            }
        }

        if(!sharesToCreate.isEmpty()){
            Database.insert(sharesToCreate, false);
        }
    }

    public static void deleteExperienceUserShares(Map<Id,Id> rebateProgramMemberToContactMap){
        Map<Id,Id> contactToUserIdMap = new Map<Id,Id>();
        List<RebateProgramMemberShare> sharesToDelete = new List<RebateProgramMemberShare>();

        for(User u: [Select Id,ContactId from User where ContactId in: rebateProgramMemberToContactMap.values()]){
            contactToUserIdMap.put(u.ContactId, u.Id);
        }

        for(RebateProgramMemberShare share: [Select Id,ParentId, UserOrGroupId 
                                       from RebateProgramMemberShare 
                                       where ParentId in: rebateProgramMemberToContactMap.keySet()
                                       AND UserOrGroupId in: contactToUserIdMap.values()
                                       AND RowCause = 'Manual']){
            if(share.UserOrGroupId == contactToUserIdMap.get(rebateProgramMemberToContactMap.get(share.ParentId))){
                sharesToDelete.add(share);
            }
        }

        if(!sharesToDelete.isEmpty()){
            delete sharesToDelete;
        }
    }
}