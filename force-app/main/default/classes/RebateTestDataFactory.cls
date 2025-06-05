@istest
public with sharing class RebateTestDataFactory {
    public static final String TEST_ACCOUNT_NAME = 'Test Account';
    public static final String CUSTOMER_ALIAS = 'tcont';
    public static final String CUSTOMER_FIRST_NAME = 'Test';
    public static final String CUSTOMER_LAST_NAME = 'Contractor';
    public static final String CUSTOMER_EMAIL = 'test.contractor@claims.certainteed.com';
    public static final String CUSTOMER_PHONE = '(888) 123-0000';
    public static final String CUSTOMER_USERNAME = 'test.contractor@claims.certainteed.com';
    public static final Map<String, String> UOM_MAP = new Map<String, String>{'Square' => 'SQ', 'Piece' => 'PI'};
    public static final List<String> permSetsForExpUser = new List<String>{'CT_Loyalty_for_Experience_Cloud_Users', 'CT_RebateManagementExpCloudPsl'};

    public static User createCustomerUser() {
        return createCustomerUser(null);
    }

    public static User createCustomerUser(string mailingCountry) {
        User owner;
        User user;

        System.runAs(new User(Id = UserInfo.getUserId())) {
            UserRole role = [SELECT Id FROM UserRole WHERE PortalType = 'None' LIMIT 1];
            Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
            owner = new User(
                Alias = 'tOwner',
                Email = 'test.owner@claims.certainteed.com',
                EmailEncodingKey = 'UTF-8',
                FirstName = 'Test',
                LanguageLocaleKey = 'en_US',
                LastName = 'Owner',
                LocaleSidKey = 'en_US',
                ProfileId = systemAdminProfile.Id,
                TimeZoneSidKey = 'GMT',
                Username = 'test.owner@claims.certainteed.com',
                UserRoleId = role.Id
            );
            insert owner;

            Account account = initializeAccount();
            account.OwnerId = owner.Id;
            insert account;

            Contact contact = initializeContact(account.Id);
            contact.MailingCountry = mailingCountry;
            insert contact;

            Profile customerProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Community Contractor User' LIMIT 1];
            user = new User(
                Alias = CUSTOMER_ALIAS,
                CommunityNickname = CUSTOMER_ALIAS,
                ContactId = contact.Id,
                Email = contact.Email,
                EmailEncodingKey = 'UTF-8',
                Phone = '123-456-7890',
                FirstName = contact.FirstName,
                LanguageLocaleKey = 'en_US',
                LastName = contact.LastName,
                LocaleSidKey = 'en_US',
                ProfileId = customerProfile.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                Username = CUSTOMER_USERNAME,
                Isactive = True
            );
            insert user;

            //assign perm sets
            List<PermissionSetAssignment> assignments = new List<PermissionSetAssignment>();
            for(PermissionSet ps: [Select Id ,Name from PermissionSet where Name in: permSetsForExpUser]){
                assignments.add(new PermissionSetAssignment(AssigneeId=user.Id,PermissionSetId=ps.id));
            }
            insert assignments;
        }

        return user;
    }

    public static RebateProgram initializeRebateProgram(string progremType) {
        RebateProgram rebateProgram = new RebateProgram(
            Name = 'Test Rebate',
            StartDate = Date.today().addDays(-4),
            EndDate = Date.today().addDays(-3),
            Rebate_Program_Type__c = progremType,
            Status = 'Active',
            No_of_Grace_Days_for_Claim__c = 1,
            Frequency = 'CustomPeriods',
             Country__c = 'CAN'
        );
        return rebateProgram;
    }

    public static RebateProgram initializeRebateProgramNonCanada(string progremType) {
        RebateProgram rebateProgram = new RebateProgram(
            Name = 'Contractor Cash Back',
            StartDate = Date.today().addDays(-4),
            EndDate = Date.today().addDays(-3),
            Rebate_Program_Type__c = progremType,
            Status = 'Active',
            No_of_Grace_Days_for_Claim__c = 1,
            Frequency = 'CustomPeriods',
            Country__c = 'US'
        );
        return rebateProgram;
    }

    public static List<UnitOfMeasure> initializeUoms() {
        List<UnitOfMeasure> uoms = new List<UnitOfMeasure>();
        for(String uomName: UOM_MAP.keySet()){
            uoms.add(new UnitOfMeasure(Name = uomName, UnitCode = UOM_MAP.get(uomName), Type = 'CCB'));
        }
        return uoms;
    }

    public static Product2 initalizeProduct(string name) {
        Product2 testProduct = new product2(
            name = name,
            productCode = '632982',
            Product_Category__c = 'Low Slope Roofing');
        return testProduct;
    }

    public static List<Product_UOM__c> initalizeProductUOMS(Product2 testProduct, List<UnitOfMeasure> uoms, string programType) {
        List<Product_UOM__c> productUoms = new List<Product_UOM__c>();
        for(UnitOfMeasure uom: uoms){
            Product_UOM__c pUom = new Product_UOM__c(
                Product__c = testProduct.Id,
                Unit_of_Measure__c = uom.Id,
                Applicable_Program__c = programType
            );
            productUoms.add(pUom);
        }
        return productUoms;
    }

    public static RebateProgramMember initializeRebateProgrammember(Id accountId, Id contactId, Id rebateProgramId){
        RebateProgramMember programMember = new RebateProgramMember(
            AccountId = accountId,
            MemberStatus = 'Active',
            RebateProgramId = rebateProgramId,
            Name = TEST_ACCOUNT_NAME,
            Contact__c = contactId
        );
        return programMember;
    }

    public static Account initializeAccount(){
        Account account = new Account( Name = TEST_ACCOUNT_NAME);
        return account;
    }

    public static Contact initializeContact(Id accountId){
        Contact contact = new Contact(
            AccountId = accountId,
            FirstName = CUSTOMER_FIRST_NAME,
            LastName = CUSTOMER_LAST_NAME,
            Email = CUSTOMER_EMAIL,
            Phone = CUSTOMER_PHONE,
            BSP_Eligibility__c = salesAgreementProductsFormController.ELIGIBLE,
            CCB_Eligibility__c = salesAgreementProductsFormController.ELIGIBLE,
            BIR_Eligibility__c = salesAgreementProductsFormController.ELIGIBLE,
            Change_Pay_Eligibility__c = salesAgreementProductsFormController.ELIGIBLE,
            Status__c = 'Active'
        );
        return contact;
    }

    public static SalesAgreement initializeSalesAgreement(Id accountId){        
        SalesAgreement sa = new SalesAgreement(
            Name = 'Test Agreement',
            IndirectRebate_Status__c = 'Deal',
            StartDate = Date.today().addDays(-5),
            EndDate = Date.today().addDays(3),
            AccountId = accountId,
            ScheduleCount = 1,
            Status = 'Draft',
            ProductLevel = 'Product',
            PricebookId = Test.getStandardPricebookId(),
            No_of_Grace_Days__c = 5         
        );
        return sa;
    }

    public static RebateProgramPayoutPeriod initializeRebateProgramPayoutPeriod(Id rebateProgramId){
        RebateProgramPayoutPeriod rebateProgramPayoutPeriod = new RebateProgramPayoutPeriod(
            Name = 'Test Period',
            StartDate = Date.today().addDays(-5),
            EndDate = Date.today().addDays(3),
            RebateProgramId = rebateProgramId,
            Status = 'Active',
            TransactionGracePeriodDate = Date.today().addDays(3),
            PayoutCalculationDate = Date.today().addDays(3)
        );
        return rebateProgramPayoutPeriod;
    }

    public static Rebate_Claim_Aggregate__c initializeRebateClaimAggregate( Id rebateClaimId, Id payoutPeriodId){
        Rebate_Claim_Aggregate__c rebateClaimAggregate = new Rebate_Claim_Aggregate__c(
            Rebate_Claim__c = rebateClaimId,
            Rebate_Program_Payout_Period__c = payoutPeriodId,
            Total_Rebate_Amount__c = 500
        );
        return rebateClaimAggregate;
    }

    public static RebateMemberProductAggregate initializeRebateMemberProductAggregate(Id payoutPeriodId, Id rebateProgramMemberId, Id rebateClaimId, Id programRebateTypeId){
        RebateMemberProductAggregate rebateMemberProductAggregate = new RebateMemberProductAggregate(
            RebateProgramPayoutPeriodId = payoutPeriodId,
            Rebate_Claim__c = rebateClaimId,
            RebateProgramMemberId = rebateProgramMemberId,
            ProgramRebateTypeId = programRebateTypeId,
            TotalQuantity = 1,
            TotalTransactionAmount = 5
        );
        return rebateMemberProductAggregate; 
    }

    public static Business_Units__c initializeBusinessUnits(){
        Business_Units__c businessUnit = new Business_Units__c(
            Name = 'Test BU',
            Company_Code__c = '100',
            Sales_Org__c = '100'
        );
        return businessUnit;
    }

    public static ProgramRebateType initializeProgramRebateType(Id businessUnitId, Id rebateProgramId){
        ProgramRebateType programRebateType = new ProgramRebateType(
            Name = 'Test rebate type',
            Status = 'Active',
            CalculationType = 'AggregateBased',
            RebateMeasureType = 'AmountperUnit',
            Business_Units__c = businessUnitId,
            RebateProgramId = rebateProgramId,
            CalcObjectId = [select Id from BatchCalcJobDefinition where DeveloperName = 'BSPCCB_AggregateByClaimRebateTypeWithAggregateItems' limit 1][0].Id,
            AggregateObjectName = 'RebateMemberProductAggregate',
            MeasureField = 'TotalQuantity',
            BenefitQualifierField = 'TotalQuantity'

        );
        return programRebateType;
    }

    public static RebateMemberAggregateItem initializeRebateMemberAggregateItem(Id rebateMemberProductAggregateId, Id rebateClaimId, Id rebateClaimItemId, Id transactionJournalId){
        RebateMemberAggregateItem aggItem = new RebateMemberAggregateItem(
            RebateMemberProductAggregateId = rebateMemberProductAggregateId,
            Rebate_Claim__c = rebateClaimId,
            Rebate_Claim_Item__c = rebateClaimItemId,
            TransactionJournalId = transactionJournalId,
            RebateAmount = 1,
            TransactionAmount = 10,
            TransactionQuantity = 1
        );
        return aggItem;
    }

    public static TransactionJournal initializeTransactionJournal(Id rebateClaimId, Id rebateClaimItemId, Id memberId){
        TransactionJournal journal = new TransactionJournal(
            Rebate_Claim__c = rebateClaimId,
            Rebate_Claim_Item__c = rebateClaimItemId,
            MemberId = memberId,
            TransactionAmount = 10,
            Quantity = 1,
            ActivityDate = Date.Today()
        );
        return journal;
    }

    public static SalesAgreementProduct initializeSalesAgreementProduct(Id salesAgreementId, Id pricebookEntryId, string offerType, string basis){
        SalesAgreementProduct salesAgreementProduct = new SalesAgreementProduct(
            SalesAgreementId = salesAgreementId,
            PricebookEntryId = pricebookEntryId,
            Offer_Type__c = offerType,
            Basis__c = basis,
            InitialPlannedQuantity = 1,
            Name = 'Test Sales product'
        );
        return salesAgreementProduct;
    }

    public static ProgramRebateTypeBenefit initializeProgramRebateTypeBenefit(Id rebateTypeId, Id productId){
        ProgramRebateTypeBenefit programRebateTypeBenefit = new ProgramRebateTypeBenefit(
            Name = 'Test Benefit',
            Status = 'Active',
            MinimumQualifyingValue = .1,
            BenefitValue = 1,
            ProgramRebateTypeId = rebateTypeId,
            ProductId = productId

        );
        return programRebateTypeBenefit;
    }

    public static Exchange_Rate__c initializeExchangeRate(String currencyCode){
        Exchange_Rate__c exchnageRate = new Exchange_Rate__c(
            Date__c = Date.Today(),
            Exchange_Rate__c = .8,
            Currency__c = currencyCode
        );
        return exchnageRate;
    }    
}