@RestResource(urlMapping='/api/Contact/*')
global with sharing class ContactRestServices {
@HttpGet
    global static List<Account> doGet() 
    {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        List<Account> accountsWithContacts=new List<Account>();
         List<account> acclist=[SELECT id,Name,LOB__c,JDE_Hierarchy_Level__c,SAP_ACCOUNT__c,(select FirstName,LastName,email from Contacts)  FROM Account where  (RecordType.Name IN ('Sold-To','Ship-To','Payer') and JDE_Hierarchy_Level__c!='' and (SAP_ACCOUNT__c LIKE '100%' or SAP_ACCOUNT__c LIKE '200%' or SAP_ACCOUNT__c LIKE '300%'or SAP_ACCOUNT__c LIKE '310%') )  ];
         //for(Account acc:acclist)
        for(Account acc : acclist)
        {
            if(acc.Contacts != null && acc.Contacts.size() > 0)
            {
            accountsWithContacts.add(acc);
            }
        }
        
        return accountsWithContacts;
    }
}