/********************************************
 Created by : Sneha Gupta
 Description : Test class for SendEmailWithAttachmentAction S-504993
 Created Date : 5th August 2017

 ********************************************/
@isTest

public class SendEmailWithAttachmentActionTest{

     public static testMethod void newTestMethod() { 
     
     SendEmailWithAttachmentAction.EmailSettings obj= new SendEmailWithAttachmentAction.EmailSettings();
     List<String> testString= new List<String>();
     testString.add('test@test.test');
     testString.add('test@test.test');

        Account acc = new Account();
        acc.Name ='Test Account';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();    //Added by Purnima for Story S-562343
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'Test Name';
        con.phone ='1234';
        con.MailingStreet='20 moores Road';
        con.MailingCity='Malvern';
        con.MailingState='PA';
        con.MailingPostalCode='19355';
        con.AccountId = acc.Id;
        con.Email='test@test.com';
        insert con;
        
        Large_Job_Quote__c ljq = new Large_Job_Quote__c();
        ljq.CHK_Code__c = '1234';
        ljq.Contract__c = 'Test Contract';
        insert ljq;
        
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();

        List<Messaging.SingleEmailMessage> msgLst=new List<Messaging.SingleEmailMessage>{msg};
       
        
        
      
     EmailTemplate temp= [select id, name from EmailTemplate where developername='ContactFollowUpSAMPLE' limit 1];
         
        

     obj.ToAddresses=testString;
     obj.CCAddresses=testString;
     obj.BCCAddresses=testString;
     obj.TemplateAPIName='ContactFollowUpSAMPLE';
     obj.TargetObjectId=con.ID;
     obj.WhatId=ljq.Id;
     obj.ReplyToId=UserInfo.getUserId();
     obj.PDFAttachmentURL='test';
     obj.FileName='test';
     List<SendEmailWithAttachmentAction.EmailSettings> testObj= new List<SendEmailWithAttachmentAction.EmailSettings>();
     testObj.add(obj);
     
     
     SendEmailWithAttachmentAction.sendEmailWithVFPDFAttachmentAction(testObj);
     
     
     
     }
 }