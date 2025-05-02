public class MagentoIntegration {

    public static void getMagentoAccessToken() {
        String magentoUrl = 'https://magento-1165041-4068435.cloudwaysapps.com/rest/V1/integration/admin/token';
        String requestBody = '{"username":"rohit.chormalle@sohamtechnologies.in", "password":"d9X9EptZG9Tvnu"}';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(magentoUrl);
        request.setMethod('GET');
        request.setBody(requestBody);
        request.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response==' + response);
        System.debug('response body==' + response.getBody());
        if (response.getStatusCode() == 200) {
            string accesstoken = response.getBody().replace('"', '');
                    System.debug('accesstoken==' +accesstoken);
                 callMagentoApi(accesstoken);              
        } else {
            System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
          //  return null;
        }
    }

    public static void callMagentoApi(String accessToken ) {
                            System.debug('accessToken in callMagentoApi==' +accessToken);
       // String accessToken = getMagentoAccessToken();
        if (accessToken != null) {
            String apiUrl = 'https://magento-1165041-4068435.cloudwaysapps.com/rest/V1/products?searchCriteria[pageSize]=20'; // Replace with your specific Magento API endpoint
            // String body  ='{"product": { "sku": "VBP_003", "name": "Black &bakar", "attribute_set_id": 9, "price": 32, "status": 1, "visibility": 1,  "type_id": "simple", "weight": "30",  "extension_attributes": {"category_links": [{	"position": 0,"category_id": "11"},{"position": 1,"category_id": "12"},{"position": 2,"category_id": "16"}],"stock_item": {"qty": "100","is_in_stock": true} },"custom_attributes": [{"attribute_code": "description","value": "Vintage Backpack is a heavy weight washed cotton canvas backpack with a large main compartment, a front pocket, and two side pockets."},{"attribute_code": "tax_class_id","value": "2"},{"attribute_code": "material","value": "189"},{"attribute_code": "pattern","value": "166"},{"attribute_code": "color","value": "42"},{"attribute_code": "size","value": "20"} ]  }}';
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('GET');
            String searchCriteria = '{"searchCriteria": {20}}';
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('response after getToken==' +response);
            System.debug('response get body in callMagentoApi ==' +response.getBody());
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(responseBody);
            // Extract the count from the response
            Integer totalCount = ((Double)jsonResponse.get('total_count')).intValue();
            System.debug('Total Count of Records: ' + totalCount);
                // Process the response body here
                System.debug(responseBody);
                syncMagentoProducts(responseBody);
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            System.debug('Failed to get access token');
        }
    }
    public static void syncMagentoProducts(String magentoApiResponse) {
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(magentoApiResponse);
        System.debug('jsonResponse in Creating Product==' + jsonResponse);
        List<Object> products = (List<Object>) jsonResponse.get('items');
        System.debug('jproducts in CP==' + products);
        List<Product2> salesforceProducts = new List<product2>();
        for (Object product : products) {
            Map<String, Object> productDetails = (Map<String, Object>) product;

            Product2 sfProduct = new product2(
               // Id__c = String.valueOf(productDetails.get('id')),
                StockKeepingUnit = String.valueOf(productDetails.get('sku')),
                Name = String.valueOf(productDetails.get('name')),
                ProductCode = String.valueOf(productDetails.get('attribute_set_id'))
               // Price__c = (Decimal) productDetails.get('price'),
                // Map other Magento product properties to corresponding Salesforce fields
                // ...
            );

            salesforceProducts.add(sfProduct);
        }

        // Insert Salesforce products
        insert salesforceProducts;
        System.debug('salesforceProducts==' + salesforceProducts);
    }
   public static void getMagentoCustomerAccessToken() {
        String magentoUrl = 'https://magento-1165041-4068435.cloudwaysapps.com/rest/V1/integration/customer/token';
        String requestBody = '{"username":"julielawson@example.com", "password":"Password42"}';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(magentoUrl);
        request.setMethod('GET');
        request.setBody(requestBody);
        request.setHeader('Content-Type', 'application/json');
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('response==' + response);
        System.debug('response body==' + response.getBody());
        if (response.getStatusCode() == 200) {
            string accesstoken = response.getBody().replace('"', '');
                    System.debug('customer accesstoken==' +accesstoken);
               //insertQuoteInMagentoApi(accesstoken);  
               insertCartInMagentoApi(accesstoken)  ;  
            insertShippingAddressInMagentoApi(accesstoken);
            insertShippingInformationInMagentoApi(accesstoken);
            insertPaymentInformationInMagentoApi(accesstoken);
        } else {
            System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
          //  return null;
        }
    } 
     public static void insertQuoteInMagentoApi(String accessToken ) {
                            System.debug('accessToken in  quote==' +accessToken);
    
        if (accessToken != null) {
            String apiUrl = 'https://magento-1165041-4068435.cloudwaysapps.com/rest/V1/carts/mine'; // Replace with your specific Magento API endpoint
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
           String productData = '{"cartItem": {"quote_id": null,"sku": "VBP_001","qty": 1,"product_option": {"extension_attributes": {}},"extension_attributes": {}}}';
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(productData);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('response after getToken in quote==' +response);
            System.debug('response get body in insertQuoteInMagentoApi ==' +response.getBody());
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug('responseBody of Quote' + responseBody);
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            System.debug('Failed to get access token');
        }
    }
    public static void insertCartInMagentoApi(String accessToken ) {
       System.debug('accessToken in callMagentoApi==' +accessToken);
       // String accessToken = getMagentoAccessToken();
        if (accessToken != null) {
            String apiUrl = 'https://magento-1165041-4068435.cloudwaysapps.com/rest/V1/carts/mine/items'; // Replace with your specific Magento API endpoint
           String body  =' {"cartItem": {"sku": "VBP_001", "qty": 1, "quote_id": "1" }}';
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
           // String searchCriteria = '{"searchCriteria": {20}}';
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(body);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('cart=' +response);
            System.debug('cart response ==' +response.getBody());
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug('responseBody in Insert Cart' +responseBody);
                
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            System.debug('Failed to get access token');
        }
    }
public static void insertShippingAddressInMagentoApi(String accessToken ) {
              System.debug('accessToken in  quote==' +accessToken);
        if (accessToken != null) {
            String apiUrl = 'https://magento-1165041-4068435.cloudwaysapps.com/rest/V1/carts/mine/estimate-shipping-methods'; // Replace with your specific Magento API endpoint
          String requestBody =  '{"address": { "region": "Nevada","region_id": 39,"region_code": "NV", "country_id": "US","street": [ "3703 Wescam Court" ],"postcode": "89406", "city": "Fallon", "firstname": "Julie",  "lastname": "Lawson",  "customer_id": 1, "email": "julielawson@example.com","telephone": "860-212-5597","same_as_billing": 1 }}';
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(requestBody);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('insertShippingAddressInMagentoApi==' +response);
            System.debug('insertShippingAddressInMagentoApi ==' +response.getBody());
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug('responseBody in insertShippingAddressInMagentoApi' + responseBody);
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            System.debug('Failed to get access token');
        }
    }
     //shipping-information
     public static void insertShippingInformationInMagentoApi(String accessToken ) {
              System.debug('accessToken in Shipping Insert==' +accessToken);
    
        if (accessToken != null) {
            String apiUrl = 'https://magento-1165041-4068435.cloudwaysapps.com/rest/V1/carts/mine/shipping-information'; // Replace with your specific Magento API endpoint
            String requestBody = '{"addressInformation": {"shipping_address":{"region":"Nevada","region_id":39,"region_code":"NV","country_id":"US","street":["3703 Wescam Court"],"postcode":"89406","city":"Fallon","firstname":"Julie","lastname":"Lawson","customer_id":1,"email":"julielawson@example.com","telephone":"860-212-5597"},"billing_address":{"region":"Nevada","region_id":39,"region_code":"NV","country_id":"US","street":["3703 Wescam Court"],"postcode":"89406","city":"Fallon","firstname":"Julie","lastname":"Lawson","customer_id":1,"email":"julielawson@example.com","telephone":"860-212-5597"},"shipping_carrier_code":"flatrate","shipping_method_code":"flatrate"}}';
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(requestBody);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('shipping-information Response==' +response);
            System.debug('shipping-information body ==' +response.getBody());
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug('responseBody shipping-information' + responseBody);
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            System.debug('Failed to get access token');
        }
    }
     //payment information
     public static void insertPaymentInformationInMagentoApi(String accessToken ) {
              System.debug('accessToken in Insert Payment Method==' +accessToken);
        if (accessToken != null) {
            String apiUrl = 'https://magento-1165041-4068435.cloudwaysapps.com/rest/V1/carts/mine/payment-information'; // Replace with your specific Magento API endpoint
           String requestBody =  '{"paymentMethod": { "method": "checkmo" }, "billing_address": {"email": "julielawson@example.com", "region": "Nevada","region_id": 39,"region_code": "NV","country_id": "US","street": ["3703 Wescam Court"],"postcode": "89406","city": "Fallon","telephone": "860-212-5597","firstname": "Julie","lastname": "Lawson" }}';
            HttpRequest request = new HttpRequest();
            request.setEndpoint(apiUrl);
            request.setMethod('POST');
            request.setHeader('Authorization', 'Bearer ' + accessToken);
            request.setHeader('Content-Type', 'application/json');
            request.setBody(requestBody);
            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('create Order Information response==' +response);
            System.debug('create Order Information body ==' +response.getBody());
            if (response.getStatusCode() == 200) {
                String responseBody = response.getBody();
                System.debug('responseBody in create Order' +responseBody );
            } else {
                System.debug('Error: ' + response.getStatusCode() + ' ' + response.getStatus());
            }
        } else {
            System.debug('Failed to get access token');
        }
    }
    }