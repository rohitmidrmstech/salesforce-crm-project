@isTest
public class ContactDistanceControllerTest {
    @isTest
    static void testGetNearestContactRoofing() {
        // Create test data
        Lead lead = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Street='123 Test St', City='Test City', State='Test State', PostalCode='12345', Country='Test Country', Business_Unit__c = 'Residential Roofing');
        insert lead;
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User user1 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user1' + '@test' + '12345' + '.org',
            Username = 'user1' + '@test' + '12345' + '.org',
            Alias = 'user1abc',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        insert user1;
        
        User user2 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user2' + '@test' + '12345' + '.org',
            Username = 'user2' + '@test' + '12345' + '.org',
            Alias = 'user2abc',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        insert user2;
        
        User user3 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user3' + '@test' + '12345' + '.org',
            Username = 'user3' + '@test' + '12345' + '.org',
            Alias = 'user3abc',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        insert user3;
        
        Contact contact1 = new Contact(FirstName='Contact1', LastName='Last1', MailingStreet='123 Contact St', MailingCity='Contact City', MailingState='Contact State', MailingPostalCode='12345', MailingCountry='Contact Country', Email='contact1@test.com', Phone='1234567890', Geolocation__Latitude__s=37.7749, Geolocation__Longitude__s=-122.4194, Partner_User_2__c=user1.id);
        Contact contact2 = new Contact(FirstName='Contact2', LastName='Last2', MailingStreet='456 Contact St', MailingCity='Contact City', MailingState='Contact State', MailingPostalCode='12345', MailingCountry='Contact Country', Email='contact2@test.com', Phone='1234567890', Geolocation__Latitude__s=37.7749, Geolocation__Longitude__s=-122.4194, Partner_User_2__c=user2.id);
        Contact contact3 = new Contact(FirstName='Contact3', LastName='Last3', MailingStreet='789 Contact St', MailingCity='Contact City', MailingState='Contact State', MailingPostalCode='12345', MailingCountry='Contact Country', Email='contact3@test.com', Phone='1234567890', Geolocation__Latitude__s=37.7749, Geolocation__Longitude__s=-122.4194, Partner_User_2__c=user3.id);
        insert new List<Contact>{contact1, contact2, contact3};
            
            Credential__c cred1=new Credential__c(Name='Select ShingleMaster');
        insert cred1;
        
        
        Assigned_Credential__c ac1 = new Assigned_Credential__c(Contact__c=contact1.Id, Credential__c=cred1.id);
        Assigned_Credential__c ac2 = new Assigned_Credential__c(Contact__c=contact2.Id, Credential__c=cred1.id);
        Assigned_Credential__c ac3 = new Assigned_Credential__c(Contact__c=contact3.Id, Credential__c=cred1.id);
        insert new List<Assigned_Credential__c>{ac1, ac2, ac3};
            
            Test.startTest();
        
        // Create a mock response for the Maps API
        Map<String, Object> mockResponse = new Map<String, Object>{
            'baseUrl' => 'https://example.com',
                'data' => new Map<String, Object>{
                    'position' => new Map<String, Object>{
                        'lat' => 37.7749,
                            'lng' => -122.4194
                            }
                }
        };
            //  Test.setMock(HttpCalloutMock.class, new MockMapsAPI(mockResponse));
            
            List<List<ContractorRecommendation>> result = ContactDistanceController.getNearestContact(new List<Id>{lead.Id});
        
        Test.stopTest();
        
