public class ContentDocumentTriggerHandler {
    public static void preventRebateFileUpdatesAndDeletions(List<ContentDocument>documents){
        //get Content Document links
        Set<Id> documentIds = new Set<Id>();
        for(ContentDocument document: documents){
            documentIds.add(document.Id);
        }
        Set<Id> rebateClaimIds = new Set<Id>();
        Map<Id, Set<Id>> documentIdToLinkedRecordsMap = new Map<Id, Set<Id>>();
        Schema.DescribeSObjectResult describResult = Rebate_Claim__c.sObjectType.getDescribe();
        String idPrefix = describResult.getKeyPrefix();
        for(ContentDocumentLink cdl: [Select Id,ContentDocumentId,LinkedEntityId from ContentDocumentLink where ContentDocumentId in: documentIds]){
            //isolate ones which are Rebate Claims
            if(String.valueof(cdl.LinkedEntityId).startsWith(idPrefix)){
                rebateClaimIds.add(cdl.LinkedEntityId);

                if(!documentIdToLinkedRecordsMap.containsKey(cdl.ContentDocumentId)){
                    documentIdToLinkedRecordsMap.put(cdl.ContentDocumentId, new Set<Id>());
                }
                documentIdToLinkedRecordsMap.get(cdl.ContentDocumentId).add(cdl.LinkedEntityId);
            }
        }
        if(!rebateClaimIds.isEmpty()){
            List<String> statusVlauesThatPreventFileChange = new List<String>{RebateUtility.REBATE_CLAIM_HEADER_STSTUS_DRAFT, RebateUtility.REBATE_CLAIM_HEADER_STATUS_INCOMPLETE};
            Id distributorRebateRecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CCB_DISTRIBUTOR_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId();
            Map<Id,Rebate_Claim__c> rebateClaimsThatDoNotAllowFileChanage = new Map<Id,Rebate_Claim__c>([Select Id from Rebate_Claim__c 
                                                                                                         where Id in: rebateClaimIds and Status__c not in: statusVlauesThatPreventFileChange 
                                                                                                         and RecordTypeId !=: distributorRebateRecordTypeId]);
            //prevent Document from Update/Deletion if Rebate is not in Draft or Incomplete Status
            for(ContentDocument document: documents){
                if(documentIdToLinkedRecordsMap.containsKey(document.Id)){
                    boolean hasRebateClaimId = false;
                    for(Id rebateClaimId: documentIdToLinkedRecordsMap.get(document.Id)){
                        if(rebateClaimsThatDoNotAllowFileChanage.containsKey(rebateClaimId)){
                            hasRebateClaimId = true;
                            break;
                        }
                    }
                    if(hasRebateClaimId){
                        document.addError(Label.Error_Modifying_Files_on_Submitted_Rebate);
                    }
                }
            }
        }
    }
}