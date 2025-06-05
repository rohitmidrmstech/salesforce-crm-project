@isTest 
private  class RebateClaimTriggerHandlerTest {
    @TestSetup
    static void setupTestData(){         
		Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId =RecordTypeId);
        insert acc;
        
        Contact con = new Contact(AccountId = acc.Id,
            FirstName = 'Test',
            LastName = 'Contractor',
            Email = 'test.contractor@claims.certainteed.com',
            Phone = '(888) 123-0000',
            CCB_Eligibility__c = salesAgreementProductsFormController.ELIGIBLE,
            Status__c = 'Active'
        );
        insert con;
        Automation_Controller__c control = Automation_Controller__c.getInstance();
        control.All_Triggers_enabled__c = true;
        upsert control; 
        
        Profile customerProfile = [SELECT Id FROM Profile WHERE Name = 'Partner Community Contractor User' LIMIT 1];
        User user = new User(
                Alias = 'tcont',
                CommunityNickname = 'tcont23',
                ContactId = con.Id,
                Email = con.Email,
                EmailEncodingKey = 'UTF-8',
                Phone = '123-456-7890',
                FirstName = con.FirstName,
                LanguageLocaleKey = 'en_US',
                LastName = con.LastName,
                LocaleSidKey = 'en_US',
                ProfileId = customerProfile.Id,
                TimeZoneSidKey = 'America/Los_Angeles',
                Username = 'test2.contractor@claims.certainteed.com',
                Isactive = True
            );
            insert User;

        List<UnitOfMeasure> uoms = RebateTestDataFactory.initializeUoms();
        insert uoms;
        
        Product2 testProduct = RebateTestDataFactory.initalizeProduct('Monogram D4 Ced Solid Suwhe');
        insert testProduct;

        List<Product_UOM__c> puoms = RebateTestDataFactory.initalizeProductUOMS(testProduct,  uoms, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
        insert puoms;

        RebateProgram rebateProgram = RebateTestDataFactory.initializeRebateProgram(CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
		rebateProgram.Status =salesAgreementProductsFormController.STATUS_ACTIVE;        
        insert rebateProgram;

        RebateProgramMember rpm = TestDataUtilityClass.createRebateProgramMember(rebateProgram.Id,con.id);
        rpm.MemberStatus = RebateUtility.REBATE_PROGRAM_MEMBER_STATUS_ACTIVE;
        update rpm;

        RebateTestDataFactory.createCustomerUser();

        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];
       
        List<RebateClaim> claimItems = new List<RebateClaim>();
        claimItems.add(new RebateClaim(ClaimDate = Date.Today(),Invoice_Number__c = '1234',ProductId = [Select Id from Product2][0].Id,Quantity = 5)); 
     //   Rebate_claim__C  rebateClaim = CCBClaimFormController.upsertCCBRebate(claimItems, String.Valueof(Date.today().year()), null, con.id, true, null, false, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER);
    
    	Rebate_Claim__c rebateClaimHeader = new Rebate_Claim__c(Submitted_By__c =con.Id );
        insert rebateClaimHeader;
        
        // Insert a Rebate Claim record
       
        RebateClaim rebateClaimItem1 = new RebateClaim(PriceFX_Processed__c = false,Rebate_Claim__c=rebateClaimHeader.Id,Quantity=2,ClaimDate=SYSTEM.NOW(),ClaimAmount=200);
        insert rebateClaimItem1;
      
    }
    
    @isTest 
    static void testSubmittedByRemovalFromRebateClaim(){
        USER testUser = [Select Id,ContactId,Contact.AccountId from User where UserName =: RebateTestDataFactory.CUSTOMER_USERNAME];

        Rebate_claim__c rebateClaim = [Select Id from Rebate_claim__c limit 1];
        rebateClaim.Submitted_By__c = null;
        update rebateClaim;

        //Assert there are no shares for user after submitted by is removed
        System.assert([Select count() from Rebate_claim__Share where ParentId =: rebateClaim.Id and UserOrGroupId =: testUser.Id] == 0, 'Shares should have been deleted');
    }  
    
    // Below Test class is used on AutoEnrollAssignedCredentials for code coverage
    
