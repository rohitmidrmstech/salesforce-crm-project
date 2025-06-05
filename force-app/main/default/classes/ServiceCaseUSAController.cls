public without sharing class ServiceCaseUSAController {
    
    @AuraEnabled
    public static String recallApproval(String recordId) {
        List<ProcessInstance> steps = [SELECT Id, Status, CreatedDate, CompletedDate, TargetObjectId, 
                                      (SELECT Id, StepStatus, ActorId, Actor.Name, ElapsedTimeInDays, ElapsedTimeInMinutes, 
                                       CreatedDate, ProcessNodeId, ProcessNode.Name, Comments 
                                       FROM StepsAndWorkitems order by CreatedDate desc) 
                                       FROM ProcessInstance 
                                       WHERE TargetObjectId =: recordId
                                       ORDER BY CreatedDate desc];
        
        String status = '';
        for(ProcessInstance rec : steps) {
            for(ProcessInstanceHistory crec : rec.StepsAndWorkitems) {
                if(crec.StepStatus == 'Approved' && crec.ActorId == UserInfo.getUserId()) {
                    
                    if(crec.ProcessNode.Name == 'Pending CSM Approval') {
                        status = 'Pending CSM';
                    }
                    else if(crec.ProcessNode.Name == 'Pending Transportation Approval') {
                        status = 'Pending Transportation';
                    }
                    else if(crec.ProcessNode.Name == 'Pending RSM Approval') {
                        status = 'Pending RSM';
                    }
                    else if(crec.ProcessNode.Name == 'Pending Plant Manager Approval') {
                        status = 'Pending Plant Manager';
                    }
                    
                    break;
                }
            }
        }
        
        System.debug('status :::::' + status);
        
        if(status == '') {
            for(ProcessInstance rec : steps) {
                for(ProcessInstanceHistory crec : rec.StepsAndWorkitems) {
                    if(crec.StepStatus == 'Started' && crec.ActorId == UserInfo.getUserId()) {
                        status = 'Draft';
                        break;
                    }
                }
            }
        }
        
        System.debug('status :::::' + status);
        
        if(status != '') {
            Case newCase = new Case(Status = status, Id = recordId, Lock_Recall__c = true, Process_Builder_Update__c = true);
            
            if(status == 'Draft') {
                newCase.OwnerId = UserInfo.getUserId();
                newCase.Lock_Recall__c = false;
            }
            
            update newCase;
            
            ServiceCaseUSAController.recallApprovalStep(recordId, status);
        }
        
        return status;
    }
    
    @AuraEnabled
    public static void assignPermissionSet() {
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'Modify_All_Cases'];
        insert new PermissionSetAssignment(AssigneeId = UserInfo.getUserId(), PermissionSetId = ps.Id);
    }
    
    @AuraEnabled
    public static void removePermissionSet() {
        PermissionSetAssignment psa = [SELECT Id FROM PermissionSetAssignment 
                                       WHERE PermissionSet.Name = 'Modify_All_Cases'
                                       AND AssigneeId =: UserInfo.getUserId()];
                                                    
        delete psa;
    }
    
    @AuraEnabled
    public static void recallApprovalStep(String recordId, String status) {
        
        ProcessInstanceWorkitem[] Pval = [SELECT Id FROM ProcessInstanceWorkItem 
                                          WHERE ProcessInstance.TargetObjectId = :recordId 
                                          AND ProcessInstance.Status = 'Pending']; 
        if(Pval.size() > 0){
                 
            Approval.ProcessWorkItemRequest Preq= new Approval.ProcessWorkItemRequest();
            Preq.setAction('Removed');
            Preq.setWorkItemId(Pval[0].Id);
            Approval.ProcessResult result = Approval.process(Preq);
        }
        
        if(status != 'Draft') {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setObjectId(recordId);
            //If the next step in your approval process is another Apex approval process, you specify exactly one user ID as the next approver. 
            //If not, you cannot specify a user ID and this method must be null.
            Approval.ProcessResult processResult = Approval.process(req);
        }
    }
    
    //@AuraEnabled
}