@isTest
public class TJCreatorForRebateClaimsTest {
    @testSetup
    static void setupTestData() {
        // Insert Rebate program for current year CCB
        try{
            Test.startTest(); 
            List<ProgramRebateTypeBenefit> insertListofRebateBenefitRecords= new List<ProgramRebateTypeBenefit>();
            List<UnitOfMeasureConversion> insertListofUomC= new List<UnitOfMeasureConversion>();
            Id bspccbRecordTypeId =  Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BSP CCB Product').getRecordTypeId();
            Date today = Date.today();
            Integer currentYear = today.year();
            Integer previousYear = currentYear - 1;
            RebateProgram ccbProgram = new RebateProgram(Name = 'Contractor Cash Back',
                                                         StartDate =Date.newInstance(Date.today().year(), 1, 1),  
                                                         EndDate =Date.newInstance(Date.today().year(), 12, 31),
                                                         Frequency='Annually',
                                                         Status='Active',Rebate_Program_Type__c='CCB',
                                                         No_of_Grace_Days_for_Claim__c=60,Country__c='US');
            // Insert Rebate program for current year CCB
            insert ccbProgram;
            
            RebateProgram canadaCCBProgram = new RebateProgram(Name = 'Canada Contractor Cash Back',
                                                               StartDate =Date.newInstance(Date.today().year(), 1, 1),  
                                                               EndDate =Date.newInstance(Date.today().year(), 12, 31),
                                                               Status='Active',Rebate_Program_Type__c='CCB',
                                                               Frequency='Annually',
                                                               No_of_Grace_Days_for_Claim__c=60,Country__c='CAN');
            // Insert Canada CCB Rebate Program for current Year.
            insert canadaCCBProgram;
            
            // Insert Rebate Program for Previous year.    
            RebateProgram ccbProgramPreviousYear = new RebateProgram(Name = 'Contractor Cash Back-' +previousYear,
                                                                     StartDate =Date.newInstance(Date.today().year()-1, 1, 1),  
                                                                     EndDate =Date.newInstance(Date.today().year()-1, 12, 31),
                                                                     Frequency='Annually',
                                                                     Status='Active',Rebate_Program_Type__c='CCB',
                                                                     No_of_Grace_Days_for_Claim__c=60,Country__c='US');
            // Insert Rebate program for previous year CCB
            insert ccbProgramPreviousYear;
            
            System.debug('ccbProgramPreviousYear==>'+ccbProgramPreviousYear);
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
            // Insert ccbProgramMember for CCB-Current Year
            insert ccbProgramMember;
            
            // creating member for CCB-Previous year
            RebateProgramMember ccbProgramMemberPrevious = new RebateProgramMember(
                Name = 'Contractor Cash Back -'+ previousYear +'-test contact',
                RebateProgramId = ccbProgramPreviousYear.Id, // Linking the Program
                AccountId = testAccount.Id, // Linking the Account
                Contact__c = testContact.Id, // Linking the Contact
                MemberStatus = 'Active'
            );
            // Insert ccbProgramMember for CCB-2024
            insert ccbProgramMemberPrevious;
            
            
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
            
            // Insert CertaPlank product 
            Product2 certaProd= new Product2(Name='S7" Reinforced Siding 63106',IsActive=true,
                                             Description='S7" Reinforced Siding 63106',
                                             ProductCode='S7" Reinforced Siding 63106',
                                             Base_Unit_Of_Measure__c=unitMeasure.Id,
                                             Line_Of_Business__c=sidingBusinessUnit.Id,
                                             Product_Category__c='CERTAplank Reinforced Siding',
                                             recordTypeId=bspccbRecordTypeId
                                            );
            // Insert product for certaPlank Product category.
            Insert certaProd;
            
            // Insert CertaPlank product UOM
            Product_UOM__c certaProdUom= new Product_UOM__c(Name='CERTAplank S7" Reinforced Siding',Product__c=certaProd.Id,
                                                            Unit_of_Measure__c=unitMeasure.Id,
                                                            Applicable_Program__c='CCB;BSP');
            // Insert Product UOM for certa Plank Product.
            Insert certaProdUom;
            
            // Insert product for RISE Product category.
            Product2 riseProduct= new Product2(Name='Rise S11 Textured 38211',IsActive=true,
                                               Description='Rise S11 Textured 38211',
                                               ProductCode='Rise S11 Textured 38211',
                                               Base_Unit_Of_Measure__c=riseUnitMeasure.Id,
                                               recordTypeId=bspccbRecordTypeId,
                                               Line_Of_Business__c=sidingBusinessUnit.Id,
                                               Product_Category__c='RISE'
                                              );
            // Insert rise Product 
            Insert riseProduct;
            
            // Creating product UOM  for RISE product Category
            Product_UOM__c riseProductUom= new Product_UOM__c(Name='Rise S11 Textured 38211',Product__c=riseProduct.Id,
                                                              Unit_of_Measure__c=riseUnitMeasure.Id,
                                                              Applicable_Program__c='CCB;BSP');
            // Insert Product UOM for RISE Product.
            Insert riseProductUom;
            
            // Insert product for Ventilation Product category.
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
            
            // Insert product for STONEfacade Product category.
            Product2 stoneFacadeProd= new Product2(Name='STONEfacade Ledgestone Panels 11000',IsActive=true,
                                                   Description='STONEfacade Ledgestone Panels 11000',
                                                   ProductCode='STONEfacade Ledgestone Panels 11000',
                                                   Base_Unit_Of_Measure__c=unitMeasure.Id,
                                                   Line_Of_Business__c=sidingBusinessUnit.Id,
                                                   Product_Category__c='STONEfacade',
                                                   recordTypeId=bspccbRecordTypeId
                                                  );
            // Insert product for STONEfacade Product category.
            Insert stoneFacadeProd;
            
            Product_UOM__c stoneFacadeProdUom= new Product_UOM__c(Name='STONEfacade Ledgestone Panels 11000',
                                                                  Product__c=stoneFacadeProd.Id,
                                                                  Unit_of_Measure__c=unitMeasure.Id,
                                                                  Applicable_Program__c='CCB;BSP');
            
            // Insert Product UOM for STONEfacade Product Category.
            Insert stoneFacadeProdUom;
            
            // Insert product for STONEfacade Product category.
            Product2 urbanReserveProd= new Product2(Name='Alum Panel Solid SMO',IsActive=true,
                                                    Description='Alum Panel Solid SMO',
                                                    ProductCode='Alum Panel Solid SMO',
                                                    Base_Unit_Of_Measure__c=unitMeasure.Id,
                                                    Line_Of_Business__c=sidingBusinessUnit.Id,
                                                    Product_Category__c='Urban Reserve',
                                                    recordTypeId=bspccbRecordTypeId
                                                   );
            // Insert product for Urban Reserve Product category.
            Insert urbanReserveProd;
            
            Product_UOM__c urbanReserveProdUom= new Product_UOM__c(Name='Alum Panel Solid SMO',
                                                                   Product__c=urbanReserveProd.Id,
                                                                   Unit_of_Measure__c=unitMeasure.Id,
                                                                   Applicable_Program__c='CCB;BSP');
            
            // Insert Product UOM for Urban Reserve Product Category.
            Insert urbanReserveProdUom;
            
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
                                                                                       EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                       EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                      );
            // Insert  Regular benefit for certaPlank Product.
            insertListofRebateBenefitRecords.add(regularCertaBenefit);
            System.debug('regularCertaBenefit==>'+regularCertaBenefit);
            ProgramRebateTypeBenefit promoCertaBenefit= new ProgramRebateTypeBenefit(Name='2024 S7" Reinforced Siding 63106 - $10 Promo',
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
                                                                                     EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                     EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                    );
            // Insert  promo benefit for certaPlank Product.
            insertListofRebateBenefitRecords.add(promoCertaBenefit);
            System.debug('promoCertaBenefit==>'+promoCertaBenefit);
            
            ProgramRebateTypeBenefit regularCertaPreviosYear= new ProgramRebateTypeBenefit(Name='2024 S7" Reinforced Siding 63106 - $10 Regular',
                                                                                           Status='Active',
                                                                                           Benefit_Type__c='Regular',
                                                                                           Product_Category__c='CERTAplank Reinforced Siding',
                                                                                           ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                           MinimumQualifyingValue=1912,
                                                                                           MaximumQualifyingValue=1913,
                                                                                           ProductId=certaProd.Id,
                                                                                           Unit_of_Measure__c=unitMeasure.Id,
                                                                                           BenefitValue=10,
                                                                                           EffectiveStartDate=Date.newInstance(Date.today().year()-1, 1, 1),
                                                                                           EffectiveEndDate=Date.newInstance(Date.today().year()-1, 12, 31)
                                                                                          );
            // Insert  Regular benefit for certaPlank Product.
            
            insertListofRebateBenefitRecords.add(regularCertaPreviosYear);
            System.debug('regularCertaBenefit==>'+regularCertaPreviosYear);
            ProgramRebateTypeBenefit promoCertaPreviosYear= new ProgramRebateTypeBenefit(Name='2024 S7" Reinforced Siding 63106 - $10 Promo',
                                                                                         Status='Active',
                                                                                         Benefit_Type__c='Promo',
                                                                                         Promo_Name__c='CERTAplank Reinforced Siding Promo',
                                                                                         Product_Category__c='CERTAplank Reinforced Siding',
                                                                                         ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                         MinimumQualifyingValue=2012,
                                                                                         MaximumQualifyingValue=2013,
                                                                                         ProductId=certaProd.Id,
                                                                                         Unit_of_Measure__c=unitMeasure.Id,
                                                                                         BenefitValue=0,
                                                                                         Stone_Facade_Benefit__c=10,
                                                                                         EffectiveStartDate=Date.newInstance(Date.today().year()-1, 1, 1),
                                                                                         EffectiveEndDate=Date.newInstance(Date.today().year()-1, 12, 31)
                                                                                        );
            // Insert  promo benefit for certaPlank Product.
            insertListofRebateBenefitRecords.add(promoCertaPreviosYear);
            System.debug('promoCertaBenefit==>'+promoCertaPreviosYear);
            
            
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
                                                                                             EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                             EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                            );
            // Insert  Credentialled benefit record for certaPlank Product.
            insertListofRebateBenefitRecords.add(credentialledCertaBenefit);
            System.debug('credentialledCertaBenefit==>'+credentialledCertaBenefit);
            
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
            insertListofRebateBenefitRecords.add(ventprodRebateBenefit);
            System.debug('ventprodRebateBenefit==>'+ventprodRebateBenefit);
            
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
                                                                                         EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                         EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                        );
            // Insert  Regular benefit record for RISE  Product.
            insertListofRebateBenefitRecords.add(riseprodRebateBenefit);
            
            // Insert Rebate Benefit type for RISE product as a Promo benefit.
            ProgramRebateTypeBenefit riseprodPromoRebateBenefit= new ProgramRebateTypeBenefit(Name='Rise S11 Textured 38211- $5',
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
                                                                                              EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                              EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                             );
            // Insert  Promo benefit record for RISE  Product.
            insertListofRebateBenefitRecords.add(riseprodPromoRebateBenefit);
            
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
                                                                                            EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                            EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                           );
            // Insert  Credentialled benefit record for RISE Product.
            insertListofRebateBenefitRecords.add(credentialledRiseBenefit);
            
            
            ProgramRebateTypeBenefit urbanReserveRegularBenefit= new ProgramRebateTypeBenefit(Name='Alum Panel Solid SMO-Regular',
                                                                                              Status='Active',
                                                                                              Benefit_Type__c='Regular',
                                                                                              Promo_Name__c='Alum Panel Solid SMO-Regular',
                                                                                              Product_Category__c='Urban Reserve',
                                                                                              ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                              MinimumQualifyingValue=1711,
                                                                                              MaximumQualifyingValue=1712,
                                                                                              ProductId=urbanReserveProd.Id,
                                                                                              Unit_of_Measure__c=unitMeasure.Id,
                                                                                              BenefitValue=10,
                                                                                              EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                              EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                             );
            // Insert Regular benefit record for Urban Reserve Product Category.
            insertListofRebateBenefitRecords.add(urbanReserveRegularBenefit);
            
            ProgramRebateTypeBenefit urbanReservePromoBenefit= new ProgramRebateTypeBenefit(Name='Alum Panel Solid SMO-Promo',
                                                                                            Status='Active',
                                                                                            Benefit_Type__c='Promo',
                                                                                            Promo_Name__c='Alum Panel Solid SMO- Promo',
                                                                                            Product_Category__c='Urban Reserve',
                                                                                            ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                            MinimumQualifyingValue=1611,
                                                                                            MaximumQualifyingValue=1612,
                                                                                            ProductId=urbanReserveProd.Id,
                                                                                            Unit_of_Measure__c=unitMeasure.Id,
                                                                                            BenefitValue=0,
                                                                                            Stone_Facade_Benefit__c=10,
                                                                                            EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                            EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                           );
            // Insert  Credentialled benefit record for Urban Reserve Product category.
            insertListofRebateBenefitRecords.add(urbanReservePromoBenefit);
            
            ProgramRebateTypeBenefit urbanReserveRegularPreviousYear= new ProgramRebateTypeBenefit(Name='Alum Panel Solid SMO-Regular',
                                                                                                   Status='Active',
                                                                                                   Benefit_Type__c='Regular',
                                                                                                   Promo_Name__c='Alum Panel Solid SMO-Regular',
                                                                                                   Product_Category__c='Urban Reserve',
                                                                                                   ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                                   MinimumQualifyingValue=1711,
                                                                                                   MaximumQualifyingValue=1712,
                                                                                                   ProductId=urbanReserveProd.Id,
                                                                                                   Unit_of_Measure__c=unitMeasure.Id,
                                                                                                   BenefitValue=10,
                                                                                                   EffectiveStartDate=Date.newInstance(Date.today().year()-1, 1, 1),
                                                                                                   EffectiveEndDate=Date.newInstance(Date.today().year()-1, 12, 31)
                                                                                                  );
            // Insert Regular benefit record for Urban Reserve Product Category-Previous year
            insertListofRebateBenefitRecords.add(urbanReserveRegularPreviousYear);
            
            ProgramRebateTypeBenefit urbanReservePromoPreviousYear= new ProgramRebateTypeBenefit(Name='Alum Panel Solid SMO-Promo',
                                                                                                 Status='Active',
                                                                                                 Benefit_Type__c='Promo',
                                                                                                 Promo_Name__c='Alum Panel Solid SMO- Promo',
                                                                                                 Product_Category__c='Urban Reserve',
                                                                                                 ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                                 MinimumQualifyingValue=1611,
                                                                                                 MaximumQualifyingValue=1612,
                                                                                                 ProductId=urbanReserveProd.Id,
                                                                                                 Unit_of_Measure__c=unitMeasure.Id,
                                                                                                 BenefitValue=0,
                                                                                                 Stone_Facade_Benefit__c=10,
                                                                                                 EffectiveStartDate=Date.newInstance(Date.today().year()-1, 1, 1),
                                                                                                 EffectiveEndDate=Date.newInstance(Date.today().year()-1, 12, 31)
                                                                                                );
            // Insert  Credentialled benefit record for Urban Reserve Product category -Previous year
            insertListofRebateBenefitRecords.add(urbanReservePromoPreviousYear);
            
            ProgramRebateTypeBenefit stoneFacadeRegularBenefit= new ProgramRebateTypeBenefit(Name='STONEfacade Ledgestone Panels 11000-Regular',
                                                                                             Status='Active',
                                                                                             Benefit_Type__c='Regular',
                                                                                             Promo_Name__c='STONEfacade Ledgestone Panels 11000 Regular',
                                                                                             Product_Category__c='STONEfacade',
                                                                                             ProgramRebateTypeId=sidingCCBRebateType.Id,
                                                                                             MinimumQualifyingValue=1811,
                                                                                             MaximumQualifyingValue=1813,
                                                                                             ProductId=stoneFacadeProd.Id,
                                                                                             Unit_of_Measure__c=unitMeasure.Id,
                                                                                             BenefitValue=10,
                                                                                             Stone_Facade_Benefit__c=10,
                                                                                             EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                             EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                            );
            // Insert  Regular benefit record for Stone Facade Product.
            insertListofRebateBenefitRecords.add(stoneFacadeRegularBenefit);
            
            // Inserting Program Rebate type benefit.
            Insert insertListofRebateBenefitRecords;
            
            UnitOfMeasureConversion certaUomConversion = new UnitOfMeasureConversion(Name='CERTAplank S7" Reinforced Siding - SQ to SQ',Product__c=certaProd.Id,
                                                                                     FromUnitOfMeasureId=unitMeasure.Id,
                                                                                     ToUnitOfMeasureId=unitMeasure.Id,
                                                                                     Applicable_Program__c='CCB',
                                                                                     ConversionFactor=1,
                                                                                     Program_Year__c= String.ValueOf(Date.today().year())
                                                                                    );
            // Insert uom conversation for certa Plank product
            insertListofUomC.add(certaUomConversion);
            
            UnitOfMeasureConversion certaUomCPreviousYear = new UnitOfMeasureConversion(Name='CERTAplank S7" Reinforced Siding - SQ to SQ',Product__c=certaProd.Id,
                                                                                        FromUnitOfMeasureId=unitMeasure.Id,
                                                                                        ToUnitOfMeasureId=unitMeasure.Id,
                                                                                        Applicable_Program__c='CCB',
                                                                                        ConversionFactor=1,
                                                                                        Program_Year__c= String.ValueOf(Date.today().year()-1)
                                                                                       );
            // Insert uom conversation for certa Plank product
            insertListofUomC.add(certaUomCPreviousYear);
            
            // Insert UOM conversion for RISE product Category
            UnitOfMeasureConversion riseUomConversion = new UnitOfMeasureConversion(Name='Rise S11 Textured 38211 EA to EA',Product__c=riseProduct.Id,
                                                                                    FromUnitOfMeasureId=riseUnitMeasure.Id,
                                                                                    ToUnitOfMeasureId=riseUnitMeasure.Id,
                                                                                    Applicable_Program__c='CCB',
                                                                                    ConversionFactor=1,
                                                                                    Program_Year__c= String.ValueOf(Date.today().year())
                                                                                   );
            // Insert uom conversation for certa Plank product
            insertListofUomC.add(riseUomConversion);
            
            UnitOfMeasureConversion ventUomConversion = new UnitOfMeasureConversion(Name='Rolled Ridge Vents- SQ to SQ',Product__c=ventProd.Id,
                                                                                    FromUnitOfMeasureId=unitMeasure.Id,
                                                                                    ToUnitOfMeasureId=unitMeasure.Id,
                                                                                    Applicable_Program__c='CCB;BSP',
                                                                                    ConversionFactor=1,
                                                                                    Program_Year__c= String.ValueOf(Date.today().year())
                                                                                   );
            // Insert uom conversation for certa Plank product
            insertListofUomC.add(ventUomConversion);
            
            UnitOfMeasureConversion stoneFacadeUomConversion = new UnitOfMeasureConversion(Name='STONEfacade Ledgestone Panels 11000',
                                                                                           Product__c=stoneFacadeProd.Id,
                                                                                           FromUnitOfMeasureId=unitMeasure.Id,
                                                                                           ToUnitOfMeasureId=unitMeasure.Id,
                                                                                           Applicable_Program__c='CCB;BSP',
                                                                                           ConversionFactor=1,
                                                                                           Program_Year__c= String.ValueOf(Date.today().year())
                                                                                          );
            // Insert uom conversation for Stone Facade product.
            insertListofUomC.add(stoneFacadeUomConversion);
            
            UnitOfMeasureConversion urbanReserveUomConversion = new UnitOfMeasureConversion(Name='Alum Panel Solid SMO',
                                                                                            Product__c=urbanReserveProd.Id,
                                                                                            FromUnitOfMeasureId=unitMeasure.Id,
                                                                                            ToUnitOfMeasureId=unitMeasure.Id,
                                                                                            Applicable_Program__c='CCB;BSP',
                                                                                            ConversionFactor=1,
                                                                                            Program_Year__c= String.ValueOf(Date.today().year())
                                                                                           );
            // Insert uom conversation for Urban Reserve product.
            insertListofUomC.add(urbanReserveUomConversion);
            
            // Creating UOM C for Urban Reserve Product  Category for previous year.
            UnitOfMeasureConversion urbanReserveUomCPreviousYear = new UnitOfMeasureConversion(Name='Alum Panel Solid SMO',
                                                                                               Product__c=urbanReserveProd.Id,
                                                                                               FromUnitOfMeasureId=unitMeasure.Id,
                                                                                               ToUnitOfMeasureId=unitMeasure.Id,
                                                                                               Applicable_Program__c='CCB;BSP',
                                                                                               ConversionFactor=1,
                                                                                               Program_Year__c= String.ValueOf(Date.today().year()-1)
                                                                                              );
            // Insert uom conversation for Urban Reserve product.
            insertListofUomC.add(urbanReserveUomCPreviousYear);
            
            // Inserting List of UOmC records 
            Insert insertListofUomC;
            
            Credential__c certaCredentialpreviousYear= new Credential__c(Name='CERTAplank',Status__c='Active',
                                                                         Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=40,
                                                                         Unit_of_Measure__c=unitMeasure.Id,
                                                                         Product_Category__c='CERTAplank Reinforced Siding',
                                                                         Start_Date__c = Date.newInstance(Date.today().year()-1, 1, 1), 
                                                                         End_Date__c = Date.newInstance(Date.today().year()-1, 12, 31) 
                                                                        );
            
            // Insert Credential for CertaPlank product Category for previous Year.
            Insert certaCredentialpreviousYear;
            
            // Insert Credential for Urban Reserve product Category
            Credential__c urbanReserveCredential= new Credential__c(Name='Urban Reserve',Status__c='Active',
                                                                    Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=50,
                                                                    Unit_of_Measure__c=unitMeasure.Id,
                                                                    Product_Category__c='Urban Reserve',
                                                                    Start_Date__c=Date.newInstance(Date.today().year(), 1, 1), 
                                                                    End_Date__c=Date.newInstance(Date.today().year(), 12, 31) 
                                                                   );
            
            // Insert Credential for CertaPlank product Category- Current Year
            Insert urbanReserveCredential;
            System.debug('urbanReserveCredential==>'+urbanReserveCredential);
            
            Credential__c urbanCredentialpreviousYear= new Credential__c(Name='Urban Reserve',Status__c='Active',
                                                                         Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=50,
                                                                         Unit_of_Measure__c=unitMeasure.Id,
                                                                         Product_Category__c='Urban Reserve',
                                                                         Start_Date__c = Date.newInstance(Date.today().year()-1, 1, 1), 
                                                                         End_Date__c = Date.newInstance(Date.today().year()-1, 12, 31) 
                                                                        );
            
            // Insert Credential for CertaPlank product Category for Previous Year.
            Insert urbanCredentialpreviousYear;
            
            
            
            // Insert Credential for RISE product Category
            Credential__c riseCredential= new Credential__c(Name='RISE',Status__c='Active',
                                                            Applicable_Program__c='CCB;BSP',
                                                            Max_Payout_Quantity__c=500,
                                                            Unit_of_Measure__c=riseUnitMeasure.Id,
                                                            Product_Category__c='RISE',
                                                            Start_Date__c=Date.newInstance(Date.today().year(), 1, 1), 
                                                            End_Date__c=Date.newInstance(Date.today().year(), 12, 31) 
                                                           );
            
            // Insert Credential for CertaPlank product Category
            Insert riseCredential;
            
            // Insert Credential for StoneFacade product Category
            Credential__c stoneFacadeCredential= new Credential__c(Name='STONEfacade',Status__c='Active',
                                                                   Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=5,
                                                                   Unit_of_Measure__c=riseUnitMeasure.Id,
                                                                   Product_Category__c='STONEfacade',
                                                                   Start_Date__c=Date.newInstance(Date.today().year(), 1, 1), 
                                                                   End_Date__c=Date.newInstance(Date.today().year(), 12, 31) 
                                                                  );
            
            // Insert Credential for CertaPlank product Category
            Insert stoneFacadeCredential;
            
            
            Rebate_Claim__c rebateClaim= new Rebate_Claim__c(Submitted_By__c=testContact.Id,Status__c='Submitted',
                                                             Claim_Currency__c='USD',
                                                             Rebate_Program_Member__c=ccbProgramMember.Id,
                                                             Submit_Date__c = Date.newInstance(2024, 1, 20)
                                                            );
            
            // Insert rebateClaim
            Insert rebateClaim;
            List<RebateClaim> rebateClaims = new List<RebateClaim>();
            Id ccbRebateTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
            
            Rebate_Claim__c rebateClaim1= new Rebate_Claim__c(Submitted_By__c=testContact.Id,Status__c='Submitted',
                                                              Claim_Currency__c='USD',
                                                              Submit_Date__c = Date.newInstance(2025, 1, 20),
                                                              Rebate_Program_Member__c=ccbProgramMember.Id 
                                                             );
            
            // Insert rebateClaim
            Insert rebateClaim1;
            RebateClaim certaRebateClaim1 = new RebateClaim(
                Rebate_Claim__c = rebateClaim1.Id,
                ProductId = certaProd.Id,
                Invoice_Number__c = '06443',
                Quantity = 10,
                Unit_Of_Measure_Selected__c = unitMeasure.Id,
                Business_Units__c = sidingBusinessUnit.Id,
                Product_Category__c = sidingCCBRebateType.Id,
                //   ClaimType = 'StandardRebate',
                ClaimDate = Date.newInstance(2024, 12, 9),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            insert certaRebateClaim1;
            
            // Insert rebate claim for CertaPlank product Category
            RebateClaim certaRebateClaim = new RebateClaim(
                Rebate_Claim__c = rebateClaim.Id,
                ProductId = certaProd.Id,
                Invoice_Number__c = '03438',
                Quantity = 10,
                Unit_Of_Measure_Selected__c = unitMeasure.Id,
                Business_Units__c = sidingBusinessUnit.Id,
                Product_Category__c = sidingCCBRebateType.Id,
                ClaimType = 'StandardRebate',
                ClaimDate = System.Today(),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(certaRebateClaim);
            
            RebateClaim certaClaimFutureYear = new RebateClaim(
                Rebate_Claim__c = rebateClaim1.Id,
                ProductId = certaProd.Id,
                Invoice_Number__c = '03439',
                Quantity = 10,
                Unit_Of_Measure_Selected__c = unitMeasure.Id,
                Business_Units__c = sidingBusinessUnit.Id,
                Product_Category__c = sidingCCBRebateType.Id,
                ClaimType = 'StandardRebate',
                ClaimDate = Date.newInstance(Date.today().year()-1, 8, 25),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(certaClaimFutureYear);
            
            // Insert rebate claim for Urban Reserve Product Category
            RebateClaim urbanRebateClaim = new RebateClaim(
                Rebate_Claim__c = rebateClaim.Id,
                ProductId = urbanReserveProd.Id,
                Invoice_Number__c = '03438',
                Quantity = 10,
                Unit_Of_Measure_Selected__c = unitMeasure.Id,
                Business_Units__c = sidingBusinessUnit.Id,
                Product_Category__c = sidingCCBRebateType.Id,
                ClaimType = 'StandardRebate',
                ClaimDate = System.Today(),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(urbanRebateClaim);
            
            
            // Insert rebate claim for Urban Reserve Product Category
            RebateClaim urbanClaimFuture = new RebateClaim(
                Rebate_Claim__c = rebateClaim.Id,
                ProductId = urbanReserveProd.Id,
                Invoice_Number__c = '03439',
                Quantity = 10,
                Unit_Of_Measure_Selected__c = unitMeasure.Id,
                Business_Units__c = sidingBusinessUnit.Id,
                Product_Category__c = sidingCCBRebateType.Id,
                ClaimType = 'StandardRebate',
                ClaimDate = Date.newInstance(Date.today().year()-1, 8, 25),
                ClaimAmount =0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(urbanClaimFuture);
            
            // Insert rebate claim for RISE product Category
            RebateClaim riseRebateItem = new RebateClaim(
                Rebate_Claim__c = rebateClaim.Id,
                ProductId = riseProduct.Id,
                Invoice_Number__c = '03438',
                Quantity = 100,
                Unit_Of_Measure_Selected__c = riseUnitMeasure.Id,
                Business_Units__c = sidingBusinessUnit.Id,
                Product_Category__c = sidingCCBRebateType.Id,  // Second Product Rebate Type
                ClaimType = 'StandardRebate',
                ClaimDate = System.Today(),
                ClaimAmount = 0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(riseRebateItem);
            
            // Insert rebate claim for StoneFacade product Category
            RebateClaim stoneFacadeRebateItem = new RebateClaim(
                Rebate_Claim__c = rebateClaim.Id,
                ProductId = stoneFacadeProd.Id,
                Invoice_Number__c = '03438',
                Quantity = 100,
                Unit_Of_Measure_Selected__c = unitMeasure.Id,
                Business_Units__c = sidingBusinessUnit.Id,
                Product_Category__c = sidingCCBRebateType.Id,  // Second Product Rebate Type
                ClaimType = 'StandardRebate',
                ClaimDate = System.Today(),
                ClaimAmount = 0,
                RecordTypeId=ccbRebateTypeId
            );
            rebateClaims.add(stoneFacadeRebateItem);
            
            // Insert rebate claim for Ventilation product Category
            RebateClaim ventLineItem= new RebateClaim(Rebate_Claim__c=rebateClaim.Id,
                                                      ProductId=ventProd.Id,
                                                      Invoice_Number__c='03438',
                                                      Quantity=10,
                                                      Unit_Of_Measure_Selected__c=unitMeasure.Id,
                                                      Business_Units__c=roofingbusinessUnit.Id,
                                                      Product_Category__c=roofingCCBRebatetType.Id,
                                                      ClaimType='StandardRebate',
                                                      ClaimDate=System.Today(),
                                                      ClaimAmount=0,
                                                      RecordTypeId=ccbRebateTypeId
                                                     );
            rebateClaims.add(ventLineItem);
            
            // Inserting all the rebate line Items related to rebate Claim.
            Insert rebateClaims;
            
            Credential__c certaCredential= new Credential__c(Name='CERTAplank',Status__c='Active',
                                                             Applicable_Program__c='CCB;BSP',
                                                             Max_Payout_Quantity__c=40,
                                                             Unit_of_Measure__c=unitMeasure.Id,
                                                             Product_Category__c='CERTAplank Reinforced Siding',
                                                             Start_Date__c=Date.newInstance(Date.today().year(), 1, 1), 
                                                             End_Date__c=Date.newInstance(Date.today().year(), 12, 31) 
                                                            );
            
            // Insert Credential for CertaPlank product Category- CurrentYear
            Insert certaCredential;
            
            list<DPE_Base_Calculation__c> dpebasecal = new list<DPE_Base_Calculation__c>();
            DPE_Base_Calculation__c certaDPEBase = new DPE_Base_Calculation__c(
                Rebate_Claim_Item__c = certaRebateClaim.id,
                Quantity__c = 10,
                Quantity_Converted__c = 10,
                Unit_of_Measure__c = unitMeasure.Id
            );
            dpebasecal.add(certaDPEBase);
            
            DPE_Base_Calculation__c stoneFacadeDPEBase = new DPE_Base_Calculation__c(
                Rebate_Claim_Item__c = stoneFacadeRebateItem.id,
                Quantity__c = 10,
                Quantity_Converted__c = 10,
                Unit_of_Measure__c = unitMeasure.Id
            );
            dpebasecal.add(stoneFacadeDPEBase);
            insert dpebasecal;
            
            
            //creating data for Certa plank as a Assigned Credential Account.
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
            
            //creating data for Certa plank as a Assigned Credential Account.
            Assigned_Credential_Account__c certaCredPrevYear= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
                                                                                                 Credential__c=certaCredentialpreviousYear.Id,
                                                                                                 Status__c='Active',
                                                                                                 Max_Payout_Quantity_Claimed__c=0 
                                                                                                );
            // Insert Assigned Credential for certaPlank - Previous year
            Insert certaCredPrevYear;
            Assigned_Credential__c certAssingedCredPrevYear= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
                                                                                        RecordTypeId='0123w000001YemGAAS',
                                                                                        Credential__c=certaCredentialpreviousYear.Id,
                                                                                        Assigned_Credential_Account__c=certaCredPrevYear.Id,
                                                                                        Account__c=testAccount.Id,
                                                                                        Max_Payout_Quantity_Claimed__c=0
                                                                                       );
            // Insert Assigned_Credential for certaPlank - Previous Year.
            Insert certAssingedCredPrevYear;
            
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
            Insert siding5StarAssignCred;
            
            //creating data for Urban Reserve as a Assigned Credential Account.
            Assigned_Credential_Account__c urbanResAssignedCredAccount= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
                                                                                                           Credential__c=urbanReserveCredential.Id,
                                                                                                           Status__c='Active',
                                                                                                           Max_Payout_Quantity_Claimed__c=0 
                                                                                                          );
            // Insert Assigned Credential Account for Urban Reserve product Category.
            Insert urbanResAssignedCredAccount;
            
            //creating duplicate ACA record to call Queueable and delete it.
            Assigned_Credential_Account__c urbanResAssignedDupCredAccount= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
                                                                                                              Credential__c=urbanReserveCredential.Id,
                                                                                                              Status__c='Active',
                                                                                                              Max_Payout_Quantity_Claimed__c=0 
                                                                                                             );
            // Insert Assigned Credential Account for Urban Reserve product Category.
            Insert urbanResAssignedDupCredAccount;
            
            
            Assigned_Credential__c urbanResAssignedCred= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
                                                                                    RecordTypeId='0123w000001YemGAAS',
                                                                                    Credential__c=urbanReserveCredential.Id,
                                                                                    Assigned_Credential_Account__c=urbanResAssignedCredAccount.Id,
                                                                                    Account__c=testAccount.Id,
                                                                                    Max_Payout_Quantity_Claimed__c=0
                                                                                   );
            // Insert Assigned_Credential for Urban Reserve product Category.
            Insert urbanResAssignedCred;
            
            //creating data for Urban Reserve as a Assigned Credential Account-Previous year
            Assigned_Credential_Account__c urbanResAssignedCredPreyear= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
                                                                                                           Credential__c=urbanCredentialpreviousYear.Id,
                                                                                                           Status__c='Active',
                                                                                                           Max_Payout_Quantity_Claimed__c=0 
                                                                                                          );
            // Insert Assigned Credential Account for Urban Reserve product Category- Previous year
            Insert urbanResAssignedCredPreyear;
            
            Assigned_Credential__c urbanResCredPrevYear= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
                                                                                    RecordTypeId='0123w000001YemGAAS',
                                                                                    Credential__c=urbanCredentialpreviousYear.Id,
                                                                                    Assigned_Credential_Account__c=urbanResAssignedCredPreyear.Id,
                                                                                    Account__c=testAccount.Id,
                                                                                    Max_Payout_Quantity_Claimed__c=0
                                                                                   );
            // Insert Assigned_Credential for Urban Reserve product Category- Previous year
            Insert urbanResCredPrevYear; 
            Test.stopTest();
        } Catch(Exception e){
            System.debug('Error in Class==>'+ e.getMessage());
        }
        
        
    }   
    
    @isTest
    static void testProcessQAComplete() {
        // List<Rebate_Claim__c> rebateClaims= testdataUtilityRebateClaims.createRebatePrograms();        
        List<Rebate_Claim__c> rebateClaims = [SELECT Id, Status__c FROM Rebate_Claim__c];
        List<Credential__c> credset = [SELECT Id, Name,Product_Category__c FROM Credential__c];
        System.debug('credset==>'+credset);
        
        Map<Id, Rebate_Claim__c> oldMap = new Map<Id, Rebate_Claim__c>(rebateClaims);
        
        // Update the status to meet the condition in the processQAComplete method
        for (Rebate_Claim__c rebateClaim : rebateClaims) {
            rebateClaim.Status__c = 'QA Completed';
        }
        update rebateClaims;
        
        Test.startTest();
        TransactionJournalCreatorForRebateClaims.processQAComplete(rebateClaims, oldMap);
        
        Test.stopTest();
        
        
    }
    
   @isTest
    static void processRebateClaimforTJCreation() {
        List<Id> rebateClaimIdsToProcess = new List<Id>();
        //List<Rebate_Claim__c> rebateClaims= testdataUtilityRebateClaims.createRebatePrograms();
        List<Rebate_Claim__c> rebateClaims = [SELECT Id, Status__c FROM Rebate_Claim__c];
        Map<Id, Rebate_Claim__c> oldMap = new Map<Id, Rebate_Claim__c>(rebateClaims);
        
        for (Rebate_Claim__c rebateClaim : rebateClaims) {
            rebateClaim.Status__c = 'QA Completed';
        }
        update rebateClaims;
        Integer sizetodefineAsyncCall= 2;
        
        rebateClaimIdsToProcess.add(rebateClaims[0].Id); 
        if (!rebateClaimIdsToProcess.isEmpty()) {
            List<AggregateResult> groupedResults = [Select COUNT(Id) countRecords From RebateClaim WHERE  Rebate_Claim__c IN :rebateClaimIdsToProcess];
            System.debug('groupedResults==>' + groupedResults);
            Integer rebateLineItemSize=(Integer)groupedResults[0].get('countRecords');
            System.debug('lineItemSize==>' + rebateLineItemSize);
            // if size is greater than expected call the Queueable Method else call in the synchronous processing.
            if(rebateLineItemSize > sizetodefineAsyncCall){
                System.debug('RebateClaimProcessorQueueable==>'); 
                String oldMapJson = JSON.serialize(oldMap); 
                System.enqueueJob(new processRebateClaimQueueable(rebateClaimIdsToProcess,rebateClaims,oldMapJson));   
                
            } else{
                Test.startTest();
                TransactionJournalCreatorForRebateClaims.processQACompletedRebateClaim(rebateClaimIdsToProcess,rebateClaims,oldMap);
                Test.stopTest();
            }
            
        }
        
    }  
  
    @isTest
    static void revalidateprocess(){
        list<Rebate_Claim__c> insertedrebateclaim = new list<Rebate_Claim__c>();
        insertedrebateclaim = [SELECT Id FROM Rebate_Claim__c];
        list<Rebate_Claim__c> listofrc = new list<Rebate_Claim__c>();
        for(Rebate_Claim__c rc: insertedrebateclaim){
            rc.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STATUS_QA_COMPLETED;
            listofrc.add(rc);
        }
        update listofrc; 
        system.debug('insertedrebateclaim=='+insertedrebateclaim.get(0).Status__c);
        system.debug('listofrc=='+insertedrebateclaim.get(1).Status__c);
        RevalidateRebateQuickActionController.reValidateRebateClaim(listofrc.get(0).id);
        RevalidateRebateQuickActionController.reValidateRebateClaim(listofrc.get(1).id);
    }
   
 

}