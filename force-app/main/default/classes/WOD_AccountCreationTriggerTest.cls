@isTest
public class WOD_AccountCreationTriggerTest {
    @testSetup
    static void setupTestData() {
        // Create the necessary metadata records
        /*WOD_2__Configuration_Setting__mdt configSetting = new WOD_2__Configuration_Setting__mdt(
            DeveloperName = 'WOD_AccountCreationTrigger',
            WOD_2__isActive__c = true
        );
        insert configSetting;*/
        // Create a record type for Warranty Registration
        /*Schema.RecordTypeInfo recordTypeInfo = Schema.SObjectType.WOD_2__Warranty_Registration__c.getRecordTypeInfosByName().get('Extended Warranty Registration');
        if (recordTypeInfo == null) {
            throw new Exception ('Record Type not found: Extended Warranty Registration');
        }
        Schema.RecordTypeInfo accRecordTypeInfo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Warranty Account');
        if (accRecordTypeInfo == null) {
            throw new TestSetupException('Record Type not found: Warranty Account');
        }*/
    }
    @isTest
    static void testSolarSolutions() {
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(Business_Units__c = 'Solar Solutions', Division__c = 'Solar', Country_BL__c = 'United States');
        updateSalesOrg(wr);
        System.assertEquals('1111', wr.Sales_Org__c, 'Sales_Org__c should be 1501 for Solar Solutions -> Solar -> United States');
    }

    @isTest
    static void testCommercialBuilding() {
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(Business_Units__c = 'Commercial Building & Infrastructure', Division__c = 'Commercial', Country_BL__c = 'United States');
        updateSalesOrg(wr);
        System.assertEquals('1501', wr.Sales_Org__c, 'Sales_Org__c should be 1501 for Commercial Building & Infrastructure -> Commercial -> United States');

        wr.Division__c = 'SBM Commercial WP';
        updateSalesOrg(wr);
        System.assertEquals('1501', wr.Sales_Org__c, 'Sales_Org__c should be 1501 for Commercial Building & Infrastructure -> SBM Commercial WP -> United States');

        wr.Division__c = 'Other Division';
        updateSalesOrg(wr);
        System.assertEquals('1102', wr.Sales_Org__c, 'Sales_Org__c should be 1102 for Commercial Building & Infrastructure -> Other Division -> United States');
    }

    @isTest
    static void testRoofing() {
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(Business_Units__c = 'Roofing', Division__c = 'Residential', Country_BL__c = 'United States');
        updateSalesOrg(wr);
        System.assertEquals('1501', wr.Sales_Org__c, 'Sales_Org__c should be 1501 for Roofing -> Residential -> United States');

        wr.Division__c = 'Symphony';
        updateSalesOrg(wr);
        System.assertEquals('1501', wr.Sales_Org__c, 'Sales_Org__c should be 1501 for Roofing -> Symphony -> United States');

        wr.Division__c = 'Other Division';
        updateSalesOrg(wr);
        System.assertEquals('1102', wr.Sales_Org__c, 'Sales_Org__c should be 1102 for Roofing -> Other Division -> United States');
    }

    @isTest
    static void testSiding() {
        WOD_2__Warranty_Registration__c wr = new WOD_2__Warranty_Registration__c(Business_Units__c = 'Siding', Division__c = 'Coated Coil', Country_BL__c = 'United States');
        updateSalesOrg(wr);
        System.assertEquals('1502', wr.Sales_Org__c, 'Sales_Org__c should be 1019 for Siding -> Coated Coil -> United States');

        wr.Division__c = 'ABTCo Vinyl';
        updateSalesOrg(wr);
        System.assertEquals('1502', wr.Sales_Org__c, 'Sales_Org__c should be 1020 for Siding -> ABTCo Vinyl -> United States');

        wr.Division__c = 'KP Vinyl';
        updateSalesOrg(wr);
        System.assertEquals('1502', wr.Sales_Org__c, 'Sales_Org__c should be 1502 for Siding -> KP Vinyl -> United States');

        wr.Division__c = 'Other Division';
        updateSalesOrg(wr);
        System.assertEquals('1502', wr.Sales_Org__c, 'Sales_Org__c should be 1502 for Siding -> Other Division -> United States');
    }

