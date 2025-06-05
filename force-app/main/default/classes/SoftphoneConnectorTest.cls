//3.0.11
@isTest
private class SoftphoneConnectorTest {


    static testMethod void testGetObjectsforAccountWithoutFilter() {
        // Create Account
        Account accountTest = new Account(Name = 'AccountTest');
        accountTest.Phone = '298100000';
        insert accountTest;

        try {

            //getObjects(String cli, String accQuery, String contQuery, String searchObject) 
            String result = SoftphoneConnector.getObjects('298100000', '', '', 'Account');
            System.debug('testGetObjectsforAccount - SoftphoneConnector.getObjects: ====> ' + result);
            if (result.indexOf('AccountTest') != -1) {
                System.assert(true, 'Result should contain at least one account with AccountTest');
            } else {
                System.assert(false, 'Result not contain at least one account with AccountTest');
            }

        } finally {
            // Delete Account
            delete accountTest;
        }
    }

    static testMethod void testGetObjectsfor2AccountsWithoutFilter() {
        // Create Account
        Account accountTest = new Account(Name = 'AccountTest');
        accountTest.Phone = '6035551234';
        insert accountTest;

        Account accountTest2 = new Account(Name = 'AccountTest2');
        accountTest2.Phone = '6035551234';
        insert accountTest2;

        try {

            //getObjects(String cli, String accQuery, String contQuery, String searchObject) 
            String result = SoftphoneConnector.getObjects('6035551234', '', '', 'Account');
            System.debug('testGetObjectsforAccount - SoftphoneConnector.getObjects: ====> ' + result);
            Integer nbTest = result.countMatches('Test');
            if (nbTest == 2) {
                System.assert(true, 'Result should contain at least two accounts ');
            } else {
                System.assert(false, 'Result not contain two accounts');
            }

        } finally {
            // Delete Accounts
            delete accountTest;
            delete accountTest2;
        }
    }

    static testMethod void testGetObjectsforAccountWithFilter() {
        // Create Account
        Account accountTest = new Account(Name = 'AccountTest');
        accountTest.Phone = '298100000';
        //accountTest.Hierarchy_Level_BPCS__c = '4-Order For';
        accountTest.Status__c = 'Active';
        insert accountTest;

        String accQuery = 'Status__c = \'Active\'';
        try {

            //getObjects(String cli, String accQuery, String contQuery, String searchObject) 

            String result = SoftphoneConnector.getObjects('298100000', accQuery, '', 'Account');
            System.debug('testGetObjectsforAccount - SoftphoneConnector.getObjects: ====> ' + result);

            if (result.indexOf('AccountTest') != -1) {
                System.assert(true, 'Result should contain at least one account with AccountTest');
            } else {
                System.assert(false, 'Result not contain at least one account with AccountTest');
            }
        } finally {
            // Delete Account
            delete accountTest;
        }
    } 

    static testMethod void testGetObjectsforContactWithoutFilter() {
        // Create Contact
        Contact contactTest = new Contact();
        contactTest.FirstName = 'ContactTest ' + DateTime.now();
        contactTest.LastName = 'ContactLastName';
        contactTest.phone = '298100000';
        insert contactTest;

        try {

            //getObjects(String cli, String accQuery, String contQuery, String searchObject) 
            String result = SoftphoneConnector.getObjects('298100000', '', '', 'Contact');
            System.debug('testGetObjectsforContactWithoutFilter - SoftphoneConnector.getObjects: ====> ' + result);

            if (result.indexOf('ContactTest') != -1) {
                System.assert(true, 'Result should contain at least one Contact with ContactTest');
            } else {
                System.assert(false, 'Result not contain at least one Contact with ContactTest');
            }
        } finally {
            // Delete Contact
            delete contactTest;
        }
    }
    static testMethod void testGetObjectsforContactWithFilter() {
        // Create Contact
        Contact contactTest = new Contact();
        contactTest.FirstName = 'ContactTest ' + DateTime.now();
        contactTest.LastName = 'ContactLastName';
        contactTest.phone = '6035551234';
        contactTest.Status__c = 'Active';
        insert contactTest;
        String contQuery = 'Status__c = \'Active\'';

        try {
    
            //getObjects(String cli, String accQuery, String contQuery, String searchObject) 
            String result = SoftphoneConnector.getObjects('6035551234', '', contQuery, 'Contact');
            System.debug('testGetObjectsforContactWithFilter - SoftphoneConnector.getObjects: ====> ' + result);
    
            if (result.indexOf('ContactTest') != -1) {
                System.assert(true, 'Result should contain at least one Contact with ContactTest');
            } else {
                System.assert(false, 'Result not contain at least one Contact with ContactTest');
            }
        } finally {
            // Delete contact
            delete contactTest;
        }
    }
    
