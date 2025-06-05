@isTest 
public class LoyaltyNewCardPaymentLoadBatch_Test 
{
    static testMethod void testMethod1() 
    {
        automation_Controller__c automationController = new automation_Controller__c(Name = 'Automation', LoyaltyAutomatedPaymentProcessing__c = true);
        insert automationController;
        Account acc = new Account(Name = 'TestAcct',BillingStreet='6640 28th St SE Ste 2',
        							BillingCity='Grand Rapids',BillingState='MI',BillingPostalCode='49546',BillingCountry='US');
        insert acc;
         
         Contact con = new Contact (LastName='TestCont',Contractor_ID__c='89714871122',Contact_Card_Active__c=False,
                                    Contact_Card_Expiration__c=Date.newInstance(2023, 12, 31),MailingStreet='6640 28th St SE Ste 2',
        							MailingCity='Grand Rapids',MailingState='MI',MailingPostalCode='49546',MailingCountry='US') ;
         insert con;
        
        Rebate_Claim__c rebate = new Rebate_Claim__c(Post_Processing_Audit__c=true,Claim_Exception__c=false,
                                                     Status__c='Submitted',Submitted_By__c=con.id, 
                                                     RecordTypeId = Schema.SObjectType.Rebate_Claim__c.getRecordTypeInfosByName().get('CCB').getRecordTypeId(),
                                                     Claim_Currency__c ='CAD');
        insert rebate;
        
        rebate.Status__c = 'QA Completed';
        update rebate;
        
        rebate.Status__c = 'Claim approved';
        update rebate;
        
        rebate.Status__c = 'Pending card funding';
        update rebate;
        
        RebateProgram RP = new RebateProgram(EndDate = Date.newInstance(2023, 12, 31),Frequency='CustomPeriods',
                                             Name = 'Contractor Cash Back - 2023',Rebate_Program_Type__c='CCB',
                                             StartDate = Date.newInstance(2023, 01, 01),Status='Active');
        insert RP;
        
        RebateProgramPayoutPeriod RPPP = new RebateProgramPayoutPeriod(EndDate = Date.newInstance(2023, 12, 31),Name = 'FY 2023',
                                                                       PayoutCalculationDate = Date.newInstance(2024, 12, 31),
                                                                       StartDate = Date.newInstance(2023, 01, 01),Status='Active',
                                                                       TransactionGracePeriodDate = Date.newInstance(2024, 12, 31),
                                                                      RebateProgramId = RP.Id);
        insert RPPP;
        
        RebateProgramMember RPM = new RebateProgramMember(Name = 'Contractor Cash Back - 2023 - Ju Yang',MemberStatus='Active',
                                                          IsPayoutCalcSkipped=false,RebateProgramId = RP.Id);
        insert RPM;
        
        RebateProgramMemberPayout RPMP = new RebateProgramMemberPayout(Name='RCA-000000066',Status ='Interim',MemberId=RPM.ID,PeriodId=RPPP.ID);
        insert RPMP;
        
        /*BatchCalcJobDefinition BCJD = new BatchCalcJobDefinition(DeveloperName = 'BSPCCB_AggregateByClaimRebateTypeWithAggregateItems',
                                                                 IsTemplate = false, MasterLabel = 'BSP & CCB - Aggregate by Claim & Rebate Type with Aggregate Items',
                                                                 ProcessType = 'Rebates');
        insert BCJD;*/
        
        BatchCalcJobDefinition BCJD = [Select Id,DeveloperName from	BatchCalcJobDefinition WHERE DeveloperName ='BSPCCB_AggregateByClaimRebateTypeWithAggregateItems'];
        
        Business_Units__c BU = new Business_Units__c(Name = 'Roofing');
        insert BU;
        
        ProgramRebateType PRT = new ProgramRebateType(CalculationType ='AggregateBased',IsIntegratable = false,Name ='Roofing - Contractor Cash Back - 2023',
                                                      RebateMeasureType = 'AmountperUnit',Status ='Active',CalcObjectId = BCJD.ID, 
                                                      AggregateObjectName = 'RebateMemberProductAggregate', MeasureField = 'TotalQuantity',
                                                      RebateProgramId = RP.ID, Business_Units__c = BU.Id);
        insert PRT;
        
        ProgramRebateTypePayout PRTP = new ProgramRebateTypePayout(Rebate_Claims__c=rebate.id,Name='Roofing - Contractor Cash Back - 2023',
                                                                   SAP_Processed__c=false,Sent_To_Payment_Details__c=false,Sent_To_SAP__c=false,
                                                                   Sent_Request_For_New_Card__c=false,RebateProgramMemberPayoutId=RPMP.id,
                                                                   ProgramRebateTypeId=PRT.id , Transaction_Amount__c =10);
        insert PRTP;
        
        Test.startTest();
        
        LoyaltyNewCardPaymentLoadBatch myBatchObject = new LoyaltyNewCardPaymentLoadBatch();
        Id batchId = Database.executeBatch(myBatchObject);
        
        Test.stopTest();
    }
}