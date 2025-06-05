global class LastLoginEmailtoUsers implements Schedulable {
    global void execute(SchedulableContext SC) {
        date dt = date.today() - 90;    
        List<Id> frozenUserIds;
        List<string> userType = new List<String>();
        List<string> proName = new List<string>();
        LastLogin_UserDeactivation_Switch__c lastloginCS = LastLogin_UserDeactivation_Switch__c.getOrgDefaults();

        String strProNames = lastloginCS.Profile_Names__c; 
        String strUserTypes = lastloginCS.User_Type__c;
        
        //List<string> userType = new List<string>{'Guest', 'AutomatedProcess', 'CloudIntegrationUser'};  
        userType = strUserTypes.split(',');         
        
        //List<string> proName = new List<string>{'System Administrator', 'Tech Services', 'Integration User'};
        proName = strProNames.split(',');
        
        List<UserLogin> frozenUsers = [SELECT UserId FROM UserLogin WHERE IsFrozen = True];
        if(frozenUsers.size() > 0){
            frozenUserIds = new List<Id>();
            for(UserLogin fuser: frozenUsers){
                frozenUserIds.add(fuser.UserId);
            }
        }
        List<User> uds = [SELECT Id, LastLoginDate, Email, Last_Login_Email_Sent_On__c FROM User where IsActive = True AND ID NOT IN :frozenUserIds AND Profile.Name NOT IN :proName AND UserType NOT IN :userType AND LastLoginDate < :dt AND (Last_Login_Email_Sent_On__c < :dt OR Last_Login_Email_Sent_On__c = null) AND Name != 'Platform Integration User'];
        
        List<User> usertoUpdate = new List<User>();
        List<Id> userIds = new List<Id>();
        
        if(lastloginCS.LastLoginEmailNotificaion__c == TRUE){
            EmailTemplate et = [Select id from EmailTemplate where Name = 'Last login notification to users' LIMIT 1]; 
            
            for(User u : uds){
                u.Last_Login_Email_Sent_On__c = System.Today();
                usertoUpdate.add(u);
                userIds.add(u.Id);
            }
            System.debug('UIDs########:' + userIds);
 
            Messaging.MassEmailMessage mail = new Messaging.MassEmailMessage();
            mail.setTargetObjectIds(userIds);
            mail.setTemplateId(et.Id);
            mail.saveAsActivity = false;
            Messaging.sendEmail(new Messaging.MassEmailMessage[] { mail });
       
            Update usertoUpdate;
        }
    }
}