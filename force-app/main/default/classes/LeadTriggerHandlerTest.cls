@isTest
public class LeadTriggerHandlerTest {
    static testmethod void test1(){
        Id sidingLeadId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Siding Lead').getRecordTypeId();
        Lead leadObj = new Lead();
        leadObj.lastName = 'Test Lead';
        leadObj.RecordTypeId = sidingLeadId;
        leadObj.company = 'Test';
        leadObj.Status = 'Open - Not Contacted';
        leadObj.phone = 'phone';
       	leadObj.WTU_Notes__c ='abcd';
        leadObj.Fax = '7897893933';
        Test.startTest();
        insert leadObj;  
        Test.stopTest();
    }
    static testmethod void test2(){
        Id sidingLeadId = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('Siding Lead').getRecordTypeId();
        Lead leadObj = new Lead();
        leadObj.lastName = 'Test123';
        leadObj.company = 'Test';
        leadObj.Status = 'Open - Not Contacted';
        leadObj.phone = 'phone';
        leadObj.WTU_Notes__c ='abcd';
        leadObj.Fax = '7897893933';
        insert leadObj;
        system.assert(leadObj.Id != NULL);
        Test.startTest();
        Lead ld = [Select RecordTypeId,OwnerId from Lead where Id=:leadObj.Id];
        ld.RecordTypeId = sidingLeadId;
        ld.WTU_Notes__c = 'pgrs';
        update ld;
        Test.stopTest();
        system.assert(ld.RecordTypeId != null);
    }
}