    static testMethod void testGetObjectsforLead() {
        // Create Lead
        Lead leadTest = new Lead();
        leadTest.FirstName = 'LeadFirstName' + DateTime.now();
        leadTest.LastName = 'LeadLastName';
        leadTest.Company = 'LeadCompany';
        leadTest.Phone = '298100000';
        insert leadTest;

        try {

            //getObjects(String cli, String accQuery, String contQuery, String searchObject) 
            String result = SoftphoneConnector.getObjects('298100000', '', '', 'Leads');
            System.debug('testGetObjectsforLead - SoftphoneConnector.getObjects: ====> ' + result);

            if (result.indexOf('LeadLastName') != -1) {
                System.assert(true, 'Result should contain at least one Lead with LeadLastName');
            } else {
                System.assert(false, 'Result not contain at least one Lead with LeadLastName');
            }
        } finally {
            // Delete Lead
            delete leadTest;
        }
    }

    static testMethod void testGetObjectsforRegistrations() {
        
        // Create Account
        Account accountTest = new Account(Name = 'AccountTest');
        accountTest.Phone = '298100000';
        insert accountTest;
        
        //Create Warranty Registration
        WOD_2__Warranty_Registration__c wrTest = new WOD_2__Warranty_Registration__c();
        wrTest.Name = 'Warranty_Reg' + DateTime.now();
        wrTest.Last_Name__c = 'WR_Test';
        wrTest.Phone__c = '298100000';
        wrTest.WOD_2__Registration_Date__c = System.Today();
        wrTest.WOD_2__Account__c = accountTest.Id;
        insert wrTest;
        
        try {
            //getObjects(String cli, String accQuery, String contQuery, String searchObject)
            String result = SoftphoneConnector.getObjects('298100000', '', '', 'Registrations');
            System.debug('testGetObjectsforRegistrations - SoftphoneConnector.getObjects: ====> ' + result);
            if (result.indexOf('Warranty_Reg') != -1) {
                System.assert(true, 'Result should contain at least one WOD_2__Warranty_Registration__c with Warranty_Reg');    
            } else {
                System.assert(false, 'Result not contain at least one WOD_2__Warranty_Registration__c with Warranty_Reg');  
            }
        } finally {
            delete accountTest;
            delete wrTest;
        }
    }
    
    static testMethod void testGetObjectsforWTransfers() {
        
        // Create Account
        Account accountTest = new Account(Name = 'AccountTest');
        accountTest.Phone = '298100000';
        insert accountTest;
        
        //Create Warranty Transfer
        WOD_Warranty_Transfer__c wtTest = new WOD_Warranty_Transfer__c();
        wtTest.First_Name__c = 'Warranty_Txf';
        wtTest.Account__c = accountTest.Id;
        wtTest.Phone__c = '298100000';
        insert wtTest; 
        
        try {
            //getObjects(String cli, String accQuery, String contQuery, String searchObject)
            String result = SoftphoneConnector.getObjects('298100000', '', '', 'WTransfers');
            System.debug('testGetObjectsforWTransfers - SoftphoneConnector.getObjects: ====> ' + result);
            if (result.indexOf('WT-') != -1) {
                System.assert(true, 'Result should contain at least one WOD_Warranty_Transfer__c with Warranty_Txf');   
            } else {
                System.assert(false, 'Result not contain at least one WOD_Warranty_Transfer__c with Warranty_Txf'); 
            }
        } finally {
            delete accountTest;
            delete wtTest;
        }
    }
    
        static testMethod void testGetObjectsforClaims() {
        
        // Create Account
        Account accountTest = new Account(Name = 'AccountTest');
        accountTest.Phone = '555100000';
        insert accountTest;
        
        //Create Warranty Claim
        WOD_2__Claim__c claimTest = new WOD_2__Claim__c();
        claimTest.Name = 'Claim_Test' + DateTime.now();
        claimTest.Last_Name__c = 'Claim_Test';
        claimTest.WOD_2__Account__c = accountTest.Id;
        claimTest.Customer__c = accountTest.Id;
        claimTest.Phone__c = '555100000';
        insert claimTest; 
        
        try {
            //getObjects(String cli, String accQuery, String contQuery, String searchObject)
            String result = SoftphoneConnector.getObjects('555100000', '', '', 'Claims');
            System.debug('testGetObjectsforClaims - SoftphoneConnector.getObjects: ====> ' + result);
            if (result.indexOf('CS') != -1) {
                System.assert(true, 'Result should contain at least one WOD_2__Claim__c with Claim_Test');  
            } else {
                System.assert(false, 'Result not contain at least one WOD_2__Claim__c with Claim_Test');    
            }
        } finally {
            delete accountTest;
            delete claimTest;
        }
    }
}