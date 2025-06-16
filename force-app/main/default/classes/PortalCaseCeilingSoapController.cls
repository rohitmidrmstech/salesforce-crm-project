/****************************************************************************************
* @Author       Satyajit Chanda/Gopi Ravoori
* @Date         Feb 16, 2018
* @Description  This class created for the protal case project, to integrate salesfore with Hybris using middleware SAP PO.
                The apex class expossing as soap webservices, and SAP PO invoking the web service and mapping the salesforce
                case fields with portal case fields. Case created from salesforce going back to portal and case created from 
                portal coming back to salesforce.
*               Kondal # 1/18/2019 # Field has been updated.
*****************************************************************************************/
global with sharing class PortalCaseCeilingSoapController {
        
     /****************************************************************************************
     * @Author       Satyajit Chanda/Gopi Ravoori
     * @Date         Feb 16, 2018
     * @Description  Inner class that holds fields for the case Response sending back to PO and Hybris.
     * * @Modified By Gopi Ravoori
     * @Date Mar 05,2018
     * @7/18/2018 Gopi Ravoori added contactID filter.
     * @Version History : Added Service Closed,Quality Closed,Pricing Closed,Portal Closed 
     *****************************************************************************************/
        global with sharing class CaseDetails{
            webservice ID CaseID; //Id
            webservice String CaseNumber;//CaseNumber
            webservice String PortalCaseId; //PortalCaseId__c
            webservice String CaseType;//RecordType.Name           
            webservice String InvoiceNumber;//JDE_Order_Number__r.Invoice_Number__c
            webservice String Division;//Account.LOB__c
            webservice String LineItemsandProductNotes;//Order_Line_Items__c
            webservice String AdditionalContactName;//SuppliedName
            webservice String AdditionalContactEmail;//SuppliedEmail
            webservice String AdditionalContactPhoneNumber;//SuppliedPhone
            webservice String ReportedByName;//Contact.Name
            webservice String ReportedPersonPhNo;//Contact.Phone
            webservice String ReportedPersonEmail;//Contact.Email
            webservice String IssueType;//Issue_Problem__c
            webservice String Subject;//Subject
            webservice String CaseDescription;//Descriptions
            webservice String SoldToNo;//SoldTo //JDE_Order_Number__r.Sold_To__r.JDE_Customer_Number__c
            webservice String ShipToNo;//JDE_Order_Number__r.Ship_To__r.JDE_Customer_Number__c
            webservice String BillToNo;//JDE_Order_Number__r.Sold_To__r.JDE_Customer_Number__c
            webservice String CustomerPoNumber;//JDE_Order_Number__r.ponumber
            webservice String InvoiceName;//JDE_Order_Number__r.Invoice_Number__c
            webservice String SAPOrderID;//JDE_Order_Number__r.JDE_Order_Number__c
            webservice String CaseStatus;//Status
            webservice DateTime CaseCreatedDate;//CreatedDate
            Webservice String CaseReason;//Reason
            webservice List<CaseCommentDetail> CaseComments;
        }
       /****************************************************************************************
         * @Author       Satyajit Chanda/Gopi Ravoori
         * @Date         Feb 16, 2018
         * @Description  Inner class that holds fields for the case comment Response sending back to PO and Hybris.
     *****************************************************************************************/
        global with sharing class CaseCommentDetail{
            webservice Id CommentsId;//Id
            webservice String CaseParentId;//ParentId
            webservice Boolean isPublic;//IsPublished
            webservice DateTime NotesAddedDate;//CreatedDate
            webservice String ContactNamewhoaddedNotes;//CreatedBy.Name
            webservice String Notes; //CommentBody        
            
        }
        /**
        * @method      : getPortalCases()
        * @return      : List<CaseDetails>
        * @description : Gets an case details and all of the related case comments.
        */ 
        webservice static List<CaseDetails> getPortalCases() {
            List<CaseDetails> CaseDetailsList = new List<CaseDetails>();
                        
            Datetime fourHourBack = Datetime.now().addHours(-4);
            Datetime thirtyMinBack = Datetime.now().addMinutes(-30);
            List<Case> CaseList = [Select Id, CaseNumber, PortalCaseId__c,RecordType.Name,Status,Account.LOB__c,
                                   Order_Line_Items__c,SuppliedName,SuppliedEmail,SuppliedPhone,Contact.Name,Contact.Phone,Contact.Email,Type,Issue_Problem__c,Subject,
                                   Description,Order__r.Sold_To__r.JDE_Customer_Number__c,Order__r.Ship_To__r.JDE_Customer_Number__c,Order__r.Account.JDE_Customer_Number__c, 
                                   Order__r.PONumber,Order__r.Order_Num__c,Order__r.Invoice__c,
                                   CreatedDate,LastModifiedDate,Reason, Origin,CreatedBy.Name,ContactId, (
                                       Select Id, ParentId, IsPublished, CreatedDate,  CreatedBy.Name, CommentBody 
                                       From CaseComments where CreatedBy.Name != 'CTIT Ceilings Integration User' AND IsPublished = true AND (Lastmodifieddate >= :fourHourBack OR CreatedDate >= :fourHourBack))                                   
                                   FROM CASE WHERE Order__c != null AND ContactId != null AND PortalCaseId__c != null AND RecordType.Name IN ('Portal', 'Pricing', 'Service', 'Quality','Service Closed','Quality Closed','Pricing Closed','Portal Closed') AND (Lastmodifieddate >= :fourHourBack OR CreatedDate >= :fourHourBack)];   
                                   //Service, Pricing, quality,portal,Service Closed,Quality Closed,Pricing Closed and Portal Closed case's sending back to hybris. 
 
            CaseDetails caseDetails;
            List<CaseCommentDetail> caseCommentDetailList;
            CaseCommentDetail caseCmtDetais;
            //Retriving the list of cases and map into the inner class.
            for(Case cs : CaseList){
                caseDetails = new CaseDetails();
                caseDetails.CaseID = cs.id;
                caseDetails.CaseNumber = cs.CaseNumber;
                caseDetails.PortalCaseId = cs.PortalCaseId__c;
                caseDetails.CaseType = cs.RecordType.Name;
                caseDetails.InvoiceNumber = cs.Order__r.Invoice__c;
                caseDetails.Division = cs.Account.LOB__c; 
                caseDetails.LineItemsandProductNotes= cs.Order_Line_Items__c;
                caseDetails.AdditionalContactName = cs.SuppliedName;
                caseDetails.AdditionalContactEmail = cs.SuppliedEmail;
                caseDetails.AdditionalContactPhoneNumber = cs.SuppliedPhone;
                caseDetails.ReportedByName = cs.Contact.Name;
                caseDetails.ReportedPersonPhNo =cs.Contact.Phone;
                caseDetails.ReportedPersonEmail = cs.Contact.Email;               
                caseDetails.IssueType = cs.Issue_Problem__c;
                caseDetails.Subject = cs.Subject;
                //description field sending back to portal(hybris) created by 'Integration User'.
                if(cs.Origin == 'Portal' && cs.CreatedBy.Name == 'CTIT Ceilings Integration User'){                    
                    caseDetails.CaseDescription = cs.Description;
                }
                //Sending blank for non 'Integration User'.
                else {
                    caseDetails.CaseDescription = '';                   
                }
                
                caseDetails.CaseStatus = cs.Status;
                caseDetails.CaseCreatedDate = cs.CreatedDate;
                caseDetails.SoldToNo = cs.Order__r.Sold_To__r.JDE_Customer_Number__c;
                
                //ShipToNo is not null set Order lookup (Ship_To) account number.
                if(caseDetails.ShipToNo != null && caseDetails.ShipToNo !=''){
                    caseDetails.ShipToNo = cs.Order__r.Ship_To__r.JDE_Customer_Number__c;
                }//ShipToNo is null set SoldTo account number.
                else{
                    caseDetails.ShipToNo= cs.Order__r.Sold_To__r.JDE_Customer_Number__c;
                }
                //set the BillTo Parent account Number.
                //caseDetails.BillToNo = cs.JDE_Order_Number__r.Payer_Name__r.JDE_Customer_Number__c;
                
                caseDetails.CustomerPoNumber = cs.Order__r.PONumber;
                caseDetails.InvoiceName = cs.Order__r.Invoice__c;
                caseDetails.SAPOrderID = cs.Order__r.Order_Num__c;
                caseDetails.CaseReason = cs.Reason;
                 //fetching the case comments from case.
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