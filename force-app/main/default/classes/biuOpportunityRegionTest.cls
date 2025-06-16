/*
 * Author : Raja Jaswani
 * Date   : 11/02/2020
 * Description : Test Class For biuOpportunityRegion Trigger
 * 
*/

@isTest
public class biuOpportunityRegionTest {
  public static testMethod void testTriggerMethord(){
      Test.startTest();
      Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
      User u1 = new User();
      u1.Alias = 'standt';
      u1.Email='teststandarduser1@testorg.com';
      u1.EmailEncodingKey='UTF-8';
      u1.LastName='Testing';
      u1.LanguageLocaleKey='en_US';
      u1.LocaleSidKey='en_US';
      u1.ProfileId = p.Id;
      u1.TimeZoneSidKey='America/Los_Angeles';
      u1.UserName='teststandarduser1@testorg.com';
      insert u1;
      account acc = new account(name='test account',BillingPostalCode='1234546464');
      insert acc;
      RecordType rObj = [Select Id ,Name From RecordType Where Name = 'Gypsum USA Project' AND SObjectType = 'Opportunity' limit 1];
      System.assertEquals('Gypsum USA Project', rObj.Name);
      Opportunity opp = new Opportunity();
      opp.CloseDate=date.today().addMonths(2);
      opp.Name='test opp';
      opp.StageName='IsWon';
      opp.AccountId=acc.id;
      opp.RecordTypeId=rObj.id;
      opp.Zip_Code__c ='16664564';
      insert opp;
      system.debug('opp'+opp);
      Opportunity  oppobj =[select id ,RecordTypeId,Zip_Code_5_digit__c from Opportunity where name = 'test opp' ];
      system.debug('oppobj'+oppobj);
      
      RecordType rObj1 = [Select Id ,Name From RecordType Where Name = 'Insulation' AND SObjectType = 'Opportunity' limit 1];
      System.assertEquals('Insulation', rObj1.Name);
      
      Opportunity oppTest = new Opportunity();
      oppTest.CloseDate=date.today().addMonths(2);
      oppTest.Name='test opp1';
      oppTest.StageName='Cancelled';
      oppTest.AccountId=acc.id;
      oppTest.RecordTypeId=rObj1.id;
      oppTest.Zip_Code__c ='166645647';
      oppTest.Assigned_TM_User__c = u1.id;
      oppTest.Dodge_Ext_Id__c='Test DodgeExtId';
      oppTest.LeadSource = 'Dodge';
      oppTest.Group__c = 'Sales Support Group';
      insert oppTest;
      Test.stopTest();
      system.debug('oppTest'+oppTest);
      Opportunity  oppobj1 =[select id ,RecordTypeId,Zip_Code_5_digit__c from Opportunity where name = 'test opp1' ];
      system.debug('oppobj1'+oppobj1);
      
      
      rObj1 = [Select Id ,Name From RecordType Where Name = 'End User' AND SObjectType = 'Opportunity' limit 1];
      oppTest = new Opportunity();
      oppTest.CloseDate=date.today().addMonths(2);
      oppTest.Name='test opp1';
      oppTest.StageName='Cancelled';
      oppTest.AccountId=acc.id;
      oppTest.RecordTypeId=rObj1.id;
      oppTest.Zip_Code__c ='166645647';
      oppTest.Assigned_TM_User__c = u1.id;
      oppTest.Dodge_Ext_Id__c='Test DodgeExtId';
      oppTest.LeadSource = 'Dodge';
      oppTest.Group__c = 'Sales Support Group';
      oppTest.WTU_Notes__c = 'SidingOpportunity';
      insert oppTest;
      //  Region__c Regionbj = [Select Id,Name, TM__c,TM_Name__c, Region_Number__c,MSA__c,County__c,Zip_Code__c from Region__c Where Zip_Code__c =: opp.Zip_Code_5_digit__c ];
      
      
  }
    
}