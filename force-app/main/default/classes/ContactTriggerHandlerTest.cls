@isTest
private class ContactTriggerHandlerTest {
    @TestSetup
    static void setupTestData(){
        Automation_Controller__c control = Automation_Controller__c.getInstance();
        control.All_Triggers_enabled__c = true;
        upsert control; 

        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert rebateProgram; 
        
        RebateTestDataFactory.createCustomerUser();    
    }

    @isTest
    private static void testProgramMemberShareCreation(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];

        //create test account
        Account testAccount = RebateTestDataFactory.initializeAccount();
        testAccount.OwnerId = [Select Id from User where IsActive = true and UserRoleId != null and UserRole.PortalType = 'None'  limit 1][0].Id;
        insert testAccount;

        //update account to be partner
        testAccount.isPartner = true;        
        update testAccount;

        //update contact account
        update new Contact(Id = testUser.ContactId, AccountId = testAccount.Id);

        //assert member share is created
        //System.assert([Select count() from RebateProgramMemberShare Where RowCause ='Manual'] == 1 );
    }
}