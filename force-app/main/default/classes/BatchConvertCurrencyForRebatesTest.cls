@isTEST
private class BatchConvertCurrencyForRebatesTest {
    @TestSetup
    static void setupTestData(){
        Automation_Controller__c control = Automation_Controller__c.getInstance();
        control.All_Triggers_enabled__c = true;
        upsert control;  
        
        Exchange_Rate__c exchangeRate = RebateTestDataFactory.initializeExchangeRate(BatchConvertCurrencyForRebates.CAD_CURRENCY);
        insert exchangeRate;
        
        RebateProgram ccbProgram = new RebateProgram(Name = 'Contractor Cash Back',
                                                     StartDate =Date.newInstance(Date.today().year(), 1, 1),  
                                                     EndDate =Date.newInstance(Date.today().year(), 12, 31),
                                                     Frequency='Annually',
                                                     Status='Active',Rebate_Program_Type__c='CCB',
                                                     No_of_Grace_Days_for_Claim__c=60,Country__c='CAN');
        // Insert Rebate program for current year CCB
        insert ccbProgram;
        
        id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test Account',Status__c='Active',RecordTypeId=RecordTypeId);
        
        // Insert test Account
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe',
                                          AccountId = testAccount.Id,
                                          Enable_for_Promotion__c=true,
                                          Status__c='Active',
                                          CCB_Eligibility__c='Eligible',
                                         MailingCountry = 'Canada');
        // Insert testContact
        insert testContact;
        
        Credential__c sidingCredentialed= new Credential__c(Name='Siding5Star',Status__c='Active',
                                                            Credential_Type__c='Siding Credential',
                                                            Rebate_Benefits__c='Yes'
                                                           );
        // Insert Siding 5 star credentialed.
        Insert sidingCredentialed;
        
        // creating member for CCB-2024
        RebateProgramMember ccbProgramMember = new RebateProgramMember(
            Name = 'Contractor Cash Back -'+ Date.today().Year() +'-test contact',
            RebateProgramId = ccbProgram.Id, // Linking the Program
            AccountId = testAccount.Id, // Linking the Account
            Contact__c = testContact.Id, // Linking the Contact
            MemberStatus = 'Active'
        );
        insert ccbProgramMember;
        
        
        Business_Units__c roofingbusinessUnit= new Business_Units__c(Name='Roofing',Company_Code__c='1000',Sales_Org__c='1501');
        // Insert businessUnit                                               
        Insert roofingbusinessUnit;
        
        UnitOfMeasure unitMeasure= new UnitOfMeasure(Name='SQ',UnitCode='SQFT',
                                                     Description='SQ',Type='Area');
        // Insert unitMeasure
        Insert unitMeasure;
        
        ProgramRebateType  roofingCCBRebatetType= new ProgramRebateType(Name='Roofing-Contractor Cash Back - 2024',
                                                                        RebateProgramId=ccbProgram.Id,
                                                                        Business_Units__c=roofingbusinessUnit.Id,
                                                                        Status='Active',
                                                                        CalculationType='AggregateBased',
                                                                        RebateMeasureType='AmountperUnit',
                                                                        CalcObjectId='9N13w000000000ACAQ',
                                                                        AggregateObjectName='RebateMemberProductAggregate',
                                                                        MeasureField='TotalQuantity',
                                                                        BenefitQualifierField='TotalQuantity'
                                                                       ); 
        // Insert ProgramRebateType for CCB Roofing.  
        Insert roofingCCBRebatetType;
        
        Id bspccbRecordTypeId =  Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BSP CCB Product').getRecordTypeId();
        
        Product2 ventProd= new Product2(Name='Rolled Ridge Vents',IsActive=true,
                                        Description='Rolled Ridge Vents',
                                        ProductCode='Rolled Ridge Vents',
                                        Base_Unit_Of_Measure__c=unitMeasure.Id,
                                        Line_Of_Business__c=roofingbusinessUnit.Id,
                                        Product_Category__c='Ventilation',
                                        recordTypeId=bspccbRecordTypeId
                                       );
        // Insert product for Ventilation Product category.
        Insert ventProd;
        
