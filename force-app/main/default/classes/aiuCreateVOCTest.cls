/************************
 Creadted by : Kritika Bhati
 Created Date : 27/7/2017
 Description : Test class for aiuCreateVOC S-490569
 
 ***********************/
@isTest

public class aiuCreateVOCTest {
  
    static testMethod void testCaseTrigger(){
    
         Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        Contact con = new Contact(LastName= 'Test',MailingStreet = 'Test', MailingCity = 'testcity', MailingState='testState',Phone= '1234567890', MailingPostalCode='testpostal');
        insert con;
        Id rtId = [Select Id from RecordType where sObjectType='Event' and Name='New Event'].Id;
        
      
        
        Event e = new Event();
        e.WhatId  = a.id;
        e.WhoId = con.id;
        e.Category__c = 'New Product Idea';
        e.Comments__c = ' test Comment';
        e.Sub_Category__c = 'ICC';
        e.Action_Plan__c = 'Test';
        e.RecordTypeId = rtId;
        e.DurationInMinutes = 10000;
        e.Sub_Category_Ins__c = 'Other';
        e.ActivityDateTime = system.today();
        
        insert e;
        
         
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Contact__c = con.id;
        voc.Sub_Category__c ='Test';
        voc.Information_Source__c = 'TestInformattion';
        voc.Priority__c = 'Normal';
        voc.Category__c = 'Test';
        //voc.Notes__c = 'TestNotes';
      
        voc.Created_Date__c = System.today();
        voc.Activities_Id__c = e.id;
        voc.City_State__c = 'TestCityState';
        insert voc;
      
        e.Category__c = 'new Category';
       
        update e;
        
        ProDialogue_Input__c voc1 = new ProDialogue_Input__c();
        voc1.Account__c = a.Id;
        voc1.City_State__c = 'TestStateCity';
        voc1.Created_Date__c = System.today();
        
        insert voc1;
    
    }
    
    static testMethod void unitTest(){
    
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        Contact con = new Contact(LastName= 'Test',MailingStreet = 'Test1', MailingCity = 'testcity1', MailingState='testState1',Phone= '1234567890', MailingPostalCode='test1postal');
        insert con;
        Id rtId = [Select Id from RecordType where sObjectType='Event' and Name='New Event'].Id;
      
        Event e = new Event();
        e.WhatId = a.id;
        e.WhoId = con.id;
        e.Comments__c = ' test Comment';
        e.Sub_Category__c = 'Test';
        e.Action_Plan__c = 'Test';
        e.DurationInMinutes = 10000;
        e.ActivityDateTime = system.today();
        insert e;
        
        e.Category__c =' new Category';
        update e;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Activities_Id__c = e.id;
        voc.Category__c = 'Test';
        voc.Sub_Category__c = 'Test';
        //voc.Notes__c = 'Test Notes';
        voc.Information_Source__c = 'TestInformation';
        voc.Priority__c = 'Normal';
        voc.City_State__c = 'TestCityState';
        voc.Created_Date__c = System.today();
        voc.Activities_Id__c = e.Id;
        insert voc;
     
    }
}