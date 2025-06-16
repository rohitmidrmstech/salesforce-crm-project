@istest
public class OpportunityLineUpdateSchedule_Test {
    @istest
    public static void runtest(){
        
        Id recordTypeId =Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('CBI_Project').getRecordTypeId();
        system.debug('RecordTypeId-->'+recordTypeId);
        
        Account acc = new Account(name='Test Account');
        insert acc;       
        opportunity opp = new opportunity(Accountid=acc.id,name='TestOpp',stageName = 'New',closedate=System.Today(),RecordTypeId=recordTypeId);
        insert opp;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 product = new Product2(
            Name = '"STRIP-ALL" BRAND WIRE STRIPPERS',// Product Name
            IsActive = true,                            // Active
            CanUseQuantitySchedule = true,              // Quantity Scheduling Enabled
            CanUseRevenueSchedule = true,               // Revenue Scheduling Enabled
            ProductCode = '65944'                      // Product Code
        );
        insert product;
        
        /*PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;*/
        
        OpportunityLineItem sobj = new OpportunityLineItem(
            OpportunityId = opp.Id,                // Opportunity
            Quantity = 10,                              // Quantity
            Shipping_Start_Date__c = Date.Today(),  // Revenue Start Date
            Shipping_End_Date__c = Date.Today().addMonths(3),  // Revenue End Date
            Opportunity_Probability__c = 60,                    // Opportunity Probability
            Created_Revenue_Schedules__c = true,                // Created Revenue Schedules
            Product2Id = product.id,  
            PricebookEntryId = [SELECT Id from PricebookEntry].Id,
            TotalPrice = 10 * 1         // Product
        );
        insert sobj;
        
        OpportunityLineItemTriggerHandler.isFirstRun = true;
        sobj.UnitPrice=10;
        sobj.Quantity=10;
        update sobj;
        
        /*OpportunityLineItemTriggerHandler.isFirstRun = true;
        sobj.Shipping_End_Date__c = Date.Today().addMonths(1);
        update sobj;*/
        
        OppLineItemScheduleTriggerHandler.isFirstRun = true;
        OpportunityLineItemSchedule scd = new OpportunityLineItemSchedule();
        scd.OpportunityLineItemId = sobj.id;
        scd.Type = 'Both'; //changed from Quantity to Both
        scd.ScheduleDate = Date.Today();
        scd.Quantity = 10;
        scd.Revenue = 4500;
        insert scd;
        
        
        Test.StartTest(); 
        Apexpages.StandardController stdController = new Apexpages.StandardController(sobj); 
        OpportunityLineUpdateSchedule cntrl = new OpportunityLineUpdateSchedule(stdController);
        cntrl.updateSchedule();
        cntrl.cancle();
        Test.StopTest();
    }
    @istest
    public static void runtest2(){
        
        Id recordTypeId =Schema.SObjectType.opportunity.getRecordTypeInfosByDeveloperName().get('CBI_Project').getRecordTypeId();
        system.debug('RecordTypeId-->'+recordTypeId);
        
        Account acc = new Account(name='Test Account');
        insert acc;       
        opportunity opp = new opportunity(Accountid=acc.id,name='TestOpp',stageName = 'New',closedate=System.Today(),RecordTypeId=recordTypeId);
        insert opp;
        
        Id pricebookId = Test.getStandardPricebookId();
        
        Product2 product = new Product2(
            Name = '"STRIP-ALL" BRAND WIRE STRIPPERS',// Product Name
            IsActive = true,                            // Active
            CanUseQuantitySchedule = true,              // Quantity Scheduling Enabled
            CanUseRevenueSchedule = true,               // Revenue Scheduling Enabled
            ProductCode = '65944'                      // Product Code
        );
        insert product;
        
        /*PricebookEntry pbEntry = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = product.Id,
            UnitPrice = 100.00,
            IsActive = true
        );
        insert pbEntry;*/
        
        OpportunityLineItem sobj = new OpportunityLineItem(
            OpportunityId = opp.Id,                // Opportunity
            Quantity = 10,                              // Quantity
            Shipping_Start_Date__c = Date.Today(),  // Revenue Start Date
            Shipping_End_Date__c = Date.Today().addMonths(3),  // Revenue End Date
            Opportunity_Probability__c = 60,                    // Opportunity Probability
            Created_Revenue_Schedules__c = true,                // Created Revenue Schedules
            Product2Id = product.id,  
            PricebookEntryId = [SELECT Id from PricebookEntry].Id,
            TotalPrice = 10 *1        // Product
        );
        insert sobj;
        
        /*OpportunityLineItemTriggerHandler.isFirstRun = true;
        sobj.UnitPrice=10;
        sobj.Quantity=10;
        sobj.TotalPrice = sobj.UnitPrice * sobj.Quantity;
        update sobj;*/
        
        /*OpportunityLineItemTriggerHandler.isFirstRun = true;
        sobj.Shipping_End_Date__c = Date.Today().addMonths(1);
        update sobj;*/
        
        OppLineItemScheduleTriggerHandler.isFirstRun = true;
        OpportunityLineItemSchedule scd = new OpportunityLineItemSchedule();
        scd.OpportunityLineItemId = sobj.id;
        scd.Type = 'Both'; //changed from Quantity to Both
        scd.ScheduleDate = Date.Today();
        scd.Quantity = 10;
        scd.Revenue = 4500;
        insert scd;
        
        
        Test.StartTest(); 
        Apexpages.StandardController stdController = new Apexpages.StandardController(sobj); 
        OpportunityLineUpdateSchedule cntrl = new OpportunityLineUpdateSchedule(stdController);
        cntrl.updateSchedule();
        cntrl.cancle();
        
        OpportunityLineUpdateSchedule.queryOpportunityLineItem(sobj.Id);
        OpportunityLineUpdateSchedule.getPicklistsData();
        OpportunityLineUpdateSchedule.updateScheduleLWC(sobj.Id, sobj);
        Test.StopTest();
    }
}