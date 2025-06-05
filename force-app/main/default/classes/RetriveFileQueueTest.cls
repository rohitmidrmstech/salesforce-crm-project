@isTest
public class RetriveFileQueueTest {
    @isTest
    static void testRetriveFilesQueue() {
        ContentVersion cv = new ContentVersion();
        cv.Title = 'TestFile';
        cv.PathOnClient = 'TestFile.txt';
        cv.ContentLocation = 'S';
        cv.VersionData = Blob.valueOf('Test file content');
        insert cv;
        
        Account testAccount = new Account();
        testAccount.Name = 'Test Account';
        insert testAccount;
        
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

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id = :cv.Id].ContentDocumentId;
        cdl.LinkedEntityId = testAccount.Id;
        cdl.ShareType = 'I';
        cdl.Visibility = 'AllUsers';
        insert cdl;
        
        Id destinationRecordId = opplist[0].Id ;
        FoundFiles.cvRecords cvRecord = new FoundFiles.cvRecords(); // You need to populate this object with relevant data
        String sourceSessionId = 'Your_Source_Session_Id';
        String sourceDomainURL = 'Your_Source_Domain_URL';
        
        
        
        RetriveFileQueue RFileQueue = new RetriveFileQueue(destinationRecordId,cvRecord,sourceSessionId,sourceDomainURL);
        System.enqueueJob(RFileQueue);

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.stopTest();
    }
    
    //mock class hendal web service call out
    public class MockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"id": "sampleContentDocumentId"}');
            res.setStatusCode(200);
            return res;
        }
    }
}