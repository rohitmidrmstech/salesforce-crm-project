@isTest
public class OffSite_OpportunityDistance_CntTest {
    
    @isTest
    public static void testGetLatLng() {
        // Test data
        List<String> lstOppAddress = new List<String>();
        lstOppAddress.add('123 Main St, City, State');
        
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
        List<String> result = OffSite_OpportunityDistance_Controller.getLatLng(lstOppAddress);
        
        // Assert the result
        System.assertEquals(1, result.size());
        System.assertEquals('37.12345@-122.54321', result[0]);
    }
}