@istest
class NPSemailSentScheduler_Test {
        @isTest(SeeAllData = false)
    static void test() {
        User userRecord = initTestUser('Testing1');
        System.runAs(userRecord){
            List<RecordType> accountRecord1 = [SELECT Id, Name, DeveloperName FROM RecordType where sobjectType = 'account' AND NAME = 'Ship-To' limit 1];
            List<RecordType > recordTypes = [SELECT Id, Name, DeveloperName FROM RecordType where sobjectType = 'contact' and DeveloperName ='Gypsum_USA_Contact' limit 1];
            
            
            Account ac = new Account();
            Id devRecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payer').getRecordTypeId();
            ac.RecordTypeId = accountRecord1[0].id;
            ac.Name = 'TestAccount';
            ac.BillingCountry = 'USA';
            ac.BillingState = 'TX';
            ac.Shipping_Condition_Desc__c = 'TestAccountRAIL';
            insert ac;
            
            Contact cont = new Contact();
            cont.Survey_Email_Sent__c = true;
            Id devRecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Gypsum USA Contact').getRecordTypeId();
            cont.RecordTypeId = recordTypes[0].id;

            cont.FirstName='fname';
            cont.LastName = 'lname';
            cont.Email = 'email@gmail.com';
            cont.Email_Opt_Out__c = false;
            cont.Phone = '9743800309';
            cont.MailingStreet = 'ABC'; 
            cont.MailingCity  = 'ABC';
            cont.MailingState = 'ABC';
            cont.MailingPostalCode = '350250';
            cont.Status__c = 'Active';
            cont.Contact_Type__c  = 'Dealer';
            cont.Survey_Email_Sent__c  = true;
            cont.accountid = ac.id;
            cont.Survey_Sent_Date__c = date.today() - 90;
            insert cont;
            
            Test.startTest();
                NPSemailSentScheduler nps = new NPSemailSentScheduler();
                String sch = '0 0 23 * * ?';
                system.schedule('Test status Check', sch, nps );
            Test.stopTest();
        }
    }

    private static user initTestUser(String userName){
        Profile userPrf = [select id from profile where name='System Administrator'];
        User userRecord = new User(emailencodingkey     = 'UTF-8',
                                    languagelocalekey   = 'en_US',
                                    localesidkey        = 'en_US',
                                    timezonesidkey      = 'America/Los_Angeles',
                                    alias               = 'Tstr', 
                                    lastname            = userName,
                                    email               = userName + '@testorg.com',
                                    profileid           = userPrf.Id, 
                                    username            = userName + UserInfo.getOrganizationId() + '@testorg.com',
                                    sales_org__c        = '1502');
        Insert userRecord;
        return userRecord;
    }
}