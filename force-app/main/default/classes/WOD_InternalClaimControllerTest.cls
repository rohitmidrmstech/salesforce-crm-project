@isTest
private class WOD_InternalClaimControllerTest {
   @TestSetup  
    public static void testDataSetup() { 
        Account acc = WOD_TestDataFactory.createAccount('Tavant_Test','','Customer');
        insert acc;
    }

    private static testmethod void getClaimInformationTest(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        clm.Address_1_BL__c='Add Test2';
        insert clm;
        WOD_InternalClaimController.getClaimInformation(clm.Id);
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant2';
       // plant.Business_Units__c='Roofing';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='11234541';
        plant.Plant_code__c='5556';
        insert plant;
        WOD_2__Claim__c clmInternational=WOD_TestDataFactory.CreateClaim('International','International',acc.Id,'Roofing');
        clmInternational.Plant__c=plant.Id;
        clmInternational.Address_1__c='Add1';
        insert clmInternational;
        WOD_Claim_Interested_Parties__c cip=new WOD_Claim_Interested_Parties__c();
        cip.Business_Units__c='Roofing';
        cip.Address_1__c='Test';
        cip.City__c='Test';
        cip.Claim__c=clmInternational.Id;
        cip.Country__c='United States';
        cip.State__c='Florida (FL)';
        cip.Zip_Code__c='2323';
        cip.Type__c='Distributor';
        insert cip;
        WOD_InternalClaimController.getClaimInformation(clmInternational.Id);
        WOD_InternalClaimController.assignShipToInfo(null);
        WOD_InternalClaimController.assignSoldToiInfo(null);
        WOD_InternalClaimController.getClaimData(null);
        WOD_InternalClaimController.getClaimInterestedPartiesRecordType(clm.Id);
        WOD_InternalClaimController.getClaimInterestedPartiesRecordType(null);

        Test.stopTest();
    }
    
