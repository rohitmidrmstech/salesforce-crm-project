/**
 * @description Test class for WOD_OrderTriggerHandler
*/
@isTest
public class WOD_OrderTriggerTest {
    /**
     * @description test method execution
    */
    public static testmethod void orderTest(){
        Test.startTest();
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        
        Id recTypeIdShipTo = [select Id from RecordType where DeveloperName ='Ship_to' and SobjectType = 'Account' limit 1].Id;
        Account shiptoAcc = WOD_TestDataFactory.createAccount('Shipto','','Customer');
        shiptoAcc.recordTypeId =recTypeIdShipTo;
        shiptoAcc.LOB__c ='1501';
        shiptoAcc.Status__c ='Active';
        insert shiptoAcc;
        
        Id recTypeIdSoldTo = [select Id from RecordType where DeveloperName ='Sold_to' and SobjectType = 'Account' limit 1].Id;
        Account soldtoAcc = WOD_TestDataFactory.createAccount('Shipto2','','Customer');
        soldtoAcc.recordTypeId =recTypeIdSoldTo;
        soldtoAcc.LOB__c ='1501';
        soldtoAcc.Status__c ='Active';
        insert soldtoAcc;
        
        Hierarchy_Ship_To_Sold_To__c h = new Hierarchy_Ship_To_Sold_To__c();
        h.Ship_To__c = shiptoAcc.id;
        h.Sold_To__c = soldtoAcc.id;
        h.Sales_Org__c = '1501';
        insert h;
        
        Product_Type__c productType= WOD_TestDataFactory.createProductType();
        insert productType;
        
        WOD_2__Policy_Definition__c polDef = WOD_TestDataFactory.createPolicyDefination();
        insert polDef;
        
        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        product.Product_Type__c =productType.Id;
        product.Item_Class__c='90';
        insert product;
        
        Plants__c p = WOD_TestDataFactory.createPlant('test','aaaa');
        insert p;
        
        WOD_Manufacturing_Plant__c plant = WOD_TestDataFactory.createManufacturingPlant('POL','aaaa','1000');
        insert plant;
        
        Pitch_Cost__c pc= WOD_TestDataFactory.createPitchCost();
        insert pc;
        
        WOD_RSMeans__c rs = WOD_TestDataFactory.createRSMeans();
        insert rs;
        
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim.Plant__c = p.Id; 
        claim.WOD_2__Applicable_Policy__c= polDef.Id;
        claim.State_BL__c ='Florida (FL)';
        claim.Country_BL__c ='United States';
        claim.WOD_2__warranty_product__c =product.Id;
        claim.Install_Date__c =System.Today();
        claim.Business_Units__c = 'Roofing';
        claim.Division_Code__c = 'Residential';
        insert claim;
        
        WOD_Payment__c pay1 = WOD_TestDataFactory.createPayment('Check','1501',claim.Id,'POL - Policy Adjustment','Claimant');
        pay1.Organization__c = 'Tavant';
        pay1.RemitTo_City__c ='Kolkata';
        pay1.RemitTo_State__c ='WB';
        pay1.RemitTo_ZipCode__c ='656787';
        pay1.RemitTo_Address1__c ='Digha';
        pay1.RemitTo_Country__c ='India';
        pay1.Order_Number__c='11111';
        insert pay1;
        
        Order ord=new Order();
        ord.Name='Test';
        ord.Sales_Org__c='1501';
        ord.Total_Cost__c=500;
        ord.Planned_Ship_Date__c=System.today();
        ord.AccountId=acc.Id;
        ord.EffectiveDate=System.today();
        ord.Status='Draft';
        ord.BPCS_Order__c='11111';
        Insert ord;
        
        ord.Sales_Org__c='1502';
        ord.Planned_Ship_Date__c=System.today();
        update ord;
        
        Order ord2=new Order();
        ord2.Name='Test2';
        ord2.Sales_Org__c='1501';
        ord2.Total_Cost__c=0;
        ord2.Planned_Ship_Date__c=System.today();
        ord2.AccountId=acc.Id;
        ord2.EffectiveDate=System.today();
        ord2.Status='Draft';
        ord2.BPCS_Order__c='11111';
        Insert ord2;
        
        ord2.Sales_Org__c='1502';
        ord2.Total_Cost__c=0;
        ord2.Planned_Ship_Date__c=System.today();
        update ord2;
        
        ord2.Total_Cost__c=60;
        update ord2;
        Test.stopTest();
    }
}