@isTest
public class CT_CaseTakeOwnershipController_Test {
    
    
    @testSetup static void configSetup() {
        User u1;
        User u2;
        User u3;
        
        String uniqueUserName1 = 'standarduser1' + DateTime.now().getTime() + '@testorg.com';
        String uniqueUserName2 = 'standarduser2' + DateTime.now().getTime() + '@testorg.com';
        String uniqueUserName3 = 'standarduser3' + DateTime.now().getTime() + '@testorg.com';
        
        
        Profile prof3 = [SELECT Id FROM Profile WHERE NAme='USA VP User'];
        u3 = new User(Alias = 'standt', Email='standarduser@testorg.com',
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                      LocaleSidKey='en_US', ProfileId = prof3.Id,
                      TimeZoneSidKey='America/Los_Angeles',
                      UserName=uniqueUserName3);
        Insert u3;
        
        Profile prof2 = [SELECT Id FROM Profile WHERE Name='USA RM User'];
        u2  = new User(Alias = 'standt', Email='standarduser@testorg.com',
                       EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                       LocaleSidKey='en_US', ProfileId = prof2.Id,ManagerId = u3.Id,
                       TimeZoneSidKey='America/Los_Angeles',
                       UserName=uniqueUserName2);
        Insert u2;
        
        Profile prof1 = [SELECT Id FROM Profile WHERE Name='USA TM User'];
        u1 = new User(Alias = 'standt', Email='standarduser@testorg.com',
                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                      LocaleSidKey='en_US', ProfileId = prof1.Id, ManagerId=u2.Id,
                      TimeZoneSidKey='America/Los_Angeles',
                      UserName=uniqueUserName1);
        Insert u1;
    }
    
    static testmethod void test1(){
        
        Id salesAdjRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment No Charge').getRecordTypeId();
        Id acctSoldToRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        List<Case> listOfCases = new List<Case>();
        
        // Create Account record
        Account a1 = new Account();
        a1.RecordTypeId = acctSoldToRecTypeId;
        a1.name ='Test Acc 1';
        a1.SAP_ACCOUNT__c = 'ABC0023';
        a1.BillingCity = 'Test City';
        a1.BillingCountry = 'USA';
        a1.BillingPostalCode = '560043';
        a1.BillingState = 'Test State';
        a1.BillingStreet = 'Test Street';
        a1.JDE_Hierarchy_Level__c = 'Sold-To';
        insert a1;
        
        // Create cases under the account;
        Case c1 = new Case();
        c1.status = 'Pending CSM';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Sold_to_Name__c = a1.Id;
        c1.Territory__c = 'terr';
        c1.Confidential__c = true;
        c1.RecordTypeId = salesAdjRecTypeId;
        insert c1;
        List<User> u1 = [Select Id FROM User WHERE Profile.Name = 'USA VP User'];

        c1.OwnerId = u1[0].Id;
        update c1;

        listOfCases.add(c1);     
        Test.startTest();

            System.debug('listOfCases '+listOfCases);
            Test.setCurrentPage(Page.CT_CaseTakeOwnership);
            ApexPages.StandardSetController caseStdSetCtrl = new ApexPages.StandardSetController(listOfCases);
            caseStdSetCtrl.setSelected(listOfCases);
            CT_CaseTakeOwnershipController caseTakeOwnrship = new CT_CaseTakeOwnershipController(caseStdSetCtrl);
            caseTakeOwnrship.init();

            List<Case> testCaseList = [select Id, OwnerId from Case];
            System.assert(testCaseList.size()>0);
            System.assertEquals(UserInfo.getUserId(), testCaseList[0].OwnerId);
            
        Test.stopTest();
        
    }
}