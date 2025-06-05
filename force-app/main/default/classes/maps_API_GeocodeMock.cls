// Mock class for maps.API.Geocode callout
    @isTest
    public class maps_API_GeocodeMock implements HttpCalloutMock {
        public Map<String, Object> response;
        
        public maps_API_GeocodeMock(Map<String, Object> response) {
            this.response = response;
        }
        
        public HttpResponse respond(HttpRequest request) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(JSON.serialize(response));
            res.setStatusCode(200);
            return res;
        }
    }