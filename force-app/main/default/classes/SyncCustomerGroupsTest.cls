@isTest
public class SyncCustomerGroupsTest 
{
    @testSetup
    public static void init(){
        //TestDataFactory.storeTestCustomerData();
    }
    @isTest 
    public static void testBatch()
    {
        Id soldToRecordTypeId = Schema.getGlobalDescribe().get('Account').getDescribe().getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        Account acc = new Account();
        acc.Name = 'Test1';
        acc.Type = 'Sold-To';
        acc.RecordTypeId = soldToRecordTypeId;
        acc.SAP_ACCOUNT__c = '1009876543';
        acc.PRICE_GROUP__c = '12';
        Insert acc;
        
        TestCaseUtil.sampleInvoice();  // For Cover TestCaseUtil Class
        
        
        SyncCustomerGroups testClass = new SyncCustomerGroups();

        Test.startTest();
            // call the schedule method to invoke the executebatch
            SchedulableContext ctx=null;
            testClass.execute(ctx);
        Test.stopTest();

      //  list<Customer_Group__c> custGroups = [select id from Customer_Group__c];

       // System.assertEquals(1, custGroups.size());
    }
}