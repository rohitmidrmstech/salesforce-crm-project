public class contactCardActiveStatus {
    @AuraEnabled(Cacheable=true)
    public static List<Contact> getRecentlyCreatedContacts (){
      return [
    SELECT Id, Name, Contact_Card_Active__c
    FROM Contact
    ORDER BY CreatedDate DESC
    LIMIT 10
];  
    }  
    


}