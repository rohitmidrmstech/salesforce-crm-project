@isTest
public class ApprovalCommentsControllerTest {
    @isTest static void testComments() {
        // Fetch the created data
        Account acc = [SELECT Id FROM Account LIMIT 1];
        User usr = [SELECT Id FROM User WHERE LastName = 'Last' LIMIT 1];
        
        Supply_Chain__c sc = new Supply_Chain__c();
       
        sc.Accounting_Charge_Code__c ='tutwq';
        sc.Copy_Approval_Comments__c = false;  
        insert sc;
        //Submit the appproval request as the test user
        Test.startTest();
        System.runAs(usr) {
            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
            req.setComments('Approve.');
            //req.setNextApproverIds(new Id[] {UserInfo.getUserId()});
            req.setObjectId(sc.Id);
             req.setProcessDefinitionNameOrId('SAMPLE_REQUEST_PROCESS_FOR_APPROVALS');
             req.setSkipEntryCriteria(true);
            // Submit the approval request
            Approval.ProcessResult result = Approval.process(req);
        }
        
        ApprovalCommentsController controller = new ApprovalCommentsController();
        controller.recordID = sc.Id;
        
        Test.stopTest();
    }
    
    //Method to create test data
    @testSetup static void createTestData() {
        User manager = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last2',
            Email = 'testuser2@example.com',
            Username = 'testuser2@example.com' + System.currentTimeMillis(),
            CompanyName = 'Company',
            Title = 'Title',
            Alias = 'user2',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US'
        );
        insert manager;
        
        User usr = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,
            LastName = 'Last',
            Email = 'testuser@example.com',
            Username = 'testuser@example.com' + System.currentTimeMillis(),
            CompanyName = 'Company',
            Title = 'Title',
            Alias = 'draff',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ManagerId = manager.Id
        );
        insert usr;
        
        String recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Payer').getRecordTypeId();
        
        // Create record with the test user as the owner
        System.runAs(usr) {
            Account acc = new Account(
                RecordTypeId = recordTypeId,
                Name = 'Test Account',
                Account_Type__c = 'Customer' ,
                JDE_Hierarchy_Level__c = 'Payer'
            );
            insert acc;
        }
    }
}