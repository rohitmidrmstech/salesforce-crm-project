@isTest(seeAllData = TRUE)
public class ScheduleDeactivateUsers_Test{
    public static testMethod void testschedule(){
        date dtLastEmailSent = date.today() - 8;
       
        LastLogin_UserDeactivation_Switch__c cs = new LastLogin_UserDeactivation_Switch__c();
        cs.User_Deactivation__c = TRUE;
        try{insert cs;}catch(exception ex){}
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User']; 
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser121@testorg.com', Last_Login_Email_Sent_On__c = dtLastEmailSent);
        
        Insert u; 
        
        Test.startTest();
        ScheduleDeactivateUsers sh1 = new ScheduleDeactivateUsers();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test', sch, sh1); 
        Test.stopTest();
    }    
}