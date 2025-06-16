global class deactivateUsers implements Database.Batchable<SObject>, Database.Stateful
{    
    global String log = '';
    global Integer totalError = 0;
    global Integer totalSuccess = 0;
    global List<User> userList;
    public List<Id> frozenUserIds;
    public String query; 
    date dt = date.today() - 90;  
    date dtLastEmailSent = date.today() - 7;  
    
    global Database.querylocator start(Database.BatchableContext bc){
       List<string> proName = new List<string>();
       List<string> userType = new List<String>();
       
       LastLogin_UserDeactivation_Switch__c lastloginCS = LastLogin_UserDeactivation_Switch__c.getOrgDefaults();
       String strProNames = lastloginCS.Profile_Names__c; 
       String strUserTypes = lastloginCS.User_Type__c;
       
       userType = strUserTypes.split(','); 
       proName = strProNames.split(',');
    
       List<UserLogin> frozenUsers = [SELECT UserId FROM UserLogin WHERE IsFrozen = True];
       if(frozenUsers.size() > 0){
           frozenUserIds = new List<Id>();
           for(UserLogin fuser: frozenUsers){
               frozenUserIds.add(fuser.UserId);
           }
       }
     
       query = 'SELECT Name, LastLoginDate, Id, LastName From User WHERE IsActive = TRUE';
       query += ' AND ID NOT IN :frozenUserIds AND LastLoginDate < :dt AND Last_Login_Email_Sent_On__c < :dtLastEmailSent AND Profile.Name NOT IN :proName AND UserType NOT IN :userType';  
       if(Test.isRunningTest()) query = 'SELECT Name, LastLoginDate, Id, LastName From User WHERE IsActive = TRUE limit 1';
       return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc,List<User> scope){          
        totalError = 0; 
        totalSuccess = 0;
        userList = new List<User>();
        for(User s:scope){
            User u =(user)s;
            userList.add(u);
        }
        
        if(userList.size() > 0){
            for(User usr : userList){
                usr.isActive = false;
                usr.LastName = usr.LastName + ' Inactive';
            }
        }
        
        Database.SaveResult[] srList = database.update(userList, false);
        System.Debug('srList ----' + srList ); 
        for (Integer i = 0; i < srList.size(); i++){
            if (!srList[i].isSuccess()){
                this.log += 'Error in deactivating user: ' + userList[i].Name + '. Error msg = ' + srList[i].getErrors()[0].getMessage() + '\n';
                System.Debug('Test  LOG *** ' + log);
                totalError = totalError + 1;
            }    
            else{
                this.log += 'User successfully deactivated: ' + userList[i].Name + '. \n';
                totalSuccess = totalSuccess + 1;
            }        
        }    
    }

    global void finish(Database.BatchableContext bc){
        //AsyncApexJob a = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email FROM AsyncApexJob WHERE Id = :BC.getJobId()];

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'ctsfdc@saint-gobain.com'};
        mail.setToAddresses(toAddresses);
        mail.setSubject('Apex job for deactivating users');
        mail.setPlainTextBody('The batch Apex job has been processed with ' + totalSuccess + ' successful update(s) and ' + totalError + ' failure(s). \n \nLogs: \n' + log);
        if(!Test.isRunningTest())
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
    }
}