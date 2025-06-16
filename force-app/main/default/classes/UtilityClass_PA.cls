public without sharing class UtilityClass_PA {
    //public class UtilException extends Exception {}
    
    public static Boolean isLJQ {get; set;}
    //fetching All User Info For Logged user 
    public static User userDetail{
        get{
            if(userDetail == null){
                    if(Constants_PA.isTesting){
                        //userDetail = [Select Id, Name, Email, Role__c, Profile.Name from User where id =: '005K0000002GWwS']; // For TM
                        //userDetail = [Select Id, Name, Email, Role__c, Profile.Name from User where id =: '005d0000001bgUK']; // For PC
                        //userDetail = [Select Id, Name, Email, Role__c, Profile.Name from User where id =: '005K0000001zALc']; // For RM
                    }else{ 
                        userDetail = [Select Id, Name, Email, Role__c, Profile.Name,Ecophon_Approver__c,SAP_TM_Number__c,
                                      Gyptone_Approver__c,National_Accounts__c from User where id =: UserInfo.getUserId()];
                        //if(UserInfo.getUserId() == '005d0000001bgUKAAY'){
                        //  userDetail = [Select Id, Name, Email, Role__c, Profile.Name from User where id =: '005K0000001zALh'];   
                        //}
                    } 
            } 
            return userDetail;
        }
        protected set;       
    }
 }