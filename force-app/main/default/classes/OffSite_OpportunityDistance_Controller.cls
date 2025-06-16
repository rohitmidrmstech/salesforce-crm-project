public class OffSite_OpportunityDistance_Controller {

    @InvocableMethod(label='OffSite_Opportunity_Distance' description='Get closest plant from Opportunity Address')
    public static List<String> getLatLng(List<String> lstOppAddress){
        
        try{
            
            Location opportunityLocation = new Location();
            
            List<Location> plantLocations = new List<Location>();
            Map<double,id> lstDistanceMap = new Map<double,id>();
            List<Double> lstDistance = new List<Double>();
            
            Map<string,object> options = new Map<String,Object> {
                'version' => '1', // Required. Version of the API endpoint. Must be '1'.
                    'address' => lstOppAddress[0]
            };
            
            // Call the Geocode() method with the address.
        Map<String, Object> lstCoordinatesMap = (Test.isRunningTest() ? new Map<String, Object>{'baseUrl' => 'https://example.com','data' => new Map<String, Object>{'position' => new Map<String, Object>{ 'lat' => 37.12345,'lng' => -122.54321}}} :
														maps.API.Geocode(options) );
            
            //system.debug(lstCoordinatesMap.get('baseUrl'));
            
            Map<String, Object> cData = (Map<String, Object>)lstCoordinatesMap.get('data');
            Map<String, Object> cPos = (Map<String, Object>)cData.get('position');
            
            system.debug('lat:' + cPos.get('lat') + 'lng:' + cPos.get('lng'));
            
            Double lat = (Double) cPos.get('lat');
            Double lng = (Double) cPos.get('lng');      
            
            List<String> lstLatLng = new List<String>();
            String coordinates = lat + '@' + lng;
            lstLatLng.add(coordinates);
            
            return lstLatLng;
            
        }   
        catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
			List<String> ex = new List<String>();
            ex.add(e.getMessage());
            return ex;
        }
   
	}
}