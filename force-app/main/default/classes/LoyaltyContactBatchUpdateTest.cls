@isTest
public class LoyaltyContactBatchUpdateTest {
    @testSetup static void setup() {
        
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
        
    } 
    static testmethod void testMethodTocallContactBatch()
    {
        Test.startTest();
        set<string> loyalty = new set<string>{'89714871122'};
            LoyaltyContactBatchUpdate batchClass = new LoyaltyContactBatchUpdate(loyalty);
        Id batchId = Database.executeBatch(batchClass);
        
        Test.stopTest();
        
    }
    
    static testmethod void testMethodContactException()
    {        
        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        profile profiledetails = [SELECT id from profile where name = 'System Administrator' Limit 1];
        User newuser = new User(Alias = 'standt',Email='standarduser@testorg.com',
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                LocaleSidKey='en_US', ProfileId = profiledetails.Id,
                                TimeZoneSidKey='America/Los_Angeles',UserName=uniqueUserName);
        insert newuser;
        System.RunAs(newuser){
            Test.startTest();
            set<string> loyalty = new set<string>{'89714871122'};
                LoyaltyContactBatchUpdate batchClass = new LoyaltyContactBatchUpdate(loyalty);
            
            Id batchId = Database.executeBatch(batchClass);
            Test.stopTest();
        }
    }
    
    
}