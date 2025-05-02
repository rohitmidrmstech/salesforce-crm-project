public with sharing class CTLocationController {
    public static List<Location__c> getRecentstatuschanges(){
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
        
    }
    public static List<Location__c>  searchlocation(string searchterm){
        searchterm = searchterm + '%';
        return [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c WHERE NAME LIKE:searchterm OR Pincode__c LIKE:searchterm OR Address__c LIKE:searchterm   ORDER BY Status_Update_Date__c DESC NULLS LAST LIMIT 100];
        
    }
    public static Location__c getLocationById(string LocatioNid){
        List<Location__c> Locations = [SELECT Id, Name, Address__c, Pincode__c, Red_Score__c, Status_Update_Date__c, Status__c FROM Location__c WHERE ID =:LocatioNid];
        if(Locations != null && Locations.size()>0){
            return Locations[0]; 
        }
        return null;
    }
}