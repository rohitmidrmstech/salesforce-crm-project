@isTest
public class OmSearchTests {

public static testMethod void testMyController() {

    AccContactsController at= new AccContactsController();
    at.test = true;
    at.strURL = 'https://cs0.salesforce.com/';
    String link = at.getlink();
    at.strURL = 'https://cs1.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://cs2.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://cs3.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://cs4.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na1.salesforce.com/'; 
    link = at.getlink();
    at.strURL = 'https://na2.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na3.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na4.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na5.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na6.salesforce.com/';
    link = at.getlink();

        PageReference pageRef = at.doSearchit();
        Account a = new Account(Name='Testing');
        AccContactsController.accountTotal lis = new AccContactsController.accountTotal(a);
        List<AccContactsController.accountTotal>  nl = at.getaccounttotals();

    }
    public static testMethod void testMyContController() {

    OMContactController at= new OMContactController();
    at.test = true;
    at.strURL = 'https://cs0.salesforce.com/';
    String link = at.getlink();
    at.strURL = 'https://cs1.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://cs2.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://cs3.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://cs4.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na1.salesforce.com/'; 
    link = at.getlink();
    at.strURL = 'https://na2.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na3.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na4.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na5.salesforce.com/';
    link = at.getlink();
    at.strURL = 'https://na6.salesforce.com/';
    link = at.getlink();

        PageReference pageRef = at.doSearchit();
        Contact c = new Contact(lastName = 'TestContact');
        OMContactController.ContactAcc lis = new OMContactController.ContactAcc(c);
        List<OMContactController.ContactAcc>  nl = at.getContactAcc();

    }
}