/**
 * @description Test class for WOD_GenerateLetterController
*/
@isTest
public class WOD_GenerateLetterControllerTest {
    /**
     * @description data set up and execution
    */
    public static testmethod void method1(){
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert claim;
        WOD_GenerateLetterController.getRecord(claim.Id);
    }
    /**
     * @description data set up and execution
    */
    public static testmethod void method2(){
        WOD_2__Warranty_Registration__c wr = WOD_TestDataFactory.createWarrantyRegistration('Residential','Roofing');
        insert wr;
        WOD_GenerateLetterController.getRecord(wr.Id);
    }
    /**
     * @description data set up and execution
    */
    public static testmethod void method3(){
        WOD_Warranty_Transfer__c wt = WOD_TestDataFactory.createWarrantyTransfer('Residential','Roofing');
        insert wt;
        WOD_GenerateLetterController.getRecord(wt.Id);
    }
    /**
     * @description data set up and execution
    */
    public static testmethod void method4(){
       WOD_GenerateLetterController.getRecord('aghag'); 
    }
    /**
     * @description data set up and execution
    */
    public static testmethod void method5(){
       WOD_GenerateLetterController.getRecord(null); 
    }
}