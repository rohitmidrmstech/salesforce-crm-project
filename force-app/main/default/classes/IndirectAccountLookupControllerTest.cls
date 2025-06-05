@isTest
public class IndirectAccountLookupControllerTest {
    @TestSetup
    static void setupTestData() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now())
            .replace(' ', '')
            .replace(':', '')
            .replace('-', '');
        Integer randomInt = Integer.valueOf(math.rint(math.random() * 1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User user = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = uniqueName + '@test' + orgId + '.org',
            Username = uniqueName + '@test' + orgId + '.org',
            Alias = uniqueName.substring(18, 23),
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        insert user;
        
        Account account = new Account(
            Name = 'Test Indirect Account',
            BillingStreet = '123 Main St.',
            BillingCity = 'PITTSBURGH',
            BillingState = 'PA',
            BillingPostalCode = '12345',
            BillingCountry = 'USA',
            Phone = '123-456-7890',
            RecordTypeId = '0123w0000026D5TAAU');
        insert account;
        
        Contact contact = new Contact(
            FirstName = 'Test',
            LastName = 'Contact',
            MailingState = 'PA',
            CCB_Eligibility__c = 'Eligible',
            AccountId = account.Id
        );
        insert contact;    
        
        FIPS__c fips = new FIPS__c(
            Name = 'TEST',
            FIPS_Code__c = '54321'
        );
        insert fips;
        
        Zip_to_Fips__c zipToFips = new Zip_to_Fips__c(
            Name = '12345',
            City__c = 'PITTSBURGH',
            FIPS_Code_Name__c = fips.id
        );
        insert zipToFips;   
        
        Territory__c territory = new Territory__c(
            Active__c = true,
            Sales_Rep__c = user.id
        );
        insert territory;
        
        Territory_Assignment__c territoryAssignment = new Territory_Assignment__c(
            Territory__c = territory.id,
            FIPS__c = fips.id
        );
        insert territoryAssignment;
    }
    @isTest
    static void testGetAccounts() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        Test.startTest();
        
        System.runAs(user) {
            List<AggregateResult> results = IndirectAccountLookupController.getAccounts('Test Indirect Account','PA',true);
            System.assertEquals(1, results.size());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetAccounts1() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        Test.startTest();
        
        System.runAs(user) {
            List<AggregateResult> results = IndirectAccountLookupController.getAccounts('Test Indirect Account',null, false);
            System.assertEquals(1, results.size());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetAccounts2() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        Test.startTest();
        
        System.runAs(user) {
            List<AggregateResult> results = IndirectAccountLookupController.getAccounts('Test Indirect Account','PA', false);
            System.assertEquals(1, results.size());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetAccounts3() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        Test.startTest();
        
        System.runAs(user) {
            List<AggregateResult> results = IndirectAccountLookupController.getAccounts(null,'PA', true);
            System.assertEquals(1, results.size());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetAccounts4() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        Test.startTest();
        
        System.runAs(user) {
            List<AggregateResult> results = IndirectAccountLookupController.getAccounts(null,'PA', false);
            System.assertEquals(1, results.size());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetAccounts5() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        Test.startTest();
        
        System.runAs(user) {
            List<AggregateResult> results = IndirectAccountLookupController.getAccounts('Test Indirect Account',null, false);
            System.assertEquals(1, results.size());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetAccounts6() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        Test.startTest();
        
        System.runAs(user) {
            List<AggregateResult> results = IndirectAccountLookupController.getAccounts(null,null, true);
            System.assertEquals(1, results.size());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetAccounts7() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        Test.startTest();
        
        System.runAs(user) {
            List<AggregateResult> results = IndirectAccountLookupController.getAccounts(null,'PA', true);
            System.assertEquals(1, results.size());
        }
        Test.stopTest();
    }
    @isTest
    static void testGetStates() {
        User user = [SELECT Id FROM User WHERE FirstName = 'Test' AND LastName = 'Standard' LIMIT 1];
        List<String> states = new List<String>();
        Test.startTest();
        System.runAs(user) {
            states = IndirectAccountLookupController.getStates();
        }
        Test.stopTest();
        System.assertEquals(1, states.size());
    }
    
}