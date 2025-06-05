/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* This test class will cover all the classes related to the Issue trigger. 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Deepak Regala (dregala@liquidhub.com)
* @verstion       1.0
* @created        2017-06-12
*/
@isTest
public class CT_IssueTriggerHandlerTest {
    
    static testmethod void test1(){
        List<CT_Issues_Problem_Code__c> custSett = new List<CT_Issues_Problem_Code__c>();
        CT_Issues_Problem_Code__c probCode1 = new CT_Issues_Problem_Code__c();
        probCode1.Name = '317';
        probCode1.Category__c = 'Bead';
        probCode1.Problem__c = 'Paper Delamination';
      	probCode1.Code__c = 'DEL';
        
        CT_Issues_Problem_Code__c probCode2 = new CT_Issues_Problem_Code__c();
        probCode2.Name = '308';
        probCode2.Category__c = 'Cove and Cornice';
        probCode2.Problem__c = 'Paper Color';
        probCode2.Code__c = 'QLT';
        
        custSett.add(probCode1);
        custSett.add(probCode2);
        insert custSett;
       
        
        Id caseRecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId();
        Id caseRecordTypeId1 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Case').getRecordTypeId();
        Id caseRecordTypeId2 = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId();

       
        account a = new account();
        a.name ='Test Acc';
        insert a;

        Case c = new Case();
        c.RecordTypeId = caseRecordTypeId;
        c.Origin = 'Web';
        c.Status = 'Draft';
        c.AccountId = a.Id;
        c.Portal_Subject__c = 'Invoice Discrepancy';
        insert c;
        
        Case c1 = new Case();
        c1.RecordTypeId = caseRecordTypeId2;
        c1.Origin = 'Web';
        c1.Status = 'Draft';
        c1.AccountId = a.Id;
        c1.Portal_Subject__c = 'Invoice Discrepancy';
        insert c1;
        
        
        List<Issues__c>IssueList = new List<Issues__c>();
        Issues__c issue = new Issues__c();
        issue.Case__c = c.Id;
        issue.Category__c = 'Cove and Cornice';
        issue.Problem__c = 'Paper Color';
        issue.RecordTypeId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Issues').getRecordTypeId();
      
        IssueList.add(issue);
        insert IssueList;
        IssueList[0].Category__c = 'Bead';
        IssueList[0].Problem__c = 'Paper Delamination';
        update IssueList;
        CT_IssueTriggerHandler obj = new CT_IssueTriggerHandler();
       	CT_IssueTriggerHandler.beforeInsertHandler(IssueList); 
        CT_IssueTriggerHandler.testmethodcoverga();
    }

}