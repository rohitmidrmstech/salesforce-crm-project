public  class RebateMemberProductAggregateTrigrHandler {
    //method re-writen so that member payout is found from Rebate Claim Aggregate
    public static void syncProgramRebateTypePayout(List<RebateMemberProductAggregate> rebateMemberProductAggregates, Boolean checkForExistingRecords){
        
        //get existing ProgramRebateTypePayout records
        Map<Id,Id> productAggregateToProgramRebateTypePayoutMap = new  Map<Id,Id> ();
        if(checkForExistingRecords){
            for(ProgramRebateTypePayout programRebateTypePayout: [Select Id, Rebate_Business_Unit_Aggregate__c from  ProgramRebateTypePayout 
                                                                  where Rebate_Business_Unit_Aggregate__c in:rebateMemberProductAggregates]){
                productAggregateToProgramRebateTypePayoutMap.put(programRebateTypePayout.Rebate_Business_Unit_Aggregate__C, programRebateTypePayout.Id);
            }
        }

        //get info from Program Rebate type
        Set<Id> ProgramRebateTypeIds = new Set<Id>();
        Set<Id> rebateClaimIds = new Set<Id>();
        Map<Id,ProgramRebateType> programRebateTypeMap = new Map<Id,ProgramRebateType>();
        Map<Id,WOD_Manufacturing_Plant__c> businessUnitToSapAccountMap = new Map<Id,WOD_Manufacturing_Plant__c>();
        for(RebateMemberProductAggregate rebateMemberProductAggregate: rebateMemberProductAggregates){
            if(rebateMemberProductAggregate.ProgramRebateTypeId!= null){
                ProgramRebateTypeIds.add(rebateMemberProductAggregate.ProgramRebateTypeId);
            }
            if(rebateMemberProductAggregate.Rebate_Claim__c != null){
                rebateClaimIds.add(rebateMemberProductAggregate.Rebate_Claim__c);
            }
        }
        if(!ProgramRebateTypeIds.isEmpty()){
            programRebateTypeMap = new Map<Id,ProgramRebateType>([Select Id,Business_Units__c,Name
                                                                from ProgramRebateType 
                                                                where Id in: ProgramRebateTypeIds and Business_Units__c != null]);
            Set<Id> businessUnitIds = new Set<Id>();
            if(!programRebateTypeMap.isEmpty()){
                for(ProgramRebateType programRebateType: programRebateTypeMap.values()){
                    businessUnitIds.add(programRebateType.Business_Units__c);
                }
                for(WOD_Manufacturing_Plant__c sapAccount: [Select Id,Business_Units__c, SAP_GL_Account__c,SAP_Profit_Center__c from WOD_Manufacturing_Plant__c where Business_Units__c in: businessUnitIds]){
                    businessUnitToSapAccountMap.put(sapAccount.Business_Units__c, sapAccount);
                }
            }
        }        

        //get info from rebate claim
        Set<Id> periodIds = new Set<Id>();
        Set<Id> memberIds = new Set<Id>();
        Set<String> years = new Set<String>();

        Map<Id,Rebate_Claim_Aggregate__c> rebateClaimToRebateAggregatemap = new Map<Id,Rebate_Claim_Aggregate__c>();       
        for(Rebate_Claim_Aggregate__c rebateClaimAggregate: [Select Id, Rebate_Claim__c, Rebate_Claim__r.Rebate_Program_Member__c,Rebate_Program_Payout_Period__c,
                                                            PFX_Claim__c,Payment_Date__c
                                                            from Rebate_Claim_Aggregate__c 
                                                            where Rebate_Claim__c in: rebateClaimIds]){
            rebateClaimToRebateAggregatemap.put(rebateClaimAggregate.Rebate_Claim__c, rebateClaimAggregate);

            if(rebateClaimAggregate.Rebate_Program_Payout_Period__c != null){
                periodIds.add(rebateClaimAggregate.Rebate_Program_Payout_Period__c);
            }
            if(rebateClaimAggregate.Rebate_Claim__r.Rebate_Program_Member__c != null){
                memberIds.add(rebateClaimAggregate.Rebate_Claim__r.Rebate_Program_Member__c);
            }
            if(rebateClaimAggregate != null && rebateClaimAggregate.Payment_Date__c != null){
                years.add(String.valueof(rebateClaimAggregate.Payment_Date__c.year()));
            }
        }
        //add program members for BIR rebates
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

        Map<String,Id> existingRebateProgramMemberPayoutMap = new Map<String,Id>();
        for(RebateProgramMemberPayout memberPayout: [Select Id, PeriodId, MemberId from RebateProgramMemberPayout 
                                                    where MemberId in: memberIds and PeriodId in: periodIds]){
            existingRebateProgramMemberPayoutMap.put(memberPayout.MemberId + '-' + memberPayout.PeriodId, memberPayout.Id);
        }
        

        List<ProgramRebateTypePayout> programRebateTypePayouts = new List<ProgramRebateTypePayout>();
        Set<Id> rebateClaimsWithMissingSAPInfo = new Set<Id>();
        for(RebateMemberProductAggregate rebateMemberProductAggregate: rebateMemberProductAggregates){
            ProgramRebateTypePayout programRebateTypePayout = new ProgramRebateTypePayout();
            //process record only when master is found
            if(rebateMemberProductAggregate.Rebate_Claim__c != null && rebateClaimToRebateAggregatemap.containsKey(rebateMemberProductAggregate.Rebate_Claim__c)){
                Rebate_Claim_Aggregate__c parentAggregate = rebateClaimToRebateAggregatemap.get(rebateMemberProductAggregate.Rebate_Claim__c);
                Id memberId;
                //get from rebate for BSP/CCB
                if(parentAggregate.Rebate_Claim__c != null && parentAggregate.Rebate_Claim__r.Rebate_Program_Member__c != null){
                    memberId = parentAggregate.Rebate_Claim__r.Rebate_Program_Member__c;
                }
                //get from year for BIR
                if(memberId == null){
                    if(parentAggregate.PFX_Claim__c != null && parentAggregate.Payment_Date__c != null && birProgramMembersByYearMap.containskey(String.valueof(parentAggregate.Payment_Date__c.year()))){
                        memberId = birProgramMembersByYearMap.get(String.valueof(parentAggregate.Payment_Date__c.year()));
                    }
                }
                if(parentAggregate.Rebate_Program_Payout_Period__c != null && memberId != null){
                    string memberPayoutKey = memberId + '-' + parentAggregate.Rebate_Program_Payout_Period__c;
                    if(existingRebateProgramMemberPayoutMap.containsKey(memberPayoutKey)){                
                        programRebateTypePayout.RebateProgramMemberPayoutId = existingRebateProgramMemberPayoutMap.get(memberPayoutKey);                
                        programRebateTypePayout.ProgramRebateTypeId = rebateMemberProductAggregate.ProgramRebateTypeId;
                        if(rebateMemberProductAggregate.ProgramRebateTypeId != null){
                            if(programRebateTypeMap.containskey(rebateMemberProductAggregate.ProgramRebateTypeId)){
                                programRebateTypePayout.Name = programRebateTypeMap.get(rebateMemberProductAggregate.ProgramRebateTypeId).Name;
                                if(businessUnitToSapAccountMap.containsKey(programRebateTypeMap.get(rebateMemberProductAggregate.ProgramRebateTypeId).Business_Units__c)){
                                    WOD_Manufacturing_Plant__c sapAccount = businessUnitToSapAccountMap.get(programRebateTypeMap.get(rebateMemberProductAggregate.ProgramRebateTypeId).Business_Units__c);
                                    programRebateTypePayout.SAP_Account__c = sapAccount.Id;
                                    //check SAP fields necessary for payment processing are present
                                    if((String.isBlank(sapAccount.SAP_GL_Account__c) || String.isBlank(sapAccount.SAP_Profit_Center__c) && rebateMemberProductAggregate.Rebate_Claim__c != null)){
                                        rebateClaimsWithMissingSAPInfo.add(rebateMemberProductAggregate.Rebate_Claim__c);
                                    }
                                }
                                else if(rebateMemberProductAggregate.Rebate_Claim__c != null){
                                    rebateClaimsWithMissingSAPInfo.add(rebateMemberProductAggregate.Rebate_Claim__c);
                                }
                            }
                        }
                        programRebateTypePayout.Transaction_Amount__c = rebateMemberProductAggregate.TotalTransactionAmount;
                        programRebateTypePayout.Rebate_Business_Unit_Aggregate__c = rebateMemberProductAggregate.Id;
                        programRebateTypePayout.Rebate_Claims__c = rebateMemberProductAggregate.Rebate_Claim__c;
                        if(productAggregateToProgramRebateTypePayoutMap.containskey(rebateMemberProductAggregate.Id)){
                            programRebateTypePayout.Id = productAggregateToProgramRebateTypePayoutMap.get(rebateMemberProductAggregate.Id);
                        }
                        if(programRebateTypePayout.Name == null){
                            programRebateTypePayout.Name = rebateMemberProductAggregate.Name;
                        } 
                        programRebateTypePayout.Rebate_Claim_Aggregate__c = parentAggregate.Id;       
                        programRebateTypePayouts.add(programRebateTypePayout);
                    }
                }
            }
        }
        if(!programRebateTypePayouts.isEmpty()){
            upsert programRebateTypePayouts;
        }
        if(!rebateClaimsWithMissingSAPInfo.isEmpty()){
            List<Rebate_Claim__c> rebateClaimsToUpdate = new List<Rebate_Claim__c>();
            for(Id rebateClaimId: rebateClaimsWithMissingSAPInfo){
                rebateClaimsToUpdate.add(new Rebate_Claim__c(Id = rebateClaimId ,Processing_Error_Reason__c = Label.Error_SAP_Info_Missing_on_Processed_Rebates ));
            }
            update rebateClaimsToUpdate;
        }
    }
}