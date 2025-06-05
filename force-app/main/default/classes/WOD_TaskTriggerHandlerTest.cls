/**
 * @description Test class for WOD_TaskTriggerHandler
*/
@isTest
private  class WOD_TaskTriggerHandlerTest {
    /**
     * @description data set up and execution
    */
    Private static testMethod void testCreateTask(){
        
        WOD_2__Warranty_Registration__c wr = WOD_TestDataFactory.createWarrantyRegistration('Residential','Roofing');
        insert wr;
        
        // Create Account record
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount2','','Warranty Account');
        insert acc;
        WOD_2__Claim__c clm= WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert clm;
        
        //Create Inspection
        List<WOD_Inspection__c> lstIns = New List<WOD_Inspection__c>();
        
        WOD_Inspection__c objInc1 = new WOD_Inspection__c();
        
        WOD_Inspection__c objInc2 = new WOD_Inspection__c();
        objInc2.Registration__c = wr.id;
        
        WOD_Inspection__c objInc3 = new WOD_Inspection__c();
        objInc3.Claim__c = clm.id;
        
        lstIns.add(objInc1);
        lstIns.add(objInc2);
        lstIns.add(objInc3);
        
        insert  lstIns;
        
        // Create Task
        List<Task> lstTask = new List<Task>();
        
        Task tsk1 = new Task();
        tsk1.WhatId = lstIns[0].id;
        
        Task tsk2 = new Task();
        tsk2.WhatId = lstIns[1].id;
        
        Task tsk3 = new Task();
        tsk3.WhatId = lstIns[2].id;

        
        lstTask.add(tsk1);
        lstTask.add(tsk2);
        lstTask.add(tsk3);
        
        Insert lstTask;
        
        List<Task> taskCount = [Select id from Task];
        List<WOD_Inspection__c> insCount = [Select id from WOD_Inspection__c];
        system.assert(taskCount.size() > 0);
        system.assertEquals(3, insCount.size());
    }
}