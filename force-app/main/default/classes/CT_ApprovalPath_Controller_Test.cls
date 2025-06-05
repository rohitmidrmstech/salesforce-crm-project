/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* This test class will cover CT_CustomerRebatesListController apex class. 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Deepak Regala (dregala@liquidhub.com)
* @verstion       1.0
* @created        2017-10-18
*/
@isTest
public class CT_ApprovalPath_Controller_Test {

    @testSetup static void configSetup() {
        CT_Common_Settings__c common = CT_Common_Settings__c.getOrgDefaults();
        common.CaseApprovalPath_OverridingProfileIds__c = '00ed00000016siG';
        upsert common;
    }

    static testMethod void test1(){
        
        Id salesAdjRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment No Charge').getRecordTypeId();
        Id acctSoldToRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        
        //string salesAdjRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case');
        Account a1 = new Account();
        a1.name ='Test Acc 1';
        a1.RecordTypeId = acctSoldToRecTypeId;
        a1.SAP_ACCOUNT__c = 'ABC0023';
        a1.BillingCity = 'Test City';
        a1.BillingCountry = 'USA';
        a1.BillingPostalCode = '560043';
        a1.BillingState = 'NY';
        a1.BillingStreet = 'Test Street';
        a1.JDE_Hierarchy_Level__c = 'Sold-To';
        insert a1;
        
        Plants__c plantRecord = new Plants__c(Name = '0822', SAP_Plant__c = '1234567890');
        insert plantRecord;

        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Country__c = 'Canada';
        //c1.Warehouse__c = '0822';
        c1.Order_Type_Picklist__c = 'Marketing';
        c1.Agree_Disagree__c = 'Disagree';
        //c1.Version_Number__c = 1;
        insert c1;
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
        
        CaseApprovalPath_Config__c aprPathConfig = new CaseApprovalPath_Config__c();
        aprPathConfig.AssigneeType__c = 'Field';
        aprPathConfig.Country__c = 'USA';
        aprPathConfig.Field__c = 'Plant_Manager_Id__c';
        aprPathConfig.Name = 'Can-Quality-Quality Manager';
        aprPathConfig.Next_Status__c = 'Pending Plant Manager';
        aprPathConfig.RecordTypeId__c = salesAdjRecTypeId;
        aprPathConfig.Sort_Order__c = 405.0;
        aprPathConfig.Status__c = 'Pending Pre Settlement';
        aprPathConfig.Status_Label__c = 'Pre Apprv Closer';
        
        insert aprPathConfig;
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        List<User> u2 = [Select Id FROM User WHERE Profile.Name = 'USA RM User'];
        //etApprovalPathData(String recordTypeId, String country,string OwnerId,string CreatedById,string caseId,string SecondaryIssueCategory){  
          CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'USA',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Pending Admin', '');
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }
    
