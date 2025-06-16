/*
ClassName    : WOD_UpdateClaimAddressTest
CreatedOn    : 04/13/2021
Author		 : Pintoo Jadaun
Description  : Test class for WOD_UpdateClaimAddress
*/  

@isTest
private class WOD_UpdateClaimAddressTest{
    
    Private static testmethod void testmethodAddressChange(){

        // Create Account record
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount','','Warranty Account');
        acc.BillingStreet = '3667 Park Overlook Dr Unit 11';
        acc.BillingCity = 'Beavercreek';
        acc.BillingPostalCode = '45431';
        insert acc;
          
        // Create Claim record
        WOD_2__Claim__c clm = WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.id,'Roofing');
        insert clm;
        
        WOD_UpdateClaimAddress.addressChange(clm.id); 
        WOD_2__Claim__c clmModified = [select id, Postal_Code_BL__c from WOD_2__Claim__c where id  =: clm.id limit 1];
        System.assertEquals(clmModified.Postal_Code_BL__c, acc.BillingPostalCode);
    }
}