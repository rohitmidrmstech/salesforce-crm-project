public with sharing class getContactRecordBasedonName {
    @AuraEnabled(cacheable =true)
 
    public static list<contact>  getMemberData(String name) { 
        string names ='%' + name + '%' ;    
          list<contact> contacts= [SELECT Id,Name,MobilePhone,Email FROM contact Where  Name LIKE :names]; 
       return contacts;
    }
}