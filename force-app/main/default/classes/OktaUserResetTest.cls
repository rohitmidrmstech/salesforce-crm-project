/****************************************************************************************
* @Author       Lou Bui
* @Date         02/13/2023
* @Description  
				Test Classes for OktaUserReset.
*****************************************************************************************/

@isTest
public class OktaUserResetTest {  
    
    @isTest
    //OktaUserReactivate Successs Test
    static void testoktaUserReactivateSuccess(){
        
        List<Okta_Api_Settings__c> oktaCustomSettings = new List<Okta_Api_Settings__c>();
		Okta_Api_Settings__c cs = new Okta_Api_Settings__c();
        cs.End_Point__c = 'https://loginpreview.certainteed.com/api/v1/';
        cs.Token__c = 'SSWS00oHZh_ZElbMAcSYuJprGz1DloImZfZSRS61TZC2SF';
        oktaCustomSettings.add(cs);
        insert oktaCustomSettings;
        
        List<String> emails = new List<String>{'test.user@mytest.com'};
        List<String> response = new List<String>{'Success - Resent Activation Email.'};
           
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OktaUserReactivateSuccessMock());
        
        List<String> result = OktaUserReset.oktaUserReactivate(emails);
        Test.stopTest();
        
        System.assertEquals(response,result);
       
    }
    
     @isTest
    //OktaUserReactivate Successs Test
    static void testoktaUserReactivateExisting(){
        
        List<Okta_Api_Settings__c> oktaCustomSettings = new List<Okta_Api_Settings__c>();
		Okta_Api_Settings__c cs = new Okta_Api_Settings__c();
        cs.End_Point__c = 'https://loginpreview.certainteed.com/api/v1/';
        cs.Token__c = 'SSWS00oHZh_ZElbMAcSYuJprGz1DloImZfZSRS61TZC2SF';
        oktaCustomSettings.add(cs);
        insert oktaCustomSettings;
        
        List<String> emails = new List<String>{'test.user@mytest.com'};
        List<String> response = new List<String>{'User is already activated.'};
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OktaUserReactivateExistingMock());
        
        List<String> result = OktaUserReset.oktaUserReactivate(emails);
        Test.stopTest();
        
        System.assertEquals(response,result);
       
    }
    
    @isTest
    //OktaUserReactivate No User Returned Test
    static void testoktaUserReactivateUserEmpty(){
        
        List<Okta_Api_Settings__c> oktaCustomSettings = new List<Okta_Api_Settings__c>();
		Okta_Api_Settings__c cs = new Okta_Api_Settings__c();
        cs.End_Point__c = 'https://loginpreview.certainteed.com/api/v1/';
        cs.Token__c = 'SSWS00oHZh_ZElbMAcSYuJprGz1DloImZfZSRS61TZC2SF';
        oktaCustomSettings.add(cs);
        insert oktaCustomSettings;
        
        List<String> emails = new List<String>{'test.user@mytest.com'};
        List<String> response = new List<String>{'User does not exist in Okta.'};
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OktaUserReactivateUserEmptyMock());
        
        List<String> result = OktaUserReset.oktaUserReactivate(emails);
        Test.stopTest();
        
        System.assertEquals(response,result);
       
    }
    
    @isTest
    //OktaUserReactivate Error Test
    static void testoktaUserReactivateError(){
        
        List<Okta_Api_Settings__c> oktaCustomSettings = new List<Okta_Api_Settings__c>();
		Okta_Api_Settings__c cs = new Okta_Api_Settings__c();
        cs.End_Point__c = 'https://loginpreview.certainteed.com/api/v1/';
        cs.Token__c = 'SSWS00oHZh_ZElbMAcSYuJprGz1DloImZfZSRS61TZC2SF';
        oktaCustomSettings.add(cs);
        insert oktaCustomSettings;
        
        List<String> email = new List<String>{'test.user@email.com'}; 
            
            
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new OktaUserReactivateErrorMock());
        	OktaUserReset.oktaUserReactivate(email);
        Test.stopTest();	
        
       
    }
    
    @isTest
    //OktaUserReactivate Exception Test
    static void testoktaUserReactivateException(){
        
        List<Okta_Api_Settings__c> oktaCustomSettings = new List<Okta_Api_Settings__c>();
		Okta_Api_Settings__c cs = new Okta_Api_Settings__c();
        cs.End_Point__c = 'https://loginpreview.certainteed.com/api/v1/';
        cs.Token__c = 'SSWS00oHZh_ZElbMAcSYuJprGz1DloImZfZSRS61TZC2SF';
        oktaCustomSettings.add(cs);
        insert oktaCustomSettings;
        
         	List<String> emails = new List<String>{'test.user@mytest.com'};
            List<String> response = new List<String>{'TryCatch Error: Error, Please contact your system administrator.'};
            Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new OktaExceptionMock());
        	
        	List<String> result = OktaUserReset.oktaUserReactivate(emails);
        	Test.stopTest();
        
        System.assertEquals(response,result);        
    }
    
    @isTest
    //OktaUserReset Success Test
    static void testoktaUserResetSuccess() { 
        
        String uid = '1001';
        
        List<Okta_Api_Settings__c> oktaCustomSettings = new List<Okta_Api_Settings__c>();
		Okta_Api_Settings__c cs = new Okta_Api_Settings__c();
        cs.End_Point__c = 'https://loginpreview.certainteed.com/api/v1/';
        cs.Token__c = 'SSWS00oHZh_ZElbMAcSYuJprGz1DloImZfZSRS61TZC2SF';
        oktaCustomSettings.add(cs);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OktaUserResetSuccessMock());
        
        String result = OktaUserReset.oktaUserReset(uid,oktaCustomSettings);
        Test.stopTest();
        
        System.assertEquals('Success - Resent Activation Email.',result);
	}
    
    @isTest
    //OktaUserReset Error Test
    static void testoktaUserResetError(){
        
         string uid = '1001'; 
         List<Okta_Api_Settings__c> oktaCustomSettings = new List<Okta_Api_Settings__c>();
         Okta_Api_Settings__c cs = new Okta_Api_Settings__c();
         cs.End_Point__c = 'https://loginpreview.certainteed.com/api/v1/';
         cs.Token__c = 'SSWS00oHZh_ZElbMAcSYuJprGz1DloImZfZSRS61TZC2SF';
         oktaCustomSettings.add(cs);
        
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new OktaUserResetErrorMock());
        	String result = OktaUserReset.oktaUserReset(uid,oktaCustomSettings);
        Test.stopTest();	
        
        System.assertEquals('Error, Please contact your system administrator.',result);
        
    }   
    
    @isTest
    static void testoktaUserResetException(){
        string uid = '1001'; 
        List<Okta_Api_Settings__c> oktaCustomSettings = new List<Okta_Api_Settings__c>();
        Okta_Api_Settings__c cs = new Okta_Api_Settings__c();
        cs.End_Point__c = 'https://loginpreview.certainteed.com/api/v1/';
        cs.Token__c = 'SSWS00oHZh_ZElbMAcSYuJprGz1DloImZfZSRS61TZC2SF';
        oktaCustomSettings.add(cs);
        
        
        Test.startTest();
        	Test.setMock(HttpCalloutMock.class, new OktaExceptionMock());
        	String result = OktaUserReset.oktaUserReset(uid, oktaCustomSettings);
        Test.stopTest();	
        
        System.assertEquals('TryCatch Error: Error, Please contact your system administrator.',result);
        
    }   
    
     @isTest
    //OktaUserReactivate Error List out of bounds
    static void testoktaUserReactivateTCException(){
        
        List<String> emails = new List<String>{'test.user@mytest.com'};
        List<String> response = new List<String>{'TryCatch Error: List index out of bounds: 0'};
            
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new OktaUserReactivateSuccessMock());
        
        List<String> result = OktaUserReset.oktaUserReactivate(emails);
        Test.stopTest();
        
        System.assertEquals(response,result);
       
    }
    
    //Test response general error.
    class OktaExceptionMock implements HttpCalloutMock{
    public HttpResponse respond(HttpRequest request) {
        CalloutException e = (CalloutException)CalloutException.class.newInstance();
        e.setMessage('Error, Please contact your system administrator.');
        throw e;
    }
}
    
    //Test response ueser reactivate method error code 400.
	class OktaUserReactivateErrorMock implements HttpCalloutMock{
         
    public HttpResponse respond(HTTPRequest req){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type','application/json');
        response.setStatus('Error');
        response.setStatusCode(400);
        response.setBody('Error, Please contact your system administrator.');
        return response;
    }   
    
}
    
    //Test respone ueser reactivate method existing user.
    class OktaUserReactivateExistingMock implements HttpCalloutMock{
        
        public HttpResponse respond(HTTPRequest req){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatus('OK');
            response.setStatusCode(200);
            response.setBody('[ { "id": "00u5stwss32FJdnrT5d7", "status": "ACTIVE", "created": "2022-07-15T15:16:15.000Z", "activated": "2022-07-15T15:16:15.000Z", "statusChanged": "2022-07-15T15:46:13.000Z", "lastLogin": "2022-07-15T15:49:10.000Z", "lastUpdated": "2022-07-15T15:46:13.000Z", "passwordChanged": "2022-07-15T15:46:13.000Z", "type": { "id": "oty5pn7isj2FZ5czi5d7" }, "profile": { "firstName": "Sandip", "lastName": "Patel", "mobilePhone": null, "secondEmail": null, "login": "sandip.patel@visionsoft.com", "email": "sandip.patel@visionsoft.com" }, "credentials": { "password": {}, "emails": [     { "value": "sandip.patel@visionsoft.com", "status": "VERIFIED", "type": "PRIMARY"     } ], "recovery_question": {     "question": "Who is your favorite sports player?" }, "provider": {     "type": "OKTA",     "name": "OKTA" } }, "_links": { "self": {     "href": "https://dev-15533322.okta.com/api/v1/users/00u5stwss32FJdnrT5d7" } } } ]');
            return response;
        }   
}    

	//Test response ueser reactivate method success.
    class OktaUserReactivateSuccessMock implements HttpCalloutMock{
        
        public HttpResponse respond(HTTPRequest req){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatus('OK');
            response.setStatusCode(200);
            response.setBody('[ { "id": "00u5stwss32FJdnrT5d7", "status": "PROVISIONED", "created": "2022-07-15T15:16:15.000Z", "activated": "2022-07-15T15:16:15.000Z", "statusChanged": "2022-07-15T15:46:13.000Z", "lastLogin": "2022-07-15T15:49:10.000Z", "lastUpdated": "2022-07-15T15:46:13.000Z", "passwordChanged": "2022-07-15T15:46:13.000Z", "type": { "id": "oty5pn7isj2FZ5czi5d7" }, "profile": { "firstName": "Sandip", "lastName": "Patel", "mobilePhone": null, "secondEmail": null, "login": "sandip.patel@visionsoft.com", "email": "sandip.patel@visionsoft.com" }, "credentials": { "password": {}, "emails": [     { "value": "sandip.patel@visionsoft.com", "status": "VERIFIED", "type": "PRIMARY"     } ], "recovery_question": {     "question": "Who is your favorite sports player?" }, "provider": {     "type": "OKTA",     "name": "OKTA" } }, "_links": { "self": {     "href": "https://dev-15533322.okta.com/api/v1/users/00u5stwss32FJdnrT5d7" } } } ]');
            return response;
        }   
    }

	//Test response ueser reactivate method no match on user email address.
    class OktaUserReactivateUserEmptyMock implements HttpCalloutMock{
        
        public HttpResponse respond(HTTPRequest req){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatus('OK');
            response.setStatusCode(200);
            response.setBody('[]');
            return response;
        }   
    }

    //Test response user reset method error code 400.
    class OktaUserResetErrorMock implements HttpCalloutMock{
        
        public HttpResponse respond(HTTPRequest req){
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type','application/json');
            response.setStatus('Error');
            response.setStatusCode(400);
            response.setBody('Error, Please contact your system administrator.');
            return response;
        }   
    
}
	
    //Test response user reset method success.
    class OktaUserResetSuccessMock implements HttpCalloutMock{
    
    public HttpResponse respond(HTTPRequest req){
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type','application/json');
        response.setStatus('OK');
        response.setStatusCode(200);
        response.setBody('Success - Resent Activation Email.');
        return response;
    }   
}
}