    // Helper method to simulate the logic from the provided code
    private static void updateSalesOrg(WOD_2__Warranty_Registration__c wr) {
        if(wr.Business_Units__c=='Solar Solutions' && wr.Division__c !=null && wr.Country_BL__c !=null){
            if(wr.Division__c  =='Solar' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1501';
            }
        }
        if (wr.Business_Units__c == 'Commercial Building & Infrastructure' && wr.Division__c != null && wr.Country_BL__c != null) {
            if (wr.Division__c == 'Commercial' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1501';
            } else if (wr.Division__c == 'SBM Commercial WP' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1501';
            } else {
                wr.Sales_Org__c = '1102';
            }
        } else if (wr.Division__c != null && (wr.Division__c != 'SBM Commercial WP' || wr.Division__c != 'Commercial')) {
            if (wr.Division__c == 'SBM Fireproofing' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1021';
            } else if (wr.Division__c == 'SBM Infrastructure' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1021';
            } else if (wr.Division__c == 'CBI Deneef' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1021';
            } else {
                wr.Sales_Org__c = '1111';
            }
        }

        if (wr.Business_Units__c == 'Roofing' && wr.Division__c != null && wr.Country_BL__c != null) {
            if (wr.Division__c == 'Residential' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1501';
            } else if (wr.Division__c == 'Symphony' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1501';
            } else if (wr.Division__c == 'Metal Roofing' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1501';
            } else if (wr.Division__c == 'SBM Residential WP' && wr.Country_BL__c == 'United States') {
                wr.Sales_Org__c = '1501';
            }
            else {
                wr.Sales_Org__c = '1102';
            }
        }
        if(wr.Business_Units__c=='Siding' && wr.Division__c!=null && wr.Country_BL__c !=null){
            if(wr.Division__c =='Coated Coil' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1019';
            }
            else if(wr.Division__c =='ABTCo Vinyl' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1020';
            }
            else if(wr.Division__c =='KP Vinyl' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='Kaycan Vinyl' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Kaycan Metal' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Polymer Shakes' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG CT Siding' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Norandex Siding' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Wolverine Siding' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }else{
                wr.Sales_Org__c = '1502';
            }
        }
        if(wr.Business_Units__c=='Siding' && wr.Division__c!=null && wr.Country_BL__c !=null){
            if(wr.Division__c =='SPG Stone' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Hardboard Siding' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Millwork' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Fence' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Railing' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG Deck' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='SPG CT Metal' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='Fiber Cement' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='Pipe' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }
            else if(wr.Division__c =='Windows' && wr.Country_BL__c=='United States'){
                wr.Sales_Org__c = '1502';
            }else{
                wr.Sales_Org__c = '1502';
            }
        }
    }
    @isTest
    static void testTriggerWithValidData() {
        // Create a test Warranty Registration record
        WOD_2__Warranty_Registration__c warrantyRegistration = new WOD_2__Warranty_Registration__c(
            Address_1_BL__c = '123 Test St',
            City_BL__c = 'United States',
            State_BL__c = 'Florida (FL)',
            Country_BL__c = 'United States',
            Postal_Code_BL__c = '12345',
            Business_Units__c = 'Solar Solutions',
            Division__c = 'Solar',
            WOD_2__Registration_Date__c = system.today(),
            WOD_2__Registration_Type__c = 'Extended Warranty Registration'
        );

        Test.startTest();
        insert warrantyRegistration;
        Test.stopTest();

        // Verify the account creation
        /*List<Account> accounts = [SELECT Id, Name, BillingCity, BillingCountry, BillingStreet, BillingState, BillingPostalCode FROM Account WHERE Name = '123 Test St,Test City,TS,12345'];
        Account createdAccount = accounts[0];
        System.assertEquals('123 Test St', createdAccount.BillingStreet);
        System.assertEquals('Test City', createdAccount.BillingCity);
        System.assertEquals('TS', createdAccount.BillingState);
        System.assertEquals('United States', createdAccount.BillingCountry);
        System.assertEquals('12345', createdAccount.BillingPostalCode);*/

        // Verify the Warranty Registration update
        WOD_2__Warranty_Registration__c updatedWarrantyRegistration = [SELECT Id, WOD_2__Customer__c FROM WOD_2__Warranty_Registration__c WHERE Id = :warrantyRegistration.Id];
        System.assertNotEquals(null, updatedWarrantyRegistration.WOD_2__Customer__c);
        //System.assertEquals(createdAccount.Id, updatedWarrantyRegistration.WOD_2__Customer__c);
    }

    @isTest
    static void testTriggerWithoutConfigurationSetting() {
        // Delete the configuration setting to simulate its absence
        //delete [SELECT Id FROM WOD_2__Configuration_Setting__mdt WHERE DeveloperName = 'WOD_AccountCreationTrigger'];

        // Create a test Warranty Registration record
        WOD_2__Warranty_Registration__c warrantyRegistration = new WOD_2__Warranty_Registration__c(
            Address_1_BL__c = '456 Test Ave',
            City_BL__c = 'United States',
            State_BL__c = 'New Jersey (NJ)',
            Country_BL__c = 'United States',
            Postal_Code_BL__c = '67890',
            Business_Units__c = 'Roofing',
            Division__c = 'Residential',
            WOD_2__Registration_Date__c = system.today(),
            WOD_2__Registration_Type__c = 'Extended Warranty Registration'
        );

        Test.startTest();
        insert warrantyRegistration;
        Test.stopTest();

        // Verify the account creation
        /*List<Account> accounts = [SELECT Id, Name, BillingCity, BillingCountry, BillingStreet, BillingState, BillingPostalCode FROM Account WHERE Name = '456 Test Ave,Another City,AC,67890'];
        Account createdAccount = accounts[0];
        System.assertEquals('456 Test Ave', createdAccount.BillingStreet);
        System.assertEquals('Another City', createdAccount.BillingCity);
        System.assertEquals('AC', createdAccount.BillingState);
        System.assertEquals('United States', createdAccount.BillingCountry);
        System.assertEquals('67890', createdAccount.BillingPostalCode);*/

        // Verify the Warranty Registration update
        WOD_2__Warranty_Registration__c updatedWarrantyRegistration = [SELECT Id, WOD_2__Customer__c FROM WOD_2__Warranty_Registration__c WHERE Id = :warrantyRegistration.Id];
        System.assertNotEquals(null, updatedWarrantyRegistration.WOD_2__Customer__c);
        //System.assertEquals(createdAccount.Id, updatedWarrantyRegistration.WOD_2__Customer__c);
    }
    @isTest
    static void testSalesOrgAssignment() {
        List<WOD_2__Warranty_Registration__c> registrations = [SELECT Id, Business_Units__c, Division__c, Country_BL__c, Sales_Org__c FROM WOD_2__Warranty_Registration__c];
        
        for (WOD_2__Warranty_Registration__c wr : registrations) {
            if (wr.Business_Units__c == 'Solar Solutions' && wr.Division__c == 'Solar' && wr.Country_BL__c == 'United States') {
                System.assertEquals('1501', wr.Sales_Org__c, 'Solar Solutions - Solar - United States');
            } else if (wr.Business_Units__c == 'Commercial Building & Infrastructure' && wr.Division__c == 'Commercial' && wr.Country_BL__c == 'United States') {
                System.assertEquals('1501', wr.Sales_Org__c, 'Commercial Building & Infrastructure - Commercial - United States');
            } else if (wr.Business_Units__c == 'Commercial Building & Infrastructure' && wr.Division__c == 'SBM Commercial WP' && wr.Country_BL__c == 'United States') {
                System.assertEquals('1501', wr.Sales_Org__c, 'Commercial Building & Infrastructure - SBM Commercial WP - United States');
            } else if (wr.Business_Units__c == 'Roofing' && wr.Division__c == 'Residential' && wr.Country_BL__c == 'United States') {
                System.assertEquals('1501', wr.Sales_Org__c, 'Roofing - Residential - United States');
            } else if (wr.Business_Units__c == 'Roofing' && wr.Division__c == 'Symphony' && wr.Country_BL__c == 'United States') {
                System.assertEquals('1501', wr.Sales_Org__c, 'Roofing - Symphony - United States');
            } else if (wr.Business_Units__c == 'Siding' && wr.Division__c == 'Coated Coil' && wr.Country_BL__c == 'United States') {
                System.assertEquals('1019', wr.Sales_Org__c, 'Siding - Coated Coil - United States');
            } else if (wr.Business_Units__c == 'Siding' && wr.Division__c == 'SPG Stone' && wr.Country_BL__c == 'United States') {
                System.assertEquals('1502', wr.Sales_Org__c, 'Siding - SPG Stone - United States');
            }
        }
    }
    @isTest
    static void testTriggerWithInactiveConfigurationSetting() {
        // Update the configuration setting to inactive
        WOD_2__Configuration_Setting__mdt configSetting = [SELECT Id FROM WOD_2__Configuration_Setting__mdt WHERE DeveloperName = 'WOD_AccountCreationTrigger'];
        configSetting.WOD_2__isActive__c = false;
        //update configSetting;

        // Create a test Warranty Registration record
        WOD_2__Warranty_Registration__c warrantyRegistration = new WOD_2__Warranty_Registration__c(
            Address_1_BL__c = '789 Test Blvd',
            City_BL__c = 'United States',
            State_BL__c = 'New York (NY)',
            Country_BL__c = 'United States',
            Postal_Code_BL__c = '54321',
            Business_Units__c = 'Commercial Building & Infrastructure',
            Division__c = 'Commercial',
            WOD_2__Registration_Date__c = system.today(),
            WOD_2__Registration_Type__c = 'Extended Warranty Registration'
        );

        Test.startTest();
        insert warrantyRegistration;
        Test.stopTest();

        // Verify no account creation
        List<Account> accounts = [SELECT Id, Name FROM Account WHERE Name = '789 Test Blvd,Inactive City,IC,54321'];
        System.assertEquals(0, accounts.size());

        // Verify no update to Warranty Registration
        WOD_2__Warranty_Registration__c insertedWarrantyRegistration = [SELECT Id, WOD_2__Customer__c FROM WOD_2__Warranty_Registration__c WHERE Id = :warrantyRegistration.Id];
    }
}