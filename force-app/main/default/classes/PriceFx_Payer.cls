/**************************************************
Name :Shashikanth Vattam
Date :05/13/2021
Purpose: Exposing Payer Contacts information thru RestService
Associated coonected App:   RestServices_Contact
Test Class Name :Test_PriceFx_Payer
****************************************************/
@RestResource(urlMapping='/api/PriceFx_Payer/*')
global with sharing class PriceFx_Payer{
@HttpGet
    global static List<AccountContactRelation> doGetContactRelation() 
    {   
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        list<AccountContactRelation> conRelation3 =[select id ,Account.name,contact.Firstname,IsDirect,contact.LastName,contact.email,Account.LOB__c,
                                                    AccountId,Account.JDE_Hierarchy_Level__c,Account.SAP_ACCOUNT__c from AccountContactRelation
                                                    where ( (IsDirect = true or IsDirect = false ) 
                                                    and (Account.RecordType.Name ='Payer') 
                                                    and (Contact.email !='') 
                                                    and (Account.JDE_Hierarchy_Level__c!='')
                                                    and (Account.SAP_ACCOUNT__c LIKE '3%' )  )];
 
         
         system.debug('conRelation3 count'+conRelation3.size()); 
         system.debug('getHeapSize'+Limits.getHeapSize());
         system.debug('getLimitHeapSize'+Limits.getLimitHeapSize());
         return conRelation3 ;
    }
}