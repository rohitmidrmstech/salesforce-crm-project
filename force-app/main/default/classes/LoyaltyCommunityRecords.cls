public with sharing class LoyaltyCommunityRecords {
    
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getOpenClaims(){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();
        RebateClaimList = [Select ID, Name, Program_Name__c, Claim_Status__c, CreatedDate,Submitted_By_sys__c  From Rebate_Claim__c Where Claim_Status__c IN ('Incomplete', 'Draft') AND Submission_Source__c != 'Submitted by Distributor' ORDER BY CreatedDate DESC];
        return RebateClaimList;
    }
    
    @AuraEnabled
    Public Static List<Lead> getLeads(String searchType){
        List<Lead> LeadList = new List<Lead>();
        List<Lead> AllLeadList = new List<Lead>();
        List<Lead> AllAcceptedLeads = new List<Lead>();
        Map<id, Lead> AllUniqueLeadsMap = new Map<id, Lead>();
        
        List<User> UserIdList = [Select ContactId From User Where Id = :UserInfo.getUserId()];
        String UserId = UserIdList[0].id;
        String strSOQL = '';
        List<String> AcceptedLeads = new List<String>{'New','Contacted','Qualified'};
            List<String> ClosedLeads = new List<String>{'Won','Lost'};
                List<String> AllLeadStatus = new List<String>{'New','Contacted','Qualified','Won','Lost'};                      
                    
                    if(searchType == 'Open Leads'){
                        AllLeadList = GetListOfLeadsForCommHome.getLeadList();
                    }
        if(searchType == 'Accepted Lead' || searchType == 'Closed Leads'){
            strSOQL = 'Select ID, Name,OwnerId, Address,Status,CreatedDate from Lead';
            if(searchType == 'Accepted Lead'){
                strSOQL += ' Where Status IN :AcceptedLeads AND OwnerId = :UserId ORDER BY Sent_to_Community_Date__c DESC';
            }
            if(searchType == 'Closed Leads'){            
                strSOQL += ' Where Status IN :ClosedLeads AND OwnerId = :UserId ORDER BY Sent_to_Community_Date__c DESC';
            }       
            System.Debug('SOQL: ' + strSOQL);
            AllLeadList = Database.query(strSOQL); 
        }
        if(String.isBlank(searchType)){
            strSOQL = 'Select ID, Name,OwnerId, Address,Status,CreatedDate from Lead';
            strSOQL += ' Where Status IN :AllLeadStatus AND Community_User__c = :UserId ORDER BY Sent_to_Community_Date__c DESC';
            LeadList = GetListOfLeadsForCommHome.getLeadList();
            
            
            //system.debug('LeadList Size =>' + LeadList.size());
            AllAcceptedLeads = Database.query(strSOQL);
            //system.debug(' AllAcceptedLeads Size =>' +  AllAcceptedLeads.size());
            if(AllAcceptedLeads.size() > 0){
                for(Lead l:AllAcceptedLeads){
                    LeadList.Add(l);
                }
            }    
            
            for(Lead l : leadList){
                AllUniqueLeadsMap.Put(l.Id, l);
            }
            
            for(Lead l : AllUniqueLeadsMap.values()){
                AllLeadList.add(l);
            }
            
        }
        
        system.debug('Lead List Count =>' + LeadList.size());
        system.debug('Lead List =>' + LeadList);
        
        return AllLeadList;
    }
    
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getPendingClaims(){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();
        RebateClaimList = [Select ID, Name, Program_Name__c, Claim_Status__c,Status__c, Submitted_By_sys__c, CreatedDate From Rebate_Claim__c Where Claim_Status__c IN ('Submitted', 'Processing', 'Claim Approved') ORDER BY CreatedDate DESC];
        return RebateClaimList;
    }
    
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getProcessedClaims(){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();
        RebateClaimList = [Select ID, Name, Program_Name__c, Claim_Status__c,Status__c, Submitted_By_sys__c, CreatedDate,Submit_Date__c, Total_Rebate_Amount__c From Rebate_Claim__c Where Claim_Status__c = 'Payout Completed' ORDER BY CreatedDate DESC];
        return RebateClaimList;
    }
    
    @AuraEnabled
    Public Static Decimal getPaidOutAmount(){
        List<AggregateResult> groupedResults = [Select SUM(Total_Rebate_Amount__c) sumAmount From Rebate_Claim__c Where Status__c = 'Payout Completed' AND Bank_Payment_Date__c = THIS_YEAR];
        Decimal sumAmount = (Decimal)groupedResults[0].get('sumAmount');
        System.debug('Sum Of Amount: ' + sumAmount);
        Return sumAmount;
    }
    //added for lifetime paid out
    @AuraEnabled
    Public Static Decimal getLifeTimePaidOutAmount(){
        // Added by Rohit to get the date from custom label (line :94,95,96)
        String startDateLabel = Label.Bank_Payment_Date;
        Date startDate = Date.valueOf(startDateLabel);
        List<AggregateResult> groupedLifeTimeResults = [Select SUM(Total_Rebate_Amount__c) sumLifeTimeAmount From Rebate_Claim__c Where Status__c = 'Payout Completed' AND  Bank_Payment_Date__c >=:startDate ];
        // List<AggregateResult> groupedLifeTimeResults = [Select SUM(Total_Rebate_Amount__c) sumLifeTimeAmount From Rebate_Claim__c Where Status__c = 'Payout Completed' AND  Bank_Payment_Date__c >= 2023-01-01 ];
        Decimal sumLifeTimeAmount = (Decimal)groupedLifeTimeResults[0].get('sumLifeTimeAmount');
        System.debug('Sum Of Amount: ' + sumLifeTimeAmount);
        Return sumLifeTimeAmount;
    }
    
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getRebateHistory(String searchType, String searchString){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();
        String strSOQL = '';
        strSOQL = 'Select ID, Name, Program__c,Program_Name__c, Claim_Status__c,Status__c, Submit_Date__c, Submitted_By_sys__c, Total_Rebate_Amount__c,Submission_Source__c From Rebate_Claim__c';
        if(searchType == 'Claim #'){
            strSOQL += ' Where Name = \''+ searchString + '\' ' + ' ORDER BY Submit_Date__c DESC';
        }
        if(searchType == 'Status'){
            strSOQL += ' Where Claim_Status__c = \''+ searchString + '\' ' + ' ORDER BY Submit_Date__c DESC';
        }
        if(searchType == 'Invoice'){            
            strSOQL = 'Select ID, Name, Program__c,Program_Name__c, Claim_Status__c, Submit_Date__c, Submitted_By_sys__c, Total_Rebate_Amount__c,Submission_Source__c From Rebate_Claim__c where id in (select Rebate_Claim__c from RebateClaim where Invoice_Number__c = \''+ searchString + '\' ' + ') ORDER BY Submit_Date__c DESC';
            //strSOQL += ' Where Invoice_Number__c = \''+ searchString + '\' ' + ' ORDER BY Rebate_Claim__r.Submit_Date__c DESC'; 
        }       
        System.Debug('SOQL: ' + strSOQL);
        RebateClaimList = Database.query(strSOQL);       
        System.debug('List Size: ' + RebateClaimList.size());
        //if(RebateClaimList.size() >0 && searchType == 'Status' && String.isBlank(searchString)){
        if(RebateClaimList.size() >0 ){
            for(Integer index = 0; index < RebateClaimList.size(); index++)
            {
                if(RebateClaimList[index].Submission_Source__c == 'Submitted by Distributor' && RebateClaimList[index].Claim_Status__c == 'Draft'){
                    System.debug('IN condition: ');
                    RebateClaimList.remove(index);
                }
            }
        }
        System.debug('List Size After condition: ' + RebateClaimList.size());
        return RebateClaimList;
    }
    
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getRebateHistorybyDate(String searchType, String DateFrom, String DateTo){
        //Date format should be yyyy-mm-dd
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();
        String strSOQL = '';
        strSOQL = 'Select ID, Name, Program__c,Program_Name__c, Claim_Status__c,Submission_Source__c, Submit_Date__c, Submitted_By_sys__c, Total_Rebate_Amount__c From Rebate_Claim__c ';
        if(searchType == 'Date Range'){
            strSOQL += ' Where Submit_Date__c >= '+ DateFrom + ' AND Submit_Date__c <= ' + DateTo + ' ORDER BY Submit_Date__c DESC';           
        }
        System.Debug('SOQL: ' + strSOQL);
        RebateClaimList = Database.query(strSOQL);     
        System.debug('List Size: ' + RebateClaimList.size());
        if(RebateClaimList.size() >0){
            for(Integer index = 0; index < RebateClaimList.size(); index++)
            {
                if(RebateClaimList[index].Submission_Source__c == 'Submitted by Distributor' && RebateClaimList[index].Claim_Status__c == 'Draft'){
                    System.debug('IN condition: ');
                    RebateClaimList.remove(index);
                }
            }
        }
        System.debug('List Size After condition: ' + RebateClaimList.size());
        return RebateClaimList;
    }
    
    @AuraEnabled
    Public Static String getAdditionalProcessingNotes(String claimId){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();
        String AdditionalProcessingNotes = '';
        RebateClaimList = [Select ID, Additional_Processing_Notes__c From Rebate_Claim__c Where Claim_Status__c = 'Incomplete' AND Id =: claimId];
        if(RebateClaimList.size() > 0){
            AdditionalProcessingNotes = RebateClaimList[0].Additional_Processing_Notes__c;
        }
        return AdditionalProcessingNotes;
    }
    
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getClaimDetailsbyId(String claimId){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();        
        RebateClaimList = [Select ID, Name, Submit_Date__c, Program__c,Program_Name__c, Claim_Status__c From Rebate_Claim__c Where Claim_Status__c = 'Incomplete' AND Id =: claimId];
        return RebateClaimList;
    }
    
    @AuraEnabled
    Public Static List<LoyaltyProductDetails> getProductDetails(){
        List<Product2> lstProduct = new List<Product2>();
        List<LoyaltyProductDetails> lstProductDetails = new List<LoyaltyProductDetails>();
        lstProduct = [Select Id, Name, Product_Category__c,Line_Of_Business__r.Name from Product2 WHERE RecordTypeId = '0123w000001YemLAAS' AND Line_Of_Business__c != NULL];
        if(lstProduct.size() > 0){
            for(Product2 p : lstProduct){
                LoyaltyProductDetails pd = new LoyaltyProductDetails();
                pd.Name = p.Name;
                pd.Category = p.Product_Category__c;
                pd.LineOfBusiness = p.Line_Of_Business__r.Name;
                lstProductDetails.add(pd);
            }
        }
        //system.debug('lstProductDetails' + lstProductDetails[0]);
        return lstProductDetails;
        
    }
    
    //Wrapper Class for LoyaltyProductDetails for combined claim items and proof of purchase file download links.
    public class LoyaltyProductDetails {
        public String Name;
        public String Category;
        public String LineOfBusiness; 
        public List<ContentDocument> FileDetails;
        public List<ContentVersion> FileDownloadDetails;
    }
    
    //Class to store file detials.
    public class LoyaltyFileDetails {
        public String FileName;
        public String ProgramName;
        public String UploadDate;
        public String SubmittedBy;
    }
    
    @AuraEnabled
    Public Static Date getMovedToIncompleteDate(String claimId){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();        
        Date MovedToIncompleteDate = null;
        RebateClaimList = [Select ID, Moved_to_Incomplete_Date__c From Rebate_Claim__c Where Claim_Status__c = 'Incomplete' AND Id =: claimId];
        if(RebateClaimList.size() > 0){
            MovedToIncompleteDate = (RebateClaimList[0].Moved_to_Incomplete_Date__c).addDays(30);
        }
        Return MovedToIncompleteDate;
    }
    
    //Created method on 11/04/2023
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getRebateClaimDetails(String claimId){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();        
        RebateClaimList = [select Id,Name,Program_Name__c,Claim_Status__c,Submit_Date__c, Submitted_By_sys__c,Total_Rebate_Amount__c from Rebate_Claim__c where Id =: claimId];
        Return RebateClaimList;
    }
    
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getClaimNamebyId(String claimId){
        List<Rebate_Claim__c> RebateClaimList = new List<Rebate_Claim__c>();        
        RebateClaimList = [Select ID, Name, Submit_Date__c, Program__c,Program_Name__c, Claim_Status__c From Rebate_Claim__c Where Id =: claimId];
        return RebateClaimList;
    }
    //Created method on 11/04/2023
    //Note - ContentSize is the size of document in bytes.
    @AuraEnabled
    Public Static List<ContentDocument> getRebateClaimFileDetails(String claimId){
        List<ContentDocumentLink> documentLinkList = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId =: claimId];
        set<id> docIdSet = new set<id>();
        for(ContentDocumentLink doc: documentLinkList){
            docIdSet.add(doc.ContentDocumentId);
        }
        List<ContentDocument> documentList  = [select Id, CreatedById, CreatedDate, OwnerId,Owner.Name, Title, LatestPublishedVersionId, ParentId, Description, ContentSize,
                                               FileType, FileExtension, SharingOption from ContentDocument where Id IN : docIdSet];
        system.debug(documentList);
        Return documentList; 
    }
    /* LB 06-13-2023 Old method, not used, is replaced with getRebateClaimFileDownload2
@AuraEnabled
Public Static List<ContentVersion> getRebateClaimFileDownload(String latestPublishedVersionId){
List<ContentVersion> documentLinkList = [Select VersionDataUrl FROM ContentVersion Where ContentDocument.LatestPublishedVersionId =:latestPublishedVersionId];
system.debug('documentLinkList =>' + documentLinkList);
Return documentLinkList; 
}
*/
    @AuraEnabled
    Public Static List<ContentVersion> getRebateClaimFileDownload2(String ContentDocumentId ){
        List<ContentVersion> documentLinkList = [SELECT VersionDataUrl FROM ContentVersion WHERE ContentDocumentId = :ContentDocumentId AND IsLatest = true];
        system.debug('documentLinkList =>' + documentLinkList);
        Return documentLinkList; 
    }
    //Created Method on 14/04/2023
    //Note - filteration of record
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getFilterRebateClaimDetailCCB(string ClaimNumber, string InvoiceNumber, string ClaimStatus, string InvoiceDatefrom, string InvoiceDateto){
        List<RebateClaim> ClaimIdsfromChildList = new List<RebateClaim>();
        Map<String, RebateClaim> MapClaimIds = new Map<String, RebateClaim>(); 
        List<Rebate_Claim__c> ClaimList = new List<Rebate_Claim__c>();        
        
        String dynamicHelper = 'Select Id, Name, Program_Name__c, Claim_Status__c, Submit_Date__c, claim_From__c, claim_To__c, Submitted_By_sys__c, Total_Rebate_Amount__c,Submission_Source__c from Rebate_Claim__c';        
        if(!String.isBlank(InvoiceNumber) || !String.isBlank(InvoiceDatefrom) || !String.isBlank(InvoiceDateto)){
            String dynamicHelperChild = 'Select Id, Rebate_Claim__r.Id from RebateClaim';
            dynamicHelperChild+=' Where Rebate_Claim__r.Id != null And ';
            if(!String.isBlank(InvoiceNumber)){
                dynamicHelperChild+= 'Invoice_Number__c LIKE \'%'+InvoiceNumber+'\' And ';
            }
            if(!String.isBlank(InvoiceDatefrom)){
                dynamicHelperChild+= 'ClaimDate >= '+InvoiceDatefrom+'T00:00:00Z'+' And ';
            }
            if(!String.isBlank(InvoiceDateto)){
                dynamicHelperChild+= 'ClaimDate <= '+InvoiceDateto+'T23:59:59Z'+' And ';
            }
            dynamicHelperChild = dynamicHelperChild.removeEnd(' And ');
            system.debug('dynamicHelperChild : '+dynamicHelperChild);
            ClaimIdsfromChildList = database.query(dynamicHelperChild);
            
        }
        if(ClaimIdsfromChildList.size() == 0 && ((!String.isBlank(InvoiceNumber)) || (!String.isBlank(InvoiceDatefrom)) ||(!String.isBlank(InvoiceDateto))))
        {
            system.debug('ClaimList : '+ClaimList);
            return ClaimList; 
        }
        else{
            if(ClaimIdsfromChildList.size() > 0 || !String.isBlank(ClaimNumber) || !String.isBlank(ClaimStatus)){
                dynamicHelper+=' Where ';
            }
            if(ClaimIdsfromChildList.size() > 0){ 
                List<String> ClaimIds = new List<String>();            
                for(RebateClaim rbclaim : ClaimIdsfromChildList){                
                    ClaimIds.add('\'' + rbclaim.Rebate_Claim__r.Id + '\'');                 
                }
                System.Debug('ClaimIds: ' + ClaimIds);        
                System.Debug('ClaimIds Size: ' + ClaimIds.size());    
                dynamicHelper+= 'ID IN '+ '('  +(String.join(ClaimIds,','))+  ')  And ';  
                System.Debug('Main SOQL: ' + dynamicHelper);
            }
            if(!String.isBlank(ClaimNumber)){
                dynamicHelper+= 'Name LIKE \'%'+ClaimNumber+'\' And ';
            }
            if(!String.isBlank(ClaimStatus)){ 
                dynamicHelper+= 'Claim_Status__c = \''+ClaimStatus+'\' And ';
            }
            dynamicHelper = dynamicHelper.removeEnd(' And ');
            system.debug('dynamicHelper : '+dynamicHelper);
            ClaimList = database.query(dynamicHelper);
            System.debug('List Size: ' + ClaimList.size());
            //if(ClaimList.size() >0 && String.isBlank(ClaimStatus)){
            if(ClaimList.size() >0){
                for(Integer index = 0; index < ClaimList.size(); index++)
                {
                    if(ClaimList[index].Submission_Source__c == 'Submitted by Distributor' && ClaimList[index].Claim_Status__c == 'Draft'){
                        System.debug('IN condition: ');
                        ClaimList.remove(index);
                    }
                }
            }
            System.debug('List Size After condition: ' + ClaimList.size());
            return ClaimList; 
        }
        
    }
    
    
    @AuraEnabled
    Public Static List<Rebate_Claim__c> getFilterRebateClaimDetailBSP(string ClaimNumber, string ClaimStatus, string SubmitDatefrom, string SubmitDateto){
        List<Rebate_Claim__c> ClaimList = new List<Rebate_Claim__c>();
        string Qr;
        
        //All search fields populated.
        Qr = 'SELECT Name, Submission_Source__c,Claim_Status__c,Submit_Date__c,Submitted_By_sys__c, Program_Name__c from Rebate_Claim__c where ';
        if(!String.isBlank(ClaimNumber) && !String.isBlank(ClaimStatus) && !String.isBlank(SubmitDatefrom) && !String.isBlank(SubmitDateto)){
            Qr += '(Name LIKE \'%'+ClaimNumber+'\') AND (Claim_Status__c = \''+ ClaimStatus + '\' ) AND Submit_Date__c >= '+ SubmitDatefrom + ' AND Submit_Date__c <= '+ SubmitDateto + '';
        }
        //Claim Status empty. All other fields are populated.
        else if(!String.isBlank(ClaimNumber) && String.isBlank(ClaimStatus) && !String.isBlank(SubmitDatefrom) && !String.isBlank(SubmitDateto)){
            Qr += '(Name LIKE \'%'+ClaimNumber+'\') AND Submit_Date__c >= '+ SubmitDatefrom + ' AND Submit_Date__c <= '+ SubmitDateto + '';
        }
        //Claim Number empty. All other fields are populated.
        else if(String.isBlank(ClaimNumber) && !String.isBlank(ClaimStatus) && !String.isBlank(SubmitDatefrom) && !String.isBlank(SubmitDateto)){
            Qr += '(Claim_Status__c = \''+ ClaimStatus + '\') AND Submit_Date__c >= '+ SubmitDatefrom + ' AND Submit_Date__c <= '+ SubmitDateto + '';
        }
        //Claim Status and Claim Nubmer empty. All other fields are populated.
        else if(!String.isBlank(SubmitDatefrom) && !String.isBlank(SubmitDateto) && String.isBlank(ClaimNumber) && String.isBlank(ClaimStatus)){
            Qr += '(Submit_Date__c >= '+ SubmitDatefrom + ' AND Submit_Date__c <= '+ SubmitDateto + ')';
        }
        //Claim Submitted Date From and To is empty. All other fields are populated.
        else if(!String.isBlank(ClaimNumber) && !String.isBlank(ClaimStatus)){
            Qr += '(Name LIKE \'%'+ClaimNumber+'\') AND (Claim_Status__c = \''+ ClaimStatus + '\' )';
        }
        //Only Claim Number is populated.
        else if(!String.isBlank(ClaimNumber)){
            Qr += '(Name LIKE \'%'+ClaimNumber+'\' )';
        }
        //Only Claim Status is populated.
        else if(!String.isBlank(ClaimStatus)){
            Qr += '(Claim_Status__c = \''+ ClaimStatus + '\' )';
        }
        //No condition matched.
        else{
            return ClaimList;
        }
        
        system.debug('Query =>' + Qr );
        ClaimList = database.query(Qr);
        system.debug('ClaimList =>' + ClaimList );
        
        System.debug('List Size: ' + ClaimList.size());
        if(ClaimList.size() >0 && String.isBlank(ClaimStatus)){
            for(Integer index = 0; index < ClaimList.size(); index++)
            {
                if(ClaimList[index].Submission_Source__c == 'Submitted by Distributor' && ClaimList[index].Claim_Status__c == 'Draft'){
                    System.debug('IN condition: ');
                    ClaimList.remove(index);
                }
            }
        }
        System.debug('List Size After condition: ' + ClaimList.size());
        
        return ClaimList;
        
    }
    
    @AuraEnabled
    Public Static List<RebateClaim> getRebateClaimItemDetails(String claimId){
        List<RebateClaim> RebateClaimList = new List<RebateClaim>();   
        RebateClaimList = [Select Id,Rebate_Claim__r.Status__c, Rebate_Claim__r.Claim_From__c,Rebate_Claim__r.Claim_To__c,ClaimDate,Invoice_Number__c,Business_Units__r.Name,Product.Name,Quantity,Unit_Of_Measure_Selected_Name__c, ClaimAmount, Rejected_Reason__c,Rejected__c from RebateClaim where Rebate_Claim__c =: claimId];
        Return RebateClaimList;
    }
    
    @AuraEnabled
    Public Static String getContactEligibility(string contactId){   
        List<String> lstEligibility = new List<String>();   
        String strEligibility = ''; 
        lstEligibility = salesAgreementProductsFormController.getEligibility(contactId);
        
        if(lstEligibility.contains('BSP_PROGRAM')){ 
            strEligibility = 'BSP'; 
        }   
        if(lstEligibility.contains('CCB_PROGRAM')){ 
            strEligibility = 'CCB'; 
        }   
        return strEligibility;  
    }   
    
    @AuraEnabled
    Public Static List<ClaimFileSearchWrapper> getRebateClaimFileSearch(String accountId, string FileName, string UploadDateFrom, string UploadDateTo){
        List<ClaimFileSearchWrapper> claimFileSearchWrappers = new List<ClaimFileSearchWrapper>();
        
        List<ContentDocument> documentList = new List<ContentDocument>();
        List<ContentDocumentLink> documentLinkList = [SELECT ContentDocumentId, LinkedEntityId FROM ContentDocumentLink where LinkedEntityId IN (Select Id from Rebate_Claim__c Where Submitted_By__r.AccountId =: accountId)];
        List<String> docIdSet = new List<String>();
        for(ContentDocumentLink doc: documentLinkList){
            docIdSet.add('\''+doc.ContentDocumentId+'\'');
            
        }
        system.debug('docIdSet'+docIdSet);
        if(docIdSet.size() > 0){
            string dynamicHelper = 'SELECT Id, CreatedById, CreatedDate, Owner.Name, Title, LatestPublishedVersionId, ParentId FROM ContentDocument';
            //dynamicHelper+= ' Where ID IN '+docIdSet; 
            
            //changed above line to string join 
            dynamicHelper+= ' Where ID IN '+ '('  +(String.join(docIdSet,','))+  ')'; 
            
            if(!String.isBlank(FileName)){
                dynamicHelper+= ' AND Title LIKE \'%'+FileName+'%\'';            
            }                                           
            if(!String.isBlank(UploadDateFrom)){
                dynamicHelper+= ' AND CreatedDate >= '+UploadDateFrom+'T00:00:00Z';   
            }
            if(!String.isBlank(UploadDateTo)){
                dynamicHelper+= ' AND CreatedDate <= '+UploadDateTo+'T23:59:59Z';   
            }
            System.Debug('SOQL: ' + dynamicHelper); 
            documentList = Database.Query(dynamicHelper);                
        }
        system.debug('documentList'+documentList);
        
        // Rebate_Claim__c rebateClaim = [SELECT Id,Program_Name__c From Rebate_Claim__c WHERE Id =: documentLinkList[0].LinkedEntityId];                
        Map<Id,String> mapOfProgramName = new Map<Id,String>();
        
        for(ContentDocumentLink cdocLink : documentLinkList){
            for(ContentDocument cdoc: documentList){
                if(cdoc.id == cdocLink.ContentDocumentId){
                    List<Rebate_Claim__c> rebateClaims = [SELECT Id,Program_Name__c From Rebate_Claim__c WHERE Id =: cdocLink.LinkedEntityId];
                    for(Rebate_Claim__c rebateClaim : rebateClaims){
                        mapOfProgramName.put(cdoc.id, rebateClaim.Program_Name__c);
                    }
                }
            }
        }
        
        for(ContentDocument cdoc: documentList){
            ClaimFileSearchWrapper claimFileSearchRecord   = new ClaimFileSearchWrapper();
            claimFileSearchRecord.FileName                 = cdoc.Title;
            claimFileSearchRecord.ProgramName              = mapOfProgramName.get(cdoc.Id);
            claimFileSearchRecord.CreatedDate              = cdoc.CreatedDate;
            claimFileSearchRecord.OwnerName                = cdoc.Owner.Name;
            claimFileSearchRecord.LatestPublishedVersionId = cdoc.LatestPublishedVersionId;
            claimFileSearchWrappers.add(claimFileSearchRecord);
        }
        
        System.debug('claimFileSearchWrappers'+claimFileSearchWrappers);
        Return claimFileSearchWrappers; 
    }
    
    // Wrapper class for combined data
    public class ClaimFileSearchWrapper {
        @AuraEnabled public String   FileName;
        @AuraEnabled public String   ProgramName; 
        @AuraEnabled public DateTime CreatedDate;
        @AuraEnabled public String   OwnerName;
        @AuraEnabled Public ID       LatestPublishedVersionId;
    }
    
    @AuraEnabled
    public static Boolean getContactInfo(String contactId){
        List<Contact> lstContacts = [Select Id, Distributor__c From Contact LIMIT 1];
        if(lstContacts.size() > 0){
            if(lstContacts[0].Distributor__c == 'Yes'){
                system.debug(lstContacts[0].Distributor__c);
                return True;
            }
            system.debug(lstContacts[0].Distributor__c);
            return False;
        }       
        else return False;
    }
     /**
     * User Story: LCC2025-114
     * Date          User          Change Description
     * 2025-01-08    Rohit      Added logic for user story LCC2025-114 to handle the ClaimLineItems export functionality
     *                          from the experaince cloud site UI.
     *  From (LineNumber 510-561)
   */
    public class RebateClaimWrapper {
        @AuraEnabled public String ClaimNumber;
        @AuraEnabled public String InvoiceNumber;
        @AuraEnabled public String InvoiceDate;
        @AuraEnabled public Decimal Quantity;
        @AuraEnabled public String ProductName;
        @AuraEnabled public Decimal ApprovedAmount;
        @AuraEnabled public String ContractorId;
        @AuraEnabled public String Status;
        // Constructor
        public RebateClaimWrapper(RebateClaim rebateClaim) {
            this.ClaimNumber = rebateClaim.Rebate_Claim__r.Name != null ? rebateClaim.Rebate_Claim__r.Name : '';
            this.InvoiceNumber = rebateClaim.Invoice_Number__c!=null ? rebateClaim.Invoice_Number__c :'' ;
            this.InvoiceDate = rebateClaim.ClaimDate != null ?  rebateClaim.ClaimDate.date().format():null;
            this.Quantity = rebateClaim.Quantity!=null ? rebateClaim.Quantity : 0.0 ;
            this.ProductName = rebateClaim.Product.Name!=null ? rebateClaim.Product.Name:'';
            this.ApprovedAmount = rebateClaim.Rebate_Claim__r.Total_Rebate_Amount__c !=null ? rebateClaim.Rebate_Claim__r.Total_Rebate_Amount__c : 0.0;
            this.ContractorId = rebateClaim.Rebate_Claim__r.Submitted_By__r.Contractor_ID__c != null ? rebateClaim.Rebate_Claim__r.Submitted_By__r.Contractor_ID__c : '';
            this.Status = rebateClaim.Rebate_Claim__r.Claim_Status__c != null ? rebateClaim.Rebate_Claim__r.Claim_Status__c :'';
        }
    }
    
    @AuraEnabled
    public static List<RebateClaimWrapper> getRebateClaimRelatedLineItems(List<Id> parentIds) {
        // Query LineItems related to the Rebate Claims.
        List<RebateClaim> rebateClaims;
        if(!parentIds.isEmpty()){
            rebateClaims = [
                SELECT Id,Name, Rebate_Claim__c, Rebate_Claim__r.Name,Product.Name, Product_Name__c, ClaimAmount, Quantity, Invoice_Number__c, ClaimDate,
                Rebate_Claim__r.Submitted_By__r.Contractor_ID__c, Rebate_Claim__r.Status__c, Rebate_Claim__r.Distributor_Submission__r.Name,
                Rebate_Claim__r.Claim_Status__c, Rebate_Claim__r.Submit_Date__c, Rebate_Claim__r.Submission_Source__c,Rebate_Claim__r.Total_Rebate_Amount__c
                FROM RebateClaim
                WHERE Rebate_Claim__c IN :parentIds
                ORDER BY Rebate_Claim__c
            ];
        }
        
        List<RebateClaimWrapper> wrapperList = new List<RebateClaimWrapper>();
        if(rebateClaims.size()> 0 && rebateClaims!=null){
            for (RebateClaim rebateClaim : rebateClaims) {
                wrapperList.add(new RebateClaimWrapper(rebateClaim));
            }
        }
        return wrapperList;
    }
    
    
}