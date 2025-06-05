/*
 	Purpose			:	This Apex class provides record types for any sObject.
 	Created By		:	Nishant Singh Panwar (Appirio Offshore)
 	Created Date	:	1/27/2018
 	Current Version	:	V_1.0
*/
public class recordtypeController {
    public static Map<Id, String> recordtypemap {get;set;}
    
   @AuraEnabled        
    public static List<String> fetchRecordTypeValues(string sObjectName){
        
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        //Retrieve the describe result for the desired object
        Map<Id, Schema.RecordTypeInfo> result = gd.get(sObjectName).getDescribe().getRecordTypeInfosById();
        recordtypemap = new Map<Id, String>();
        for(Id RecordTypeId : result.keySet()){
            RecordTypeInfo rt = result.get(RecordTypeId);
            if(rt.getName() != 'Master')
            	recordtypemap.put(rt.getRecordTypeId(), rt.getName());
        }      
        return recordtypemap.values();
    }
    
    @AuraEnabled
    public static Id getRecTypeId(string sObjectName, String recordTypeLabel){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        //Retrieve the describe result for the desired object
        Map<String, Schema.RecordTypeInfo> result = new Map<String, Schema.RecordTypeInfo>();
        if(gd.containsKey(sObjectName)){
            result = gd.get(sObjectName).getDescribe().getRecordTypeInfosByName();
        }
        Id recid = NULL;
        if(!result.isEmpty() && result.containsKey(recordTypeLabel)){
            recid = result.get(recordTypeLabel).getRecordTypeId(); 
        }
        return recid;
    }    
}