    static testMethod void test2(){
        
        Id salesAdjRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment No Charge').getRecordTypeId();
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
        

        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Country__c = 'Canada';
       // c1.Version_Number__c = 1;
        insert c1;
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
        
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
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        List<User> u2 = [Select Id FROM User WHERE Profile.Name = 'USA RM User'];
         // CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId, 'Canada');
          CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'New', u2[0].Id);
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }
    static testMethod void test3(){
        
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
        

        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
        //c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
        insert c1;
        
        
        
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Detention Fee';
        issue1.Case__c =c1.Id;
        insert issue1;
        
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
        
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
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        List<User> u2 = [Select Id FROM User WHERE Profile.Name = 'Pricing'];
         // CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId, 'Canada');
           CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Pending Pre-Settlement Closer', u2[0].Id);
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }
    static testMethod void test4(){
        
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
        

        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
       // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
        insert c1;
        
        
        
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
        
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
        
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
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        List<User> u2 = [Select Id FROM User WHERE Profile.Name = 'USA RM User'];
          //CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId, 'Canada');
            CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }
    static testMethod void test5(){
        
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
        
        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
       // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
        //c1.Confidential__c = true;
        //c1.Corrective_Action__c ='External';
       // c1.VP_Approved_Via_Email__c =true;
        c1.Order_Type_Picklist__c ='Marketing';
        //c1.Plant_Quality_Manager_Id__c=
        //c1.Plant_Manager_Id__c =
        //c1.Supplier__c =s1.id;
        //c1.Manufacturing_Plant__c =p1.id;
       // c1.Sales_Rep__c =u2[0].Id;
        insert c1;
        
       
        
        
        
        
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Pallet Return';
        issue1.Case__c =c1.Id;
        insert issue1;
        
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
        
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
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        
        //  CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId, 'Canada');
          CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }
     static testMethod void test6(){
        
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
        List<User> u2 = [Select Id FROM User WHERE Profile.Name = 'Canada Logistics'];
        
        Plants__c p1 = new Plants__c();
        p1.Name ='Name';
         p1.SAP_Plant__c ='0276';
        insert p1;
        
        Supplier__c s1= new Supplier__c();
        s1.Name ='Name';
        insert s1;
        
        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.Status  ='Pending Closer';
        c1.RecordTypeId = salesAdjRecTypeId;
       // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
        //c1.Confidential__c = true;
        //c1.Corrective_Action__c ='External';
       // c1.VP_Approved_Via_Email__c =true;
        c1.Order_Type_Picklist__c ='Marketing';
        //c1.Plant_Quality_Manager_Id__c=
        //c1.Plant_Manager_Id__c =
        //c1.Supplier__c =s1.id;
        //c1.Manufacturing_Plant__c =p1.id;
       // c1.Sales_Rep__c =u2[0].Id;
           c1.Sales_Org__c ='1506';
           //c1.Plant_Quality_Manager_Id__c = u2;
 //c1.Plant_Manager_Id__c =u2.id;
// c1.Supplier__c =s1.id;
// c1.Manufacturing_Plant__c=s1.id;
 c1.Sales_Rep__c=u2[0].id;
 c1.Issue_Problem__c ='Service Charter Product Failure';
// c1.Investigator__c=u2[0].id;   
c1.Settlement_Recommendation__c='Return Material';
//c1.Total_Case_Value__c='100';
c1.Settle_Action__c='Issue Manual Check';   
c1.Confidential__c=true;
// c1.VP__c=u2[0].id;
 c1.Corrective_Action__c='External';
 //c1.Owner.name=u2[0].Name;
 //c1.Planner__c=u2[0].id;
 c1.Plant_Manager__c=u2[0].id;
 c1.Plant_Manager_Agree_Disagree__c ='agree';
 c1.Secondary_Issue_Category__c ='plant efficiency';
 c1.Third_Issue_Category__c='test';

 c1.VP_Approved_Via_Email__c=true;
 c1.Order_Type_Picklist__c='test';
 c1.OwnerId=u2[0].id;
 c1.createdbyid=u2[0].id;
        insert c1;
        
       
        
        
        
        
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Pallet Return';
        issue1.Case__c =c1.Id;
        insert issue1;
         
         insert new CT_Issues_Problem_Code__c(Name = 'Test', Status__c = '1', Problem__c = 'Pallet Return', Category__c = 'Documentation');
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
        
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
        
        Sales_Org_value__c salesOrg = new Sales_Org_value__c();
        //select id,Value__c,Name from Sales_Org_value__c where Name =: casObj.Sales_Org__c];  
        salesOrg.Value__c =200;
        salesOrg.Name  =c1.Sales_Org__c ;
        insert salesOrg ;
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        
          //CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId, 'Canada');
            CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
        CT_ApprovalPath_Controller.getIssueData(c1.Id);
        CT_ApprovalPath_Controller.getCustomSetting(c1.Id);
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }
    
    
    static testMethod void test7(){
        
        Id salesAdjRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case').getRecordTypeId();
        Id acctSoldToRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        
        //string salesAdjRecType = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service Case');
        Account a1 = new Account();
        a1.name ='Test Acc 1';
        a1.RecordTypeId = acctSoldToRecTypeId;
        a1.SAP_ACCOUNT__c = 'ABC0023';
        a1.BillingCity = 'Test City';
        a1.BillingCountry = 'USA';
        a1.BillingPostalCode = '560043';
        a1.BillingState = 'NY';
        a1.BillingStreet = 'Test Street';
        a1.JDE_Hierarchy_Level__c = 'Sold-To';
        insert a1;
        
        Plants__c plantRecord = new Plants__c(Name = '0822', SAP_Plant__c = '1234567890');
        insert plantRecord;

        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.Country__c = 'Canada';
        //c1.Warehouse__c = '0822';
        c1.Issue_Category__c = 'Service Incomplete';
        c1.Issue_Problem__c = 'Service Charter Product Failure';
        c1.Portal_Subject__c = 'Internal Service Case';
        //c1.Version_Number__c = 1;
        insert c1;
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
    
    
        
        CaseApprovalPath_Config__c aprPathConfig = new CaseApprovalPath_Config__c();
        aprPathConfig.AssigneeType__c = 'Field';
        aprPathConfig.Country__c = 'USA';
        aprPathConfig.Field__c = 'Plant_Manager_Id__c';
        aprPathConfig.Name = 'Can-Quality-Quality Manager';
        aprPathConfig.Next_Status__c = 'Pending Plant Manager';
        aprPathConfig.RecordTypeId__c = salesAdjRecTypeId;
        aprPathConfig.Sort_Order__c = 405.0;
        aprPathConfig.Status__c = 'Pending Pre Settlement';
        aprPathConfig.Status_Label__c = 'Pre Apprv Closer';
        
        insert aprPathConfig;
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        List<User> u2 = [Select Id FROM User WHERE Profile.Name = 'USA RM User'];
        //etApprovalPathData(String recordTypeId, String country,string OwnerId,string CreatedById,string caseId,string SecondaryIssueCategory){  
          CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'USA',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Pending Planner', u2[0].Id);
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }

