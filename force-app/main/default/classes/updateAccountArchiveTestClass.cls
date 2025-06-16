@isTest
public class updateAccountArchiveTestClass 
{ 
    static testMethod void updateAccountArchiveTest() 
    {
        Account acct = new Account(Name = 'acctInsertTrigger1'
                                    , SAP_ACCOUNT__c = 'bpcstest1'
                                    , JDE_Hierarchy_Level__c = '1-GPO'
                                    , Status__c = 'Active'
                                    , BillingStreet = 'test st'
                                    , BillingCity = 'test city'
                                    , BillingState = 'te'
                                    , BillingPostalCode = '12345'
                                    , Phone = '1112223333'
                                   
                                    );
        insert acct ;

        //Account retAcct = [SELECT Id, SIC_2_Digits_Desc__c, SIC_3_Digits_Desc__c, SIC_Category__c FROM Account WHERE Id = :acct.Id LIMIT 1];
        //System.assert(retAcct.Id != null);
               
    } 

}