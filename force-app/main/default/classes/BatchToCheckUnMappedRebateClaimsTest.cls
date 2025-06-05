@isTest
public class BatchToCheckUnMappedRebateClaimsTest{
    
    @isTest
    static void checkUnmappedClaimswithTjs(){
        id RecordTypeId1 = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account acc1 = new Account(Name = 'Test Account1',RecordTypeId =RecordTypeId1);
        insert acc1; 
        Contact con1 = new Contact(LastName = 'Test Contact1 ', Title = 'Test Title',AccountId = acc1.id);
        insert con1;
        
        Business_Units__c BU1 = new Business_Units__c(Name='Siding');
        insert BU1;
        
        date t1=date.today();
        RebateProgram rebprog121 = new RebateProgram(Name = 'Test ',Frequency='Monthly', StartDate=t1, EndDate=t1, Rebate_Program_Type__c='CCB'); 
        insert rebprog121;
        
        BatchCalcJobDefinition BCJD1 = [Select Id,DeveloperName from BatchCalcJobDefinition WHERE DeveloperName ='BSPCCB_AggregateByClaimRebateTypeWithAggregateItems'];
        
        ProgramRebateType PRT1 = new ProgramRebateType();
        PRT1.Name = 'TestPRT';
        PRT1.Status='Active';
        PRT1.RebateProgramId=rebprog121.id;
        PRT1.Business_Units__c=BU1.id;
        PRT1.CalcObjectId=BCJD1.id;
        PRT1.RebateMeasureType = 'Custom';
        PRT1.CalculationType='Custom';
        insert PRT1;
        id RebateClaimCCB = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
               
        RebateProgramMember rebprogmem121 = new RebateProgramMember(Name = 'Test',RebateProgramId=rebprog121.id,Contact__c=con1.id); 
        insert rebprogmem121;
        
        Rebate_Claim__c rebclaim1 = new Rebate_Claim__c(Submitted_By__c=con1.Id,Submit_Date__c=t1,Status__c='Claim Approved',Rebate_Program_Member__c=rebprogmem121.id,Claim_Currency__c='USD',recordTypeid =RebateClaimCCB,Claim_Approved_Date__c = null);
        insert rebclaim1;        
        
        Id strRecordTypeId1 = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
        
        Product2 prod1 = new Product2();       
        prod1.Name = 'Test Product';
        prod1.ProductCode = '123456';
        prod1.Product_Category__c='STONEfacade';
        prod1.SAP_Material__c ='E35421565';
        prod1.Stocking_to_Selling_Conversion_Factor__c = 0.50;
        prod1.RecordTypeId =strRecordTypeId1;      
        insert prod1; 
        UnitOfMeasure UOM = NEW UnitOfMeasure(Name='SQ',Type='Area',UnitCode='SQ');
        insert UOM;
        
        RebateClaim  rebclaimitems1 = new RebateClaim(Rebate_Claim__c =rebclaim1.Id, ClaimAmount=200, ClaimDate=t1,ProductId=prod1.Id,Unit_Of_Measure_Selected__c =UOM.id,Quantity=5,Business_Units__c=BU1.id );        
        insert rebclaimitems1;
        
        Rebate_Claim_Aggregate__c rebateAggregate1 = new Rebate_Claim_Aggregate__c(Rebate_Claim__c = rebclaim1.id);
        insert rebateAggregate1;
        
        Decimal decVal1=20;
        
        TransactionJournal tranJour1=new TransactionJournal();
        tranJour1.Applied_Benefit_Value__c=decVal1;
        tranJour1.ProductId=prod1.id;
        tranJour1.Quantity_Converted__c=5;
        tranJour1.Rebate_Claim_Item__c=rebclaimitems1.Id;
        tranJour1.Stone_Facade_Rebate_Amount__c=decVal1;
        tranJour1.Quantity=decVal1;
        tranJour1.UOMConversionFactor__c=decVal1;
        tranJour1.TransactionAmount=decVal1;
        tranJour1.Rebate_Claim__c=rebclaim1.Id;
        tranJour1.Rebate_Claim_Item__c=rebclaimitems1.Id;
        tranJour1.MemberId=rebprogmem121.id;
        tranJour1.ActivityDate=t1;
        insert tranJour1;
        
        RebateProgramPayoutPeriod RPPP1 = new RebateProgramPayoutPeriod(Name = 'FY 2023',StartDate=t1,EndDate=t1,TransactionGracePeriodDate=t1,RebateProgramId=rebprog121.id,PayoutCalculationDate=t1,Status='Active');
        insert RPPP1;
        RebateProgramMemberPayout RPTY1 = new RebateProgramMemberPayout(Name='TestRPTY',MemberId = rebprogmem121.id,PeriodId=RPPP1.id);
        insert RPTY1;
        
        ProgramRebateTypePayout PRTY1 = new ProgramRebateTypePayout(Name='TestPRTY',ProgramRebateTypeId=PRT1.id,RebateProgramMemberPayoutId = RPTY1.id,Rebate_Claims__c=rebclaim1.id,Transaction_Amount__c=20,Claim_Currency__c='USD');
        insert PRTY1;
        
        RebateMemberProductAggregate RMPA1 = new RebateMemberProductAggregate(RebateProgramMemberId=rebprogmem121.id,ProgramRebateTypeId=PRT1.id,Rebate_Claim__c=rebclaim1.id,RebateProgramPayoutPeriodId=RPPP1.id);
        insert RMPA1;
        RebateMemberAggregateItem RMAI1 = new RebateMemberAggregateItem(RebateMemberProductAggregateId=RMPA1.id,TransactionJournalId=tranJour1.id);
        Insert RMAI1;
        ProgramRebateTypPayoutSrc PRTPS1 = new ProgramRebateTypPayoutSrc(Name='TestPRTPS',Rebate_Business_Unit_Aggregate_Item__c=RMAI1.id,ProgramRebateTypePayoutId=PRTY1.id,MemberId=rebprogmem121.id);
        insert PRTPS1;
        
        //for second rebate claim for BSP
        id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account acc = new Account(Name = 'Test Account',RecordTypeId =RecordTypeId);
        insert acc; 
        Contact con = new Contact(LastName = 'Test Contact ', Title = 'Test Title',AccountId = acc.id);
        insert con;
        
        Business_Units__c BU = new Business_Units__c(Name='Siding');
        insert BU;
        date t=date.today();
        RebateProgram rebprog12 = new RebateProgram(Name = 'Test ',Frequency='Monthly', StartDate=t, EndDate=t, Rebate_Program_Type__c='BSP',status='Active'); 
        insert rebprog12;
        BatchCalcJobDefinition BCJD = [Select Id,DeveloperName from	BatchCalcJobDefinition WHERE DeveloperName ='BSPCCB_AggregateByClaimRebateTypeWithAggregateItems'];
        ProgramRebateType PRT = new ProgramRebateType(Name='TestPRT',Status='Active',RebateProgramId=rebprog12.id,Business_Units__c=BU.id,CalcObjectId=BCJD.id,RebateMeasureType = 'Custom',CalculationType='Custom');
        insert PRT;
        RebateProgramMember rebprogmem12 = new RebateProgramMember(Name = 'Test',RebateProgramId=rebprog12.id,AccountId=acc.id,MemberStatus='Active'); 
        insert rebprogmem12;
        id RebateClaimBSP = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('BSP').getRecordTypeId();
        Rebate_Claim__c rebclaim = new Rebate_Claim__c(Submitted_By__c =con.Id,Submitted_For__c = acc.id,Claim_From__c=t,Claim_To__c=t,Submit_Date__c=t,Status__c='Claim Approved',Rebate_Program_Member__c=rebprogmem12.id,Claim_Currency__c='USD',recordtypeid =RebateClaimBSP);
        insert rebclaim;        
        
        String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
        Product2 prod = new Product2();       
        prod.Name = 'Test Product';
        prod.ProductCode = '123456';
        prod.Product_Category__c='STONEfacade';
        prod.SAP_Material__c ='E35421565';
        prod.Stocking_to_Selling_Conversion_Factor__c = 0.50;
        prod.RecordTypeId =strRecordTypeId;      
        insert prod;   
        
        RebateClaim  rebclaimitems = new RebateClaim(Rebate_Claim__c =rebclaim.Id,Quantity=1, ClaimAmount=200, ClaimDate=t,ProductId=prod.Id);        
        insert rebclaimitems;
        
        Rebate_Claim_Aggregate__c rebateAggregate = new Rebate_Claim_Aggregate__c(Rebate_Claim__c = rebclaim.id);
        insert rebateAggregate;
        Decimal decVal=20;
        TransactionJournal tranJour=new TransactionJournal();
        tranJour.Applied_Benefit_Value__c=decVal;
        tranJour.ProductId=prod.id;
        tranJour.Quantity_Converted__c=5;
        tranJour.Rebate_Claim_Item__c=rebclaimitems.Id;
        tranJour.Stone_Facade_Rebate_Amount__c=decVal;
        tranJour.Quantity=decVal;
        tranJour.UOMConversionFactor__c=decVal;
        tranJour.TransactionAmount=decVal;
        tranJour.Rebate_Claim__c=rebclaim.Id;
        tranJour.Rebate_Claim_Item__c=rebclaimitems.Id;
        tranJour.MemberId=rebprogmem12.id;
        tranJour.ActivityDate=t;
        insert tranJour;
        
        RebateProgramPayoutPeriod RPPP = new RebateProgramPayoutPeriod(Name = 'FY 2023',StartDate=t,EndDate=t,TransactionGracePeriodDate=t,RebateProgramId=rebprog12.id,PayoutCalculationDate=t,Status='Active');
        insert RPPP;
        RebateProgramMemberPayout RPTY = new RebateProgramMemberPayout(MemberId = rebprogmem12.id,Name='TestRPTY',PeriodId=RPPP.id);
        insert RPTY;
        ProgramRebateTypePayout PRTY = new ProgramRebateTypePayout(Name='TestPRTY',ProgramRebateTypeId=PRT.id,RebateProgramMemberPayoutId = RPTY.id,Rebate_Claims__c=rebclaim.id,Sent_To_SAP__c=False);
        insert PRTY;
        ProgramRebateTypPayoutSrc PRTPS = new ProgramRebateTypPayoutSrc(Name='TestPRTPS',Rebate_Business_Unit_Aggregate_Item__c=RMAI1.id,ProgramRebateTypePayoutId=PRTY.id,MemberId=rebprogmem121.id);
        insert PRTPS;
        test.startTest(); 
        BatchToCheckUnMappedRebateClaims batcalcu = new BatchToCheckUnMappedRebateClaims();
        id reqJobId =Database.executeBatch(batcalcu);
        test.stopTest();
    }
    
  
}