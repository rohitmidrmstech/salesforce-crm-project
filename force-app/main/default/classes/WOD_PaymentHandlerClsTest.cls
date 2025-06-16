@isTest
public class WOD_PaymentHandlerClsTest {
   
    @TestSetup  
    private static void testDataSetup() {
        insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx',
            Order_Endpoint__c='http://sap-wddev.certainteed.com/qa/WarrantyOrder',
            Siding_Customer_Price_Endpoint__c ='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest'
        );
        List<Account> accs = new List<Account>();
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        accs.add(acc);
        
        Id recTypeIdShipTo = [select Id from RecordType where DeveloperName ='Ship_to' and SobjectType = 'Account' limit 1].Id;
        Account shiptoAcc = WOD_TestDataFactory.createAccount('Shipto','','Customer');
        shiptoAcc.recordTypeId =recTypeIdShipTo;
        shiptoAcc.LOB__c ='1502';
        shiptoAcc.Status__c ='Active';
        accs.add(shiptoAcc);
        
        Id recTypeIdSoldTo = [select Id from RecordType where DeveloperName ='Sold_to' and SobjectType = 'Account' limit 1].Id;
        String accName = Date.today()+'shipTo';
        Account soldtoAcc = WOD_TestDataFactory.createAccount(accName,'','Customer');
        soldtoAcc.recordTypeId =recTypeIdSoldTo;
        soldtoAcc.LOB__c ='1502';
        soldtoAcc.Status__c ='Active';
        accs.add(soldtoAcc);
        
        
        Account shiptoAcc2 = WOD_TestDataFactory.createAccount('ShiptoAccount2','','Customer');
        shiptoAcc2.recordTypeId =recTypeIdShipTo;
        shiptoAcc2.LOB__c ='1501';
        shiptoAcc2.Status__c ='Active';
        accs.add(shiptoAcc2);
        //insert shiptoAcc2;
        
        Account soldtoAcc2 = WOD_TestDataFactory.createAccount('sold2Acc23','','Customer');
        soldtoAcc2.recordTypeId =recTypeIdSoldTo;
        soldtoAcc2.LOB__c ='1501';
        soldtoAcc2.Status__c ='Active';
        accs.add(soldtoAcc2);
        //insert soldtoAcc2;
        insert accs ; 
        
        for(Account ac : [SELECT id, Name,recordTypeId  from Account limit 1000 ]){
           if(ac.Name =='Shipto' ) shiptoAcc.id = ac.Id;
           else if(ac.Name == accName )soldtoAcc.Id = ac.id;
           else if(ac.Name == 'ShiptoAccount2')shiptoAcc2.Id = ac.id;
           else if (ac.Name =='sold2Acc23' )soldtoAcc2.id = ac.id;
           else acc.id = ac.id;
        
        }
        
        
        
        List<Hierarchy_Ship_To_Sold_To__c> lstHSS = new List<Hierarchy_Ship_To_Sold_To__c>();
        Hierarchy_Ship_To_Sold_To__c h = new Hierarchy_Ship_To_Sold_To__c();
        h.Ship_To__c = shiptoAcc.id;
        h.Sold_To__c = soldtoAcc.id;
        h.Sales_Org__c = '1501';

        Hierarchy_Ship_To_Sold_To__c hss = new Hierarchy_Ship_To_Sold_To__c();
        hss.Sold_To__c = soldtoAcc.id;
        hss.Ship_To__c = shiptoAcc.id; 
        hss.Sales_Org__c = '1502';
       
        Hierarchy_Ship_To_Sold_To__c h2 = new Hierarchy_Ship_To_Sold_To__c();
        h2.Ship_To__c = shiptoAcc2.id;
        h2.Sold_To__c = soldtoAcc2.id;
        h2.Sales_Org__c = '1501';
        
        lstHSS.add(h);
        lstHSS.add(hss);
        lstHSS.add(h2);
        insert lstHSS;
        
        
        
        Product_Type__c productType= WOD_TestDataFactory.createProductType();
        insert productType;
        
