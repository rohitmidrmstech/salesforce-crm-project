public class WOD_RelatedListNotesAttachmentInspection {
    
    public String parentId{get; set;}
    public String objClaim {get; set;}
    public List<WOD_NoteAndAttachmentHelper.NoteAndAttachmentDetails> Records {get; set;}   
    
    
    public WOD_RelatedListNotesAttachmentInspection(ApexPages.StandardController controller){
        Records = new List<WOD_NoteAndAttachmentHelper.NoteAndAttachmentDetails>();
        WOD_Inspection__c Record = (WOD_Inspection__c) controller.getRecord();        
        WOD_Inspection__c inspection = [Select Id, Name from WOD_Inspection__c where Id=:Record.Id];
        parentId = String.valueOf(Record.Id).substring(0, 15);
        objClaim = parentId+','+inspection.Name;
        
        Records = WOD_NoteAndAttachmentHelper.getAllNotesAndAttachments(Record.Id);  
    }    
}