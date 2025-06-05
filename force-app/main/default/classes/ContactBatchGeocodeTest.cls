@isTest
public class ContactBatchGeocodeTest {
    @isTest
    static void testUpdateContactWithSFMaps() {
        Automation_Controller__c control = Automation_Controller__c.getInstance();
        control.All_Triggers_enabled__c = true;
        upsert control; 
        
       Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User user1 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user11' + '@test' + '12345' + '.org',
            Username = 'user11' + '@test' + '12345' + '.org',
            Alias = 'user11',
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
        contact2.MailingCity ='Test City 2';
        update contact2;
        
        Test.startTest();
        
     // Mock the API response
        Map<String, Object> mockResponse = new Map<String, Object>{
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
                        'score' => 80
                    }
                }
            }
        };
            system.debug('mockResponse:: '+mockResponse);
        //Test.setMock(HttpCalloutMock.class, new MockMapsAPI(mockResponse));
        
        // Call the method
        ContactBatchGeocode.updateContactWithSFMaps('CA');
        
        Test.stopTest();
        
        // Verify the results
        List<Contact> updatedContacts = [SELECT id,Geolocation__Latitude__s, Geolocation__Longitude__s FROM Contact WHERE Id IN :new List<Id>{contact1.Id, contact2.Id}];
     system.debug('updatedContacts:: '+updatedContacts);
        // System.assertEquals(37.7749, updatedContacts[0].Geolocation__Latitude__s);
       // System.assertEquals(-122.4194, updatedContacts[0].Geolocation__Longitude__s);
       // System.assertEquals(37.7749, updatedContacts[1].Geolocation__Latitude__s);
       // System.assertEquals(-122.4194, updatedContacts[1].Geolocation__Longitude__s);
    }
    
    private class MockMapsAPI implements HttpCalloutMock {
        private Map<String, Object> mockResponse;
        
        public MockMapsAPI(Map<String, Object> mockResponse) {
            this.mockResponse = mockResponse;
        }
        
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(JSON.serialize(mockResponse));
            res.setStatusCode(200);
            return res;
        }
    }
}