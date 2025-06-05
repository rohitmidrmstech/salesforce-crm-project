/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* This test class will cover ServiceCaseUSAController apex class. 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Prasan Sharma
* @verstion       1.0
* @created        2023-09-28
*/
@isTest
public class ServiceCaseUSAControllerTest {
    
    @testSetup static void configSetup() {
        CT_Common_Settings__c common = CT_Common_Settings__c.getOrgDefaults();
        common.CaseApprovalPath_OverridingProfileIds__c = '00ed00000016siG';
        upsert common;
    }
    
    static testMethod void testServiceCaseUSAController(){
        
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
        c1.status ='Draft';
        c1.AccountId = a1.Id;
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='USA';
        c1.Reporting_Index_Type__c ='Plant';
        c1.Product_Category__c = 'Corners West';
        
        insert c1;
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
        
        Approval.ProcessSubmitRequest app = new Approval.ProcessSubmitRequest();
        app.setObjectId(c1.id);
        Approval.ProcessResult result = Approval.process(app);
        
        Test.startTest();
        ServiceCaseUSAController.recallApproval(c1.Id);
        Test.stopTest();
    }
    
    static testMethod void testCaseTriggerServiceUSA(){
        
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
        c1.status ='Draft';
        c1.AccountId = a1.Id;
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='USA';
        c1.Product_Category__c = 'Corners West';
        
        insert c1;
        
        c1.Reporting_Index_Type__c ='Plant';
        c1.Product_Category__c = 'Corners West';
        
        update c1;
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
    }
    
    static testMethod void testCaseTriggerServiceUSACornersEast(){
        
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
        c1.status ='Draft';
        c1.AccountId = a1.Id;
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='USA';
        c1.Product_Category__c = 'Corners East';
        
        insert c1;
        
        c1.Reporting_Index_Type__c ='Plant';
        c1.Product_Category__c = 'Corners West';
        
        update c1;
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
    }
    
    static testMethod void testCaseTriggerServiceUSAMilledGypsum(){
        
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
        c1.status ='Draft';
        c1.AccountId = a1.Id;
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='USA';
        c1.Product_Category__c = 'Milled Gypsum';
        
        insert c1;
        
        c1.Reporting_Index_Type__c ='Plant';
        c1.Product_Category__c = 'Corners West';
        
        update c1;
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
    }
    
    static testMethod void testCaseTriggerServiceUSAExport(){
        
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
        c1.status ='Draft';
        c1.AccountId = a1.Id;
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='India';
        c1.Product_Category__c = 'Export';
        
        insert c1;
        
        c1.Reporting_Index_Type__c ='Plant';
        c1.Product_Category__c = 'Corners West';
        
        update c1;
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
    }
    
    static testMethod void testCaseTriggerServiceUSAFinishing(){
        
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
        c1.status ='Draft';
        c1.AccountId = a1.Id;
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='USA';
        c1.Product_Category__c = 'Finishing';
        
        insert c1;
        
        c1.Reporting_Index_Type__c ='Plant';
        c1.Product_Category__c = 'Corners West';
        
        update c1;
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
    }
    
    static testMethod void testServiceCaseUSAControllerv2(){
        Test.startTest();
        ServiceCaseUSAController.assignPermissionSet();
        ServiceCaseUSAController.removePermissionSet();
        Test.stopTest();
    }
}