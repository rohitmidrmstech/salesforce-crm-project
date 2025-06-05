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
private class Test_ConvertLeads_Controller {

    static testMethod void myUnitTest() {
        //Create Test Accounts
        List<Account> testAccs = new List<Account>();
        
            Account acc = new Account(name='company1');
            testAccs.add(acc);
            Account acc2 = new Account(name='company1');
            testAccs.add(acc2);
            Account acc3 = new Account(name='othervalue');
            testAccs.add(acc3);
            
            insert testAccs;
        
        //Create Test Contacts
        List<Contact> testCons = new List<Contact>();
        
            Contact c1 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,otherphone='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingState = 'rajasthan',MailingPostalCode = '987654321a',Phone = '1234567890');
            testCons.add(c1);
            Contact c2 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,fax='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingState = 'rajasthan',MailingPostalCode = '987654321a',Phone = '1234567890');
            testCons.add(c2);
            Contact c3 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingState = 'rajasthan',MailingPostalCode = '987654321a',Phone = '1234567890');
            testCons.add(c3);
            Contact c4 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,mobilephone='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingState = 'rajasthan',MailingPostalCode = '987654321a',Phone = '1234567890');
            testCons.add(c4);
            Contact c5 = new Contact(firstname='test',lastname='contact',AccountId=acc3.id,homephone='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingState = 'rajasthan',MailingPostalCode = '987654321a',Phone = '1234567890');
            testCons.add(c5);                   
            insert testCons;    
        
            
        //Create Test Leads
        List<Lead> testLeads = new List<Lead>();
                                           
            Lead l1 = new Lead(company='company1',lastName='lname1',phone='12345');
            testLeads.add(l1);
            Lead l2 = new Lead(company='company1',lastName='lname1',fax='12345');
            testLeads.add(l2);
            Lead l3 = new Lead(company='othervalue',lastName='lname1',LeadSource='Publication');
            testLeads.add(l3);
            insert testLeads;

    PageReference pageRef;// = Page.Marketing_Results_convertLeads_summary;
    //Test.setCurrentPageReference(pageRef);  
    
    ApexPages.StandardSetController setConTEST = new ApexPages.StandardSetController(Database.getQueryLocator(
    [select id,name,fax,mobilephone,FirstName,LastName,company,leadsource,Territory_Manager__c,Notes__c,phone,Lead_Source_Record_Type__c from lead where id in :testLeads]
    ));
    
    List<lead> tempLeads = [select id,name,fax,mobilephone,FirstName,LastName,company,leadsource,Territory_Manager__c,Notes__c,phone,Lead_Source_Record_Type__c from lead where id in :testLeads];
    
    setConTest.setSelected(tempLeads);
    
    ConvertLeads_Controller controller = new ConvertLeads_Controller(setConTest);

    List<lead> AllLeads = controller.getAllLeads(setConTEST);
    AllLeads = controller.getSCLeads();

    controller.getAccountsMessage();
    controller.getContactsMessage();
    
    //Test PageReference Methods
    
    pageReference Testref;
    controller.GAPage();
    controller.saveGALeads();
    

    //controller.step0();
    controller.step1();
    
    controller.startConversion();
    controller.continueFromSelectAccounts();
    controller.continueFromSelectContacts();
        
    List<LeadConverter.c_Lead> theCleads = controller.getCLeads();
    controller.setCLeads(theCleads);
    
    }
    
    static testMethod void myUnitTest2() {
        //Create Test Accounts
        List<Account> testAccs = new List<Account>();
        
            Account acc = new Account(name='company1');
            testAccs.add(acc);
            Account acc2 = new Account(name='company1');
            testAccs.add(acc2);
            Account acc3 = new Account(name='othervalue');
            testAccs.add(acc3);
            
            insert testAccs;
        
        //Create Test Contacts
        List<Contact> testCons = new List<Contact>();
        
            Contact c1 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,otherphone='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingState = 'Newyork',MailingPostalCode ='305001',MailingCountry = 'Usa',phone='12345');
            testCons.add(c1);
            Contact c2 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,fax='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingPostalCode ='305001',phone='12345',MailingState = 'Newyork');
            testCons.add(c2);
            Contact c3 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,phone='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingPostalCode ='305001',MailingState = 'Newyork');
            testCons.add(c3);
            Contact c4 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,mobilephone='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingPostalCode ='305001',phone='12345',MailingState = 'Newyork');
            testCons.add(c4);
            Contact c5 = new Contact(firstname='test',lastname='contact',AccountId=acc3.id,homephone='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingPostalCode ='305001',phone='12345',MailingState = 'Newyork');
            testCons.add(c5);                   
            insert testCons;    
            
        //Create Test Leads
        List<Lead> testLeads = new List<Lead>();
                                           
            Lead l1 = new Lead(company='company1',lastName='lname1',phone='12345');
            testLeads.add(l1);
            Lead l2 = new Lead(company='company1',lastName='lname1',fax='12345');
            testLeads.add(l2);
            Lead l3 = new Lead(company='othervalue',lastName='lname1',LeadSource='Publication');
            testLeads.add(l3);
            insert testLeads;

    PageReference pageRef;// = Page.Marketing_Results_convertLeads_summary;
    //Test.setCurrentPageReference(pageRef);  
        
    ApexPages.StandardSetController setConTEST = new ApexPages.StandardSetController(Database.getQueryLocator(
    [select id,name,fax,mobilephone,FirstName,LastName,company,leadsource,Territory_Manager__c,Notes__c,phone,Lead_Source_Record_Type__c from lead where id in :testLeads]
    ));
    
    ConvertLeads_Controller controller = new ConvertLeads_Controller(setConTest);

    controller.startConversion();

    
    }

    static testMethod void myUnitTest3() {
        //Create Test Accounts
        List<Account> testAccs = new List<Account>();
        

            Account acc2 = new Account(name='company1');
            testAccs.add(acc2);
            insert testAccs;
        
        //Create Test Contacts
        List<Contact> testCons = new List<Contact>();
        
            Contact c1 = new Contact(firstname='test',lastname='contact',AccountId=acc2.id,otherphone='12345',MailingStreet = 'manhattan',MailingCity = 'Newyork',MailingState = 'rajasthan',MailingPostalCode = '987654321a',Phone = '1234567890');
            testCons.add(c1);           
            insert testCons;    
            
        //Create Test Leads
        List<Lead> testLeads = new List<Lead>();
            
            for(Integer i = 0;i<100;i++){
                testLeads.add(new Lead(company='othervalue',lastName='lname1',LeadSource='Publication'));
            }                          
            insert testLeads;

    PageReference pageRef;// = Page.Marketing_Results_convertLeads_summary;
    //Test.setCurrentPageReference(pageRef);  
    
    ApexPages.StandardSetController setConTEST = new ApexPages.StandardSetController(Database.getQueryLocator(
    [select id,name,fax,mobilephone,FirstName,LastName,company,leadsource,Territory_Manager__c,Notes__c,phone,Lead_Source_Record_Type__c from lead where id in :testLeads]
    ));
    
    List<lead> tempLeads = [select id,name,fax,mobilephone,FirstName,LastName,company,leadsource,Territory_Manager__c,Notes__c,phone,Lead_Source_Record_Type__c from lead where id in :testLeads];
    
    setConTest.setSelected(tempLeads);
    
    ConvertLeads_Controller controller = new ConvertLeads_Controller(setConTest);

    pageReference Testref;
    controller.GAPage();
    controller.startConversion();
    controller.convertLeads();//Added by Kritika Bhati for S-510717 on 5/9/2017

    
    }

}