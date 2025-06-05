@isTest
private class UserTriggerHandlerTest {
    @TestSetup
    static void setupTestData(){
        Automation_Controller__c control = Automation_Controller__c.getInstance();
        control.All_Triggers_enabled__c = true;
        upsert control;  

        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert rebateProgram;

        RebateTestDataFactory.createCustomerUser();

        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];       

    }

    @isTest
    static void testCreateExperianceUserShares() {
        //deactivate test user
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
        testUser.IsActive = false;
        update testUser;

        RebateProgramMember programMember = [Select Id,Contact__c from RebateProgramMember where Contact__c =: testUser.ContactId limit 1];

        Test.startTest();
        //Active test user
        testUser.IsActive = true;
        update testUser;

        Test.stopTest();

        //Assert Shares are created in group member
        System.assert([Select count() from RebateProgramMemberShare where ParentId =: programMember.Id and UserOrgroupId =: testUser.Id] == 1);
    }
}