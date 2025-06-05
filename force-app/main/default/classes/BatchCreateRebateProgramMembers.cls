global class BatchCreateRebateProgramMembers implements Database.Batchable<sObject>, Database.Stateful{
    List<RebateProgram> rebatePrograms;
    Set<Id> lastCurrentAndFutureYearRebateProgramIds = new Set<Id>();
    Set<String> applicableCCBEligibilityValues = new Set<String>();
    Set<String> applicableCPEligibilityValues = new Set<String>();
    Set<String> applicableBSPEligibilityValues = new Set<String>();
    Integer lastYear;
    String rebateProgramNameJoiningString = ' - ';
    global BatchCreateRebateProgramMembers(List<RebateProgram> rebatePrograms){
        this.rebatePrograms = rebatePrograms;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        lastYear = Date.today().year() - 1;
        for(RebateProgram rebateProgram: rebatePrograms){
            if(rebateProgram.Program_Active_Year__c != null){
                Integer programYear = Integer.valueOf(rebateProgram.Program_Active_Year__c);

                if(programYear >= lastYear){
                    lastCurrentAndFutureYearRebateProgramIds.add(rebateProgram.Id);
                    //CCB Program
                    if(rebateProgram.Rebate_Program_Type__c == CCBClaimFormController.CCB_PROGRAM_IDENTIFIER){
                        applicableCCBEligibilityValues.add(salesAgreementProductsFormController.ELIGIBLE);
                        if(programYear == lastYear){
                            applicableCCBEligibilityValues.add(RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR);
                        }
                    }
                    //CP Program
                    if(rebateProgram.Rebate_Program_Type__c == CCBClaimFormController.CP_PROGRAM_IDENTIFIER){
                        applicableCPEligibilityValues.add(salesAgreementProductsFormController.ELIGIBLE);
                        if(programYear == lastYear){
                            applicableCPEligibilityValues.add(RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR);
                        }
                    }
                    //BSP Program
                    if(rebateProgram.Rebate_Program_Type__c == salesAgreementProductsFormController.BSP_PROGRAM){
                        applicableBSPEligibilityValues.add(salesAgreementProductsFormController.ELIGIBLE);
                        if(programYear == lastYear){
                            applicableBSPEligibilityValues.add(RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR);
                        }
                    }
                }
            }
        }

        if(!applicableCCBEligibilityValues.isEmpty() || !applicableCPEligibilityValues.isEmpty() || !applicableBSPEligibilityValues.isEmpty()){
            String contactQuery = 'Select Id,AccountId,Name,Account.Name,CCB_Eligibility__c,Change_Pay_Eligibility__c,BSP_Eligibility__c from Contact where  Distributor__c != \'Yes\'  and (';
            List<String> eligibilityConditions = new List<String>();
            if(!applicableCCBEligibilityValues.isEmpty()){ 
                eligibilityConditions.add('CCB_Eligibility__c in: applicableCCBEligibilityValues');     
            }
            if(!applicableCPEligibilityValues.isEmpty()){
                eligibilityConditions.add('Change_Pay_Eligibility__c in: applicableCPEligibilityValues');          
            }
            if(!applicableBSPEligibilityValues.isEmpty()){   
                eligibilityConditions.add('BSP_Eligibility__c in: applicableBSPEligibilityValues');       
            }
            contactQuery += String.join(eligibilityConditions, ' or ');
            contactQuery += ' ) order by AccountId';

            return Database.getQueryLocator(contactQuery);
        }
        else{
            return null;
        }
    }

    global Void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<Contact> contacts = (List<Contact>)scope;
        List<RebateProgramMember> rebateProgramMembersToUpsert = new List<RebateProgramMember>();
        Map<string,RebateProgramMember> existingRebateProgramMembersMap = new Map<String,RebateProgramMember>();
        Set<Id> contactIdsForMemberQuery = new Set<Id>();
        Set<Id> accountIdsForMemberQuery = new Set<Id>();
        Set<Id> accountIdsALreadyProcessedForBSP = new Set<Id>();

        System.debug(JSON.serialize(contacts));
        for(Contact con: contacts){
            //if we have CCB/CP Rebates in context, use contact id for Query
            if(!applicableCCBEligibilityValues.isEmpty() || !applicableCPEligibilityValues.isEmpty()){
                contactIdsForMemberQuery.add(con.Id);
            }
            //if we have BSP Rebates in context, use Account id for Query
            if(!applicableBSPEligibilityValues.isEmpty() && con.AccountId != null){
                accountIdsForMemberQuery.add(con.AccountId);
            }
        }

        
        //get existing program members
        for(RebateProgramMember programMember: [Select AccountId, Contact__c, RebateProgramId,RebateProgram.Rebate_Program_Type__c, MemberStatus
                                                from RebateProgramMember 
                                                where RebateProgramId in: rebatePrograms and (Contact__c in: contactIdsForMemberQuery or AccountId in: accountIdsForMemberQuery)]){
            string key = programMember.RebateProgram.Rebate_Program_Type__c == salesAgreementProductsFormController.BSP_PROGRAM ? programMember.AccountId : programMember.Contact__c;
            key += '-' + programMember.RebateProgramId;
            existingRebateProgramMembersMap.put(key, programMember);
        }
        
        for(RebateProgram rebateProgram: rebatePrograms){
            if(lastCurrentAndFutureYearRebateProgramIds.contains(rebateProgram.Id)){
                Set<String> applicableEligibilityValues = new Set<String>{salesAgreementProductsFormController.ELIGIBLE};
                if(Integer.valueOf(rebateProgram.Program_Active_Year__c) == lastYear){
                    applicableEligibilityValues.add(RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR);
                }
                for(Contact con: contacts){
                    //bsp program
                    if(rebateProgram.Rebate_Program_Type__c == salesAgreementProductsFormController.BSP_PROGRAM && con.AccountId != null){
                        //check BSP eligibility
                        if(isEligible(applicableEligibilityValues, con.BSP_Eligibility__c) && !accountIdsALreadyProcessedForBSP.contains(con.AccountId)){
                            accountIdsALreadyProcessedForBSP.add(con.AccountId);

                            string key = con.AccountId + '-' + rebateProgram.Id;
                            if(existingRebateProgramMembersMap.containsKey(key)){
                                if(existingRebateProgramMembersMap.get(key).MemberStatus != salesAgreementProductsFormController.STATUS_ACTIVE){
                                    rebateProgramMembersToUpsert.add(new RebateProgramMember(MemberStatus = RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE,Id = existingRebateProgramMembersMap.get(key).Id));
                                }
                            }
                            else{
                                rebateProgramMembersToUpsert.add(
                                    new RebateProgramMember(
                                            MemberStatus = RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE,
                                            RebateProgramId = rebateProgram.Id,
                                            Name = rebateProgram.Name + rebateProgramNameJoiningString +con.Account.Name,
                                            AccountId = con.AccountId
                                    )
                                );
                            }
                        }
                    }
                    //CCB or CP program and is eligible
                    else if((rebateProgram.Rebate_Program_Type__c == CCBClaimFormController.CCB_PROGRAM_IDENTIFIER && isEligible(applicableEligibilityValues, con.CCB_Eligibility__c))
                    || (rebateProgram.Rebate_Program_Type__c == CCBClaimFormController.CP_PROGRAM_IDENTIFIER && isEligible(applicableEligibilityValues, con.Change_Pay_Eligibility__c))){
                        string key = con.Id + '-' + rebateProgram.Id;
                        if(existingRebateProgramMembersMap.containsKey(key)){
                            if(existingRebateProgramMembersMap.get(key).MemberStatus != salesAgreementProductsFormController.STATUS_ACTIVE){
                                rebateProgramMembersToUpsert.add(new RebateProgramMember(MemberStatus = RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE,Id = existingRebateProgramMembersMap.get(key).Id));
                            }
                        }
                        else{
                            rebateProgramMembersToUpsert.add(
                                new RebateProgramMember(
                                        MemberStatus = RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE,
                                        RebateProgramId = rebateProgram.Id,
                                        Name = rebateProgram.Name + rebateProgramNameJoiningString +con.Name,
                                        Contact__c = con.Id
                                )
                            );
                        }
                    }
                }
            }
        }    
        upsert rebateProgramMembersToUpsert;

    }

    static boolean isEligible(Set<String> eligibleValues, string currentValue){
        boolean isEligible = false;
        for(String eligibleValue: eligibleValues){
            if(eligibleValue.equalsIgnoreCase(currentValue)){
                isEligible = true;
                break;
            }
        }
        return isEligible;
    }

    global void finish(Database.BatchableContext BC) {

    }    
}