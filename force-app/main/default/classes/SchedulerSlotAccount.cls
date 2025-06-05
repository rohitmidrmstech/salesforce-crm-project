global class SchedulerSlotAccount implements Schedulable {
    global void execute(SchedulableContext SC) {
        String strQuery = 'Select Id from Slot_Account__c';
        Id batchInstanceId = Database.executeBatch(new BatchSlotAccount(strQuery), 500);
    }
}