   private static testmethod void saveClaimTest(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
       // plant.Business_Units__c='Roofing';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='1123454';
        plant.Plant_code__c='5556';
        insert plant;
      
        
        WOD_2__Claim__c clmLocked=WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        clmLocked.Address_1_BL__c='My Name2';
        clmLocked.WOD_2__BusinessCategory__c=bcc.Id;
        clmLocked.Plant__c=plant.Id;
        clmLocked.Product_Group__c='Solar';
        clmLocked.Postal_Code_BL__c='212-222';
        clmLocked.Ship_To_Party__c=acc.Id;
        clmLocked.Sold_To_Party__c=acc.Id;
        clmLocked.isLocked__c=true;
        clmLocked.Property_Type__c='Commercial';
        clmLocked.Extended_Warranty_Registration_Number__c='232323';
        
        WOD_InternalClaimController.saveClaim(JSON.serialize(clmLocked),'','');
        
        clmLocked.Product_Group__c='Roofing';
        WOD_InternalClaimController.saveClaim(JSON.serialize(clmLocked),'','');
        clmLocked.Product_Group__c='Roofing';
        clmLocked.Property_Type__c='Residential';
        clmLocked.WOD_2__Claim_Type__c ='Commercial_Extended_Warranty_NDL';
        WOD_InternalClaimController.saveClaim(JSON.serialize(clmLocked),'','');
        Test.stopTest();
    }
    private static testmethod void saveClaimTest2(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
       // plant.Business_Units__c='Roofing';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='1123454';
        plant.Plant_code__c='5556';
        insert plant;
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm.Address_1_BL__c='My Name22';
        clm.WOD_2__BusinessCategory__c=bcc.Id;
        clm.Plant__c=plant.Id;
        clm.Product_Group__c='Solar';
        clm.Postal_Code_BL__c='212-222';
        clm.Ship_To_Party__c=acc.Id;
        clm.Sold_To_Party__c=acc.Id;
        //insert clm;
       
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Commercial_Extended_Warranty_NDL';
        clm.WOD_2__Claim_Status__c = 'Claim';
        clm.isClassAction__c=true;
        clm.Business_Units__c='Siding';
        clm.Tape_Code_A__c='Abc';
        clm.Tape_Code_B__c='666';
        clm.Tape_Code_C__c='788';
        clm.Tape_Code_D__c='2121';
        clm.Ship_to__c='TEst';
        clm.Order_for__c='Test';
        clm.Squares_Applied__c=67555;
        clm.Squares_In_Whse__c=8999;
        clm.Squares_Not_Applied__c=887;
        clm.Voucher1_Amount__c=11;
        clm.Voucher2_Amount__c=22;
        //update clm;
       // WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Standard';
        //update clm;
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'Test','');
        Test.stopTest();
    }
    
    private static testmethod void getBCCRecordsTest(){
        
        Test.startTest();
        User testUser = new User(FirstName = 'Test',LastName = 'User',Username = 'testuser@dtag.com.dtagdev',Email = 'testuser@dtag.com.dtagdev',Alias = 'Alias',TimeZoneSidKey = 'GMT',LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8',FederationIdentifier ='TESTUSER32T',WOD_2__Business_Units__c='Roofing; Commercial Building & Infrastructure; Siding; Solar Solutions',ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,LanguageLocaleKey = 'en_US', Sales_Org__c='1102');
        insert testUser;
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        System.runAs(testUser){
            WOD_InternalClaimController.getBCCRecords();
        }
        testUser.Sales_Org__c='1502';
        update testUser;
        System.runAs(testUser){
            WOD_InternalClaimController.getBCCRecords();
        }
        testUser.Sales_Org__c='1501';
        update testUser;
        System.runAs(testUser){
            WOD_InternalClaimController.getBCCRecords();
        }
        Test.stopTest();
    }
    private static testmethod void getDependentOptionsTest(){
        Test.startTest();
        WOD_InternalClaimController.getDependentOptions('WOD_2__Claim__c','Business_Units__c','Installation_Location__c',false);
        WOD_InternalClaimController.getShortTermValidity();
        Test.stopTest();
    }
    /**
     * @description data set up and execution
    */
    private static testmethod void claimTest(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='111234';
        plant.Plant_code__c='5556';
        insert plant;
        WOD_2__Warranty_Product__c wp=new WOD_2__Warranty_Product__c();
        wp.Name='Test';
        wp.WOD_2__Track_Type__c='Non-Serialized';
        insert wp;
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm.Address_1_BL__c='Add Test21';
        clm.WOD_2__BusinessCategory__c=bcc.Id;
        clm.Plant__c=plant.Id;
        clm.Product_Group__c='Solar';
        clm.Postal_Code_BL__c='212-222';
        clm.Ship_To_Party__c=acc.Id;
        clm.Sold_To_Party__c=acc.Id;
        clm.WOD_2__Warranty_Product__c=wp.Id;
        insert clm;
        
        WOD_InternalClaimController.getAccountInformation(acc.Id);
        WOD_InternalClaimController.getClaimData(clm.Id);
        WOD_InternalClaimController.getClaimInterestedPartiesRecordType(clm.Id); 
        Test.stopTest();
    }
    private static testmethod void cliamUpdateTest(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='111154';
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
        
        WOD_InternalClaimController.getShippingMaterial(clm.Id);
        WOD_InternalClaimController.getClaimRecordTypes();
        
        WOD_InternalClaimController intCont=new WOD_InternalClaimController();
        
        WOD_InternalClaimController.updateClaimAsApprovedOrReject(clm.Id,'Approved');
        WOD_InternalClaimController.updateClaim(clm.Id,'Test Closed');
        WOD_InternalClaimController.updateClaimAsReOpened(clm.Id,'Test');
        WOD_InternalClaimController.createShippingProduct(clm.Id,lstWrap,shppProdList,true);
        WOD_InternalClaimController.updateClaimAsApprovedOrReject('','Approved');
        WOD_InternalClaimController.updateClaim('','Test Closed');
        WOD_InternalClaimController.updateClaimAsReOpened('','Test');
        //WOD_InternalClaimController.getDivisionvals();
        //WOD_InternalClaimController.getPicklistValues();
   
        Test.stopTest();
    }
    private static testmethod void cliamUpdateTest2(){
        
        Account acc=[Select Id,Name from Account];
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

    private static testmethod void cliamUpdateTestpositive(){
        Test.startTest();
        User testUser = new User(FirstName = 'Test',LastName = 'User',Username = 'testuser@dtag.com.dtagdev',Email = 'testuser@dtag.com.dtagdev',Alias = 'Alias',TimeZoneSidKey = 'GMT',LocaleSidKey = 'en_US',EmailEncodingKey = 'UTF-8',FederationIdentifier ='TESTUSER32T',WOD_2__Business_Units__c='Roofing; Commercial Building & Infrastructure; Siding; Solar Solutions',ProfileId = [SELECT Id FROM Profile WHERE Name = 'System Administrator'].Id,LanguageLocaleKey = 'en_US', Sales_Org__c='1102');

        insert testUser;
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='111154';
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
        
        
              
      System.runAs(testUser)
        {
            //WOD_InternalClaimController.getDivisionvals();
            WOD_InternalClaimController.getPicklistValues('WOD_2__Claim__c','Product_Group__c');
        }
       
        Test.stopTest();
    } 
    
private static testmethod void saveClaimTest3(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Siding';
        insert bcc;
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
       // plant.Business_Units__c='Roofing';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='1123454';
        plant.Plant_code__c='5556';
        insert plant;
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm.Address_1_BL__c='My Name22';
        clm.WOD_2__BusinessCategory__c=bcc.Id;
        clm.Plant__c=plant.Id;
        clm.Product_Group__c='Solar';
        clm.Postal_Code_BL__c='212-222';
        clm.Ship_To_Party__c=acc.Id;
        clm.Sold_To_Party__c=acc.Id;
        //insert clm;
       
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Commercial_Extended_Warranty_NDL';
        clm.WOD_2__Claim_Status__c = 'Claim';
        clm.isClassAction__c=true;
        clm.Business_Units__c='Siding';
        clm.Tape_Code_A__c='Abc';
        clm.Tape_Code_B__c='666';
        clm.Tape_Code_C__c='788';
        clm.Tape_Code_D__c='2121';
        clm.Ship_to__c='TEst';
        clm.Order_for__c='Test';
        clm.Squares_Applied__c=67555;
        clm.Squares_In_Whse__c=8999;
        clm.Squares_Not_Applied__c=887;
        clm.Voucher1_Amount__c=11;
        clm.Voucher2_Amount__c=22;
        //update clm;
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Standard';
        //update clm;
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'Test','');
        Test.stopTest();
    }
    private static testmethod void saveClaimTest4(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Siding';
        insert bcc;
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
       // plant.Business_Units__c='Roofing';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='1123454';
        plant.Plant_code__c='5556';
        insert plant;
        WOD_2__Warranty_Product__c wp=new WOD_2__Warranty_Product__c();
        wp.Name='Test';
        wp.WOD_2__Track_Type__c='Non-Serialized';
        insert wp;
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm.Address_1_BL__c='My Name22';
        clm.WOD_2__BusinessCategory__c=bcc.Id;
        clm.Plant__c=plant.Id;
        clm.Product_Group__c='Solar';
        clm.Postal_Code_BL__c='212-222';
        clm.Ship_To_Party__c=acc.Id;
        clm.Sold_To_Party__c=acc.Id;
        clm.WOD_2__Warranty_Product__c=wp.Id;
        
        //insert clm;
       
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Commercial_Extended_Warranty_NDL';
        clm.WOD_2__Claim_Status__c = 'Claim';
        clm.isClassAction__c=true;
        clm.Business_Units__c='Siding';
        clm.Tape_Code_A__c='Abc';
        clm.Tape_Code_B__c='666';
        clm.Tape_Code_C__c='788';
        clm.Tape_Code_D__c='2121';
        clm.Ship_to__c='TEst';
        clm.Order_for__c='Test';
        clm.Squares_Applied__c=67555;
        clm.Squares_In_Whse__c=8999;
        clm.Squares_Not_Applied__c=887;
        clm.Voucher1_Amount__c=11;
        clm.Voucher2_Amount__c=22;
        //update clm;
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Standard';
        //update clm;
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'Test','');
        Test.stopTest();
    }
        private static testmethod void saveClaimTest5(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Siding';
        insert bcc;
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
       // plant.Business_Units__c='Roofing';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='1123454';
        plant.Plant_code__c='5556';
        insert plant;
        WOD_2__Warranty_Product__c wp=new WOD_2__Warranty_Product__c();
        wp.Name='Test';
        wp.WOD_2__Track_Type__c='Non-Serialized';
        insert wp;
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm.Address_1_BL__c='My Name22';
        clm.WOD_2__BusinessCategory__c=bcc.Id;
        clm.Plant__c=plant.Id;
        clm.Product_Group__c='Solar';
        clm.Postal_Code_BL__c='212-222';
        clm.Ship_To_Party__c=acc.Id;
        clm.Sold_To_Party__c=acc.Id;
        clm.WOD_2__Warranty_Product__c=wp.Id;
        
        //insert clm;
       
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Commercial_Extended_Warranty_NDL';
        clm.WOD_2__Claim_Status__c = 'Claim';
        clm.isClassAction__c=true;
        clm.Business_Units__c='Siding';
        clm.Tape_Code_A__c='&#160;';
        clm.Tape_Code_B__c='666';
        clm.Tape_Code_C__c='788';
        clm.Tape_Code_D__c='2121';
        clm.Ship_to__c='TEst';
        clm.Order_for__c='Test';
        clm.Squares_Applied__c=67555;
        clm.Squares_In_Whse__c=8999;
        clm.Squares_Not_Applied__c=887;
        clm.Voucher1_Amount__c=11;
        clm.Voucher2_Amount__c=22;
        //update clm;
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Standard';
        //update clm;
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'Test','');
        Test.stopTest();
    }
    private static testmethod void saveClaimTest6(){
        Test.startTest();
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        Plants__c plant=new Plants__c();
        plant.Name='Test Plant';
       // plant.Business_Units__c='Roofing';
        plant.SOrg__c='1502';
        plant.SAP_Plant__c='1123454';
        plant.Plant_code__c='5556';
        insert plant;
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.Id,'Roofing');
        clm.Address_1_BL__c='My Name22';
        clm.WOD_2__BusinessCategory__c=bcc.Id;
        clm.Plant__c=plant.Id;
        clm.Product_Group__c='Solar';
        clm.Postal_Code_BL__c='212-222';
        clm.Ship_To_Party__c=acc.Id;
        clm.Sold_To_Party__c=acc.Id;
        //insert clm;
       
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'','');
        clm.WOD_2__Claim_Type__c='Commercial_Extended_Warranty_NDL';
        clm.WOD_2__Claim_Status__c = 'Claim';
        clm.isClassAction__c=true;
        clm.Business_Units__c='Siding';
        clm.Tape_Code_A__c='Abc';
        clm.Tape_Code_B__c='666';
        clm.Tape_Code_C__c='788';
        clm.Tape_Code_D__c='2121';
        clm.Ship_to__c='TEst';
        clm.Order_for__c='Test';
        clm.Squares_Applied__c=67555;
        clm.Squares_In_Whse__c=8999;
        clm.Squares_Not_Applied__c=887;
        clm.Voucher1_Amount__c=11;
        clm.Voucher2_Amount__c=22;
        WOD_InternalClaimController.saveClaim(JSON.serialize(clm),'Test','');
        Test.stopTest();
    }
   
    private static testmethod void updateClaimWithDivisionTest(){
        Test.startTest();
        
        Account acc=[Select Id,Name from Account];
        WOD_2__Business_Category_Configuration__c bcc=new WOD_2__Business_Category_Configuration__c();
        bcc.Name='Roofing';
        insert bcc;
        WOD_2__Claim__c clm=WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.Id,'Roofing');
        clm.Address_1_BL__c='Add Test2';
        clm.Division_Code__c = 'Metal Roofing';
        insert clm;
        WOD_InternalClaimController.updateClaimWithDivision(clm.Id , 'Metal Roofing');
        Test.stopTest();
    }
}