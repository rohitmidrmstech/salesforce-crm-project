/****************************************************************************************
* @Description  This class created for the protal inquiry case project, to integrate salesfore with Hybris using middleware SAP PO.
The apex class expossing as soap webservices, and SAP PO invoking the web service and mapping the salesforce
case fields with portal case fields. Case created from salesforce going back to portal and case created from 
portal coming back to salesforce.
*****************************************************************************************/
global with sharing class PortalCaseInquirySoapController {
    /****************************************************************************************
* @Description  Inner class and fields exposing as a webservices that holds fields for the case 
*               Response sending back to PO and Hybris.
*****************************************************************************************/
    global with sharing class CaseDetails{
        webservice ID CaseID; 
        webservice String CaseNumber;
        webservice String PortalCaseId; 
        webservice String CaseStatus; 
        webservice DateTime CaseCreatedDate;
        webservice List<CaseCommentDetail> CaseComments;
        
    }
    /****************************************************************************************
* @Description  Inner class and fields exposing as a webservices that holds fields for the 
*               case comment Response sending back to PO and Hybris.
*****************************************************************************************/
    global with sharing class CaseCommentDetail{
        webservice Id CommentsId;
        webservice String CaseParentId;
        webservice Boolean isPublic;
        webservice DateTime NotesAddedDate;
        webservice String ContactNamewhoaddedNotes;
        webservice String Notes;         
        
    }
    
    /**
* @method      : getPortalCases()
* @return      : List<CaseDetails>
* @description : method exposing as a webservices to get the case details and all of the related case comments.
*/ 
    webservice static List<CaseDetails> getPortalCases() {
        List<CaseDetails> CaseDetailsList = new List<CaseDetails>();
        
        Datetime fourHourBack = Datetime.now().addHours(-4);
        
        List<Case> CaseList = [SELECT Id, PortalCaseId__c, CreatedById,RecordType.Name,Status,
                               CreatedDate,LastModifiedDate,Origin, CaseNumber, CreatedBy.Name,
                               (SELECT Id, ParentId, IsPublished, CreatedDate,  CreatedBy.Name, CommentBody
                                //2-27-2023 Lou Bui: Updated From cause to new Integration User. Commented out and retired old integration users.
                                FROM CaseComments WHERE CreatedById != '005d0000005b0usAAA'
                                //FROM CaseComments WHERE CreatedBy.Name != 'CTIT Gypsum Integration User' AND CreatedBy.Name != 'CTIT Siding Integration User' AND CreatedBy.Name != 'Integration User' 
                                AND IsPublished = true AND (Lastmodifieddate >= :fourHourBack OR CreatedDate >= :fourHourBack))
                               FROM CASE
                               WHERE
                               PortalCaseId__c != null AND
                               (Lastmodifieddate >= :fourHourBack) AND (RecordType.Name='Portal Inquiry')];
        
        CaseDetails caseDetails;
        List<CaseCommentDetail> caseCommentDetailList;
        CaseCommentDetail caseCmtDetais;
        if(CaseList.size() > 0) {
            for(Case cs : CaseList){
                caseDetails = new CaseDetails();
                caseDetails.CaseID = cs.id;
                caseDetails.CaseNumber = cs.CaseNumber;
                caseDetails.PortalCaseId = cs.PortalCaseId__c;
                caseDetails.CaseStatus = cs.status;
                caseDetails.CaseCreatedDate = cs.CreatedDate;
                
                caseCommentDetailList = new List<CaseCommentDetail>();
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
                
            }
            
            system.debug('return CaseDetailsList'+ CaseDetailsList);  
            system.debug(CaseList);
            system.debug('csCmt'+caseCommentDetailList);
        }
        return CaseDetailsList;
        
        
    }
}