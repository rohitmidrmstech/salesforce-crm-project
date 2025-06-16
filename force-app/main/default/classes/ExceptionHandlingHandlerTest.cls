@isTest
public class ExceptionHandlingHandlerTest {
    
    @isTest
    static void exceptionmethod(){
        RebateProgram ccbProgram = new RebateProgram(Name = 'Contractor Cash Back',
                                                     StartDate =Date.today().addMonths(-12), 
                                                     EndDate =Date.today().addMonths(12),
                                                     Frequency='Annually',
                                                     Status='Active',Rebate_Program_Type__c='CCB',
                                                     No_of_Grace_Days_for_Claim__c=60,Country__c='US');
        // Insert Rebate program for current year CCB
        insert ccbProgram;
        
        Account testAccount = new Account(Name = 'Test Account',Status__c='Active');
        insert testAccount;
        
        Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe',
                                          AccountId = testAccount.Id,
                                          Enable_for_Promotion__c=true,
                                          Status__c='Active',
                                          CCB_Eligibility__c='Eligible');
        // Insert testContact
        insert testContact;
        
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
        
        Business_Units__c sidingBusinessUnit= new Business_Units__c(Name='Siding',Company_Code__c='1100',Sales_Org__c='1502');
        // Insert sidingBusinessUnit                                               
        Insert sidingBusinessUnit;
        
        UnitOfMeasure unitMeasure= new UnitOfMeasure(Name='SQ',UnitCode='SQFT',
                                                     Description='SQ',Type='Area');
        // Insert unitMeasure
        Insert unitMeasure;
        
        ProgramRebateType sidingCCBRebateType;
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
        
        Product2 certaProd= new Product2(Name='S7" Reinforced Siding 63106',IsActive=true,
                                         Description='S7" Reinforced Siding 63106',
                                         ProductCode='S7" Reinforced Siding 63106',
                                         Base_Unit_Of_Measure__c=unitMeasure.Id,
                                         Line_Of_Business__c=sidingBusinessUnit.Id,
                                         Product_Category__c='CERTAplank Reinforced Siding'
                                        );
        // Insert product for certaPlank Product category.
        Insert certaProd;
        
        Product_UOM__c certaProdUom= new Product_UOM__c(Name='CERTAplank S7" Reinforced Siding',Product__c=certaProd.Id,
                                                        Unit_of_Measure__c=unitMeasure.Id,
                                                        Applicable_Program__c='CCB;BSP');
        // Insert Product UOM for certa Plank Product.
        Insert certaProdUom;
        
        ProgramRebateTypeBenefit regularCertaBenefit= new ProgramRebateTypeBenefit(Name='2024 S7" Reinforced Siding 63106 - $10 Regular',
                                                                                   Status='InActive',
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
        
        UnitOfMeasureConversion certaUomConversion = new UnitOfMeasureConversion(Name='CERTAplank S7" Reinforced Siding - SQ to SQ',Product__c=certaProd.Id,
                                                                                 FromUnitOfMeasureId=unitMeasure.Id,
                                                                                 ToUnitOfMeasureId=unitMeasure.Id,
                                                                                 Applicable_Program__c='CCB',
                                                                                 ConversionFactor=1,
                                                                                 Program_Year__c= String.ValueOf(Date.today().year())
                                                                                );
        // Insert uom conversation for certa Plank product
        Insert certaUomConversion;
        
        Rebate_Claim__c rebateClaim= new Rebate_Claim__c(Submitted_By__c=testContact.Id,Status__c='Submitted',
                                                         Claim_Currency__c='USD',
                                                         Submit_Date__c = Date.newInstance(2024, 8, 20),
                                                         Rebate_Program_Member__c=ccbProgramMember.Id
                                                        );
        insert rebateClaim;
        
        Id stExam = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        RebateClaim certaRebateClaim = new RebateClaim(
            Rebate_Claim__c = rebateClaim.Id,
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
        
        test.starttest();
        Rebate_claim__c rebateClaim0 = [Select Id from Rebate_claim__c WHERE id =:rebateClaim.Id];
        system.debug('rebateClaim0'+rebateClaim0);
        rebateClaim0.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STATUS_QA_COMPLETED;
        update rebateClaim0;
        test.stoptest();
    }
}