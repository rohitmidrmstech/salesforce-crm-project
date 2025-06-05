/****************************************************************************************
* @Author       Satyajit Chanda/Gopi Ravoori
* @Date         Feb 16, 2018
* @Description  This class created for the protal case project, to integrate salesfore with Hybris using middleware SAP PO.
                The apex class expossing as soap webservices, and SAP PO invoking the web service and mapping the salesforce
                case fields with portal case fields. Case created from salesforce going back to portal and case created from 
                portal coming back to salesforce.
*****************************************************************************************/
global with sharing class PortalCaseGypsumSoapController {
     /****************************************************************************************
     * @Author       Satyajit Chanda/Gopi Ravoori
     * @Date         Feb 16, 2018
     * @Description  Inner class and fields exposing as a webservices that holds fields for the case 
     *               Response sending back to PO and Hybris.
     *****************************************************************************************/
     global with sharing class CaseDetails{
      webservice ID CaseID; //Id
      webservice String CaseNumber;//CaseNumber
      webservice String PortalCaseId; //PortalCaseId__c
      webservice String CaseType;//RecordType.Name      
      webservice String InvoiceNumber;//Order__r.Invoice__r.Name
      webservice String Division;//Account.LOB__c
      webservice String LineItemsandProductNotes;//Order_Line_Items__c
      webservice String AdditionalContactName;//SuppliedName
      webservice String AdditionalContactEmail;//SuppliedEmail
      webservice String AdditionalContactPhoneNumber;//SuppliedPhone
      webservice String ReportedByName;//Contact.Name
      webservice String ReportedPersonPhNo;//Contact.Phone
      webservice String ReportedPersonEmail;//Contact.Email
      webservice String IssueType;//Issues__c.Problem__c
      webservice String Subject;//Subject
      webservice String CaseDescription;//Description
      webservice String SoldToNo;//SoldTo //Order__r.Sold_To__r.SAP_ACCOUNT__c
      webservice String ShipToNo;//Order__r.Ship_To__r.SAP_ACCOUNT__c
      webservice String BillToNo;//Order__r.Sold_To__r.Parent.SAP_ACCOUNT__c
      webservice String CustomerPoNumber;//Order__r.PoNumber
      webservice String InvoiceName;//Order__r.Invoice__r.Name
      webservice String SAPOrderID;//Order__r.Order_Num__c
      webservice String CaseStatus;//Status
      webservice DateTime CaseCreatedDate;//CreatedDate
      Webservice String CaseReason;//Reason
      webservice List<CaseCommentDetail> CaseComments;
      }
      
    /****************************************************************************************
     * @Author       Satyajit Chanda/Gopi Ravoori
     * @Date         Feb 16, 2018
     * @Description  Inner class and fields exposing as a webservices that holds fields for the 
     *               case comment Response sending back to PO and Hybris.
     *****************************************************************************************/
      global with sharing class CaseCommentDetail{
        webservice Id CommentsId;//Id
        webservice String CaseParentId;//ParentId
        webservice Boolean isPublic;//IsPublished
        webservice DateTime NotesAddedDate;//CreatedDate
        webservice String ContactNamewhoaddedNotes;//CreatedBy.Name
        webservice String Notes; //CommentBody        
        
    }
    global with sharing class CaseLineItemDetail{
      webservice id OrderLineItemId;
      webservice String Products;//Product_Received__r.Name
      webservice Integer QTYAffected;//csLineItem.Quantity_Received__c
      webservice Integer QTYShipped;//csLineItem.Quantity_Ordered__c
      webservice String LineItemNo;//Item_Number__c
      webservice String Description;//Product_Ordered__r.Description
      webservice String Name;//Product_Ordered__r.Name
      webservice String ProductNote;//Product_Notes__c
    } 

    /**
    * @method      : getPortalCases()
    * @return      : List<CaseDetails>
    * @description : method exposing as a webservices to get the case details and all of the related case comments.
    */ 
    webservice static List<CaseDetails> getPortalCases() {
        List<CaseDetails> CaseDetailsList = new List<CaseDetails>();
        // last four hours case.       
        Datetime fourHourBack = Datetime.now().addHours(-4);
        
        List<Case> CaseList = [SELECT Id, CaseNumber, PortalCaseId__c, SuppliedName, SuppliedEmail, SuppliedPhone, Contact.Name, Contact.Phone, Contact.Email, Resolution__c, Type, Subject, CreatedById,RecordType.Name,Status,Order__r.Invoice_Number__c,
                Account.LOB__c, Order_Line_Items__c,Documents__c,
                Description,Order__r.Sold_To__r.SAP_ACCOUNT__c,Order__r.Ship_To__r.SAP_ACCOUNT__c,Order__r.Sold_To__r.Parent.SAP_ACCOUNT__c,
                Order__r.PO_Number__c,Order__r.Invoice__r.Name, Order__r.Order_Num__c,
                CreatedDate,LastModifiedDate,Reason, Origin,CreatedBy.Name,Order__r.PoNumber,
                (SELECT Id, ParentId, IsPublished, CreatedDate,  CreatedBy.Name, CommentBody
                FROM CaseComments WHERE CreatedBy.Name != 'CTIT Gypsum Integration User' AND CreatedBy.Name != 'CTIT Siding Integration User' AND CreatedBy.Name != 'Integration User' 
                AND IsPublished = true AND (Lastmodifieddate >= :fourHourBack OR CreatedDate >= :fourHourBack)),
                (SELECT Id, Name, Problem__c FROM Issues__r order by Name ASC limit 1)
                FROM CASE
                WHERE
                Order__c != null AND ContactId != null AND
                PortalCaseId__c != null AND
                (Lastmodifieddate >= :fourHourBack OR CreatedDate >= :fourHourBack) AND
                //((Order__r.Sales_Org__c IN ('1003', '1101') AND Portal_Subject__c!= 'Internal Service Case' AND (RecordType.Name='Service Case' OR Origin='Portal'))
                //OR (Order__r.Sales_Org__c IN ('1006', '1100') AND
                ((Order__r.Sales_Org__c IN ('1006', '1100') AND Portal_Subject__c!= 'Internal Service Case' AND (RecordType.Name='Service Case' OR Origin='Portal'))
                OR (Order__r.Sales_Org__c IN ('1003', '1101') 
                AND RecordType.Name IN ('Portal', 'Pricing', 'Service', 'Quality'))
                
                OR (Order__r.Sales_Org__c IN ('1502') 
                /*AND RecordType.Name IN ('Portal', 'Pricing', 'Service', 'Quality')*/ 
                OR (Order__r.Sales_Org__c IN ('1501','1102') AND RecordType.Name != 'General Case')))];
                                                                     
        CaseDetails caseDetails;
        List<CaseCommentDetail> caseCommentDetailList;
        CaseCommentDetail caseCmtDetais;
        //List<Issues__c> listIssue;
        //Retriving the list of cases and map into the inner class.
        if(CaseList.size() > 0) {
        for(Case cs : CaseList){
            caseDetails = new CaseDetails();
            caseDetails.CaseID = cs.id;
            caseDetails.CaseNumber = cs.CaseNumber;
            caseDetails.PortalCaseId = cs.PortalCaseId__c;
            caseDetails.CaseType = cs.RecordType.Name;            
            caseDetails.InvoiceNumber = cs.Order__r.Invoice__r.Name;
            caseDetails.Division = cs.Account.LOB__c; 
            caseDetails.LineItemsandProductNotes= cs.Order_Line_Items__c;
            caseDetails.AdditionalContactName = cs.SuppliedName;
            caseDetails.AdditionalContactEmail = cs.SuppliedEmail;
            caseDetails.AdditionalContactPhoneNumber = cs.SuppliedPhone;
            caseDetails.ReportedByName = cs.Contact.Name;
            caseDetails.ReportedPersonPhNo =cs.Contact.Phone;
            caseDetails.ReportedPersonEmail = cs.Contact.Email;
            caseDetails.ShipToNo = cs.Order__r.Ship_To__r.SAP_ACCOUNT__c;
            caseDetails.IssueType = cs.Type;                     
            caseDetails.Subject = cs.Subject;
            
            //description field sending back to portal(hybris) created by 'Integration User'.
            if(cs.Origin == 'Portal' && (cs.CreatedBy.Name == 'CTIT Gypsum Integration User' ||
              cs.CreatedBy.Name == 'CTIT Siding Integration User' || cs.CreatedBy.Name == 'Integration User')){
                caseDetails.CaseDescription = cs.Description;
            }
            //Sending blank for non 'Integration User', Hybris handling the null value for description field.
            else {
                caseDetails.CaseDescription = '';
            }
            
            caseDetails.CaseStatus = cs.Status;
            caseDetails.CaseCreatedDate = cs.CreatedDate;
            caseDetails.SoldToNo = cs.Order__r.Sold_To__r.SAP_ACCOUNT__c;
            
           
            //ShipToNo is not null set Order lookup (Ship_To__c) account number.
            if(caseDetails.ShipToNo != null && caseDetails.ShipToNo !=''){
                caseDetails.ShipToNo = cs.Order__r.Ship_To__r.SAP_ACCOUNT__c;
            }//ShipToNo is null set SoldTo account number.
            else{
                caseDetails.ShipToNo= cs.Order__r.Sold_To__r.SAP_ACCOUNT__c;
            }
            //set the BillTo as Sold_To__c Parent account Number.
            caseDetails.BillToNo = cs.Order__r.Sold_To__r.Parent.SAP_ACCOUNT__c;
            
            caseDetails.CustomerPoNumber = cs.Order__r.PoNumber;
            caseDetails.InvoiceName = cs.Order__r.Invoice__r.Name;
            caseDetails.SAPOrderID = cs.Order__r.Order_Num__c;
            caseDetails.CaseReason = cs.Reason;
            // retriving the case comments from case.
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
            } 
            caseDetails.CaseComments = caseCommentDetailList; 
            //Inbound case => case created in hybris (Hybris->SFDC),  Hybris (IssueType) map with salesforce (Case.Type__c).
            //Outbound case => case created in salesforce (SFDC->Hybris), salesforce (Issues__c.Problem__c) map with Hybris (IssueType).
            //if multiple issues exist in the case , Sending the first record. if there are no Issues__c sending blank.
            
            for(Issues__c issue : cs.Issues__r){
                if(issue.Problem__c != null){
                    caseDetails.IssueType = issue.Problem__c;                     
                }else{
                    caseDetails.IssueType = '';
                }                
                                                                                         
             }
           
            CaseDetailsList.add(caseDetails);  
        }
    }
        return CaseDetailsList;
    }

}