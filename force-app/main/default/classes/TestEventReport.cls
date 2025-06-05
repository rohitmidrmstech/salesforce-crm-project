@isTest (seeAllData = true)
public class TestEventReport
{
    public static testMethod void unitTest0()
    {
        test.startTest();
       
        Lead Ld = new Lead(FirstName ='Test2');
        Ld.LastName ='Test';
        Ld.Company ='tttt';
        Ld.Email ='terter@gmail.com';
        Ld.Country ='US';
        insert Ld;
        
        Account a = new Account(Name='Test');
        insert a;
        
        Contact Con = new Contact(FirstName='TestALL');
        Con.LastName='Test';
        Con.Email='fdfdf@ffff.com';
        Con.MailingCountry='ggg';
        Con.AccountId = a.Id;
        Con.MailingStreet = 'Test1';
        Con.MailingCity = 'Newyork';
        Con.MailingState = 'rajasthan';
        Con.otherphone='12345';
        Con.Phone = '1234567890';
        Con.MailingPostalCode = '987654321a';
        insert Con;
        
        Event__c Evt = new Event__c(Name ='test');
        Evt.Audience__c='builder';
        Evt.City__c ='test';
        Evt.Country__c ='US' ;
        Evt.Notes__c ='Test';
        Evt.State__c ='California';
        Evt.Source__c ='Retailer';
        insert Evt;
        
        Event_Attendee__c temp1 = new Event_Attendee__c();
        temp1.Name = Ld.FirstName;
        temp1.Event__c = Evt.Id;
        temp1.Lead__c = Ld.Id;
        insert temp1;
        ApexPages.currentPage().getParameters().put('id',Evt.id);
        
        EventReportController sa = new EventReportController (new Apexpages.Standardcontroller(Evt));
        sa.searchItemAttendee = 'Te';
        Id [] fixedSearchResults= new Id[]{};
        fixedSearchResults.add(Con.Id);
        fixedSearchResults.add(Ld.Id);
        Test.setFixedSearchResults(fixedSearchResults);
        sa.searchAttendees();
        sa.showPopup();
        sa.quickCreatedLead.LastName = 'TestL';
        sa.quickCreatedLead.FirstName = 'TestF';
        sa.quickCreatedLead.Company = 'TestF';
        sa.closePopup();
        sa.deleteAllExistingAttendees();
        sa.cancelPopup();
        sa.addSelectedAsAttendees();
        test.stopTest();
    }   
    public static testMethod void unitTest1()
    {
        test.startTest();
       
        Lead Ld = new Lead(FirstName ='Test2');
        Ld.LastName ='Test';
        Ld.Company ='tttt';
        Ld.Email ='terter@gmail.com';
        Ld.Country ='US';
        insert Ld;
        
        Account a = new Account(Name='Test');
        insert a;
        
        Contact Con = new Contact(FirstName='TestALL');
        Con.LastName='Test';
        Con.Email='fdfdf@ffff.com';
        Con.MailingCountry='ggg';
        Con.AccountId = a.Id;
        Con.MailingStreet = 'Test1';
        Con.MailingCity = 'Newyork';
        Con.MailingState = 'rajasthan';
        Con.otherphone='12345';
        Con.Phone = '1234567890';
        Con.MailingPostalCode = '987654321a';
        
        insert Con;
        
        Event__c Evt = new Event__c(Name ='test');
        Evt.Audience__c='builder';
        Evt.City__c ='test';
        Evt.Country__c ='US' ;
        Evt.Notes__c ='Test';
        Evt.State__c ='California';
        Evt.Source__c ='Retailer';
        insert Evt;
      //START Modified by Kritika Bhati on 31/7/2017 for S-490568
        List<Event_Attendee__c> eventAttendeeList = new List<Event_Attendee__c>();
        Event_Attendee__c temp1 = new Event_Attendee__c();
        temp1.Name = Ld.FirstName;
        temp1.Event__c = Evt.Id;
        temp1.Lead__c = Ld.Id;
        //insert temp1;
        
    

        
        Event_Attendee__c temp2= new Event_Attendee__c();
        temp2.Name = Ld.FirstName;
        temp2.Event__c = Evt.Id;
        temp2.Contact__c = Con.Id;
        //insert temp2;
        eventAttendeeList.add(temp1);
        eventAttendeeList.add(temp2);
        insert eventAttendeeList;
        //END S-490568
    }
    //START Added by Kritika Bhati for S-510717 on 5/9/2017
    public static testMethod void unitTest2()
    {
        test.startTest();
       
        Lead Ld = new Lead(FirstName ='Test2');
        Ld.LastName ='Test';
        Ld.Company ='tttt';
        Ld.Email ='terter@gmail.com';
        Ld.Country ='US';
        insert Ld;
        
        Account a = new Account(Name='Test');
        insert a;
        
        Contact Con = new Contact(FirstName='TestALL');
        Con.LastName='Test';
        Con.Email='fdfdf@ffff.com';
        Con.MailingCountry='ggg';
        Con.AccountId = a.Id;
        Con.MailingStreet = 'Test1';
        Con.MailingCity = 'Newyork';
        Con.MailingState = 'rajasthan';
        Con.otherphone='12345';
        Con.Phone = '1234567890';
        Con.MailingPostalCode = '987654321a';
        insert Con;
        
        Contact Con1 = new Contact(FirstName='TestFew');
        Con1.LastName='Teskskt';
        Con1.Email='fdfdfxzcx@ffff.com';
        Con1.MailingCountry='zxcv';
        Con1.AccountId = a.Id;
        Con1.MailingStreet = 'Test2';
        Con1.MailingCity = 'Newyork';
        Con1.MailingState = 'rajasthan';
        Con1.otherphone='123465';
        Con1.Phone = '123456766890';
        Con1.MailingPostalCode = '98766654321a';
        insert Con1;
        
        Event__c Evt = new Event__c(Name ='test');
        Evt.Audience__c='builder';
        Evt.City__c ='test';
        Evt.Country__c ='US' ;
        Evt.Notes__c ='Test';
        Evt.State__c ='California';
        Evt.Source__c ='Retailer';
        insert Evt;
        
        Event_Attendee__c temp1 = new Event_Attendee__c();
        temp1.Name = Ld.FirstName;
        temp1.Event__c = Evt.Id;
        temp1.Lead__c = Ld.Id;
        insert temp1;
        
        ApexPages.currentPage().getParameters().put('id',Evt.id);
        
        EventReportController sa = new EventReportController (new Apexpages.Standardcontroller(Evt));
        sa.searchItemAttendee = 'Te';
        Id [] fixedSearchResults= new Id[]{};
        fixedSearchResults.add(Con.Id);
        fixedSearchResults.add(Ld.Id);
        //Test.setFixedSearchResults(fixedSearchResults);
        sa.searchAttendees();
        sa.showPopup();
        sa.quickCreatedLead.LastName = 'TestL';
        sa.quickCreatedLead.FirstName = 'TestF';
        sa.quickCreatedLead.Company = 'TestF';
        sa.closePopup();
        sa.deleteAllExistingAttendees();
        sa.cancelPopup();
        List<EventReportController.contactWrapper> objWrapList = new List<EventReportController.contactWrapper>();
        EventReportController.contactWrapper objWrap = new EventReportController.contactWrapper();
        objWrap.con = con1;
        objWrap.isChecked = true;
        objWrap.rIndex = 2;
        objWrapList.add(objWrap);
        sa.conList = objWrapList;
        sa.addSelectedAsAttendees();
        List<EventReportController.leadWrapper> ldList = new List<EventReportController.leadWrapper>();
        
        EventReportController.leadWrapper objLead = new EventReportController.leadWrapper();
        objLead.ld = Ld;
        objLead.isChecked = true;
        objLead.rIndex = 2;
        ldList.add(objLead);
        sa.ldList = ldList;
        test.stopTest();
        
    }
    //END S-510717
}