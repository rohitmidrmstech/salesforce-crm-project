@isTest
public class WOD_RelatedListNotesAttachmentsWR_Test{
    
    static testMethod void testNotes(){
        Account acc = wod_TestDataFactory.createAccount('TestAccount','','Warranty Account');
        acc.BillingStreet = '3667 Park Overlook Dr Unit 11';
        acc.BillingCity = 'Beavercreek';
        acc.BillingPostalCode = '45431';
        upsert acc;
        
        WOD_2__Warranty_Registration__c wr=new WOD_2__Warranty_Registration__c();
        wr.WOD_2__Registration_Date__c=system.today();
        wr.Address_1__c='Test';
        wr.Address_2__c='Address 2';
        wr.City__c='City';
        wr.State__c='Alabama (AL)';
        wr.Country__c='United States';
        wr.Postal_Code__c='12345';
        wr.Address_1_BL__c='Test';
        wr.Address_2_BL__c='Address 2';
        wr.City_BL__c='City';
        wr.State_BL__c='Alabama (AL)';
        wr.Country_BL__c='United States';
        wr.Postal_Code_BL__c='12345';
        wr.Email__c='test@test.com';
        wr.WOD_2__Registration_Type__c='Commercial';
        insert wr;
        
        Blob blobdata=Blob.valueof('unit test for contentversionbatch class');
        Attachment a = new Attachment (ParentId = wr.Id, Name= 'test', Body=blobdata);
        insert a;
        
        Note note1 = new Note(ParentId = wr.Id, title='Test Note');
        insert note1;
        
        ContentVersion cv=new contentVersion(Title='simpletitle',pathonclient='sampletitle.jpg',versionData=blobdata,origin='H');
        insert cv;
        contentversion cvI=[select id,title,contentDocumentId from contentVersion where id=:cv.Id limit 1];
        
        ContentDocumentlInk cl = new ContentDocumentLink(LinkedEntityId = wr.Id, COntentDocumentiD = cvI.ContentDocumentId );
        insert cl;
        
        
        ContentVersion cvN=new contentVersion(Title='simpletitle',pathonclient='sampletitle.snote',versionData=blobdata,origin='H');
        insert cvN;
        contentversion cvIN=[select id,title,contentDocumentId from contentVersion where id=:cvN.Id limit 1];
        
        ContentDocumentlInk cl1 = new ContentDocumentLink(LinkedEntityId = wr.Id, COntentDocumentiD = cvIN.ContentDocumentId );
        insert cl1;
        
        Test.setCurrentPage(Page.WOD_RelatedListNotesAndAttachmentsWR);
        ApexPages.currentPage().getParameters().put('Id', wr.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(wr);
        WOD_RelatedListNotesAndAttachmentsWR w = new WOD_RelatedListNotesAndAttachmentsWR(sc);
    }
}