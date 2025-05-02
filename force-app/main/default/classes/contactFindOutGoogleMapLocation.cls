public  with sharing class contactFindOutGoogleMapLocation {
 @AuraEnabled(cacheable=true)
    public static List<Contact> getContactsByDate(Date specificDate) {
        system.debug('specificDate' + specificDate);
        list<contact> contacts = [SELECT Id, Name, MailingStreet, MailingCity,Geolocation__c, MailingState, MailingPostalCode, Next_Meeting__c	 
                FROM Contact WHERE Next_Meeting__c = :specificDate];
                system.debug('contacts' + contacts);
        return contacts;

    }
}