@isTest
public class WOD_RelatedListNotesAndAttachments_Test{
    
    static testMethod void testNotes(){
        Account acc = wod_TestDataFactory.createAccount('TestAccount','','Warranty Account');
        acc.BillingStreet = '3667 Park Overlook Dr Unit 11';
        acc.BillingCity = 'Beavercreek';
        acc.BillingPostalCode = '45431';
        upsert acc;
        
        WOD_2__Claim__c clm = new WOD_2__Claim__c();
        
        WOD_2__Claim__c clmModified = new WOD_2__Claim__c();
        List<WOD_2__Claim__c> lstWodCS = new List<WOD_2__Claim__c>();
        
        
        clm =WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');


        
        clm.customer__c = acc.id;
        upsert clm;
        
        Blob blobdata=Blob.valueof('unit test for contentversionbatch class');
        Attachment a = new Attachment (ParentId = clm.Id, Name= 'test', Body=blobdata);
        insert a;
        
        Note note1 = new Note(ParentId = clm.Id, title='Test Note');
        insert note1;
        
        ContentVersion cv=new contentVersion(Title='simpletitle',pathonclient='sampletitle.jpg',versionData=blobdata,origin='H');
        insert cv;
        contentversion cvI=[select id,title,contentDocumentId from contentVersion where id=:cv.Id limit 1];
        
        ContentDocumentlInk cl = new ContentDocumentLink(LinkedEntityId = clm.Id, COntentDocumentiD = cvI.ContentDocumentId );
        insert cl;
        
        
        ContentVersion cvN=new contentVersion(Title='simpletitle',pathonclient='sampletitle.snote',versionData=blobdata,origin='H');
        insert cvN;
        contentversion cvIN=[select id,title,contentDocumentId from contentVersion where id=:cvN.Id limit 1];
        
        ContentDocumentlInk cl1 = new ContentDocumentLink(LinkedEntityId = clm.Id, COntentDocumentiD = cvIN.ContentDocumentId );
        insert cl1;
        
        Test.setCurrentPage(Page.WOD_RelatedListNotesAndAttachments);
        ApexPages.currentPage().getParameters().put('Id', clm.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(clm);
        WOD_RelatedListNotesAndAttachments w = new WOD_RelatedListNotesAndAttachments(sc);
    }
}