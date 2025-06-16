@isTest
private class WOD_LookUpComponentControllerTest{
    Private static testMethod void testLookUpSearch(){
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount','','Warranty Account');
        acc.Status__c = 'Active';
        insert acc;
        
        List<sobject> searchResult =  WOD_LookUpComponentController.findRecords('%','Account','Status__c=\'Active\'','Name','AccountNumber,BillingStreet,BillingCity,BillingState,BillingCountry,Parent.Name'); 
        System.assert(searchResult.size()>0);
    }
}