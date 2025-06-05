/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* This test class will cover CT_CustomerRebatesListController apex class. 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Deepak Regala (dregala@liquidhub.com)
* @verstion       1.0
* @created        2017-10-18   39,
*/
@isTest
public class CT_NoChargeSalesAdjustmentCtrl_Test {

    static testMethod void test1(){
        String qry = 'SELECT Id, Name, Case__c, Product__c, Price__c, Unit_of_Measure__c FROM Sales_Adjustment_No_Charge__c';
        Id salesAdjRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Sales Adjustment No Charge').getRecordTypeId();
        Id acctSoldToRecTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        
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
        
        Case c1 = new Case();
        c1.status = 'New';
        c1.origin = 'Email';
        c1.AccountId = a1.Id;
        c1.Territory__c = 'terr';
        c1.Country__c = 'USA';
        c1.RecordTypeId = salesAdjRecTypeId;
      //  c1.Version_Number__c = 1;
        c1.Sold_to_Name__c = a1.Id;
        c1.Ship_To_Company__c = a1.Id;
        c1.Rebill_Sold_To__c = a1.Id;
       // c1.Rebill_Different_Customers__c = 'Yes';
        insert c1;
        
 Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing1232324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c='0600';
        insert Testingplant1;
         String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
        Product2 newProduct = new Product2(
            Name = 'Test Product'
            ,ProductCode = '123'
            ,RecordTypeId = strRecordTypeId
            ,ApprovingPlant__c = Testingplant1.id
        );
        insert newProduct;
        
        
        
        Test.startTest();
        
        Sales_Adjustment_No_Charge__c salAdj1 = new Sales_Adjustment_No_Charge__c(
            Name = 'Sales Adj Test',
            Case__c = c1.Id,
            Price__c = 3,
            Product__c = newProduct.Id,
            Unit_of_Measure__c = 'MSF'
        );
        
        CT_NoChargeSalesAdjustmentController.addSalesAgjustment(salAdj1);
        
        String json = '[{"caseId":"'+c1.Id+'","displayMode":"Edit","materialNumber":"345342","price":45,"productId":"'+newProduct.Id+'","productName":"FIBA TAPE MOLDX-10 300X 12CTN","recordId":"'+salAdj1.Id+'","unitOfMeasure":"MSF"},{"caseId":"'+c1.Id+'","displayMode":"Read","materialNumber":"0000000638683","price":500,"productId":"'+newProduct.Id+'","productName":"1/2 REGULAR 4X8 TE-K40","recordId":"","unitOfMeasure":"MSF"}]';
        
        CT_NoChargeSalesAdjustmentController.updateSalesAdjustments(json);
        CT_NoChargeSalesAdjustmentController.getSalesAdjustments(c1.Id);
        CT_NoChargeSalesAdjustmentController.updateCaseSalesAdjustments(c1.Id, json);
        CT_NoChargeSalesAdjustmentController.deleteNoChargeRecord(salAdj1.Id);
        
        Test.stopTest();
        
    }
}