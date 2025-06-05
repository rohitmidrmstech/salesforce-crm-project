//@isTest (seeAllData = true)
public class testAllVOCDataEntry
{
    /*
    History:
* - VERSION  DEVELOPER NAME                  DATE            DETAIL FEATURES/CSR/TTP
    1.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
    public static testMethod void AllVOCDataEntry1()
    {
        test.startTest();
        
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        voc.City_State__c  = 'Rajasthan';
        insert voc;
       
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.Email = 'test.class@testuser.com';
        c.FirstName = 'testContact';
        c.LastName = 'classContact';
        c.MailingStreet = 'TestStreet';
        c.MailingCity = 'TestCity';
        c.MailingState = 'TestState';
        c.MailingPostalCode = ' TestPostalCode';
        c.Phone = '1234567890';
        c.Call_Attempt__c = 'C1';
        c.Call_Attempt_Comments__c = 'Test Record';
        c.Call_Attempt_Description__c = 'Wrong Number';
        c.Call_Attempted_By__c = 'Testing';
        c.Call_Back_Date__c = System.today();
        insert c;
             
        ApexPages.currentPage().getParameters().put('pId',c.Id);     
        AllVOCDataEntry vde = new AllVOCDataEntry(new Apexpages.Standardcontroller(voc));
        
        Pagereference pr = vde.cancelCustom();
        List<SelectOption> listOptions = vde.getSelectedTypeOptions();
        vde.rIndex = 0;
        vde.addRow();
        vde.rIndex = 0;
        vde.copyRow();
        vde.DeleteAll2();
        
        test.stopTest();
    }
    public static testMethod void AllVOCDataEntry2()
    {
        test.startTest();
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        voc.City_State__c  = 'Rajasthan';
        insert voc;
             
        ApexPages.currentPage().getParameters().put('pId',a.Id);     
        AllVOCDataEntry vde = new AllVOCDataEntry(new Apexpages.Standardcontroller(voc));
        
        Pagereference pr = vde.cancelCustom();
        List<SelectOption> listOptions = vde.getSelectedTypeOptions();
        vde.rIndex = 0;
        vde.addRow();
        pr = vde.saveAll(); 
        test.stopTest();
    }
    public static testMethod void AllVOCDataEntry3()
    {
        test.startTest();
        
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        voc.City_State__c  = 'Rajasthan';
        insert voc;

        Event__c e = new Event__c();
        e.City__c = 'tesCity';
        e.Country__c = 'testCountry';
        insert e;

        ApexPages.currentPage().getParameters().put('pId',e.Id);     
        AllVOCDataEntry vde = new AllVOCDataEntry(new Apexpages.Standardcontroller(voc));
        
        Pagereference pr = vde.cancelCustom();
        List<SelectOption> listOptions = vde.getSelectedTypeOptions();
        vde.rIndex = 0;
        vde.addRow();
        vde.rIndex = 0;
        vde.copyRow();
        pr = vde.saveAllAndClose();
        test.stopTest();
    }
    public static testMethod void AllVOCDataEntry4()
    {
        test.startTest();
       
       Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        voc.City_State__c  = 'Rajasthan';
        //voc.Notes__c = 'Test';
        insert voc;
        
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'class';
        l.Email = 'test.class@gmail.com';
        l.Company = 'testCompany';
        insert l;

        ApexPages.currentPage().getParameters().put('pId',l.Id);     
        AllVOCDataEntry vde = new AllVOCDataEntry(new Apexpages.Standardcontroller(voc));
        Pagereference pr = vde.cancelCustom();
        List<SelectOption> listOptions = vde.getSelectedTypeOptions();  
        vde.rIndex = 0;
        vde.copyRow();
        vde.rIndex = 0;
        vde.addRow();
        vde.resetAll();
        test.stopTest();
    }
    public static testMethod void AllVOCDataEntry5()
    {
        test.startTest();
       
       Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        voc.City_State__c  = 'Rajasthan';
        //voc.Notes__c = 'test';
        insert voc;
        
        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'class';
        l.Email = 'test.class@gmail.com';
        l.Company = 'testCompany';
        insert l;

        ApexPages.currentPage().getParameters().put('pId',l.Id);     
        AllVOCDataEntry vde = new AllVOCDataEntry(new Apexpages.Standardcontroller(voc));
        Pagereference pr = vde.cancelCustom();
        List<SelectOption> listOptions = vde.getSelectedTypeOptions();  
        vde.rIndex = 0;
        vde.copyRow();
        vde.resetAll2();
        test.stopTest();
    }
    //START Added by Kritika Bhati for S-490569 on 28/7/2017
    public static testMethod void AllVOCDataEntry6()
    {
        test.startTest();
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        //voc.Notes__c = 'Test';
        voc.City_State__c  = 'Rajasthan';
        insert voc;
             
        ApexPages.currentPage().getParameters().put('pId',a.Id);     
        AllVOCDataEntry vde = new AllVOCDataEntry(new Apexpages.Standardcontroller(voc));
        
        Pagereference pr = vde.cancelCustom();
        List<SelectOption> listOptions = vde.getSelectedTypeOptions();
        vde.rIndex = 0;
        vde.addRow();
        //vde.wrapList[0].VDE.Notes__c = 'Test';
        pr = vde.saveAll(); 
        pr = vde.saveAllAndClose();
        test.stopTest();
    }
    //End S-490569
    //Added by Kritika Bhati for S-510717 on 5/9/2017
    public static testMethod void AllVOCDataEntry7()
    {
        test.startTest(); 
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        voc.City_State__c  = 'Rajasthan';
        //voc.Notes__c = 'This simple test Cheecking';
        insert voc;

        Event__c e = new Event__c();
        e.City__c = 'tesCity';
        e.Country__c = 'testCountry';
        insert e;

        ApexPages.currentPage().getParameters().put('pId',e.Id);     
        AllVOCDataEntry vde = new AllVOCDataEntry(new Apexpages.Standardcontroller(voc));
        AllVOCDataEntry.Wrapper wrap = new AllVOCDataEntry.Wrapper();
        Pagereference pr = vde.cancelCustom();
        List<SelectOption> listOptions = vde.getSelectedTypeOptions();
        
        vde.rIndex = 0;
        vde.addRow();
        vde.rIndex = 0;
        vde.copyRow();
        wrap.VDE = voc;
        // vde.wrapList[0].vde.Notes__c = 'test';
        //vde.wrapList[0].VDE.Meeting_Date__c = null;
        pr = vde.saveAllAndClose();
        test.stopTest();
    }
     public static testMethod void AllVOCDataEntry8()
    {
        test.startTest();
        
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        voc.City_State__c  = 'Rajasthan';
        //voc.Notes__c = ' This is simple Test checking';
        insert voc;

        Event__c e = new Event__c();
        e.City__c = 'tesCity';
        e.Country__c = 'testCountry';
        
        insert e;

        ApexPages.currentPage().getParameters().put('pId',e.Id);     
        AllVOCDataEntry vde = new AllVOCDataEntry(new Apexpages.Standardcontroller(voc));
        AllVOCDataEntry.Wrapper wrap = new AllVOCDataEntry.Wrapper();
        Pagereference pr = vde.cancelCustom();
        List<SelectOption> listOptions = vde.getSelectedTypeOptions();
        vde.rIndex = 0;
        vde.addRow();
        vde.rIndex = 0;
        vde.copyRow();
        wrap.VDE = voc;
        //vde.wrapList[0].VDE.Notes__c = 'Test';
        //vde.wrapList[0].VDE.Meeting_Date__c = null;
        pr = vde.saveAllAndClose();
        test.stopTest();
    }
    //END S-510717
*/
}