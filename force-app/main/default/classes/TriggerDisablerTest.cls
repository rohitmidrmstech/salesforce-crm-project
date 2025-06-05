@isTest
public class TriggerDisablerTest {
    public static testMethod void test1() {    
        TriggerDisabler.shouldTriggerRun('Account');
        TriggerDisabler1__c setting = new TriggerDisabler1__c();
        setting.Name = 'Default';
        setting.User_Id__c = userInfo.getUserid();
        insert setting;
        TriggerDisabler.shouldTriggerRun('Account');
    }
    public static testMethod void test2() {    
        TriggerDisabler.shouldTriggerRun('Account');
        TriggerDisabler1__c setting = new TriggerDisabler1__c();
        setting.Name = 'Default';
        setting.User_Id__c = null;
        insert setting;
        TriggerDisabler.shouldTriggerRun('Account');
    }
}