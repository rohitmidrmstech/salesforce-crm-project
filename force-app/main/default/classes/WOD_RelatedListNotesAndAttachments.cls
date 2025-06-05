public class WOD_RelatedListNotesAndAttachments {
    
    public String parentId{get; set;}
    public String objClaim {get; set;}
    public List<WOD_NoteAndAttachmentHelper.NoteAndAttachmentDetails> Records {get; set;}   
    
    
    public WOD_RelatedListNotesAndAttachments(ApexPages.StandardController controller){
        Records = new List<WOD_NoteAndAttachmentHelper.NoteAndAttachmentDetails>();
        WOD_2__Claim__c Record = (WOD_2__Claim__c) controller.getRecord();        
        WOD_2__Claim__c claim = [Select Id, Name from WOD_2__Claim__c where Id=:Record.Id];
        parentId = String.valueOf(Record.Id).substring(0, 15);
        objClaim = parentId+','+claim.Name;
        
        Records = WOD_NoteAndAttachmentHelper.getAllNotesAndAttachments(Record.Id); 
    }  
}