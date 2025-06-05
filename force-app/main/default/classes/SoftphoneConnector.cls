//3.0.18
global class SoftphoneConnector {

    webService static String getObjects(String cli, String accQuery, String contQuery, String searchObject) {
       
        System.debug('=== SoftphoneConnector cli: ' + cli + ' accQuery: ' + accQuery + ' searchObject: ' + searchObject);

        String filterAccount = accQuery;
        String filterContact = contQuery;
        
        string queryCli;
        if (cli.length() == 10) {
            queryCli = '%' + cli.mid(0,3) + '%' + cli.mid(3,3) + '%' + cli.mid(6,4) + '%';
        }
        else {
            queryCli = '%' + cli + '%';
        }
        
        List < List <SObject>> searchList = new List<List<SObject>>();

        if (searchObject.indexOf('Account') != -1) {
            List <SObject> objectAccountList = new List<SObject>();
            if (filterAccount.length() > 3) {
                String condition = '(phone LIKE \'' + queryCli + '\' AND (' + filterAccount + '))';
                String query = 'select id, name from Account where ' + condition;
                System.debug('=== SoftphoneConnector query: ' + query);
                objectAccountList = Database.query(query);
            } else {
                String condition = 'phone LIKE \'' + queryCli + '\'';
                String query = 'select id, name from Account where ' + condition;
                System.debug('=== SoftphoneConnector condition : ' + condition + ' query: ' + query);
                objectAccountList = Database.query(query);
            }
            System.debug('=== SoftphoneConnector objectAccountList: ' + objectAccountList);
            searchList.add(objectAccountList);
        }

        if (searchObject.indexOf('Contact') != -1) {
            List <SObject> objectContactList = new List<SObject>();
            if (filterContact.length() > 3) {

                String condition = '(phone LIKE \'' + queryCli + '\' OR  otherphone LIKE \'' + queryCli + '\' OR mobilephone LIKE \'' + queryCli + '\' OR homephone LIKE \'' + queryCli + '\' ) AND (' + filterContact + ')';
                String query = 'select id, name from Contact where ' + condition;
              
                System.debug('=== SoftphoneConnector query: ' + query);
                objectContactList = Database.query(query);
            } else {
                String condition = '( phone LIKE \'' + queryCli + '\' OR  otherphone LIKE \'' + queryCli + '\'  OR mobilephone LIKE \'' + queryCli + '\' OR homephone LIKE \'' + queryCli + '\')';
                String query = 'select id, name from Contact where ' + condition;
                objectContactList = Database.query(query);
            }
            searchList.add(objectContactList);
        }

        if (searchObject.indexOf('Leads') != -1) {
            List <SObject> objectLead = new List<SObject>();
            for (Lead lead: [SELECT id, name FROM Lead WHERE  phone LIKE :queryCli OR mobilephone LIKE :queryCli]) {
                objectLead.add(lead);
            }
            searchList.add(ObjectLead);
        }

        if (searchObject.indexOf('WTransfers') != -1) {
            List<SObject> objectWTransfer = new List<SObject>();
            for (WOD_Warranty_Transfer__c wt: [SELECT id, name FROM WOD_Warranty_Transfer__c WHERE Phone__c LIKE :queryCli]) {
                objectWTransfer.add(wt);
            }
            searchList.add(objectWTransfer);
        }
        
        if (searchObject.indexOf('Registrations') != -1) {
            List<SObject> objectRegistrations = new List<SObject>();
            for (WOD_2__Warranty_Registration__c wr: [SELECT id, name FROM WOD_2__Warranty_Registration__c WHERE Phone__c LIKE :queryCli]) {
                objectRegistrations.add(wr);
            }
            searchList.add(objectRegistrations);
        }
        
        if (searchObject.indexOf('Claims') != -1) {
            List<SObject> objectClaims = new List<SObject>();
            for (WOD_2__Claim__c claim: [SELECT id, name FROM WOD_2__Claim__c WHERE Phone__c LIKE :queryCli]) {
                objectClaims.add(claim);
            }
            searchList.add(objectClaims);
        }

        String JSONString = JSON.serialize(searchList);
        System.debug('SoftphoneConnector getObjects: phoneNumber  ' + cli + ' ==> ' + JSONString);
        return JSONString;
    }
}