public class RebateMemberAggregateItemTriggerHandler {
    public static void syncProgramRebateTypePayoutSource(List<RebateMemberAggregateItem> rebateMemberAggregateItems, Boolean checkForExistingRecords){
        Set<Id> transactionJournalIds = new Set<Id>();
        Set<Id> rebateMemberProductAggregateIds = new Set<Id>();
        for(RebateMemberAggregateItem rebateMemberAggregateItem: rebateMemberAggregateItems){
            if(rebateMemberAggregateItem.TransactionJournalId != null){
                transactionJournalIds.add(rebateMemberAggregateItem.TransactionJournalId);
            }
            if(rebateMemberAggregateItem.RebateMemberProductAggregateId != null){
                rebateMemberProductAggregateIds.add(rebateMemberAggregateItem.RebateMemberProductAggregateId);
            }
        }

        Map<Id,TransactionJournal> transactionJournalMa= new Map<Id,TransactionJournal> (
            [Select Id, MemberId from TransactionJournal where Id in: transactionJournalIds]
        );

        //get existing ProgramRebateTypPayoutSrc records
        Map<Id,Id> aggregateItemToPayoutSrcMap = new  Map<Id,Id> ();
        if(checkForExistingRecords){
            for(ProgramRebateTypPayoutSrc rebateTypePayoutSource: [Select Id, Rebate_Business_Unit_Aggregate_Item__c from  ProgramRebateTypPayoutSrc where Rebate_Business_Unit_Aggregate_Item__c in:rebateMemberAggregateItems]){
                aggregateItemToPayoutSrcMap.put(rebateTypePayoutSource.Rebate_Business_Unit_Aggregate_Item__c, rebateTypePayoutSource.Id);
            }
        }

        //get info from ProgramRebateTypePayout
        Map<Id,Id> rebateMemberProductAggregateToProgramRebateTypePayoutMap = new  Map<Id,Id>();
        for(ProgramRebateTypePayout programRebateTypePayout : [Select Id, Rebate_Business_Unit_Aggregate__C 
                                                              from ProgramRebateTypePayout 
                                                              where Rebate_Business_Unit_Aggregate__C in:rebateMemberProductAggregateIds]){
            rebateMemberProductAggregateToProgramRebateTypePayoutMap.put(programRebateTypePayout.Rebate_Business_Unit_Aggregate__C, programRebateTypePayout.Id);
        }
        

        List<ProgramRebateTypPayoutSrc> payoutSources = new List<ProgramRebateTypPayoutSrc>();
        for(RebateMemberAggregateItem rebateMemberAggregateItem: rebateMemberAggregateItems){
            ProgramRebateTypPayoutSrc payoutSrc = new ProgramRebateTypPayoutSrc();
            //only process record if master detail is available
            if(rebateMemberProductAggregateToProgramRebateTypePayoutMap.containsKey(rebateMemberAggregateItem.RebateMemberProductAggregateId)){
                payoutSrc.ProgramRebateTypePayoutId = rebateMemberProductAggregateToProgramRebateTypePayoutMap.get(rebateMemberAggregateItem.RebateMemberProductAggregateId);
            
            
                payoutSrc.RebateAmount = rebateMemberAggregateItem.TransactionAmount;
                if(rebateMemberAggregateItem.TransactionJournalId != null && transactionJournalMa.containskey(rebateMemberAggregateItem.TransactionJournalId)){
                    payoutSrc.MemberId = transactionJournalMa.get(rebateMemberAggregateItem.TransactionJournalId).MemberId;
                }
                payoutSrc.Rebate_Business_Unit_Aggregate_Item__c = rebateMemberAggregateItem.Id;
                if(aggregateItemToPayoutSrcMap.containskey(rebateMemberAggregateItem.Id)){
                    payoutSrc.Id = aggregateItemToPayoutSrcMap.get(rebateMemberAggregateItem.Id);
                }
                payoutSrc.Name = rebateMemberAggregateItem.Name;
                payoutSources.add(payoutSrc);
            }
        }
        if(!payoutSources.isEmpty()){
            upsert payoutSources;
        }
    }
}