global class CreateNextSlots_Scheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        String strQuery = 'Select Id, RecordTypeId, Account__c, No_Of_Slots__c, Plant__c,Plant__r.Name, ';
        strQuery += ' (Select Id, Scheduled_Shipping_Date__c from Slots__r ';
        //strQuery += ' where Scheduled_Shipping_Date__c >= : dtToday order by Scheduled_Shipping_Date__c Desc limit 1)';
        strQuery += ' where Scheduled_Shipping_Date__c >= : dtToday and Scheduled_Shipping_Day__c =: strDayName order by Scheduled_Shipping_Date__c Desc limit 1)';
        strQuery += ' from Warehouse_Slot__c where Slot_DOW__c =: strDayName AND Status__c =: strStatus'; //AND (Start_Date__c = null OR Start_Date__c <=: dtToday)';

        Id batchInstanceId = Database.executeBatch(new BatchCreateNextSlot(strQuery), 10);
    }
}