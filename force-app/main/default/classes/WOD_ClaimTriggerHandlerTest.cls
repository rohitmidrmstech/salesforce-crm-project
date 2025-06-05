/**
 * @description Test class of trigger handler WOD_ClaimTriggerHandler
*/
@isTest
public class WOD_ClaimTriggerHandlerTest {
    /**
     * @description method to execute test coverage
    */
    public static testmethod void claimHandlerMethod(){
        List<Id> listClaimId = new List<Id>();
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim.Payment_Date__c = System.today();
        insert claim;
        listClaimId.add(claim.Id);
        WOD_ClaimTriggerHandler.updateOldestPaymentdateOnClaim(listClaimId);
         Profile p = [SELECT Id FROM Profile WHERE Name='Warranty Admin Roofing' limit 1]; 
         User u = new User(Alias = 'standt', Email='testcasemanager@bcinsourcing.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, Sales_Org__c='1501',User_Territory_Code__c='TC0457',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testcasemanager@bcinsourcing.com');
        
         insert  u;
        
        claim.OwnerId=u.id;
        update claim;
        
        Product_Type__c productType= WOD_TestDataFactory.createProductType();
        insert productType;
        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        product.Product_Type__c =productType.Id;
        product.Item_Class__c='90';
        insert product;
        
        Territory__c t = new Territory__c();
        t.Name ='WarrantyGroup_Tavant';
        t.Territory_Code__c ='WarrantyGroup_a12345';
        insert t;

        List<WOD_2__Claim__c> claimsList = new List<WOD_2__Claim__c>();
       
       WOD_2__Claim__c claim1 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Siding');
        claim1.Payment_Date__c = System.today();
            Territory__c t1 = new Territory__c();
            t1.Name ='WarrantyGroup_Tavant';
            t1.Territory_Code__c ='WarrantyGroup_a12345';
            insert t1;
        claim1.Territory__c = t1.Id;
        claim1.Country_BL__c ='United States';
        claim1.Business_Units__c ='Siding'; 
        claim1.WOD_2__Warranty_Product__c=product.id;
        claim1.Customer__c=acc.id;
        claim1.Division_Code__c='Fiber Cement';
        //insert claim1;
        claimsList.add(claim1);
        
        WOD_2__Claim__c claim2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim2.Payment_Date__c = System.today();
        claim2.Territory__c = t1.Id;
        claim2.Country_BL__c ='United States';
        claim2.Business_Units__c ='Roofing'; 
        claim2.WOD_2__Warranty_Product__c=product.id;
        claim2.Customer__c=acc.id;
        claim2.Business_Units__c='Roofing';
        claim2.Division_Code__c='Residential';
        //insert claim2;
        claimsList.add(claim2);
        
        
        WOD_2__Claim__c claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Roofing';
        claim3.Division_Code__c='Residential';
        //insert claim2;
        claimsList.add(claim3);
        
        
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Solar Solutions');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Solar Solutions';
        claim3.Division_Code__c='Solar';
        //insert claim2;
        claimsList.add(claim3);
        
        //4
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Commercial Building & Infrastructure');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Commercial Building & Infrastructure';
        claim3.Division_Code__c='Commercial';
        //insert claim2;
        claimsList.add(claim3);
        
        
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Commercial Building & Infrastructure');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Commercial Building & Infrastructure';
        claim3.Division_Code__c='SBM Commercial WP';
        //insert claim2;
        claimsList.add(claim3);
        
        
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Commercial Building & Infrastructure');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Commercial Building & Infrastructure';
        claim3.Division_Code__c='SBM Fireproofing';
        //insert claim2;
        claimsList.add(claim3);
        
        //7
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Commercial Building & Infrastructure');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Commercial Building & Infrastructure';
        claim3.Division_Code__c='Commercial';
        //insert claim2;
        claimsList.add(claim3);
        
        WOD_2__Claim__c claim4 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Siding');
        claim1.Payment_Date__c = System.today();
            Territory__c t4 = new Territory__c();
            t4.Name ='WarrantyGroup_Tavant';
            t4.Territory_Code__c ='WarrantyGroup_a12345';
            insert t4;
        claim4.Territory__c = t4.Id;
        claim4.Country_BL__c ='Canada';
        claim4.Business_Units__c ='Siding'; 
        claim4.WOD_2__Warranty_Product__c=product.id;
        claim4.Customer__c=acc.id;
        claim4.Division_Code__c='SPG Norandex Siding';
        //insert claim1;
        claimsList.add(claim4);
       // h.onBeforeUpdate(listClaimId,oldMap);   
       // h.onBeforeUpdate(listClaimId,oldMap);       
        insert claimslist;

        claimslist[0].Division_code__c ='Windows';
        claimslist[1].Division_code__c ='Symphony';
        claimslist[2].Division_code__c ='Metal Roofing';
        //claimslist[3].Division_code__c ='Windows';
        claimslist[4].Division_code__c ='CBI Deneef';
        claimslist[5].Division_code__c ='CBI Deneef';
        claimslist[6].Division_code__c ='CBI Deneef';
        claimslist[7].Division_code__c ='SBM Infrastructure';
        
        update claimslist;
    }
    /**
     * @description method to execute test coverage
    */
   public static testmethod void claimHandlerMethod2(){
        List<WOD_2__Claim__c> listClaimId = new List<WOD_2__Claim__c>();
        Map<Id, WOD_2__Claim__c> oldMap = new Map<Id, WOD_2__Claim__c>();
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        Product_Type__c productType= WOD_TestDataFactory.createProductType();
        insert productType;
        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        product.Product_Type__c =productType.Id;
        product.Item_Class__c='90';
        insert product;
        WOD_Manufacturing_Plant__c plant1 = WOD_TestDataFactory.createManufacturingPlant('POL','aaaa','1000');
        insert plant1;
        List<Account> accs = new List<Account>();
        Id recTypeIdSoldTo = [select Id from RecordType where DeveloperName ='Sold_to' and SobjectType = 'Account' limit 1].Id;
        Id recTypeIdShipTo = [select Id from RecordType where DeveloperName ='Ship_to' and SobjectType = 'Account' limit 1].Id;
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
       
       Hierarchy_Ship_To_Sold_To__c h2 = new Hierarchy_Ship_To_Sold_To__c();
        h2.Ship_To__c = shiptoAcc2.id;
        h2.Sold_To__c = soldtoAcc2.id;
        h2.Sales_Org__c = '1501';
       insert h2;
        
       
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim.Payment_Date__c = System.today();
            Territory__c t = new Territory__c();
            t.Name ='WarrantyGroup_Tavant';
            t.Territory_Code__c ='WarrantyGroup_a12345';
            insert t;
        claim.Territory__c = t.Id;
        claim.Country_BL__c ='United States';
        claim.Business_Units__c ='Roofing'; 
        claim.WOD_2__Warranty_Product__c=product.id;
        claim.Customer__c=acc.id;
        claim.Business_Units__c='Roofing';
        claim.Division_Code__c='Residential';
        insert claim;
       
       WOD_Payment__c pay1 = WOD_TestDataFactory.createPayment('Credit_Debit','1501',claim.Id,'POL - Policy Adjustment','Claimant');
        pay1.Ship_Credit_Debit_Date__c='11/11/2024';
        pay1.Organization__c = 'Tavant1';
        pay1.RemitTo_City__c ='Kolkata1';
        pay1.RemitTo_State__c ='test state';
        pay1.RemitTo_ZipCode__c ='12345';
        pay1.RemitTo_Address1__c ='test';
        pay1.RemitTo_Country__c ='India';
        pay1.Ship_To__c = shiptoAcc2.id;
        pay1.Sold_To__c = soldtoAcc2.id;
        pay1.Currency__c='USD';
        pay1.Sold_to_Hierarchy__c = h2.id;
        insert pay1;

        update pay1;
       
        listClaimId.add(claim);        
        Territory__c t2 = new Territory__c();
        t2.Name ='WarrantyGroup_Tavant';
        t2.Territory_Code__c ='WarrantyGroup_a12';
        insert t2;
        claim.Territory__c = t2.Id;
        claim.WOD_2__Warranty_Product__c = null;
        update claim; 
        claim.WOD_2__Warranty_Product__c = product.id;
        update claim;
        oldMap.put(claim.Id,claim);
        WOD_ClaimTriggerHandler h = new WOD_ClaimTriggerHandler();
       
       List<WOD_2__Claim__c> claimsList = new List<WOD_2__Claim__c>();
       
       WOD_2__Claim__c claim1 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Siding');
        claim1.Payment_Date__c = System.today();
            Territory__c t1 = new Territory__c();
            t1.Name ='WarrantyGroup_Tavant';
            t1.Territory_Code__c ='WarrantyGroup_a12345';
            insert t1;
        claim1.Territory__c = t1.Id;
        claim1.Country_BL__c ='United States';
        claim1.Business_Units__c ='Siding'; 
        claim1.WOD_2__Warranty_Product__c=product.id;
        claim1.Customer__c=acc.id;
        claim1.Division_Code__c='Fiber Cement';
        //insert claim1;
        claimsList.add(claim1);
        
        WOD_2__Claim__c claim2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim2.Payment_Date__c = System.today();
        claim2.Territory__c = t1.Id;
        claim2.Country_BL__c ='United States';
        claim2.Business_Units__c ='Roofing'; 
        claim2.WOD_2__Warranty_Product__c=product.id;
        claim2.Customer__c=acc.id;
        claim2.Business_Units__c='Roofing';
        claim2.Division_Code__c='Residential';
        //insert claim2;
        claimsList.add(claim2);
        
        
        WOD_2__Claim__c claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Roofing';
        claim3.Division_Code__c='Residential';
        //insert claim2;
        claimsList.add(claim3);
        
        
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Solar Solutions');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Solar Solutions';
        claim3.Division_Code__c='Solar';
        //insert claim2;
        claimsList.add(claim3);
        
        //4
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Commercial Building & Infrastructure');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Commercial Building & Infrastructure';
        claim3.Division_Code__c='Commercial';
        //insert claim2;
        claimsList.add(claim3);
        
        
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Commercial Building & Infrastructure');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Commercial Building & Infrastructure';
        claim3.Division_Code__c='SBM Commercial WP';
        //insert claim2;
        claimsList.add(claim3);
        
        
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Commercial Building & Infrastructure');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Commercial Building & Infrastructure';
        claim3.Division_Code__c='SBM Fireproofing';
        //insert claim2;
        claimsList.add(claim3);
        
        //7
        claim3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Commercial Building & Infrastructure');
        claim3.Payment_Date__c = System.today();
        claim3.WOD_2__Claim_Status__c='Pre-Claim';
        claim3.Territory__c = t1.Id;
        claim3.Country_BL__c ='United States';
        claim3.WOD_2__Warranty_Product__c=product.id;
        claim3.Customer__c=acc.id;
        claim3.Business_Units__c='Commercial Building & Infrastructure';
        claim3.Division_Code__c='Commercial';
        //insert claim2;
        claimsList.add(claim3);
        
         WOD_2__Claim__c claim4 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Siding');
        claim1.Payment_Date__c = System.today();
            Territory__c t4 = new Territory__c();
            t4.Name ='WarrantyGroup_Tavant';
            t4.Territory_Code__c ='WarrantyGroup_a12345';
            insert t4;
        claim4.Territory__c = t4.Id;
        claim4.Country_BL__c ='Canada';
        claim4.Business_Units__c ='Siding'; 
        claim4.WOD_2__Warranty_Product__c=product.id;
        claim4.Customer__c=acc.id;
        claim4.Division_Code__c='SPG Norandex Siding';
        //insert claim1;
        claimsList.add(claim4);
       // h.onBeforeUpdate(listClaimId,oldMap);       
        insert claimslist;

        claimslist[0].Division_code__c ='Windows';
        claimslist[1].Division_code__c ='Symphony';
        claimslist[2].Division_code__c ='Metal Roofing';
        //claimslist[3].Division_code__c ='Windows';
        claimslist[4].Division_code__c ='CBI Deneef';
        claimslist[5].Division_code__c ='CBI Deneef';
        claimslist[6].Division_code__c ='CBI Deneef';
        claimslist[7].Division_code__c ='SBM Infrastructure';
        
        
        update claimslist;
       
    }
}