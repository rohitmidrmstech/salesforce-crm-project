@isTest
public class ContentDocumentLinkTriggerTest {

    @isTest
    public static void testsetFileVisibilityForRebateClaim() {
          Automation_Controller__c automationController = new Automation_Controller__c();
        automationController.All_Triggers_enabled__c = true;
        insert automationController;
        // create test rebate claim
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        // Test data        
        Rebate_Claim__c testRebateClaim = new Rebate_Claim__c(Status__c = 'Incomplete', RecordTypeId = recTypeId);
        insert testRebateClaim;
        
        // create test content document
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test File Content'),
            IsMajorVersion = true
        );
        insert testContentVersion;
       
        List<ContentDocument> testContentDocument = [
            SELECT Id, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        // create content document link to rebate claim
        ContentDocumentLink testContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId = testContentDocument[0].Id,
            LinkedEntityId = testRebateClaim.Id
        );
        insert testContentDocumentLink;
     
    }
}