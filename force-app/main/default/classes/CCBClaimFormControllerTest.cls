@istest
public with sharing class CCBClaimFormControllerTest {
    @TestSetup
    static void setupTestData(){
        Automation_Controller__c control = Automation_Controller__c.getInstance();
        control.All_Triggers_enabled__c = true;
        upsert control;        

        List<UnitOfMeasure> uoms = RebateTestDataFactory.initializeUoms();
        insert uoms;
        
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;

        List<Product_UOM__c> puoms = RebateTestDataFactory.initalizeProductUOMS(testProduct,  uoms, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert puoms;


        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert rebateProgram; 
        
        RebateTestDataFactory.createCustomerUser();

        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        RebateProgramMember member = RebateTestDataFactory.initializeRebateProgrammember(testUser.Contact.AccountId, testUser.ContactId, rebateProgram.Id);
        insert member;  
    }

    @isTest
    static void testUpsertCCBRebate(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '1234',ProductId = [Select Id from Product2][0].Id,Quantity = 5)); //Unit_Of_Measure_Selected__c, Product_Category__c
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '5678',ProductId = [Select Id from Product2][0].Id,Quantity = 10)); 
        Rebate_claim__C  rebateClaim = CCBClaimFormController.upsertCCBRebate(claimItems, String.Valueof(Date.today().year()), null, testUser.contactId, true, null, false, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER,null);
        System.assert(rebateClaim.Id != null, 'Rebate Claim Record must be created');

        String initData =  CCBClaimFormController.getInitializationData(rebateClaim.Id);
        System.assert(initData != null, 'Init Data must be available');
    
    }

    @isTest 
    static void testProgramMemberDeactivation(){
        RebateProgramMember rebateProgramMember = [Select Id from RebateProgramMember limit 1];

        System.assert([Select count() from RebateProgramMemberShare where ParentId =: rebateProgramMember.Id and RowCause = 'Manual'] == 1, 'Manual Share should be available once Member is created');

        //update member status to inactive
        rebateProgramMember.MemberStatus = RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_INACTIVE;
        update rebateProgramMember;

        System.assert([Select count() from RebateProgramMemberShare where ParentId =: rebateProgramMember.Id and RowCause = 'Manual'] == 0, 'Manual Share should be deleted once Member is deactivate');
    }

    @isTest 
    static void testCreateDistributorRebate(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];

        Rebate_claim__c  rebateClaim = CCBClaimFormController.createDistributorRebate(null, testUser.contactId);        
        System.assert(rebateClaim.Id != null);
    }

    @isTest
    static void testgetDuplicateData(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        
        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '1234',ProductId = [Select Id from Product2][0].Id,Quantity = 5)); //Unit_Of_Measure_Selected__c, Product_Category__c
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '5678',ProductId = [Select Id from Product2][0].Id,Quantity = 10)); 
        Rebate_claim__C  rebateClaim = CCBClaimFormController.upsertCCBRebate(claimItems, String.Valueof(Date.today().year()), null, testUser.contactId, true, null, false, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER,null);
        System.assert(rebateClaim.Id != null, 'Rebate Claim Record must be created');

        String initData =  CCBClaimFormController.getDuplicateData(rebateClaim.Id);
        System.assert(initData != null, 'Init Data must be available');
    
    }
}