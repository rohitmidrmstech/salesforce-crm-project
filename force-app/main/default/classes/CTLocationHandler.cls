public class CTLocationHandler {
    public static void UpdateStatusToGreen(List<Location__c> ListLocation){
        for(Location__c lst :ListLocation){
            lst.Status__c ='Green';
        }
    }
    public static void UpdateStatus(List<Location__c> ListLocations , map<id,Location__c> oldRecord){
        for(Location__c loc :ListLocations){
            if(loc.Status__c !=oldRecord.get(loc.id).Status__c ){
                loc.Status_Update_Date__c = system.today();
            }
        }
    }
}