        WOD_2__Policy_Definition__c polDef = WOD_TestDataFactory.createPolicyDefination();
        insert polDef;
        
        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('000000000000619565','000000000000619565',true,'Non-Serialized','Item','Machine','Hours');
        product.Product_Type__c =productType.Id;
         product.Product_Line__c = 'test';
        insert product;
        
        List<Plants__c> lstPlant = new List<Plants__c>();
        Plants__c p1 = WOD_TestDataFactory.createPlant('test','aaaa');
        Plants__c p2 = WOD_TestDataFactory.createPlant('testPlant','0402');
        
        lstPlant.add(p1);
        lstPlant.add(p2);
        insert lstPlant;
        
        List<WOD_Manufacturing_Plant__c> lstSapAcc = new List<WOD_Manufacturing_Plant__c>();
        WOD_Manufacturing_Plant__c plant1 = WOD_TestDataFactory.createManufacturingPlant('POL','aaaa','1000');
        WOD_Manufacturing_Plant__c plant2 = WOD_TestDataFactory.createManufacturingPlant('WAR','0402','1000');
        WOD_Manufacturing_Plant__c plant3 = WOD_TestDataFactory.createManufacturingPlant('MTL','0402','1000');
        plant2.Divison_Code__c = 'test';
        plant3.Divison_Code__c = 'test';
        lstSapAcc.add(plant1);
        lstSapAcc.add(plant2);
        lstSapAcc.add(plant3);
        insert lstSapAcc;
        
       
        Pitch_Cost__c pc= WOD_TestDataFactory.createPitchCost();
        insert pc;
        
        WOD_RSMeans__c rs = WOD_TestDataFactory.createRSMeans();
        insert rs;
        
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim.Plant_Code__c = 'aaaa';
        claim.Plant__c = lstPlant[0].Id; 
        claim.WOD_2__Applicable_Policy__c= polDef.Id;
        claim.State_BL__c ='Florida (FL)';
        claim.Country_BL__c ='United States';
        claim.WOD_2__warranty_product__c =product.Id;
        claim.Install_Date__c =System.Today();
        claim.Business_Units__c='Roofing';
        claim.Division_Code__c='Residential';
        insert claim;
        
        Region__c rg = new Region__c();
        rg.Name = 'test Region';
        insert rg;

        WOD_2__Claim__c claim2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Siding');
        claim2.Plant__c = lstPlant[1].Id; 
        claim2.Plant_Code__c = '0402';
        claim2.WOD_2__Applicable_Policy__c= polDef.Id;
        claim2.State_BL__c ='Florida (FL)';
        claim2.Country_BL__c ='United States';
        claim2.WOD_2__warranty_product__c =product.Id;
        claim2.Install_Date__c =System.Today();
        claim2.State__c ='California (CA)';
        claim2.Region__c = rg.id;
        claim2.Business_Units__c='Siding';
        claim2.Division_Code__c='Fiber Cement';
        insert claim2;
        
        WOD_2__Claim__c claimCanada = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claimCanada.Plant__c = lstPlant[1].Id; 
        claimCanada.Plant_Code__c = '0402';
        claimCanada.WOD_2__Applicable_Policy__c= polDef.Id;
        claimCanada.Postal_Code_BL__c='V2R 5V1';
        claimCanada.City_BL__c='Beauharnois';
        claimCanada.State_BL__c ='British Columbia (BC)';
        claimCanada.Country_BL__c ='Canada';
        claimCanada.WOD_2__warranty_product__c =product.Id;
        claimCanada.Install_Date__c =System.Today();
        claimCanada.Division_Code__c='Metal Roofing';
        claimCanada.Business_Units__c='Roofing';
       // claimCanada.State__c ='Quebec (QC)';
        claimCanada.Region__c = rg.id;
        insert claimCanada;
        
        Id sampleRoofingRec = [select Id from RecordType where DeveloperName ='Siding' and SobjectType = 'WOD_Sampling_QC__c' limit 1].Id;
        
        WOD_Sampling_QC__c sam = new WOD_Sampling_QC__c();
        sam.Claim__c = claim2.id;
        sam.RecordTypeId = sampleRoofingRec;
        insert sam;
        
        List<WOD_Claim_Interested_Parties__c> cipList = new List<WOD_Claim_Interested_Parties__c>();
        