static testMethod void test8(){
        
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
        
        Case c1 = new Case();
        c1.status ='Pending Investigator';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.OwnerId=u2[0].id;
        c1.Settlement_Recommendation__c ='Invoice Correction'  ;
        //c1.Issue_Problem__c !='Service Charter Product Failure' ;
       // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
        //c1.Confidential__c = true;
        //c1.Corrective_Action__c ='External';
       // c1.VP_Approved_Via_Email__c =true;
        c1.Order_Type_Picklist__c ='Marketing';
        //c1.Plant_Quality_Manager_Id__c=
        //c1.Plant_Manager_Id__c =
        //c1.Supplier__c =s1.id;
        //c1.Manufacturing_Plant__c =p1.id;
       // c1.Sales_Rep__c =u2[0].Id;
        insert c1;
        
       
        
        
        
        
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Pallet Return';
        issue1.Case__c =c1.Id;
        insert issue1;
        
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
        
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
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        
        //  CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId, 'Canada');
          CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }
    static testMethod void test9(){
        
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
        
        Case c1 = new Case();
        c1.status ='Pending Pre-Settlement Closer';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
        //c1.OwnerId=u2[0].id;
        c1.Plant_Manager__c =u2[0].id;
        c1.OwnerId =c1.Plant_Manager__c;
        c1.Settlement_Recommendation__c ='Return Material'  ;
        //c1.Issue_Problem__c !='Service Charter Product Failure' ;
       // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
        //c1.Confidential__c = true;
        //c1.Corrective_Action__c ='External';
       // c1.VP_Approved_Via_Email__c =true;
        c1.Order_Type_Picklist__c ='Marketing';
        //c1.Plant_Quality_Manager_Id__c=
        //c1.Plant_Manager_Id__c =
        //c1.Supplier__c =s1.id;
        //c1.Manufacturing_Plant__c =p1.id;
       // c1.Sales_Rep__c =u2[0].Id;
        insert c1;
        
        Case c2 = new Case();
        c2.status ='Pending Plant';
        c2.origin = 'Email';
        c2.AccountId = a1.Id;
        c2.Territory__c = 'terr';
        c2.RecordTypeId = salesAdjRecTypeId;
        c2.OwnerId=u2[0].id;
        c2.Settlement_Recommendation__c ='Return Material'  ;
        //c2.Issue_Problem__c !='Service Charter Product Failure' ;
       // c2.Version_Number__c = 1;
        c2.Portal_Subject__c ='Internal Service Case';
        c2.Country__c ='canada';
        //c2.Confidential__c = true;
        //c2.Corrective_Action__c ='External';
       // c2.VP_Approved_Via_Email__c =true;
        c2.Order_Type_Picklist__c ='Marketing';
        //c2.Plant_Quality_Manager_Id__c=
        //c2.Plant_Manager_Id__c =
        //c2.Supplier__c =s1.id;
        //c2.Manufacturing_Plant__c =p1.id;
       // c2.Sales_Rep__c =u2[0].Id;
        insert c2;
        
        
        
        
        
        
        Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Pallet Return';
        issue1.Case__c =c1.Id;
        insert issue1;
        
        
        /* PELI deleted
        Price_Exception_Line_Item__c PriceException = new Price_Exception_Line_Item__c();
        PriceException.Case__c = c1.Id;
        PriceException.IDC_Description__c='Test IDC';
        PriceException.IDC_Code__c='Test GAB';
        PriceException.New__c=true;
        PriceException.Current_Price__c = 900.00;
        PriceException.Exception_Price__c = 500.00;
        PriceException.Order_UOM__c = 'Test PC';
        PriceException.Price_UOM__c = 'MSF';
        PriceException.Product_Group__c='Test IA';
        PriceException.Product_Group_Code__c='Test IDC Group';
        PriceException.Remove__c=false;
        insert PriceException;
        */
        
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
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
      

        
        //  CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId, 'Canada');
          CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
          CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c2.id,'plant Efficiency');
        // CLOSED and an id is not normal but this is just testing
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
        CT_ApprovalPath_Controller.updateCase(c2.Id, 'Closed', u2[0].Id);
        //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
        //CT_ApprovalPath_Controller.getPriceExceptionLineData(c1.Id);        
        //Ends here
        Test.stopTest();
    }
    static testMethod void test10(){
        
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
        
        Case c1 = new Case();
        c1.status ='Pending Plant';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.RecordTypeId = salesAdjRecTypeId;
        c1.OwnerId=u2[0].id;
        c1.Settlement_Recommendation__c ='Return Material'  ;
        c1.Issue_Problem__c ='Detention Fee' ;
        c1.Issue_Category__c='Aesthetics';
       // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
       
        c1.Order_Type_Picklist__c ='Marketing';
        
        insert c1;
       Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Pallet Return';
        issue1.Case__c =c1.Id;
        insert issue1;
        
    
        
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
        
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
        CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
         Test.stopTest();
    }
    static testMethod void test11(){
        
        Id salesAdjRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Case').getRecordTypeId();
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
        c1.Issue_Problem__c ='Detention Fee' ;
        c1.Issue_Category__c='Aesthetics';
       // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='Canada';
       
        c1.Order_Type_Picklist__c ='Marketing';
        c1.Settle_Action__c = 'Return Material';
        
        insert c1;
       Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Pallet Return';
        issue1.Case__c =c1.Id;
        insert issue1;
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
        CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Pending RMA', u2[0].Id);
        Test.stopTest();
    }
    static testMethod void test12(){
        
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
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
        CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
         Test.stopTest();
    }
    static testMethod void test13(){
        
        Id salesAdjRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality Case').getRecordTypeId();
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
        a1.Product_Line__c ='Siding';
        a1.JDE_Hierarchy_Level__c = 'Sold-To';
        insert a1;
        List<User> u2 = [Select Id,IsActive FROM User WHERE Profile.Name = 'USA RM User' and IsActive =true];
        
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
        //c1.Settlement_Recommendation__c ='Return Material'  ;
        c1.Issue_Problem__c ='Documentation' ;
        c1.Issue_Category__c='Dunnage/Scrap ';
       // c1.Version_Number__c = 1;
        c1.Portal_Subject__c ='Internal Service Case';
        c1.Country__c ='canada';
        //c1.Total_Case_Value__c='100';
        c1.Order_Type_Picklist__c ='Marketing';
        // c1.Plant_Quality_Manager_Id__c =u2[0].id;
        // c1.Plant_Manager_Id__c =u2[0].id;
        // c1.Supplier__c = u2[0].id;
        c1.Manufacturing_Plant__c = p1.id;
         c1.Sales_Rep__c =u2[0].id;
         c1.Issue_Problem__c ='Airbag Deflated';
         c1.Investigator__c =u2[0].id;
         c1.Logistics_Agree_Disagree__c  = 'Agree';
         //c1.Settlement_Recommendation__c ='Credit';
         //formula c1.Total_Case_Value__c =
         c1.Settle_Action__c ='Issue Manual Check';
         //c1.Total_Credits__c =
        // c1.Total_Rebills__c =
        //c1.Warehouse__c ='GYP Albany, NY Reload';
        c1.Warehouse__c = p1.id;
         c1.Pre_Approver_1b_Pricing__c =u2[0].id;
         c1.Comments_Plant_Manager__c ='text area';
         //c1.Pre_Approver_1b_Agree_Disagree__c ='Complete';
         c1.Confidential__c = true;
         c1.Comments_Logistics__c ='text area';
        c1.VP__c =u2[0].id;
        // c1.Corrective_Action__c ='Employee Disciplined';
         //c1.Owner.name= u2[0].name;
         c1.Planner__c =u2[0].id;
         c1.Plant_Manager__c =u2[0].id;
         c1.Plant_Manager_Agree_Disagree__c  ='Agree';
        c1.Secondary_Issue_Category__c ='Unexpected Demand';
         c1.Third_Issue_Category__c ='Human Error';
        // c1.CreatedBy.name =u2[0].name;
         c1.VP_Approved_Via_Email__c = true;
         c1.Order_Type_Picklist__c  ='CT Standard Order';
         c1.OwnerId =u2[0].id;
         c1.createdbyid =u2[0].id;
        
        insert c1;
       Issues__c issue1 = new Issues__c();
        issue1.Category__c ='Documentation';
        issue1.Problem__c ='Dunnage/Scrap';
        issue1.Case__c =c1.Id;
        insert issue1;
        Test.startTest();
        
        CT_ApprovalPath_Controller.getCaseData(c1.Id);
        CT_ApprovalPath_Controller.getApprovalPathData(salesAdjRecTypeId,'Canada',u2[0].id,u2[0].id,c1.id,'plant Efficiency');
        //CT_ApprovalPath_Controller.updateCase(c1.Id, 'Closed', u2[0].Id);
         Test.stopTest();
    }
    }