public with sharing class CtpersonController {
    public static String getToken(String mobileNo){
        Blob value = Blob.valueof(mobileNo);
        Blob hash = Crypto.generateDigest('MD5', value);
        return EncodingUtil.base64Encode(hash);
    }
    public static List<person__C> getRecentHealthChanges(){
        return [SELECT Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c, Name, Id FROM Person__c ORDER BY Status_Update_Date__c DESC NULLS LAST  LIMIT 100];

    }
    public static List<person__C> searchPeople(string searchterm) {
        searchterm = searchterm +'%';
        return [SELECT Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c, Name, Id FROM 
        Person__c   WHERE NAME
         LIKE:searchterm OR Mobile__C
          LIKE :searchterm OR Token__C
           LIKE:searchterm 
           ORdER BY Status_Update_Date__c DESC NULLS LAST];

    }
    public static person__C getpersonById(string personid){
        List<person__C> person =[SELECT Health_Status__c, Mobile__c, Status_Update_Date__c, Token__c, Name, Id FROM Person__c WHERE ID =:personid];
        if(person!= null && person.size()>0){
            return person[0];

        }
        return null;
    }

    }