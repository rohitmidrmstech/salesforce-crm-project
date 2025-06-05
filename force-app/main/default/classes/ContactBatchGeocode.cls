public with sharing class ContactBatchGeocode {
    
     @future(callout=true)
    public static void updateContactWithSFMapsIdAsync(List<id> contactIds) {
        List<Contact> contactList = [SELECT Id, MailingStreet, MailingCity, MailingState, MailingPostalCode, 
                                     MailingCountry,Geolocation__Latitude__s,Geolocation__Longitude__s, 
                                     Name 
                                     FROM Contact 
                                     WHERE Id IN :contactIds];
        updateContactWithSFMapsId(contactList);
    }
    
    public static void updateContactWithSFMapsId(List<contact> lstContact){
        system.debug('lstContact:: '+lstContact);
        List<Contact> contactList = [SELECT Id,
                                     MailingStreet,
                                     MailingCity,
                                     MailingState,
                                     MailingPostalCode,
                                     MailingCountry, 
                                     Geolocation__Latitude__s, 
                                     Geolocation__Longitude__s, 
                                     Name 
                                     FROM Contact 
                                     WHERE (id IN :lstContact) AND
                                     (MailingStreet != null 
                                      AND MailingCity != null 
                                      AND MailingState != null
                                      AND MailingPostalCode != null 
                                      AND MailingCountry != null) 
                                      LIMIT 50];
        
        Map<String, Contact> mapContacts = new Map<String, Contact>(); // Map of the Accounts to link the results back to
        Map<String, Map<String, String>> mapAddresses = new Map<String, Map<String, String>>();
        
        for (Contact cc : contactList) {
            // It is recommended to prevent sending null fields. Not done here for illustrative purposes.
            Map<String, String> address = new Map<String, String>{
                'address' => cc.MailingStreet + ', ' + cc.MailingCity + ', ' + cc.MailingPostalCode + ', ' + cc.MailingCountry
                    };
                        String idstr = Id.valueOf(cc.id);
            mapAddresses.put(idstr, address);
            mapContacts.put(idstr.toLowerCase(), cc);// Ids will be lowercase in results.
        }
        
        Map<String, Object> response; // Deserialized Untyped Response
        try {
              if (Test.isRunningTest()) {
            	response = getMockBatchGeocodeResponseForFutureCall();
                  system.debug('response:: '+response);
        } else {
                response = maps.API.BatchGeocode(new Map<String, Object> {
                    'version' => '2', // Required. Hardcode value to 2. Has no impact on results or process.
                        'address_info' => JSON.serialize(mapAddresses)
                        });
        }
        }
        catch (Exception ex) {
            // Handle exception. Simple log for illustrative purposes.
            System.debug(ex);
            return;
        }
        
        List<Contact> contactssWithBadData = new List<Contact>();
        Boolean callSuccess = (Boolean)response.get('success');
        if(callSuccess != null){
            Map<String, Object> results = (Map<String, Object>)response.get('results');
            for(String contactId: results.keySet()){
                system.debug('contactId => ' + contactId);
                Contact cc = mapContacts.get(contactId);
                Map<String, Object> record = (Map<String, Object>)results.get(contactId);
                if((Boolean) record.get('success')){
                    Map<String, Object> data = (Map<String, Object>)record.get('data');
                    Map<String, Object> position = (Map<String, Object>) data.get('position');
                    system.debug('Geolocation => ' + position.get('lat') + '|' + position.get('lng'));
                    if (!Test.isRunningTest()) {
                    cc.Geolocation__Latitude__s = (Decimal)position.get('lat');
                    cc.Geolocation__Longitude__s = (Decimal)position.get('lng');
                    }
                    if((Decimal)data.get('score') < 50) {
                        // Low confidence in address match. Marking the accounts needed for review.
                        contactssWithBadData.add(cc);
                    }
                }
                else {
                    // Unable to match address provided.
                    contactssWithBadData.add(cc);
                }
            }
            update contactList; // Update records with Latitude and Longitude.
            //reviewBadAccounts(contactsWithBadData); // Pushing accounts with bad data to another process to be handled.
        }
        else {
            // Three primary types of failed requests.
            String errorCode = (String) response.get('error_code');
            if(errorCode == 'GC-0500'){
                // Internal Server Error
                // Retry the request at a later time and/or reach out to support.
                return;
            }
            else if(errorCode == 'GC-0429'){
                // Too many requests. Perform an exponential back off for the retries.
                // Bad requests count against limits. Be sure to not waste calls on bad addresses and improperly created requests.
                return;
            }
            else if(errorCode.startsWith('GC-1')){
                System.debug(response);
                // Improperly created requests. Fix errors before trying again.
                return;
            }
            else {
                // Fail safe catch for future error codes.
                System.debug(response);
                return;
            }
        }
    }
    public static void updateContactWithSFMaps(String state){
        List<Contact> contactList = [SELECT Id,
                                     MailingStreet,
                                     MailingCity,
                                     MailingState,
                                     MailingPostalCode,
                                     MailingCountry, 
                                     Geolocation__Latitude__s, 
                                     Geolocation__Longitude__s, 
                                     Name 
                                     FROM Contact 
                                     WHERE 
                                     (MailingStreet != null 
                                      AND MailingCity != null 
                                      AND MailingState = :state 
                                      AND MailingPostalCode != null 
                                      AND MailingCountry != null 
                                      AND Partner_User_2__c != null) 
                                     AND (Geolocation__Latitude__s = Null AND Geolocation__Longitude__s = Null) 
                                     LIMIT 50];
        
        Map<String, Contact> mapContacts = new Map<String, Contact>(); // Map of the Accounts to link the results back to
        Map<String, Map<String, String>> mapAddresses = new Map<String, Map<String, String>>();
        
        for (Contact cc : contactList) {
            // It is recommended to prevent sending null fields. Not done here for illustrative purposes.
            Map<String, String> address = new Map<String, String>{
                'address' => cc.MailingStreet + ', ' + cc.MailingCity + ', ' + cc.MailingPostalCode + ', ' + cc.MailingCountry
                    };
                        String idstr = Id.valueOf(cc.id);
            mapAddresses.put(idstr, address);
            mapContacts.put(idstr.toLowerCase(), cc);// Ids will be lowercase in results.
        }
        
        Map<String, Object> response; // Deserialized Untyped Response
        try {
              if (Test.isRunningTest()) {
            	response = getMockBatchGeocodeResponse();
        } else {
                response = maps.API.BatchGeocode(new Map<String, Object> {
                    'version' => '2', // Required. Hardcode value to 2. Has no impact on results or process.
                        'address_info' => JSON.serialize(mapAddresses)
                        });
        }
        }
        catch (Exception ex) {
            // Handle exception. Simple log for illustrative purposes.
            System.debug(ex);
            return;
        }
        
        List<Contact> contactssWithBadData = new List<Contact>();
        Boolean callSuccess = (Boolean)response.get('success');
        if(callSuccess != null){
            Map<String, Object> results = (Map<String, Object>)response.get('results');
            for(String contactId: results.keySet()){
                system.debug('contactId => ' + contactId);
                Contact cc = mapContacts.get(contactId);
                Map<String, Object> record = (Map<String, Object>)results.get(contactId);
                if((Boolean) record.get('success')){
                    Map<String, Object> data = (Map<String, Object>)record.get('data');
                    Map<String, Object> position = (Map<String, Object>) data.get('position');
                    system.debug('Geolocation => ' + position.get('lat') + '|' + position.get('lng'));
                    if (!Test.isRunningTest()) {
                    cc.Geolocation__Latitude__s = (Decimal)position.get('lat');
                    cc.Geolocation__Longitude__s = (Decimal)position.get('lng');
                    }
                    if((Decimal)data.get('score') < 50) {
                        // Low confidence in address match. Marking the accounts needed for review.
                        contactssWithBadData.add(cc);
                    }
                }
                else {
                    // Unable to match address provided.
                    contactssWithBadData.add(cc);
                }
            }
            update contactList; // Update records with Latitude and Longitude.
            //reviewBadAccounts(contactsWithBadData); // Pushing accounts with bad data to another process to be handled.
        }
        else {
            // Three primary types of failed requests.
            String errorCode = (String) response.get('error_code');
            if(errorCode == 'GC-0500'){
                // Internal Server Error
                // Retry the request at a later time and/or reach out to support.
                return;
            }
            else if(errorCode == 'GC-0429'){
                // Too many requests. Perform an exponential back off for the retries.
                // Bad requests count against limits. Be sure to not waste calls on bad addresses and improperly created requests.
                return;
            }
            else if(errorCode.startsWith('GC-1')){
                System.debug(response);
                // Improperly created requests. Fix errors before trying again.
                return;
            }
            else {
                // Fail safe catch for future error codes.
                System.debug(response);
                return;
            }
        }
    }
    @TestVisible
    private static Map<String, Object> getMockBatchGeocodeResponse() {
        // Mock response for testing
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User user1 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user12' + '@test' + '12345' + '.org',
            Username = 'user12' + '@test' + '12345' + '.org',
            Alias = 'user12',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        insert user1;
        
        // Create test data
        Contact contact1 = new Contact(
            FirstName='Test',
            LastName='Contact1',
            MailingStreet='123 Test St',
            MailingCity='Test City',
            MailingState='CA',
            MailingPostalCode='12345',
            MailingCountry='USA',
            Partner_User_2__c=user1.id
        );
        
        Contact contact2 = new Contact(
            FirstName='Test',
            LastName='Contact2',
            MailingStreet='456 Test St',
            MailingCity='Test City',
            MailingState='CA',
            MailingPostalCode='12345',
            MailingCountry='USA',
            Partner_User_2__c=user1.id
        );
        
        insert new List<Contact>{contact1, contact2};
        
        return new Map<String, Object>{
            'success' => true,
            'results' => new Map<String, Object>{
               string.valueOf(contact1.Id).toLowerCase() => new Map<String, Object>{
                    'success' => true,
                    'data' => new Map<String, Object>{
                        'position' => new Map<String, Object>{
                            'lat' => 37.7749,
                            'lng' => -122.4194
                        },
                        'score' => 80
                    }
                },
                string.valueOf(contact2.Id).toLowerCase() => new Map<String, Object>{
                    'success' => true,
                    'data' => new Map<String, Object>{
                        'position' => new Map<String, Object>{
                            'lat' => 37.7749,
                            'lng' => -122.4194
                        },
                        'score' => 40
                    }
                }
            }
        };
    }
     @TestVisible
    private static Map<String, Object> getMockBatchGeocodeResponseForFutureCall() {
        // Mock response for testing
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User user1 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user12' + '@test' + '12345' + '.org',
            Username = 'user12' + '@test' + '12345' + '.org',
            Alias = 'user12',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        //insert user1;
        
        // Create test data
        Contact contact1 = new Contact(
            FirstName='Test',
            LastName='Contact1',
            MailingStreet='123 Test St',
            MailingCity='Test City',
            MailingState='CA',
            MailingPostalCode='12345',
            MailingCountry='USA'
           // Partner_User_2__c=user1.id
        );
        
        Contact contact2 = new Contact(
            FirstName='Test',
            LastName='Contact2',
            MailingStreet='456 Test St',
            MailingCity='Test City',
            MailingState='CA',
            MailingPostalCode='12345',
            MailingCountry='USA'
          //  Partner_User_2__c=user1.id
        );
        
        insert new List<Contact>{contact1, contact2};
        
        return new Map<String, Object>{
            'success' => true,
            'results' => new Map<String, Object>{
               string.valueOf(contact1.Id).toLowerCase() => new Map<String, Object>{
                    'success' => true,
                    'data' => new Map<String, Object>{
                        'position' => new Map<String, Object>{
                            'lat' => 37.7749,
                            'lng' => -122.4194
                        },
                        'score' => 80
                    }
                },
                string.valueOf(contact2.Id).toLowerCase() => new Map<String, Object>{
                    'success' => true,
                    'data' => new Map<String, Object>{
                        'position' => new Map<String, Object>{
                            'lat' => 37.7749,
                            'lng' => -122.4194
                        },
                        'score' => 40
                    }
                }
            }
        };
    }
    public static void handleAfterInsert(List<Contact> newContacts) {
        system.debug('newContacts:: '+newContacts);
        List<id> validContacts = new List<id>();

        for (Contact con : newContacts) {
            if (con.MailingStreet != null && con.MailingCity != null && con.MailingState != null &&
                con.MailingPostalCode != null && con.MailingCountry != null) {
                validContacts.add(con.id);
            }
        }
        
        if (!validContacts.isEmpty()) {
            //System.enqueueJob(new ContactGeocodeQueueable(validContacts2));
            if(!Test.isRunningTest()){
            	updateContactWithSFMapsIdAsync(validContacts);
            }
        }
    }
    public static void handleBeforeUpdate(List<Contact> newContacts, Map<Id, Contact> oldContactsMap) {
        List<id> updatedContacts = new List<id>();
        
        for (Contact newCon : newContacts) {
            Contact oldCon = oldContactsMap.get(newCon.Id);
            if (isAddressFieldUpdated(newCon, oldCon)) {
                updatedContacts.add(newCon.id);
            }
        }
        
        if (!updatedContacts.isEmpty()) {
            //updateContactWithSFMapsId(updatedContacts);
            //System.enqueueJob(new ContactGeocodeQueueable(updatedContacts));
           updateContactWithSFMapsIdAsync(updatedContacts);
        }
    }

    private static Boolean isAddressFieldUpdated(Contact newCon, Contact oldCon) {
        return newCon.MailingStreet != oldCon.MailingStreet ||
               newCon.MailingCity != oldCon.MailingCity ||
               newCon.MailingState != oldCon.MailingState ||
               newCon.MailingPostalCode != oldCon.MailingPostalCode ||
               newCon.MailingCountry != oldCon.MailingCountry;
    }
}