        // Insert Product UOM for Ventilation Product.
        Product_UOM__c ventProdUom= new Product_UOM__c(Name='Rolled Ridge Vents',Product__c=ventProd.Id,
                                                       Unit_of_Measure__c=unitMeasure.Id,
                                                       Applicable_Program__c='CCB;BSP');
        
        // Insert Product UOM for Ventilation Product Category.
        Insert ventProdUom;
        
        ProgramRebateTypeBenefit ventprodRebateBenefit= new ProgramRebateTypeBenefit(Name='Rolled Ridge Vents - $5',
                                                                                         Status='Active',
                                                                                         Benefit_Type__c='Regular',
                                                                                         Promo_Name__c='Ventilation Promo',
                                                                                         Product_Category__c='Ventilation',
                                                                                         ProgramRebateTypeId=roofingCCBRebatetType.Id,
                                                                                         MinimumQualifyingValue=1401,
                                                                                         MaximumQualifyingValue=1403,
                                                                                         ProductId=ventProd.Id,
                                                                                         Unit_of_Measure__c=unitMeasure.Id,
                                                                                         BenefitValue=10,
                                                                                         EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                         EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                        );
            // Insert  Regular benefit record for Ventilation  Product.
            insert ventprodRebateBenefit;
        
        UnitOfMeasureConversion ventUomConversion = new UnitOfMeasureConversion(Name='Rolled Ridge Vents- SQ to SQ',Product__c=ventProd.Id,
                                                                                    FromUnitOfMeasureId=unitMeasure.Id,
                                                                                    ToUnitOfMeasureId=unitMeasure.Id,
                                                                                    Applicable_Program__c='CCB;BSP',
                                                                                    ConversionFactor=1,
                                                                                    Program_Year__c= String.ValueOf(Date.today().year())
                                                                                   );
            // Insert uom conversation for certa Plank product
            insert ventUomConversion;
        
