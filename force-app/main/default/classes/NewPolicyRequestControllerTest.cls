/**
 * @description Test class for NewPolicyRequestControllerTest
*/
@isTest
public class NewPolicyRequestControllerTest {
    
    /**
     * @description data set up
    */
    @TestSetup  
    public static void testDataSetup() { 
        Account acc = WOD_TestDataFactory.createAccount('Tavant_Test','','Customer');
        insert acc;
        
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        clm.Address_1_BL__c='Add Test2';
        insert clm;
    }
    
    /**
     * @description data set up and execution
    */
    private static testmethod void testgetClaim(){
        WOD_2__Claim__c claim = [Select Id from WOD_2__Claim__c Limit 1];
        Test.startTest();
            WOD_2__Claim__c clm = NewPolicyRequestController.getClaim(claim.Id);
            system.assertEquals(claim.Id, clm.Id);
        Test.stopTest();
    }
    
    /**
     * @description data set up and execution
    */
    private static testmethod void testValidPRNegative(){
        WOD_2__Claim__c claim = [Select Id from WOD_2__Claim__c Limit 1];
        Boolean isValid = false;
        Test.startTest();
            isValid = NewPolicyRequestController.validatePolicyRequest(claim.Id);
        Test.stopTest();
        system.assertEquals(true, isValid);
    }
    
    /**
     * @description data set up and execution
    */
    private static testmethod void testValidPRPositive(){
        WOD_2__Claim__c claim = [Select Id from WOD_2__Claim__c Limit 1];
        Policy_Request__c pr = new Policy_Request__c(Claim__c = claim.Id);
        insert pr;
        set<Id> plyreqId = new set<Id>{pr.id};
         Boolean isValid = true;
        Test.startTest();
            isValid = NewPolicyRequestController.validatePolicyRequest(claim.Id);
            WOD_PolicyReqTriggerHandler.updateclminfoonplyreq(plyreqId);
        Test.stopTest();
        system.assertEquals(true, isValid);
    }

}