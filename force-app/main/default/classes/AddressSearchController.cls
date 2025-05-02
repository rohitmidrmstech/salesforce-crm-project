public class AddressSearchController {
 //Method to call Google Map API and fetch the address recommendations 
    @AuraEnabled
    public static String getAddressRecommendations(String searchText){
        System.debug('searchText' + searchText);
        String apiKey = 'AIzaSyC5nWtBJ-z_oOaMx10ixFThqZ5SVhVbcCY';//YOUR_API_KEY
        String result = null;
        try{
            if(searchText != null){
                String apiUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + searchText.replace(' ', '%20') + '&key=' + apiKey; 
                System.debug('apiUrl' + apiUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(apiUrl);
                Http http = new Http();
                HttpResponse res = http.send(req);
                System.debug('res' + res);
                Integer statusCode = res.getStatusCode();
               System.debug('statusCode' + statusCode);
                if(statusCode == 200){
                    result = res.getBody();
                   System.debug('result' + result);
                }
            }
        } catch(exception e){
            System.debug(e.getMessage());
        }
        return result;
    }
    
    //Method to call Google Map API and fetch the address details by placeId 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String placeId){
         System.debug('placeId' + placeId);
        String apiKey = 'AIzaSyC5nWtBJ-z_oOaMx10ixFThqZ5SVhVbcCY';//YOUR_API_KEY
        String result = null;
        try{
            if(placeId != null){
                String apiUrl = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=' + placeId.replace(' ', '%20') + '&key=' + apiKey;
                System.debug('apiUrl' + apiUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(apiUrl);
                Http http = new Http();
                HttpResponse res = http.send(req);
                System.debug('res' + res);
                Integer statusCode = res.getStatusCode();
                if(statusCode == 200){
                    result = res.getBody();
                    System.debug('result' + result); 
                }
            }
        } catch(exception e){
            System.debug(e.getMessage());
        }
        return result;
    }
    
    //Method to update the address on Account
    @AuraEnabled
    public static void updateAddressDetails(String jsonAddress) {
        System.debug('jsonAddress' + jsonAddress); 
        Address addressDetail = (Address)JSON.deserialize(jsonAddress, Address.Class);
         System.debug('addressDetail' + addressDetail); 
        if(addressDetail != null && !String.isBlank(addressDetail.Id)) {
            Account acc = new Account();
            acc.Id = addressDetail.Id;
              System.debug('acc.Id' + acc.Id); 
            acc.BillingState = addressDetail.state;
            System.debug('acc.BillingState' + acc.BillingState);
            acc.BillingCity = addressDetail.city;
            acc.BillingCountry = addressDetail.country;
            acc.BillingPostalCode = addressDetail.postalCode;
            acc.BillingStreet = addressDetail.streetNumber;
            update acc;
            System.debug('acc' + acc);
        }
    }
    
    public class Address {
        public String Id {get; set;}
        public String city {get; set;}
        public String country {get; set;}
        public String state {get; set;}
        public String postalCode {get; set;}
        public String subLocal2 {get; set;}
        public String subLocal1 {get; set;}
        public String streetNumber {get; set;}
        public String route {get; set;}
    }
}