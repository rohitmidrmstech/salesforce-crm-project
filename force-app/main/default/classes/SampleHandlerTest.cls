/**
 * @description Test class for SampleHandler
*/
@isTest
public class SampleHandlerTest {
    
    /**
     * @description data set up
    */
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
        
        
        insert accs ;         
        
        
        List<Hierarchy_Ship_To_Sold_To__c> lstHSS = new List<Hierarchy_Ship_To_Sold_To__c>();
        Hierarchy_Ship_To_Sold_To__c h = new Hierarchy_Ship_To_Sold_To__c();
        h.Ship_To__c = shiptoAcc.id;
        h.Sold_To__c = soldtoAcc.id;
        h.Sales_Org__c = '1501';

        Hierarchy_Ship_To_Sold_To__c hss = new Hierarchy_Ship_To_Sold_To__c();
        hss.Sold_To__c = soldtoAcc.id;
        hss.Ship_To__c = shiptoAcc.id; 
        hss.Sales_Org__c = '1502';

        
        lstHSS.add(h);
        lstHSS.add(hss);
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
        Plants__c p1 = WOD_TestDataFactory.createPlant('test','0402');
        
        lstPlant.add(p1);
        insert lstPlant;
        
        List<WOD_Manufacturing_Plant__c> lstSapAcc = new List<WOD_Manufacturing_Plant__c>();
        WOD_Manufacturing_Plant__c plant1 = WOD_TestDataFactory.createManufacturingPlant('POL','0402','1000');
        lstSapAcc.add(plant1);
        insert lstSapAcc;
        
       
        Pitch_Cost__c pc= WOD_TestDataFactory.createPitchCost();
        insert pc;
        
        WOD_RSMeans__c rs = WOD_TestDataFactory.createRSMeans();
        insert rs;
        
        Region__c rg = new Region__c();
        rg.Name = 'test Region';
        insert rg;

        WOD_2__Claim__c claim2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim2.Plant__c = lstPlant[0].Id; 
        claim2.Plant_Code__c = '0402';
        claim2.WOD_2__Applicable_Policy__c= polDef.Id;
        claim2.State_BL__c ='Florida (FL)';
        claim2.Country_BL__c ='United States';
        claim2.WOD_2__warranty_product__c =product.Id;
        claim2.Install_Date__c =System.Today();
        claim2.State__c ='California (CA)';
        claim2.Region__c = rg.id;
        insert claim2;
    }
    
    /**
     * @description test method execution
    */
    public static testmethod void SetSampleDateTest(){
        WOD_2__Claim__c claim = [Select Id from WOD_2__Claim__c Limit 1];
        Id sampleRoofingRec = [select Id from RecordType where DeveloperName ='Roofing' and SobjectType = 'WOD_Sampling_QC__c' limit 1].Id;
        Test.startTest();
        
            List<WOD_Sampling_QC__c> insertSamplelst = new List<WOD_Sampling_QC__c>();
        	WOD_Sampling_QC__c sample = null;
            for(Integer i = 1;i <= 2;i++){
                sample = new WOD_Sampling_QC__c();
                sample.Claim__c = claim.id;
                sample.RecordTypeId = sampleRoofingRec;
                sample.Samples_Received_Date__c = system.today().addDays(i);
                insertSamplelst.add(sample);
            }
            insert insertSamplelst;
        
        Test.stopTest();
    }

}