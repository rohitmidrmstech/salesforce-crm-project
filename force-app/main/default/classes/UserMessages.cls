/*********************************************************************************
* {Type} Class: {UserMessages}
* Created by {Yogesh Kumar}, Navivo, {DateCreated 12/05/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Describe the purpose of this class}
* - {include what other classes or triggers call this class or any special
* business logic that needs to be documented}
----------------------------------------------------------------------------------
* Unit Test: {TestUserMessages}
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Yogesh Kumar 05/12/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
*********************************************************************************/
public without sharing class UserMessages {
     public List<User_Messages__c> userMessage {get;set;} 
     public User u{get;set;}
     public UserMessages(){
        u = [select Country__c, UserRoleId, UserRole.Name from User where id =:Userinfo.getUserId()];
        String country;
        String region;
        String role;
        if(u.Country__c != null) country = u.Country__c;
        if(u.UserRoleId != null && u.UserRole.Name != null && u.UserRole.Name.contains(' - ')) {
            List<String> temp = u.UserRole.Name.split(' - ');
            if(temp.size() == 2) {
                role = temp[0];
                region = temp[1];
            }
        }
        
        if(country != null && region != null && role != null) 
            userMessage = [select Country__c,Region__c,Message__c,Role__c, Id, Name from User_Messages__c where Country__c =: country and Region__c includes(:region) and Role__c includes (:role) ];
     }

}