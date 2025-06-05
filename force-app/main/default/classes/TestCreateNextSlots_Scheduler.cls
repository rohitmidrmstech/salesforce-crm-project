@istest
public with sharing class TestCreateNextSlots_Scheduler {
    static testmethod void testSample() {
        Test.startTest();
        CreateNextSlots_Scheduler obj = new CreateNextSlots_Scheduler();
        obj.execute(null);
        Test.stopTest();
    }

}