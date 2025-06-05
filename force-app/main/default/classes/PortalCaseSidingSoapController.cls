/*
Author : Satyajit Chanda
Class: Portal_Case_Soap_Controller
Description : This is the SOAP web services class to integrate Hybris to Salesforce.
Modification : 
Modified By : Rakesh Bandi/Satyajit Chanda/Gopi 
1. Added ispublished = true and CreadtedBy.Name at Case comments
2. added createdDate in Case level.
3. Last four hours case record should fetch logic implemented on 9/12/2017
*/

global with sharing class PortalCaseSidingSoapController{

     global with sharing class CaseDetails{
      webservice ID CaseID; //Id
      webservice String CaseNumber;//CaseNumber
      webservice String PortalCaseId; //PortalCaseId__c
      webservice String CaseType;//RecordType.Name
//      webservice String CaseResolution;//Resolution__c
      webservice String InvoiceNumber;//Order__r.Invoice_Number__c
      webservice String Division;//Account.Sales_Org__c
      webservice String ProductNotes;//Order_Line_Items__c
      webservice String AdditionalContactName;//SuppliedName
      webservice String AdditionalContactEmail;//SuppliedEmail
      webservice String AdditionalContactPhoneNumber;//SuppliedPhone
      webservice String ReportedByName;//Contact.Name
      webservice String ReportedPersonPhNo;//Contact.Phone
      webservice String ReportedPersonEmail;//Contact.Email
      webservice String IssueType;//Type
      webservice String Subject;//Subject
      webservice String CaseDescription;//Description
      webservice String AccountNo;//SoldTo //Order__r.Account__r.Account_Number__c
      webservice String ShipToNo;//Order__r.Ship_To_No__r.Account_Number__c
      webservice String BillToNo;//Order__r.Account__r.Parent.Account_Number__c
      webservice String CustomerPoNumber;//Order__r.Customer_PO__c
      webservice String InvoiceName;//Order__r.Invoice__r.Name
      webservice String BPCSOrderID;//Order__r.Order_No__c
      webservice String CaseStatus;//Status
      webservice DateTime CaseCreatedDate;//CreatedDate
      Webservice String CaseReason;//Reason
      webservice List<CaseCommentDetail> CaseComments;
      }
      
      global with sharing class CaseCommentDetail{
        webservice Id CommentsId;//Id
        webservice String CaseParentId;//ParentId
        webservice Boolean isPublic;//IsPublished
        webservice DateTime NotesAddedDate;//CreatedDate
        webservice String ContactNamewhoaddedNotes;//CreatedBy.Name
        webservice String Notes; //CommentBody        
        
    }
     
    webService static List<CaseDetails> getPortalCases() {
        List<CaseDetails> CaseDetailsList = new List<CaseDetails>();
        Map<Id,Case> CaseMap = new Map<Id,Case>();
        Set<Id> OrderIdSet = new Set<Id>();
        
        Datetime fourHourBack = Datetime.now().addHours(-4);
        List<Case> CaseList = [Select Id, CaseNumber, PortalCaseId__c,RecordType.Name,Status,Order__r.Invoice_Number__c,Account.LOB__c,
                                Order_Line_Items__c,SuppliedName,SuppliedEmail,SuppliedPhone,Contact.Name,Contact.Phone,Contact.Email,Type,Subject,
                                Description,Order__r.Sold_To__r.SAP_ACCOUNT__c,Order__r.Ship_To__r.SAP_ACCOUNT__c,Order__r.Sold_To__r.Parent.SAP_ACCOUNT__c,Order__r.PONumber,Order__r.Invoice__r.Name,
                                Order__r.Order_Num__c,CreatedDate,LastModifiedDate,Reason, Origin,CreatedBy.Name, (
                                Select Id, ParentId, IsPublished, CreatedDate,  CreatedBy.Name, CommentBody 
                                From CaseComments where CreatedBy.Name != 'CTIT Siding Integration User' AND IsPublished = true AND (Lastmodifieddate >= :fourHourBack OR CreatedDate >= :fourHourBack) )
                                FROM CASE 
                                //WHERE Order__c != null AND (Lastmodifieddate = TODAY OR CreatedDate = TODAY)];
                                WHERE Order__c != null AND (Lastmodifieddate >= :fourHourBack OR CreatedDate >= :fourHourBack)];
        
        for(Case cs : CaseList){
            CaseMap.put(cs.id,cs);
            OrderIdSet.add(cs.Order__c);
        }
        
        CaseDetails caseDetails;
        List<CaseCommentDetail> caseCommentDetailList;
        CaseCommentDetail caseCmtDetais;
        
        for(Case cs : CaseList){
            caseDetails = new CaseDetails();
            caseDetails.CaseID = cs.id;
            caseDetails.CaseNumber = cs.CaseNumber;
            caseDetails.PortalCaseId = cs.PortalCaseId__c;
            caseDetails.CaseType = cs.RecordType.Name;
            //caseDetails.CaseResolution = cs.Resolution__c;
            caseDetails.InvoiceNumber = cs.Order__r.Invoice_Number__c;
            caseDetails.Division = cs.Account.LOB__c; 
            caseDetails.ProductNotes = cs.Order_Line_Items__c;
            caseDetails.AdditionalContactName = cs.SuppliedName;
            caseDetails.AdditionalContactEmail = cs.SuppliedEmail;
            caseDetails.AdditionalContactPhoneNumber = cs.SuppliedPhone;
            caseDetails.ReportedByName = cs.Contact.Name;
            caseDetails.ReportedPersonPhNo =cs.Contact.Phone;
            caseDetails.ReportedPersonEmail = cs.Contact.Email;
            caseDetails.IssueType = cs.Type;
            caseDetails.Subject = cs.Subject;
            
            if(cs.Origin == 'Portal' && cs.CreatedBy.Name == 'CTIT Siding Integration User'){
                caseDetails.CaseDescription = cs.Description;
            }
            else {
                caseDetails.CaseDescription = '';
            }
            
            caseDetails.CaseStatus = cs.Status;
            caseDetails.CaseCreatedDate = cs.CreatedDate;
            caseDetails.AccountNo = cs.Order__r.Sold_To__r.SAP_ACCOUNT__c;//SoldTo
            //caseDetails.ShipToNo = cs.Order__r.Ship_To_No__r.Account_Number__c;//ShipTo
            //caseDetails.BillToNo = cs.Order__r.Bill_To_No__r.Account_Number__c;//Bill to
            
            //ShipToNo is not null set Order lookup (Ship_To_No__c) account number.
            if(caseDetails.ShipToNo != null && caseDetails.ShipToNo !=''){
                caseDetails.ShipToNo = cs.Order__r.Ship_To__r.SAP_ACCOUNT__c;
            }//ShipToNo is null set SoldTo account number.
            else{
                caseDetails.ShipToNo= cs.Order__r.Sold_To__r.SAP_ACCOUNT__c;
            }
            //set the BillTo Parent account Number.
            caseDetails.BillToNo = cs.Order__r.Sold_To__r.Parent.SAP_ACCOUNT__c;
            
            caseDetails.CustomerPoNumber = cs.Order__r.PONumber;
            caseDetails.InvoiceName = cs.Order__r.Invoice__r.Name;
            caseDetails.BPCSOrderID = cs.Order__r.Order_Num__c;
            caseDetails.CaseReason = cs.Reason;

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
                                        
                    caseCommentDetailList.add(caseCmtDetais);
                }
            }            
            caseDetails.CaseComments = caseCommentDetailList;
            
      
            CaseDetailsList.add(caseDetails);  
        }
        return CaseDetailsList;
    }

  }