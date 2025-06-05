@istest
private class RebateMemProduAggregateTrigrHandlerTest {
    @TestSetup
    static void setupTestData(){
        RebateTestDataFactory.createCustomerUser();

        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];

        List<UnitOfMeasure> uoms = RebateTestDataFactory.initializeUoms();
        insert uoms;

        Business_Units__c bu = RebateTestDataFactory.initializeBusinessUnits();
        insert bu;
        
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;

        List<Product_UOM__c> puoms = RebateTestDataFactory.initalizeProductUOMS(testProduct,  uoms, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert puoms;

        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert rebateProgram;

        RebateProgramMember programMember = RebateTestDataFactory.initializeRebateProgrammember(testUser.Contact.AccountId, testUser.ContactId, rebateProgram.Id);
        insert programMember;

        RebateProgramPayoutPeriod programPeriod = RebateTestDataFactory.initializeRebateProgramPayoutPeriod(rebateProgram.Id);
        insert programPeriod;

        ProgramRebateType programRebateType = RebateTestDataFactory.initializeProgramRebateType(bu.Id, rebateProgram.Id);
        insert programRebateType;

        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '1234',ProductId = [Select Id from Product2][0].Id,Quantity = 5)); 
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '5678',ProductId = [Select Id from Product2][0].Id,Quantity = 10)); 
        Rebate_claim__C  rebateClaim = CCBClaimFormController.upsertCCBRebate(claimItems, String.Valueof(Date.today().year()), null, testUser.contactId, true, null, false, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER,null);
    }

    @isTest 
    static void testHandler(){
        Id payoutPeriodId = [Select Id from RebateProgramPayoutPeriod][0].Id;
        Id rebateProgramMemberId = [Select Id from RebateProgramMember][0].Id;
        Id programRebateTypeId = [Select Id from ProgramRebateType][0].Id;
        Id rebateClaimId = [Select Id from Rebate_claim__C][0].Id;
        Id rebateClaimItemId = [Select Id from RebateClaim][0].Id;

        RebateMemberProductAggregate rebateMemAgg = RebateTestDataFactory.initializeRebateMemberProductAggregate(payoutPeriodId, rebateProgramMemberId, rebateClaimId, programRebateTypeId);
        insert rebateMemAgg;

        System.assert([Select count() from programRebateTypePayout] == 0, 'There should not be any programRebateTypePayout records created because no RebateMemberProductAggregate record is yet created');

        Rebate_Claim_Aggregate__c claimAggregate = RebateTestDataFactory.initializeRebateClaimAggregate(rebateClaimId, payoutPeriodId);
        insert claimAggregate;

        System.assert([Select count() from programRebateTypePayout] == 1, 'There should  be 1 programRebateTypePayout records created because  RebateMemberProductAggregate record is now created');

        rebateMemAgg.TotalTransactionAmount = rebateMemAgg.TotalTransactionAmount + 10;
        update rebateMemAgg;

        //update payout to test ProgramRebateTypePayoutTriggerHandler
        programRebateTypePayout typePayout = [Select Id from programRebateTypePayout limit 1];
        typePayout.SAP_Processed__c = true;
        typePayout.Check_Number__c = '123';
        typePayout.Total_Amount_Paid__c = 100;
        update typePayout;        

        TransactionJournal journal = RebateTestdataFactory.initializeTransactionJournal(rebateClaimId, rebateClaimItemId, rebateProgramMemberId);
        insert journal;

        RebateMemberAggregateItem aggregateItem = RebateTestdataFactory.initializeRebateMemberAggregateItem(rebateMemAgg.Id, rebateClaimId, rebateClaimItemId, journal.Id);
        insert aggregateItem;

        //assert payout src is created
        System.assert([Select count() from ProgramRebateTypPayoutSrc where Rebate_Business_Unit_Aggregate_Item__c =: aggregateItem.Id] == 1, 'There should be 1 ProgramRebateTypPayoutSrc records created because  RebateMemberAggregateItem record is now created');
        aggregateItem.TransactionAmount += 1;
        update aggregateItem;

    }
}