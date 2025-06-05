@isTest
private class TaskTriggerHandlerTest {
    @testSetup
    static void init(){
        /*TestDataFactory.storeTestCommonSettings();
        
        User tmUser = TestDataFactory.getTmUser();
        Territory__c tmTerr = TestDataFactory.storeTestTerritory(tmUser);
        
        TestDataFactory.storeTestCustomerData(tmUser, tmTerr);*/
        Id accRtId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        insert new Account(RecordTypeId = accRtId, Name = 'test');
        Account soldTo = [select id from Account where RecordType.Name = 'Sold-To' limit 1];
        
        /*Pricing_Request__c testPr = TestDataFactory.createTestPricingRequest('PCR', soldTo.Id);
        testPr.Status__c = 'Pending RM Review';
        testPr.Discount_Applied__c = 11;
        testPr.RM_Approver__c = tmUser.ManagerId;
        insert testPr;*/
    }
    
    @isTest
    static void testRmApproverEmailTrigger(){
        //Pricing_Request__c testPr = [select id, Customer__r.Owner.Manager.email from Pricing_Request__c limit 1];
        Id taskRtId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Sales Task').getRecordTypeId();
        Task testTask = new Task(Subject='Test Task'
                                //,WhatId = testPr.Id
                                ,Status = 'New'
                                ,RecordTypeId = taskRtId);
        //insert testTask;
         Test.startTest();
        List<Task>taskList = new List<Task>();
        taskList.add(testTask);
        Insert taskList ;
        
        Map<Id,Task> oldMap = new Map<Id,Task>();
        oldMap.put(taskList[0].id,taskList[0]);
        
       
            //testTask.Status = 'PCR Impact Analysis Attached';
            testTask.Status = 'In Progress';
        	
        	testTask.Category__c = 'CT Product Comment';
        	testTask.Sub_Category_Ins__c = 'CT HVAC';
            update testTask;
        	Task testTask2 = [SELECT id, Comments__c, Category__c, Sub_Category_Ins__c FROM Task where Id = :testTask.Id LIMIT 1];
        SYSTEM.DEBUG('+++++ tt2: ' + testTask2);
        	testTask2.Comments__c = 'Updated Comments';
        	update testTask2;
        Test.stopTest();
        
        testTask = [select id, Manager_Email__c from Task where Id = :testTask.Id];
        //System.assertEquals(testPr.Customer__r.Owner.Manager.email, testTask.Manager_Email__c);
        TaskTriggerHandler  ttobj = new TaskTriggerHandler ();
        
        
        ttobj.impactAnalysisGetRmEmail(taskList ,oldMap );
        ttobj.getDescribe('Task');
    }
    
    @isTest
    static void taskTriggerCover(){
        Id sidingTaskId = Schema.SObjectType.Task.getRecordTypeInfosByName().get('Siding Task').getRecordTypeId();
        
        List<Task>taskList = new List<Task>();
        Task testTask = new Task(Subject='Test Task',Status = 'New',RecordTypeId=sidingTaskId, WTU_Notes__c='Testing Record');
        taskList.add(testTask);
        Test.startTest();
        Insert taskList ;
        taskList[0].Subject='Test Task1';
        taskList[0].Comments__c ='Updated Comments';
        update taskList;
        Test.stopTest();
    }
}