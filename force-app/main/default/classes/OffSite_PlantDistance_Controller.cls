public class OffSite_PlantDistance_Controller {
    
    @InvocableMethod(label='OffSite_Plant_Distance' description='Get closest plant from account')
    public static List<String> getNearestPlant(List<String> lstAddress){
        
        try{
            
            Location opportunityLocation = new Location();
            
            List<Location> plantLocations = new List<Location>();
            Map<double,id> lstDistanceMap = new Map<double,id>();
            List<Double> lstDistance = new List<Double>();
            
            
            String inputAddress = lstAddress[0].SubStringBefore('@');
            String plantType = lstAddress[0].SubStringAfter('@');
            List<String> plantSearch = new List<String>();
            
            if(plantType == 'G'){
                plantSearch.add('1006');
                plantSearch.add('1007');
                plantSearch.add('1008');
                plantSearch.add('1009');
                plantSearch.add('1010');
                plantSearch.add('1011');
                plantSearch.add('1012');
                plantSearch.add('1100');
                plantSearch.add('1016');                
            }
            else if(plantType == 'I'){
                plantSearch.add('1503');
                plantSearch.add('1300');
            }
            else if(plantType == 'R'){
                plantSearch.add('1501');
                plantSearch.add('1102');
            }
            else if(plantType == 'S'){
                plantSearch.add('1502');
            }
            else if(plantType == 'O'){
                plantSearch.add('OPA');
            }
            
            
            List<Plants__c> lstPlants = [Select Id, Name,Street__c, City__c, State_Province__c, Postal_Code__c, Country__c,SOrg__c,Warehouse_Status__c,Geocode__c, Geocode__Latitude__s,Geocode__Longitude__s 
                                         FROM Plants__c 
                                         WHERE SOrg__c IN :plantSearch AND Warehouse_Status__c = 'Active' AND Geocode__Latitude__s != NULL AND Geocode__Longitude__s != NULL AND SOrg__c != NULL];
            
            
            Map<string,object> options = new Map<String,Object> {
                'version' => '1', // Required. Version of the API endpoint. Must be '1'.
                    'address' => inputAddress
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
            
            opportunityLocation = Location.newInstance(lat,lng);
            
            for(Plants__c p : lstPlants){
                Location ploc = Location.newInstance(p.Geocode__Latitude__s,p.Geocode__Longitude__s);
                Double dist = Location.getDistance(opportunityLocation, ploc, 'mi');
                
                //system.debug('Distance => ' + dist);
                lstDistanceMap.put(dist, p.Id);
                lstDistance.add(dist);
            }
            
            lstDistance.sort();
            
            Id plantId = lstDistanceMap.get(lstDistance[0]);
            system.debug('Plant Id =>' + plantId + '|Distance => ' + lstDistance[0]);    
            
            List<String> lstPlantId = new List<String>();
            lstPlantId.add(plantId);
            
            return lstPlantId;
            
        }
        catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            
            List<String> lstError = new List<String>();
            lstError.add(e.getMessage());
            return lstError;
        }
        
    }
    
}