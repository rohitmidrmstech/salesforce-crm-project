/**************************************************************************************************
* Test Class: TestCTGStrategiesItem
* Created by Abhishek Pareek(Navivo), DateCreated: 11/24/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - Test CTGStrategiesItem trigger
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME                 DATE            DETAIL FEATURES
    1.0      Abhishek Pareek (Navivo)      11/28/2014      INITIAL DEVELOPMENT
**************************************************************************************************/

@isTest
private class TestCTGStrategiesItem {

    public static CTG_Strategy__c sampleCreateCTGStrategy(String actionItem, Id accId){
        
        //Create Test data for CTG Strategy 
        CTG_Strategy__c  csObj = new CTG_Strategy__c ();
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
        
        List<CTG_Strategy__c > csObjList = new List<CTG_Strategy__c >();
        
        csObjList.add(sampleCreateCTGStrategy('testAction',a.Id));
        csObjList.add(sampleCreateCTGStrategy('testAction',a.Id));
        csObjList.add(sampleCreateCTGStrategy('testAction',a.Id));
        
        CTG_Strategy__c  tempObj = [Select id from CTG_Strategy__c  limit 1];
        delete tempObj;
        
    }
}