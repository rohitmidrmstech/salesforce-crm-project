// ==================================================================================
//   Object: testWtu 
//  Company: CT-SPG
//   Author: John Westenhaver (Sales Optimizer)
// Comments: Tests the WTU triggers. 
// ==================================================================================
//  Changes: 2011-04-20 Initial version.
// ==================================================================================

@isTest
private class testWtu
{
    public static testmethod void unitTest()
    {
        test.startTest();
        try{
            
            // Get Account record types. 
            ID primary;
            /*list<RecordType> recordTypes = 
                [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];
            for (RecordType rt : recordTypes)
            {
                if (rt.Name.startsWith('BPCS')) 
                {
                    primary = rt.Id;
                    break;
                }
            } */
            
            
            
            // Create an Account.
            Account a = new Account(Name = 'New Account'/*, RecordTypeId = primary*/); //
            a.WTU_Notes__c = 'Test Account WTU Notes';
            insert a;
            a.WTU_Notes__c = 'Changed Account Notes';
            update a;
            list<WTU_Note__c> notes = [SELECT Id FROM WTU_Note__c WHERE Account__c = :a.Id LIMIT 1];
            if (notes.size() > 0)
            {
                delete notes;
                a.WTU_Notes__c = 'Changed Account Notes Again';
                update a;
            }
            
            // Create an Opportunity.
            Opportunity o = new Opportunity(Name = 'Test Opportunity', StageName = 'New', CloseDate = system.today() + 1, AccountId = a.Id);
            o.WTU_Notes__c = 'Test Project WTU Notes';
            insert o;
            o.WTU_Notes__c = 'Changed Opportunity Notes';
            update o;
            notes = [SELECT Id FROM WTU_Note__c WHERE Project__c = :o.Id LIMIT 1];
            if (notes.size() > 0)
            {
                delete notes;
                o.WTU_Notes__c = 'Changed Opportunity Notes Again';
                update o;
            }
            
            // Create a Lead.
            Lead l = new Lead(FirstName = 'Test', LastName = 'Lead', Company = 'Test Lead Company', Email = 'test@email.com');
            l.WTU_Notes__c = 'Test Lead WTU Notes';
            insert l;
            l.WTU_Notes__c = 'Changed Lead Notes';
            update l;
            notes = [SELECT Id FROM WTU_Note__c WHERE Lead__c = :l.Id LIMIT 1];
            if (notes.size() > 0)
            {
                delete notes;
                l.WTU_Notes__c = 'Changed Lead Notes Again';
                update l;
            }
            o.Zip_Code__c = '10254';
            Update o;
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }
        test.stopTest();
    }

    public static testmethod void unitTest2()
    {
        test.startTest();
        try{
                // Get Account record types. 
            ID primary;
            /*list<RecordType> recordTypes = 
                [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];
            for (RecordType rt : recordTypes)
            {
                if (rt.Name.startsWith('BPCS')) 
                {
                    primary = rt.Id;
                    break;
                }
            } */
            
            
            
            // Create an Account.
            Account a = new Account(Name = 'New Account'/*, RecordTypeId = primary*/); //
            a.WTU_Notes__c = 'Test Account WTU Notes';
            insert a;
            a.WTU_Notes__c = 'Changed Account Notes';
            update a;
            list<WTU_Note__c> notes = [SELECT Id FROM WTU_Note__c WHERE Account__c = :a.Id LIMIT 1];
            if (notes.size() > 0)
            {
                delete notes;
                a.WTU_Notes__c = 'Changed Account Notes Again';
                update a;
            }
            
            // Create a Contact.
            Contact c = new Contact(FirstName = 'Test', LastName = 'Lead', AccountId = a.Id, Email = 'test@email.com');
            c.WTU_Notes__c = 'Test Contact WTU Notes';
            insert c;
            c.WTU_Notes__c = 'Changed Contact Notes';
            update c;
            notes = [SELECT Id FROM WTU_Note__c WHERE Contact__c = :c.Id LIMIT 1];
            if (notes.size() > 0)
            {
                delete notes;
                c.WTU_Notes__c = 'Changed Contact Notes Again';
                update c;
            }
            
            // Create a Sales Call (aka Event).
            Event e = new Event(StartDateTime = system.now(), EndDateTime = system.now() + 1, WhatId = a.Id, WhoId = c.Id, OwnerId = userInfo.getUserId());
            e.WTU_Notes__c = 'Test Sales Call WTU Notes';
            insert e;
            e.WTU_Notes__c = 'Changed Sales Call Notes';
            update e;
            notes = [SELECT Id FROM WTU_Note__c WHERE Event_ID__c = :e.Id LIMIT 1];
            if (notes.size() > 0)
            {
                delete notes;
                e.WTU_Notes__c = 'Changed Sales Call Notes Again';
                update e;
            }
            
            // Create a Task.
            Task t = new Task(ActivityDate = system.today(), WhatId = a.Id, WhoId = c.Id, OwnerId = userInfo.getUserId());
            t.WTU_Notes__c = 'Test Task WTU Notes';
            insert t;
            t.WTU_Notes__c = 'Changed Task Notes';
            update t;
            notes = [SELECT Id FROM WTU_Note__c WHERE Task_ID__c = :t.Id LIMIT 1];
            if (notes.size() > 0)
            {
                delete notes;
                t.WTU_Notes__c = 'Changed Task Notes Again';
                update t;
            }
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }
        test.stopTest();
    }
}