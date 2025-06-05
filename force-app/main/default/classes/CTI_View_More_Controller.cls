public class CTI_View_More_Controller { 


    public List<Account> accounts {get; private set;}
    public List<Contact> contacts {get; private set;}

    public CTI_View_More_Controller() {
        String callerId = ApexPages.currentPage().getParameters().get('ANI');
        List<List<SObject>> searchList = [FIND :callerId IN PHONE FIELDS RETURNING Account(Id,Name, Phone, Parent.Name, BillingStreet, BillingState, BillingPostalCode, BillingCity, JDE_Hierarchy_Level__c, SAP_ACCOUNT__c where(JDE_Hierarchy_Level__c IN('4-Order For','5-Ship To')AND Status__c= 'Active')),Contact(Id,Name, MailingStreet, MailingState, MailingPostalCode, MailingCity, Account.Name, Phone where(Function__c INCLUDES('OM Contact','Telemar')AND Contact_Relationship__c= 'Active'))];
        accounts = ((List<Account>)searchList[0]);
        contacts = ((List<Contact>) searchList[1]);
    }
    

}