public class CalloutQueueable implements System.Queueable, Database.AllowsCallouts {
    private String accName;

    public CalloutQueueable(String accName) {
        this.accName = accName;
        system.debug(' this.accName' +  this.accName);
    }

    public void execute(QueueableContext context) {
        Map<String, Object> eventDataMap = new Map<String, Object>{
            'AccName' => accName             
        };
        String jsonData = JSON.serialize(eventDataMap);
        System.debug('jsonData' + jsonData);

        // Perform REST API Callout
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://sohamtechnologies-a2-dev-ed.develop.my.salesforce.com/');
        req.setMethod('POST');
        req.setHeader('Authorization', '6Cel800D5j00000CAGp98885j000000HsGULzyrNp5eyyeaBy8vuCkAtBieYwya1HaCBGU7mdgGmJvRYg3Cl1Ii9j7rlcfnp82FpnX3wehu');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(jsonData);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() == 302) {
            // Handle redirection
            String redirectedUrl = res.getHeader('Location');
            HttpRequest newReq = new HttpRequest();
            newReq.setEndpoint(redirectedUrl);
            newReq.setMethod('POST');
            newReq.setHeader('Authorization', 'Replace with actual auth token');
            newReq.setHeader('Content-Type', 'application/json');
            newReq.setBody(jsonData);

            HttpResponse newRes = http.send(newReq);

            if (newRes.getStatusCode() == 200) {
                System.debug('Event Data Sent to Another Org Successfully');
            } else {
                System.debug('Failed to Send Event Data to Another Org: ' + newRes.getBody());
            }
        } else if (res.getStatusCode() == 200) {
            System.debug('Event Data Sent to Another Org Successfully');
        } else {
            System.debug('Failed to Send Event Data to Another Org: ' + res.getBody());
        }
    }
}