/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_aiuWarehouseTimeOff {

    static testMethod void myUnitTest() {
        Plants__c testWH = new Plants__c(Name='White City');
        testWH.SAP_Plant__c = 'W2';
        testWH.Lead_Time_Days__c =1;
        testWH.Maximum_Slots_Per_Day__c = 20;
        testWH.SOrg__c  = '1502';
        insert testWH;
        
        Warehouse_Slot__c wSlot = new Warehouse_Slot__c();
        wSlot.Plant__c = testWH.Id;
        wSlot.Slot_DOW__c = 'Monday';
        wSlot.Slot_Type__c = 'LTL';
        wSlot.Status__c = 'Active';
        insert wSlot;
        
        SLot__c slot = new SLot__c();
        slot.Warehouse_Slot__c = wSlot.Id;
        slot.Plant__c = testWH.Id;
        slot.Scheduled_Shipping_Date__c = Date.TODAY().addDays(2);
        insert slot;
        
        Warehouse_Time_Off__c timeOff = new Warehouse_Time_Off__c(Name='test');
        timeOff.Repeats__c = true;
        timeOff.Time_Off_Date__c = Date.TODAY().addDays(2);
        timeOff.Time_Off_Type__c = 'Holiday';
        timeOff.Plant__c = testWH.Id;
        insert timeOff;
    }
}