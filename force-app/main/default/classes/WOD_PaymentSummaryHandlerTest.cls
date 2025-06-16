/*
ClassName    : WOD_PaymentSummaryHandlerTest
CreatedOn    : 06/11/2021
Author       : Tavant
Description  : Test class for WOD_PaymentSummaryHandler
*/

@isTest
private class WOD_PaymentSummaryHandlerTest {
    @testSetup
    public static  void testData(){
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
        claim.Business_Units__c='Roofing';
        claim.Division_Code__c='Residential';
        claim.Install_Date__c =System.Today();
        insert claim;
        
        List<WOD_Payment__c> lstPayment = new List<WOD_Payment__c>();
        WOD_Payment__c payment = WOD_TestDataFactory.createPayment('Free_Material','1501',claim.Id,'POL - Policy Adjustment','Claimant');
        payment.Organization__c = 'Tavant';
        payment.RemitTo_City__c ='Kolkata';
        payment.RemitTo_State__c ='WB';
        payment.RemitTo_ZipCode__c ='656787';
        payment.RemitTo_Address1__c ='Digha';
        payment.RemitTo_Country__c ='India';
        payment.Payment_Type__c = 'Free Material';
        
        WOD_Payment__c payment2 = WOD_TestDataFactory.createPayment('Credit_Debit','1501',claim.Id,'POL - Policy Adjustment','Claimant');
        payment2.Organization__c = 'Tavant';
        payment2.RemitTo_City__c ='Kolkata';
        payment2.RemitTo_State__c ='WB';
        payment2.RemitTo_ZipCode__c ='656787';
        payment2.RemitTo_Address1__c ='Digha';
        payment2.RemitTo_Country__c ='India';
        payment2.Payment_Type__c = 'Credit/Debit';
        payment2.Released_To_SAP__c = false;
        
        WOD_Payment__c payment3 = WOD_TestDataFactory.createPayment('Check','1501',claim.Id,'POL - Policy Adjustment','Claimant');
        payment3.Organization__c = 'Tavant';
        payment3.RemitTo_City__c ='Kolkata';
        payment3.RemitTo_State__c ='WB';
        payment3.RemitTo_ZipCode__c ='656787';
        payment3.RemitTo_Address1__c ='Digha';
        payment3.RemitTo_Country__c ='India';
        payment3.Payment_Type__c = 'Check';
        payment3.Released_To_SAP__c = false;
        payment3.Currency__c = 'USD';
        payment3.Total_Amount_Converted__c = 123;
      
        lstPayment.add(payment);
        lstPayment.add(payment2);
        lstPayment.add(payment3);
        insert lstPayment;   

        List<WOD_Payment_Line__c> lstPL = new List<WOD_Payment_Line__c>();
        WOD_Payment_Line__c pl1 = WOD_TestDataFactory.createPaymentLine(lstPayment[0].Id);
        WOD_Payment_Line__c pl2 = WOD_TestDataFactory.createPaymentLine(lstPayment[1].Id);
        WOD_Payment_Line__c pl3 = WOD_TestDataFactory.createPaymentLine(lstPayment[2].Id);
        
        lstPL.add(pl1);
        lstPL.add(pl2);
        lstPL.add(pl3);
        insert lstPL;
    }
    
   
    public static testmethod void creditDebitPaymentTest(){
        WOD_2__Claim__c claim = [Select id from WOD_2__Claim__c];
        List<WOD_Payment__c> lstPayment = [Select id from WOD_Payment__c where Payment_Type__c != 'Check'];
        List<String> lstPaymentIds = new List<String>{lstPayment[0].id,lstPayment[1].id};
            
        WOD_PaymentSummaryHandler objPaySumm = new WOD_PaymentSummaryHandler();
        WOD_PaymentSummaryHandler.getPaymentList(claim.id);
        
        WOD_PaymentSummaryHandler.queueForApprovalSelected(claim.id,lstPaymentIds);
        WOD_PaymentSummaryHandler.updatePayment(lstPaymentIds);
        
        String res = WOD_PaymentSummaryHandler.processSelected(lstPaymentIds,'Roofing');
        system.assertEquals('Credit and Debit business days not defined. Please contact Warranty Admin team', res);
        
        CreditDebit_Release_Day__c relDay = new CreditDebit_Release_Day__c();
        string todaysmonth = String.valueof(System.today().month());
        if(todaysmonth.length() == 1){
            todaysmonth = '0' + todaysmonth;
        }
        
        relDay.Year__c = String.valueof(System.today().year());
        relDay.Month__c =  todaysmonth;
        
        relDay.Date__c = String.ValueOf(Date.today().day()+5);   
        insert relDay;  
        
        String response = WOD_PaymentSummaryHandler.processSelected(lstPaymentIds,'Roofing');
        system.assertEquals('Credit and Debit payments cannot be released to SAP during the first 2 business days of the month', response);
    } 
    
    public static testmethod void checkPaymentTest(){
        List<WOD_Payment__c> lstPayment = [Select id from WOD_Payment__c where Payment_Type__c = 'Check'];
        WOD_PaymentSummaryHandler.updatePayment(new List<String>{lstPayment[0].id});
        String response = WOD_PaymentSummaryHandler.processSelected(new List<String>{lstPayment[0].id},'Roofing');
        system.assertEquals('Processed', response);
    }
    public static testmethod void getUserInfoTest(){
        Test.startTest();
        List<WOD_Payment__c> lstPayment = [Select id from WOD_Payment__c];
        WOD_PaymentSummaryHandler.getUserInfo(lstPayment[0].id);
        Test.stopTest();
    }
}