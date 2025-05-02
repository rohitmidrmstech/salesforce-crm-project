public class publishEventDataofAccount {
    public static void publishEvent(Id AccountId) {
        Account acclist = [SELECT Id, Name, CustomerPriority__c FROM Account WHERE Id = :AccountId];
        pubSubEvent__e eventdata = new pubSubEvent__e(AccountId__c = acclist.Id, AccName__c = acclist.Name);
        System.debug('eventdata' + eventdata);
        Database.SaveResult sr = EventBus.publish(eventdata);

        if (sr.isSuccess()) {
            System.debug('Event Data Published Successfully');
            
            // Enqueue a queueable job for the callout
           // System.enqueueJob(new CalloutQueueable(acclist.Name));
        } else {
            System.debug('Event Data Publish Failed');
            return;
        }
    }
}