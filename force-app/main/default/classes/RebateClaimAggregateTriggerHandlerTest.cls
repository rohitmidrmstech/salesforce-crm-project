@isTest
private class RebateClaimAggregateTriggerHandlerTest {
    @TestSetup
    static void setupTestData(){
        RebateTestDataFactory.createCustomerUser();

        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];

        List<UnitOfMeasure> uoms = RebateTestDataFactory.initializeUoms();
        insert uoms;
        
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;

        List<Product_UOM__c> puoms = RebateTestDataFactory.initalizeProductUOMS(testProduct,  uoms, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER+';'+salesAgreementProductsFormController.BIR_PROGRAM);
        insert puoms;

        List<RebateProgram> programsToCreate = new List<RebateProgram>();
        RebateProgram ccbRebateProgram = new RebateProgram(Name = 'Contractor Cash Back',
                                                     StartDate =Date.newInstance(Date.today().year(), 1, 1),  
                                                     EndDate =Date.newInstance(Date.today().year(), 12, 31),
                                                     Frequency='Annually',
                                                     Status='Active',Rebate_Program_Type__c='CCB',
                                                     No_of_Grace_Days_for_Claim__c=60,Country__c='CAN');
        // Insert Rebate program for current year CCB
        programsToCreate.add(ccbRebateProgram);
        RebateProgram birRebateProgram = RebateTestDataFactory.initializeRebateProgram(salesAgreementProductsFormController.BIR_PROGRAM);
        programsToCreate.add(birRebateProgram);
        insert programsToCreate;

        List<RebateProgramMember> membersToCreate = new List<RebateProgramMember>();
        RebateProgramMember ccbProgramMember = RebateTestDataFactory.initializeRebateProgrammember(testUser.Contact.AccountId, testUser.ContactId, ccbRebateProgram.Id);
        membersToCreate.add(ccbProgramMember);
        RebateProgramMember birProgramMember = RebateTestDataFactory.initializeRebateProgrammember(testUser.Contact.AccountId, testUser.ContactId, birRebateProgram.Id);
        membersToCreate.add(birProgramMember);
        insert membersToCreate;

        List<RebateProgramPayoutPeriod> periodsToCreate = new List<RebateProgramPayoutPeriod>();
        RebateProgramPayoutPeriod ccbProgramPeriod = RebateTestDataFactory.initializeRebateProgramPayoutPeriod(ccbRebateProgram.Id);
        periodsToCreate.add(ccbProgramPeriod);
        RebateProgramPayoutPeriod birProgramPeriod = RebateTestDataFactory.initializeRebateProgramPayoutPeriod(birRebateProgram.Id);
        periodsToCreate.add(birProgramPeriod);
        insert periodsToCreate;

    }

    @isTest
    static void testHandlerForNonBIRRebates(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];

        Id periodId = [Select Id from RebateProgramPayoutPeriod where RebateProgram.Rebate_Program_Type__c =: CCBClaimFormController.CCB_PROGRAM_IDENTIFIER][0].Id;
        RebateProgramMember member = [Select Id, Contact__c, RebateProgramId, MemberStatus, RebateProgram.Program_Active_Year__c from RebateProgramMember where RebateProgram.Rebate_Program_Type__c =: CCBClaimFormController.CCB_PROGRAM_IDENTIFIER][0];
        
        member.Contact__c = testUser.contactId;
        member.MemberStatus = RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE;
        
        update member;
        
        System.debug('RebateProgram.Program_Active_Year__c :::::' + member.RebateProgram.Program_Active_Year__c);
        
        update new RebateProgram(Id = member.RebateProgramId, 
                                 Status = salesAgreementProductsFormController.STATUS_ACTIVE,
                                 Rebate_Program_Type__c = CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        
        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '1234',ProductId = [Select Id from Product2][0].Id,Quantity = 5)); //Unit_Of_Measure_Selected__c, Product_Category__c
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '5678',ProductId = [Select Id from Product2][0].Id,Quantity = 10)); 
        Rebate_claim__C  rebateClaim = CCBClaimFormController.upsertCCBRebate(claimItems, String.Valueof(Date.today().year()), null, testUser.contactId, true, null, false, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER,null);

        Rebate_Claim_Aggregate__c claimAggregate = RebateTestDataFactory.initializeRebateClaimAggregate(rebateClaim.Id, periodId);
        insert claimAggregate;

        System.assert([select count() from RebateProgramMemberPayout where PeriodId =: periodId and MemberId =: member.Id] == 1, 'There should be a RebateProgramMemberPayout record created');

        //update claim aggregate
        claimAggregate.Total_Rebate_Amount__c = claimAggregate.Total_Rebate_Amount__c + 10;
        update claimAggregate;

        System.assert([select count() from RebateProgramMemberPayout where PeriodId =: periodId] == 1, 'There should be a RebateProgramMemberPayout record created');
    }  
    
    @isTest
    static void testHandlerForBIRRebates(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];

        Id periodId = [Select Id from RebateProgramPayoutPeriod where RebateProgram.Rebate_Program_Type__c =: salesAgreementProductsFormController.BIR_PROGRAM][0].Id;
        Id memberId = [Select Id from RebateProgramMember where RebateProgram.Rebate_Program_Type__c =: salesAgreementProductsFormController.BIR_PROGRAM][0].Id;
        
        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '1234',ProductId = [Select Id from Product2][0].Id,Quantity = 5)); 
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '5678',ProductId = [Select Id from Product2][0].Id,Quantity = 10)); 

        List<Rebate_claim__c> rebateClaim = salesAgreementProductsFormController.upsertBIRRebate(new List<Rebate_claim__c>{new Rebate_claim__c()}, claimItems, null, testUser.contactId, false, false);

        Rebate_Claim_Aggregate__c claimAggregate = RebateTestDataFactory.initializeRebateClaimAggregate(rebateClaim[0].Id, periodId);
        claimAggregate.PFX_Claim__c = 'pfx-001';
        claimAggregate.Payment_Date__c = Date.today();
        insert claimAggregate;

        //update claim aggregate
        claimAggregate.Total_Rebate_Amount__c = claimAggregate.Total_Rebate_Amount__c + 10;
        claimAggregate.SAP_Processed__c = true;
        claimAggregate.Check_Number__c = '0001';
        update claimAggregate;
    }    
}