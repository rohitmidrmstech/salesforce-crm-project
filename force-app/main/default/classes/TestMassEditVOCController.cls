@isTest(seeAllData=true)
public class TestMassEditVOCController 
{
    public static testmethod void unitTest1()
    {
        test.startTest();
        Event__c e = new Event__c();
        e.City__c = 'tesCity';
        e.Country__c = 'testCountry';
        insert e;
        
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;

        Lead l = new Lead();
        l.FirstName = 'test';
        l.LastName = 'class';
        l.Email = 'test.class@gmail.com';
        l.Company = 'testCompany';
        insert l;
        
       
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.Email = 'test.class@testuser.com';
        c.FirstName = 'testContact';
        c.LastName = 'classContact';
        c.MailingStreet = 'Test1';
        c.MailingCity = 'testcity1';
        c.MailingState = 'TestState';
        c.MailingPostalCode = 'TestPostal';
        c.Phone = '1234567890';
        insert c;
        
        ApexPages.currentPage().getParameters().put('pid',a.id);
        ApexPages.currentPage().getParameters().put('ids',a.id);
        MassEditVOCController mev  = new MassEditVOCController();
       
        PageReference pr =  mev.deleteAll2();
        pr = mev.cancelCustom();
        pr = mev.saveAll();
        pr = mev.saveAllAndClose();
        
        ApexPages.currentPage().getParameters().put('pid',c.id);
        ApexPages.currentPage().getParameters().put('ids',c.id);
        MassEditVOCController mev1  = new MassEditVOCController();

        PageReference pr1 =  mev1.deleteAll2();
        pr1 = mev1.cancelCustom();
        pr1 = mev1.saveAll();
        pr1 = mev1.saveAllAndClose();
        
        ApexPages.currentPage().getParameters().put('pid',l.id);
        ApexPages.currentPage().getParameters().put('ids',l.id);
        MassEditVOCController mev2  = new MassEditVOCController();

        PageReference pr2 =  mev2.deleteAll2();
        pr2 = mev2.cancelCustom();
        pr2 = mev2.saveAll();
        pr2 = mev2.saveAllAndClose();
        
        ApexPages.currentPage().getParameters().put('pid',e.id);
        ApexPages.currentPage().getParameters().put('ids',e.id);
        MassEditVOCController mev3  = new MassEditVOCController();

        PageReference pr3 =  mev3.deleteAll2();
        pr3 = mev3.cancelCustom();
        pr3 = mev3.saveAll();
        pr3 = mev3.saveAllAndClose();
        
    }
    public static testmethod void unitTest2()
    {
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        ApexPages.currentPage().getParameters().put('pid',a.id);
        ApexPages.currentPage().getParameters().put('ids',a.id);
        MassEditVOCController mev  = new MassEditVOCController();
       
        // pr =  mev.cancelCustom();
        PageReference pr = mev.saveAll();
    }
}