@isTest
public class WOD_RelatedLstNoteAtachmntInspectionTest{
    
    static testMethod void testNotes(){
        Account acc = wod_TestDataFactory.createAccount('TestAccount','','Warranty Account');
        acc.BillingStreet = '3667 Park Overlook Dr Unit 11';
        acc.BillingCity = 'Beavercreek';
        acc.BillingPostalCode = '45431';
        upsert acc;
        
        WOD_2__Claim__c clm = new WOD_2__Claim__c();
        
        WOD_2__Claim__c clmModified = new WOD_2__Claim__c();
        
        clm =WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        
        clm.customer__c = acc.id;
        upsert clm;
        
        WOD_Inspection__c inspect = new WOD_Inspection__c();
        inspect.Date_Received__c = System.today();
        inspect.Claim__c = clm.Id;
        inspect.Inspection_Status__c = 'Inspection-Requested';
        insert inspect;
        
        Blob blobdata=Blob.valueof('unit test for contentversionbatch class');
        Attachment a = new Attachment (ParentId = inspect.Id, Name= 'test', Body=blobdata);
        insert a;
        
        Note note1 = new Note(ParentId = inspect.Id, title='Test Note');
        insert note1;
        
        ContentVersion cv=new contentVersion(Title='simpletitle',pathonclient='sampletitle.jpg',versionData=blobdata,origin='H');
        insert cv;
        contentversion cvI=[select id,title,contentDocumentId from contentVersion where id=:cv.Id limit 1];
        
        ContentDocumentlInk cl = new ContentDocumentLink(LinkedEntityId = inspect.Id, COntentDocumentiD = cvI.ContentDocumentId );
        insert cl;
        
        
        ContentVersion cvN=new contentVersion(Title='simpletitle',pathonclient='sampletitle.snote',versionData=blobdata,origin='H');
        insert cvN;
        contentversion cvIN=[select id,title,contentDocumentId from contentVersion where id=:cvN.Id limit 1];
        
        ContentDocumentlInk cl1 = new ContentDocumentLink(LinkedEntityId = inspect.Id, COntentDocumentiD = cvIN.ContentDocumentId );
        insert cl1;
        
        Test.setCurrentPage(Page.WOD_RelatedListNotesAndAttachmentsWR);
        ApexPages.currentPage().getParameters().put('Id', inspect.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(inspect);
        WOD_RelatedListNotesAttachmentInspection w = new WOD_RelatedListNotesAttachmentInspection(sc);
    }
}