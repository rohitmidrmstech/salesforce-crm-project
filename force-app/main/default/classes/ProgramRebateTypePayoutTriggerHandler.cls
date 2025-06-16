public class ProgramRebateTypePayoutTriggerHandler {
    public static void updatedRebateClaimsForProcessedMemberPayouts(List<ProgramRebateTypePayout> processedMemberTypePayouts){
        //get unique list of rebate claims
        Set<Id> rebateClaimIds = new Set<Id>();
        Map<Id,Id> rebateClaimIDToRebateClaimAggregateIdMap = new Map<Id,Id>();
        for(ProgramRebateTypePayout typePayout: processedMemberTypePayouts){
            rebateClaimIds.add(typePayout.Rebate_Claims__c);
            if(typePayout.Rebate_Claim_Aggregate__c != null){
                rebateClaimIDToRebateClaimAggregateIdMap.put(typePayout.Rebate_Claims__c, typePayout.Rebate_Claim_Aggregate__c);
            }
        }

        Map<Id,Decimal> rebateClaimTotalPaidMap = new Map<Id,Decimal>();
        Map<Id,Set<String>> rebateClaimCheckNumbersMap = new Map<Id,Set<String>>();

        //08_18_2023 Lou Bui - Update to select statement to correct issue with incorrect amount update to rebate claim header. Service Now =>INC1107134
        for(ProgramRebateTypePayout typePayout: [Select Id, Rebate_Claims__c, Transaction_Amount__c, Check_Number__c 
        //for(ProgramRebateTypePayout typePayout: [Select Id, Rebate_Claims__c, Total_Amount_Paid__c, Check_Number__c
                                                from ProgramRebateTypePayout 
                                                where Rebate_Claims__c in: rebateClaimIds and SAP_Processed__c = true]){
            //if(typePayout.Total_Amount_Paid__c != null){                                        
            if(typePayout.Transaction_Amount__c != null){
                if(!rebateClaimTotalPaidMap.containsKey(typePayout.Rebate_Claims__c)){
                    rebateClaimTotalPaidMap.put(typePayout.Rebate_Claims__c, 0);
                }
                //rebateClaimTotalPaidMap.put(typePayout.Rebate_Claims__c, rebateClaimTotalPaidMap.get(typePayout.Rebate_Claims__c) + typePayout.Total_Amount_Paid__c);
                rebateClaimTotalPaidMap.put(typePayout.Rebate_Claims__c, rebateClaimTotalPaidMap.get(typePayout.Rebate_Claims__c) + typePayout.Transaction_Amount__c);
                system.debug('rebateClaimTotalPaidMap => ' + rebateClaimTotalPaidMap);
            }
            if(typePayout.Check_Number__c != null){
                if(!rebateClaimCheckNumbersMap.containsKey(typePayout.Rebate_Claims__c)){
                    rebateClaimCheckNumbersMap.put(typePayout.Rebate_Claims__c, new Set<String>());
                }
                rebateClaimCheckNumbersMap.get(typePayout.Rebate_Claims__c).add(typePayout.Check_Number__c);
            }

        }
        //update rebate claim aggregates and rebate claims
        List<Rebate_Claim_Aggregate__c> claimAggregatesToUpdate = new List<Rebate_Claim_Aggregate__c>();
        List<Rebate_Claim__c> rebateClaimsToUpdate = new List<Rebate_Claim__c>();
        for(Id rebateClaimId: rebateClaimIds){
            Rebate_Claim__c rebateClaim = new Rebate_Claim__c();
            Rebate_Claim_Aggregate__c claimAggregate = new Rebate_Claim_Aggregate__c();
            if(rebateClaimIDToRebateClaimAggregateIdMap.containsKey(rebateClaimId)){
                claimAggregate.Id = rebateClaimIDToRebateClaimAggregateIdMap.get(rebateClaimId);
            }
            rebateClaim.Id = rebateClaimId;
            if(rebateClaimTotalPaidMap.containsKey(rebateClaimId)){
                rebateClaim.Total_Rebate_Amount__c = rebateClaimTotalPaidMap.get(rebateClaimId);
                claimAggregate.Total_Amount_Paid__c = rebateClaimTotalPaidMap.get(rebateClaimId);
            }
            if(rebateClaimCheckNumbersMap.containsKey(rebateClaimId)){
                rebateClaim.Check_Number__c = String.join(new List<String>(rebateClaimCheckNumbersMap.get(rebateClaimId)), ',');
                claimAggregate.Check_Number__c = rebateClaim.Check_Number__c;
            }
            rebateClaim.Status__c = RebateUtility.REBATE_CLAIMS_STATUS_PAYOUT_COMPLETED;
            rebateClaimsToUpdate.add(rebateClaim);
            if(claimAggregate.Id != null){
                claimAggregatesToUpdate.add(claimAggregate);
            }
        }
        update claimAggregatesToUpdate;
        update rebateClaimsToUpdate;
    }
}