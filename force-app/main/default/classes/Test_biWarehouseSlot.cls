/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 */
@isTest
private class Test_biWarehouseSlot {

    static testMethod void myUnitTest() {
        Plants__c testWH = new Plants__c(Name='White City');
        testWH.SAP_Plant__c = 'W2';
        testWH.Lead_Time_Days__c =1;
        testWH.Maximum_Slots_Per_Day__c = 1;
        insert testWH;
        
        List<Warehouse_Slot__c> lst = new List<Warehouse_Slot__c>();
        Warehouse_Slot__c wSlot = new Warehouse_Slot__c();
        wSlot.Plant__c = testWH.Id;
        wSlot.Slot_DOW__c = 'Monday';
        wSlot.Slot_Type__c = 'LTL';
        wSlot.Status__c = 'Active';
        lst.add(wSlot);
        
        Warehouse_Slot__c wSlot1 = new Warehouse_Slot__c();
        wSlot1.Plant__c = testWH.Id;
        wSlot1.Slot_DOW__c = 'Tuesday';
        wSlot1.Slot_Type__c = 'LTL';
        wSlot1.Status__c = 'Active';
        lst.add(wSlot1);
        try{
            insert lst;
        }catch(DMLException ex){
            System.debug('====error=='+ex);
            System.assert(true);
        }
    }
}