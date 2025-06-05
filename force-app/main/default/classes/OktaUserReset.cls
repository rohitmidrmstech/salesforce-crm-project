/****************************************************************************************
* @Author       Lou Bui
* @Date         02/13/2023
* @Description  
				A Salesforce to OKTA integration that provides CertainTeed Customer Experience Agents (CX User) 
				to resend activation emails to newly provisioned users inside of OKTA from within the Salesforce 
				Customer Experience Contacts Layout via a screen flow: Okta_User_Reset.
*****************************************************************************************/

public class OktaUserReset {
    
    //Method to get Okta UserId for secondary call to resend activation email.
    @InvocableMethod(label='Okta User Reactivate' description='GET request for Okta UserID.')
    public static List<String> oktaUserReactivate(List<String> emails){  
        try{
            
            //Getting endpoint adn token information from Custom Setting.
            List<Okta_Api_Settings__c> oktaCustomSettings = [Select End_Point__c, Token__c from Okta_Api_Settings__c];
                       
            String userEmail = emails[0];
            
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            request.setEndpoint(oktaCustomSettings[0].End_Point__c + '/users?search=profile.email%20eq%20%22'+userEmail+'%22');
            request.setMethod('GET');
            request.setHeader('Accept', 'application/json;charset=UTF-8');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', oktaCustomSettings[0].Token__c);
            
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() != 200) { 
                //System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
                List<String> error = new List<String>();
                //error.Add('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus());
                error.Add('Error, Please contact your system administrator.');
                return error;
            } 
            else { 
                //Get Okta UserId from response Http GET request.
                //System.debug(response.getBody());
                String json = response.getBody();
                List<OktaUserData> userData = parse(json);
                
                
                if(userData.isEMPTY()){
                    
                    //System.debug('User does not exist in Okta.'); 
                    List<String> result = new List<String>();
                    result.Add('User does not exist in Okta.');
                    return result;
                }
                else if(userData[0].status != 'PROVISIONED'){
                    
                    //System.debug('User is already activated.');  
                    List<String> result = new List<String>();
                    result.Add('User is already activated.');
                    return result;
                }
                
                //System.debug('OK, User qualifies for reactivation reset.');  
                List<String> result = new List<String>();
                String resetResponse = oktaUserReset(userData[0].id, oktaCustomSettings);
                result.Add(resetResponse);
                return result;
            }
        }
        catch (Exception e){
            //System.debug(e.getMessage());
            List<String> exError = new List<String>();
            exError.Add('TryCatch Error: ' + e.getMessage());
            return exError;
        }  
    }
    
    //Method to resend Okta reactivaton email.
    public static String oktaUserReset(string userId, List<Okta_Api_Settings__c> oktaCustomSettings){
        try{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            
            request.setEndpoint(oktaCustomSettings[0].End_Point__c + 'users/' + userId + '/lifecycle/reactivate?sendEmail=true');
            request.setMethod('POST');
            request.setHeader('Accept', 'application/json;charset=UTF-8');
            request.setHeader('Content-Type', 'application/json');
            request.setHeader('Authorization', oktaCustomSettings[0].Token__c);
            
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() != 200) {
                System.debug('The status code returned was not expected: ' + response.getStatusCode() + ' ' + response.getStatus()); 
                return ('Error, Please contact your system administrator.');
                
            } 
            else 
            {
                System.debug(response.getBody());
                return 'Success - Resent Activation Email.';
            }
        }
        catch (Exception e){
            //System.debug(e.getMessage());
            return ('TryCatch Error: ' + e.getMessage());
        } 
    }
    
    //Class to store http response body.
    public class OktaUserData {
    public String id;
	public String status;
	}
    
    //Method to parse respone body to OktaUserData Class
    public static List<OktaUserData> parse(String json) {
		return (List<OktaUserData>) System.JSON.deserialize(json, List<OktaUserData>.class);
	}
    
}