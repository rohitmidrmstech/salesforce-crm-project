public class WOD_NoteAndAttachmentHelper {
    
    public class NoteAndAttachmentDetails   
    {  
        public String recordId{get; set;}
        public String CreatedDate {get; set;} 
        public string Title {get; set;} 
        public string Type {get; set;} 
        public String createdById{get;Set;}
        public String createdByName{get;Set;}
        public String versionId{get;set;}
    }  
    
    
    public static List<NoteAndAttachmentDetails> getAllNotesAndAttachments(Id recordId)
    {
        List<NoteAndAttachmentDetails> Records = new List<NoteAndAttachmentDetails>();              
        List<NoteAndAttachmentDetails> recordSet = new List<NoteAndAttachmentDetails>();
        List<NoteAndAttachmentDetails> recordSet2 = new List<NoteAndAttachmentDetails>();
        List<DateTime> recordsDateTime = new List<DateTime>();
        
        List<Attachment> lstAttachment = [select Id, IsDeleted, ParentId, Name, IsPrivate, ContentType, BodyLength, Body, OwnerId, CreatedDate, CreatedById, CreatedBy.Name, LastModifiedDate, LastModifiedById, SystemModstamp, Description
                                          from Attachment where parentId =:recordId];
        
        List<Note> lstNote = [select Id, IsDeleted, ParentId, Title, IsPrivate, Body, OwnerId, CreatedDate, CreatedById, CreatedBy.Name, LastModifiedDate, LastModifiedById, SystemModstamp
                              from Note where parentId =:recordId];
        
        List<ContentDocumentLink> lstContentDocumentLink = [select Id, LinkedEntityId,ContentDocument.Title, ContentDocument.CreatedDate, ContentDocument.CreatedById, ContentDocument.CreatedBy.Name, ContentDocumentId, ContentDocument.LatestPublishedVersionId, IsDeleted, SystemModstamp, ShareType, Visibility
                                                            from ContentDocumentLink where ContentDocument.FileType != 'SNOTE' and LinkedEntityId =:recordId];
        
        
        List<ContentDocumentLink> lstContentDocumentLinkNote = [select Id, LinkedEntityId,ContentDocument.Title, ContentDocument.CreatedDate, ContentDocument.CreatedById, ContentDocument.CreatedBy.Name, ContentDocumentId, IsDeleted, SystemModstamp, ShareType, Visibility
                                                                from ContentDocumentLink where LinkedEntityId = :recordId and ContentDocument.FileType = 'SNOTE'];
        
        
        for(ContentDocumentLink n: lstContentDocumentLinkNote)
        {
            NoteAndAttachmentDetails detail = new NoteAndAttachmentDetails();
            detail.recordId = n.ContentDocumentId;
            detail.CreatedDate = String.valueOf(n.ContentDocument.CreatedDate);
            detail.createdById = n.ContentDocument.CreatedById;
            detail.createdByName = n.ContentDocument.CreatedBy.Name;
            detail.Title = n.ContentDocument.Title;
            detail.Type = 'Note';
            recordSet.add(detail);
            recordsDateTime.add(DateTime.valueOf(detail.CreatedDate));
        } 
        
        for(ContentDocumentLink n: lstContentDocumentLink)
        {
            NoteAndAttachmentDetails detail = new NoteAndAttachmentDetails();
            detail.recordId = String.valueOf(n.ContentDocumentId).substring(0, 15);
            detail.CreatedDate = String.valueOf(n.ContentDocument.CreatedDate);
            detail.createdById = n.ContentDocument.CreatedById;
            detail.createdByName = n.ContentDocument.CreatedBy.Name;
            detail.Title = n.ContentDocument.Title;
            detail.versionId = String.valueOf(n.ContentDocument.LatestPublishedVersionId).substring(0, 15);
            detail.Type = 'File';
            recordSet.add(detail);
            recordsDateTime.add(DateTime.valueOf(detail.CreatedDate));
        } 
        
        for(Attachment a: lstAttachment)
        {
            NoteAndAttachmentDetails detail = new NoteAndAttachmentDetails();
            detail.recordId = a.Id; //CT - Prod
            detail.CreatedDate = String.valueOf(a.CreatedDate);
            detail.createdById = a.CreatedById;
            detail.createdByName = a.CreatedBy.Name;
            detail.Title = a.Name;
            detail.Type = 'Attachment';
            recordSet.add(detail);
            recordsDateTime.add(DateTime.valueOf(detail.CreatedDate));
        }    
        
        for(Note n: lstNote)
        {
            NoteAndAttachmentDetails detail = new NoteAndAttachmentDetails();
            detail.recordId = n.Id;
            detail.CreatedDate = String.valueOf(n.CreatedDate);
            detail.createdById = n.CreatedById;
            detail.createdByName = n.CreatedBy.Name;
            detail.Title = n.Title;
            detail.Type = 'Note';
            recordSet.add(detail);
            recordsDateTime.add(DateTime.valueOf(detail.CreatedDate));
        } 
        recordsDateTime.sort();
        for(DateTime dt : recordsDateTime){
            for(NoteAndAttachmentDetails attachments : recordSet){
                if(!attachments.CreatedDate.contains('/')){
                    if(dt == DateTime.valueOf(attachments.CreatedDate)){
                        attachments.CreatedDate = DateTime.valueOf(attachments.CreatedDate).format('M/d/yyy h:mm a', UserInfo.getTimeZone().getID());
                        System.debug('Date>>'+attachments.CreatedDate);
                        recordSet2.add(attachments);
                    }
                }
            }
        }
        System.debug('recordSet2 size>>'+recordSet2.size()+' & recordSet size>>'+recordSet.size());
        for(Integer i=1; i <= recordSet2.size(); i++){
            Records.add(recordSet2[recordSet2.size()-i]);
        }
        system.debug('*****Records' + Records);   
        
        return Records;
    }
}