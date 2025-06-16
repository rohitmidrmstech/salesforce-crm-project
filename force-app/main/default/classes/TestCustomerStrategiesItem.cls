/**************************************************************************************************
* Test Class: TestCustomerStrategiesItem
* Created by Abhishek Pareek(Navivo), DateCreated: 11/24/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - Test CustomerStrategiesItem trigger
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME                 DATE            DETAIL FEATURES
    1.0      Abhishek Pareek (Navivo)      11/28/2014      INITIAL DEVELOPMENT
**************************************************************************************************/

@isTest
private class TestCustomerStrategiesItem {

    //Create Test data for Customer Strategy
    public static Customer_Strategy__c sampleCreateCustomerStrategy(String actionItem, Id accId){
            
        Customer_Strategy__c csObj = new Customer_Strategy__c();
        csObj.Action_Item__c = actionItem;
        csObj.Account__c = accId;
        insert csObj;
        return csObj;
    } 
        
    static testMethod void myUnitTest() {
        
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingPostalCode = '73455';
        a.BillingCity = 'NY';
        insert a;
        
        List<Customer_Strategy__c> csObjList = new List<Customer_Strategy__c>();
        
        csObjList.add(sampleCreateCustomerStrategy('testAction',a.Id));
        csObjList.add(sampleCreateCustomerStrategy('testAction',a.Id));
        csObjList.add(sampleCreateCustomerStrategy('testAction',a.Id));
        
        Customer_Strategy__c tempObj = [Select id from Customer_Strategy__c limit 1];
        delete tempObj;
        
    }
}