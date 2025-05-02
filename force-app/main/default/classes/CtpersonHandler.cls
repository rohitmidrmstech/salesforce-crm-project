public class CtpersonHandler {
    public static void updateHealth(List<person__c> personList){
        for(person__c person :personList){
            person.Health_Status__c= 'green';
            person.Token__c = CtpersonController.getToken('47548578');
        }
    }
        public static void UpdateStatusDate(List<person__c> personLists, map<id,person__c> oldrecord){
            for(person__c person :personLists){
                if(person.Health_Status__c != oldrecord.get(person.Id).Health_Status__c ){
                   person.Status_Update_Date__c = system.today(); 
                }
            }
        }
    }