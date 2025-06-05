@isTest
public class BatchRebateClaimShareUpdateTest {
    
    @isTest
    static void test() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(LastName ='Test Contact',AccountId = testAccount.Id);
        insert testContact;
        
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Community Contractor User'].Id,
            LastName = 'CTSFDC CertainTeed',
            Email = 'puser000@test.com',
            Username = 'puser000@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            IsActive=TRUE,
            contactId= testContact.id
        );
        insert u;
        
        
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        Id recTypeIdCP = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CP').getRecordTypeId();
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Exception Submitted', RecordTypeId = recTypeId,ShareFixed__c=False,Submitted_By__c = testContact.ID);
        Rebate_Claim__c rc2 = new Rebate_Claim__c(Status__c = 'Draft', RecordTypeId = recTypeIdCP,ShareFixed__c=False,Submitted_By__c = testContact.ID);
        insert new List<Rebate_Claim__c>{rc1, rc2};
            
            Id recTypeIdrc = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        RebateClaim rc = new RebateClaim(Rebate_Claim__c=rc1.Id ,Quantity=1, ClaimAmount=100, ClaimDate=System.now(),RecordTypeId=recTypeIdrc);
        insert rc;
        
        Test.startTest();
        BatchRebateClaimShareUpdate b = new BatchRebateClaimShareUpdate();
        Database.executeBatch(b);
        Test.stopTest();
    }
}