global class BatchSlotAccount implements Database.Batchable<sObject>, Database.AllowsCallouts {
    Global String strQuery;
    Global Date dtToday;

    Global BatchSlotAccount(String strQuery) {
        this.strQuery = strQuery;
        this.dtToday = System.Today();
    }
    Global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }
    Global Void execute(Database.BatchableContext BC,List<sObject> scope) {
        BatchUpdateSlotAccount(scope);
    }
    Void BatchUpdateSlotAccount(List<sObject> scope) {
        List<Slot_Account__c> lstSlotAccount = (List<Slot_Account__c>) scope;
        Update lstSlotAccount;
    }
    Global void finish(Database.BatchableContext BC) {

    }
}