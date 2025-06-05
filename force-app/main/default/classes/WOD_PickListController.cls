/**
 * @description To Prepare picklist values
*/
public without sharing class WOD_PickListController {
    /**
     * @description To Prepare picklist value wrapper
     * @param objectName Sobject API Name
     * @param fieldName Picklist field API Name
     * @param bu Business unit Siding/Roofing
     * @return serialized wrapper
    */
    @AuraEnabled
    public static string getPickListValues(String objectName, String fieldName, String bu){
        List<NameValue> optionList = new List<NameValue>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Map<String, Schema.SObjectField> fieldMap = schemaMap.get(objectName).getDescribe().fields.getMap();
        Schema.DescribeFieldResult fieldResult = fieldMap.get(fieldName).getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple){
            NameValue nv=new NameValue();
            nv.label=f.getLabel();
            nv.value=f.getValue();
            optionList.add(nv);
        }             
        PickListWrapper pickList = new PickListWrapper();
        pickList.key='ftr';
        pickList.val=optionList;
        string returnString = JSON.serialize(pickList);
        system.debug('strToReturn '+returnString);
        return returnString;
    }
    /**
     * @description Wrapper Class
    */
    public class NameValue{
        public String label{get;set;}
        public String value{get;set;}
    }
    /**
     * @description Wrapper Class
    */
    public class PickListWrapper{ 
        public String key{get;set;}
        public List<Object> val{get;set;}
    }
}