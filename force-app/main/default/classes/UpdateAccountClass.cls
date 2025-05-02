public class UpdateAccountClass {
    public static void publishEvent(Id AccountId){
        Account accList = [SELECT Id ,Name,CustomerPriority__c FROM Account WHERE Id =:AccountId];
        accList.CustomerPriority__c = 'High';
        update accList;
        pubSubEvent__e eventData = new pubSubEvent__e(AccountId__c=accList.Id);
        System.debug('eventData' + eventData);
       Database.SaveResult sr = EventBus.publish(eventData);
        system.debug('sr' + sr);
        if(sr.isSuccess()){
                   system.debug('Event Published Successfully');
        }
        else{
            system.debug('Event Failed to Publish');
  
        }
            
    }
}