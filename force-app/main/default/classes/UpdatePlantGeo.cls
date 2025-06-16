public class UpdatePlantGeo {
    
    public static void updateGeo(){
        
        try{
            
            Location opportunityLocation = new Location();
            
            List<Location> plantLocations = new List<Location>();
            Map<double,id> lstDistanceMap = new Map<double,id>();
            List<Double> lstDistance = new List<Double>();
            
            List<Plants__c> lstPlants = [Select Id, Name,Street__c, City__c, State_Province__c, Postal_Code__c, Country__c,SOrg__c,Warehouse_Status__c,Geocode__c 
										FROM Plants__c 
										WHERE (Street__c != NULL AND City__c != NULL AND State_Province__c != NULL AND Postal_Code__c != NULL) AND SOrg__c != NULL AND Warehouse_Status__c = 'Active' AND (Geocode__Latitude__s = NULL OR Geocode__Longitude__s = NULL)];
            
            System.debug('lstPlants'+lstPlants); 
            for(Plants__c p : lstPlants){
                Map<string,object> options = new Map<String,Object> {
                    'version' => '1', // Required. Version of the API endpoint. Must be '1'.
                        'address' => p.Street__c + ' ' + p.City__c + ',' + p.State_Province__c + ' ' + p.Postal_Code__c + ' ' + p.Country__c
                };
                 System.debug('options'+options);   
                // Call the Geocode() method with the address.
              Map<String, Object> lstCoordinatesMap = (Test.isRunningTest() ? new Map<String, Object>{'baseUrl' => 'https://example.com','data' => new Map<String, Object>{'position' => new Map<String, Object>{ 'lat' => 37.12345,'lng' => -122.54321}}} :
														maps.API.Geocode(options) );
														 
                                                             
                  //   Map<String, Object> lstCoordinatesMap = maps.API.Geocode(options);                                       
                    
                //system.debug(lstCoordinatesMap.get('baseUrl'));
                
                Map<String, Object> cData = (Map<String, Object>)lstCoordinatesMap.get('data');
                Map<String, Object> cPos = (Map<String, Object>)cData.get('position');
                
                system.debug('lat:' + cPos.get('lat') + 'lng:' + cPos.get('lng'));
                
                Double lat = (Double) cPos.get('lat');
                Double lng = (Double) cPos.get('lng');      
                
                p.Geocode__Latitude__s = lat;
                p.Geocode__Longitude__s = lng;

        		}
            
            Update lstPlants;
            
        }    
            
        catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());

        }
   
	}
}