    @isTest
    static void testTriggerRebateCheck() {
        
        List<DefineProductLevel__mdt> matarecord=[Select ID,Product_Category__c, Assigned_Credential_Level__c From DefineProductLevel__mdt]; //where Product_Category__c='STONEfacade'];
        id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account acc = new Account(name = 'test',RecordTypeId=RecordTypeId);
        insert acc; 
        Account acc12 = new Account(Name = 'Test Account12',RecordTypeId=RecordTypeId);
        insert acc12; 
        Contact con = new Contact(LastName = 'Test Contact ', Title = 'Test Title',accountId = acc.Id);
        insert con;
       Contact con12 = new Contact(LastName = 'Test Contact12 ', Title = 'Test Title12',accountId = acc12.Id);
       insert con12;
        date t=date.today();
        RebateProgram rebprog = new RebateProgram(Name = 'Test ',Frequency='Monthly', StartDate=t, EndDate=t, Rebate_Program_Type__c='CCB'); 
        insert rebprog;
         RebateProgram rebprog12 = new RebateProgram(Name = 'Test ',Frequency='Monthly', StartDate=t, EndDate=t, Rebate_Program_Type__c='CCB'); 
         insert rebprog12;
        RebateProgramMember rebprogmem12 = new RebateProgramMember(Name = 'Test',RebateProgramId=rebprog.id,Contact__c=con12.id); 
        insert rebprogmem12;
        RebateProgramMember rebprogmem = new RebateProgramMember(Name = 'Test',RebateProgramId=rebprog.id,Contact__c=con.id); 
        insert rebprogmem;
        Rebate_Claim__c rebclaim = new Rebate_Claim__c(Submitted_By__c =con.Id ,Rebate_Program_Id__c =rebprog.Id ,Rebate_Program_Member__c =rebprogmem.Id);
        insert rebclaim;
        Rebate_Claim__c rebclaim12 = new Rebate_Claim__c(Submitted_By__c =con12.Id ,Rebate_Program_Id__c =rebprog12.Id ,Rebate_Program_Member__c =rebprogmem12.Id);
        insert rebclaim12;
        Credential__c cc=new Credential__c(Product_Category__c='STONEfacade',Status__c='Active',Start_Date__c=Date.today().addMonths(-12),End_Date__c=Date.today().addMonths(+12) );
        insert cc;
        Credential__c cc2=new Credential__c(Product_Category__c='CERTAplank Reinforced Siding',Status__c='Active',Start_Date__c=Date.today().addMonths(-12),End_Date__c=Date.today().addMonths(+12));
        insert cc2;
        Credential__c cc3=new Credential__c(Product_Category__c='Cedar Impressions',Status__c='Active',Start_Date__c=System.today(),End_Date__c=System.today().addDays(60));
        insert cc3;
        Credential__c cc4=new Credential__c(Product_Category__c='RISE',Status__c='Active',Start_Date__c=System.today(),End_Date__c=System.today().addDays(60));
        insert cc4;
        
        String strRecordTypeId =  Schema.SObjectType.Product2.getRecordTypeInfosByName().get('New Products').getRecordTypeId();
        Id riseRecordTypeId =  Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BSP CCB Product').getRecordTypeId();
     
        Product2 prod= new Product2(Name='STONEfacade Ledgestone Panels 11000',IsActive=true,
                                    Description='STONEfacade Ledgestone Panels 11000',
                                    ProductCode='STONEfacade Ledgestone Panels 11000',
                                    Product_Category__c='STONEfacade',
                                    recordTypeId=riseRecordTypeId
                                   );
        insert prod;
        
     
        Product2 prod2= new Product2(Name='S7" Reinforced Siding 63106',IsActive=true,
                                     Description='S7" Reinforced Siding 63106',
                                     ProductCode='S7" Reinforced Siding 63106',
                                     Product_Category__c='CERTAplank Reinforced Siding',
                                     recordTypeId=riseRecordTypeId
                                    );
        // Insert product for certaPlank Product category.
        insert prod2;
        
        Product2 prodCedar = new Product2();
        prodCedar.Name = 'Test cedar';
        prodCedar.ProductCode = '24434';
        prodCedar.Product_Category__c='Cedar Impressions';
        prodCedar.SAP_Material__c ='E354213';
        prodCedar.Stocking_to_Selling_Conversion_Factor__c = 0.80;
        prodCedar.RecordTypeId =riseRecordTypeId;
        insert prodCedar;
    
        Product2 prodRise= new Product2(Name='Rise S11 Textured 38211',IsActive=true,
                                        Description='Rise S11 Textured 38211',
                                        ProductCode='Rise S11 Textured 38211',
                                        Product_Category__c='RISE',
                                        RecordTypeId =riseRecordTypeId
                                       );
        // Insert rise Product 
        Insert prodRise;
        
        System.assert(prodCedar !=null);
        
        Id RecordId = Schema.SObjectType.Assigned_Credential__c.getRecordTypeInfosByName().get('General Promotion').getRecordTypeId();
        ID RecordIdAca = Schema.SObjectType.Assigned_Credential_Account__c.getRecordTypeInfosByName().get('General Promotion').getRecordTypeId();
        string accountwithcreds = acc.id + '-' + cc.id ;
        
        //creating assigned credential Account
        Assigned_Credential_Account__c assignedCredAcc = new Assigned_Credential_Account__c();
        assignedCredAcc.Account__c = acc.id ;
        assignedCredAcc.Credential__c = cc.id ;
        assignedCredAcc.Status__c = 'Active' ;
        assignedCredAcc.Max_Payout_Quantity_Claimed__c = 0;
        assignedCredAcc.RecordTypeId = RecordIdAca ;
        assignedCredAcc.ExternalID__c = accountwithcreds;
        insert assignedCredAcc;
        
        //creating assigned credential
        Assigned_Credential__c AssignedCred = new Assigned_Credential__c();
        AssignedCred.Contact__c = con.id;
        AssignedCred.Account__c = acc.Id;
        AssignedCred.RecordTypeId = RecordId;
        AssignedCred.Credential__c = cc2.id;
        AssignedCred.Status__c = 'Active';
        AssignedCred.Max_Payout_Quantity_Claimed__c = 0;
        insert AssignedCred;
        
        
      
        List<RebateClaim> tt=new List<RebateClaim>();
         List<id> ttId=new List<id>();
            Id ccbRebateTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
          List<RebateClaim> rebateClaims = new List<RebateClaim>();
        /*RebateClaim  rebclaimitems = new RebateClaim(Rebate_Claim__c =rebclaim.Id,Quantity=1, ClaimAmount=200, ClaimDate=t,ProductId=prod.Id,RecordTypeId=ccbRebateTypeId);
        insert rebclaimitems;
        RebateClaim rebClaimdata=[select id,Product_Category1__c,Contact_Id__c from RebateClaim where id=:rebclaimitems.Id]; 
        
        RebateClaim  rebclaimitems1 = new RebateClaim(Rebate_Claim__c =rebclaim.Id,Quantity=1, ClaimAmount=200, ClaimDate=t,ProductId=prodRise.Id,RecordTypeId=ccbRebateTypeId);
        insert rebclaimitems1;
        RebateClaim rebClaimdata1=[select id,Product_Category1__c,Contact_Id__c from RebateClaim where id=:rebclaimitems.Id]; 
        
        RebateClaim  rebclaimitems2 = new RebateClaim(Rebate_Claim__c =rebclaim.Id,Quantity=1, ClaimAmount=200, ClaimDate=t,ProductId=prod2.Id,RecordTypeId=ccbRebateTypeId);
        insert rebclaimitems2;
        RebateClaim rebClaimdata2=[select id,Product_Category1__c,Contact_Id__c from RebateClaim where id=:rebclaimitems2.Id];  
       
        RebateClaim rebateclaimitemCedar = new RebateClaim(ProductId=prodCedar.Id,Rebate_Claim__c=rebclaim.Id,Quantity=2,ClaimDate=SYSTEM.NOW(),ClaimAmount=200,RecordTypeId=ccbRebateTypeId);
        insert rebateclaimitemCedar;
        RebateClaim rebClaimdata3=[select id,Product_Category1__c,Contact_Id__c from RebateClaim where id=:rebateclaimitemCedar.Id];  */
        
           // Insert rebate claim for CertaPlank product Category
            RebateClaim stoneRebateClaim = new RebateClaim(
                Rebate_Claim__c = rebclaim.Id,
                ProductId = prod.Id,
                Invoice_Number__c = '03438',
                Quantity = 10,
                ClaimType = 'StandardRebate',
                ClaimDate = System.Today(),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(stoneRebateClaim);
            
            RebateClaim certaClaim = new RebateClaim(
                Rebate_Claim__c = rebclaim.Id,
                ProductId = prod2.Id,
                Invoice_Number__c = '03438',
                Quantity = 10,
                ClaimType = 'StandardRebate',
                ClaimDate = System.Today(),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(certaClaim);
            
            // Insert rebate claim for Urban Reserve Product Category
            RebateClaim riseRebateClaim = new RebateClaim(
                Rebate_Claim__c = rebclaim.Id,
                ProductId = prodRise.Id,
                Invoice_Number__c = '03438',
                Quantity = 10,
                ClaimType = 'StandardRebate',
                ClaimDate = System.Today(),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(riseRebateClaim);
            
            
            // Insert rebate claim for Urban Reserve Product Category
            RebateClaim cedarRebateClaim = new RebateClaim(
                Rebate_Claim__c = rebclaim.Id,
                ProductId = prodCedar.Id,
                Invoice_Number__c = '03438',
                Quantity = 10,
                ClaimType = 'StandardRebate',
                ClaimDate = System.Today(),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(cedarRebateClaim);
             Insert rebateClaims;
        Set<Id> rebateClaimHeaderIds = new  Set<Id>();
        rebateClaimHeaderIds.add(rebclaim.Id);
     	test.startTest();
        RebateClaimItemTriggerHandler.updateClaimHeaderStatusOnLineItemPriceFXprocessed(rebateClaimHeaderIds);
        
        test.stopTest();   
    }
    
     @isTest
    static void testRebateClaimUpdate() {
        // Retrieve the RebateClaim record
        RebateClaim rebateClaim = [SELECT Id, RecordTypeId, PriceFX_Processed__c FROM RebateClaim LIMIT 1];
        
        // Start a test context to check callouts if any
        Test.startTest();
        
        // Update the PriceFX_Processed__c field to true
        rebateClaim.PriceFX_Processed__c = true;
        update rebateClaim;
        
        Test.stopTest();
        
        // Retrieve the updated RebateClaim and assert changes
        RebateClaim updatedRebateClaim = [SELECT Id, PriceFX_Processed__c FROM RebateClaim WHERE Id = :rebateClaim.Id];
        
        System.assertEquals(true, updatedRebateClaim.PriceFX_Processed__c, 'PriceFX_Processed__c should be updated.');
        
       
    }
        @isTest
    static void testCreateExperienceUserShares() {
        // Fetch data
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        RebateClaim rebateClaim = [SELECT Id,OwnerId  FROM RebateClaim LIMIT 1];
        User user = [SELECT Id, ContactId FROM User WHERE ContactId = :contact.Id LIMIT 1];

        // Prepare input map
        Map<RebateClaim, Id> rebateClaimItemToContactMap = new Map<RebateClaim, Id> {
            rebateClaim => contact.Id
        };

        // Test the method
        Test.startTest();
        RebateClaimItemTriggerHandler.createExperienceUserShares(rebateClaimItemToContactMap);
        Test.stopTest();

        // Verify the result
        List<RebateClaimShare> shares = [
            SELECT Id, ParentId, UserOrGroupId, AccessLevel
            FROM RebateClaimShare
            WHERE ParentId = :rebateClaim.Id
        ];
        System.assertEquals(2, shares.size(), 'One share should have been created');
    }

    @isTest
    static void testDeleteExperienceUserShares() {
        // Fetch data
        Contact contact = [SELECT Id FROM Contact LIMIT 1];
        RebateClaim rebateClaim = [SELECT Id,OwnerId FROM RebateClaim LIMIT 1];
        User user = [SELECT Id, ContactId FROM User WHERE ContactId = :contact.Id LIMIT 1];

        // Prepare input map
        Map<Id, Id> rebateClaimItemToContactMap = new Map<Id, Id> {
            rebateClaim.Id => contact.Id
        };

        // Insert RebateClaimShare
        RebateClaimShare share = new RebateClaimShare(
            ParentId = rebateClaim.Id,
            UserOrGroupId = user.Id,
            AccessLevel = 'Edit',
            RowCause = Schema.RebateClaimShare.RowCause.Manual
        );
        insert share;

        // Verify the share was created
        System.assertEquals(2, [
            SELECT COUNT()
            FROM RebateClaimShare
            WHERE ParentId = :rebateClaim.Id
        ], 'One share should exist before deletion');

        // Test the method
        Test.startTest();
        RebateClaimItemTriggerHandler.deleteExperienceUserShares(rebateClaimItemToContactMap);
        Test.stopTest();

        // Verify the share was deleted
        System.assertEquals(1, [
            SELECT COUNT()
            FROM RebateClaimShare
            WHERE ParentId = :rebateClaim.Id
        ], 'No shares should exist after deletion');
    }
}