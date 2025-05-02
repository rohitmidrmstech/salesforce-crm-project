public with sharing class Valid8Controller{
    @AuraEnabled(cacheable= true)
    public static List<Valid8Member__c > getValid8list(String validID ,string fName ,string lName){
        String keyNameString = '%' +  validID + '%';        

return [SELECT Name,First_Name__c,Last_Name__c	 ,Valid_ID__c	 FROM Valid8Member__c Where Valid_ID__c like:keyNameString] ;
    }
}