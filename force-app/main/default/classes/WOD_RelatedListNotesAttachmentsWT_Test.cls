@isTest
public class WOD_RelatedListNotesAttachmentsWT_Test{
    
    static testMethod void testNotes(){
        Account acc = wod_TestDataFactory.createAccount('TestAccount','','Warranty Account');
        acc.BillingStreet = '3667 Park Overlook Dr Unit 11';
        acc.BillingCity = 'Beavercreek';
        acc.BillingPostalCode = '45431';
        upsert acc;
        
        WOD_Warranty_Transfer__c wt=new WOD_Warranty_Transfer__c();
        wt.Transfered_Date__c=system.today();
        wt.Address_1__c='Test';
        wt.Address_2__c='Address 2';
        wt.City__c='City';
        wt.State__c='Alabama (AL)';
        wt.Country__c='United States';
        wt.Postal_Code__c='12345';
        wt.Address_1_BL__c='Test';
        wt.Address_2_BL__c='Address 2';
        wt.City_BL__c='City';
        wt.State_BL__c='Alabama (AL)';
        wt.Country_BL__c='United States';
        wt.Postal_Code_BL__c='12345';
        wt.Email__c='test@test.com';
        wt.RecordTypeId=[Select Id,Name from RecordType where sobjecttype='wod_Warranty_Transfer__c' and Name = 'Commercial'].Id;
        insert wt;
        
        Blob blobdata=Blob.valueof('unit test for contentversionbatch class');
        Attachment a = new Attachment (ParentId = wt.Id, Name= 'test', Body=blobdata);
        insert a;
        
        Note note1 = new Note(ParentId = wt.Id, title='Test Note');
        insert note1;
        
        ContentVersion cv=new contentVersion(Title='simpletitle',pathonclient='sampletitle.jpg',versionData=blobdata,origin='H');
        insert cv;
        contentversion cvI=[select id,title,contentDocumentId from contentVersion where id=:cv.Id limit 1];
        
        ContentDocumentlInk cl = new ContentDocumentLink(LinkedEntityId = wt.Id, COntentDocumentiD = cvI.ContentDocumentId );
        insert cl;
        
        
        ContentVersion cvN=new contentVersion(Title='simpletitle',pathonclient='sampletitle.snote',versionData=blobdata,origin='H');
        insert cvN;
        contentversion cvIN=[select id,title,contentDocumentId from contentVersion where id=:cvN.Id limit 1];
        
        ContentDocumentlInk cl1 = new ContentDocumentLink(LinkedEntityId = wt.Id, COntentDocumentiD = cvIN.ContentDocumentId );
        insert cl1;
        
        Test.setCurrentPage(Page.WOD_RelatedListNotesAndAttachmentsWT);
        ApexPages.currentPage().getParameters().put('Id', wt.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(wt);
        WOD_RelatedListNotesAndAttachmentsWT w = new WOD_RelatedListNotesAndAttachmentsWT(sc);
    }
}