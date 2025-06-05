public class TriggerDisabler {
  
  public static boolean shouldTriggerRun(String objectName) {
    TriggerDisabler1__c defaultDisabler = TriggerDisabler1__c.getInstance('Default');
      system.debug('objectDisabler' + defaultDisabler);
      system.debug('### ' + userInfo.getUserid());
    if (defaultDisabler != null && userInfo.getUserid() != null && defaultDisabler.User_Id__c == userInfo.getUserId())
        return false;

    TriggerDisabler1__c objectDisabler =  TriggerDisabler1__c.getInstance(objectName);

    if (objectDisabler != null && userInfo.getUserid() != null && objectDisabler.User_Id__c == userInfo.getUserId())
        return false;
      
    if (objectDisabler != null && objectDisabler.User_Id__c == null)
        return false;

    system.debug('trigger is executing for ' + objectName + ' for running user ' + userInfo.getUserId());
    return true;
}
}