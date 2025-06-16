@isTest
private class Test_SchedulerSlotAccount {

    static testMethod void myTestMethod() {        
        SLOT__c slotRecord = new SLOT__c(Color__c = 'T');
        Insert slotRecord;
        
        Account acc = new Account(Name = 'Test');
        Insert acc;
        
        
        Slot_Account__c slotAccount = new Slot_Account__c(SLOT__c = slotRecord.Id, Account__c = acc.Id);
        Insert slotAccount;
    
         test.starttest();
         SchedulerSlotAccount myClass = new SchedulerSlotAccount ();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
    }
}