public class RebateClaimTriggerHandler {
    public static void createExperienceUserShares(Map<Id,Id> rebateClaimToContactMap){
        Map<Id,Id> contactToUserIdMap = new Map<Id,Id>();
        List<Rebate_claim__Share> sharesToCreate = new List<Rebate_claim__Share>();

        for(User u: [Select Id,ContactId from User where ContactId in: rebateClaimToContactMap.values()]){
            contactToUserIdMap.put(u.ContactId, u.Id);
        }

        for(Id rebateClaimId: rebateClaimToContactMap.keySet()){
            if(contactToUserIdMap.containsKey(rebateClaimToContactMap.get(rebateClaimId)) ){
                Rebate_claim__Share share = new Rebate_claim__Share();
                share.ParentId = rebateClaimId;
                share.UserOrGroupId = contactToUserIdMap.get(rebateClaimToContactMap.get(rebateClaimId));
                share.AccessLevel = RebateUtility.SHARING_ACCESS_LEVEL_EDIT;
                share.RowCause = Schema.Rebate_claim__Share.rowCause.Experience_User_Sharing__c;
                sharesToCreate.add(share);
            }
        }

        if(!sharesToCreate.isEmpty()){
            Database.insert(sharesToCreate, false);
        }
    }

    public static void deleteExperienceUserShares(Map<Id,Id> rebateClaimToContactMap){
        Map<Id,Id> contactToUserIdMap = new Map<Id,Id>();
        List<Rebate_claim__Share> sharesToDelete = new List<Rebate_claim__Share>();

        for(User u: [Select Id,ContactId from User where ContactId in: rebateClaimToContactMap.values()]){
            contactToUserIdMap.put(u.ContactId, u.Id);
        }

        for(Rebate_claim__Share share: [Select Id,ParentId, UserOrGroupId 
                                       from Rebate_claim__Share 
                                       where RowCause =:  Schema.Rebate_claim__Share.rowCause.Experience_User_Sharing__c
                                       AND  ParentId in: rebateClaimToContactMap.keySet()
                                       AND UserOrGroupId in: contactToUserIdMap.values()]){
            if(share.UserOrGroupId == contactToUserIdMap.get(rebateClaimToContactMap.get(share.ParentId))){
                sharesToDelete.add(share);
            }
        }

        if(!sharesToDelete.isEmpty()){
            delete sharesToDelete;
        }
    }

    public static void createExperienceUserSharesForClaimItems(Map<Id,Id> rebateClaimToContactMap){
        Map<RebateClaim,Id> rebateClaimItemToContactMap = new  Map<RebateClaim,Id>();
        for(RebateClaim claimItem : [Select Id, Rebate_Claim__c,OwnerId from RebateClaim where Rebate_Claim__c in: rebateClaimToContactMap.keySet()]){
            rebateClaimItemToContactMap.put(claimItem, rebateClaimToContactMap.get(claimItem.Rebate_Claim__c));
        }
        if(!rebateClaimItemToContactMap.isEmpty()){
            RebateClaimItemTriggerHandler.createExperienceUserShares(rebateClaimItemToContactMap);
        }
    }

    public static void deleteExperienceUserSharesForClaimItems(Map<Id,Id> rebateClaimToContactMap){
        Map<Id,Id> rebateClaimItemToContactMap = new  Map<Id,Id>();
        for(RebateClaim claimItem : [Select Id, Rebate_Claim__c from RebateClaim where Rebate_Claim__c in: rebateClaimToContactMap.keySet()]){
            rebateClaimItemToContactMap.put(claimItem.Id, rebateClaimToContactMap.get(claimItem.Rebate_Claim__c));
        }
        if(!rebateClaimItemToContactMap.isEmpty()){
            RebateClaimItemTriggerHandler.deleteExperienceUserShares(rebateClaimItemToContactMap);
        }
    }
}