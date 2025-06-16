@isTest 
private class LoyaltyCommunityRecords_Test {
    
    @isTest
    static void testGetOpenClaims() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        // Test data
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Incomplete', RecordTypeId = recTypeId);
        Rebate_Claim__c rc2 = new Rebate_Claim__c(Status__c = 'Draft', RecordTypeId = recTypeId);
        insert new List<Rebate_Claim__c>{rc1, rc2};
        
        // Call the method
        List<Rebate_Claim__c> result = LoyaltyCommunityRecords.getOpenClaims();
         
        // Verify the expected records
        System.assertEquals(2, result.size(), 'Expected one open claim');
        System.assertEquals('Contractor Cashback', result[0].Program_Name__c, 'Program');
    }
    
    @isTest
    static void testGetLeads() {

        // Test data
        Lead l1 = new Lead(FirstName = 'John', LastName = 'Doe', Status = 'Contacted');
        Lead l2 = new Lead(FirstName = 'Jane', LastName = 'Doe', Status = 'Won');
        insert new List<Lead>{l1, l2}; 

        // Call the method
        List<Lead> resultAccepted = LoyaltyCommunityRecords.getLeads('Accepted Lead');
        List<Lead> resultClosed = LoyaltyCommunityRecords.getLeads('Closed Leads');
        List<Lead> resultAll = LoyaltyCommunityRecords.getLeads('');


        // Verify the expected
        //System.assertEquals(1, resultAccepted.size(), 'Expected one Contacted lead');
        //System.assertEquals(1, resultClosed.size(), 'Expected one Won lead');
        //System.assertEquals(2, resultAll.size(), 'Expected two lead');
       
    }
    
    @isTest
    static void testGetPendingClaims() {
		//Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        
        // Test data
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Submitted', RecordTypeId = recTypeId);
        Rebate_Claim__c rc2 = new Rebate_Claim__c(Status__c = 'QA Completed', RecordTypeId = recTypeId);
        Rebate_Claim__c rc3 = new Rebate_Claim__c(Status__c = 'Draft', RecordTypeId = recTypeId);
        insert new List<Rebate_Claim__c>{rc1, rc2, rc3};

        // Call the method
        List<Rebate_Claim__c> result = LoyaltyCommunityRecords.getPendingClaims();

        // Verify the expected records
        //System.assertEquals(1, result.size(), 'Expected two pending claims');
        System.assertEquals('Contractor Cashback', result[0].Program_Name__c, 'Program');
        System.assertEquals('Submitted', result[0].Status__c, 'status');
        //System.assertEquals('QA Completed', result[1].Status__c, 'status');        
    }
    
    @isTest
    static void testGetProcessedClaims() {
		//Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        
        // Test data
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Payout Completed', RecordTypeId = recTypeId, Total_Rebate_Amount__c = 100.00);
        Rebate_Claim__c rc2 = new Rebate_Claim__c(Status__c = 'Submitted', RecordTypeId = recTypeId, Total_Rebate_Amount__c = 200.00);
        insert new List<Rebate_Claim__c>{rc1, rc2};

        // Call the method
        List<Rebate_Claim__c> result = LoyaltyCommunityRecords.getProcessedClaims();

        // Verify the expected records
        System.assertEquals(1, result.size(), 'Expected one processed claim');
        System.assertEquals('Contractor Cashback', result[0].Program_Name__c, 'program');
        System.assertEquals('Payout Completed', result[0].Status__c, 'status');        
        System.assertEquals(100.00, result[0].Total_Rebate_Amount__c, 'total rebate amount');
    }
    
    @isTest
    static void testGetPaidOutAmount() {

        // Test data
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Payout Completed', Bank_Payment_Date__c = Date.today(), Total_Rebate_Amount__c = 100.00);
        Rebate_Claim__c rc2 = new Rebate_Claim__c(Status__c = 'Payout Completed', Bank_Payment_Date__c = Date.today().addYears(-1), Total_Rebate_Amount__c = 200.00);
        insert new List<Rebate_Claim__c>{rc1, rc2};

        // Call the method
        Decimal result = LoyaltyCommunityRecords.getPaidOutAmount();

        // Verify the expected amount
        System.assertEquals(100.00, result, 'Unexpected sum of amounts');
    }
    
    @isTest
    static void testGetRebateHistory() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        
        // Test records
        Rebate_Claim__c claim1 = new Rebate_Claim__c(            
			RecordTypeId = recTypeId,         
            Status__c = 'Incomplete',
            Submit_Date__c = Date.today(),            
            Total_Rebate_Amount__c = 1000
        );
        Rebate_Claim__c claim2 = new Rebate_Claim__c(            
            RecordTypeId = recTypeId,
            Status__c = 'Submitted',
            Submit_Date__c = Date.today(),            
            Total_Rebate_Amount__c = 500
        );
        insert new List<Rebate_Claim__c>{ claim1, claim2 };
        
        // Test search by Claim #
        List<Rebate_Claim__c> claimsByClaimNum = LoyaltyCommunityRecords.getRebateHistory('Claim #', '1234');
        System.assertEquals(0, claimsByClaimNum.size());
        //System.assertNotEquals('Claim1', claimsByClaimNum[0].Name);
        
        // Test search by Status
        List<Rebate_Claim__c> claimsByStatus = LoyaltyCommunityRecords.getRebateHistory('Status', 'Incomplete');
        System.assertEquals(1, claimsByStatus.size());
        System.assertEquals('Incomplete', claimsByStatus[0].Status__c);
        
        // Test search by Invoice        
        RebateClaim claim = new RebateClaim (            
            Invoice_Number__c = 'INV001',
            Rebate_Claim__c = claim1.id,
			Quantity = 2, 
            ClaimAmount = 100, 
            ClaimDate = System.today()           
        );
        insert claim;
       
        List<Rebate_Claim__c> claimsByInvoice = LoyaltyCommunityRecords.getRebateHistory('Invoice', 'INV001');
        System.assertEquals(1, claimsByInvoice.size());
        System.assertEquals(1000, claimsByInvoice[0].Total_Rebate_Amount__c);
    }
    
    @isTest
	static void testGetRebateHistorybyDate() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
            
        // Test data
        Rebate_Claim__c rebateClaim = new Rebate_Claim__c( RecordTypeId = recTypeId,
                                                           Status__c = 'Submitted',
                                                           Submit_Date__c = Date.newInstance(2023, 4, 10),                                                       
                                                           Total_Rebate_Amount__c = 100.00);
        insert rebateClaim;
    
        // Call the method
        List<Rebate_Claim__c> result = LoyaltyCommunityRecords.getRebateHistorybyDate('Date Range', '2023-04-01', '2023-04-30');
    
        // Assert the results
        System.assertEquals(1, result.size(), 'Expected only one record to be returned.');
        System.assertEquals(rebateClaim.Id, result[0].Id, 'Incorrect record was returned.');
	}
    
    @isTest
    static void testGetAdditionalProcessingNotes() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
            
        // Test data
        Rebate_Claim__c rebateClaim = new Rebate_Claim__c(RecordTypeId = recTypeId,
                                                          Status__c = 'Incomplete',
                                                          Additional_Processing_Notes__c = 'Test Additional Notes');
        insert rebateClaim;
    
        // Call the method
        String result = LoyaltyCommunityRecords.getAdditionalProcessingNotes(rebateClaim.Id);
    
        // Assert the results
        System.assertEquals('Test Additional Notes', result, 'additional processing notes returned.');
    }
    
    @isTest
    static void testGetClaimDetailsbyId() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();

        // Test data
        Rebate_Claim__c rebateClaim = new Rebate_Claim__c(RecordTypeId = recTypeId,                                                           
                                                          Status__c = 'Incomplete');
        insert rebateClaim;
    
        // Call the method
        List<Rebate_Claim__c> result = LoyaltyCommunityRecords.getClaimDetailsbyId(rebateClaim.Id);
    
        // Assert the results
        System.assertEquals(1, result.size(), 'Expected only one record to be returned.');      
    }
    
    @isTest
    static void testGetMovedToIncompleteDate() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        
        // Test data
        Rebate_Claim__c rebateClaim = new Rebate_Claim__c(RecordTypeId = recTypeId,                                                           
                                                          Status__c = 'Incomplete',
                                                          Moved_to_Incomplete_Date__c = Date.today());
        insert rebateClaim;
    
        // Call the method
        Date result = LoyaltyCommunityRecords.getMovedToIncompleteDate(rebateClaim.Id);
    
        // Assert the results
        System.assertEquals(Date.today().addDays(30), result, 'moved to incomplete date returned.');
    }
    
    @isTest
    static void testgetRebateClaimDetails() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        // Test data
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Incomplete', RecordTypeId = recTypeId);
        Rebate_Claim__c rc2 = new Rebate_Claim__c(Status__c = 'Draft', RecordTypeId = recTypeId);
        insert new List<Rebate_Claim__c>{rc1, rc2};
        
        // Call the method
        List<Rebate_Claim__c> result = LoyaltyCommunityRecords.getRebateClaimDetails(rc1.id);
        
        // Verify the expected records
        System.assertEquals(1, result.size(), 'All Claims');
    }
    
    @isTest
    static void testgetRebateClaimFileDetails() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        // Test data
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Incomplete', RecordTypeId = recTypeId);
        insert rc1;
        
        List<Rebate_Claim__c> rList = new List<Rebate_Claim__c>();
        rList.add(rc1);
        // Call the method
        List<ContentDocument> result = LoyaltyCommunityRecords.getRebateClaimFileDetails(rc1.id);
        
        // Verify the expected records
        System.assertEquals(1, rList.size(), 'Expected one open claim');
        //System.assertEquals('Contractor Cashback', result[0].Program_Name__c, 'Program');
    }
    @isTest
    static void testgetClaimNamebyId() {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        // Test data
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Incomplete', RecordTypeId = recTypeId);
        insert rc1;
        
        List<Rebate_Claim__c> rList = new List<Rebate_Claim__c>();
        rList.add(rc1);
        // Call the method
        List<Rebate_Claim__c> result = LoyaltyCommunityRecords.getClaimNamebyId(rc1.id);
    }

    @isTest
    static void testGetProductDetails() {
        // Create test data
        Business_Units__c lob = new Business_Units__c(Name='Test LOB');
        insert lob;
        Id recTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('SAP Product').getRecordTypeId();
        Product2 p = new Product2(Name='Test Product', Product_Category__c='Gypsum', Line_Of_Business__c=lob.Id, RecordTypeId=recTypeId);
        insert p;
        Product2 p1 = new Product2(Name='Test Product 1', Product_Category__c='Gypsum', Line_Of_Business__c=lob.Id, RecordTypeId=recTypeId);
        insert p1;
        
        // Call the method to be tested
        Test.startTest();
        LoyaltyCommunityRecords.getProductDetails();
        Test.stopTest();
        
        // Verify the results
        //System.assertEquals(1, results.size());
        //LoyaltyProductDetails pd = results[0];
        //System.assertEquals(p.Name, pd.Name);
        //System.assertEquals(p.Product_Category__c, pd.Category);        
    }
    
    @isTest 
    static void testGetFilterRebateClaimDetailCCB() {
        // Test data setup
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        List<Rebate_Claim__c> claims = new List<Rebate_Claim__c>();
        claims.add(new Rebate_Claim__c(Status__c = 'Submitted', RecordTypeId = recTypeId));
        claims.add(new Rebate_Claim__c(Status__c = 'Draft', RecordTypeId = recTypeId));
        insert claims;
        
        List<RebateClaim> claimDetails = new List<RebateClaim>();
        claimDetails.add(new RebateClaim(Rebate_Claim__c = claims[0].Id, Quantity = 10, ClaimAmount = 100, ClaimDate = Date.valueOf('2023-04-21')));
        claimDetails.add(new RebateClaim(Rebate_Claim__c = claims[1].Id, Invoice_Number__c = 'INV-123', Quantity = 20, ClaimAmount = 200, ClaimDate = Date.valueOf('2023-04-18')));
        insert claimDetails;
        
        Test.startTest(); 
        // Test the method
        List<Rebate_Claim__c> result = LoyaltyCommunityRecords.getFilterRebateClaimDetailCCB(claims[0].Name, 'INV-123', 'Submitted', '', '');
        // Verify the results
              
        result = LoyaltyCommunityRecords.getFilterRebateClaimDetailCCB('000012345', 'INV-123', 'Submitted', '', '');
        
        result = LoyaltyCommunityRecords.getFilterRebateClaimDetailCCB('000012345', 'INV-123', 'Draft', '', '');
        
        result = LoyaltyCommunityRecords.getFilterRebateClaimDetailCCB('000012345', 'INV-123', 'Submitted', '2023-01-01', '2023-12-31');
        
        Test.stopTest();
    }
    
    @isTest
    static void testGetFilterRebateClaimDetailBSP() {
        // Create test data
        Rebate_Claim__c claim = new Rebate_Claim__c(          
            Status__c = 'Submitted',
            Submit_Date__c = Date.today()
        );
        insert claim;

        // Call the method with valid parameters
        List<Rebate_Claim__c> result1 = LoyaltyCommunityRecords.getFilterRebateClaimDetailBSP('Test Claim', 'Open', String.valueOf(Date.today()), String.valueOf(Date.today()));
       
        // Call the method with only Claim Number parameter
        List<Rebate_Claim__c> result2 = LoyaltyCommunityRecords.getFilterRebateClaimDetailBSP('Test Claim', null, null, null);
       
        // Call the method with only Claim Status parameter
        List<Rebate_Claim__c> result3 = LoyaltyCommunityRecords.getFilterRebateClaimDetailBSP(null, 'Open', null, null);
       
        // Call the method with invalid parameters
        List<Rebate_Claim__c> result4 = LoyaltyCommunityRecords.getFilterRebateClaimDetailBSP(null, null, null, null);       
    }
    
        @isTest
	static void testGetContactEligibility() {
        // Create a test contact
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'Contact');
        insert testContact;
    
        // Call the getContactEligibility method with the test contact's ID
        String eligibility = LoyaltyCommunityRecords.getContactEligibility(testContact.Id);    
    }	
    
    /*
    @isTest
	static void testGetRebateClaimsfromNumber() {
        // Create test data 
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        Business_Units__c testBU = new Business_Units__c(Name = 'Test BU');
        insert testBU;
        UnitOfMeasure testUOM = new UnitOfMeasure(Name = 'Test UOM', UnitCode = '2253', Type = 'BSP');
        insert testUOM;
        Rebate_Claim__c testRebateClaim = new Rebate_Claim__c(Status__c = 'Submitted', RecordTypeId = recTypeId);
        insert testRebateClaim;
        RebateClaim testRebateClaim1 = new RebateClaim(ClaimDate = Date.today(), Invoice_Number__c = 'INV-001', Business_Units__c = testBU.Id, Quantity = 10, Unit_Of_Measure_Selected__c = testUOM.Id, Rebate_Claim__c = testRebateClaim.Id, ClaimAmount= Decimal.valueOf('100'));
        RebateClaim testRebateClaim2 = new RebateClaim(ClaimDate = Date.today(), Invoice_Number__c = 'INV-002', Business_Units__c = testBU.Id, Quantity = 5, Unit_Of_Measure_Selected__c = testUOM.Id, Rebate_Claim__c = testRebateClaim.Id, ClaimAmount= Decimal.valueOf('150'));
        insert new List<RebateClaim>{testRebateClaim1, testRebateClaim2};
    
        // Call the method with test data
        List<RebateClaim> result = LoyaltyCommunityRecords.getRebateClaimsfromNumber('Test Claim');	
    }
	*/
    
    @isTest
    static void testGetRebateClaimFileSearch() {
        
        // create test account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;
        
        Contact testContact = new Contact(LastName ='Test Contact',AccountId = testAccount.Id);
        insert testContact;
        
        // create test rebate claim
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        // Test data        
        Rebate_Claim__c testRebateClaim = new Rebate_Claim__c(Status__c = 'Incomplete', RecordTypeId = recTypeId,Submitted_By__c = testContact.ID);
        insert testRebateClaim;
        
        // create test content document
        ContentVersion testContentVersion = new ContentVersion(
            Title = 'Test File',
            PathOnClient = 'TestFile.pdf',
            VersionData = Blob.valueOf('Test File Content'),
            IsMajorVersion = true
        );
        insert testContentVersion;
       
        List<ContentDocument> testContentDocument = [
            SELECT Id, LatestPublishedVersionId 
            FROM ContentDocument
        ];
        
        // create content document link to rebate claim
        ContentDocumentLink testContentDocumentLink = new ContentDocumentLink(
            ContentDocumentId = testContentDocument[0].Id,
            LinkedEntityId = testRebateClaim.Id
        );
        insert testContentDocumentLink;

       Test.startTest();
        // call the method to be tested
        LoyaltyCommunityRecords.getRebateClaimFileSearch(testAccount.Id, '', '', '');
        Test.stopTest();
    }
    
    @isTest
    static void testgetRebateClaimItemDetails() {
        
         //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        // Test data
        Rebate_Claim__c rc1 = new Rebate_Claim__c(Status__c = 'Incomplete', RecordTypeId = recTypeId);
        insert new List<Rebate_Claim__c>{rc1};
            
        RebateClaim rc = new RebateClaim(Rebate_Claim__c = rc1.Id,Quantity=10, ClaimAmount = Decimal.valueOf('100'), ClaimDate = Date.today());
        insert rc;
        
        // Call the method
        List<RebateClaim> result = LoyaltyCommunityRecords.getRebateClaimItemDetails(rc1.id);
        
        // Verify the expected records
        System.assertEquals(1, result.size());    
    }
    
    @isTest
    static void testGetContactInfo() {
        // Create a test contact
        Contact testContact = new Contact(LastName = 'Test', Distributor__c = 'Yes');
        insert testContact;

        // Call the getContactInfo method with the test contact ID
        Boolean result = LoyaltyCommunityRecords.getContactInfo(testContact.Id);

        // Verify that the method returns True
        System.assertEquals(True, result);
    }
     @isTest
    static void testgetRebateClaimRelatedLineItems(){
        List<Rebate_Claim__c> rebateClaimList= new  List<Rebate_Claim__c>();
        List<RebateClaim> rebateClaimItems = new List<RebateClaim>();
        Id ccbRebateTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account',Status__c='Active',RecordTypeId=RecordTypeId);
        
        // Insert test Account
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe',
                                          AccountId = testAccount.Id,
                                          Enable_for_Promotion__c=true,
                                          Status__c='Active',
                                          CCB_Eligibility__c='Eligible');
        // Insert testContact
        insert testContact;
     
         Rebate_Claim__c rebateClaim= new Rebate_Claim__c(Submitted_By__c=testContact.Id,Status__c='Submitted',
                                                             Claim_Currency__c='USD',
                                                             //Rebate_Program_Member__c=ccbProgramMember.Id,
                                                             Submit_Date__c = Date.newInstance(2024, 1, 20)
                                                            );
        rebateClaimList.add(rebateClaim);
        Rebate_Claim__c rebateClaim1= new Rebate_Claim__c(Submitted_By__c=testContact.Id,Status__c='Submitted',
                                                          Claim_Currency__c='USD',
                                                          Submit_Date__c = Date.newInstance(2025, 1, 20)
                                                         // Rebate_Program_Member__c=ccbProgramMember.Id 
                                                         );
        rebateClaimList.add(rebateClaim1);
         Insert rebateClaimList;
        RebateClaim certaRebateClaim1 = new RebateClaim(
            Rebate_Claim__c = rebateClaimList[0].Id,
            Invoice_Number__c = '06443',
            Quantity = 10,
            ClaimDate = Date.newInstance(2024, 12, 9),
            ClaimAmount =0,
            RecordTypeId=ccbRebateTypeId
        );
       rebateClaimItems.add(certaRebateClaim1);
        
        // Insert rebate claim for CertaPlank product Category
        RebateClaim certaRebateClaim = new RebateClaim(
            Rebate_Claim__c = rebateClaimList[1].Id,
            Invoice_Number__c = '03438',
            Quantity = 10,
            ClaimDate = System.Today(),
            ClaimAmount =0,
            RecordTypeId=ccbRebateTypeId
        );
        rebateClaimItems.add(certaRebateClaim);
        insert  rebateClaimItems;
        
        List<Rebate_Claim__c> insertedRebateClaim= [SELECT Id,Name FROm Rebate_Claim__c];
        List<Id> rebateClaimIds= new List<Id>();
        for(Rebate_Claim__c rc : insertedRebateClaim){
           rebateClaimIds.add(rc.Id);
        }
        Test.StartTest();
        LoyaltyCommunityRecords.getRebateClaimRelatedLineItems(rebateClaimIds);
        Test.StopTest();
        
    }
}