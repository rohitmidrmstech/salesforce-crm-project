@isTest
private class TestVOCEditOrverrideController{
    static testMethod void myUnitTest() {
        VOC_Data_Entry__c  vde = new VOC_Data_Entry__c();
        insert vde;
        String str = vde.id;
        Apexpages.currentPage().getParameters().put('retURL','/str');
        Apexpages.standardController sc = new Apexpages.standardController(vde);
        VOCEditOrverrideController  veoc = new VOCEditOrverrideController(sc);
        veoc.init();

    }
    static testMethod void myUnitTest1() {
        ProDialogue_Input__c pin = new ProDialogue_Input__c(City_State__c = 'New york',Meeting_Date__c = System.today());
        insert pin;
        ProDialogue_Input_Attendee__c  vde = new ProDialogue_Input_Attendee__c(ProDialogue_Input__c = pin.Id);
        insert vde;
        String str = vde.id;
        Apexpages.currentPage().getParameters().put('retURL','/str');
        Apexpages.standardController sc = new Apexpages.standardController(vde);
        VOCAttendeeditOrverrideController veoc = new VOCAttendeeditOrverrideController(sc);
        veoc.init();
        Weekly_Territory_Update__c wtu = new Weekly_Territory_Update__c();
        insert wtu;
    }
}