        // Verify the results
        /* System.assertEquals(1, result.size());
System.assertEquals(3, result[0].size());
System.assert(result[0][0].distance != null);
System.assert(result[0][0].contact != null);
System.assert(result[0][0].ac != null);*/
    }
    
    @isTest
    static void testGetNearestContactSiding() {
        // Create test data
        Lead lead = new Lead(FirstName='Test', LastName='Lead', Company='Test Company', Street='123 Test St', City='Test City', State='Test State', PostalCode='12345', Country='Test Country', Business_Unit__c = 'Siding');
        insert lead;
        
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        
        User user1 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user1' + '@test' + '12345' + '.org',
            Username = 'user1' + '@test' + '12345' + '.org',
            Alias = 'user1abc',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        insert user1;
        
        User user2 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user2' + '@test' + '12345' + '.org',
            Username = 'user2' + '@test' + '12345' + '.org',
            Alias = 'user2abc',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        insert user2;
        
        User user3 = new User(
            FirstName = 'Test',
            LastName = 'Standard',
            email = 'user3' + '@test' + '12345' + '.org',
            Username = 'user3' + '@test' + '12345' + '.org',
            Alias = 'user3abc',
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            IsActive = True,
            ProfileId = profile.Id
        );
        insert user3;
        
        Contact contact1 = new Contact(FirstName='Contact1', LastName='Last1', MailingStreet='123 Contact St', MailingCity='Contact City', MailingState='Contact State', MailingPostalCode='12345', MailingCountry='Contact Country', Email='contact1@test.com', Phone='1234567890', Geolocation__Latitude__s=37.7749, Geolocation__Longitude__s=-122.4194, Partner_User_2__c=user1.id);
        Contact contact2 = new Contact(FirstName='Contact2', LastName='Last2', MailingStreet='456 Contact St', MailingCity='Contact City', MailingState='Contact State', MailingPostalCode='12345', MailingCountry='Contact Country', Email='contact2@test.com', Phone='1234567890', Geolocation__Latitude__s=37.7749, Geolocation__Longitude__s=-122.4194, Partner_User_2__c=user2.id);
        Contact contact3 = new Contact(FirstName='Contact3', LastName='Last3', MailingStreet='789 Contact St', MailingCity='Contact City', MailingState='Contact State', MailingPostalCode='12345', MailingCountry='Contact Country', Email='contact3@test.com', Phone='1234567890', Geolocation__Latitude__s=37.7749, Geolocation__Longitude__s=-122.4194, Partner_User_2__c=user3.id);
        insert new List<Contact>{contact1, contact2, contact3};
            
            Credential__c cred1=new Credential__c(Name='Siding5Star');
        insert cred1;
        
        Assigned_Credential__c ac1 = new Assigned_Credential__c(Contact__c=contact1.Id, Credential__c=cred1.id);
        Assigned_Credential__c ac2 = new Assigned_Credential__c(Contact__c=contact2.Id, Credential__c=cred1.id);
        Assigned_Credential__c ac3 = new Assigned_Credential__c(Contact__c=contact3.Id, Credential__c=cred1.id);
        insert new List<Assigned_Credential__c>{ac1, ac2, ac3};
            
            Test.startTest();
        
        // Create a mock response for the Maps API
        Map<String, Object> mockResponse = new Map<String, Object>{
            'baseUrl' => 'https://example.com',
                'data' => new Map<String, Object>{
                    'position' => new Map<String, Object>{
                        'lat' => 37.7749,
                            'lng' => -122.4194
                            }
                }
        };
            //  Test.setMock(HttpCalloutMock.class, new MockMapsAPI(mockResponse));
            
            List<List<ContractorRecommendation>> result = ContactDistanceController.getNearestContact(new List<Id>{lead.Id});
        
        Test.stopTest();
        
        // Verify the results
        /* System.assertEquals(1, result.size());
System.assertEquals(3, result[0].size());
System.assert(result[0][0].distance != null);
System.assert(result[0][0].contact != null);
System.assert(result[0][0].ac != null);*/
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
    
    @isTest
    static void testGetNearestContactException() {
        //Test.setMock(HttpCalloutMock.class, new MockMapsAPI(mockResponse));
        Test.startTest();
        List<List<ContractorRecommendation>> result = ContactDistanceController.getNearestContact(null);
        
        Test.stopTest();
    }
}