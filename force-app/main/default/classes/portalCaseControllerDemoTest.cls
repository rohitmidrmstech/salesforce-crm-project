@istest
public class portalCaseControllerDemoTest {
    
    class CaseDetails{
        ID CaseID; 
        String CaseNumber;
        String PortalCaseId; 
        String CaseStatus; 
        DateTime CaseCreatedDate;
        List<CaseCommentDetail> CaseComments;
        
    }
    class CaseCommentDetail{
        Id CommentsId;
        String CaseParentId;
        Boolean isPublic;
        DateTime NotesAddedDate;
        String ContactNamewhoaddedNotes;
        String Notes;         
        
    }
    
    public static testMethod void testgetPortalCases(){
        
        Case cObj = new Case();
        cObj.PortalCaseId__c = 'TestPortalCaseId';
        cObj.SuppliedName = 'Testname';
        cObj.SuppliedEmail = 'abc@cde.com';
        cObj.SuppliedPhone = '(999) 924-5712';       
        cObj.Type = 'Order Change';
        cObj.Subject = 'Test Soap';               
        cObj.Description = 'test Sucessfull';        
        cObj.Order_Line_Items__c = 'Test Comment 1';
        //cObj.Documents__c = 'http://certainteedcustomerportal/maptest'; 
        cObj.Status = 'New';
        cObj.Origin ='Portal';
        cObj.Priority ='Medium';
        //cObj.RecordTypeId = '0128H000000BgtmQAC'; - Full Sandbox RecordId
        cObj.RecordTypeId = '0123w000001YepPAAS';
        INSERT cObj;
          
        CaseComment caseComment = new CaseComment();
        caseComment.IsPublished = true;
        caseComment.CommentBody = 'Test';
        caseComment.ParentId = cObj.id;  
        INSERT caseComment;
        
        List<CaseDetails> CaseDetailsList = new List<CaseDetails>();
        
        List<Case> CaseList = [SELECT Id, PortalCaseId__c, CreatedById,RecordType.Name,Status,
                               CreatedDate,LastModifiedDate,Origin, CaseNumber, CreatedBy.Name,
                               (SELECT Id, ParentId, IsPublished, CreatedDate,  CreatedBy.Name, CommentBody
                                FROM CaseComments)
                               FROM CASE
                               WHERE Id = :cObj.id LIMIT 1];
        
        CaseDetails caseDetails;
        List<CaseCommentDetail> caseCommentDetailList;
        CaseCommentDetail caseCmtDetais;
        system.debug('CaseList.size=>' + CaseList.size());
        if(CaseList.size() > 0) {
            for(Case cs : CaseList){
                caseDetails = new CaseDetails();
                caseDetails.CaseID = cs.id;
                caseDetails.CaseNumber = cs.CaseNumber;
                caseDetails.PortalCaseId = cs.PortalCaseId__c;
                caseDetails.CaseStatus = cs.status;
                caseDetails.CaseCreatedDate = cs.CreatedDate;
                
                caseCommentDetailList = new List<CaseCommentDetail>();
                system.debug('cs.CaseComments=>' + cs.CaseComments);
                system.debug('cs.CaseComments.size() =>' + cs.CaseComments.size());
                
              if(cs.CaseComments != null){
               for(CaseComment csCmt : cs.CaseComments){             
                        caseCmtDetais = new CaseCommentDetail();
                        caseCmtDetais.CommentsId = csCmt.Id;
                        caseCmtDetais.CaseParentId = csCmt.ParentId;
                        caseCmtDetais.isPublic = csCmt.IsPublished;
                        caseCmtDetais.NotesAddedDate = csCmt.CreatedDate;
                        caseCmtDetais.ContactNamewhoaddedNotes = csCmt.CreatedBy.Name;
                        caseCmtDetais.Notes = csCmt.CommentBody;
                        caseCmtDetais.NotesAddedDate = csCmt.CreatedDate;
                        caseCmtDetais.ContactNamewhoaddedNotes = csCmt.CreatedBy.Name;                   
                        caseCommentDetailList.add(caseCmtDetais);
                    }
                    
                    CaseDetailsList.add(caseDetails);
                    caseDetails.CaseComments = caseCommentDetailList; 
                }     
                
                Test.startTest();
                portalCaseControllerDemo.getPortalCases();
                Test.stopTest();
            }     
        }
    }
    
}