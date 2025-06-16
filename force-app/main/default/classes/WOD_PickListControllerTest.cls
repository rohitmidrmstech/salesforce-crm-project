/**
 * @description Test class for WOD_PickListController
*/
@isTest
private class WOD_PickListControllerTest{
    /**
     * @description test method execution
    */
    private static testmethod void getPickListValuesTest(){
        String result=WOD_PickListController.getPickListValues('WOD_2__Claim__c','WOD_2__Claim_Status__c','');
        System.assertNotEquals(result, null);
    }
}