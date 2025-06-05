@isTest
public class LeadConverterTest {
    @testSetup static void createAccountsAndLeads(){
        Account accObj = new Account();
        accObj.Name = 'Test';
        
        insert accObj;
        
        Contact conObj = new Contact();
        conObj.LastName = 'test';
        conObj.AccountId = accObj.id;
        conObj.Phone = '7878437844';
        conObj.MobilePhone = '4567890567';
        conObj.Fax = '34567890678';
        conObj.otherphone = '456789056789';
        conObj.HomePhone = '3456789';
        conObj.lastName = 'Test';
        conObj.MailingStreet = 'Test Street';
        conObj.MailingCity = 'Test';
        conObj.MailingState = 'Test1';
        conObj.MailingPostalCode = '987654321a';
        insert conObj;
        
        Lead leadObj = new Lead();
        leadObj.lastName = 'Test Lead';
        leadObj.company = 'Test';
        leadObj.Status = 'Open - Not Contacted';
        leadObj.phone = 'phone';
       
        leadObj.Fax = '7897893933';
        
        insert leadObj;
        
    }
    public static testmethod void testLeadConverter(){
        Lead leadObj = [select id, Name, company, Status, phone,Fax from lead];
        Test.startTest();
            LeadConverter.c_Lead leadObject = new LeadConverter.c_Lead(leadObj);
            leadObject.getLead();
            leadObject.setLead(leadObj);
            leadObject.getRelatedContacts();
            
            leadObject.addRelatedContacts(leadObj);
            leadObj.Phone = 'test';
            update leadObj;
            leadObject.addRelatedContacts(leadObj);
            leadObject.getRelatedContactLeads();
           
            Account accObj = [Select name, phone, BillingStreet, (select id, lastname, phone, HomePhone, fax, OtherPhone,  mobilephone from Contacts)
                              from Account];
            
            leadObject.setAccount(accObj);
        	leadObject.getAccount();
            leadObject.getAccountId();
            leadObject.setAccountId(accObj.id);
            leadObject.getDupAccounts();
            leadObject.addDupAccounts(accObj);
            leadObject.getAccounts();
            leadObject.getHasMultipleAccounts();
            leadObject.getHasMultipleContacts();
            leadObject.getRelatedContactValues();
            //null lead phone
            leadObj.Phone = null;
            update leadObj;
        
        
        Contact conObject = [select name, phone, fax from Contact];
        conObject.MailingStreet = 'Test Street';
        conObject.MailingCity = 'Test';
        conObject.MailingState = 'Test1';
        conObject.MailingPostalCode = '987654321a';
        conObject.Phone = '1234567890';
        conObject.MobilePhone = '4567890567';
        conObject.Fax = '34567890678';
        conObject.otherphone = '456789056789';
        conObject.HomePhone = '3456789';
        update conObject;
        
        
        
            LeadConverter.c_Lead leadObject1 = new LeadConverter.c_Lead(leadObj);
            leadObject1.getPhone(conObject);
            leadObj.Fax = null;
            update leadObj;
        
            LeadConverter.c_Lead leadObject2 = new LeadConverter.c_Lead(leadObj);
            leadObject2.getPhone(conObject);
            conObject.mobilephone = null;
            update conObject;
        
            LeadConverter.c_Lead leadObject3 = new LeadConverter.c_Lead(leadObj);
            leadObject3.getPhone(conObject);
        
         List<Lead> leadLst = new List<Lead>();
        leadLst.add(leadObj);
        //c_ContactLead class methods
        LeadConverter.c_ContactLead contactLeadObj = new LeadConverter.c_ContactLead(leadObj);
        contactLeadObj.getHasMultipleContacts();
        contactLeadObj.getContacts();
        
        List<contact> conList = new List<Contact>();
        conList.add(conObject);
        contactLeadObj.setContactId(conObject.id);
        
        contactLeadObj.getLead();
        contactLeadObj.setLead(leadObj);
        contactLeadObj.getLeadProcessed();
        contactLeadObj.getDupContacts();
       // contactLeadObj.startConversion(leadObj);
        contactLeadObj.setLeadProcessed(true);
        contactLeadObj.setDupContacts(conList);
        contactLeadObj.addDupContacts(conObject );
        contactLeadObj.setRelatedLeads(leadLst);
        contactLeadObj.getContactId();
        contactLeadObj.getContact();
        contactLeadObj.setContact(conObject);
        
        LeadConverter leadConverterObj = new LeadConverter();
        leadConverterObj.CreateCustomLeadswAccounts(leadLst);
        
           
        List<LeadConverter.c_Lead> c_LeadLst = new List<LeadConverter.c_Lead>();
         c_LeadLst.add(leadObject);
        //c_LeadLst.add(leadConverterObj);
        leadConverterObj.getAccountSelRedirect(c_LeadLst);
        leadConverterObj.getContactSelRedirect(c_LeadLst);
        leadConverterObj.startConversion(c_LeadLst);
        //2nd constructor
        leadObj.Lead_Source_Record_Type__c = 'Dodge Lead';
        update leadObj;
        LeadConverter leadConverterObj1 = new LeadConverter();
        leadConverterObj1.startConversion(c_LeadLst);
        Test.stopTest();
    }
    @isTest
    public static void testaiuWtuLeadaiuWtuContact(){
        Test.startTest();
        Id sidingLeadId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Siding Lead').getRecordTypeId();
        Lead leadObj = new Lead();
        leadObj.lastName = 'Test Lead 111';
        leadObj.company = 'Test';
        leadObj.Status = 'Open - Not Contacted';
        leadObj.phone = 'phone';
        leadObj.recordtypeid = sidingLeadId;
        leadObj.Fax = '7897893933';
        leadObj.WTU_Notes__c = 'TestingTrigger';
        insert leadObj;
        leadObj.WTU_Notes__c = 'TestingTrigger1';
        update leadObj;
        Test.stopTest();
        
    	Id certainTeedContactId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('CertainTeed Contact').getRecordTypeId();
        Contact conObj = new Contact();
        conObj.recordtypeid = certainTeedContactId;
        conObj.firstname = 'certainTeedContactId';
        conObj.LastName = 'test';
        conObj.Phone = '7878437844';
        conObj.MobilePhone = '4567890567';
        conObj.Fax = '34567890678';
        conObj.otherphone = '456789056789';
        conObj.HomePhone = '3456789';
        conObj.lastName = 'Test';
        conObj.MailingStreet = 'Test Street';
        conObj.MailingCity = 'Test';
        conObj.MailingState = 'Test1';
        conObj.MailingPostalCode = '987654321a';
        conObj.WTU_Notes__c = 'TestingTrigger';
        insert conObj;
        conObj.WTU_Notes__c = 'TestingTrigger';
        update conObj;
    }
}