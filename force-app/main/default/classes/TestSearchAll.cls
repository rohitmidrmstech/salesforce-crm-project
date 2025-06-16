@isTest (seeAllData = true)
public class TestSearchAll
{
/*
 * History:
* - VERSION  DEVELOPER NAME                  DATE            DETAIL FEATURES/CSR/TTP
    1.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
    public static testMethod void unitTest0()
    {
        test.startTest();
        ProDialogue_Input__c VOC = new ProDialogue_Input__c();
        Account a = new Account(Name = 'Test');
        insert a;
        Lead Ld = new Lead(FirstName ='xxx');
        
        Ld.LastName ='vvv';
        Ld.Company ='tttt';
        Ld.Email ='terter@gmail.com';
        Ld.Country ='US';
        insert Ld;
        
        Contact Con = new Contact(FirstName='TestALL');
        
        Con.LastName='fdfdf';
        Con.AccountId=a.id;
        Con.Email='fdfdf@ffff.com';
        Con.MailingCountry='ggg';
        Con.MailingStreet = 'Test1';
        Con.MailingCity = 'Newyork';
        Con.MailingState = 'rajasthan';
        Con.otherphone='12345';
        Con.MailingPostalCode = '987654321a';
        Con.Phone = '1234567890';
        //insert Con;
        
        Event__c Evt = new Event__c(Name ='test');
        Evt.Audience__c='builder';
        Evt.City__c ='test';
        Evt.Country__c ='US' ;
        Evt.Notes__c ='Test';
        Evt.State__c ='California';
        Evt.Source__c ='Retailer';
        insert Evt;
         
        SearchAll sa= new SearchAll(new Apexpages.Standardcontroller(VOC));
        sa.searchString= 'Test';
        //sa.selectRecord();
        
        
        PageReference pr = sa.doSearch();
        String selId = ApexPages.CurrentPage().getParameters().get('conid');
        pr = sa.save();
        pr = sa.closePopup();
        pr = sa.cancelPopup();
        sa.showPopup();
        //START Added by Kritika Bhati for S-510717 on 5/9/2017
        sa.newVoc(); 
        Event__c ev = sa.evt;
        List<Event_Attendee__c> eventList = sa.addedAttendees;
        String st = sa.eventId;
        Set<Id> exSet = sa.existingAttendeeIdSet;
        Boolean b = sa.showAddedAttendees;
        String st1  = sa.eventBackMsg;
        Boolean b1 = sa.showAddAttendees;
        SA.selectRecord();
        String st2 = sa.objectName;
        //END S-510717
        test.stopTest();
    }
   */
}