        RebateProgramPayoutPeriod rebateProgramPayoutPeriod = new RebateProgramPayoutPeriod(
            Name = 'Test Period',
            StartDate = Date.today().addDays(-5),
            EndDate = Date.today().addDays(3),
            RebateProgramId = ccbProgram.id,
            Status = 'Active',
            TransactionGracePeriodDate = Date.today().addDays(3),
            PayoutCalculationDate = Date.today().addDays(3)
        );
        insert rebateProgramPayoutPeriod;
        
        
        

    }
    
    @isTest
    static void testBatchWithCanadianContact(){
        Id payoutPeriodId = [Select Id from RebateProgramPayoutPeriod][0].Id;
        Id rebateProgramMemberId = [Select Id from RebateProgramMember][0].Id;
        Id programRebateTypeId = [Select Id from ProgramRebateType][0].Id;
        id contactId = [select id from contact][0].Id;
        id unitofmeasureId = [SELECT id FROM unitofmeasure][0].id;
        id productId = [Select Id,Name from Product2][0].id;
        id pcid = [select Id FROM ProgramRebateType][0].id;
        id buid = [select id from Business_Units__c][0].id;
        system.debug('contactId'+contactId);
        
                    
        system.debug('ProductId' + [Select Id,Name from Product2]);
        
        Id ccbRebateTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();

        List<RebateClaim> claimItems = new List<RebateClaim>();
        RebateClaim ventLineItem= new RebateClaim(    ProductId=productId,
                                                      Invoice_Number__c='03438',
                                                      Quantity=10,
                                                      Unit_Of_Measure_Selected__c=unitofmeasureId,
                                                      Business_Units__c=buid,
                                                      Product_Category__c=pcid,
                                                      ClaimDate=System.Today(),
                                                      ClaimAmount=0,
                                                      RecordTypeId=ccbRebateTypeId
                                                     );
            claimItems.add(ventLineItem);
        
        RebateClaim ventLineItem2= new RebateClaim(   ProductId=productId,
                                                      Invoice_Number__c='03438',
                                                      Quantity=20,
                                                      Unit_Of_Measure_Selected__c=unitofmeasureId,
                                                      Business_Units__c=buid,
                                                      Product_Category__c=pcid,
                                                      ClaimDate=System.Today(),
                                                      ClaimAmount=0,
                                                      RecordTypeId=ccbRebateTypeId
                                                     );
            claimItems.add(ventLineItem2);
        
        Rebate_claim__C  rebateClaim = CCBClaimFormController.upsertCCBRebate(claimItems, String.Valueof(Date.today().year()), null, contactId, true, null, false, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER, null);
        System.assert(rebateClaim.Id != null, 'Rebate Claim Record must be created');
        system.debug('Rebate claim items'+ claimItems);
        system.debug('Rebate claim'+rebateClaim);
        
        String initData =  CCBClaimFormController.getInitializationData(rebateClaim.Id);
        System.assert(initData != null, 'Init Data must be available');
        
        RebateMemberProductAggregate rebateMemAgg = RebateTestDataFactory.initializeRebateMemberProductAggregate(payoutPeriodId, rebateProgramMemberId, rebateClaim.Id, programRebateTypeId);
        insert rebateMemAgg;
        
        Rebate_Claim_Aggregate__c claimAggregate = RebateTestDataFactory.initializeRebateClaimAggregate(rebateClaim.Id, payoutPeriodId);
        insert claimAggregate;
        
        //  Id rebateClaimItemId = [Select Id from RebateClaim][0].Id;
        // TransactionJournal journal = RebateTestdataFactory.initializeTransactionJournal(rebateClaim.Id, rebateClaimItemId, rebateProgramMemberId);
        // insert journal;
        
        
        Id ccbRebateclaimTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();

        //update status to QA Completed first
        rebateClaim.Status__c = 'QA Completed';
        rebateClaim.RecordTypeId = ccbRebateclaimTypeId;
        rebateClaim.Rebate_Program_Member__c = rebateProgramMemberId;
        update rebateClaim;
        
        Id rebateClaimItemId = [Select Id from RebateClaim][0].Id;
        id journalId = [SELECT Id FROM TransactionJournal][0].Id ;
        RebateMemberAggregateItem aggregateItem = RebateTestdataFactory.initializeRebateMemberAggregateItem(rebateMemAgg.Id, rebateClaim.Id, rebateClaimItemId, journalId);
        insert aggregateItem;
        
        //update rebate to Approved and populate amount
        rebateClaim.Total_Rebate_Amount__c = 500;
        rebateClaim.Status__c = BatchConvertCurrencyForRebates.CLAIM_REBATE_APPROVED_STATUS;
        update rebateClaim;
        system.debug('final rebate claim216'+rebateClaim);
        
        Test.startTest();
        Database.executeBatch(new BatchConvertCurrencyForRebates(), 5);
        Test.stopTest();
        
        rebateClaim = [Select Id, Total_Rebate_Amount__c, Total_rebate_amt_USD_before_conv__c, Status__c, Claim_Currency__c, Applied_Exchange_Rate__c 
                       from Rebate_claim__C where Id =: rebateClaim.Id];
        system.debug('final rebate claim'+rebateClaim);
        System.assert(rebateClaim.Applied_Exchange_Rate__c != null, 'Applied Exchange Rate lookup should be populated for Canadian rebates');
        System.assert(rebateClaim.Total_Rebate_Amount__c == 625, 'Converted value must be 500/.8 (.8 is vaue used for test currency exchange)');
        System.assert(rebateClaim.Total_rebate_amt_USD_before_conv__c == 500);
        System.assert(rebateClaim.Claim_Currency__c == BatchConvertCurrencyForRebates.CAD_CURRENCY);
        System.assert(rebateClaim.Status__c == BatchConvertCurrencyForRebates.STATUS_AFTER_CURRENCY_CONVERSION);
    }
    
    @isTest
    static void testScheduler(){
        Rebate_Settings__c settings = Rebate_Settings__c.getInstance();
        settings.Currency_Conversion_Batch_Size__c = 5;
        upsert settings;
        
        Test.startTest();
        BatchConvertCurrencyForRebates currencyConversyBatch = new BatchConvertCurrencyForRebates ();   
        String cron = '0 0 23 * * ?';        
        system.schedule('Test Schedule', cron, currencyConversyBatch);
        Test.stopTest();
    }
}