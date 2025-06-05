@isTest (seeAllData = true)
public class TestMassDataEntry
{

    public static testMethod void unitTest0()
    {
        test.startTest();
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();
        Account a = new Account(Name = 'Test');
        insert a;

        MassDataEntryController1 mde= new MassDataEntryController1 (new Apexpages.Standardcontroller(VOC));

        mde.getSelectedTypeOptions();
        mde.wrapList.get(0).selectedType = 'Existing';
        mde.wrapList.get(0).VDE.Audience__c = 'Builder';
        mde.wrapList.get(0).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Sub_Category__c = 'Web';
        mde.wrapList.get(0).VDE.Country__c = 'US';
        mde.wrapList.get(0).VDE.City__c = 'New York';
        mde.wrapList.get(0).VDE.State__c = 'New York';
        //mde.wrapList.get(0).VDE.Notes__c = 'Existing';
        mde.wrapList.get(0).VDE.Information_Source__c = 'Retailer';
        mde.wrapList.get(0).VDE.Account__c = a.Id;
        mde.wrapList.get(0).VDE.Meeting_Date__c = System.today();
        PageReference pr=mde.SaveAll();

        mde.rIndex = 0;
        mde.copyRow();
        mde.addRow();
        mde.wrapList.get(2).selectedType = 'Existing';
        mde.wrapList.get(2).VDE.Audience__c = 'Builder';
        mde.wrapList.get(2).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(2).VDE.Sub_Category__c = 'Web';
        mde.wrapList.get(2).VDE.Country__c = 'US';
        mde.wrapList.get(2).VDE.City__c = 'New York';
        mde.wrapList.get(2).VDE.State__c = 'New York';
        //mde.wrapList.get(2).VDE.Notes__c = 'Existing';
        mde.wrapList.get(2).VDE.Information_Source__c = 'Retailer';
        mde.wrapList.get(2).VDE.Account__c = a.Id;
        mde.wrapList.get(2).VDE.Meeting_Date__c = System.today();
        pr=mde.SaveAll();

        test.stopTest();
    }
    public static testMethod void unitTest1()
    {
        test.startTest();
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();
        Account a = new Account(Name = 'Test');
        insert a;

        MassDataEntryController1 mde= new MassDataEntryController1 (new Apexpages.Standardcontroller(VOC));

        mde.getSelectedTypeOptions();
        mde.wrapList.get(0).selectedType = 'Existing';
        mde.wrapList.get(0).VDE.Audience__c = 'Builder';
        mde.wrapList.get(0).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Sub_Category__c = 'Web';
        mde.wrapList.get(0).VDE.Country__c = 'US';
        mde.wrapList.get(0).VDE.City__c = 'New York';
        mde.wrapList.get(0).VDE.State__c = 'New York';
        //mde.wrapList.get(0).VDE.Notes__c = 'Existing';
        mde.wrapList.get(0).VDE.Information_Source__c = 'Retailer';
        mde.wrapList.get(0).VDE.Account__c = a.Id;
        mde.wrapList.get(0).VDE.Meeting_Date__c = System.today();
        PageReference pr=mde.SaveAll();

        mde.rIndex = 0;
        mde.copyRow();
        mde.addRow();
        mde.wrapList.get(1).selectedType = 'Existing';
        mde.wrapList.get(1).VDE.Audience__c = 'Builder';
        mde.wrapList.get(1).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(1).VDE.Sub_Category__c = 'Web';
        mde.wrapList.get(1).VDE.Country__c = 'US';
        mde.wrapList.get(1).VDE.City__c = 'New York';
        mde.wrapList.get(1).VDE.State__c = 'New York';
        //mde.wrapList.get(1).VDE.Notes__c = 'Existing';
        mde.wrapList.get(1).VDE.Information_Source__c = 'Retailer';
        mde.wrapList.get(0).VDE.Account__c = a.Id;
        mde.wrapList.get(1).VDE.Meeting_Date__c = System.today();
        pr=mde.SaveAll();

        pr= mde.saveAllAndClose();
        mde.resetAll();
        mde.DeleteAll2();

        test.stopTest();
    }
    public static testMethod void unitTest2()
    {
        test.startTest();
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();
        Account a = new Account(Name = 'Test');
        insert a;

        MassDataEntryController1 mde= new MassDataEntryController1 (new Apexpages.Standardcontroller(VOC));

        mde.getSelectedTypeOptions();
        mde.cancelCustom();//Added by Kritika Bhati for S-490569 on 27/7/2017
        mde.wrapList.get(0).selectedType = 'Existing';
        mde.wrapList.get(0).VDE.Audience__c = 'Builder';
        mde.wrapList.get(0).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Sub_Category__c = 'Web';
        mde.wrapList.get(0).VDE.Country__c = 'US';
        mde.wrapList.get(0).VDE.City__c = 'New York';
        mde.wrapList.get(0).VDE.State__c = 'New York';
        //mde.wrapList.get(0).VDE.Notes__c = 'Existing';
        mde.wrapList.get(0).VDE.Information_Source__c = 'Retailer';
        mde.wrapList.get(0).VDE.Account__c = a.Id;
        mde.wrapList.get(0).VDE.Meeting_Date__c = System.today();
        PageReference pr=mde.SaveAll();
        pr=mde.saveAllAndClose();
        test.stopTest();
    }
    public static testMethod void unitTest3()
    {
        test.startTest();
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();
        Account a = new Account(Name = 'Test');
        insert a;

        MassDataEntryController1 mde= new MassDataEntryController1 (new Apexpages.Standardcontroller(VOC));

        mde.getSelectedTypeOptions();
        mde.wrapList.get(0).selectedType = 'Existing';
        mde.wrapList.get(0).VDE.Audience__c = 'Builder';
        mde.wrapList.get(0).VDE.Category__c = 'Channel Comment';
        mde.wrapList.get(0).VDE.Sub_Category__c = 'Web';
        mde.wrapList.get(0).VDE.Country__c = 'US';
        mde.wrapList.get(0).VDE.City__c = 'New York';
        mde.wrapList.get(0).VDE.State__c = 'New York';
        //mde.wrapList.get(0).VDE.Notes__c = 'Existing';
        mde.wrapList.get(0).VDE.Information_Source__c = 'Retailer';
        mde.wrapList.get(0).VDE.Account__c = a.Id;
        mde.wrapList.get(0).VDE.Meeting_Date__c = System.today();
        PageReference pr=mde.SaveAll();
        
        mde.wrapList.get(0).selected = true;
        mde.DeleteAll2();
        
        pr=mde.SaveAll();
        test.stopTest();
    }
    //Added by Kritika Bhati for S-490569 on 27/7/2017
      public static testMethod void unitTest4()
      {
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();
        Account a = new Account(Name = 'Test');
        insert a;

        MassDataEntryController1 mde= new MassDataEntryController1 (new Apexpages.Standardcontroller(VOC));
          mde.copyRow();
          mde.showLead = true;
          mde.showContact = true;
          mde.showAccount = true;
      }
    //END S-490569
 
}