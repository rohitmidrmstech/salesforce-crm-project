/**
 * @description Test data set up class
*/
@isTest
public class WOD_BatchClassShareTest {
    /**
     * @description method for create test data
    */
    public static testmethod void shareTestMethod(){
        Territory__c t = new Territory__c();
        t.Name ='WarrantyGroup_Tavant';
        t.Territory_SalesOrg__c ='WarrantyGroup_a12345';
        insert t;
         Territory__c t1 = new Territory__c();
        t1.Name ='WarrantyGroup_Tavant';
        t1.Territory_SalesOrg__c ='WarrantyGroup_a12344';
        insert t1;
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim.Territory__c = t.Id;
        insert claim;
        WOD_2__Claim__c claim2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim2.Territory__c = t.Id;
        insert claim2;
        claim2.Territory__c=t1.Id;
        update claim2;
        Database.executeBatch(new WOD_BatchClassShare());
    }
    
}