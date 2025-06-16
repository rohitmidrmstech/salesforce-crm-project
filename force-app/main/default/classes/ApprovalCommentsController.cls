public class ApprovalCommentsController {
	public List<String> approvalComments{get;set;}
    public string recordID {
        get {return recordID;}
        set {
            recordId = value;
            returnComments();
        }
    }

    public void returnComments() {
        approvalComments = new List<String>();
        Map<ID, User> usrMap = new Map<ID, User>([SELECT Id, Name 
                                                FROM User 
                                                WHERE IsActive =: true]);
        ProcessInstance pi = [SELECT Id, TargetObjectId 
                              FROM ProcessInstance
                              WHERE targetobjectId = :recordID
                              ORDER BY createdDate DESC
                              LIMIT 1];
        
        for (ProcessInstanceStep pis : [SELECT ID, Comments, ActorId
                                        FROM ProcessInstanceStep 
                                        WHERE processInstanceID = :pi.Id 
                                        ORDER BY CreatedDate ASC]) {
            if (pis.comments != null && pis.comments != '') {
                approvalComments.add(usrMap.get(pis.ActorId).name + ': ' + pis.Comments);
            }
        }
    }
}