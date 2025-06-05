@isTest (seeAllData = false)
public class TestaiuCreateVOC
{
    public static testMethod void unitTest0()
    {
        test.startTest();  
        Contact contactRecord = new Contact(LastName ='TestContact');
        contactRecord.Email='fdfdfxzcx@ffff.com';
        contactRecord.MailingCountry='zxcv';
        contactRecord.MailingStreet = 'Test2';
        contactRecord.MailingCity = 'Newyork';
        contactRecord.MailingState = 'rajasthan';
        contactRecord.otherphone='123465';
        contactRecord.Phone = '123456766890';
        contactRecord.MailingPostalCode = '98766654321a';
        insert contactRecord ;
        Lead  leadRecord = new Lead(LastName = 'TestLead', Company = 'TestCompany');
        insert leadRecord;
        Account accountRecord = new Account(Name ='TestAccount');
        insert accountRecord;
        Event__c eventRecord = new Event__C(Name = 'TestEvent');
        insert eventRecord;
        
        Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p2.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.IsActive = TRUE;
        u1.Sales_Org__c = '1006';
        insert u1;
        
        RecordType rt = [select id,Name from RecordType where SobjectType='Task' and Name='Sales Task' Limit 1];
        RecordType rt1 = [select id,Name from RecordType where SobjectType='Event' and Name='New Event' Limit 1];
        
        Task t = new Task();
        t.RecordTypeid = rt.id;
        t.Category__c = 'Channel Comment';
        t.sub_category_ins__c = 'Web';               
        t.Source__c = 'Retailer';
        t.Comments__c ='test1';
        t.Status = 'Work in Progress';
        t.Priority ='High';
        t.Type = 'Personal';
        t.Ownerid = u1.id;
        t.Subject = 'Training';
        t.Activity_Type__c = 'Market Development';  
        insert t;
        
        Event e = new Event();
        e.RecordTypeid = rt1.id; 
        e.Category__c = 'Channel Comment';
        e.sub_category_ins__c = 'Web';
        e.Source__c = 'Retailer';
        e.Comments__c ='test1';
        e.Subject = 'Complaint';
        //e.State__c = 'Arizona';
        e.WhoId = leadRecord.id;  
        e.Ownerid = u1.id;             
        e.StartDateTime = date.today();
        e.EndDateTime = date.today();
        insert e;
        
        Event e1 = new Event();
        e1.RecordTypeid = rt1.id; 
        e1.Category__c = 'Channel Comment';
        e1.sub_category_ins__c = 'Web';
        e1.Source__c = 'Retailer';
        e1.Comments__c ='test1';
        e1.Subject = 'Complaint';
        e1.WhoId = contactRecord.id;  
        e1.Ownerid = u1.id;             
        e1.StartDateTime = date.today();
        e1.EndDateTime = date.today();
        insert e1;                 
        
        Event e2 = new Event();
        e2.RecordTypeid = rt1.id; 
        e2.Category__c = 'Channel Comment';
        e2.sub_category_ins__c = 'Web';
        e2.Source__c = 'Retailer';
        e2.Comments__c ='test1';
        e2.Subject = 'Complaint';
        //e2.AccountId = accountRecord.id;
        e2.Ownerid = u1.id;             
        e2.StartDateTime = date.today();
        e2.EndDateTime = date.today();
        insert e2; 
        
        ProDialogue_Input__c proDialoguInuputRecord =new ProDialogue_Input__c();
        proDialoguInuputRecord.Activities_Id__c = e.id;
        proDialoguInuputRecord.City_State__c = 'Arizona';
        proDialoguInuputRecord.Category__c = e.Category__c;
        proDialoguInuputRecord.sub_category__c = e.sub_category_ins__c;
        //proDialoguInuputRecord.Notes__c = e.Comments__c;
        insert proDialoguInuputRecord;
        
        t.Source__c = 'Survey';
        t.Comments__c ='test2';
        update t;
        
        e.Source__c = 'Survey';  
        e.Comments__c ='test2';
        update e;  
        
        delete e; 
        
        test.stopTest();
        
    }
}