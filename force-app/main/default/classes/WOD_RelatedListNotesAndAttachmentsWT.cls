public class WOD_RelatedListNotesAndAttachmentsWT {
    
    public String parentId{get; set;}
    public String objClaim {get; set;}
    public List<WOD_NoteAndAttachmentHelper.NoteAndAttachmentDetails> Records {get; set;}   
    
    
    public WOD_RelatedListNotesAndAttachmentsWT(ApexPages.StandardController controller){
        Records = new List<WOD_NoteAndAttachmentHelper.NoteAndAttachmentDetails>();
        WOD_Warranty_Transfer__c Record = (	WOD_Warranty_Transfer__c) controller.getRecord();        
        WOD_Warranty_Transfer__c wt = [Select Id, Name from WOD_Warranty_Transfer__c where Id=:Record.Id];
        parentId = String.valueOf(Record.Id).substring(0, 15);
        objClaim = parentId+','+wt.Name;
        
        Records = WOD_NoteAndAttachmentHelper.getAllNotesAndAttachments(Record.Id); 
    }   
}