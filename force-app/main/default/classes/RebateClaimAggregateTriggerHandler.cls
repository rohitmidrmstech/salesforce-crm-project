public class RebateClaimAggregateTriggerHandler {
    public static void prePopulateBIRPayoutFields(List<Rebate_Claim_Aggregate__c> rebateClaimAggregates){
        //get years associated to BIR Pauouts (PFX_Claim__c is populated only for BIR payouts)
        Set<String> years = new Set<String>();
        for(Rebate_Claim_Aggregate__c rebateClaimAggregate: rebateClaimAggregates){
            if(String.isNotBlank(rebateClaimAggregate.PFX_Claim__c) && rebateClaimAggregate.Payment_Date__c != null){
                years.add(String.valueof(rebateClaimAggregate.Payment_Date__c.year()));
            }
        }

        if(!years.isEmpty()){
            //get Rebate Programs associated to years
            Map<String,RebateProgram> rebateProgramMap = new Map<String,RebateProgram>();
            for(RebateProgram rebateProgram : [Select Id,Program_Active_Year__c,
                                            (Select Id from RebateProgramMembers where MemberStatus = : RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE),
                                            (Select Id from RebateProgramPayoutPeriods)
                                            from RebateProgram 
                                            where Program_Active_Year__c in:years and  Rebate_Program_Type__c =: salesAgreementProductsFormController.BIR_PROGRAM]){
                rebateProgramMap.put(rebateProgram.Program_Active_Year__c, rebateProgram);
            }

            for(Rebate_Claim_Aggregate__c rebateClaimAggregate: rebateClaimAggregates){
                if(String.isNotBlank(rebateClaimAggregate.PFX_Claim__c) && rebateClaimAggregate.Payment_Date__c != null && rebateprogramMap.containskey(String.valueof(rebateClaimAggregate.Payment_Date__c.year()))){
                    RebateProgram rebateProgram = rebateprogramMap.get(String.valueof(rebateClaimAggregate.Payment_Date__c.year()));
                    if(!rebateProgram.RebateProgramPayoutPeriods.isEmpty()){
                        rebateClaimAggregate.Rebate_Program_Payout_Period__c = rebateProgram.RebateProgramPayoutPeriods[0].Id;
                    }
                }
            }
        }
    }
    //method re-writen to create RebateProgramMemberPayout only at the Member/Period level and no association with Rebate Claim Aggregate
    public static void syncRebateProgramMemberPayout(List<Rebate_Claim_Aggregate__c> rebateClaimAggregates, boolean isUpdate){
        //get program members for BIR rebates
        Set<String> years = new Set<String>();
        Set<Id> periodIds = new Set<Id>();
        Set<Id> memberIds = new Set<Id>();
        for(Rebate_Claim_Aggregate__c rebateClaimAggregate: rebateClaimAggregates){
            if(String.isNotBlank(rebateClaimAggregate.PFX_Claim__c) && rebateClaimAggregate.Payment_Date__c != null){
                years.add(String.valueof(rebateClaimAggregate.Payment_Date__c.year()));
            }
        }
        Map<String,Id> birProgramMembersByYearMap = new Map<String,Id>();
        if(!years.isEmpty()){
            for(RebateProgram rebateProgram : [Select Id,Program_Active_Year__c,
                                            (Select Id from RebateProgramMembers where MemberStatus = : RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE)
                                            from RebateProgram 
                                            where Program_Active_Year__c in:years and  Rebate_Program_Type__c =: salesAgreementProductsFormController.BIR_PROGRAM]){
                if(!rebateProgram.RebateProgramMembers.isEmpty()) {                          
                    birProgramMembersByYearMap.put(rebateProgram.Program_Active_Year__c, rebateProgram.RebateProgramMembers[0].Id);
                    memberIds.add(rebateProgram.RebateProgramMembers[0].Id);
                }
            }
        }

        
        //get existing ProgramRebateTypePayout records
        Map<Id,Rebate_Claim_Aggregate__c> rebateAggregatesWithProgramMember = new  Map<Id,Rebate_Claim_Aggregate__c>(
            [Select Id, Rebate_Claim__r.Rebate_Program_Member__c from Rebate_Claim_Aggregate__c where Id in: rebateClaimAggregates]);

        
        for(Rebate_Claim_Aggregate__c rebateClaimAggregate: rebateClaimAggregates){
            if(rebateClaimAggregate.Rebate_Program_Payout_Period__c != null){
                periodIds.add(rebateClaimAggregate.Rebate_Program_Payout_Period__c);
            }
            if(rebateClaimAggregate.Rebate_Claim__c != null 
                && rebateAggregatesWithProgramMember.get(rebateClaimAggregate.Id).Rebate_Claim__r.Rebate_Program_Member__c != null){                
                memberIds.add(rebateAggregatesWithProgramMember.get(rebateClaimAggregate.Id).Rebate_Claim__r.Rebate_Program_Member__c);
            }
        }

        if(!memberIds.isEmpty()){
            Map<String,Id> existingRebateProgramMemberPayoutMap = new Map<String,Id>();
            for(RebateProgramMemberPayout memberPayout: [Select Id, PeriodId, MemberId from RebateProgramMemberPayout 
                                                        where MemberId in: memberIds and PeriodId in: periodIds]){
                existingRebateProgramMemberPayoutMap.put(memberPayout.MemberId + '-' + memberPayout.PeriodId, memberPayout.Id);
            }

            Set<String> payoutKeysAlreadyAccounted = new Set<String>();
            List<RebateProgramMemberPayout> rebateProgramMemberPayoutsToCreate = new List<RebateProgramMemberPayout>();
            for(Rebate_Claim_Aggregate__c rebateClaimAggregate: rebateClaimAggregates){
                Id memberId;
                //get member by year for BIR rebates
                if(String.isNotBlank(rebateClaimAggregate.PFX_Claim__c) && rebateClaimAggregate.Payment_Date__c != null && birProgramMembersByYearMap.containsKey(String.valueof(rebateClaimAggregate.Payment_Date__c.year()))){
                    memberId = birProgramMembersByYearMap.get(String.valueof(rebateClaimAggregate.Payment_Date__c.year()));
                }
                //get member id through Rebate claims for BSP/CCB
                if(memberId == null && rebateClaimAggregate.Rebate_Claim__c != null &&
                rebateAggregatesWithProgramMember.get(rebateClaimAggregate.Id).Rebate_Claim__r.Rebate_Program_Member__c != null){
                    memberId = rebateAggregatesWithProgramMember.get(rebateClaimAggregate.Id).Rebate_Claim__r.Rebate_Program_Member__c;
                }
                if(rebateClaimAggregate.Rebate_Program_Payout_Period__c != null && memberId != null ){
                    string memberPayoutKey = memberId + '-' + rebateClaimAggregate.Rebate_Program_Payout_Period__c;
                    if(!existingRebateProgramMemberPayoutMap.containsKey(memberPayoutKey) && !payoutKeysAlreadyAccounted.contains(memberPayoutKey)){
                        payoutKeysAlreadyAccounted.add(memberPayoutKey);
                        RebateProgramMemberPayout rebateProgramMemberPayout = new RebateProgramMemberPayout();
                        rebateProgramMemberPayout.Name = rebateClaimAggregate.Name; //could this be another name?
                        rebateProgramMemberPayout.PeriodId = rebateClaimAggregate.Rebate_Program_Payout_Period__c;
                        rebateProgramMemberPayout.MemberId = memberId;
                        rebateProgramMemberPayout.Status = RebateUtility.REBATE_PROGRAM_MEMBER_PAYOUT_STATUS_CALCULATION_IN_PROGRESS; // what status makes sense
                        rebateProgramMemberPayoutsToCreate.add(rebateProgramMemberPayout);
                    }
                }               
            }
            if(!rebateProgramMemberPayoutsToCreate.isEmpty()){
                insert rebateProgramMemberPayoutsToCreate;
            }
        }

        //process child records when Rebate_Claim_Aggregate__c is created for the first time
        Set<Id> rebateClaimIds = new Set<Id>();
        for(Rebate_Claim_Aggregate__c rebateClaimAggregate: rebateClaimAggregates){
            if(rebateClaimAggregate.Rebate_Claim__c != null){
                rebateClaimIds.add(rebateClaimAggregate.Rebate_Claim__c);
            }
        }
        if(!isUpdate && !rebateClaimIds.isEmpty()){
            List<RebateMemberProductAggregate> rebateMemberProductAggregates = [Select Id, ProgramRebateTypeId, Rebate_Claim__c, TotalTransactionAmount, Name
                                                                                from RebateMemberProductAggregate where Rebate_Claim__c in: rebateClaimIds];
            if(!RebateMemberProductAggregates.isEmpty()){
                RebateMemberProductAggregateTrigrHandler.syncProgramRebateTypePayout(rebateMemberProductAggregates, true);

                List<RebateMemberAggregateItem> rebateMemberAggregateItems = [Select Id, RebateMemberProductAggregateId, TransactionJournalId, TransactionAmount, Name
                                                                             from RebateMemberAggregateItem
                                                                            where RebateMemberProductAggregateId in: RebateMemberProductAggregates];
                if(!rebateMemberAggregateItems.isEmpty()){
                    RebateMemberAggregateItemTriggerHandler.syncProgramRebateTypePayoutSource(rebateMemberAggregateItems, true);
                }
            }
        }
    }

    public static void syncRebateClaimRebateAmount(List<Rebate_Claim_Aggregate__c> rebateClaimAggregates){
        //how do we manage rebateClaim.Status__c
        List<Rebate_Claim__c> rebateClaims = new List<Rebate_Claim__c>();
        for(Rebate_Claim_Aggregate__c rebateClaimAggregate: rebateClaimAggregates){
            if(rebateClaimAggregate.Rebate_Claim__c != null){
                Rebate_Claim__c rebateClaim = new Rebate_Claim__c(
                    Id = rebateClaimAggregate.Rebate_Claim__c, 
                    Total_Rebate_Amount__c =rebateClaimAggregate.Total_Rebate_Amount__c,
                    Check_Number__c = rebateClaimAggregate.Check_Number__c,             
                    Status__c = RebateUtility.REBATE_CLAIMS_STATUS_PAYOUT_COMPLETED);
                rebateClaims.add(rebateClaim);
            }
        }
        update rebateClaims;
    }
}