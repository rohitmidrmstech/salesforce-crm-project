@isTest (seeAllData = true)
public class TestNewEvent
{

    public static testMethod void unitTest0()
    {
        test.startTest();
        Event__c evt = new Event__c();
        evt.Name ='Test555';
        evt.City__c ='NZ';
        evt.Priority__c ='High';
        evt.Country__c ='US';
        insert evt;
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();

        NewEventController mde= new NewEventController (new Apexpages.Standardcontroller(VOC));
       
        mde.wrapList.get(0).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Priority__c = 'High';
        mde.wrapList.get(0).VDE.Sub_Category__c = 'Web';       
        //mde.wrapList.get(0).VDE.Notes__c = 'Existing';
        PageReference pr=mde.SaveAll();

        mde.rIndex = 0;
        mde.copyRow();
        mde.addRow();       
        mde.wrapList.get(2).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Priority__c = 'High';
        mde.wrapList.get(2).VDE.Sub_Category__c = 'Web';
        //mde.wrapList.get(2).VDE.Notes__c = 'Existing';
        pr=mde.SaveAll();

        test.stopTest();
    }
    public static testMethod void unitTest1()
    {
        test.startTest();
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();

        NewEventController mde= new NewEventController (new Apexpages.Standardcontroller(VOC));
       
        mde.wrapList.get(0).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Priority__c = 'High';
        mde.wrapList.get(0).VDE.Sub_Category__c = 'Web';
        //mde.wrapList.get(0).VDE.Notes__c = 'Existing';
        PageReference pr=mde.SaveAll();

        mde.rIndex = 0;
        mde.copyRow();
        mde.addRow();
        mde.wrapList.get(1).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Priority__c = 'High';
        mde.wrapList.get(1).VDE.Sub_Category__c = 'Web';
        //mde.wrapList.get(1).VDE.Notes__c = 'Existing';
        pr=mde.SaveAll();

        pr= mde.saveAllAndClose();
        mde.DeleteAll2();

        test.stopTest();
    }
    public static testMethod void unitTest2()
    {
        test.startTest();
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();

        NewEventController mde= new NewEventController (new Apexpages.Standardcontroller(VOC));

        mde.wrapList.get(0).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Priority__c = 'High';
        mde.wrapList.get(0).VDE.Sub_Category__c = 'Web';
        //mde.wrapList.get(0).VDE.Notes__c = 'Existing';
        PageReference pr=mde.SaveAll();
        pr=mde.saveAllAndClose();
        test.stopTest();
    }
    public static testMethod void unitTest3()
    {
        test.startTest();
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();

        NewEventController mde= new NewEventController (new Apexpages.Standardcontroller(VOC));

        mde.wrapList.get(0).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Priority__c = 'High';
        mde.wrapList.get(0).VDE.Sub_Category__c = 'Web';
        //mde.wrapList.get(0).VDE.Notes__c = 'Existing';
        PageReference pr=mde.SaveAll();
        
        mde.wrapList.get(0).selected = true;
        mde.DeleteAll2();
        
        pr=mde.SaveAll();
        test.stopTest();
    }
    
}