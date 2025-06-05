/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestPopulateRegiononActivites {

    static testMethod void myUnitTest() {
         test.starttest();
        
         // Create Region
        Region__c r = new Region__c(Name='Southeast', Zip_Code__c='73455');
        insert r;
        
        // Create Account
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingPostalCode = '73455-0001';
        a.BillingCity = 'NY';
        a.Region__c = r.Id;
        
        for(RecordType rt: [Select Id From RecordType Where Name = 'Gypsum USA Customer' AND SObjectType = 'Account']){
            a.RecordTypeId = rt.Id;
        }
        insert a;
        
        //Create Contact
        Contact c = new Contact();
        c.AccountId = a.Id;
        c.LastName = 'Test';
        c.MailingStreet = 'Test';
        c.MailingCity = 'Test';
        c.MailingState = 'New York';
        c.MailingPostalCode = '10254';
        c.Phone='6106661235'; //S-493803 [Hemant 9/8/2017] - Fix Test Failures
         
        for(RecordType rt: [Select Id From RecordType Where Name = 'Gypsum USA Contact' AND SObjectType = 'Contact']){
            c.RecordTypeId = rt.Id;
        }
        insert c;
        
        //Create Task;
        Task t = new Task();
        t.WhatId = a.Id;
        t.Subject = 'Testing';
        t.ActivityDate = system.today();
        //t.Region__c = r.Name;
        
        //Create event       
        Event e  = new Event();
        e.WhatId = a.Id;
        e.Subject = 'Testing';
        e.ActivityDateTime = system.today();
        //e.Region__c = r.Name;
        e.DurationInMinutes = 0;
        
        for(RecordType rt: [Select Id From RecordType Where Name = 'USA Task' AND SObjectType = 'Task']){
            t.RecordTypeId = rt.Id;
        }
        insert t;
        
        for(RecordType rt: [Select Id From RecordType Where Name = 'USA Event' AND SObjectType = 'Event']){
            e.RecordTypeId = rt.Id;
        }
        insert e;
        
        
            
        //Create Task;
        Task t1 = new Task();
        t1.WhoId = c.Id;
        t1.Subject = 'Testing';
        t1.ActivityDate = system.today();
        //t1.Region__c = r.Name;
        
        //Create event       
        Event e1  = new Event();
        e1.WhoId = c.Id;
        e1.Subject = 'Testing';
        e1.ActivityDateTime = system.today();
        //e1.Region__c = r.Name;
        e1.DurationInMinutes = 0;
        
        for(RecordType rt: [Select Id From RecordType Where Name = 'USA Task' AND SObjectType = 'Task']){
            t1.RecordTypeId = rt.Id;
        }
        insert t1;
        
        for(RecordType rt: [Select Id From RecordType Where Name = 'USA Event' AND SObjectType = 'Event']){
            e1.RecordTypeId = rt.Id;
        }
        insert e1;
        Opportunity o = new Opportunity(Name = 'Test Opportunity', StageName = 'New', CloseDate = system.today() + 1, AccountId = a.Id);
        insert o;
        e1.WhatId = o.Id;
        Update e1;
        
        t1.WhatId = o.Id;
        Update t1;
        
        // Check of field populattion based on trigger
        for(Task acc: [Select Id,/*Region__c,*/WhatId From Task Where Id = : t.Id ]) {
            if(acc.WhatId != null){
            //system.assertEquals(acc.Region__c, r.Name);
            }
            else{
                //system.assertEquals(acc.Region__c, c.Region__c);
            
            }
        }
        
         // Check of field populattion based on trigger
        for(Event acc: [Select Id,/*Region__c,*/WhatId From Event Where Id = : t.Id ]) {
            if(acc.WhatId != null){
            //system.assertEquals(acc.Region__c, a.Region__r.Name);
            }
            else{
                //system.assertEquals(acc.Region__c, c.Region__c);
            
            }
        }
        
        test.stoptest();
    }
    }