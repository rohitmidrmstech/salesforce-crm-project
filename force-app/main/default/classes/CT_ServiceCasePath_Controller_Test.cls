/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* This test class will cover CT_ServiceCasePath_Controller apex class. 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Prasan Sharma
* @verstion       1.0
* @created        2023-09-28
*/
@isTest
public class CT_ServiceCasePath_Controller_Test {
    
    @testSetup static void configSetup() {
        CT_Common_Settings__c common = CT_Common_Settings__c.getOrgDefaults();
        common.CaseApprovalPath_OverridingProfileIds__c = '00ed00000016siG';
        upsert common;
    }
    
    static testMethod void testCT_ServiceCasePath_Controller(){
        
        Id salesAdjRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId();
        Id acctSoldToRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        
        Account a1 = new Account();
        a1.name ='Test Acc 1';
        a1.RecordTypeId = acctSoldToRecTypeId;
        a1.SAP_ACCOUNT__c = 'ABC0023';
        a1.BillingCity = 'Test City';
        a1.BillingCountry = 'Canada';
        a1.BillingPostalCode = '560043';
        a1.BillingState = 'NY';
        a1.BillingStreet = 'Test Street';
        a1.JDE_Hierarchy_Level__c = 'Sold-To';
        insert a1;
        List<User> u2 = [Select Id FROM User WHERE Profile.Name = 'USA RM User'];
        
        Plants__c p1 = new Plants__c();
        p1.Name ='Name';
        p1.SAP_Plant__c ='0276';
        insert p1;
        
        Supplier__c s1= new Supplier__c();
        s1.Name ='Name';
        insert s1;
        CaseApprovalPath_Config__c aprPathConfig = new CaseApprovalPath_Config__c();
        aprPathConfig.AssigneeType__c = 'Field';
        aprPathConfig.Country__c = 'Canada';
        aprPathConfig.Field__c = 'Plant_Manager_Id__c';
        aprPathConfig.Name = 'Can-Quality-Quality Manager';
        aprPathConfig.Next_Status__c = 'Pending Plant Manager';
        aprPathConfig.RecordTypeId__c = salesAdjRecTypeId;
        aprPathConfig.Sort_Order__c = 405.0;
        aprPathConfig.Status__c = 'Pending Pre Settlement';
        aprPathConfig.Status_Label__c = 'Pre Apprv Closer';
        
        insert aprPathConfig;
        
        Case c1 = new Case();
        c1.status ='Pending RMA';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Secondary_Quality_Category__c='Cost of Complaints';
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.OwnerId=u2[0].id;
        c1.Settlement_Recommendation__c ='Return Material'  ;
        c1.Issue_Problem__c ='Documentation' ;
        c1.Issue_Category__c='Dunnage/Scrap ';
        // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
        //c1.Total_Case_Value__c='100';
        c1.Order_Type_Picklist__c ='Marketing';
        
        insert c1;
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
        Test.startTest();
        
        CT_ServiceCasePath_Controller.getCaseData(c1.Id);
        CT_ServiceCasePath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        Test.stopTest();
    }
}