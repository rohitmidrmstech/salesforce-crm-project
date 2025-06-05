/**************************************************
Name :Shashikanth Vattam
Date :05/13/2021
Purpose: Exposing Ship-To Contacts information thru RestService
Associated coonected App:   RestServices_Contact
Test Class Name :Test_PriceFx_Ship_To
****************************************************/
@RestResource(urlMapping='/api/PriceFx_Ship_To/*')
global with sharing class PriceFx_Ship_To{
@HttpGet
    global static List<AccountContactRelation> doGetContactRelation() 
    {   
     RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        
        list<AccountContactRelation> conRelation2 =[select id ,Account.name,contact.Firstname,IsDirect,contact.LastName,contact.email,
                                                    Account.LOB__c,AccountId,Account.JDE_Hierarchy_Level__c,Account.SAP_ACCOUNT__c from
                                                    AccountContactRelation where ( (IsDirect = true or IsDirect = false ) 
                                                    and (Account.RecordType.Name ='Ship-To')
                                                    and (Contact.email !='') 
                                                    and (Account.JDE_Hierarchy_Level__c!='')
                                                    and (Account.SAP_ACCOUNT__c LIKE '2%' )  )];
                                             
             
        system.debug('conRelation2 count'+conRelation2.size()); 
        system.debug('getHeapSize'+Limits.getHeapSize());
        system.debug('getLimitHeapSize'+Limits.getLimitHeapSize());
        
        return conRelation2 ;
    }
}