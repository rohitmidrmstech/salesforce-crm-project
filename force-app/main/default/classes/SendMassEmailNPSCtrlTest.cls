@isTest
private class SendMassEmailNPSCtrlTest {
   
    @isTest(SeeAllData = true)
    static void test_EmailTemplateData(){
        EmailTemplate e = [Select Id, Name from EmailTemplate Where Name LIKE 'Gypsum NPS Survey Custom' LIMIT 1];
    }
    
    /*@testSetup static void setup() {
    //EmailTemplate e = new EmailTemplate (developerName = 'test', FolderId = '00l0V000002FPunQAG', TemplateType= 'Text', Name = 'Gypsum NPS Survey Custom');
    //Insert e;
    System.debug('e'+e);
    }*/

    
    static testMethod void test_method1(){
            
        List<RecordType> accountRecord1 = [SELECT Id, Name, DeveloperName FROM RecordType where sobjectType = 'account' AND NAME = 'Ship-To' limit 1];
        List<RecordType > recordTypes = [SELECT Id, Name, DeveloperName FROM RecordType where sobjectType = 'contact' and DeveloperName ='Gypsum_USA_Contact' limit 1];
        
        
        UserRole portalRole = [Select Id From UserRole Where PortalType = 'None' Limit 1];
        system.debug('portalRole is ' + portalRole);
        
        Profile profile1 = [Select Id from Profile where name = 'USA TM User'];
        User portalAccountOwner1 = new User( 
            UserRoleId = portalRole.Id,
            ProfileId = profile1.Id,
            Username = System.now().millisecond() + 'test2@test.com',
            Alias = 'test',
            Email='test@gmail.com',
            EmailEncodingKey='UTF-8',
            Firstname='portal',
            Lastname='user',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            TimeZoneSidKey='America/Chicago'
        );
        Database.insert(portalAccountOwner1);
        
        System.runAs ( portalAccountOwner1 ) {
            
            
        
        NPS_Survey_Week_Counter__c npsOne = new NPS_Survey_Week_Counter__c();
        npsOne.Name = 'Test';
        npsOne.Week_Counter__c = 2;
        npsOne.Total_Week__c = 13;
        Insert npsOne;
     
        // plus any other fields that you want to set

        
        Account accountRecord = new Account();
        accountRecord.Name = 'TestAccount';
        accountRecord.BillingCountry = 'USA';
        accountRecord.BillingState = 'TX';
        accountRecord.Shipping_Condition_Desc__c = 'TestAccountRAIL';
        accountRecord.RecordTypeId = accountRecord1[0].id;
        accountRecord.OwnerId = portalAccountOwner1.id;
        insert accountRecord;
        
        List<Contact> contactRecordList = new List<Contact>();
        for(integer i=0 ; i<50 ;i++){
            Contact con = new Contact(
                FirstName='fname',
                LastName = 'lname',
                Email = 'email@gmail.com',
                Email_Opt_Out__c = false,
                Phone = '9743800309', 
                MailingStreet = 'ABC', 
                MailingCity  = 'ABC',
                MailingState = 'ABC',
                MailingPostalCode = '350250',
                Status__c = 'Active',
                Contact_Type__c  = 'Dealer',
                Survey_Email_Sent__c  = false,
                accountid = accountRecord.id,
                recordTypeId = recordTypes[0].Id
            );             
            contactRecordList.add(con);
        }
        //insert contactRecordList;
        
        //List<NPS_Survey_Filters__mdt> filterList = [SELECT Label, Where_Condition__c FROM NPS_Survey_Filters__mdt];
        Test.startTest();
        Apexpages.StandardSetController sc = new Apexpages.StandardSetController(contactRecordList);
       
        SendMassEmailNPSCtrl cls = new SendMassEmailNPSCtrl(sc);
        insert contactRecordList;
        cls.actionOnLoad();
        cls.listView = 'Gypsum NPS Survey List';
        cls.contactCount = 2;
        test_EmailTemplateData();
        EmailTemplate e = [Select Id, Name from EmailTemplate Where Name LIKE 'Gypsum NPS Survey Custom' LIMIT 1];
        cls.emailTemplate = e.Id;
        cls.sendEmailToContacts();
        Test.stopTest();
        }
        
    }
 
}