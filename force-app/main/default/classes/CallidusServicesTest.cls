/**
* ──────────────────────────────────────────────────────────────────────
* This test class will cover CallidusServices apex class. 
* ──────────────────────────────────────────────────────────────────────
* @author         Satyajit Chanda
* @verstion       1.0
* @created        11-07-2018
*/
@isTest(seeAllData=false)
public class CallidusServicesTest{
  
   @testSetup
   static void setup(){
    
       User thisUser = [ select Id from User where Id = :UserInfo.getUserId() ];
       System.runAs(thisUser){
       Test.startTest();
            Profile p = [SELECT Id FROM Profile WHERE Name='Integration User'];
           
            UserRole role = new UserRole(DeveloperName = 'MyCustomRole', Name = 'Pricing');
            insert role;                       
           
            User u1 = new User(Alias = 'standt3',Region__c ='Test', Country='United State',Email='demo3@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo3@camfed.org',UserRoleId = role.id);
            insert u1;          
                          
            Account a = new Account();
            a.ownerid= u1.id;
            a.Name = 'Test Account';
            a.BillingPostalCode = '73455-0001';
            a.BillingCity = 'NY';            
            a.Segment__c = 'Test';
            a.CreatedDate =Date.today();
            
            for(RecordType rt: [Select Id, Name From RecordType Where Name = 'US Customer Account' AND SObjectType = 'Account']){
                a.RecordTypeId = rt.Id;
            }
            insert a;
            
            for(Account acc: [Select Id, Owner.Name, Owner.UserRole.Name, Name, Owner.Region__c, Count__c, Data_Quality_Score__c, Segment__c, Account_Owner_SGID__c, RecordType.Name, CreatedDate From Account Where Id = : a.Id ]) {
                
            }
            
            Contact c = new Contact();
            c.ownerid= u1.id;
            c.LastName = 'Test Contact';
            c.Phone = '1234566890';
            c.Email = 'test@test.com';
            c.AccountId = a.Id;
            c.MailingStreet='20 Test Road';
            c.MailingCity='Malvern Test';
            c.MailingState='PA';
            c.MailingPostalCode='19355';
            for(RecordType rtc: [Select Id, Name From RecordType Where Name = 'Gypsum USA Contact' AND SObjectType = 'Contact']){
                c.RecordTypeId = rtc.Id;
            }
            insert c;
            for(Contact con: [Select id, Owner.Name, Owner.UserRole.Name, Owner.Region__c, Count__c, Data_Quality_Score__c, Contact_Owner_SGID__c, RecordType.Name, CreatedDate From Contact Where Id = : c.Id ]) {
                
            }
           
            Opportunity o = new Opportunity();
            o.ownerid= u1.id;
            o.Name = 'test opty';
            //o.CloseDate = Date.today().addDays(20);
            o.StageName = 'Completed Won';
            o.Notify_TM__c = true;
            o.Notify_TM_Date__c = Date.today();
            o.Project_Data_Completed__c = true;
            o.Project_Data_Completed_Date__c = Date.today();
            //o.Dealer_Supplying__c = a.id;
            o.Contractor_Supplying__c = a.id;
            o.Validated_by_Board_RM__c = 'Yes';
            o.Validated_by_Finishing_RM__c = 'Yes';
            o.Type ='CT Corners Conversion';
            o.Agreement_Date__c = Date.today();
            //o.Ship_Date__c = Date.today();
           o.Segment__c = 'Residential';
           o.TotalOpportunityQuantity = 3;
           o.CloseDate = Date.newInstance(2019, 01, 01);
           o.Pricebook2Id = Test.getStandardPricebookId();

           o.Gypsum_Product_Value__c = 100;
            for(RecordType rtc: [Select Id, Name From RecordType Where Name = 'Gypsum USA Conversions' AND SObjectType = 'Opportunity']){
                o.RecordTypeId = rtc.Id;
            }           
            
            try {
                insert o;
                o.CloseDate = Date.today().addMonths(-7);
                Update o;
                System.debug('**##$$ O' + o);
            } catch (Exception e) {
               System.debug('An error occurred opportunity');
            }
            System.debug('**## '+ [SELECT id, Name, CloseDate, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems Where Product_Grouping__c ='Finishing') FROM Opportunity Where StageName='Completed Won' AND Type ='CT Corners Conversion']);
            system.debug('Opportunity::'+o.Id);
           
            Set<Id> idSetTest = new Set<Id>();
            for(Opportunity opp: [Select id From Opportunity Where Id = : o.Id AND RecordType.Name ='Gypsum USA Conversions']) {
                idSetTest.add(opp.id);
                
            }            
            
            Product2 pro2 = new Product2(Name='BXCD',isActive=true, Description='Test Product Entry 1');
            insert pro2;
   
            PricebookEntry pbe2 =new PricebookEntry(unitprice=0.01,Product2Id=pro2.Id,Pricebook2Id=Test.getStandardPricebookId(), isActive=true,UseStandardPrice = false);            
                    
            OpportunityLineItem OPplineitem2 = new OpportunityLineItem (UnitPrice =pbe2.UnitPrice, Quantity=2, OpportunityId=o.Id,PriceBookEntryId=pbe2.Id, Product2Id = pro2.Id, TotalPrice = 2 * pbe2.UnitPrice);
  
            try {
                insert OPplineitem2;
            } catch (Exception e) {
               System.debug(e.getMessage() + e.getStackTraceString() + 'An error occurred line item');
            }
           for(OpportunityLineItem lineItem: [Select id, Name, Product2Id, Product_Grouping__c From OpportunityLineItem Where OpportunityId = : o.Id ]) {
                
            }           
           
            Region__c r = new Region__c(Name='Southeast', Zip_Code__c='73455', Sales_Org__c = '1502');
            insert r;
           
           /* Dodge_Project__c dp = new Dodge_Project__c();
            dp.Title__c = 'Test Project';
            dp.Report_ID__c = '123';
            dp.Dodge_Report_Version_Number__c = '1';
            dp.Dodge_Report_Number__c = '12';
            dp.Bid_Date__c = Date.today();
            dp.Status__c = 'Converted';
            dp.Opportunity_ID__c = o.Id;
            dp.Address_Line_1__c = 'test1'; 
            dp.Address_Line_2__c = 'Test2';
            dp.Address_Line_3__c = 'test3';
            dp.City__c = 'UsTest';
            dp.State__c = 'ustest2';
            dp.Region__c = r.id;
            insert dp;
           
            for(Dodge_Project__c lead: [Select id, Count__c, CreatedDate, Region__r.Name, Data_Quality_Score__c, Status__c From Dodge_Project__c Where Id = : dp.Id ]) { 
                
            }*/
           
            Task t = new Task();
            t.ownerid= u1.id;
            t.WhatId = a.Id;
            t.Subject = 'Testing';
            t.ActivityDate = Date.newInstance(2019, 01, 01);
            t.Activity_Type__c = 'KPI VAP PK Spec';
            t.status = 'Completed';
            for(RecordType rtc: [Select Id, Name From RecordType Where Name = 'USA Task' AND SObjectType = 'Task']){
                t.RecordTypeId = rtc.Id;
            }
            insert t;           
           
            Test.stopTest();
         } 
         
  }

    public static testMethod void testCallidus(){
        
            Test.startTest();        
            CallidusServices.getAccountDataQuality();
            CallidusServices.getContactDataQuality();
            CallidusServices.getLeadDataQuality();
            CallidusServices.getActivityService();
            CallidusServices.getOpportunityService();
             //AccountService as= new AccountService(new Apexpages.Standardcontroller());
             CallidusServices.AccountService cas = new CallidusServices.AccountService();
            Test.stopTest();
    }
    
}