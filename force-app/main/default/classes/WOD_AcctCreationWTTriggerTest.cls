@isTest
Private class WOD_AcctCreationWTTriggerTest{

    @isTest
    static void testTriggerLogic() {
        // Create test data
        WOD_Warranty_Transfer__c warranty = new WOD_Warranty_Transfer__c(
            Business_Units__c = 'Roofing',
            Division__c = 'Residential',
            Country_BL__c = 'United States',
            Address_1_BL__c = 'Test Address',
            City_BL__c = 'Test City',
            State_BL__c = 'Virginia (VA)',
            Postal_Code_BL__c = '12345'
        );
        insert warranty;

        // Execute trigger logic
        Test.startTest();
        warranty = [SELECT Id, Sales_Org__c, Account__c FROM WOD_Warranty_Transfer__c WHERE Id = :warranty.Id];
        Test.stopTest();

        // Verify trigger logic
        System.assertNotEquals(null, warranty.Account__c, 'Account should have been created');
        System.assertEquals('1501', warranty.Sales_Org__c, 'Sales Org should have been updated correctly');
    }

    @isTest
    static void testTriggerLogic_Solar_US() {
        // Create test data for Solar Solutions in the United States
        WOD_Warranty_Transfer__c warranty = new WOD_Warranty_Transfer__c(
            Business_Units__c = 'Solar Solutions',
            Division__c = 'Solar',
            Country_BL__c = 'United States',
            Address_1_BL__c = 'Test Address',
            City_BL__c = 'Test City',
            State_BL__c = ' ',
            Postal_Code_BL__c = '12345'
        );
        insert warranty;

        // Execute trigger logic
        Test.startTest();
        warranty = [SELECT Id, Sales_Org__c, Account__c FROM WOD_Warranty_Transfer__c WHERE Id = :warranty.Id];
        Test.stopTest();

        // Verify trigger logic
        System.assertEquals('1111', warranty.Sales_Org__c, 'Sales Org should have been updated correctly');
    }
    
    @isTest
    static void testTriggerLogic_OtherDivision() {
        // Create test data for other divisions
        WOD_Warranty_Transfer__c warranty = new WOD_Warranty_Transfer__c(
            Business_Units__c = 'Roofing',
            Division__c = 'Residential',
            Country_BL__c = 'Canada',
            Address_1_BL__c = 'Test Address',
            City_BL__c = 'Test City',
            State_BL__c = ' ',
            Postal_Code_BL__c = '12345'
        );
        insert warranty;

        // Execute trigger logic
        Test.startTest();
        warranty = [SELECT Id, Sales_Org__c, Account__c FROM WOD_Warranty_Transfer__c WHERE Id = :warranty.Id];
        Test.stopTest();

        // Verify trigger logic
        System.assertEquals('1102', warranty.Sales_Org__c, 'Sales Org should have been updated correctly for other division');
    }
    
    @isTest
    static void testTriggerLogic_NoAddress() {
        // Create test data with no address details
        WOD_Warranty_Transfer__c warranty = new WOD_Warranty_Transfer__c(
            Business_Units__c = 'Roofing',
            Division__c = 'Residential',
            Country_BL__c = 'Canada'
            // No address details provided intentionally
        );
        insert warranty;

        // Execute trigger logic
        Test.startTest();
        warranty = [SELECT Id, Sales_Org__c, Account__c FROM WOD_Warranty_Transfer__c WHERE Id = :warranty.Id];
        Test.stopTest();

        // Verify trigger logic
        System.assertNotEquals(null, warranty.Account__c, 'Account should have been created even with missing address');
    }

    @isTest
    static void testTriggerLogic_Siding() {
        // Create test data for Siding division
        WOD_Warranty_Transfer__c warranty = new WOD_Warranty_Transfer__c(
            Business_Units__c = 'Siding',
            Division__c = 'Coated Coil',
            Country_BL__c = 'United States',
            Address_1_BL__c = 'Test Address',
            City_BL__c = 'Test City',
            State_BL__c = ' ',
            Postal_Code_BL__c = '12345'
        );
        insert warranty;

        // Execute trigger logic
        Test.startTest();
        warranty = [SELECT Id, Sales_Org__c, Account__c FROM WOD_Warranty_Transfer__c WHERE Id = :warranty.Id];
        Test.stopTest();

        // Verify trigger logic
        System.assertEquals('1502', warranty.Sales_Org__c, 'Sales Org should have been updated correctly for Siding division');
    }
    
    @isTest
    static void testTriggerLogic_NoDivision() {
        // Create test data with no division specified
        WOD_Warranty_Transfer__c warranty = new WOD_Warranty_Transfer__c(
            Business_Units__c = 'Siding',
            // No division specified intentionally
            Country_BL__c = 'United States',
            Address_1_BL__c = '13214 Oak Farm Dr',
            City_BL__c = 'United States',
            State_BL__c = 'Virginia (VA)',
            Postal_Code_BL__c = '22192-3810'
        );
        insert warranty;

        // Execute trigger logic
        Test.startTest();
        warranty = [SELECT Id, Sales_Org__c, Account__c FROM WOD_Warranty_Transfer__c WHERE Id = :warranty.Id];
        Test.stopTest();

        // Verify trigger logic
        System.assertEquals(null, warranty.Sales_Org__c, 'Sales Org should have been updated correctly when division is not specified');
    }
    
    @isTest
    static void testTriggerLogic_SolarDivision_US() {
        // Create test data for Solar division in the United States
        WOD_Warranty_Transfer__c warranty = new WOD_Warranty_Transfer__c(
            Business_Units__c = 'Solar Solutions',
            Division__c = 'Solar',
            Sales_Org__c ='1501',
            Country_BL__c = 'United States',
            Address_1_BL__c = 'Test Address',
            City_BL__c = 'Test City',
            State_BL__c = ' ',
            Postal_Code_BL__c = '12345'
        );
        insert warranty;

        // Execute trigger logic
        Test.startTest();
        warranty = [SELECT Id, Sales_Org__c, Account__c FROM WOD_Warranty_Transfer__c WHERE Id = :warranty.Id];
        Test.stopTest();

        // Verify trigger logic
        System.assertEquals('1111', warranty.Sales_Org__c, 'Sales Org should have been updated correctly for Solar division in US');
    }
    @isTest
    static void testTriggerLogic_NoAddress1() {
        Test.startTest();
        // Create test data with no address details
        WOD_Warranty_Transfer__c warranty = new WOD_Warranty_Transfer__c(
            Business_Units__c = 'Roofing',
            Division__c = 'Residential',
            Country_BL__c = 'Canada'
            // No address details provided intentionally
        );
        insert warranty;
        // Execute trigger logic
        
        warranty = [SELECT Id, Sales_Org__c, Account__c FROM WOD_Warranty_Transfer__c WHERE Id = :warranty.Id];
        Test.stopTest();

        // Verify trigger logic
        System.assertNotEquals(null, warranty.Account__c, 'Account should have been created even with missing address');
    }
}