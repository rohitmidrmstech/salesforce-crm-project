global class BatchCreateNextSlot implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global String strQuery;
    global Date dtToday;
    global String strDayName;
    global String strStatus;

    global BatchCreateNextSlot(String strQuery) {
        this.strQuery = strQuery;
        this.dtToday = System.Today();
        this.strStatus = 'Active';
        this.strDayName = DateTime.newInstance(dtToday, Time.newInstance(0, 0, 0, 0)).format('EEEE');
    }

    global BatchCreateNextSlot(String strQuery, Date specifiedDate) {
        this.strQuery = strQuery;
        this.dtToday = specifiedDate;
        this.strStatus = 'Active';
        this.strDayName = DateTime.newInstance(dtToday, Time.newInstance(0, 0, 0, 0)).format('EEEE');
    }

    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }
    global Void execute(Database.BatchableContext BC, List<sObject> scope) {
        batchCreateSlots(scope);
    }
    void batchCreateSlots(List<sObject> scope) {
        List<Warehouse_Slot__c> listWarehouseSlot = (List<Warehouse_Slot__c>) scope;
        WarehouseSlotTriggerHandler.createNextSlots(listWarehouseSlot);
    }
    global void finish(Database.BatchableContext BC) {
    }
}