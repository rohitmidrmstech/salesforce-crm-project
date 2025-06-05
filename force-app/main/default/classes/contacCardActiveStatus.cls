public class contacCardActiveStatus {
    @AuraEnabled(cacheable=true)
    public static List<Contact> getRecentlyCreatedContacts() {
        return [
            SELECT Id, Name, Contact_Card_Active__c
            FROM Contact ORDER BY CreatedDate DESC LIMIT 10
        ];
    }


}