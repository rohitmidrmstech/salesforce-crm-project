public class WOD_RelatedListNotesAndAttachmentsWR {
    
    public String parentId{get; set;}
    public String objClaim {get; set;}
    public List<WOD_NoteAndAttachmentHelper.NoteAndAttachmentDetails> Records {get; set;}   
    
    
    public WOD_RelatedListNotesAndAttachmentsWR(ApexPages.StandardController controller){
        Records = new List<WOD_NoteAndAttachmentHelper.NoteAndAttachmentDetails>();
        WOD_2__Warranty_Registration__c Record = (WOD_2__Warranty_Registration__c) controller.getRecord();        
        WOD_2__Warranty_Registration__c wr = [Select Id, Name from WOD_2__Warranty_Registration__c where Id=:Record.Id];
        parentId = String.valueOf(Record.Id).substring(0, 15);
        objClaim = parentId+','+wr.Name;
        
        Records = WOD_NoteAndAttachmentHelper.getAllNotesAndAttachments(Record.Id);  
    }  
}