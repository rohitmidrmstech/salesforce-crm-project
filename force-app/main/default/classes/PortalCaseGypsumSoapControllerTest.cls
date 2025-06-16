/**
* ──────────────────────────────────────────────────────────────────────
* This test class will cover PortalCaseGypsumSoapController apex class. 
* ──────────────────────────────────────────────────────────────────────
* @author         Satyajit Chanda
* @verstion       1.0
* @created        02-21-2018
*/
@isTest
public class PortalCaseGypsumSoapControllerTest{

   public static testMethod void testgetPortalCases1(){
            
        Profile p = [SELECT Id FROM Profile WHERE Name='Integration User'];
        
        User u1 = new User(Alias = 'standt3',Country='United State',Email='demo3@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo3@camfed.org');
        INSERT u1;       
            
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Case' and isActive=true];       
        Map<String,String> rTypMap = new Map<String,String>{};
        
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }      
        
        Id portalRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Portal').getRecordTypeId();
        Id acctSoldToRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        Id acctPayerRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payer').getRecordTypeId();
        Id acctShipToRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship-To').getRecordTypeId();
       
        Contact conObj = new Contact(FirstName='test',LastName='TestLast',Phone='12345',Email='test@test.com',MailingCity='TestCity',MailingState = 'CA', MailingStreet = 'Mailing Street',MailingPostalCode='19341');
        INSERT conObj;                     
                
        Account accPayer = new Account();
        accPayer.RecordTypeId = acctPayerRecTypeId;
        accPayer.Name='Payer Account';
        accPayer.JDE_Hierarchy_Level__c = 'Payer';
        INSERT accPayer;
       
        Account accSoldTo = new Account();
        accSoldTo.RecordTypeId = acctSoldToRecTypeId;
        accSoldTo.Name='SoldTo Account';
        accSoldTo.JDE_Hierarchy_Level__c = 'Sold-To';
        INSERT accSoldTo;
       
        Account accShipTo = new Account();
        accShipTo.RecordTypeId = acctShipToRecTypeId;
        accShipTo.Name='ShipTo Account';
        accShipTo.JDE_Hierarchy_Level__c = 'Ship-To';
        INSERT accShipTo;
        
        Order objOrder = new Order();
        objOrder.accountId = accPayer.id;
        objOrder.Ship_To__c = accShipTo.id;
        objOrder.Sold_To__c = accSoldTo.id;        
        objOrder.effectiveDate = Date.Today();
        objOrder.status = 'Draft';
        objOrder.PONumber='38913812';
        objOrder.PoNumber='23456767';
        objOrder.Sales_Org__c= '1101';
        INSERT objOrder;
        
        Case cObj = new Case(RecordTypeId=rTypMap.get('Portal'), ContactId=conObj.id);
        cObj.PortalCaseId__c = 'TestPortalCaseId';
        cObj.SuppliedName= 'Testname';
        cObj.SuppliedEmail= 'abc@cde.com';
        cObj.SuppliedPhone= '(999) 924-5712';       
        cObj.Type= 'Order Change';
        cObj.Subject= 'Test Soap';               
        cObj.Description= 'test Sucessfull';        
        cObj.Order_Line_Items__c = 'Test Comment 1';
        cObj.Documents__c= 'http://certainteedcustomerportal/maptest'; 
        cObj.Order__c = objOrder.id ;    
        cObj.Status = 'Success';
        cObj.Origin='Portal';
        cObj.Priority='Medium';
        //cObj.Ship_To_Company__c = objAccount.id;        
        INSERT cObj;
        
        list <CaseComment> listComment = new list <CaseComment>();       
        CaseComment comment = new CaseComment();
        comment.IsPublished = true;
        comment.CommentBody='Test';
        comment.ParentId = cObj.id;
        listComment.add(comment);
            
        CaseComment comment1 = new CaseComment();
        comment1.IsPublished = true;
        comment1.CommentBody='Test1';
        comment1.ParentId = cObj.id;
        listComment.add(comment1);    
        INSERT listComment;       
        
        list <Issues__c> listIssue = new list <Issues__c>(); 
        Issues__c issue = new Issues__c();
        issue.Case__c = cObj.Id;
        issue.Category__c = 'Cove and Cornice';
        issue.Problem__c = 'Paper Color';
        listIssue.add(issue);
       
        Issues__c issue1 = new Issues__c();
        issue1.Case__c = cObj.Id;
        issue1.Category__c = 'Cove and Cornice';
        issue1.Problem__c = 'Product Problem';
        listIssue.add(issue1);
       
        INSERT listIssue;

      System.runAs(u1){
       
        Test.startTest();
        PortalCaseGypsumSoapController.getPortalCases();
        Test.stopTest();
     }     
  }
    
}