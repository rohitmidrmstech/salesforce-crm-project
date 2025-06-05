@isTest
private class recordtypeControllerTest{

    static testMethod void myUnitTest() {
        List<String> recordTypeVal = new List<String>();
        recordtypeController rtc = new recordtypeController();
        recordTypeVal = recordtypeController.fetchRecordTypeValues('Account');
        System.assert(recordTypeVal.size() > 0);
        recordtypeController.getRecTypeId('Account', 'Payer');
    }
}