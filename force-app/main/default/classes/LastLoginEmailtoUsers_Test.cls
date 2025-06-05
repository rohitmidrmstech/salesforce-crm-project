@isTest
public class LastLoginEmailtoUsers_Test{
    public static testMethod void testschedule(){
        LastLogin_UserDeactivation_Switch__c cs = new LastLogin_UserDeactivation_Switch__c();
        cs.LastLoginEmailNotificaion__c = TRUE;
        cs.Profile_Names__c = 'System Administrator';
        cs.User_Type__c = 'AutomatedProcess';
        insert cs;
        
        Test.startTest();
        LastLoginEmailtoUsers sh1 = new LastLoginEmailtoUsers();
        String sch = '0 0 2 * * ?'; 
        system.schedule('Test', sch, sh1); 
        Test.stopTest();
    }    
}