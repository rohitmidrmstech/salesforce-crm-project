public with sharing class getHelpCenterData {
    @AuraEnabled(cacheable=true)
   public static List<HelpCenter__c> getHelpCenter(){
    return [SELECT Id,CaseNumber__c,Description__c,status__c,CreatedDate__c,Issue__c,Sub_Issue_Type__c,Subject__c,Name FROM HelpCenter__c
    Order by CreatedDate DESC Limit 1];
   }

}