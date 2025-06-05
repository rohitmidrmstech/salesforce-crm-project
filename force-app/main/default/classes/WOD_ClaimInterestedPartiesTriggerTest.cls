@isTest(SeeAllData = false)
public class WOD_ClaimInterestedPartiesTriggerTest {
    public static testMethod void claimInterestedPartiesTest(){
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim.Payment_Date__c = System.today();
        insert claim;
        WOD_Claim_Interested_Parties__c interestedParty = WOD_TestDataFactory.createInterestedParty(claim.Id,'Contractor');
        interestedParty.Business_Units__c='Roofing';
        insert interestedParty;
        update interestedParty;
    }
}