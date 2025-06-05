public with sharing class CCBClaimFormController {
    public static final string CCB_PROGRAM_IDENTIFIER = 'CCB';
    // Added BP_PROGRAM_IDENTIFIER for the BP Canada CCB.
    public static final string BP_PROGRAM_IDENTIFIER = 'BP';
    public static final string CCB_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME = 'CCB';
    public static final string CCB_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME = 'CCB';
    public static final string CP_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME = 'CP';
    public static final string CP_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME = 'CP';
    public static final string CP_PROGRAM_IDENTIFIER = 'CP';
    public static final string CCB_DISTRIBUTOR_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME = 'CCB_Distributor_Claim';

    @AuraEnabled
    //Added selected program as a new parameter to differentiate the "BP" programMember
    public static Rebate_claim__C  upsertCCBRebate(List<RebateClaim> claimItems, String claimYear, string filesJSON, string contactId, boolean exceptionYear, string rebateClaimId, boolean saveOnly, string program,string selectedProgram) {
        try{
            boolean isSubmitted = true;
            if(saveOnly != null && saveOnly){
                isSubmitted = false;
            }
            //create Rebate claim
            Contact rebateContact = RebateUtility.getRebateContact(contactId);
            System.debug('upsertCCBRebate==>'+selectedProgram);
           // Added one AND Condition as "programSubTypeName" into RebateProgramMember query to return the right program member related to the program.
           // if selectedProgram is "BP" then return the rebateProgramMember specific to that RebateProgram.
            String programSubTypeName='';
            if(selectedProgram == BP_PROGRAM_IDENTIFIER){
               programSubTypeName=selectedProgram;
            }
           Id rpmId = [Select id From RebateProgramMember Where Contact__c = :rebateContact.Id 
                          And RebateProgram.Status =: salesAgreementProductsFormController.STATUS_ACTIVE 
                          And MemberStatus =: RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE 
                          And RebateProgram.Rebate_Program_Type__c =:program 
                          And RebateProgram.Program_Active_Year__c = :claimYear
                          And RebateProgram.Rebate_Program_Sub_Type__c =:programSubTypeName
                          order by Createddate Desc limit 1].Id;
            
            system.debug('rpmId==>'+rpmId);
            Rebate_claim__C rebateClaim = new Rebate_claim__C();
            if(String.isNotBlank(rebateClaimId)){
                rebateClaim.Id = rebateClaimId;
            }
            rebateClaim.RecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(program).getRecordTypeId(); 
            rebateClaim.Submitted_By__c = rebateContact.Id;
            rebateClaim.Rebate_Program_Member__c = rpmId; 
            if(exceptionYear != null && exceptionYear == true){
                rebateClaim.Claim_Exception__c = true;
            }
            //save only logic
            if(!isSubmitted){
                //status is not updated on save after original record creation
                if(String.isBlank(rebateClaimId)){
                    rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_DRAFT;
                }
            }                      
            
            //set source only on new Claims
            if(String.isNotBlank(contactId) && String.isBlank(rebateClaimId)){
                rebateClaim.Submission_Source__c = RebateUtility.REBATE_CLAIM_SOURCE_SUBMITTED_BY_BACK_OFFICE;
            }
            upsert rebateClaim;         


            //create rebate claim items
                    System.debug('claimItem==>'+ claimItems);       
            for(RebateClaim claimItem: claimItems){
                claimItem.ClaimAmount = 0;
                claimItem.RecordTypeId =  Schema.SObjectType.RebateClaim.getRecordTypeInfosByDeveloperName().get(program).getRecordTypeId(); 
                claimItem.Rebate_Claim__c = rebateClaim.Id;
                
            }
            upsert claimItems;

            if(String.isNotBlank(rebateClaimId)){
                //delete removed Claim Items
                delete [Select Id from RebateClaim where Id not in: claimItems and Rebate_Claim__c =: rebateClaim.Id];
            }

            //associate files to rebate claim
            if(String.isNotBlank(filesJSON)){
                List<RebateUtility.FileWrapper> files = (List<RebateUtility.FileWrapper>)JSON.deserialize(filesJSON, List<RebateUtility.FileWrapper>.Class);
                RebateUtility.asscoaiteFilesToRecord(rebateClaim.Id , files);
            }     
            
            //submitted only logic
            if(isSubmitted){
                rebateClaim.Submit_Date__c = Date.today();  
                if(rebateClaim.Claim_Exception__c){
                    rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_EXCEPTION_SUBMITTED;
                }
                else{
                    rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_SUBMITTED;
                }
                upsert rebateClaim;
            }

            return [Select Id,name from Rebate_claim__C where Id =:rebateClaim.Id][0];
        }
        catch(Exception ex){
            system.debug('error 98:'+ex.getMessage() + 'Line number' + ex.getLineNumber());
            throw new AuraHandledException('Error Creating Contractor Cash Back Rebate: '+ ex.getMessage());
        }
    }
   // Added variable "rebateProgramSubType" to return the identifier for the BP Program.
    public class CCBInitilizationDataWrapper {
        public String 	rebateClaimId;
        public String 	rebateProgramSubType;
        public String 	submittedByContactId;
        public List<InvoiceWrapper> invoices;
        public List<RebateUtility.FileWrapper> files;
    }

    public class InvoiceWrapper {
        public String invoiceNumber;
        public Date invoiceDate;
        public List<ProductWrapper> products;
    }

    public class ProductWrapper {
        public String businessUnitName;
        public String categoryName;
        public String productId;
        public Decimal quantity;
        public String uom;
        public String rebateClaimItemId;
    }
   
    @AuraEnabled
    public static string getInitializationData(String rebateClaimId) {

        try {
            // Added RebateProgramSubType in Query to identify the RebateProgram Specific data is loading for the "BP" program  in edit Claim form.
            Rebate_claim__C rebateClaim = [Select Id, Submitted_By__c,Rebate_Program_Member__r.RebateProgram.Rebate_Program_Sub_Type__c from Rebate_claim__c	where Id =:	rebateClaimId];
            System.debug('getInitializationData rebateClaim==>'+rebateClaim);
            //initialize wrapper
            CCBInitilizationDataWrapper initializationData = new CCBInitilizationDataWrapper();
            initializationData.rebateClaimId = rebateClaim.Id;
            initializationData.rebateProgramSubType=rebateClaim.Rebate_Program_Member__r.RebateProgram.Rebate_Program_Sub_Type__c;
             System.debug('  initializationData.rebateProgramSubType==>'+  initializationData.rebateProgramSubType);
            initializationData.submittedByContactId = rebateClaim.Submitted_By__c;
            initializationData.invoices = new List<InvoiceWrapper>();

            //initializete invoice wrapper
            InvoiceWrapper invoiceWrapper = new InvoiceWrapper();
            invoiceWrapper.products = new List<ProductWrapper>();

            //create rebate claim items
            for (RebateClaim claimItem: [Select Id, Rebate_Claim__c, Invoice_Number__c, ClaimDate, ProductId,Quantity, Unit_Of_Measure_Selected__c, 
                                        Product.Product_Category__c , Business_Units__r.Name
                                        from RebateClaim
                                        where Rebate_Claim__c =: rebateClaim.Id
                                        order by Invoice_Number__c, ClaimDate]) {

                if (invoiceWrapper.invoiceNumber != claimItem.Invoice_Number__c && invoiceWrapper.invoiceDate != claimItem.ClaimDate) {

                    if (invoiceWrapper.invoiceNumber !=	null) {
                        //add current invoice to list
                        initializationData.invoices.add(invoiceWrapper);

                        //initilize new Invoice wrapper
                        invoiceWrapper =  new InvoiceWrapper();

                        invoiceWrapper.products = new List<ProductWrapper>();
                    }

                }

                invoiceWrapper.invoiceDate = claimItem.ClaimDate.date();
                invoiceWrapper.invoiceNumber = claimItem.Invoice_Number__c;
                ProductWrapper pWrapper = new ProductWrapper();
                pWrapper.rebateClaimItemId = claimItem.Id;
                pWrapper.businessUnitName = claimItem.Business_Units__r.Name;
                pWrapper.categoryName = claimItem.Product.Product_Category__c;
                pWrapper.productId = claimItem.ProductId;
                pWrapper.quantity = ClaimItem.Quantity;
                pWrapper.uom = claimItem.Unit_Of_Measure_Selected__c;
                invoiceWrapper.products.add(pWrapper);
            }

            //add last invoice wrapper
            initializationData.invoices.add(invoiceWrapper);

            //add files to wrapper
            initializationData.files = RebateUtility.getFilesList(rebateClaimId);
              System.debug('initializationData==>'+initializationData);
            return JSON.serialize(initializationData);
        } catch (Exception ex) {
            throw new AuraHandledException('Error Generating Contractor Cash Back Rebate Initialization data: ' + ex.getMessage());
        }
    }

    @AuraEnabled
    public static Rebate_claim__C  createDistributorRebate(string filesJSON, string contactId) {
        try{
            //create Rebate claim
            System.debug('contactId==>'+contactId);
            Contact rebateContact = RebateUtility.getRebateContact(contactId);                
            System.debug('rebateContact==>'+rebateContact);
            Rebate_claim__C rebateClaim = new Rebate_claim__C();
            rebateClaim.RecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(CCB_DISTRIBUTOR_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
            rebateClaim.Submitted_By__c = rebateContact.Id;
            rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_SUBMITTED;
            rebateClaim.Submit_Date__c = Date.today(); 
            rebateClaim.Submission_Source__c = RebateUtility.REBATE_CLAIM_SOURCE_DISTRIBUTOR;        
            insert rebateClaim;                    

            //associate files to rebate claim
            if(String.isNotBlank(filesJSON)){
                List<RebateUtility.FileWrapper> files = (List<RebateUtility.FileWrapper>)JSON.deserialize(filesJSON, List<RebateUtility.FileWrapper>.Class);
                RebateUtility.asscoaiteFilesToRecord(rebateClaim.Id , files);
            }            

            return [Select Id,name from Rebate_claim__C where Id =:rebateClaim.Id][0];
        }
        catch(Exception ex){
            throw new AuraHandledException('Error Creating CCB Distributor Rebate: '+ ex.getMessage());
        }
    }
    
    //Lou Bui 2-29-2024 Added method for chanage request => CHG1247122 - RebateClaimItem Duplicate Invoices
    @AuraEnabled
    public static string getDuplicateData(String rebateClaimId) {

        try {

            Rebate_claim__C rebateClaim = [Select Id, Submitted_By__c,Submitted_By__r.AccountId from Rebate_claim__c where Id =:rebateClaimId];

            //initialize wrapper
            CCBInitilizationDataWrapper initializationData = new CCBInitilizationDataWrapper();
            initializationData.rebateClaimId = rebateClaim.Id;
            initializationData.submittedByContactId = rebateClaim.Submitted_By__c;
            initializationData.invoices = new List<InvoiceWrapper>();

            //initializete invoice wrapper
            InvoiceWrapper invoiceWrapper = new InvoiceWrapper();
            invoiceWrapper.products = new List<ProductWrapper>();
            
            Set<String> currentClaimUniqueInvoice = new set<String>();

            List<RebateClaim> claimItemCurrentClaim = [Select Invoice_Number__c,ClaimDate from RebateClaim where Rebate_Claim__c =: rebateClaim.Id];
            List<RebateClaim> acctInvoiceHistory = new List<RebateClaim>();
            
            for (RebateClaim r: claimItemCurrentClaim){
                Date invoiceDate = Date.ValueOf(r.ClaimDate);
                currentClaimUniqueInvoice.add(r.Invoice_Number__c + invoiceDate);
                //system.debug('r.Invoice_Number__c + r.ClaimDate => ' + r.Invoice_Number__c + r.ClaimDate);
            }
            
           List<RebateClaim> currentClaimItems = [Select  Id, Rebate_Claim__c, Invoice_Number__c, ClaimDate, ProductId,Quantity, Unit_Of_Measure_Selected__c, 
                                        Product.Product_Category__c , Business_Units__r.Name,Rebate_Claim__r.Submitted_By__r.AccountId from RebateClaim where Rebate_Claim__r.Submitted_By__r.AccountId =: rebateClaim.Submitted_By__r.AccountId];
           
            for(RebateClaim r: currentClaimItems){
                Date invoiceDate = Date.ValueOf(r.ClaimDate);
                String invoiceMatchKey = r.Invoice_Number__c + invoiceDate;
                //system.debug('invoiceMatchKey => ' + invoiceMatchKey);
                //system.debug('currentClaimUniqueInvoice => ' + currentClaimUniqueInvoice);
                if(currentClaimUniqueInvoice.contains(invoiceMatchKey)){
                    acctInvoiceHistory.add(r);
                }
            }
             //system.debug('acctInvoiceHistory Count => ' + acctInvoiceHistory.size());
			 //system.debug('acctInvoiceHistory => ' + acctInvoiceHistory);
            //create rebate claim items
            for (RebateClaim claimItem: acctInvoiceHistory) {
                
                if (invoiceWrapper.invoiceNumber != claimItem.Invoice_Number__c && invoiceWrapper.invoiceDate != claimItem.ClaimDate) {

                    if (invoiceWrapper.invoiceNumber !=	null) {
                        //add current invoice to list
                        initializationData.invoices.add(invoiceWrapper);

                        //initilize new Invoice wrapper
                        invoiceWrapper =  new InvoiceWrapper();

                        invoiceWrapper.products = new List<ProductWrapper>();
                    }

                }

                invoiceWrapper.invoiceDate = claimItem.ClaimDate.date();
                invoiceWrapper.invoiceNumber = claimItem.Invoice_Number__c;
                ProductWrapper pWrapper = new ProductWrapper();
                pWrapper.rebateClaimItemId = claimItem.Id;
                pWrapper.businessUnitName = claimItem.Business_Units__r.Name;
                pWrapper.categoryName = claimItem.Product.Product_Category__c;
                pWrapper.productId = claimItem.ProductId;
                pWrapper.quantity = ClaimItem.Quantity;
                pWrapper.uom = claimItem.Unit_Of_Measure_Selected__c;
                invoiceWrapper.products.add(pWrapper);
            }

            //add last invoice wrapper
            initializationData.invoices.add(invoiceWrapper);
			//system.debug(' initializationData.invoices => ' +  initializationData.invoices);
            //add files to wrapper
            initializationData.files = RebateUtility.getFilesList(rebateClaimId);
            return JSON.serialize(initializationData);
        } catch (Exception ex) {
            throw new AuraHandledException('Error Generating Contractor Cash Back Rebate Initialization data: ' + ex.getMessage());
        }
    }
    
}