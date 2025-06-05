@isTest
private class SalesAgreementProductsFormControllerTest {
    @TestSetup
    static void setupTestData(){
        Automation_Controller__c control = Automation_Controller__c.getInstance();
        control.All_Triggers_enabled__c = true;
        upsert control;
        
        RebateTestDataFactory.createCustomerUser();
    }
    
    @isTest
    static void testGetEligibilityWithBIR(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        //create sales agreement
        SalesAgreement sa= RebateTestDataFactory.initializeSalesAgreement(testUser.Contact.AccountId);
        insert sa;
        
        List<String> eligiblePrograms = salesAgreementProductsFormController.getEligibility(testUser.contactId);
        System.assert(!eligiblePrograms.isEmpty());
    }
    
    @isTest
    static void testGetEligibilityWithCCB(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert rebateProgram;       
        
        //create rebate program and members
        List<String> eligiblePrograms = salesAgreementProductsFormController.getEligibility(testUser.contactId);
        System.assert(!eligiblePrograms.isEmpty());
    }
    
    @isTest
    static void testGetEligibilityWithChangePays(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CP_PROGRAM_IDENTIFIER);
        insert rebateProgram;
        
        //create rebate program and members
        List<String> eligiblePrograms = salesAgreementProductsFormController.getEligibility(testUser.contactId);
        System.assert(!eligiblePrograms.isEmpty());
    }
    
    @isTest
    static void testGetEligibilityWithBSP(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(salesAgreementProductsFormController.BSP_PROGRAM);
        insert rebateProgram; //rebate program members are created by flow for Active contacts 
        
        //create rebate program and members
        List<String> eligiblePrograms = salesAgreementProductsFormController.getEligibility(testUser.contactId);
        System.assert(!eligiblePrograms.isEmpty());
    }
    
    @isTest
    static void testGetEligibilityWithNoPrograms(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];       
        
        //create rebate program and members
        List<String> eligiblePrograms = salesAgreementProductsFormController.getEligibility(testUser.contactId);
        System.assert(eligiblePrograms[0] == 'None');
    }
    
    @isTest
    static void testGetYearsWithBIR(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        //create sales agreement
        SalesAgreement sa= RebateTestDataFactory.initializeSalesAgreement(testUser.Contact.AccountId);
        insert sa;
        
        List<String> years = salesAgreementProductsFormController.getYears(salesAgreementProductsFormController.BIR_PROGRAM, testUser.contactId);
        System.assert(!years.isEmpty());
    }
    
    @isTest
    static void testGetYearsWithCCB(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert rebateProgram; 
        
        RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, testUser.ContactId, rebateProgram.Id);
        insert member;        
        
        List<String> years = salesAgreementProductsFormController.getYears(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER, testUser.contactId);
        System.assert(!years.isEmpty());
    }
    
    @isTest
    static void testGetYearsWithBSP(){
        Test.startTest();
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(salesAgreementProductsFormController.BSP_PROGRAM);
        insert rebateProgram; 
        
        Test.stopTest();
        
        List<String> years = salesAgreementProductsFormController.getYears(salesAgreementProductsFormController.BSP_PROGRAM, testUser.contactId);
        //System.assert(!years.isEmpty());
    }
    
    @isTest
    static void testgetExceptionWithBIR(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        //create sales agreement
        SalesAgreement sa= RebateTestDataFactory.initializeSalesAgreement(testUser.Contact.AccountId);
        insert sa;
        
        String isException = salesAgreementProductsFormController.getException(salesAgreementProductsFormController.BIR_PROGRAM,String.valueof(sa.startDate.year()), testUser.contactId);
        
        System.assert(isException == 'N');
    }
    
    @isTest
    static void testgetExceptionWithCCB(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert rebateProgram;
        
        RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, testUser.ContactId, rebateProgram.Id);
        insert member;
        
        String isException = salesAgreementProductsFormController.getException(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER,String.valueof(rebateProgram.startDate.year()), testUser.contactId);
        
        System.assert(isException == 'Y');
    }
    
    @isTest
    static void testgetExceptionWithBSP(){
        Test.startTest();
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(salesAgreementProductsFormController.BSP_PROGRAM);
        insert rebateProgram;
        
        Test.stopTest();
        
        String isException = salesAgreementProductsFormController.getException(salesAgreementProductsFormController.BSP_PROGRAM,String.valueof(rebateProgram.startDate.year()), testUser.contactId);
        
        //System.assert(isException == 'Y');
    }
    
    @isTest
    static void testgetExceptionWithNoProgram(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        String isException = salesAgreementProductsFormController.getException(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER, String.valueof(Date.Today().year()), testUser.contactId);
        
        System.assert(isException == 'N');
    }
    
    @isTest
    static void testBIRAGrrementsAndRebateClaimCreation(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        List<UnitOfMeasure> uoms = RebateTestDataFactory.initializeUoms();
        insert uoms;
        
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Id pbeId = [Select Id from PriceBookEntry where Product2Id =: testProduct.Id][0].Id;
        
        List<Product_UOM__c> puoms = RebateTestDataFactory.initalizeProductUOMS(testProduct,  uoms, salesAgreementProductsFormController.BIR_PROGRAM);
        puoms[0].Offer_Type__c = salesAgreementProductsFormController.OFFER_TYPE_MARKETING;
        puoms[1].Offer_Type__c = salesAgreementProductsFormController.OFFER_TYPE_TIER;
        puoms[1].Basis__c = salesAgreementProductsFormController.BASIS_PERCENT;
        insert puoms;
        
        //create sales agreement
        SalesAgreement sa= RebateTestDataFactory.initializeSalesAgreement(testUser.Contact.AccountId);
        insert sa;
        
        SalesAgreementProduct agreementProduct = RebateTestDataFactory.initializeSalesAgreementProduct(sa.Id, pbeId,salesAgreementProductsFormController.OFFER_TYPE_MARKETING, null);
        insert agreementProduct;
        
        NewClaimWrapper wrapper = new NewClaimWrapper();
        wrapper.program = salesAgreementProductsFormController.BIR_PROGRAM;
        wrapper.year = String.valueof(sa.StartDate.Year());
        Map<String,List<SalesAgreementProduct>> productMap = salesAgreementProductsFormController.getSalesAgreementProducts(wrapper, testUser.ContactId);
        System.assert(productMap.size() == 1);
        
        Rebate_claim__c rebateClaim = new Rebate_claim__c(Sales_Agreement__c = sa.Id);
        
        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Sales_Agreement_Product__c = agreementProduct.Id ,Quantity = 5)); 
        
        List<Rebate_claim__c>  rebateClaims = salesAgreementProductsFormController.upsertBIRRebate(new List<Rebate_claim__c>{rebateClaim}, claimItems, null, testUser.contactId, false, true);
        System.assert(rebateClaims[0].Id != null, 'Rebate claim should have been created');
        
        try {
            rebateClaims = salesAgreementProductsFormController.upsertBIRRebate(new List<Rebate_claim__c>{rebateClaim}, claimItems, null, testUser.contactId, false, false);
            System.assert(rebateClaims[0].Id != null, 'Rebate claim should have been created');
        }
        catch(Exception ex) {}
        
        List<RebateUtility.FileWrapper> fwList = new List<RebateUtility.FileWrapper>();
        RebateUtility.FileWrapper fw = new RebateUtility.FileWrapper();
        fwList.add(fw);
        
        String filesJSON = JSON.serialize(fwList);
        
        try {
            rebateClaims = salesAgreementProductsFormController.upsertBIRRebate(new List<Rebate_claim__c>{rebateClaim}, claimItems, filesJSON, testUser.contactId, false, true);
        }
        catch(Exception ex) {}
        
        String initData = salesAgreementProductsFormController.getBIRInitializationData(rebateClaims[0].Id);
        System.assert(initData != null, 'IInitialization Data Should be available');
        
        //set rebate claim to QA COmpleted Status before flagging PriceFx processed
        rebateClaims[0].Status__c = 'QA Completed';
        update rebateClaims[0];
        
        //flag BIR rebate item as processed (test RebateClaimItemTriggerHandler)
        RebateClaim claimItem = [Select Id from RebateClaim limit 1];
        claimItem.PriceFX_Processed__c = true;
        //update claimItem;
    }
    
    @isTest
    static void testGetProductCategoryGroupMap(){
        Map<String,Integer> categoryMap = salesAgreementProductsFormController.getProductCategoryGroupMap();
        System.assert(categoryMap.size() > 0, 'There should be Category Maps in Custom Metadata');
    }
    
    @isTest
    static void testIsUserEligibileToSubmitBSPRebateOnBehalfOfCustomer(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        System.assert(salesAgreementProductsFormController.isUserEligibileToSubmitBSPRebateOnBehalfOfCustomer(testUser.ContactId) == false, 'User Should not be eligible because it is not added to  account team');
    }
    
    @isTest
    static void testBSPProgramsAndRebateClaimCreation(){
        Test.startTest();
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;
        
        Business_Units__c bu = RebateTestDataFactory.initializeBusinessUnits();
        insert bu;
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(salesAgreementProductsFormController.BSP_PROGRAM);
        insert rebateProgram; 
        
        RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(testUser.Contact.AccountId, testUser.ContactId, rebateProgram.Id);
        insert member;        
        
        Rebate_claim__c rebateClaim = new Rebate_claim__c(Claim_From__c = Date.Today(), Claim_To__c = Date.Today());
        // Rebate_claim__c rebateClaim2 = new Rebate_claim__c(Claim_From__c = Date.Today(), Claim_To__c = Date.Today());
        
        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),ProductId = testProduct.Id,Quantity = 5, Business_Units__c = bu.Id)); 
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),ProductId = testProduct.Id,Quantity = 10, Business_Units__c = bu.Id)); 
        rebateClaim = salesAgreementProductsFormController.upsertBSPRebate(rebateClaim, claimItems, String.valueOf(Date.today().year()), null, testUser.contactId, false, false, false);
        //rebateClaim = salesAgreementProductsFormController.upsertBSPRebate(rebateClaim, claimItems, String.valueOf('2024'), null, testUser.contactId, false, false, false);
        //rebateClaim2 = salesAgreementProductsFormController.upsertBSPRebate(null, claimItems, String.valueOf('2024'), null, testUser.contactId, false, false, false);
        
        System.assert(rebateClaim.Id != null, 'Rebate Claim Record must be created');
        
        String initData =  salesAgreementProductsFormController.getBSPInitializationData(rebateClaim.Id);
        System.assert(initData != null, 'Init Data must be available');
        Test.stopTest();      
    }
    
    @isTest 
    static void testGetProgramRebateTypesWithBSP(){
        Test.startTest();
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;
        
        List<UnitOfMeasure> uoms = RebateTestDataFactory.initializeUoms();
        insert uoms;
        
        List<Product_UOM__c> puoms = RebateTestDataFactory.initalizeProductUOMS(testProduct,  uoms, salesAgreementProductsFormController.BSP_PROGRAM);
        insert puoms;
        
        Business_Units__c bu = RebateTestDataFactory.initializeBusinessUnits();
        insert bu;
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(salesAgreementProductsFormController.BSP_PROGRAM);
        insert rebateProgram; 
        
        Test.stopTest();
        
        ProgramRebateType programRebateType = RebateTestDataFactory.initializeProgramRebateType(bu.Id, rebateProgram.Id);
        insert programRebateType;
        
        ProgramRebateTypeBenefit benifit = RebateTestDataFactory.initializeProgramRebateTypeBenefit(programRebateType.Id, testProduct.Id);
        benifit.Product_Category__c = 'Steep Slope Roofing';
        insert benifit;
        
        NewClaimWrapper wrapper = new NewClaimWrapper();
        wrapper.program = salesAgreementProductsFormController.BSP_PROGRAM;
        wrapper.year = String.valueOf(Date.today().year());
        Map<String,List<ProgramRebateTypeBenefit>> rebateTypes = salesAgreementProductsFormController.getProgramRebateTypes(wrapper, testUser.ContactId);
    }
    @isTest 
    static void testSalesAgreementExceptions(){
        
        Test.startTest();
        try{
            salesAgreementProductsFormController.upsertBSPRebate(null,null,null,null,null,null,null,null);
            salesAgreementProductsFormController.isUserEligibileToSubmitBSPRebateOnBehalfOfCustomer(null);
            salesAgreementProductsFormController.upsertBIRRebate(null,null,null,null,null,null);
            salesAgreementProductsFormController.getBSPInitializationData('null');
            salesAgreementProductsFormController.getBIRInitializationData('null');
        }catch(Exception e){
            system.debug(e);
        }
        Test.stopTest();
        
        
    }
    @isTest
    static void testBSPProgramsAndRebateClaimCreation2(){
        Test.startTest();
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;
        
        Business_Units__c bu = RebateTestDataFactory.initializeBusinessUnits();
        insert bu;
        
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(salesAgreementProductsFormController.BSP_PROGRAM);
        insert rebateProgram; 
        
        RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(testUser.Contact.AccountId, testUser.ContactId, rebateProgram.Id);
        insert member;        
        
        Rebate_claim__c rebateClaim2 = new Rebate_claim__c(Claim_From__c = Date.Today(), Claim_To__c = Date.Today());
        
        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),ProductId = testProduct.Id,Quantity = 5, Business_Units__c = bu.Id)); 
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),ProductId = testProduct.Id,Quantity = 10, Business_Units__c = bu.Id)); 
        String jsonString = '[{\"name\":\"Sample File\",\"documentId\":\"12345abcd\",\"contentVersionId\":\"v1.0\",\"contentBodyId\":\"body1234\",\"mimeType\":\"application/pdf\",\"contentDocumentLinkId\":\"link9876\"}, {\"name\":\"Another File\",\"documentId\":\"67890efgh\",\"contentVersionId\":\"v2.0\",\"contentBodyId\":\"body5678\",\"mimeType\":\"image/jpeg\",\"contentDocumentLinkId\":\"link5432\"}]';
        
        // rebateClaim2 = salesAgreementProductsFormController.upsertBSPRebate(rebateClaim2, claimItems, String.valueOf('2024'), jsonString, testUser.contactId, false, false, false);
        rebateClaim2 = salesAgreementProductsFormController.upsertBSPRebate(rebateClaim2, claimItems,  String.valueOf(Date.today().year()), jsonString, testUser.contactId, false, false, false);
        
        //System.assert(rebateClaim.Id != null, 'Rebate Claim Record must be created');
        
        //String initData =  salesAgreementProductsFormController.getBSPInitializationData(rebateClaim.Id);
        //System.assert(initData != null, 'Init Data must be available');
        Test.stopTest();      
    }
    // Test method for getProgramRebateTypes
    @isTest
    public static void testGetProgramRebateTypes() {
        
        // 1. Setup: Create necessary test data
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;
        
        Business_Units__c bu = RebateTestDataFactory.initializeBusinessUnits();
        insert bu;
        // creating UnitOfMeasure as a Box. 
        UnitOfMeasure unitMeasure= new UnitOfMeasure(Name='SQ',UnitCode='SQFT',
                                                     Description='SQ',Type='Area');
        // Insert unitMeasure
        Insert unitMeasure;
        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(salesAgreementProductsFormController.CCB_PROGRAM);
        insert rebateProgram; 
        // Create Contact
        Contact rebateContact = new Contact(FirstName = 'John', LastName = 'Doe', AccountId = testUser.Contact.AccountId);
        insert rebateContact;
        
        // Create NewClaimWrapper instance
        NewClaimWrapper wrapper = new NewClaimWrapper();
        wrapper.program = salesAgreementProductsFormController.CCB_PROGRAM; // or 'CP_PROGRAM'
        // wrapper.year = '2024';
        wrapper.year = String.ValueOf(Date.Today().year());
        system.debug('wrapper::'+wrapper);
        // Create ProgramRebateType records
        ProgramRebateType prt1 = RebateTestDataFactory.initializeProgramRebateType(bu.Id, rebateProgram.Id);
        insert prt1;
        ProgramRebateType prt2 = RebateTestDataFactory.initializeProgramRebateType(bu.Id, rebateProgram.Id);
        insert prt2;
        
        // ProgramRebateType prt1 = new ProgramRebateType(Name = 'Rebate Type 1', RebateProgramId = rebateProgram.id, Status = 'Active', Business_Units__c = bu.id);
        //ProgramRebateType prt2 = new ProgramRebateType(Name = 'Rebate Type 2', RebateProgramId = rebateProgram.id, Status = 'Active', Business_Units__c = bu.id);
        // insert new List<ProgramRebateType>{prt1, prt2};
        
        // Create ProgramRebateTypeBenefit records
        ProgramRebateTypeBenefit regularCertaBenefit= new ProgramRebateTypeBenefit(Name='2024 Low Slope Roofing - $10 Regular',
                                                                                   Status='Active',
                                                                                   Benefit_Type__c='Regular',
                                                                                   Product_Category__c='Low Slope Roofing',
                                                                                   ProgramRebateTypeId=prt1.id,
                                                                                   MinimumQualifyingValue=883,
                                                                                   MaximumQualifyingValue=885,
                                                                                   ProductId=testProduct.id,
                                                                                   Unit_of_Measure__c=unitMeasure.Id,
                                                                                   BenefitValue=10,
                                                                                   Stone_Facade_Benefit__c=10,
                                                                                   EffectiveStartDate=Date.today().addMonths(-12), 
                                                                                   EffectiveEndDate=Date.today().addMonths(12)
                                                                                  );
        // Insert  Regular benefit for certaPlank Product.
        Insert regularCertaBenefit;
        /* ProgramRebateTypeBenefit prtBenefit1 = new ProgramRebateTypeBenefit(ProgramRebateTypeId = prt1.Id, UOM__c = unitMeasure.id, Status = 'Active', ProductId = testProduct.id, Product_Category__c = 'Low Slope Roofing');
ProgramRebateTypeBenefit prtBenefit2 = new ProgramRebateTypeBenefit(ProgramRebateTypeId = prt2.Id, UOM__c = unitMeasure.id, Status = 'Active', ProductId = testProduct.id, Product_Category__c = 'Low Slope Roofing');
insert new List<ProgramRebateTypeBenefit>{prtBenefit1, prtBenefit2};*/
        
        // Create Product_UOM__c records
        Product_UOM__c prodUOM1 = new Product_UOM__c(Product__c = testProduct.id, Unit_of_Measure__c =unitMeasure.id, Applicable_Program__c = 'BSP;CCB');
        Product_UOM__c prodUOM2 = new Product_UOM__c(Product__c = testProduct.id, Unit_of_Measure__c = unitMeasure.id, Applicable_Program__c = 'BSP;CCB');
        insert new List<Product_UOM__c>{prodUOM1, prodUOM2};
            
            RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(testUser.Contact.AccountId, rebateContact.id, rebateProgram.Id);
        insert member;     
        // 2. Call the method
        Map<String, List<ProgramRebateTypeBenefit>> result = salesAgreementProductsFormController.getProgramRebateTypes(wrapper, rebateContact.id);
    }
    @isTest
    public static void testBPProgramYearsEligible(){
        Test.startTest(); 
        String ContactId='';
        try {
            USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
            ContactId =testUser.ContactId;
            
            RebateProgram rebateProgram = new RebateProgram(
                Name = 'Test Rebate',
                StartDate = Date.today().addDays(-4),
                EndDate = Date.today().addDays(-3),
                Rebate_Program_Type__c ='CCB',
                Rebate_Program_Sub_Type__c='BP',
                Status = 'Active',
                No_of_Grace_Days_for_Claim__c = 1,
                Frequency = 'CustomPeriods',
                Country__c = 'CAN'
            );
            insert rebateProgram;
            
            RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, ContactId, rebateProgram.Id);
            insert member;
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        salesAgreementProductsFormController.getBPProgramYears('CCB','',ContactId);
        Test.stopTest();  
        
    }
    @isTest
    public static void testCPProgramYearsCurrentYearNotEligible(){
        Test.startTest(); 
        String ContactId='';
        try {
            Account acc = new Account (Name='Test Loyalty');
            Insert acc;
            Contact contact = new Contact(
                AccountId = acc.Id,
                FirstName = 'Test',
                LastName = 'Loyalty1',
                Change_Pay_Eligibility__c='Not Eligible for current year',
                Status__c = 'Active'
            );
            Insert contact;
            ContactId=contact.Id;
            RebateProgram cpRebateProgram = new RebateProgram(
                Name = 'Test Rebate',
                StartDate =Date.newInstance(Date.today().year()-1, 1, 1),  
                EndDate =Date.newInstance(Date.today().year()-1, 12, 31),
                Rebate_Program_Type__c ='CP',
                Status = 'Active',
                No_of_Grace_Days_for_Claim__c = 1,
                Frequency = 'CustomPeriods'
                
            );
            insert cpRebateProgram;
            
            RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, ContactId, cpRebateProgram.Id);
            insert member;
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        salesAgreementProductsFormController.getYears('CP',ContactId);
        Test.stopTest();  
        
    } 
    @isTest
    public static void testBSPProgramYearsCurrentYearNotEligible(){
        Test.startTest(); 
        String ContactId='';
        try {
            Account acc = new Account (Name='Test Loyalty');
            Insert acc;
            Contact contact = new Contact(
                AccountId = acc.Id,
                FirstName = 'Test',
                LastName = 'Loyalty1',
                BSP_Eligibility__c='Not Eligible for current year',
                Status__c = 'Active'
            );
            Insert contact;
            ContactId=contact.Id;
            
            RebateProgram bspRebateProgram = new RebateProgram(
                Name = 'Test Rebate',
                StartDate =Date.newInstance(Date.today().year()-1, 1, 1),  
                EndDate =Date.newInstance(Date.today().year()-1, 12, 31),
                Rebate_Program_Type__c ='BSP',
                Status = 'Active',
                No_of_Grace_Days_for_Claim__c = 1,
                Frequency = 'CustomPeriods'
                
            );
            insert bspRebateProgram;
            
            RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, ContactId, bspRebateProgram.Id);
            insert member;
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        System.debug('ContactId==>'+ContactId);
        salesAgreementProductsFormController.getYears('BSP',ContactId);
        salesAgreementProductsFormController.getYearsBackendClaimSubmission('BSP',ContactId);
        Test.stopTest();  
        
    } 
    @isTest
    public static void testBPProgramYearsForBackendSubmission(){
        Test.startTest(); 
        String ContactId='';
        try {
            Account acc = new Account (Name='Test Loyalty');
            Insert acc;
            Contact contact = new Contact(
                AccountId = acc.Id,
                FirstName = 'Test',
                LastName = 'Loyalty1',
                CCB_Eligibility__c='Eligible',
                Status__c = 'Active'
            );
            Insert contact;
            ContactId=contact.Id;
            RebateProgram rebateProgram = new RebateProgram(
                Name = 'Test Rebate',
                StartDate = Date.today().addDays(-4),
                EndDate = Date.today().addDays(-3),
                Rebate_Program_Type__c ='CCB',
                Rebate_Program_Sub_Type__c='BP',
                Status = 'Active',
                No_of_Grace_Days_for_Claim__c = 1,
                Frequency = 'CustomPeriods',
                Country__c = 'CAN'
            );
            insert rebateProgram;
            
            RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, ContactId, rebateProgram.Id);
            insert member;
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        salesAgreementProductsFormController.getBPProgramYearsForBackendSubmission('CCB','',ContactId);
        Test.stopTest();  
        
    }
      @isTest
    public static void testBSPCurrentYearBackendSubmission(){
        Test.startTest(); 
        String ContactId='';
        try {
            Account acc = new Account (Name='Test Loyalty');
            Insert acc;
            Contact contact = new Contact(
                AccountId = acc.Id,
                FirstName = 'Test',
                LastName = 'Loyalty1',
                  BSP_Eligibility__c='Eligible',
                Status__c = 'Active'
            );
            Insert contact;
            ContactId=contact.Id;
            RebateProgram rebateProgram = new RebateProgram(
                Name = 'Test Rebate',
                StartDate = Date.today().addDays(-4),
                EndDate = Date.today().addDays(-3),
                Rebate_Program_Type__c ='BSP',
                Status = 'Active',
                No_of_Grace_Days_for_Claim__c = 1,
                Frequency = 'CustomPeriods',
                Country__c = 'CAN'
            );
            insert rebateProgram;
            
            RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, ContactId, rebateProgram.Id);
            insert member;
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        salesAgreementProductsFormController.getYearsBackendClaimSubmission('BSP',ContactId);
        Test.stopTest();  
        
    }
       @isTest
    public static void testCCBCurrentYearBackendSubmission(){
        Test.startTest(); 
        String ContactId='';
        try {
            Account acc = new Account (Name='Test Loyalty');
            Insert acc;
            Contact contact = new Contact(
                AccountId = acc.Id,
                FirstName = 'Test',
                LastName = 'Loyalty1',
                CCB_Eligibility__c='Eligible',
                Status__c = 'Active'
            );
            Insert contact;
            ContactId=contact.Id;
            RebateProgram rebateProgram = new RebateProgram(
                Name = 'Test Rebate',
                StartDate = Date.today().addDays(-4),
                EndDate = Date.today().addDays(-3),
                Rebate_Program_Type__c ='CCB',
                Status = 'Active',
                No_of_Grace_Days_for_Claim__c = 1,
                Frequency = 'CustomPeriods',
                Country__c = 'CAN'
            );
            insert rebateProgram;
            
            RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, ContactId, rebateProgram.Id);
            insert member;
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        salesAgreementProductsFormController.getYearsBackendClaimSubmission('CCB',ContactId);
        Test.stopTest();  
        
    }
           @isTest
    public static void testCPCurrentYearNotEligibleBackendSubmission(){
       Test.startTest(); 
        String ContactId='';
        try {
            Account acc = new Account (Name='Test Loyalty');
            Insert acc;
            Contact contact = new Contact(
                AccountId = acc.Id,
                FirstName = 'Test',
                LastName = 'Loyalty1',
                Change_Pay_Eligibility__c='Not Eligible for current year',
                Status__c = 'Active'
            );
            Insert contact;
            ContactId=contact.Id;
            RebateProgram cpRebateProgram = new RebateProgram(
                Name = 'Test Rebate',
                StartDate =Date.newInstance(Date.today().year()-1, 1, 1),  
                EndDate =Date.newInstance(Date.today().year()-1, 12, 31),
                Rebate_Program_Type__c ='CP',
                Status = 'Active',
                No_of_Grace_Days_for_Claim__c = 1,
                Frequency = 'CustomPeriods'
                
            );
            insert cpRebateProgram;
            
            RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(null, ContactId, cpRebateProgram.Id);
            insert member;
        }
        catch(Exception e){
            system.debug(e.getMessage());
        }
        salesAgreementProductsFormController.getYearsBackendClaimSubmission('CP',ContactId);
        Test.stopTest();  
    }  
     
}