        WOD_Claim_Interested_Parties__c cip=new WOD_Claim_Interested_Parties__c();
        cip.Business_Units__c='Siding';
        cip.Address_1__c='Test';
        cip.City__c='Test';
        cip.Claim__c=claim2.Id;
        cip.Country__c='United States';
        cip.State__c='Florida (FL)';
        cip.Zip_Code__c='12345';
        cip.Type__c='Builder';
        ciplist.add(cip);
        
        
        cip=new WOD_Claim_Interested_Parties__c();
        cip.Business_Units__c='Roofing';
        cip.Address_1__c='Test';
        cip.City__c='Test';
        cip.Claim__c=claim.Id;
        cip.Country__c='United States';
        cip.State__c='Florida (FL)';
        cip.Zip_Code__c='12345';
        cip.Type__c='Builder';
        ciplist.add(cip);
        
        
        cip=new WOD_Claim_Interested_Parties__c();
        cip.Business_Units__c='Roofing';
        cip.Address_1__c='Test';
        cip.City__c='Test';
        cip.Claim__c=claimCanada.Id;
        cip.Country__c='United States';
        cip.State__c='Florida (FL)';
        cip.Zip_Code__c='12345';
        cip.Type__c='Builder';
        ciplist.add(cip);
        insert cipList;
            
    
        List<WOD_Payment__c> lstPay = new List<WOD_Payment__c>();
        WOD_Payment__c pay1 = WOD_TestDataFactory.createPayment('Credit_Debit','1501',claim.Id,'POL - Policy Adjustment','Claimant');
        pay1.Organization__c = 'Tavant1';
        pay1.RemitTo_City__c ='Kolkata1';
        pay1.RemitTo_State__c ='test state';
        pay1.RemitTo_ZipCode__c ='12345';
        pay1.RemitTo_Address1__c ='test';
        pay1.RemitTo_Country__c ='India';
        pay1.Ship_To__c = shiptoAcc2.id;
        pay1.Currency__c='USD';
        pay1.Sold_to_Hierarchy__c = h2.id;
 
        WOD_Payment__c pay2 = WOD_TestDataFactory.createPayment('Check','1502',claim2.Id,'MTL - Free Material Settlement','Builder');
        pay2.Organization__c = 'Tavant2';
        pay2.RemitTo_City__c ='Kolkata';
        pay2.RemitTo_State__c ='WB';
        pay2.RemitTo_ZipCode__c ='656787';
        pay2.RemitTo_Address1__c ='Digha2';
        pay2.RemitTo_Country__c ='Bahrain';
        pay2.Ship_To__c = shiptoAcc.id;
        pay2.Sold_To__c = soldtoAcc.id;
        pay2.Sold_to_Hierarchy__c = hss.id;
        pay2.Currency__c='USD';
        pay2.Sample__c  = sam.id;
        
        pay2.SAP_Accounts__c = lstSapAcc[1].id;
       
        pay2.Comments__c = 'test Comment to be included on pyaments. Please amke sure ths is alway sresent on the Payment and Claim, please please make sure, Also have a good day ';

        WOD_Payment__c pay3 = WOD_TestDataFactory.createPayment('Gelco','1501',claim.Id,'POL - Policy Adjustment','Claimant');
        pay3.Total_Amount_Converted__c = 123;
        pay3.RemitTo_FirstName__c ='testF';
        pay3.RemitTo_LastName__c ='testL';
        pay3.RemitTo_City__c ='Kolkata';
        pay3.RemitTo_State__c ='AB';
        pay3.RemitTo_ZipCode__c ='12345';
        pay3.RemitTo_Address1__c ='Digha23';
        pay3.RemitTo_Country__c ='Bahrain';
        pay3.Currency__c='USD';
        
        lstPay.add(pay2);
        lstPay.add(pay1);
        lstPay.add(pay3);
        insert lstPay;

