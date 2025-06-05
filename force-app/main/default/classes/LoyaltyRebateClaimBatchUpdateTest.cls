@isTest
public class LoyaltyRebateClaimBatchUpdateTest {
    @testSetup static void setupmethod() {
        automation_Controller__c automationController = new automation_Controller__c(Name = 'Automation', LoyaltyAutomatedPaymentProcessing__c = true);
        insert automationController;
        
        // Create common test accounts
        id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account acc =  new Account(Name = 'Testacc', BillingStreet='6640 28th St SE Ste 2',BillingCity='Grand Rapids',BillingState='MI',BillingPostalCode='49546',BillingCountry='US',RecordTypeId=RecordTypeId);
        insert acc;
        system.Assert(acc !=null);
        
        
        date todaysdate =date.today();	
        Contact con = new Contact (LastName='TestCont',Contractor_ID__c='89714871122',Contact_Card_Active__c=True,Contact_Card_Order_Status__c='Complete',
                                   Contact_Card_Expiration__c=todaysdate,accountId = acc.Id) ;
        insert con;
        system.Assert(con !=null);
        
        Rebate_Claim__c rebate = new Rebate_Claim__c(Claim_Exception__c=false,
                                                     Status__c='Pending Card Funding',Bank_Payment_Date__c=todaysdate);
        insert rebate;
        system.Assert(rebate !=null);
        
        
    }
    
    static testmethod void testMethodRebateClaim()
    {
        
        Test.startTest();
        List<Rebate_Claim__c> rebateClaimList = [SELECT Id FROM Rebate_Claim__c LIMIT 1];
        date todaysdate =date.today();	
        string RebcalimId = rebateClaimList.get(0).Id;
        Map<string,date> rebateMaployalty = new Map<string,date>();
        rebateMaployalty.put(RebcalimId,todaysdate);
        
        LoyaltyRebateClaimBatchUpdate batchClass = new LoyaltyRebateClaimBatchUpdate(rebateMaployalty);
        Id batchId = Database.executeBatch(batchClass);
        
        Test.stopTest();
        
    }
}