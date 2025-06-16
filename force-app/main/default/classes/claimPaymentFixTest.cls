@isTest
public class claimPaymentFixTest {
   
   public static testmethod void testDataSetup() { 
        
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
        
      
        Hierarchy_Ship_To_Sold_To__c h2 = new Hierarchy_Ship_To_Sold_To__c();
        h2.Ship_To__c = shiptoAcc2.id;
        h2.Sold_To__c = soldtoAcc2.id;
        h2.Sales_Org__c = '1501';
        
        lstHSS.add(h);
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
        plant2.Divison_Code__c = 'test';
        lstSapAcc.add(plant1);
        lstSapAcc.add(plant2);
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
        insert claim;
        
        Region__c rg = new Region__c();
        rg.Name = 'test Region';
        insert rg;
        
       
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
        // claimCanada.State__c ='Quebec (QC)';
        claimCanada.Region__c = rg.id;
        insert claimCanada;
        
      
        
        
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
        
      
        lstPay.add(pay1);
        lstPay.add(pay3);
        insert lstPay;
        Test.startTest();
        claimPaymentFix cpf = new claimPaymentFix();
        Database.QueryLocator ql = cpf.start(null);
        cpf.execute(null,lstPay);
        cpf.Finish(null);
        Test.stopTest();
    }
   
}