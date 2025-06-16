global class ScheduleDeactivateUsers implements Schedulable {

global void execute(SchedulableContext ctx){
    LastLogin_UserDeactivation_Switch__c lastloginCS = LastLogin_UserDeactivation_Switch__c.getOrgDefaults();
    
    if(lastloginCS.User_Deactivation__c == TRUE){
        deactivateUsers uu = new deactivateUsers();
        Database.executeBatch(uu);
    }
}
}