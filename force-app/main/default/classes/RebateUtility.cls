public with sharing class RebateUtility {
    public static final String REBATE_CLAIM_SOURCE_SUBMITTED_BY_BACK_OFFICE= 'Submitted by Back Office';
    public static final String REBATE_CLAIM_SOURCE_INITIATED_BY_BACK_OFFICE= 'Initiated by Back Office';
    public static final string REBATE_CLAIM_SOURCE_DISTRIBUTOR = 'Submitted by Distributor';
    public static final string REBATE_CLAIM_HEADER_STSTUS_SUBMITTED = 'Submitted';
    public static final string REBATE_CLAIM_HEADER_STSTUS_EXCEPTION_SUBMITTED = 'Exception Submitted';
    public static final string REBATE_CLAIM_HEADER_STSTUS_DRAFT = 'Draft';
    public static final string REBATE_PROGRAM_MEMBER_STATUS_ACTIVE = 'Active';
    public static final string REBATE_PROGRAM_MEMBER_STATUS_INACTIVE = 'Inactive';
    public static final String SHARING_ACCESS_LEVEL_EDIT = 'edit';
    public static final String SHARING_ACCESS_LEVEL_READ = 'read';
    public static final String REBATE_PROGRAM_MEMBER_PAYOUT_STATUS_CALCULATION_IN_PROGRESS = 'Interim';
    public static final String REBATE_CLAIMS_STATUS_PAYOUT_COMPLETED = 'Payout Completed';
    public static final string DEFAULT_CCB_CP_BSP_REBATE_CLAIM_OWNER_Name = 'CTSFDC CertainTeed';
    public static final String USD_CURRENCY = 'USD';
    public static final String CAD_CURRENCY = 'CAD';
    public static final string REBATE_CLAIM_HEADER_STATUS_QA_IN_PROGRESS = 'QA In Progress';
    public static final string REBATE_CLAIM_HEADER_STATUS_AUDIT_1 = 'Audit 1';
    public static final string REBATE_CLAIM_HEADER_STATUS_QA_COMPLETED = 'QA Completed'; 
    public static final string REBATE_CLAIM_HEADER_STATUS_INCOMPLETE = 'Incomplete';    
    public static boolean creatingContentDocumentLink = false;
    public static final string NOT_ELIGIBLE_CURRENT_YEAR = 'Not eligible for current year';
    public static final string CLAIM_REVIEW_NEEDED = 'Review Needed';
    public static final string CLAIM_REVIEW_DONE = 'Review Done';
    public static final string REBATE_PROGRAM_US = 'US';
    public static final string REBATE_PROGRAM_CANADA = 'CAN';
    


    public static void asscoaiteFilesToRecord(String recordId, List<RebateUtility.FileWrapper> files){
        creatingContentDocumentLink = true;
        List<ContentDocumentLink> contentDocumentLinksToCreate = new List<ContentDocumentLink>();
        Set<Id> documentsALreadyLinked = new Set<Id>();
        for(ContentDocumentLink cdl: [Select Id,ContentDocumentId from ContentDocumentLink where LinkedEntityId =: recordId]){
            documentsALreadyLinked.add(cdl.ContentDocumentId);
        }
        
        for(FileWrapper fileWrapper: files){
            if(fileWrapper.contentDocumentLinkId == null && !documentsALreadyLinked.contains(fileWrapper.documentId)){
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.LinkedEntityId = recordId;
                cdl.ContentDocumentId = fileWrapper.documentId;
                cdl.ShareType = 'V';
                contentDocumentLinksToCreate.add(cdl);
            }
        }
        if(!contentDocumentLinksToCreate.isEmpty()){
            insert contentDocumentLinksToCreate;
        }
        creatingContentDocumentLink = false;
    }  

    public static Contact getRebateContact(String contactId){
        //rebate created on behalf of customer
        if(String.isNotBlank(contactId)){
            return [Select Id,AccountId,  BIR_Eligibility__c, CCB_Eligibility__c, BSP_Eligibility__c, Change_Pay_Eligibility__c, Distributor__c From Contact where Id =: contactId];
        }
        //rebate created by an experiance user
        else{
            return [Select Id, AccountId,  BIR_Eligibility__c, CCB_Eligibility__c, BSP_Eligibility__c, Change_Pay_Eligibility__c, Distributor__c From Contact Where Id IN (Select ContactId From User Where Id = :UserInfo.getUserId())];
        }
    }

    public static Boolean isUserMemberOfAccountTeam(Id accountId, List<String> teamMemberRoles, Id userId){
        if([Select count() from AccountTeamMember where AccountId =: accountId and UserId =: userId and TeamMemberRole in: teamMemberRoles] > 0){
            return true;
        }
        else{
            return false;
        }
    }

    public static List<RebateUtility.FileWrapper> getFilesList(Id recordId){
        List<RebateUtility.FileWrapper> fileList = new List<RebateUtility.FileWrapper>();
        for(ContentDocumentLink cdl:[Select Id, ContentDocumentId, ContentDocument.Title, ContentDocument.FileExtension 
                                        from ContentDocumentLink where LinkedEntityId =: recordId]){
            RebateUtility.FileWrapper file = new RebateUtility.FileWrapper();
            file.contentDocumentLinkId = cdl.Id;
            file.documentId = cdl.ContentDocumentId;
            file.name = cdl.ContentDocument.Title + '.' + cdl.ContentDocument.FileExtension;
            fileList.add(file);
        }
        return fileList;
    }

    public class FileWrapper {
        public string name;
        public string documentId;
        public String contentVersionId;
        public string contentBodyId;
        public string mimeType;
        public string contentDocumentLinkId;
    }
}