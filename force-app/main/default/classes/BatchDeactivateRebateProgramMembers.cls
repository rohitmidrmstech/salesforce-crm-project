global class BatchDeactivateRebateProgramMembers implements Database.Batchable<sObject>, Database.Stateful{
    List<RebateProgram> rebatePrograms;
    global BatchDeactivateRebateProgramMembers(List<RebateProgram> rebatePrograms){
        this.rebatePrograms = rebatePrograms;
    }
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator('Select Id from RebateProgramMember where RebateProgramId in: rebatePrograms and MemberStatus = \'Active\'');
    }

    global Void execute(Database.BatchableContext BC, List<sObject> scope) {
        List<RebateProgramMember> programMembers = (List<RebateProgramMember>)scope;
        for(RebateProgramMember rebateProgramMember: programMembers){
            rebateProgramMember.MemberStatus = RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_INACTIVE;
        }
        update programMembers;
    }

    global void finish(Database.BatchableContext BC) {

    }  
}