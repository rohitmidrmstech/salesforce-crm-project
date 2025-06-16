@isTest
private with sharing class RebateUtilityTest {
    @isTest
    static void testAsscoaiteFilesToRecord(){
        
            Account testAccount = new Account(Name = 'test');
            insert testAccount;

            //Create Document
            ContentVersion contentVersion = new ContentVersion();
            contentVersion.Title = 'Test';
            contentVersion.PathOnClient = 'test.pdf';
            contentVersion.VersionData = Blob.valueOf('Test Content');
            contentVersion.IsMajorVersion = true;
            insert contentVersion;
    
            //Get Content Documents
            Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;

            RebateUtility.FileWrapper fileWrapper = new RebateUtility.FileWrapper();
            fileWrapper.name = 'Test';
            fileWrapper.contentVersionId = contentVersion.Id;
            fileWrapper.documentId = conDocId;

            RebateUtility.asscoaiteFilesToRecord(testAccount.Id, new List<RebateUtility.FileWrapper>{fileWrapper});
            System.assert([Select count() from ContentDocumentLink where LinkedEntityId =: testAccount.Id] == 1, 'There should be an entry in ContentDocumentLink');

            List<RebateUtility.FileWrapper> files = RebateUtility.getFilesList(testAccount.Id);
            System.assert(files.size() == 1, 'There should be one file returned');    
    }

    @isTest
    static void testIsUserMemberOfAccountTeam(){
        Account testAccount = RebateTestDataFactory.initializeAccount();
        insert testAccount;

        Map<string, Account_Team_Role_To_Initiate_BSP_Claim__mdt> teamRolesMap = Account_Team_Role_To_Initiate_BSP_Claim__mdt.getAll();
        string testTeamMember = teamRolesMap.values()[0].Label
;
        AccountTeammember teamMember = new AccountTeamMember(UserId = Userinfo.getUserId(), AccountId = testAccount.Id, TeammemberRole = testTeamMember);
        insert teamMember;

        Test.startTest();
        Boolean userIsMemberOfAccountTeam = RebateUtility.isUserMemberOfAccountTeam(testAccount.Id, new List<String>{testTeamMember}, UserInfo.getUserId());
        Boolean userIsNotMemberOfAccountTeam = RebateUtility.isUserMemberOfAccountTeam(testAccount.Id, new List<String>{'xx'}, UserInfo.getUserId());

        Test.stopTest();

        System.assert(userIsMemberOfAccountTeam);
        System.assert(userIsNotMemberOfAccountTeam == false);
    }

    @isTest
    static void testGetRebateContact(){
        Account testAccount = RebateTestDataFactory.initializeAccount();
        insert testAccount;        

        Contact testContact = RebateTestDataFactory.initializeContact(testAccount.Id);
        insert testContact;

        Test.startTest();
        Contact c = RebateUtility.getRebateContact(testContact.Id);
        Test.stopTest();

        System.assert(c.Id == testContact.Id);
    }
}