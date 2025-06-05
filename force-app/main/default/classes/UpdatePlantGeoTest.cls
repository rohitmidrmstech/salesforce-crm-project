@isTest
public class UpdatePlantGeoTest {
    
    @isTest
    public static void testUpdateGeo() {
        // Create test plants
        Plants__c testPlant1 = new Plants__c(
            Name = 'Plant 1',
            Street__c = '123 Plant St',
            City__c = 'City',
            State_Province__c = 'Tx',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = '1006',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = null,
            Geocode__Longitude__s = null,
            SAP_Plant__c = '0640'
        );
        Plants__c testPlant2 = new Plants__c(
            Name = 'Plant 2',
            Street__c = '456 Plant St',
            City__c = 'City',
            State_Province__c = 'TX',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = '1007',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = null,
            Geocode__Longitude__s = null, 
            SAP_Plant__c = '0640'
        );
        
        // Insert test plants
        List<Plants__c> testPlants = new List<Plants__c>{ testPlant1, testPlant2 };
        insert testPlants;
        
        // Mock Geocode response
        Map<String, Object> mockGeocodeResponse = new Map<String, Object>{
            'baseUrl' => 'https://example.com',
            'data' => new Map<String, Object>{
                'position' => new Map<String, Object>{
                    'lat' => 37.12345,
                    'lng' => -122.54321
                }
            }
        };
        
        // Set up mock callout
        Test.setMock(
            HttpCalloutMock.class,
            new maps_API_GeocodeMock(mockGeocodeResponse)
        );
   
        // Call the method under test
        Test.startTest();
        UpdatePlantGeo.updateGeo();
        Test.stopTest();
        
        // Retrieve the updated plants
        List<Plants__c> updatedPlants = [SELECT Id, Name, Geocode__Latitude__s, Geocode__Longitude__s FROM Plants__c WHERE Id IN :testPlants];
        
        // Assert the updated values
        for (Plants__c p : updatedPlants) {
            System.assertNotEquals(null, p.Geocode__Latitude__s);
            System.assertNotEquals(null, p.Geocode__Longitude__s);
       }
    }
}