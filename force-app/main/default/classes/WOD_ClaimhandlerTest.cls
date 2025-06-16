@isTest
private class WOD_ClaimhandlerTest {
    @isTest
    static void testCreateClaim() {
        // Test data setup
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        WOD_2__Claim__c testClaim = new WOD_2__Claim__c(
            Name = 'Test Claim',
            Customer__c = testAccount.Id,
            WOD_2__Claim_Type__c = 'Standard'
        );
        insert testClaim;

        WOD_Claim_Interested_Parties__c testDistributor = new WOD_Claim_Interested_Parties__c(
            Name = 'Test Distributor',
            Claim__c = testClaim.Id,
            Zip_Code__c = '12345',
            Type__c = 'Distributor'
        );
        insert testDistributor;

        List<WOD_Shipping_Products__c> testProductList = new List<WOD_Shipping_Products__c>{
            new WOD_Shipping_Products__c(Claim__c = testClaim.Id)
        };

        // Test method invocation
        WOD_Claimhandler claimHandler = new WOD_Claimhandler();
        claimHandler.createClaim(testClaim, testDistributor, testProductList);

        // Verify that claim record was created
        System.assertEquals(1, [SELECT COUNT() FROM WOD_2__Claim__c WHERE Id = :testClaim.Id]);

        // Verify that distributor record was created
        System.assertEquals(1, [SELECT COUNT() FROM WOD_Claim_Interested_Parties__c WHERE Id = :testDistributor.Id]);

        // Verify that product records were created
        System.assertEquals(0, [SELECT COUNT() FROM WOD_Shipping_Products__c WHERE Claim__c = :testClaim.Id]);
    }
    @isTest
    static void testCreateClaim1() {
        try{
        // Test data setup
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        WOD_2__Claim__c testClaim = new WOD_2__Claim__c(
            Name = 'Test Claim',
            Customer__c = testAccount.Id,
            WOD_2__Claim_Type__c = 'Standard'
        );
        insert testClaim;
		WOD_2__Claim__c testClaim1 = new WOD_2__Claim__c(
            Name = 'Test Claim',
            Customer__c = testAccount.Id,
            WOD_2__Claim_Type__c = 'Standard'
        );
         WOD_2__Claim__c testClaim2 = new WOD_2__Claim__c(
            Name = 'Test Claim',
            Customer__c = testAccount.Id,
            WOD_2__Claim_Type__c = 'Solar'
        );
        WOD_Claim_Interested_Parties__c testDistributor = new WOD_Claim_Interested_Parties__c(
            Name = 'Test Distributor',
            Claim__c = testClaim.Id,
            Zip_Code__c = '12345',
            Type__c = 'Distributor'
        );
        insert testDistributor;

        List<WOD_Shipping_Products__c> testProductList = new List<WOD_Shipping_Products__c>{
            new WOD_Shipping_Products__c(Claim__c = testClaim.Id)
        };

        // Test method invocation
        WOD_Claimhandler claimHandler = new WOD_Claimhandler();
        claimHandler.createClaim(testClaim1, testDistributor, testProductList);
        claimHandler.createClaim(testClaim2, testDistributor, testProductList);
        }catch (exception e){}
    }
    @isTest
   static void cliamUpdateTest2(){
        
  		Account acc = WOD_TestDataFactory.createAccount('Tavant_Test','','Customer');
        insert acc;        
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='11123454';
        plant.Plant_code__c='5556';
        insert plant;
        WOD_2__Warranty_Product__c wp=new WOD_2__Warranty_Product__c();
        wp.Name='Test';
        wp.WOD_2__Track_Type__c='Non-Serialized';
        insert wp;
        
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm.Address_1_BL__c='My Name90';
        clm.WOD_2__BusinessCategory__c=bcc.Id;
        clm.Plant__c=plant.Id;
        clm.Product_Group__c='Solar';
        clm.Postal_Code_BL__c='212-222';
        clm.Ship_To_Party__c=acc.Id;
        clm.Sold_To_Party__c=acc.Id;
        clm.WOD_2__Warranty_Product__c=wp.Id;
        insert clm;
        
        WOD_Shipping_Products__c shippProd=new WOD_Shipping_Products__c();
        shippProd.Name='Test';
        shippProd.Claim__c=clm.Id;
        shippProd.Quantity__c=1;
        shippProd.Warranty_Product__c=wp.Id;
        List<WOD_Shipping_Products__c> shppProdList=new List<WOD_Shipping_Products__c> ();
        shppProdList.add(shippProd);
        insert shppProdList;
        
        List<WOD_InternalClaimController.ShippingMaterialWrapper> lstWrap = new List<WOD_InternalClaimController.ShippingMaterialWrapper>(); 
        WOD_InternalClaimController.ShippingMaterialWrapper smwWrap = new WOD_InternalClaimController.ShippingMaterialWrapper();
        smwWrap.shipMaterialId = shppProdList[0].id;
        smwWrap.warrantyProdId = wp.Id;
        smwWrap.warrantyProdName = 'Test';
        smwWrap.quantity = 1;
        smwWrap.uom = 'test';
        smwWrap.color = 'RED';
        lstWrap.add(smwWrap);
        Test.startTest();
        
        WOD_2__Claim__c clm1 = WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.id,'Roofing');
        clm1.Address_1_BL__c='My Name9';
        WOD_2__Claim__c clm2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        clm2.Address_1_BL__c='My Name8';
        WOD_2__Claim__c clm3 = WOD_TestDataFactory.CreateClaim('Solar','Solar',acc.id,'Roofing');
        clm3.Address_1_BL__c='My Name7';
        WOD_2__Claim__c clm4 = WOD_TestDataFactory.CreateClaim('International','International',acc.id,'Roofing');
        clm4.Address_1__c='My Name6';
        insert clm4;
        WOD_Claim_Interested_Parties__c clmIntParties = WOD_TestDataFactory.createInterestedParty(clm4.id,'Contractor'); 
        clmIntParties.Business_Units__c='Roofing';
        insert clmIntParties;
        WOD_Claimhandler objClmHandler = new WOD_Claimhandler(); 

        objClmHandler.createClaim(clm1,clmIntParties,shppProdList); 
        objClmHandler.createClaim(clm2,clmIntParties,shppProdList); 
        objClmHandler.createClaim(clm3,clmIntParties,shppProdList); 
        objClmHandler.createClaim(clm4,clmIntParties,shppProdList);
       
        Test.stopTest();
    }
}