/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class TestOpportunityRegion {


    static testMethod void myUnitTest() {
          test.starttest();
        
         // Create Region
        Region__c r = new Region__c(Name='Southeast', Zip_Code__c='73455');
        insert r;
        
        Region__c r1 = new Region__c(Name='Southeast', Zip_Code__c='73455-0001');
        insert r1;
        
        // Create Account
        Account a = new Account();
        a.Name = 'Test Account';
        a.BillingPostalCode = '73455';
        a.BillingCity = 'NY';
        a.Region__c = r.Id;
        
        for(RecordType rt: [Select Id From RecordType Where Name = 'Gypsum USA Customer' AND SObjectType = 'Account']){
            a.RecordTypeId = rt.Id;
        }
        insert a;
        
        Account a1 = new Account();
        a1.Name = 'Test Account';
        a1.BillingPostalCode = '73455-0001';
        a1.Region__c = r.Id;
        a1.BillingCity = 'NY';
        for(RecordType rt: [Select Id From RecordType Where Name = 'Gypsum USA Customer' AND SObjectType = 'Account']){
            a1.RecordTypeId = rt.Id;
        }
        
        insert a1;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'Test Opp';
        opp.AccountId = a.Id;
        opp.StageName = 'Open';
        opp.CloseDate = system.today();
        opp.Region__c = a1.Region__c;
        opp.Zip_Code__c = '73455-0001';
       
        
        for(RecordType rt: [Select Id From RecordType Where Name = 'Promotional Opportunity' AND SObjectType = 'Opportunity']){
            opp.RecordTypeId = rt.Id;
        }
        insert opp;
        
        
        // Check of field populattion based on trigger
        for(Opportunity acc: [Select Id,Region__c,Zip_Code__c From Opportunity Where Id = : opp.Id ]) {
            if(acc.Zip_Code__c.length() > 5){
            system.assertNotEquals(acc.Zip_Code__c, a.Region__r.Zip_Code__c);
            }
            else{
            system.assertNotEquals(acc.Zip_Code_5_digit__c, a.Region__r.Zip_Code__c);
            system.assertEquals(acc.Region__c, a.Region__c);    
            
            }
        }
        
        test.stoptest();
    }
}