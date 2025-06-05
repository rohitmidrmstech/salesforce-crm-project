@isTest
private class WOD_ClaimQuickActionControllerTest{
    @TestSetup  
    private static void setup() { 
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount2','','Warranty Account');
        insert acc;

        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        insert product;
        
        WOD_2__Warranty_Code__c wc = WOD_TestDataFactory.createWarrantyCode('test Warr Code',product.id);
        insert wc;
        
        List<WOD_2__Business_Category_Configuration__c> lstBCC = new List<WOD_2__Business_Category_Configuration__c>();
        
        WOD_2__Business_Category_Configuration__c bcc1 = new WOD_2__Business_Category_Configuration__c();
        bcc1.Name = 'Siding';
        
        WOD_2__Business_Category_Configuration__c bcc2 = new WOD_2__Business_Category_Configuration__c();
        bcc2.Name = 'Roofing';
        
         // Create profiles if not already existing
        Profile techServicesProfile = [SELECT Id FROM Profile WHERE Name = 'Tech Services' LIMIT 1];
        Profile warrantyAdminRoofingProfile = [SELECT Id FROM Profile WHERE Name = 'Warranty Admin Roofing' LIMIT 1];
        Profile systemAdminProfile = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        Profile warrantyInspectorRoofing = [SELECT Id FROM Profile WHERE Name = 'Warranty Processor Roofing' LIMIT 1];
        String timestamp = String.valueOf(DateTime.now().getTime());
        // Create test users with the profiles
        User techServicesUser = new User(
            Alias = 'tsuser',
            Email = 'tsuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = techServicesProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'tsuser'+timestamp+'@example.com'
        );
        insert techServicesUser;
        
        User warrantyAdminRoofingUser = new User(
            Alias = 'wauser',
            Email = 'wauser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = warrantyAdminRoofingProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'wauser'+timestamp+'@example.com'
        );
        insert warrantyAdminRoofingUser;
        
        User systemAdminUser = new User(
            Alias = 'sauser',
            Email = 'sauser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = systemAdminProfile.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'sauser'+timestamp+'@example.com'
        );
        insert systemAdminUser;
         User techinspectUser = new User(
            Alias = 'tsinuser',
            Email = 'tsinuser@example.com',
            EmailEncodingKey = 'UTF-8',
            LastName = 'User',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            ProfileId = warrantyInspectorRoofing.Id,
            TimeZoneSidKey = 'America/Los_Angeles',
            UserName = 'tsinuser'+timestamp+'@example.com'
        );
        insert techinspectUser;
        
        // Create a test claim
        WOD_2__Claim__c testClaim = new WOD_2__Claim__c(
            Customer__c =acc.id,
            Business_Units__c = 'Roofing',
            WOD_2__Claim_Status__c = 'Pre-Claim',
            Sales_Org__c = '1501'
        );
        insert testClaim;
        
        lstBCC.add(bcc1);
        lstBCC.add(bcc2);
        insert lstBCC;
                
        WOD_2__Policy_Definition__c plcyDef =new WOD_2__Policy_Definition__c();
        plcyDef.Name = 'testplDf1';
        plcyDef.WOD_2__Active_From__c = System.today().addDays(-30);
        plcyDef.WOD_2__Active_Until__c = System.today().addDays(40);
        plcyDef.WOD_2__Priority__c = 1;
        plcyDef.WOD_2__Months_Covered__c = 15;
        plcyDef.WOD_2__Type__c = 'Standard';
        plcyDef.WOD_2__Status__c = 'Active';
        insert plcyDef;
        
        
        List<WOD_2__Applicability_Term__c> lstAT = new List<WOD_2__Applicability_Term__c>();
        WOD_2__Applicability_Term__c at = new WOD_2__Applicability_Term__c ();
        at.WOD_2__Rule_Object_API_Name__c = 'WOD_2__Claim__c';
        at.WOD_2__Policy_Definition__c = plcyDef.id;
        at.WOD_2__Functionality__c = 'Warranty Rule';
        at.WOD_2__Applicability_Term_Type__c = 'Inclusion';
        at.WOD_2__isValidExpression__c = true;
        at.WOD_2__isCustomLogicalExpression__c = true;
        at.WOD_2__Logical_Grouping__c = '1 AND 2';
        
        
        WOD_2__Applicability_Term__c at2 = new WOD_2__Applicability_Term__c ();
        at2.WOD_2__Rule_Object_API_Name__c = 'WOD_2__Claim__c';
        at2.WOD_2__Policy_Definition__c = plcyDef.id;
        at2.WOD_2__Functionality__c = 'Warranty Rule';
        at2.WOD_2__Applicability_Term_Type__c = 'Inclusion';
        at2.WOD_2__isValidExpression__c = true;
        at2.WOD_2__isCustomLogicalExpression__c = true;
        at2.WOD_2__Logical_Grouping__c = '1 AND 2';
        
        
        lstAT.add(at);
        lstAT.add(at2);
        insert lstAT;
        
        List<WOD_2__Applicability_Criteria__c> lstAC = new List<WOD_2__Applicability_Criteria__c>();
        WOD_2__Applicability_Criteria__c  ac1 = new WOD_2__Applicability_Criteria__c ();
        ac1.WOD_2__Applicability_Term__c = at.id;
        ac1.WOD_2__Criteria_Value__c = 'Siding';
        ac1.WOD_2__Criteria_Value_Text__c ='Siding'; 
        ac1.WOD_2__Field_Path__c = 'WOD_2__BusinessCategory__r.Name';
        ac1.WOD_2__Field_Path_Label__c = 'WOD_2__BusinessCategory__r.Name';
        ac1.WOD_2__Field_Type__c = 'STRING';
        ac1.WOD_2__Object_Name__c ='WOD_2__Claim__c';
        ac1.WOD_2__Operator__c='Equals';
        ac1.WOD_2__Sequence__c= 1;
        ac1.WOD_2__Value_Type__c='Static';
        
        WOD_2__Applicability_Criteria__c  ac2 = new WOD_2__Applicability_Criteria__c ();
        ac2.WOD_2__Applicability_Term__c = at.id;
        ac2.WOD_2__Criteria_Value__c = 'Other';
        ac2.WOD_2__Criteria_Value_Text__c ='Other';
        ac2.WOD_2__Field_Path__c = 'Building_Type__c';
        ac2.WOD_2__Field_Path_Label__c = 'Building_Type__c';
        ac2.WOD_2__Field_Type__c = 'PICKLIST';
        ac2.WOD_2__Object_Name__c ='WOD_2__Claim__c';
        ac2.WOD_2__Operator__c='Equals';
        ac2.WOD_2__Sequence__c= 2;
        ac2.WOD_2__Value_Type__c='Static';
        
        
        WOD_2__Applicability_Criteria__c  ac3 = new WOD_2__Applicability_Criteria__c ();
        ac3.WOD_2__Applicability_Term__c = at2.id;
        ac3.WOD_2__Criteria_Value__c = 'Roofing';
        ac3.WOD_2__Criteria_Value_Text__c ='Roofing'; 
        ac3.WOD_2__Field_Path__c = 'WOD_2__BusinessCategory__r.Name';
        ac3.WOD_2__Field_Path_Label__c = 'WOD_2__BusinessCategory__r.Name';
        ac3.WOD_2__Field_Type__c = 'STRING';
        ac3.WOD_2__Object_Name__c ='WOD_2__Claim__c';
        ac3.WOD_2__Operator__c='Equals';
        ac3.WOD_2__Sequence__c= 1;
        ac3.WOD_2__Value_Type__c='Static';
        
        WOD_2__Applicability_Criteria__c  ac4 = new WOD_2__Applicability_Criteria__c ();
        ac4.WOD_2__Applicability_Term__c = at2.id;
        ac4.WOD_2__Criteria_Value__c = 'Other';
        ac4.WOD_2__Criteria_Value_Text__c ='Other';
        ac4.WOD_2__Field_Path__c = 'Building_Type__c';
        ac4.WOD_2__Field_Path_Label__c = 'Building_Type__c';
        ac4.WOD_2__Field_Type__c = 'PICKLIST';
        ac4.WOD_2__Object_Name__c ='WOD_2__Claim__c';
        ac4.WOD_2__Operator__c='Equals';
        ac4.WOD_2__Sequence__c= 2;
        ac4.WOD_2__Value_Type__c='Static';
        
        lstAC.add(ac1);
        lstAC.add(ac2);
        lstAC.add(ac3);
        lstAC.add(ac4);
        insert lstAC;
        
        
        List<WOD_2__Claim__c> lstClaim = new List<WOD_2__Claim__c>();
        WOD_2__Claim__c clm1 = WOD_TestDataFactory.CreateClaim('Short_Term','Short Term',acc.id,'Roofing');
        clm1.State_BL__c ='Florida (FL)';
        clm1.Country_BL__c ='United States';
        clm1.Business_Units__c='Roofing';
        clm1.Division_Code__c='Residential';
        clm1.WOD_2__Claim_Status__c = 'Pre-Claim';
        
        WOD_2__Claim__c clm2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        clm2.State_BL__c ='Florida (FL)';
        clm2.Country_BL__c ='United States';
        clm2.Business_Units__c='Roofing';
        clm2.Division_Code__c='Residential';
        
        clm2.Address_1_BL__c='Test add 2';
        WOD_2__Claim__c clm3 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Siding');
        clm3.State_BL__c ='Florida (FL)';
        clm3.Country_BL__c ='United States';
        clm3.Business_Units__c='Siding';
        clm3.Division_Code__c='Fiber Cement';
        
        clm3.Address_1_BL__c='Test add 3';
        WOD_2__Claim__c clm4 = WOD_TestDataFactory.CreateClaim('Solar','Solar',acc.id,'Roofing');
        clm4.State_BL__c ='Florida (FL)';
        clm4.Country_BL__c ='United States';
        clm4.Business_Units__c='Roofing';
        clm4.Division_Code__c='Residential';
        
        clm4.Address_1_BL__c='Test add 4';
        WOD_2__Claim__c clm5 = WOD_TestDataFactory.CreateClaim('International','International',acc.id,'Roofing');
        clm5.State_BL__c ='Florida (FL)';
        clm5.Country_BL__c ='United States';
        clm5.Business_Units__c='Roofing';
        clm5.Division_Code__c='Residential';
        
        clm5.Address_1__c='Test add 5';
        WOD_2__Claim__c clm6 = WOD_TestDataFactory.CreateClaim('International','International',acc.id,'Siding');
        clm6.State_BL__c ='Florida (FL)';
        clm6.Country_BL__c ='United States';
        clm6.Business_Units__c='Siding';
        clm6.Division_Code__c='Fiber Cement';
        
        clm5.Address_1__c='Test add 6';
        
        lstClaim.add(clm1);
        lstClaim.add(clm2);
        lstClaim.add(clm3);
        lstClaim.add(clm4);
        lstClaim.add(clm5);
        lstClaim.add(clm6);
        
        insert lstClaim;
        
        
    } 
    Private static testMethod void hasUserEditAccessTest(){ 
        Test.startTest();
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        WOD_2__Warranty_Code__c wc = [Select id from WOD_2__Warranty_Code__c];
        List<Account> accList=[Select Id from Account ];
        List<WOD_2__Business_Category_Configuration__c> lstBCC = [Select id,Name from WOD_2__Business_Category_Configuration__c order by createddate asc];
        //List<WOD_2__Claim__c> lstClaim = [Select id,WOD_2__Claim_Type__c,WOD_2__Claim_Status__c,Business_Units__c from WOD_2__Claim__c WHERE Business_Units__c='Siding' order by createddate desc];
        WOD_2__Claim__c lstClaim = WOD_TestDataFactory.CreateClaim('Standard','Standard',accList[0].id,'Siding');
        lstClaim.Address_1_BL__c='Aff2';
        lstClaim.WOD_2__BusinessCategory__c = lstBCC[0].id;
        lstClaim.WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim.WOD_2__Warranty_Product__c = product.id;
        lstClaim.Proof_of_Purchase__c = Date.today()-12;
        lstClaim.Property_Type__c = 'Residential';
        lstClaim.Building_Type__c = 'Single Family Home'; 
        lstClaim.Install_Date__c = Date.today();
        lstClaim.Primary_Defect_Code__c = wc.id;
        lstClaim.Product_Group__c = 'Millwork';
        lstClaim.Quantity__c = 2;
        lstClaim.Building_Type__c = 'Other';
        lstClaim.OwnershipType__c = 'First';
        insert lstClaim;
        
        WOD_ClaimQuickActionController.hasUserEditAccess('WOD_2__Claim__c');
        //List<WOD_2__Claim__c> lstClaim = [Select id,WOD_2__Claim_Type__c,WOD_2__Claim_Status__c,Business_Units__c from WOD_2__Claim__c where Business_Units__c='Siding'];
        
        WOD_2__Claim__c clm = WOD_TestDataFactory.CreateClaim('International','International',accList[0].id,'Siding');
        clm.Address_1__c='hjkk';
        clm.WOD_2__BusinessCategory__c = lstBCC[0].id;
        clm.WOD_2__Claim_Status__c = 'Claim';
        clm.WOD_2__Warranty_Product__c = product.id;
        clm.Proof_of_Purchase__c = Date.today()-12;
        clm.Property_Type__c = 'Residential';
        clm.Building_Type__c = 'Single Family Home'; 
        clm.Install_Date__c = Date.today();
        clm.Primary_Defect_Code__c = wc.id;
        clm.Product_Group__c = 'Millwork';
        clm.Quantity__c = 2;
        clm.Building_Type__c = 'Single Family Home';
        clm.OwnershipType__c = 'Second';
        insert clm;
        WOD_ClaimQuickActionController.convertClaim(lstClaim.id);
        WOD_ClaimQuickActionController.convertClaim(clm.id);
        Test.stopTest();
        
    }
    Private static testMethod void hasUserEditAccessTest1(){ 
        Test.startTest();
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        WOD_2__Warranty_Code__c wc = [Select id from WOD_2__Warranty_Code__c];
        List<Account> accList=[Select Id from Account ];
        List<WOD_2__Business_Category_Configuration__c> lstBCC = [Select id,Name from WOD_2__Business_Category_Configuration__c order by createddate asc];
        //List<WOD_2__Claim__c> lstClaim = [Select id,WOD_2__Claim_Type__c,WOD_2__Claim_Status__c,Business_Units__c from WOD_2__Claim__c WHERE Business_Units__c='Siding' order by createddate desc];
        WOD_2__Claim__c lstClaim = WOD_TestDataFactory.CreateClaim('Commercial_Extended_Warranty_NDL','Serialized',accList[0].id,'Commercial Building & Infrastructure');
        lstClaim.Address_1_BL__c='Aff2';
        lstClaim.WOD_2__BusinessCategory__c = lstBCC[0].id;
        lstClaim.WOD_2__Claim_Status__c = 'Draft';
        lstClaim.WOD_2__Warranty_Product__c = product.id;
        lstClaim.Proof_of_Purchase__c = Date.today()-12;
        //lstClaim.Property_Type__c = 'Residential';
        lstClaim.Building_Type__c = 'Single Family Home'; 
        lstClaim.Install_Date__c = Date.today();
        lstClaim.Sales_Org__c = '1102';
        lstClaim.Primary_Defect_Code__c = wc.id;
        lstClaim.Product_Group__c = 'Millwork';
        lstClaim.Quantity__c = 2;
        lstClaim.WOD_2__Claim_Type__c = 'Commercial_Extended_Warranty_NDL';
        lstClaim.Building_Type__c = 'Other';
        lstClaim.OwnershipType__c = 'First';
        insert lstClaim;
        
        WOD_ClaimQuickActionController.hasUserEditAccess('WOD_2__Claim__c');
        WOD_ClaimQuickActionController.convertClaim(lstClaim.id);
        Test.stopTest();
        
    }
    Private static testMethod void testClaimActions(){
        Test.startTest();
        List<WOD_2__Claim__c> lstClaim = [Select id from WOD_2__Claim__c order by createddate desc];
        WOD_ClaimQuickActionController.ResponseWrapper rw = new WOD_ClaimQuickActionController.ResponseWrapper();
        rw.data = 'test data';
        rw.status = true;
        rw.errormessage = '';
        
        WOD_ClaimQuickActionController.ResponseWrapper createAccessRes = new WOD_ClaimQuickActionController.ResponseWrapper();
        createAccessRes =  WOD_ClaimQuickActionController.hasRecordCreateAccess('WOD_2__Claim__c');
        system.assertEquals('true', createAccessRes.data); 
        
        
        WOD_ClaimQuickActionController.ResponseWrapper recordAccessRes = WOD_ClaimQuickActionController.recordAccessCheck(lstClaim[0].id);
        system.assertEquals('true', createAccessRes.data); 
        WOD_ClaimQuickActionController.ResponseWrapper recordAccessRes2 = WOD_ClaimQuickActionController.recordAccessCheck('test');
        
        WOD_ClaimQuickActionController.toggleDuplicateClaim(lstClaim[0].id);
        WOD_ClaimQuickActionController.toggleDuplicateClaim(lstClaim[0].id);
        WOD_ClaimQuickActionController.needMoreInformationClaim(lstClaim[0].id);
        WOD_ClaimQuickActionController.updateClaimAddValidation(lstClaim[0].id);
        
        lstClaim[1].WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim[1].Warranty_Status__c = 'Out Of Warranty';
        update lstClaim[1];
        
        lstClaim[2].WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim[2].Warranty_Status__c = 'No Matching Policies';
        update lstClaim[2];
        
        
        WOD_ClaimQuickActionController.overrideClaimValidation(lstClaim[1].id);
        WOD_ClaimQuickActionController.overrideClaimValidation(lstClaim[2].id);
        WOD_ClaimQuickActionController.updateClaimAddFromAcc(lstClaim[0].id);
        WOD_ClaimQuickActionController.isLegalClaim(lstClaim[0].id);
        
        WOD_ClaimQuickActionController.convertClaimValidation('shortterm',lstClaim[0].id); 
        WOD_ClaimQuickActionController.convertClaimValidation('standard',lstClaim[0].id); 
        String res = WOD_ClaimQuickActionController.convertClaimValidation('shortterm',lstClaim[2].id);
        system.assertNotEquals('Convert claim is allowed for Roofing only', res);
        
        lstClaim[5].WOD_2__Claim_Status__c = 'Claim';
        update lstClaim[5];
        WOD_ClaimQuickActionController.overrideClaimValidation(lstClaim[1].id);
        
        
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        WOD_2__Warranty_Code__c wc = [Select id from WOD_2__Warranty_Code__c];
        
        lstClaim[0].WOD_2__Claim_Status__c = 'Claim';
        lstClaim[0].WOD_2__Claim_Type__c = 'Solar';
        lstClaim[0].Warranty_Status__c = 'No Matching Policies';
        lstClaim[0].Primary_Defect_Code__c = wc.id;
        update lstClaim[0];
        
        
        lstClaim[3].WOD_2__Claim_Type__c = 'Solar';
        lstClaim[3].Business_Units__c = 'Commercial Building & Infrastructure';
        update lstClaim[3];
        
        WOD_ClaimQuickActionController.convertClaimValidation('shortterm',lstClaim[0].id);
        WOD_ClaimQuickActionController.convertClaimValidation('standard',lstClaim[0].id);        
        WOD_ClaimQuickActionController.convertClaimValidation('standard',lstClaim[3].id);
        WOD_ClaimQuickActionController.needMoreInformationClaim(lstClaim[0].id);
        
        String overrClaimRes = WOD_ClaimQuickActionController.overrideClaimValidation(lstClaim[0].id);
        system.assertNOtEquals('You can only override a Claim which has no Matching Policies',overrClaimRes);
        
        WOD_ClaimQuickActionController.convertClaim(lstClaim[0].id);
        WOD_ClaimQuickActionController.convertClaim(lstClaim[1].id);
        WOD_ClaimQuickActionController.convertClaim(lstClaim[2].id);
        WOD_ClaimQuickActionController.convertClaim(lstClaim[3].id);
        WOD_ClaimQuickActionController.convertClaim(lstClaim[4].id);
        String convertClaimVal = WOD_ClaimQuickActionController.convertClaim(lstClaim[5].id);
        test.stopTest();
        system.assertEquals(Label.WOD_Convert_Error_Message, convertClaimVal);
        
    }
    Private static testMethod void testConvertClaim(){
        Test.startTest();
        WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        
        WOD_2__Warranty_Code__c wc = [Select id from WOD_2__Warranty_Code__c];
        
        List<WOD_2__Business_Category_Configuration__c> lstBCC = [Select id,Name from WOD_2__Business_Category_Configuration__c order by createddate asc];
        List<WOD_2__Claim__c> lstClaim = [Select id,WOD_2__Claim_Type__c,WOD_2__Claim_Status__c,Business_Units__c from WOD_2__Claim__c order by createddate desc];
   
        lstClaim[0].WOD_2__BusinessCategory__c = lstBCC[1].id;
        lstClaim[0].WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim[0].WOD_2__Warranty_Product__c = product.id;
        lstClaim[0].Install_Date__c = Date.today();
        lstClaim[0].Primary_Defect_Code__c = wc.id;
        lstClaim[0].Product_Group__c = 'Solar';

        
        lstClaim[1].WOD_2__BusinessCategory__c = lstBCC[1].id;
        lstClaim[1].WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim[1].WOD_2__Warranty_Product__c = product.id;
        lstClaim[1].Proof_of_Purchase__c = Date.today()-12;
        lstClaim[1].Property_Type__c = 'Residential';
        lstClaim[1].Building_Type__c = 'Single Family Home'; 
        lstClaim[1].Install_Date__c = Date.today();
        lstClaim[1].Primary_Defect_Code__c = wc.id;
        lstClaim[1].Product_Group__c = 'Solar';
        lstClaim[1].Quantity__c = 2;
        lstClaim[1].Building_Type__c = 'Other';
        lstClaim[1].OwnershipType__c = 'Second';
        
        lstClaim[2].WOD_2__BusinessCategory__c = lstBCC[0].id;
        lstClaim[2].WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim[2].WOD_2__Warranty_Product__c = product.id;
        lstClaim[2].Proof_of_Purchase__c = Date.today()-12;
        lstClaim[2].Property_Type__c = 'Residential';
        lstClaim[2].Building_Type__c = 'Single Family Home'; 
        lstClaim[2].Install_Date__c = Date.today();
        lstClaim[2].Primary_Defect_Code__c = wc.id;
        lstClaim[2].Product_Group__c = 'Millwork';
        lstClaim[2].Quantity__c = 2;
        lstClaim[2].Building_Type__c = 'Other';
        lstClaim[2].OwnershipType__c = 'First';
        lstClaim[2].Division_Code__c = '';
        
        lstClaim[3].WOD_2__BusinessCategory__c = lstBCC[1].id;
        lstClaim[3].WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim[3].WOD_2__Warranty_Product__c = product.id;
        lstClaim[3].Install_Date__c = Date.today();
        lstClaim[3].Primary_Defect_Code__c = wc.id;
        lstClaim[3].Product_Group__c = 'Solar';
        lstClaim[3].Quantity__c = 2;
        lstClaim[3].Building_Type__c = 'Other';
        lstClaim[3].OwnershipType__c = 'First';
        lstClaim[3].Property_Type__c = 'Residential';

        lstClaim[5].WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim[5].Install_Date__c = Date.today();
        lstClaim[5].WOD_2__BusinessCategory__c = lstBCC[0].id;
        lstClaim[5].WOD_2__Warranty_Product__c = product.id;
        lstClaim[5].Install_Date__c = Date.today();
        lstClaim[5].Primary_Defect_Code__c = wc.id;
        lstClaim[5].Business_Units__c = 'Siding';

        update lstClaim;
        
        String res1 = WOD_ClaimQuickActionController.convertClaim(lstClaim[0].id);
        system.assertEquals('Please fill all the fields listed in Product Details Section', res1);
        String res2 = WOD_ClaimQuickActionController.convertClaim(lstClaim[1].id);
        system.assertNotEquals('', res2);
        String res3 = WOD_ClaimQuickActionController.convertClaim(lstClaim[2].id);
        system.assertEquals('success', res3);
        String res4 = WOD_ClaimQuickActionController.convertClaim(lstClaim[3].id);
        system.assertNotEquals('', res4);
        String res5 =  WOD_ClaimQuickActionController.convertClaim(lstClaim[5].id);


        
        WOD_ClaimQuickActionController.convertClaim(lstClaim[0].id);
        WOD_ClaimQuickActionController.convertClaim(lstClaim[2].id);
        WOD_ClaimQuickActionController.convertClaim(lstClaim[3].id);
        lstClaim[5].WOD_2__Claim_Status__c = 'Claim';
        update lstClaim[5];
        WOD_ClaimQuickActionController.convertClaim(lstClaim[5].id);
        Test.stopTest();
          
    }
    Private static testMethod void testConvertClaimInternational(){
        Test.startTest();
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount3','','Warranty Account');
        insert acc;
        
        WOD_2__Business_Category_Configuration__c bcc = new WOD_2__Business_Category_Configuration__c();
        bcc.Name = 'Roofing';
        insert bcc;
        
        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        insert product;
        WOD_2__Warranty_Code__c wc = WOD_TestDataFactory.createWarrantyCode('test Warr Code',product.id);
        insert wc;
        
        WOD_2__Claim__c clm = WOD_TestDataFactory.CreateClaim('International','International',acc.id,'Roofing');
        clm.Address_1__c='ewewew';    
        clm.Install_Date__c = Date.today();
        clm.WOD_2__BusinessCategory__c = bcc.id;
        insert clm;
        
        WOD_ClaimQuickActionController.convertClaim(clm.id);
        
        // International Roofing Claim
        clm.WOD_2__Warranty_Product__c = product.id;
        clm.Install_Date__c = Date.today();
        clm.Primary_Defect_Code__c = wc.id;
        clm.Product_Group__c = 'Roofing';
        clm.Quantity__c = 2;
        update clm;
        
        String res1 = WOD_ClaimQuickActionController.convertClaim(clm.id);
        
        
        // Set Claim Status as Pre-Claim
        clm.WOD_2__Claim_Status__c = 'Pre-Claim';
        update clm;
        String res2 = WOD_ClaimQuickActionController.convertClaim(clm.id);
        Test.stopTest();
        
    }
    Private static testMethod void testConvertClaimExtWarranty(){  
        Test.startTest();
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount4','','Warranty Account');
        insert acc;
        
        WOD_2__Business_Category_Configuration__c bcc = new WOD_2__Business_Category_Configuration__c();
        bcc.Name = 'Roofing';
        insert bcc;
        
        WOD_2__Claim__c clm = WOD_TestDataFactory.CreateClaim('Commercial_Extended_Warranty_NDL','Commercial_Extended_Warranty_NDL',acc.id,'Roofing');
        clm.Address_1_BL__c='ge63';
        clm.Install_Date__c = Date.today();
        clm.WOD_2__BusinessCategory__c = bcc.id;
        clm.WOD_2__Claim_Status__c = 'Claim';
        insert clm;
        
        String res1 = WOD_ClaimQuickActionController.convertClaim(clm.id);
        clm.WOD_2__Claim_Status__c = 'Pre-Claim';
        update clm;
        String res2 = WOD_ClaimQuickActionController.convertClaim(clm.id);
        system.assertEquals('', res1);
        system.assertEquals('', res2);
        Test.stopTest();
     
    }
    Private static testMethod void testConvertClaimProfileVal(){ 
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='Warranty Admin Siding']; 
        UserRole usrRole = [SELECT Name FROM UserRole WHERE Name='Warranty Admin Siding']; 
        User usr = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', ProfileId = p.Id,UserRoleId= usrRole.id,WOD_2__Business_Units__c='Siding',
                            Sales_Org__c='1502',TimeZoneSidKey='America/Los_Angeles', UserName='12standard02user@testorg.com');
        insert usr; 
        system.runAs(usr){
            // Create Account record
            
            Account acc  = WOD_TestDataFactory.createAccount('TestAccount5','','Warranty Account');
            insert acc;
            
            // Create Claim records
            
            WOD_2__Claim__c clm = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
            insert clm;

            String res1 = WOD_ClaimQuickActionController.convertClaimValidation('shortterm',clm.id);
            String res2 =  WOD_ClaimQuickActionController.convertClaimValidation('',clm.id);
            system.assertEquals('Convert claim is allowed for Roofing only', res1);
            system.assertEquals('Convert claim is allowed for Roofing only', res2);
            Test.stopTest();
        }
    }
     @isTest
    static void testConvertClaimValidation1() {
        Test.startTest();
        // Retrieve the test claim
        //WOD_2__Claim__c testClaim = [SELECT Id FROM WOD_2__Claim__c where WOD_2__Claim_Type__c='Short Term' LIMIT 1];
        // Set the current user context to tech services user
        User techServicesUser = [SELECT Id FROM User WHERE Alias = 'tsinuser' LIMIT 1];
        System.runAs(techServicesUser) {
            Account acc  = WOD_TestDataFactory.createAccount('TestAccounttttttt2','','Warranty Account');
            insert acc;
            
            WOD_2__Claim__c testClaim = new WOD_2__Claim__c(
            Customer__c =acc.id,
            Business_Units__c = 'Roofing',
            WOD_2__Claim_Status__c = 'Pre-Claim',
            Sales_Org__c = '1501'
        );
        insert testClaim;
            String result = WOD_ClaimQuickActionController.convertClaimValidation('shortterm', testClaim.Id);
            result = WOD_ClaimQuickActionController.convertClaimValidation('standard', testClaim.Id);
        }
        Test.stopTest();
    }

    @isTest
    static void testConvertClaimValidation() {
        List<WOD_2__Claim__c> testClaim = [SELECT Id FROM WOD_2__Claim__c where WOD_2__Claim_Type__c='Short Term' LIMIT 1];
        User techServicesUser = [SELECT Id FROM User WHERE Alias = 'tsuser' LIMIT 1];
        User warrantyAdminRoofingUser = [SELECT Id FROM User WHERE Alias = 'wauser' LIMIT 1];
        User systemAdminUser = [SELECT Id FROM User WHERE Alias = 'sauser' LIMIT 1];
        // Set the current user context to tech services user
        System.runAs(techServicesUser) {
            // Test for 'shortterm' conversion
            String result = WOD_ClaimQuickActionController.convertClaimValidation('shortterm', testClaim[0].Id);
            
            // Test for 'standard' conversion
            result = WOD_ClaimQuickActionController.convertClaimValidation('standard', testClaim[0].Id);
            //Test.stopTest();
        }
        List<WOD_2__Claim__c> testClaim1 = [SELECT Id FROM WOD_2__Claim__c where WOD_2__Claim_Type__c='Short Term' LIMIT 1];
            testClaim1[0].Business_Units__c = 'Roofing';
            testClaim1[0].WOD_2__Claim_Status__c = 'Claim';
            testClaim1[0].Sales_Org__c = '1501';
        update testClaim1;
        System.runAs(techServicesUser) {
            // Test for 'shortterm' conversion
            String result = WOD_ClaimQuickActionController.convertClaimValidation('shortterm', testClaim1[0].Id);
            
            // Test for 'standard' conversion
            result = WOD_ClaimQuickActionController.convertClaimValidation('standard', testClaim1[0].Id);
            //Test.stopTest();
        }
        List<WOD_2__Claim__c> testClaim2 = [SELECT Id FROM WOD_2__Claim__c where WOD_2__Claim_Type__c='Short Term' LIMIT 1];
            testClaim2[0].Business_Units__c = 'Roofing';
            testClaim2[0].WOD_2__Claim_Status__c = 'Claim';
            testClaim2[0].Sales_Org__c = '';
            update testClaim2;
        }
     @istest
        static void testSidingClaim(){
        Test.startTest();
        Account acc  = WOD_TestDataFactory.createAccount('TestAccount3','','Warranty Account');
        insert acc;
        
        WOD_2__Business_Category_Configuration__c bcc = new WOD_2__Business_Category_Configuration__c();
        bcc.Name = 'Roofing';
        insert bcc;
        
        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        insert product;
        WOD_2__Warranty_Code__c wc = WOD_TestDataFactory.createWarrantyCode('test Warr Code',product.id);
        insert wc;
        
        WOD_2__Claim__c clm = WOD_TestDataFactory.CreateClaim('International','International',acc.id,'Siding');
        clm.Address_1__c='ewewew';    
        clm.Install_Date__c = Date.today();
        clm.WOD_2__BusinessCategory__c = bcc.id;
        clm.Business_Units__c = 'Siding';
        insert clm;
        
        WOD_ClaimQuickActionController.convertClaim(clm.id);
        
        // International Roofing Claim
        clm.WOD_2__Warranty_Product__c = product.id;
        clm.Install_Date__c = Date.today();
        clm.Primary_Defect_Code__c = wc.id;
       // clm.Product_Group__c = 'Siding';
        clm.Quantity__c = 2;
        clm.Sales_Org__c = '1502';
        clm.OwnershipType__c = 'First';
        update clm;
        
        String res1 = WOD_ClaimQuickActionController.convertClaim(clm.id);
        //System.assertEquals('', res1);
        
        // Set Claim Status as Pre-Claim
        clm.WOD_2__Claim_Status__c = 'Pre-Claim';
        update clm;
        String res2 = WOD_ClaimQuickActionController.convertClaim(clm.id);
        Test.stopTest();
        
    }
        Private static testMethod void testConvertClaim1(){
        Test.startTest();
        //WOD_2__Warranty_Product__c product = [Select id from WOD_2__Warranty_Product__c];
        
        //WOD_2__Warranty_Code__c wc = [Select id from WOD_2__Warranty_Code__c];
        
        List<WOD_2__Business_Category_Configuration__c> lstBCC = [Select id,Name from WOD_2__Business_Category_Configuration__c order by createddate asc];
        List<WOD_2__Claim__c> lstClaim = [Select id,WOD_2__Claim_Type__c,WOD_2__Claim_Status__c,Business_Units__c from WOD_2__Claim__c order by createddate desc];
   
        lstClaim[0].WOD_2__BusinessCategory__c = lstBCC[1].id;
        lstClaim[0].WOD_2__Claim_Status__c = 'Pre-Claim';
        //lstClaim[0].WOD_2__Warranty_Product__c = product.id;
        lstClaim[0].Install_Date__c = Date.today();
        //lstClaim[0].Primary_Defect_Code__c = wc.id;
        lstClaim[0].Product_Group__c = 'Solar';

        
        lstClaim[1].WOD_2__BusinessCategory__c = lstBCC[1].id;
        lstClaim[1].WOD_2__Claim_Status__c = 'Pre-Claim';
        //lstClaim[1].WOD_2__Warranty_Product__c = product.id;
        lstClaim[1].Proof_of_Purchase__c = Date.today()-12;
        lstClaim[1].Property_Type__c = 'Residential';
        lstClaim[1].Building_Type__c = 'Single Family Home'; 
        lstClaim[1].Install_Date__c = Date.today();
        //lstClaim[1].Primary_Defect_Code__c = wc.id;
        lstClaim[1].Product_Group__c = 'Solar';
        lstClaim[1].Quantity__c = 2;
        lstClaim[1].Building_Type__c = 'Other';
        lstClaim[1].OwnershipType__c = 'Second';
        
        lstClaim[2].WOD_2__BusinessCategory__c = lstBCC[0].id;
        lstClaim[2].WOD_2__Claim_Status__c = 'Pre-Claim';
        //lstClaim[2].WOD_2__Warranty_Product__c = product.id;
        lstClaim[2].Proof_of_Purchase__c = Date.today()-12;
        lstClaim[2].Property_Type__c = 'Residential';
        lstClaim[2].Building_Type__c = 'Single Family Home'; 
        lstClaim[2].Install_Date__c = Date.today();
        //lstClaim[2].Primary_Defect_Code__c = wc.id;
        lstClaim[2].Product_Group__c = 'Millwork';
        lstClaim[2].Quantity__c = 2;
        lstClaim[2].Building_Type__c = 'Other';
        lstClaim[2].OwnershipType__c = 'First';
        lstClaim[2].Division_Code__c = '';
        
        lstClaim[3].WOD_2__BusinessCategory__c = lstBCC[1].id;
        lstClaim[3].WOD_2__Claim_Status__c = 'Pre-Claim';
        //lstClaim[3].WOD_2__Warranty_Product__c = product.id;
        lstClaim[3].Install_Date__c = Date.today();
        //lstClaim[3].Primary_Defect_Code__c = wc.id;
        lstClaim[3].Product_Group__c = 'Solar';
        lstClaim[3].Quantity__c = 2;
        lstClaim[3].Building_Type__c = 'Other';
        lstClaim[3].OwnershipType__c = 'First';
        lstClaim[3].Property_Type__c = 'Residential';

        lstClaim[5].WOD_2__Claim_Status__c = 'Pre-Claim';
        lstClaim[5].Install_Date__c = Date.today();
        lstClaim[5].WOD_2__BusinessCategory__c = lstBCC[0].id;
        //lstClaim[5].WOD_2__Warranty_Product__c = product.id;
        lstClaim[5].Install_Date__c = Date.today();
        //lstClaim[5].Primary_Defect_Code__c = wc.id;
        lstClaim[5].Product_Group__c = 'Siding';

        update lstClaim;
        
        String res1 = WOD_ClaimQuickActionController.convertClaim(lstClaim[0].id);
        system.assertEquals('Please fill all the fields listed in Product Details Section', res1);
        String res2 = WOD_ClaimQuickActionController.convertClaim(lstClaim[1].id);
        system.assertNotEquals('', res2);
        String res3 = WOD_ClaimQuickActionController.convertClaim(lstClaim[2].id);
       // system.assertEquals('success', res3);
        String res4 = WOD_ClaimQuickActionController.convertClaim(lstClaim[3].id);
        system.assertNotEquals('', res4);
        String res5 =  WOD_ClaimQuickActionController.convertClaim(lstClaim[5].id);
        system.assertNotEquals('success', res5);


        
        WOD_ClaimQuickActionController.convertClaim(lstClaim[0].id);
        WOD_ClaimQuickActionController.convertClaim(lstClaim[2].id);
        WOD_ClaimQuickActionController.convertClaim(lstClaim[3].id);
        lstClaim[5].WOD_2__Claim_Status__c = 'Claim';
            
        lstClaim[5].WOD_2__Claim_Type__c = 'International';
        update lstClaim[5];
        WOD_ClaimQuickActionController.convertClaim(lstClaim[5].id);
        Test.stopTest();
          
    }
}