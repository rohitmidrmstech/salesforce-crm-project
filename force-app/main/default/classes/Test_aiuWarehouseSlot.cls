/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_aiuWarehouseSlot {

    static testMethod void myUnitTest() {
        Plants__c testWH = new Plants__c(Name='White City');
        testWH.SAP_Plant__c = 'W2';
        testWH.Lead_Time_Days__c =1;
        testWH.Maximum_Slots_Per_Day__c = 20;
        insert testWH;
        
        Warehouse_Slot__c wSlot = new Warehouse_Slot__c();
        wSlot.Plant__c = testWH.Id;
        wSlot.Slot_DOW__c = 'Monday';
        wSlot.Slot_Type__c = 'LTL';
        wSlot.Status__c = 'Active';
        insert wSlot;
    }
}