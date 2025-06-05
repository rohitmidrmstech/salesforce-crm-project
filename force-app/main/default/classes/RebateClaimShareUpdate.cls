public class RebateClaimShareUpdate {
    
    public static void addClaimShare(Integer searchLimit){
        
        Id CCBRecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CCB_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId();
        Id CCBItemRecordTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CCB_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId();
        Id CPRecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CP_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
        Id CPItemRecordTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CP_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
        Id BSPRecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(salesAgreementProductsFormController.BSP_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
        Id CCBDistributorRecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CCB_DISTRIBUTOR_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
        Id BIRRecordTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByDeveloperName().get(salesAgreementProductsFormController.BIR_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
        Id BIRItemRecordTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByDeveloperName().get(salesAgreementProductsFormController.BIR_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId();
        
        List<Rebate_Claim__c> lstRebateClaims = [Select Id, Name, Submitted_By__c, Status__c, RecordTypeId, ShareFixed__c from Rebate_Claim__c where Submitted_By__c IN (Select contactid FROM User where IsActive = true AND contactId != null AND CreatedDate >= 2023-05-20T00:00:00.000+0000) AND ShareFixed__c = False LIMIT: searchLimit];
        system.debug('lstRebateClaims =>' + lstRebateClaims.size());
        
        if(BatchConvertCurrencyForRebates.currencyConversionInProgress == false){
            
            List<User> defaultClaimOwner = [select id from user where name =: RebateUtility.DEFAULT_CCB_CP_BSP_REBATE_CLAIM_OWNER_Name];
            
            //assign newly created BSP,CP and CCB claims to default owner
            
            if(!defaultClaimOwner.isEmpty()){
                for(Rebate_claim__c rebateClaim: lstRebateClaims){
                    if((rebateClaim.RecordTypeId == CCBRecordTypeId || rebateClaim.RecordTypeId == CPRecordTypeId || rebateClaim.RecordTypeId == BSPRecordTypeId || rebateClaim.RecordTypeId == CCBDistributorRecordTypeId) && 
                       (rebateClaim.Status__c == RebateUtility.REBATE_CLAIM_HEADER_STSTUS_EXCEPTION_SUBMITTED || rebateClaim.Status__c == RebateUtility.REBATE_CLAIM_HEADER_STSTUS_SUBMITTED)){
                           rebateClaim.OwnerId = defaultClaimOwner[0].Id;
                       }
                }
            }
            
            Map<Id,Id> rebateClaimToContactMap = new Map<Id,Id>();
            for(Rebate_claim__c rebateClaim: lstRebateClaims){
                if(rebateClaim.Submitted_By__c != null && (rebateClaim.RecordTypeId == CCBRecordTypeId || rebateClaim.RecordTypeId == CPRecordTypeId || rebateClaim.RecordTypeId == CCBDistributorRecordTypeId)){
                                                               rebateClaimToContactMap.put(rebateClaim.Id, rebateClaim.Submitted_By__c);
                                                               rebateClaim.ShareFixed__c = True;
                                                           }
            }
            //create shares if any
            if(!rebateClaimToContactMap.isEmpty()){
                RebateClaimTriggerHandler.createExperienceUserShares(rebateClaimToContactMap);
                Update lstRebateClaims;
            }
            
            
            //Update Rebate Claim Item Shares
            List<RebateClaim> lstRebateClaimItems = [Select Id, RecordTypeId, ShareFixed__c, Rebate_Claim__c from RebateClaim where Rebate_Claim__c IN :lstRebateClaims];
            //system.debug('lstRebateClaimItems =>' + lstRebateClaimItems.size());

            Set<Id> rebateClaimItemIds = new Set<Id>();
            Map<RebateClaim,Id> rebateClaimItemToContactMap = new Map<RebateClaim,Id>();
            for(RebateClaim rebateClaimItem: lstRebateClaimItems){
                //system.debug('(rebateClaimItem.RecordTypeId =>' + rebateClaimItem.RecordTypeId);
                if(rebateClaimItem.Rebate_Claim__c != null && (rebateClaimItem.RecordTypeId == CCBItemRecordTypeId || rebateClaimItem.RecordTypeId == CPItemRecordTypeId)){
                    rebateClaimItemIds.add(rebateClaimItem.Id);
                    rebateClaimItem.ShareFixed__c = True;
                }
            }
            
            //system.debug('rebateClaimItemIds =>' + rebateClaimItemIds.size());

            if(!rebateClaimItemIds.isEmpty()){
                for(RebateClaim claimWithHeader : [Select Id, Rebate_Claim__c, Rebate_Claim__r.Submitted_By__c,OwnerId from RebateClaim where Id in: rebateClaimItemIds and Rebate_Claim__r.Submitted_By__c != null]){
                    rebateClaimItemToContactMap.put(claimWithHeader, claimWithHeader.Rebate_Claim__r.Submitted_By__c);  
                    
                }
            }
             //system.debug('rebateClaimItemToContactMap =>' + rebateClaimItemToContactMap.size());
            //create shares if any
            if(!rebateClaimItemToContactMap.isEmpty()){
                RebateClaimItemTriggerHandler.createExperienceUserShares(rebateClaimItemToContactMap);
                Update lstRebateClaimItems;
            }
            
        }  
        
    }     

}