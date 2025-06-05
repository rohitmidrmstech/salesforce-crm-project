@isTest
public class OffSite_PlantDistance_ControllerTest {
    
    @isTest
    public static void testGetNearestPlant() {
        // Test data
        List<String> lstAddress = new List<String>();
        lstAddress.add('123 Main St, City, State@G');
		
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
        
        // Create test plants
        Plants__c testPlant1 = new Plants__c(
            Name = 'Plant 1',
            Street__c = '123 Plant St',
            City__c = 'City',
            State_Province__c = 'TX',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = '1006',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = 37.123,
            Geocode__Longitude__s = -122.543, 
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
            Geocode__Latitude__s = 37.456,
            Geocode__Longitude__s = -122.654, 
            SAP_Plant__c = '0640'
        );
        
        // Insert test plants
        List<Plants__c> testPlants = new List<Plants__c>{ testPlant1, testPlant2 };
        insert testPlants;
        
        // Call the method under test
        List<String> result = OffSite_PlantDistance_Controller.getNearestPlant(lstAddress);
        
        // Assert the result
       System.assertEquals(1, result.size());
       System.assertEquals(testPlant1.Id, result[0]);
    }
    @isTest
    public static void testGetNearestPlant1() {
        // Test data
        List<String> lstAddress = new List<String>();
        lstAddress.add('123 Main St, City, State@I');
		
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
        
        // Create test plants
        Plants__c testPlant1 = new Plants__c(
            Name = 'Plant 1',
            Street__c = '123 Plant St',
            City__c = 'City',
            State_Province__c = 'TX',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = '1503',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = 37.123,
            Geocode__Longitude__s = -122.543, 
            SAP_Plant__c = '0640'
        );
        Plants__c testPlant2 = new Plants__c(
            Name = 'Plant 2',
            Street__c = '456 Plant St',
            City__c = 'City',
            State_Province__c = 'TX',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = '1300',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = 37.456,
            Geocode__Longitude__s = -122.654, 
            SAP_Plant__c = '0640'
        );
        
        // Insert test plants
        List<Plants__c> testPlants = new List<Plants__c>{ testPlant1, testPlant2 };
        insert testPlants;
        
        // Call the method under test
        List<String> result = OffSite_PlantDistance_Controller.getNearestPlant(lstAddress);
        
        // Assert the result
       System.assertEquals(1, result.size());
       System.assertEquals(testPlant1.Id, result[0]);
    }
    @isTest
    public static void testGetNearestPlant2() {
        // Test data
        List<String> lstAddress = new List<String>();
        lstAddress.add('123 Main St, City, State@R');
		
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
        
        // Create test plants
        Plants__c testPlant1 = new Plants__c(
            Name = 'Plant 1',
            Street__c = '123 Plant St',
            City__c = 'City',
            State_Province__c = 'TX',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = '1501',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = 37.123,
            Geocode__Longitude__s = -122.543, 
            SAP_Plant__c = '0640'
        );
        Plants__c testPlant2 = new Plants__c(
            Name = 'Plant 2',
            Street__c = '456 Plant St',
            City__c = 'City',
            State_Province__c = 'TX',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = '1102',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = 37.456,
            Geocode__Longitude__s = -122.654, 
            SAP_Plant__c = '0640'
        );
        
        // Insert test plants
        List<Plants__c> testPlants = new List<Plants__c>{ testPlant1, testPlant2 };
        insert testPlants;
        
        // Call the method under test
        List<String> result = OffSite_PlantDistance_Controller.getNearestPlant(lstAddress);
        
        // Assert the result
       System.assertEquals(1, result.size());
       System.assertEquals(testPlant1.Id, result[0]);
    }
    @isTest
    public static void testGetNearestPlant3() {
        // Test data
        List<String> lstAddress = new List<String>();
        lstAddress.add('123 Main St, City, State@S');
		
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
        
        // Create test plants
        Plants__c testPlant1 = new Plants__c(
            Name = 'Plant 1',
            Street__c = '123 Plant St',
            City__c = 'City',
            State_Province__c = 'TX',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = '1502',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = 37.123,
            Geocode__Longitude__s = -122.543, 
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
            Geocode__Latitude__s = 37.456,
            Geocode__Longitude__s = -122.654, 
            SAP_Plant__c = '0640'
        );
        
        // Insert test plants
        List<Plants__c> testPlants = new List<Plants__c>{ testPlant1, testPlant2 };
        insert testPlants;
        
        // Call the method under test
        List<String> result = OffSite_PlantDistance_Controller.getNearestPlant(lstAddress);
        
        // Assert the result
       System.assertEquals(1, result.size());
       System.assertEquals(testPlant1.Id, result[0]);
    }
    @isTest
    public static void testGetNearestPlant4() {
        // Test data
        List<String> lstAddress = new List<String>();
        lstAddress.add('123 Main St, City, State@O');
		
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
        
        // Create test plants
        Plants__c testPlant1 = new Plants__c(
            Name = 'Plant 1',
            Street__c = '123 Plant St',
            City__c = 'City',
            State_Province__c = 'TX',
            Postal_Code__c = '12345',
            Country__c = 'Country',
            SOrg__c = 'OPA',
            Warehouse_Status__c = 'Active',
            Geocode__Latitude__s = 37.123,
            Geocode__Longitude__s = -122.543, 
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
            Geocode__Latitude__s = 37.456,
            Geocode__Longitude__s = -122.654, 
            SAP_Plant__c = '0640'
        );
        
        // Insert test plants
        List<Plants__c> testPlants = new List<Plants__c>{ testPlant1, testPlant2 };
        insert testPlants;
        
        // Call the method under test
        List<String> result = OffSite_PlantDistance_Controller.getNearestPlant(lstAddress);
        
        // Assert the result
       System.assertEquals(1, result.size());
       System.assertEquals(testPlant1.Id, result[0]);
    }
}