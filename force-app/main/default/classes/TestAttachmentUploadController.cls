@isTest
private class TestAttachmentUploadController {
    static testMethod void AttachmentUploadControllerTest() {
        ProDialogue_Input__c pin = new ProDialogue_Input__c(City_State__c = 'Lewiston',Meeting_Date__c = System.Today());
        insert pin;
        Apexpages.standardController sc = new Apexpages.standardController(pin);
        AttachmentUploadController  auc = new AttachmentUploadController(sc);
        auc.attach.name = 'Test';
        auc.attach.Body = Blob.valueOf('Test');
        auc.upload();
        auc.init();
        auc.done();
        auc.testIntegers();
    }
}