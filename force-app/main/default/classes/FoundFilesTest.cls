@isTest
public class FoundFilesTest {
    @isTest
    static void testFoundFiles() {
        ContentVersion cv = new ContentVersion();
        cv.Title = 'TestFile';
        cv.PathOnClient = 'TestFile.txt';
        cv.ContentLocation = 'S';
        cv.VersionData = Blob.valueOf('Test file content');
        insert cv;
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
        /*Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.StageName = 'Prospecting';
        opp.CloseDate = system.today()+13;
        opp.start_date__c = system.today();
        opp.contract_term__c = 3;
        insert opp;*/

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = testAccount.Id;
        cdl.ShareType = 'I';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        
        
        list <opportunity> opplist = new list <opportunity>();

        // Create test Opportunity records. You may need to create related records too.
        Opportunity opp1 = new Opportunity(GCP_ID__c = 'ExternalId1', Processed_ids__c = null,Name = 'Test Opp',
        StageName = 'Prospecting',
        CloseDate = system.today()+13);
        
        Opportunity opp2 = new Opportunity(GCP_ID__c = 'ExternalId2', Processed_ids__c = 'ProcessedId1;ProcessedId2',Name = 'Test Opp',
        StageName = 'Prospecting',
        CloseDate = system.today()+13);
        
        opplist.add(opp1);
        opplist.add(opp2);

        // Insert the test Opportunity records.
        insert opplist;
        
        Set<Id> destinationRecordIds = new Set<Id>{opplist[0].id, opplist[0].id};
        String sourceSessionId = 'YourSourceSessionId';
        String sourceDomainURL = 'YourSourceDomainURL';
            
          Test.setMock(HttpCalloutMock.class, new FoundFilesHttpMock());
        Test.startTest();
        FoundFiles FFiles = new FoundFiles(destinationRecordIds, sourceSessionId, sourceDomainURL);
        Database.executeBatch(FFiles);
        Test.stopTest();

        
        //FoundFiles FFiles = new FoundFiles(destinationRecordIds,sourceSessionId,sourceDomainURL);
    }
    // Mock HTTP response for the callouts
    public class FoundFilesHttpMock implements HttpCalloutMock {
    public HTTPResponse respond(HTTPRequest req) {
        // Simulate the HTTP response here and return it.
        HTTPResponse res = new HTTPResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        // Set the response body with appropriate JSON data.
        res.setBody('{"records": [ { "Id": "ContentVersionId", "Title": "Title", "FileExtension": "pdf" } ]}');
        return res;
    }
}

}