        WOD_Payment_Line__c pl = WOD_TestDataFactory.createPaymentLine(lstPay[0].Id);
        pl.Warranty_Product__c = product.id;
        pl.Quantity__c = 1;
        pl.UOM__c = 'SQ';
        pl.Amount_Converted__c= 12;
        pl.Amount__c = 10;
        insert pl;
        
        
    }
    /**
     * @description test method execution
    */
    public static testmethod void paymentHandlerMethod(){
        Test.startTest();
        /*
        insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx'
        );
        */
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c];
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<String> paymnetIds = new List<String>{lstPay[0].id};
            
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.SIDINGPRICECALL));
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.ROOFINGAREAPRICECALLSUCCESS));
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.roofingCustomerPriceCallSuccess));
        WOD_PaymentHandlerCls.getAmountCheckCost('2ND','Material','packageRecordType',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        //  WOD_PaymentHandlerCls.getAmountCheckCost('MTL','setBasis','packageRecordType',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        // WOD_PaymentHandlerCls.getAmountCheckCost('RSM','setBasis','packageRecordType',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        
          WOD_PaymentHandlerCls.savePayment(lstPayLine[0],'WAR');
        List<Id> claimids=new List<Id>();
        for(WOD_2__Claim__c claim:lstClaim){
           claimids.add(claim.id); 
        }
        WOD_ClaimTriggerHandler.updateOldestPaymentdateOnClaim(claimids);
        
       
        delete lstPay[0];
        
        Test.stopTest();
    }
    
    public static testmethod void getpaymentCostMTL(){
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        //List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c];
        //List<WOD_2__Claim__c> clmListCanada = [Select id from WOD_2__Claim__c WHERE  Country_BL__c = 'Canada'];
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<String> paymnetIds = new List<String>{lstPay[0].id};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.roofingCustomerPriceCallSuccess));    
        //Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.SIDINGPRICECALL));
        
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.ROOFINGAREAPRICECALLSUCCESS));
        WOD_PaymentHandlerCls.getAmountCheckCost('MTL','Material','Check',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        WOD_PaymentHandlerCls.getAmountCheckCost('RSM','Material','Check',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
       // WOD_PaymentHandlerCls.getAmountCheckCost('RSM','Material','Check',clmListCanada[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        // WOD_PaymentHandlerCls.getAmountCheckCost('RSM','setBasis','packageRecordType',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
       // WOD_PaymentHandlerCls.getAmountCreditDebit('WAR','Material','Credit/Debit',lstClaim[0].Id,lstPay[0].Id,product.Id,false);
        
        Test.stopTest();
        
    }
     /**
     * @description test method execution
    */
    public static testmethod void getpaymentCostMTL2(){
        /*
        insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx',
            Siding_Customer_Price_Endpoint__c ='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest'
        );
        */
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        //List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c];
        //List<WOD_2__Claim__c> clmListCanada = [Select id from WOD_2__Claim__c WHERE  Country_BL__c = 'Canada'];
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<String> paymnetIds = new List<String>{lstPay[0].id};
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.roofingCustomerPriceCallSuccess));    
        //Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.SIDINGPRICECALL));
        
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.ROOFINGAREAPRICECALLSUCCESS));
       // WOD_PaymentHandlerCls.getAmountCheckCost('RSM','Material','Check',clmListCanada[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        // WOD_PaymentHandlerCls.getAmountCheckCost('RSM','setBasis','packageRecordType',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        WOD_PaymentHandlerCls.getAmountCreditDebit('WAR','Material','Credit/Debit',lstClaim[0].Id,lstPay[0].Id,product.Id,false);
        
        Test.stopTest();
        
    }
    
    /**
     * @description test method execution
    */
    public static testmethod void getpaymentCostPriceOnLoad(){
        Test.startTest();
        Pitch_Cost__c p =new Pitch_Cost__c(Cost_per_Square__c= 12, Pitch_of_Roof__c=2, Settlement_Type__c = 'ALG');
        Pitch_Cost__c p1 =new Pitch_Cost__c(Cost_per_Square__c= 12, Pitch_of_Roof__c=2, Settlement_Type__c = 'HAN');
        insert p;
        insert p1;
        WOD_PaymentHandlerCls.hasRecordCreateAccess('WOD_2__Claim__c');
        /*
        insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx'
        );
        */
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c];
        //WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<String> paymnetIds = new List<String>{lstPay[0].id};
            
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.roofingCustomerPriceCallSuccess));    
        //Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.SIDINGPRICECALL));
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.ROOFINGAREAPRICECALLSUCCESS));
        WOD_PaymentHandlerCls.getPriceOnLoad('PRS',lstClaim[0].Id);
        WOD_PaymentHandlerCls.getPriceOnLoad('WAR',lstClaim[0].Id);
        WOD_PaymentHandlerCls.getPriceOnLoad('RCW',lstClaim[0].Id);
        WOD_PaymentHandlerCls.fetchPaymentForURL(lstPay[0].id);
        WOD_PaymentHandlerCls.fetchPaymentForURL(lstPayLine[0].Id);
        WOD_PaymentHandlerCls.getPitchCost(2, 'ALG');
        WOD_PaymentHandlerCls.getPitchCost(2, 'HAN');
        
        //WOD_PaymentHandlerCls.getAmountCheckCost('MTL','Material','Check',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        //WOD_PaymentHandlerCls.getAmountCheckCost('RSM','Material','Check',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        // WOD_PaymentHandlerCls.getAmountCheckCost('RSM','setBasis','packageRecordType',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        
        
        Test.stopTest();
        //WOD_PaymentHandlerCls.getAmountCreditDebit('WAR','Material','Credit/Debit',lstClaim[0].Id,lstPay[0].Id,product.Id,false);
    }

    public static testmethod void getpaymentCostSiding(){
        /*
        insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx',
            Siding_Customer_Price_Endpoint__c ='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest'
        );
        */
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        //List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c WHERE Business_Units__c = 'Siding'];
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<String> paymnetIds = new List<String>{lstPay[0].id};
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.roofingCustomerPriceCallSuccess));    
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.SIDINGPRICECALL));
        //Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.ROOFINGAREAPRICECALLSUCCESS));
        WOD_PaymentHandlerCls.getAmountCheckCostForSiding('Material',lstClaim[0].Id,lstPay[0].Id,product.Id,true,false,false,false);
        //WOD_PaymentHandlerCls.getAmountCheckCost('RSM','Material','Check',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        // WOD_PaymentHandlerCls.getAmountCheckCost('RSM','setBasis','packageRecordType',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        /*
        WOD_PaymentHandlerCls.getAmountCostForSiding('Material',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        WOD_PaymentHandlerCls.getAmountCostForSiding('Labor',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        
        
        WOD_PaymentHandlerCls.getAmountCreditDebit('WAR','Material','Credit/Debit',lstClaim[0].Id,lstPay[0].Id,product.Id,false);
        
        
        WOD_PaymentHandlerCls.getAmountCheckCostForSiding('Labor',lstClaim[0].Id,lstPay[0].Id,product.Id,true,false,false,false);
        */
        Test.stopTest();
    }    
    
    public static testmethod void getpaymentCostSiding2(){
        /*
        insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx',
            Siding_Customer_Price_Endpoint__c ='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest'
        );
        */
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        //List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c WHERE Business_Units__c = 'Siding'];
        //List<WOD_2__Claim__c> clmListCanada = [Select id from WOD_2__Claim__c WHERE Country_BL__c = 'Canada'];
        lstClaim[0].Postal_Code_BL__c = '32211';
        lstClaim[0].City_BL__c = 'Jacksonville';
        lstClaim[0].Country_BL__c = 'United States';
        lstClaim[0].State_BL__c = 'Florida (FL)';
        lstClaim[0].Address_1_BL__c = '5353 Oak Forest Dr';
        //update lstClaim[0];
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<String> paymnetIds = new List<String>{lstPay[0].id};
        
        Test.startTest();
        //Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.roofingCustomerPriceCallSuccess));    
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.SIDINGPRICECALL));
        WOD_PaymentHandlerCls.getAmountCostForSiding('Material',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        //WOD_PaymentHandlerCls.getAmountCostForSiding('Labor',lstClaim[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
       // WOD_PaymentHandlerCls.getAmountCheckCost('RSM','setBasis','packageRecordType',clmListCanada[0].Id,lstPay[0].Id,product.Id,false,false,false,false);
        Test.stopTest();
        //WOD_PaymentHandlerCls.getAmountCreditDebit('WAR','Material','Credit/Debit',lstClaim[0].Id,lstPay[0].Id,product.Id,false);
        
        
        //WOD_PaymentHandlerCls.getAmountCheckCostForSiding('Labor',lstClaim[0].Id,lstPay[0].Id,product.Id,true,false,false,false);
    }    
     public static testmethod void getpaymentCostSidingError(){
        Test.startTest();
         /*
        insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx'
        );
        */        
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        //List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c WHERE Business_Units__c = 'Siding'];
        
        lstClaim[0].Postal_Code_BL__c = '94103';
        lstClaim[0].City_BL__c = 'San Francisco';
        update lstClaim[0];
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<String> paymnetIds = new List<String>{lstPay[0].id};
       
        try{
        //Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.roofingCustomerPriceCallSuccess));    
        Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.SIDINGPRICECALL));
        //Test.setMock(HttpCalloutMock.class, new WOD_WSMockResponse(WOD_WSMockResponse.Type.ROOFINGAREAPRICECALLSUCCESS));
        WOD_PaymentHandlerCls.getAmountCostForSiding('Material',lstClaim[0].Id,lstPay[0].Id,product.Id,true,false,false,false);
        WOD_PaymentHandlerCls.getAmountCostForSiding('Labor',lstClaim[0].Id,lstPay[0].Id,product.Id,true,false,false,false);
        
        }
        catch(Exception ex){
        }
        Test.stopTest();
        //WOD_PaymentHandlerCls.getAmountCreditDebit('WAR','Material','Credit/Debit',lstClaim[0].Id,lstPay[0].Id,product.Id,false);
        
        //WOD_PaymentHandlerCls.getAmountCheckCostForSiding('Labor',lstClaim[0].Id,lstPay[0].Id,product.Id,true,false,false,false);
    }    
        /**
     * @description test method execution
    */
    public static testmethod void queueApproval(){
        Test.startTest();
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        //List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c];
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        
        List<String> paymnetIds = new List<String>{lstPay[0].id};
        WOD_PaymentHandlerCls.getProductDescription('Credit/Debit',product.id);
        WOD_PaymentHandlerCls.getProductDescription('Free Material',product.id);
        WOD_ClaimQuickActionController.ResponseWrapper createAccessRes = new WOD_ClaimQuickActionController.ResponseWrapper();
        createAccessRes =  WOD_ClaimQuickActionController.hasRecordCreateAccess('WOD_Payment_Line__c');
        system.assertEquals('true', createAccessRes.data); 
      //  WOD_PaymentHandlerCls.getAmountCostForSiding('Material',lstClaim[0].id,lstPay[0].id,product.id,true,true,true,true);
      //  WOD_PaymentHandlerCls.getAmountCheckCostForSiding('Material',lstClaim[0].id,lstPay[0].id,product.id,true,true,true,true);
     //   WOD_PaymentHandlerCls.getAmountCreditDebit('PRS','Material','Credit/Debit',lstClaim[0].id,lstPay[0].id,product.id,true);
        WOD_PaymentHandlerCls.listOfMaterialCode(lstPay[0].id);
        WOD_PaymentHandlerCls.deletePaymentLineLst(lstPayLine);
        Test.stopTest();
    }
    
    /**
* @description test method execution
*/
    public static testmethod void paymentManagerTest(){
        Test.startTest();
        //WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c];
        //Account shipToAcc = [Select id from account where recordtype.Name = 'Ship-To' LIMIT 1];
        //Account soldToAcc = [Select id from account where recordtype.Name = 'Sold-To' LIMIT 1];
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        WOD_PaymentManager.GetReleasorClassActionCost(lstClaim[0].id);
        WOD_PaymentManager.GetTransferClassActionCost(lstClaim[0].id);
        WOD_PaymentManager.SendOrderToSAP(lstPay[0].id);

        update lstPay[1];
        Test.stopTest();

    }
    
    public static testmethod void paymentManagerTestRlsTOSAP(){
       Test.startTest();
        /*
       insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx',
            Order_Endpoint__c='http://sap-wddev.certainteed.com/qa/WarrantyOrder'
        );
        */
        //WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c];
        //Account shipToAcc = [Select id from account where recordtype.Name = 'Ship-To' LIMIT 1];
       // Account soldToAcc = [Select id from account where recordtype.Name = 'Sold-To' LIMIT 1];
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        lstPay[0].Payment_Type__c= 'Credit/Debit';
        lstPay[0].Order_Reason__c = 'Z48 - Warranty Credit';
        update lstPay[0];
        WOD_PaymentManager.GetReleasorClassActionCost(lstClaim[0].id);
        WOD_PaymentManager.GetTransferClassActionCost(lstClaim[0].id);
        //WOD_PaymentManager.GetMaterialPrice(true,product.id,'aaaa',shipToAcc.Id,soldToAcc.id,lstPay[0].id);
        WOD_PaymentManager.SendOrderToSAP(lstPay[0].id);
        Test.stopTest();

    }
    public static testmethod void paymentManagerTestRlsTOSAPFM(){
       Test.startTest();
        /*
       insert new WSDefaults__c(
            Customer_Price_Endpoint__c='http://sap-wddev.certainteed.com/sap/qa/RPGSFDCPricingRequest',
            Area_Price_Endpoint__c='http://sap-wddev.certainteed.com/Prod_Price_Area_Pricing/PriceAreaPricing.asmx',
            Order_Endpoint__c='http://sap-wddev.certainteed.com/qa/WarrantyOrder'
        );
        */
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c];
        //Account shipToAcc = [Select id from account where recordtype.Name = 'Ship-To' LIMIT 1];
       // Account soldToAcc = [Select id from account where recordtype.Name = 'Sold-To' LIMIT 1];
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        lstPay[0].Payment_Type__c= 'Free Material';
        lstPay[0].Order_Type__c = 'Credit Memo';
        lstPay[0].Order_Reason__c = 'Z48 - Warranty Credit';
        lstPay[0].Shipping_Condition__c='Z2 - Less than Truckload';
        update lstPay[0];
        
         WOD_Payment_Line__c pl = WOD_TestDataFactory.createPaymentLine(lstPay[0].Id);
        pl.Warranty_Product__c = product.id;
        pl.Quantity__c = 1;
        pl.UOM__c = 'SQ';
        pl.Amount_Converted__c= 12;
        pl.Amount__c = 10;
        //pl.Material_Code__c='POLICY ALLOW -TRIM';
        insert pl;
        
        WOD_PaymentManager.GetReleasorClassActionCost(lstClaim[0].id);
        WOD_PaymentManager.GetTransferClassActionCost(lstClaim[0].id);
        //WOD_PaymentManager.GetMaterialPrice(true,product.id,'aaaa',shipToAcc.Id,soldToAcc.id,lstPay[0].id);
        WOD_PaymentManager.SendOrderToSAP(lstPay[0].id);
        Test.stopTest();

    }
    public static testmethod void paymentInfoTest(){
        Test.startTest();
        List<WOD_Payment__c> lstPay = [Select id from WOD_Payment__c];
        List<WOD_Payment_Line__c> lstPayLine = [Select id,Payment__c from WOD_Payment_Line__c];
        WOD_PaymentHandlerCls.getPaymentLineLst(lstPayLine[0].Id);
        WOD_PaymentHandlerCls.getPaymentDetial(lstPay[0].Id);
        WOD_PaymentHandlerCls.getPaymentFromPLId(lstPayLine[0].Id);
        WOD_PaymentHandlerCls.getProductDescription('Test',null);
        
        List<WOD_Payment_Line__c> lstPayLine2 = [Select id,Payment__c from WOD_Payment_Line__c];
        List<WOD_Payment__c> lstPay2 = [Select id from WOD_Payment__c Where Id =: lstPayLine2[0].Payment__c];
        lstPay2[0].Void_WOD_Payment__c=true;
        lstPay2[0].Released_To_SAP__c=true;
        try{
            update lstPay2;
            update lstPayLine2;
        }catch(Exception ex){
            
        }
       Account acc =[SELECT id, name from Account where WOD_2__Warranty_Account_Type__c='Customer' limit 1];
        acc.recordtypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('Warranty Account').getRecordTypeId();
        acc.Name = 'test,test,CAlifornia(CA),94103';
        update acc;
        Test.stopTest();
        
    }
    
}