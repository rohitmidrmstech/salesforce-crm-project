/**
 * @description Test data set up class
*/
@isTest
public class WOD_BatchTerritoryGroupTest {
    /**
     * @description method for create test data
    */
     public static testmethod void ShareTestMethod(){
        Territory__c t = new Territory__c();
        t.Name ='WarrantyGroup_Tavant';
        t.Territory_SalesOrg__c ='WarrantyGroup_a12345';
        t.Sales_Org__c ='1501';
        t.Sales_Rep__c =UserInfo.getUserId();
        t.Sales_Rep2__c= UserInfo.getUserId();
        t.Sales_Rep3__c = UserInfo.getUserId();
        t.Sales_Rep4__c = UserInfo.getUserId();
        t.Sales_Rep5__c = UserInfo.getUserId();
        insert t;
        Database.executeBatch(new WOD_BatchTerritoryGroup());
     }
}