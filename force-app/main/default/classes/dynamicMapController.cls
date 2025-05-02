public class dynamicMapController {
 @AuraEnabled
    public static string getAllOrder(Date sdate){ 
        string query = 'select id,Name,Geolocation__c,MailingAddress,Description,Next_Meeting__c from Contact where Next_Meeting__c =:sdate limit 10';
        string baseUrl = URL.getSalesforceBaseUrl().toExternalForm();
        system.debug('query ==> '+query);
        system.debug('baseUrl ==> '+baseUrl);

        list< map<string,object>> markerList = new list< map<string,object>>();
        for(Contact order : Database.query(query)){          
            if(order.Geolocation__c != null){
                  String address;
        //address = 'Soham Technologies Solution Sector 135 Yerwada';
        //address = EncodingUtil.urlEncode(address, 'UTF-8');       
        // build callout
        Http h = new Http();        
        HttpRequest req = new HttpRequest();
      // url: 'https://maps.googleapis.com/maps/api/directions/json?origin=Toronto&destination=Montreal&key=YOUR_API_KEY',      
	String yourAPiKey = 'AIzaSyDADwt5hduB2UPZsHaYbZrhG4CuISd-h7c'; // Enter your Api key which you have created in google api console
        String key = '&key=' + yourAPiKey;
        String endPoint = 'https://maps.googleapis.com/maps/api/directions/json?origin=order.GeoLocation__c.getLatitude()&destination=order.GeoLocation__c.getLongitude()&key=yourAPiKey';
		
        req.setEndpoint(endPoint);
        req.setMethod('GET');
        req.setTimeout(5000);
        System.debug('Request ' + req);
       
            // callout
            HttpResponse res = h.send(req);
            // parse coordinates from response
            JSONParser parser = JSON.createParser(res.getBody());
            system.debug('Response get Body ' + res.getBody());
            
            double lat = null;
            double lon = null;
            //system.debug(parser.nextToken());
            while (parser.nextToken() != null) {  
                system.debug(parser.getCurrentToken());
                system.debug(JSONToken.FIELD_NAME);
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                    (parser.getText() == 'location')){
                       // system.debug('a');
                        parser.nextToken(); // object start                     
                        while (parser.nextToken() != JSONToken.END_OBJECT){
                            String txt = parser.getText();
                            parser.nextToken();
                            if (txt == 'lat')
                                lat = parser.getDoubleValue();
                            else if (txt == 'lng')
                                lon = parser.getDoubleValue();
                        }
                    }
            }
            // update coordinates if we get back
            system.debug(lat);
            if (lat != null){
                system.debug(lat+' '+lon);              
            }

                map<string,object> markerMap = new map<string,object>();
                markerMap.put('title', order.name);
                markerMap.put('description',order.Description != null ? order.Description : '');
                map<string,object> addressMap = new map<string,object>();
                addressMap.put('Latitude',lat);
                addressMap.put('Longitude',lon);
                markerMap.put('location',addressMap);
                markerList.add(markerMap);  
            }
        }
        
        
        system.debug('+++++++'+JSON.serialize(markerList));  
        return JSON.serialize(markerList);  
        
    } 
}