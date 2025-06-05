/**
* @description Test class for trigger WOD_TerritoryTrigger
*/
@isTest(SeeAllData = false)
public class WOD_TerritoryTriggerTest {
    /**
* @description data set up and execution
*/
    public static testMethod void territoryTest(){
        Territory__c t = new Territory__c();
        t.Name ='WarrantyGroup_Tavant';
        t.Territory_SalesOrg__c ='WarrantyGroup_a12345';
        t.Sales_Org__c = '1501';
        t.Territory_Code__c=Date.today()+'terr123';
        t.Sales_Rep__c = Userinfo.getUserId();
        insert t;
        
        t.Sales_Rep__c = null;
        t.Sales_Rep2__c =null;
        t.Sales_Rep3__c =null;
        t.Sales_Rep4__c =null;
        t.Sales_Rep5__c =null;
        update t;
        t.Sales_Rep__c = Userinfo.getUserId();
        t.Sales_Rep2__c =Userinfo.getUserId();
        t.Sales_Rep3__c = Userinfo.getUserId();
        t.Sales_Rep4__c =Userinfo.getUserId();
        t.Sales_Rep5__c =Userinfo.getUserId();
        update t;
    }
    
}