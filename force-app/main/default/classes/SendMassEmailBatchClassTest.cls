@isTest
public class SendMassEmailBatchClassTest {
    static testmethod void test() {
        List<RecordType> accountRecord1 = [SELECT Id, Name, DeveloperName FROM RecordType where sobjectType = 'account' AND NAME = 'Ship-To' limit 1];
        List<RecordType > recordTypes = [SELECT Id, Name, DeveloperName FROM RecordType where sobjectType = 'contact' and DeveloperName ='Gypsum_USA_Contact' limit 1];
        
        Account accountRecord = new Account();
        accountRecord.Name = 'TestAccount';
        accountRecord.BillingCountry = 'USA';
        accountRecord.BillingState = 'TX';
        accountRecord.Shipping_Condition_Desc__c = 'TestAccountRAIL';
        accountRecord.RecordTypeId = accountRecord1[0].id;
        insert accountRecord;
        
        List<Contact> conList = new List<Contact>();
        List<Id> conListId = new List<Id>();
        for (Integer i=0;i<200;i++) {
            Contact m = new Contact( FirstName='fname',
                                    LastName = 'lname',
                                    Email = 'email@gmail.com',
                                    Email_Opt_Out__c = false,
                                    Phone = '9743800309', 
                                    MailingStreet = 'ABC', 
                                    MailingCity  = 'ABC',
                                    MailingState = 'ABC',
                                    MailingPostalCode = '350250',
                                    Status__c = 'Active',
                                    Contact_Type__c  = 'Dealer',
                                    Survey_Email_Sent__c  = false,
                                    accountid = accountRecord.id,
                                    recordTypeId = recordTypes[0].Id);
            conList.add(m);
        }
        insert conList;
        
        conListId.add(conList[0].id);   
        
        
        Test.startTest();
        SendMassEmailBatchClass c = new SendMassEmailBatchClass(conListId);
        Database.executeBatch(c);
        Test.stopTest();
        
    }
 
}