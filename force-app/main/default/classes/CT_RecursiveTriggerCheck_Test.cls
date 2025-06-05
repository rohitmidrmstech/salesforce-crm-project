@isTest
public class CT_RecursiveTriggerCheck_Test {
    
    Static TestMethod void RecursiveTriggerCheck(){
        CT_RecursiveTriggerCheck.runOnce();
        CT_RecursiveTriggerCheck.run = false;
        CT_RecursiveTriggerCheck.runOnce();
    }
    
    

}