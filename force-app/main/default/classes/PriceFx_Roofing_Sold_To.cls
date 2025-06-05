/**************************************************
Name :Shashikanth Vattam
Date :05/13/2021
Purpose: Exposing Sold-To Roffing Contacts information thru RestService
Associated coonected App:   RestServices_Contact
Test Class Name :Test_PriceFx_Sold_To
1501,1102 roofing
****************************************************/
@RestResource(urlMapping='/api/PriceFx_R_Sold_To/*')
global with sharing class PriceFx_Roofing_Sold_To{
@HttpGet
    global static List<AccountContactRelation> doGetContactRelation() 
    {   
     RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String AccNumber = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
        list<AccountContactRelation> conRelation1 =[select id ,Account.name,contact.Firstname,IsDirect,contact.LastName,contact.email,Account.LOB__c,
                                                    AccountId,Account.JDE_Hierarchy_Level__c,Account.SAP_ACCOUNT__c from AccountContactRelation 
                                                    where ( (IsDirect = true or IsDirect = false ) 
                                                    and (Account.RecordType.Name ='Sold-To' ) 
                                                    and (Contact.email !='') 
                                                    and (Account.JDE_Hierarchy_Level__c!='')
                                                    and (Account.SAP_ACCOUNT__c LIKE '1%' ) 
                                                    and  (Account.LOB__c IN ('1501','1102')) )];
            
           
         system.debug('conRelation1 count'+conRelation1.size()); 
         system.debug('getHeapSize'+Limits.getHeapSize());
         system.debug('getLimitHeapSize'+Limits.getLimitHeapSize());
         
         return conRelation1 ;
         
    }
}