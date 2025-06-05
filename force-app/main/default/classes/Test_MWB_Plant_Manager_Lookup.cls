@isTest
public class Test_MWB_Plant_Manager_Lookup {

 @isTest static void doGet() {
         List<case> caseList = new List<case>();
         List<String> accls = new List<String>();
          map<string,id> plantMap = new map<string,id>();
        
       Id ServiceCaseRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId();
         Id acctSoldToRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        Id acctPayerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payer').getRecordTypeId();
        
 
 // Create Account record
        Account a1 = new Account();
        a1.name ='Test Acc 1';
        a1.RecordTypeId = acctSoldToRecTypeId;
        a1.SAP_ACCOUNT__c = 'ABC0023';
        a1.BillingCity = 'Test City';
        a1.BillingCountry = 'USA';
        a1.BillingPostalCode = '560043';
        a1.BillingState = 'Test State';
        a1.BillingStreet = 'Test Street';
        a1.JDE_Hierarchy_Level__c = 'Sold-To';
        insert a1;
        
        accls.add(a1.Id);
        
        Account a2 = new Account();
        a2.name ='Test Acc 2';
        a2.RecordTypeId = acctPayerRecTypeId;
        a2.SAP_ACCOUNT__c = 'ABC0024';
        a2.BillingCity = 'Test City';
        a2.BillingCountry = 'USA';
        a2.BillingPostalCode = '560043';
        a2.BillingState = 'Test State';
        a2.BillingStreet = 'Test Street';
        a2.JDE_Hierarchy_Level__c = 'Payer';
        insert a2;
        
        accls.add(a2.Id);
        
        Account a3 = new Account();
        a3.name ='Test Acc 3';
        a3.RecordTypeId = acctPayerRecTypeId;
        a3.SAP_ACCOUNT__c = 'ABC00246';
        a3.BillingCity = 'Test City';
        a3.BillingCountry = 'USA';
        a3.BillingPostalCode = '560043';
        a3.BillingState = 'Test State';
        a3.BillingStreet = 'Test Street';
        a3.JDE_Hierarchy_Level__c = 'Payer';
        a3.ParentId = a1.Id;
        insert a3;
        
        
        Profile int_PF = [SELECT ID, Name FROM Profile WHERE Name = 'Integration User'];
        Profile sr_PF = [SELECT ID, Name FROM Profile WHERE Name = 'Sales Rep'];
        
        User int_User = New User();
        int_User.LastName = 'Integration User';
        int_User.ProfileId = int_PF.id;
        int_User.Alias ='intuser';
        int_User.Sales_Org__c='1503';
        int_User.Email = 'integration123@saint-gobain.com';
        int_User.Username = 'integration123@saint-gobain.com';
        int_User.TimeZoneSidKey = 'America/New_York';
        int_User.EmailEncodingKey = 'UTF-8';
        int_User.LocaleSidKey = 'en_US';
        int_User.LanguageLocaleKey =  'en_US';   
        insert int_User;
        
        User sr_User = New User();
        sr_User.LastName = 'SalesRep';
        sr_User.ProfileId = sr_PF.id;
        sr_User.Alias ='SalesRep';
        sr_User.Sales_Org__c='1503';
        sr_User.Email = 'SalesRep@saint-gobain.com';
        sr_User.Username = 'SalesRep@saint-gobain.com';
        sr_User.TimeZoneSidKey = 'America/New_York';
        sr_User.EmailEncodingKey = 'UTF-8';
        sr_User.LocaleSidKey = 'en_US';
        sr_User.LanguageLocaleKey =  'en_US';   
        insert sr_User;
        
        
         Plants__c plant = new Plants__c();
        plant.name='test';
        plant.Plant_Manager__c=sr_User.id;
        plant.Country__c='canada';
        plant.SAP_Plant__c ='0609';
        insert plant;
        
        plantMap.put(plant.name,plant.Plant_Manager__r.Id);
        // Create cases under the account;
        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Sold_To_Name__c = a1.Id;
        c1.Territory__c = 'terr';
        c1.Country__c = 'Canada';
       c1.Plant_Manager__c=int_User.id;
      c1.Warehouse__c='GYP Calgary Finishing Plant';
        c1.RecordTypeId = ServiceCaseRecTypeId ;
        c1.Portal_Subject__c='Internal Service Case';
        c1.Issue_Problem__c ='Service Charter Product Failure';
        c1.Issue_Category__c ='Service Incomplete';
        insert c1;
         //c1.Plant_Manager__c=sr_User.id;
           c1.Plant_Manager__c= plantMap.get(c1.Warehouse__c);
         update c1;
        
       
         
       
        Case c2 = new Case();
        c2.status = 'New';
        c2.origin = 'Email';
        c2.AccountId = a1.Id;
        c2.Territory__c = 'terr';
        c2.RecordTypeId = ServiceCaseRecTypeId ;
        c2.Country__c = 'Canada';
        c2.Portal_Subject__c='Incorrect Product';
        //c2.Plant_Manager__c='';
        c2.Warehouse__c='GYP Calgary Finishing Plant';
       
        insert c2;
          c1.Plant_Manager__c= plantMap.get(c2.Warehouse__c);
         update c2;
        
        case c5 = new case();
        c5.status = 'New';
        c5.origin = 'Email';
        c5.AccountId = a1.Id;
        c5.Credit_Order__c ='456';
        c5.Debit_Order__c ='456';
        c5.ParentId = c1.Id;
        c5.RecordTypeId = ServiceCaseRecTypeId ;
        c5.Sold_to_Name__c = a1.Id;
        c5.Portal_Subject__c='Invoice Discrepancy';
        c5.Comments_Planning__c =NUll;
        c5.OWnerId=sr_User.id;
        test.startTest();   
        insert c5;
        c5.planner__c=c5.OWnerId;
        update c5;
       
        caseList.add(c1);
        caseList.add(c2);
        caseList.add(c5);
       

    /*SEMS_Service__c ss = new SEMS_Service__c();
        ss .Name = a1.Name;
        ss .Account__c = a1.Id; 
        ss .Case__c = c5.Id;
        ss .Account_Number__c = a1.SAP_ACCOUNT__c ;
        ss .City__c = a1.BillingCity;
        ss .PostalCode__c = a1.BillingPostalCode;
        ss .Province__c = a1.BillingState;
        ss .Address__c = a1.BillingStreet;
        ss .JDE_Hierarchy_Level__c = a1.JDE_Hierarchy_Level__c;
        
        insert ss ;*/
     
     
     MWB_Plant_Manager_Lookup.getPlantManager(caseList);
     test.stopTest();
 
 }




}