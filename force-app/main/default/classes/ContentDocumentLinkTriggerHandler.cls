public  class ContentDocumentLinkTriggerHandler {
    public static void preventRebateFileCreation(List<ContentDocumentLink> contentDocLinks) {
        Set<Id> rebateClaimIds = new Set<Id>();        
        Schema.DescribeSObjectResult describResult = Rebate_Claim__c.sObjectType.getDescribe();
        String idPrefix = describResult.getKeyPrefix();
        for(ContentDocumentLink cdl: contentDocLinks){
            //isolate ones which are Rebate Claims
            if(String.valueof(cdl.LinkedEntityId).startsWith(idPrefix)){
                rebateClaimIds.add(cdl.LinkedEntityId);
            }
        }
        if(!rebateClaimIds.isEmpty()){
            Id distributorRebateRecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CCB_DISTRIBUTOR_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId();
            List<String> statusVlauesThatPreventFileChange = new List<String>{RebateUtility.REBATE_CLAIM_HEADER_STSTUS_DRAFT, RebateUtility.REBATE_CLAIM_HEADER_STATUS_INCOMPLETE};
            Map<Id,Rebate_Claim__c> rebateClaimsThatDoNotAllowFileChanage = new Map<Id,Rebate_Claim__c>([Select Id from Rebate_Claim__c 
                                                                                                         where Id in: rebateClaimIds and Status__c not in: statusVlauesThatPreventFileChange 
                                                                                                         and RecordTypeId !=: distributorRebateRecordTypeId]);
            //prevent Document from creation if Rebate is not in Draft or Incomplete Status
            for(ContentDocumentLink cdl: contentDocLinks){               
                if(rebateClaimsThatDoNotAllowFileChanage.containsKey(cdl.LinkedEntityId)){
                    cdl.addError(Label.Error_Modifying_Files_on_Submitted_Rebate);
                }
            }
        }
    }
    
    public static void setFileVisibilityForRebateClaim (List<ContentDocumentLink> contentDocLinks){
        for (ContentDocumentLink cdl : contentDocLinks) {
            if (cdl.LinkedEntityId.getSObjectType().getDescribe().getName() == 'Rebate_Claim__c') {
                cdl.visibility = 'AllUsers';
            }
        }  
    }
}