@isTest
public class RevalidateRebateQuickActionTest {
    
    @isTest
    static void testProcessQAComplete(){
        Automation_Controller__c control = Automation_Controller__c.getInstance();
        control.All_Triggers_enabled__c = true;
        upsert control;
        
        
        // Insert Rebate program for current year CCB
        RebateProgram ccbProgram = new RebateProgram(Name = 'Contractor Cash Back',
                                                     StartDate =Date.today().addMonths(-12), 
                                                     EndDate =Date.today().addMonths(12),
                                                     Frequency='Annually',
                                                     Status='Active',Rebate_Program_Type__c='CCB',
                                                     No_of_Grace_Days_for_Claim__c=60,Country__c='US');
        // Insert Rebate program for current year CCB
        insert ccbProgram;
        
        RebateProgram canadaCCBProgram = new RebateProgram(Name = 'Canada Contractor Cash Back',
                                                           StartDate =Date.today().addMonths(-12), 
                                                           EndDate =Date.today().addMonths(12),
                                                           Status='Active',Rebate_Program_Type__c='CCB',
                                                           Frequency='Annually',
                                                           No_of_Grace_Days_for_Claim__c=60,Country__c='CAN');
        // Insert Canada CCB Rebate Program 
        insert canadaCCBProgram;
        
        Account testAccount = new Account(Name = 'Test Account',Status__c='Active');
        
        // Insert test Account
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe',
                                          AccountId = testAccount.Id,
                                          Enable_for_Promotion__c=true,
                                          Status__c='Active',
                                          CCB_Eligibility__c='Eligible');
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
            Name = 'Contractor Cash Back - 2024 -test contact',
            RebateProgramId = ccbProgram.Id, // Linking the Program
            AccountId = testAccount.Id, // Linking the Account
            Contact__c = testContact.Id, // Linking the Contact
            MemberStatus = 'Active'
        );
        // Insert ccbProgramMember for CCB-2024
        insert ccbProgramMember;
        
        
        // creating Business unit for  Roofing
        Business_Units__c roofingbusinessUnit= new Business_Units__c(Name='Roofing',Company_Code__c='1000',Sales_Org__c='1501');
        // Insert businessUnit                                               
        Insert roofingbusinessUnit;
        
        
        // creating Business unit for Siding
        Business_Units__c sidingBusinessUnit= new Business_Units__c(Name='Siding',Company_Code__c='1100',Sales_Org__c='1502');
        // Insert sidingBusinessUnit                                               
        Insert sidingBusinessUnit;
        
        // creating UnitOfMeasure as a Box. 
        UnitOfMeasure unitMeasure= new UnitOfMeasure(Name='SQ',UnitCode='SQFT',
                                                     Description='SQ',Type='Area');
        // Insert unitMeasure
        Insert unitMeasure;
        
        // Insert UnitOfMeasure for RISE products
        UnitOfMeasure riseUnitMeasure= new UnitOfMeasure(Name='EA',UnitCode='EA',
                                                         Description='EA',Type='BSP');
        // Insert riseUnitMeasure
        Insert riseUnitMeasure;
        
        ProgramRebateType sidingCCBRebateType;
        //creating Roofing rebate type under program. 
        sidingCCBRebateType= new ProgramRebateType(Name='Siding-Contractor Cash Back -2024',
                                                   RebateProgramId=ccbProgram.Id,
                                                   Business_Units__c=sidingBusinessUnit.Id,
                                                   Status='Active',
                                                   CalculationType='AggregateBased',
                                                   RebateMeasureType='AmountperUnit',
                                                   CalcObjectId='9N13w000000000ACAQ',
                                                   AggregateObjectName='RebateMemberProductAggregate',
                                                   MeasureField='TotalQuantity',
                                                   BenefitQualifierField='TotalQuantity'
                                                  );        
        
        // Insert ProgramRebateType for CCB Siding.   
        Insert sidingCCBRebateType;
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
        
        ProgramRebateType  roofingCanadaRebateType= new ProgramRebateType(Name='roofing - Canada Contractor Cash Back - 2024',
                                                                          RebateProgramId=canadaCCBProgram.Id,
                                                                          Business_Units__c=roofingbusinessUnit.Id,
                                                                          Status='Active',
                                                                          CalculationType='AggregateBased',
                                                                          RebateMeasureType='AmountperUnit',
                                                                          CalcObjectId='9N13w000000000ACAQ',
                                                                          AggregateObjectName='RebateMemberProductAggregate',
                                                                          MeasureField='TotalQuantity',
                                                                          BenefitQualifierField='TotalQuantity'
                                                                         ); 
        // Insert ProgramRebateType for Canada Roofing.  
        Insert roofingCanadaRebateType;
        
        
        Product2 certaProd= new Product2(Name='S7" Reinforced Siding 63106',IsActive=true,
                                         Description='S7" Reinforced Siding 63106',
                                         ProductCode='S7" Reinforced Siding 63106',
                                         Base_Unit_Of_Measure__c=unitMeasure.Id,
                                         Line_Of_Business__c=sidingBusinessUnit.Id,
                                         Product_Category__c='CERTAplank Reinforced Siding',
                                          recordTypeId='0123w000001YemLAAS'
                                        );
        // Insert product for certaPlank Product category.
        Insert certaProd;
        
        Product_UOM__c certaProdUom= new Product_UOM__c(Name='CERTAplank S7" Reinforced Siding',Product__c=certaProd.Id,
                                                        Unit_of_Measure__c=unitMeasure.Id,
                                                        Applicable_Program__c='CCB;BSP');
        // Insert Product UOM for certa Plank Product.
        Insert certaProdUom;
        
        Product2 riseProduct= new Product2(Name='Rise S11 Textured 38211',IsActive=true,
                                           Description='Rise S11 Textured 38211',
                                           ProductCode='Rise S11 Textured 38211',
                                           Base_Unit_Of_Measure__c=riseUnitMeasure.Id,
                                           Line_Of_Business__c=sidingBusinessUnit.Id,
                                           Product_Category__c='RISE',
                                            recordTypeId='0123w000001YemLAAS'
                                          );
        // Insert rise Product 
        Insert riseProduct;
        
        // Creating product UOM  for RISE product Category
        Product_UOM__c riseProductUom= new Product_UOM__c(Name='Rise S11 Textured 38211',Product__c=riseProduct.Id,
                                                          Unit_of_Measure__c=riseUnitMeasure.Id,
                                                          Applicable_Program__c='CCB;BSP');
        // Insert Product UOM for RISE Product.
        Insert riseProductUom;
        
        /*  Product2 ventProd= new Product2(Name='Rolled Ridge Vents',IsActive=true,
Description='Rolled Ridge Vents',
ProductCode='Rolled Ridge Vents',
Base_Unit_Of_Measure__c=unitMeasure.Id,
Line_Of_Business__c=roofingbusinessUnit.Id,
Product_Category__c='Ventilation'
);
// Insert product for Ventilation Product category.
Insert ventProd;
Product_UOM__c ventProdUom= new Product_UOM__c(Name='Rolled Ridge Vents',Product__c=ventProd.Id,
Unit_of_Measure__c=unitMeasure.Id,
Applicable_Program__c='CCB;BSP');

// Insert Product UOM for Ventilation Product Category.
Insert ventProdUom;  */
        
        
        Product2 stoneFacadeProd= new Product2(Name='STONEfacade Ledgestone Panels 11000',IsActive=true,
                                               Description='STONEfacade Ledgestone Panels 11000',
                                               ProductCode='STONEfacade Ledgestone Panels 11000',
                                               Base_Unit_Of_Measure__c=unitMeasure.Id,
                                               Line_Of_Business__c=sidingBusinessUnit.Id,
                                               Product_Category__c='STONEfacade',
                                                recordTypeId='0123w000001YemLAAS'
                                              );
        // Insert product for STONEfacade Product category.
        Insert stoneFacadeProd;
        Product_UOM__c stoneFacadeProdUom= new Product_UOM__c(Name='STONEfacade Ledgestone Panels 11000',
                                                              Product__c=stoneFacadeProd.Id,
                                                              Unit_of_Measure__c=unitMeasure.Id,
                                                              Applicable_Program__c='CCB;BSP');
        
        // Insert Product UOM for STONEfacade Product Category.
        Insert stoneFacadeProdUom;
        
        ProgramRebateTypeBenefit regularCertaBenefit= new ProgramRebateTypeBenefit(Name='2024 S7" Reinforced Siding 63106 - $10 Regular',
                                                                                   Status='Active',
                                                                                   Benefit_Type__c='Regular',
                                                                                   Product_Category__c='CERTAplank Reinforced Siding',
                                                                                   ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                   MinimumQualifyingValue=883,
                                                                                   MaximumQualifyingValue=885,
                                                                                   ProductId=certaProd.Id,
                                                                                   Unit_of_Measure__c=unitMeasure.Id,
                                                                                   BenefitValue=10,
                                                                                   Stone_Facade_Benefit__c=10,
                                                                                   EffectiveStartDate=Date.today().addMonths(-12), 
                                                                                   EffectiveEndDate=Date.today().addMonths(12)
                                                                                  );
        // Insert  Regular benefit for certaPlank Product.
        Insert regularCertaBenefit;
        System.debug('regularCertaBenefit==>'+regularCertaBenefit);
        /*   ProgramRebateTypeBenefit promoCertaBenefit= new ProgramRebateTypeBenefit(Name='2024 S7" Reinforced Siding 63106 - $10 Promo',
Status='Active',
Benefit_Type__c='Promo',
Promo_Name__c='CERTAplank Reinforced Siding Promo',
Product_Category__c='CERTAplank Reinforced Siding',
ProgramRebateTypeId=sidingCCBRebateType.Id,
MinimumQualifyingValue=1133,
MaximumQualifyingValue=1135,
ProductId=certaProd.Id,
Unit_of_Measure__c=unitMeasure.Id,
BenefitValue=0,
Stone_Facade_Benefit__c=10,
EffectiveStartDate=Date.today().addMonths(-1), 
EffectiveEndDate=Date.today().addMonths(1)
);
// Insert  promo benefit for certaPlank Product.
Insert promoCertaBenefit;
System.debug('promoCertaBenefit==>'+promoCertaBenefit);  */
        
        ProgramRebateTypeBenefit credentialledCertaBenefit= new ProgramRebateTypeBenefit(Name='2024 S7" Reinforced Siding 63106 - $10 Credentialled',
                                                                                         Status='Active',
                                                                                         Benefit_Type__c='Credentialled',
                                                                                         Promo_Name__c='CERTAplank Reinforced Siding Promo',
                                                                                         Product_Category__c='CERTAplank Reinforced Siding',
                                                                                         ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                         MinimumQualifyingValue=1201,
                                                                                         MaximumQualifyingValue=1203,
                                                                                         ProductId=certaProd.Id,
                                                                                         Unit_of_Measure__c=unitMeasure.Id,
                                                                                         BenefitValue=0,
                                                                                         Credentialled_Benefit__c=sidingCredentialed.Id,
                                                                                         Additional_Dollar_Benefit__c=10,
                                                                                         EffectiveStartDate=Date.today().addMonths(-1), 
                                                                                         EffectiveEndDate=Date.today().addMonths(1)
                                                                                        );
        // Insert  Credentialled benefit record for certaPlank Product.
        Insert credentialledCertaBenefit;
        System.debug('credentialledCertaBenefit==>'+credentialledCertaBenefit);
        
        /*     ProgramRebateTypeBenefit ventprodRebateBenefit= new ProgramRebateTypeBenefit(Name='Rolled Ridge Vents - $5',
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
EffectiveStartDate=Date.today().addMonths(-1), 
EffectiveEndDate=Date.today().addMonths(1)
);
// Insert  Regular benefit record for Ventilation  Product.
Insert ventprodRebateBenefit;
System.debug('ventprodRebateBenefit==>'+ventprodRebateBenefit);  */
        
        // Insert Rebate Benefit type for RISE product as a Regular benefit.
        ProgramRebateTypeBenefit riseprodRebateBenefit= new ProgramRebateTypeBenefit(Name='Rise S11 Textured 38211- $5',
                                                                                     Status='Active',
                                                                                     Benefit_Type__c='Regular',
                                                                                     Promo_Name__c='Rise S11 Textured 38211 Promo',
                                                                                     Product_Category__c='RISE',
                                                                                     ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                     MinimumQualifyingValue=1501,
                                                                                     MaximumQualifyingValue=1503,
                                                                                     ProductId=riseProduct.Id,
                                                                                     Unit_of_Measure__c=riseUnitMeasure.Id,
                                                                                     BenefitValue=10,
                                                                                     EffectiveStartDate=Date.today().addMonths(-1), 
                                                                                     EffectiveEndDate=Date.today().addMonths(1)
                                                                                    );
        // Insert  Regular benefit record for RISE  Product.
        Insert riseprodRebateBenefit;
        
        // Insert Rebate Benefit type for RISE product as a Promo benefit.
        /*    ProgramRebateTypeBenefit riseprodPromoRebateBenefit= new ProgramRebateTypeBenefit(Name='Rise S11 Textured 38211- $5',
Status='Active',
Benefit_Type__c='Promo',
Promo_Name__c='Rise S11 Textured 38211 Promo',
Product_Category__c='RISE',
ProgramRebateTypeId=sidingCCBRebateType.Id,
MinimumQualifyingValue=1508,
MaximumQualifyingValue=1509,
ProductId=riseProduct.Id,
Unit_of_Measure__c=riseUnitMeasure.Id,
BenefitValue=0,
Stone_Facade_Benefit__c=10,
EffectiveStartDate=Date.today().addMonths(-1), 
EffectiveEndDate=Date.today().addMonths(1)
);
// Insert  Promo benefit record for RISE  Product.
Insert riseprodPromoRebateBenefit; */
        
        ProgramRebateTypeBenefit credentialledRiseBenefit= new ProgramRebateTypeBenefit(Name='Rise S11 Textured 38211- Credentialled',
                                                                                        Status='Active',
                                                                                        Benefit_Type__c='Credentialled',
                                                                                        Promo_Name__c='Rise S11 Textured 38211- Credentialled',
                                                                                        Product_Category__c='RISE',
                                                                                        ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                        MinimumQualifyingValue=1511,
                                                                                        MaximumQualifyingValue=1513,
                                                                                        ProductId=riseProduct.Id,
                                                                                        Unit_of_Measure__c=riseUnitMeasure.Id,
                                                                                        BenefitValue=0,
                                                                                        Credentialled_Benefit__c=sidingCredentialed.Id,
                                                                                        Additional_Dollar_Benefit__c=10,
                                                                                        EffectiveStartDate=Date.today().addMonths(-1), 
                                                                                        EffectiveEndDate=Date.today().addMonths(1)
                                                                                       );
        // Insert  Credentialled benefit record for RISE Product.
        Insert credentialledRiseBenefit;
        
        ProgramRebateTypeBenefit stoneFacadeRegularBenefit= new ProgramRebateTypeBenefit(Name='STONEfacade Ledgestone Panels 11000-Regular',
                                                                                         Status='Active',
                                                                                         Benefit_Type__c='Regular',
                                                                                         Promo_Name__c='STONEfacade Ledgestone Panels 11000 Regular',
                                                                                         Product_Category__c='STONEfacade',
                                                                                         ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                         MinimumQualifyingValue=1611,
                                                                                         MaximumQualifyingValue=1613,
                                                                                         ProductId=stoneFacadeProd.Id,
                                                                                         Unit_of_Measure__c=unitMeasure.Id,
                                                                                         BenefitValue=10,
                                                                                         Stone_Facade_Benefit__c=10,
                                                                                         EffectiveStartDate=Date.today().addMonths(-1), 
                                                                                         EffectiveEndDate=Date.today().addMonths(1)
                                                                                        );
        // Insert  Regular benefit record for Stone Facade Product.
        Insert stoneFacadeRegularBenefit;
        
        UnitOfMeasureConversion certaUomConversion = new UnitOfMeasureConversion(Name='CERTAplank S7" Reinforced Siding - SQ to SQ',Product__c=certaProd.Id,
                                                                                 FromUnitOfMeasureId=unitMeasure.Id,
                                                                                 ToUnitOfMeasureId=unitMeasure.Id,
                                                                                 Applicable_Program__c='CCB',
                                                                                 ConversionFactor=1,
                                                                                 Program_Year__c= String.ValueOf(Date.today().year())
                                                                                );
        // Insert uom conversation for certa Plank product
        Insert certaUomConversion;
        System.debug('certaUomConversion==>'+certaUomConversion);
        
        // Insert UOM conversion for RISE product Category
        UnitOfMeasureConversion riseUomConversion = new UnitOfMeasureConversion(Name='Rise S11 Textured 38211 EA to EA',Product__c=riseProduct.Id,
                                                                                FromUnitOfMeasureId=riseUnitMeasure.Id,
                                                                                ToUnitOfMeasureId=riseUnitMeasure.Id,
                                                                                Applicable_Program__c='CCB',
                                                                                ConversionFactor=1,
                                                                                Program_Year__c= String.ValueOf(Date.today().year())
                                                                               );
        // Insert uom conversation for certa Plank product
        Insert riseUomConversion;
        
        /*  UnitOfMeasureConversion ventUomConversion = new UnitOfMeasureConversion(Name='Rolled Ridge Vents- SQ to SQ',Product__c=ventProd.Id,
FromUnitOfMeasureId=unitMeasure.Id,
ToUnitOfMeasureId=unitMeasure.Id,
Applicable_Program__c='CCB;BSP',
ConversionFactor=1,
Program_Year__c= String.ValueOf(Date.today().year())
);
// Insert uom conversation for certa Plank product
Insert ventUomConversion;  */
        
        UnitOfMeasureConversion stoneFacadeUomConversion = new UnitOfMeasureConversion(Name='STONEfacade Ledgestone Panels 11000',
                                                                                       Product__c=stoneFacadeProd.Id,
                                                                                       FromUnitOfMeasureId=unitMeasure.Id,
                                                                                       ToUnitOfMeasureId=unitMeasure.Id,
                                                                                       Applicable_Program__c='CCB;BSP',
                                                                                       ConversionFactor=1,
                                                                                       Program_Year__c= String.ValueOf(Date.today().year())
                                                                                      );
        // Insert uom conversation for Stone Facade product.
        Insert stoneFacadeUomConversion;
        //  System.debug('ventUomConversion==>'+ventUomConversion);
        Credential__c certaCredential= new Credential__c(Name='CERTAplank',Status__c='Active',
                                                         Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=40,
                                                         Unit_of_Measure__c=unitMeasure.Id,
                                                         Product_Category__c='CERTAplank Reinforced Siding',
                                                         Start_Date__c=Date.newInstance(Date.today().year(), 1, 1),
                                                         End_Date__c=Date.newInstance(Date.today().year()+1, 12, 31)
                                                        );
        
        // Insert Credential for CertaPlank product Category
        Insert certaCredential;
        
        // Insert Credential for RISE product Category
        Credential__c riseCredential= new Credential__c(Name='RISE',Status__c='Active',                                                      
                                                        Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=500,
                                                        Unit_of_Measure__c=riseUnitMeasure.Id,
                                                        Product_Category__c='RISE',
                                                        Start_Date__c=Date.newInstance(Date.today().year(), 1, 1),
                                                        End_Date__c=Date.newInstance(Date.today().year()+1, 12, 31)
                                                       );
        
        // Insert Credential for CertaPlank product Category
        Insert riseCredential;
        
        // Insert Credential for StoneFacade product Category
        Credential__c stoneFacadeCredential= new Credential__c(Name='STONEfacade',Status__c='Active',
                                                               Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=5,
                                                               Unit_of_Measure__c=unitMeasure.Id,
                                                               Product_Category__c='STONEfacade',
                                                               Start_Date__c=Date.newInstance(Date.today().year(), 1, 1),
                                                               End_Date__c=Date.newInstance(Date.today().year()+1, 12, 31)
                                                              );
        
        // Insert Credential for CertaPlank product Category
        Insert stoneFacadeCredential;
        System.debug('stoneFacadeCredential==>'+stoneFacadeCredential);
        
        
        list<Rebate_Claim__c> newRebateClaims = new list<Rebate_Claim__c>();
        Rebate_Claim__c rebateClaim= new Rebate_Claim__c(Submitted_By__c=testContact.Id,Status__c='Submitted',
                                                         Claim_Currency__c='USD',
                                                         Submit_Date__c = Date.newInstance(2024, 8, 20),
                                                         Rebate_Program_Member__c=ccbProgramMember.Id
                                                        );
        
        // Insert rebateClaim
        // Insert rebateClaim;
        newRebateClaims.add(rebateClaim);
        
        Rebate_Claim__c rebateClaim2= new Rebate_Claim__c(Submitted_By__c=testContact.Id,Status__c='Submitted',
                                                          Claim_Currency__c='USD',
                                                          Submit_Date__c = Date.newInstance(2025, 1, 20),
                                                          Rebate_Program_Member__c=ccbProgramMember.Id
                                                         );
        
        // Insert rebateClaim
        // Insert rebateClaim2;
        newRebateClaims.add(rebateClaim2);
        insert newRebateClaims;
        //   test.setCreatedDate(rebateClaim.Id, DateTime.newInstance(2025, 1, 27, 0, 0, 0));
        List<RebateClaim> rebateClaims = new List<RebateClaim>();
        Id stExam = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        
        // Insert rebate claim for CertaPlank product Category
        RebateClaim certaRebateClaim = new RebateClaim(
            Rebate_Claim__c = newRebateClaims.get(0).Id,
            ProductId = certaProd.Id,
            Invoice_Number__c = '03439',
            Quantity = 10,
            Unit_Of_Measure_Selected__c = unitMeasure.Id,
            Business_Units__c = sidingBusinessUnit.Id,
            Product_Category__c = sidingCCBRebateType.Id,
            //   ClaimType = 'StandardRebate',
            ClaimDate = System.Today(),
            ClaimAmount =0,
            RecordTypeId=stExam
        );
        insert certaRebateClaim;
        
        DPE_Base_Calculation__c certaDPEBase = new DPE_Base_Calculation__c(
            Rebate_Claim_Item__c = certaRebateClaim.id,
            Quantity__c = 10,
            Quantity_Converted__c = 10,
            Unit_of_Measure__c = unitMeasure.Id
        );
        insert certaDPEBase;
        
        
        // Insert rebate claim for RISE product Category
        RebateClaim riseRebateItem = new RebateClaim(
            Rebate_Claim__c = newRebateClaims.get(0).Id,
            ProductId = riseProduct.Id,
            Invoice_Number__c = '03439',
            Quantity = 10,
            Unit_Of_Measure_Selected__c = riseUnitMeasure.Id,
            Business_Units__c = sidingBusinessUnit.Id,
            Product_Category__c = sidingCCBRebateType.Id,  // Second Product Rebate Type
            //   ClaimType = 'StandardRebate',
            ClaimDate = System.Today(),
            ClaimAmount = 0,
            RecordTypeId=stExam
        );
        insert riseRebateItem;
        
        
        
        // Insert rebate claim for StoneFacade product Category
        RebateClaim stoneFacadeRebateItem = new RebateClaim(
            Rebate_Claim__c = newRebateClaims.get(0).Id,
            ProductId = stoneFacadeProd.Id,
            Invoice_Number__c = '03439',
            Quantity = 10,
            Unit_Of_Measure_Selected__c = unitMeasure.Id,
            Business_Units__c = sidingBusinessUnit.Id,
            Product_Category__c = sidingCCBRebateType.Id,  // Second Product Rebate Type
            //   ClaimType = 'StandardRebate',
            ClaimDate = System.Today(),
            ClaimAmount = 0,
            RecordTypeId=stExam
        );
        insert stoneFacadeRebateItem;
        
        DPE_Base_Calculation__c stoneFacadeDPEBase = new DPE_Base_Calculation__c(
            Rebate_Claim_Item__c = stoneFacadeRebateItem.id,
            Quantity__c = 10,
            Quantity_Converted__c = 10,
            Unit_of_Measure__c = unitMeasure.Id
        );
        insert stoneFacadeDPEBase;
        system.debug('stoneFacadeDPEBase==='+stoneFacadeDPEBase);
        
        
        // Insert rebate claim for Ventilation product Category
        /*   RebateClaim ventLineItem= new RebateClaim(Rebate_Claim__c=rebateClaim.Id,
ProductId=ventProd.Id,
Invoice_Number__c='03439',
Quantity=10,
Unit_Of_Measure_Selected__c=unitMeasure.Id,
Business_Units__c=roofingbusinessUnit.Id,
Product_Category__c=roofingCCBRebatetType.Id,
//     ClaimType='StandardRebate',
ClaimDate=System.Today(),
ClaimAmount=0,
RecordTypeId=stExam
);
insert ventLineItem;  */
        
        /*creating data for Certa plank as a Assigned Credential Account.
Assigned_Credential_Account__c certaAssignedCredentialAccount= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
Credential__c=certaCredential.Id,
Status__c='Active',
Max_Payout_Quantity_Claimed__c=0 
);
// Insert Assigned Credential for certaPlank
Insert certaAssignedCredentialAccount;
Assigned_Credential__c certaAssignedCred= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
RecordTypeId='0123w000001YemGAAS',
Credential__c=certaCredential.Id,
Assigned_Credential_Account__c=certaAssignedCredentialAccount.Id,
Account__c=testAccount.Id,
Max_Payout_Quantity_Claimed__c=0
);
// Insert Assigned_Credential for certaPlank on contact level.
Insert certaAssignedCred;

//creating data for StoneFacade as a Assigned Credential Account.
Assigned_Credential_Account__c stoneFacadeAssignedCredAccount= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
Credential__c=stoneFacadeCredential.Id,
Status__c='Active',
Max_Payout_Quantity_Claimed__c=0 
);
// Insert Assigned Credential for StoneFacade
Insert stoneFacadeAssignedCredAccount;

Assigned_Credential__c stoneFacadeAssignedCred= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
RecordTypeId='0123w000001YemGAAS',
Credential__c=stoneFacadeCredential.Id,
Assigned_Credential_Account__c=stoneFacadeAssignedCredAccount.Id,
Account__c=testAccount.Id,
Max_Payout_Quantity_Claimed__c=0
);
// Insert Assigned_Credential for stoneFacade on contact level.
Insert stoneFacadeAssignedCred;

// Insert Assigned Credential for RISE Product Category on contact level
Assigned_Credential__c riseAssignedCred= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
RecordTypeId='0123w000001YemGAAS',
Credential__c=riseCredential.Id,
Account__c=testAccount.Id,
Max_Payout_Quantity_Claimed__c=0
);
// Insert Assigned_Credential for certaPlank on contact level.
Insert riseAssignedCred;

// Insert Assigned Credential siding5Star on Contact Level.
Assigned_Credential__c siding5StarAssignCred= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
RecordTypeId='0123w000001YemGAAS',
Credential__c=sidingCredentialed.Id,
Account__c=testAccount.Id
);
// Insert Assigned_Credential on contact level.
Insert siding5StarAssignCred;  */
        
        
        system.debug('rebateClaim2==='+rebateClaim2); 
        
        // Insert rebate claim for CertaPlank product Category
        RebateClaim certaRebateClaim1 = new RebateClaim(
            Rebate_Claim__c = newRebateClaims.get(1).Id,
            ProductId = certaProd.Id,
            Invoice_Number__c = '06443',
            Quantity = 10,
            Unit_Of_Measure_Selected__c = unitMeasure.Id,
            Business_Units__c = sidingBusinessUnit.Id,
            Product_Category__c = sidingCCBRebateType.Id,
            //   ClaimType = 'StandardRebate',
            ClaimDate = Date.newInstance(2024, 12, 9),
            ClaimAmount =0,
            RecordTypeId=stExam
        );
        insert certaRebateClaim1;
        system.debug('certaRebateClaim1==='+certaRebateClaim1); 
        
        
        list<Rebate_claim__c> oldRebateClaims = new list<Rebate_claim__c>();
        oldRebateClaims.add(rebateClaim);
        //  oldRebateClaims.add(rebateClaim2);
        
        list<Rebate_Claim__c> qacompleteRebateClaims = new list<Rebate_Claim__c>();
        for(Rebate_Claim__c rc:newRebateClaims){
            rc.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STATUS_QA_COMPLETED;
            qacompleteRebateClaims.add(rc);
        }
        update qacompleteRebateClaims;
        /*
Rebate_claim__c rebateClaim0 = [Select Id from Rebate_claim__c WHERE id =:rebateClaim.Id];
system.debug('rebateClaim0'+rebateClaim0);
rebateClaim0.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STATUS_QA_COMPLETED;
update rebateClaim0;    */
        
        /*   Rebate_claim__c rebateClaim5 = [Select Id,Status__c from Rebate_claim__c WHERE id =:rebateClaim2.Id];
system.debug('rebateClaim0'+rebateClaim2);
rebateClaim5.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STATUS_QA_COMPLETED;
update rebateClaim5;  
system.debug('rebateClaim5==='+rebateClaim5); */
        
        /*    Map<Id, Rebate_Claim__c> oldMap = new Map<Id, Rebate_Claim__c>(oldRebateClaims);
list<rebate_claim__C> claimItems = new list<rebate_claim__C>();
claimItems.add(rebateClaim);
claimItems.add(rebateClaim2);  */
        
        
        Test.startTest(); 
        //  updateAssignedCredentialDonotTouchClass.processQAComplete(claimItems, oldMap);
        RevalidateRebateQuickActionController.reValidateRebateClaim(qacompleteRebateClaims.get(0).id);
        RevalidateRebateQuickActionController.reValidateRebateClaim(qacompleteRebateClaims.get(1).id);        
        Test.stopTest();
        
        list<Rebate_claim__c> finalRebateClaims = new list<Rebate_claim__c>();
        finalRebateClaims = [Select Id,Claim_Currency__c,Total_Rebate_Amount__c, Total_rebate_amt_USD_before_conv__c, Applied_Exchange_Rate__c  from Rebate_claim__c limit 2];
        System.assert(finalRebateClaims.get(0).Claim_Currency__c == RebateUtility.USD_CURRENCY);
        System.assert(finalRebateClaims.get(0).Total_Rebate_Amount__c == Null);
        System.assert(finalRebateClaims.get(0).Total_rebate_amt_USD_before_conv__c == Null);
        System.assert(finalRebateClaims.get(0).Applied_Exchange_Rate__c ==Null);
        System.assert(finalRebateClaims.get(1).Claim_Currency__c == RebateUtility.USD_CURRENCY);
        System.assert(finalRebateClaims.get(1).Total_Rebate_Amount__c == Null);
        System.assert(finalRebateClaims.get(1).Total_rebate_amt_USD_before_conv__c == Null);
        System.assert(finalRebateClaims.get(1).Applied_Exchange_Rate__c ==Null);
    }
}