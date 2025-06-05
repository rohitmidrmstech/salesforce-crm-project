/****************************************************************************************
* @Author       Lou Bui
* @Date         08/23/2024
* @Description  
Class used in Community_Lead_Assignment screen flow to find nearest
Credential contractor to lead address for community user.
*****************************************************************************************/

public class ContactDistanceController {
    
    @InvocableMethod(label='ContactDistanceController' description='Get closest contacts from lead address')
    
    public static List<List<ContractorRecommendation>> getNearestContact(List<Id> lstLeadId){
        
        try{
            
            Id leadId = lstLeadId[0];
            Lead leadRecord = [SELECT Id,Street,City,State,PostalCode,Country,Business_Unit__c FROM Lead WHERE id = :leadId];
            String inputAddress = leadRecord.Street	+ ' ' + leadRecord.City + ',' + leadRecord.State + ',' + leadRecord.PostalCode + ',' + leadRecord.Country;
            
            Location leadLocation = new Location();
            List<Location> contactLocations = new List<Location>();
            List<ContractorRecommendation> lstRecommendation = new List<ContractorRecommendation>();   
            
            List<String> sidingCredentials = new List<String>{'Silver Star Siding','Siding5Star'};
                List<String> roofingCredentials = new List<String>{'ShingleMaster','Select ShingleMaster'};
                    
                    List<String> selectedCredentials = new List<String>();
            
            if(leadRecord.Business_Unit__c == 'Residential Roofing'){
                selectedCredentials = roofingCredentials;
            }
            else if(leadRecord.Business_Unit__c == 'Siding'){
                selectedCredentials = sidingCredentials;
            }
            
            
            //Get list of Assigned Credentials for contacts.
            List<Assigned_Credential__c> lstAssignedCredentials = [SELECT Name,
                                                                   Contact__c,
                                                                   Contact__r.FirstName, 
                                                                   Contact__r.LastName, 
                                                                   Contact__r.MailingStreet,
                                                                   Contact__r.MailingCity,
                                                                   Contact__r.MailingState,
                                                                   Contact__r.MailingPostalCode,
                                                                   Contact__r.MailingCountry,
                                                                   Contact__r.Email, 
                                                                   Contact__r.Phone, 
                                                                   Contact__r.Geolocation__c, 
                                                                   Contact__r.Geolocation__Latitude__s, 
                                                                   Contact__r.Geolocation__Longitude__s, 
                                                                   Contact__r.Partner_User_2__c,
                                                                   Contact__r.Partner_User_2__r.IsActive, 
                                                                   Credential__r.name 
                                                                   FROM Assigned_Credential__c 
                                                                   WHERE Contact__c != null AND (Contact__r.Geolocation__Latitude__s != null AND Contact__r.Geolocation__Longitude__s != null) 
                                                                   AND (Contact__r.Partner_User_2__c != null AND Contact__r.Partner_User_2__r.IsActive = TRUE) AND (Credential__r.name IN :selectedCredentials)];
            Map<Id,String> mapAssignedCredential = new Map<Id,String>(); 
            Set<Id> uniqueContacts = new Set<Id>();
            
            
            for(Assigned_Credential__c ac : lstAssignedCredentials){
                if(mapAssignedCredential.containsKey(ac.Contact__c)){
                    string concatAc = mapAssignedCredential.get(ac.Contact__c) + ',' + ac.Credential__r.name;
                    mapAssignedCredential.put(ac.Contact__c,concatAc);
                }
                else{
                    mapAssignedCredential.put(ac.Contact__c,ac.Credential__r.name);
                }
                uniqueContacts.add(ac.Contact__c);
            }
            
            
            //Call Map API to get geo location for lead address.
            Map<string,object> options = new Map<String,Object> {
                'version' => '1', // Required. Version of the API endpoint. Must be '1'.
                    'address' => inputAddress
                    };
                        
                        // Call the Geocode() method with the address.
                        Map<String, Object> lstCoordinatesMap = (Test.isRunningTest() ? new Map<String, Object>{'baseUrl' => 'https://example.com','data' => new Map<String, Object>{'position' => new Map<String, Object>{ 'lat' => 37.12345,'lng' => -122.54321}}} :
                                                                 maps.API.Geocode(options) );
            
            Map<String, Object> cData = (Map<String, Object>)lstCoordinatesMap.get('data');
            Map<String, Object> cPos = (Map<String, Object>)cData.get('position');
            
            Double lat = (Double) cPos.get('lat');
            Double lng = (Double) cPos.get('lng');
            
            leadLocation = Location.newInstance(lat,lng);
            
            Map<Decimal,Contact> mapContactDistance = new Map<Decimal,Contact>();
            List<Decimal> lstDistance = new List<Decimal>();
            
            Map<Id,Contact> mapContacts = new Map<Id,Contact>([SELECT Id, AccountId,Sales_Org_Account_Name__c,Name,MailingAddress,
                                                               Company_Name__c,FirstName,LastName,MailingStreet,MailingCity,MailingState,
                                                               MailingPostalCode,MailingCountry,Email,Phone,
                                                               Geolocation__c,Geolocation__Latitude__s,Geolocation__Longitude__s,Partner_User_2__c,Partner_User_2__r.IsActive
                                                               FROM Contact WHERE Id IN :uniqueContacts]);
            
            
            //system.debug('mapContacts => ' + mapContacts);
            //Loop through contact geolocation and get distance in miles from lead address.
            for(Assigned_Credential__c c : lstAssignedCredentials){
                Decimal distance = Location.getDistance(leadLocation, c.Contact__r.Geolocation__c, 'mi');
                if(!mapContactDistance.containsKey(distance)){
                    lstDistance.add(distance);
                    mapContactDistance.put(distance,mapContacts.get(c.Contact__c));
                }
                
            }
            
            lstDistance.sort();
            //system.debug('lstDistance => ' + lstDistance);
            
            
            integer contractorCount = 0;
            
            List<Id> lstRecommendationAccountIds = new List<Id>();
            
            for(Decimal d : lstDistance){
                if(contractorCount < 3){
                    Id acctId = mapContactDistance.get(d).AccountId;
                    if(!lstRecommendationAccountIds.contains(acctId)){
                        ContractorRecommendation cr = new ContractorRecommendation();
                        cr.distance = d;
                        cr.contact = mapContactDistance.get(d);
                        Id contactId = mapContactDistance.get(d).id;
                        cr.ac = mapAssignedCredential.get(contactId);
                        lstRecommendationAccountIds.add(mapContactDistance.get(d).AccountId);
                        lstRecommendation.add(cr);  
                        contractorCount++;     
                    }
                }
            }
            
            List< List<ContractorRecommendation>> lstRecommendations = new  List<List<ContractorRecommendation>>();
            lstRecommendations.add(lstRecommendation);
            return lstRecommendations;
            
        }
        catch(Exception e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            
            List<String> lstError = new List<String>();
            List<List<String>> lstErrors = new List<List<String>>();
            lstError.add(e.getMessage());
            lstErrors.add(lstError);
            
            List<ContractorRecommendation> lstRecommendation = new List<ContractorRecommendation>();
            List<List<ContractorRecommendation>> lstRecommendations = new  List<List<ContractorRecommendation>>();
            lstRecommendations.add(lstRecommendation);
            return lstRecommendations;
        }
        
    }
    
}