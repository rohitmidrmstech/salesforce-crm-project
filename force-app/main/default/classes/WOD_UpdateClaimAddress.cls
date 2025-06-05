/**
 * @description To Update Address of the Claim
*/
public with sharing class WOD_UpdateClaimAddress {
    /**
	 * @description this method is used to update claim address from account billing address
	 * @param claimId Claim Id
	 * @return void
	*/
    public static void addressChange(String claimId) {
        WOD_2__Claim__c clm = [select Id,Customer__c,WOD_2__Claim_Type__c from WOD_2__Claim__c where Id =: claimId];
        Account acc = [select Id,BillingStreet,BillingCity,BillingState,BillingPostalCode,BillingCountry from Account where Id =: clm.Customer__c];
        
        clm.Address_1_BL__c = acc.BillingStreet;
        clm.City_BL__c = acc.BillingCity;
        clm.Postal_Code_BL__c = acc.BillingPostalCode;
        if(clm.WOD_2__Claim_Type__c != 'International'){
            clm.State_BL__c = acc.BillingState;
            clm.Country_BL__c = acc.BillingCountry;
        }
        
        update clm;
        
    }
}