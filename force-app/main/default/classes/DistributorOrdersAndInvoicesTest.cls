@isTest
public class DistributorOrdersAndInvoicesTest {

    @testSetup
    static void setupData() {
        // Create a test user and contact
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];

        Contact testContact = new Contact(
            LastName = 'Test Contact',
            Partner_User_2__c = testUser.Id
        );
        insert testContact;

        // Create RecordType for Account if doesn't exist
        RecordType soldToRT = [SELECT Id FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Sold-To' LIMIT 1];

        Account testAccount = new Account(
            Name = 'Test Sold-To Account',
            RecordTypeId = soldToRT.Id
        );
        insert testAccount;

        AccountContactRelation acr = new AccountContactRelation(
            ContactId = testContact.Id,
            AccountId = testAccount.Id
        );
        insert acr;

        Order testOrder = new Order(
            AccountId = testAccount.Id,
            Status = 'Draft',
            EffectiveDate = Date.today(),
            EndDate = Date.today().addDays(30)
        );
        insert testOrder;

        Invoice__c testInvoice = new Invoice__c(
            Name = 'INV-001',
            Billing_Date__c = Date.today(),
            Net_Value__c = 100.00,
            Sold_To_Lookup__c = testAccount.Id,
            Ship_To_Lookup__c = testAccount.Id,
            Order__c = testOrder.Id
        );
        insert testInvoice;
    }

    @isTest
    static void testGetOrdersAndInvoices() {
        Test.startTest();
        Map<String, List<SObject>> result = DistributorOrdersAndInvoices.getOrdersAndInvoices();
        Test.stopTest();

        System.assert(result.containsKey('orders'), 'Orders key should exist');
        System.assert(result.containsKey('invoices'), 'Invoices key should exist');
        System.assert(!result.get('orders').isEmpty(), 'Orders should not be empty');
        System.assert(!result.get('invoices').isEmpty(), 'Invoices should not be empty');
    }

    @isTest
    static void testSearchOrders() {
        // Sample search
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];

        Test.startTest();
        List<Order> orders = DistributorOrdersAndInvoices.searchOrders('Draft', testUser.Id, Date.today().addDays(-1), Date.today().addDays(1), 'Draft');
        Test.stopTest();

        System.assert(!orders.isEmpty(), 'Search orders should return results');
    }

    @isTest
    static void testSearchInvoices() {
        User testUser = [SELECT Id FROM User WHERE Profile.Name = 'Standard User' LIMIT 1];

        Test.startTest();
        List<Invoice__c> invoices = DistributorOrdersAndInvoices.searchInvoices('INV', testUser.Id);
        Test.stopTest();

        System.assert(!invoices.isEmpty(), 'Search invoices should return results');
    }

    @isTest
    static void testSearchInvoicesByOrders() {
        Order o = [SELECT Id FROM Order LIMIT 1];

        Test.startTest();
        List<Invoice__c> result = DistributorOrdersAndInvoices.searchInvoicesByOrders(new List<Id>{o.Id});
        Test.stopTest();

        System.assertEquals(1, result.size(), 'Should return one invoice');
    }

    @isTest
    static void testNoContactForUser() {
        User dummyUser = new User(
            Alias = 'testusr',
            Email='dummyuser@test.com',
            EmailEncodingKey='UTF-8',
            LastName='Test',
            LanguageLocaleKey='en_US',
            LocaleSidKey='en_US',
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Standard User' LIMIT 1].Id,
            TimeZoneSidKey='America/Los_Angeles',
            UserName='dummyuser@test.com'
        );
        insert dummyUser;

        Test.startTest();
        System.runAs(dummyUser) {
            try {
                DistributorOrdersAndInvoices.getOrdersAndInvoices();
                System.assert(false, 'Expected exception for missing contact');
            } catch (AuraHandledException e) {
                System.assert(e.getMessage().contains('No Contact found for current user'));
            }
        }
        Test.stopTest();
    }

    @isTest
    static void testEmptySearchOrdersThrowsException() {
        try {
            DistributorOrdersAndInvoices.searchOrders('', null, null, null, '');
            System.assert(false, 'Expected exception for no search criteria');
        } catch (AuraHandledException e) {
            System.assert(e.getMessage().contains('No search criteria provided.'));
        }
    }
}