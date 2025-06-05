global class UpdateFirstPaymentSc implements Schedulable {
    global void execute(SchedulableContext SC) {
        Id batchInstanceId = Database.executeBatch(new updateFirstPaymentBatch(), 20);
    }
}