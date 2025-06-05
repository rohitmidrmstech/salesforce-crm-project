/* **********************************************************************************************************************************
* Class Name   : TestDataUtilityClass
* Description  : Class to contain test utility class
* Author       : Dipen
* Created On   : Dec 30,2023
* Test Class   : BatchToCalculateTransactionvalueTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Dipen			         30-12-20223           1000              Initial Development
**************************************************************************************************************************************/

public class TestDataUtilityClass {
    private static date t=date.today();
    private static Decimal decVal=20;
    public static Account createAccount(String name) {
        id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account acc = new Account(name = name,RecordTypeId=RecordTypeId);
        insert acc;
        return acc;
    }
    
    public static Contact createContact(Id accId) {
        Contact c = new Contact(LastName = 'Test Contact ', Title = 'Test Title', accountId = accId);
        insert c;
        return c;
    }
    public static RebateProgram createRebateProgram() {
        RebateProgram rp = new RebateProgram(Name = 'Test ',Frequency='Monthly', StartDate=t, EndDate=t, Rebate_Program_Type__c='CCB');
        insert rp;
        return rp;
    }
    public static RebateProgramMember createRebateProgramMember(Id RebateProgramId,Id ContactId) {
        RebateProgramMember rpm = new RebateProgramMember(Name = 'Test',RebateProgramId=RebateProgramId,Contact__c=ContactId); 
        insert rpm;
        return rpm;
    }
    public static Rebate_Claim__c createRebateClaim(Id ContactId) {
        Rebate_Claim__c rebclaim = new Rebate_Claim__c(Submitted_By__c =ContactId );
        insert rebclaim; 
        return rebclaim;
    }
    public static Product2 createProduct() {       
        String strRecordTypeId =  Schema.SObjectType.Product2.getRecordTypeInfosByName().get('New Products').getRecordTypeId();
        Product2 prod = new Product2();       
        prod.Name = 'Test Product';
        prod.ProductCode = '123456';
        prod.Product_Category__c='STONEfacade';
        prod.SAP_Material__c ='E35421565';
        prod.Stocking_to_Selling_Conversion_Factor__c = 0.50;
        prod.RecordTypeId =strRecordTypeId;      
        insert prod;
        return prod;
    }
    public static RebateClaim createRebateClaim(Id RebateClaimId,Id ProductId) {
        RebateClaim rebclaimitems = new RebateClaim(Rebate_Claim__c =RebateClaimId,Quantity=1, ClaimAmount=200, ClaimDate=t,ProductId=ProductId); 
        insert rebclaimitems; 
        return rebclaimitems;
    }
    public static DPE_Base_Calculation__c createBaseCalculation(Id RebateClaimItemsId) {
        DPE_Base_Calculation__c bc= new DPE_Base_Calculation__c(Rebate_Claim_Item__c=RebateClaimItemsId,IsRecalculate__c=true);
        insert bc;
        return bc;
    }
    public static TransactionJournal createTransactionJournal(Id RebateClaimItemId,Id ProductId,Id RebateClaimId,Id MemberId) {
        
        TransactionJournal tranJour=new TransactionJournal();
        tranJour.Applied_Benefit_Value__c=decVal;
        tranJour.ProductId=ProductId;
        tranJour.Quantity_Converted__c=5;
        tranJour.Rebate_Claim_Item__c=RebateClaimItemId;
        tranJour.Stone_Facade_Rebate_Amount__c=decVal;
        tranJour.Quantity=decVal;
        tranJour.UOMConversionFactor__c=decVal;
        tranJour.TransactionAmount=decVal;
        tranJour.PercentageBenefit__c=0;
        tranJour.DollarBenefit__c=0;
        tranJour.General_Promotion_Amount__c=decVal;
        tranJour.Rebate_Claim__c=RebateClaimId;
        tranJour.MemberId=MemberId;
        tranJour.ActivityDate=t;
        insert tranJour;
        return tranJour;
    }     
    public static Credential__c createCredential(decimal MaxPayoutQuantity) {
        Credential__c cr = new Credential__c (Max_Payout_Quantity__c=MaxPayoutQuantity,Product_Category__c='STONEfacade');
        insert cr;
        return cr;
    }  
    
    public static Assigned_Credential__c createAssignedCredential(Id ContactId,Id AccountiId,Id CredentialId,decimal MaxPayQclaim) {
        Assigned_Credential__c assigncred =new Assigned_Credential__c(Max_Payout_Quantity_Claimed__c=MaxPayQclaim,Contact__c=ContactId,Credential__c=CredentialId,Status__c='Active');
        insert assigncred;
        return assigncred; 
    }    
    public static Assigned_Credential_Account__c createAssignedCredentialAccount(Id ContactId,Id AccountiId,Id CredentialId,decimal MaxPayQclaim) {
        Assigned_Credential_Account__c assignaccountcred =new Assigned_Credential_Account__c(Credential__c=CredentialId,Account__c=AccountiId,Max_Payout_Quantity_Claimed__c=MaxPayQclaim,Status__c='Active');
        insert assignaccountcred;
        return assignaccountcred; 
    }
}