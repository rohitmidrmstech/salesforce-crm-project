@isTest
public class BatchToCalculateTransactionvalueTest {
    @isTest
    public static void CalculateTransactionvalueMethod1() {
         Account acc = TestDataUtilityClass.createAccount('Test Acco');
         Contact cont = TestDataUtilityClass.createContact(acc.id); 
         RebateProgram rp = TestDataUtilityClass.createRebateProgram();
         RebateProgramMember rpm = TestDataUtilityClass.createRebateProgramMember(rp.Id,cont.id); 
         Rebate_Claim__c rc = TestDataUtilityClass.createRebateClaim(cont.id); 
         Product2 pr = TestDataUtilityClass.createProduct(); 
         RebateClaim rci = TestDataUtilityClass.createRebateClaim(rc.id,pr.id);
         List<DPE_Base_Calculation__c> dbc = new List<DPE_Base_Calculation__c>();
         
         for (Integer i=0;i<10;i++) {
             dbc.add(TestDataUtilityClass.createBaseCalculation(rci.id));
         }
         TransactionJournal tj = TestDataUtilityClass.createTransactionJournal(rci.id,pr.id,rc.id,rpm.id);
         Credential__c cr = TestDataUtilityClass.createCredential(420.0);
         Assigned_Credential__c acr = TestDataUtilityClass.createAssignedCredential(cont.id,acc.id,cr.id,10.0);
         Assigned_Credential__c acrn = TestDataUtilityClass.createAssignedCredential(cont.id,acc.id,cr.id,null);
         Assigned_Credential_Account__c acccr = TestDataUtilityClass.createAssignedCredentialAccount(cont.id,acc.id,cr.id,10.0);
         Assigned_Credential_Account__c acccrn = TestDataUtilityClass.createAssignedCredentialAccount(cont.id,acc.id,cr.id,null);
          
         test.startTest(); 
         BatchToCalculateTransactionvalue batcalcu = new BatchToCalculateTransactionvalue();
         id reqJobId =Database.executeBatch(batcalcu);
         test.stopTest();
     }
     
    // Method is used to check the Positive and Negative Scenario
    @isTest
    public static void CalculateTransactionvalueMethod2() {
      
         Account acc = TestDataUtilityClass.createAccount('Test Acco');
         Contact cont = TestDataUtilityClass.createContact(acc.id); 
         RebateProgram rp = TestDataUtilityClass.createRebateProgram();
         RebateProgramMember rpm = TestDataUtilityClass.createRebateProgramMember(rp.Id,cont.id); 
         Rebate_Claim__c rc = TestDataUtilityClass.createRebateClaim(cont.id); 
         Product2 pr = TestDataUtilityClass.createProduct(); 
         RebateClaim rci = TestDataUtilityClass.createRebateClaim(rc.id,pr.id);
         // DPE_Base_Calculation__c dbc = TestDataUtilityClass.createDPEBaseCalculation(rci.id);
         List<DPE_Base_Calculation__c> dbc = new List<DPE_Base_Calculation__c>();
         
         for (Integer i=0;i<10;i++) {
             dbc.add(TestDataUtilityClass.createBaseCalculation(rci.id));
         }
         TransactionJournal tj = TestDataUtilityClass.createTransactionJournal(rci.id,pr.id,rc.id,rpm.id);
         Credential__c cr = TestDataUtilityClass.createCredential(420.0);
         Assigned_Credential__c acr = TestDataUtilityClass.createAssignedCredential(cont.id,acc.id,cr.id,10.0);
         Assigned_Credential__c acrn = TestDataUtilityClass.createAssignedCredential(cont.id,acc.id,cr.id,null);
        
         test.startTest(); 
         BatchToCalculateTransactionvalue batcalcu = new BatchToCalculateTransactionvalue();
         id reqJobId =Database.executeBatch(batcalcu);
         test.stopTest();
     }
     
    // Method is used to check the Positive and Negative Scenario
    @isTest
    public static void CalculateTransactionvalueMethod3() {
      
         Account acc = TestDataUtilityClass.createAccount('Test Acco');
         Contact cont = TestDataUtilityClass.createContact(acc.id); 
         RebateProgram rp = TestDataUtilityClass.createRebateProgram();
         RebateProgramMember rpm = TestDataUtilityClass.createRebateProgramMember(rp.Id,cont.id); 
         Rebate_Claim__c rc = TestDataUtilityClass.createRebateClaim(cont.id); 
         Product2 pr = TestDataUtilityClass.createProduct(); 
        
        String strRecordTypeId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('New Products').getRecordTypeId(); 
 
        Product2 prodCedar = new Product2();       
        prodCedar.Name = 'Test cedar';
        prodCedar.ProductCode = '24434';
        prodCedar.Product_Category__c='Cedar Impressions';
        prodCedar.SAP_Material__c ='E354213';
        prodCedar.Stocking_to_Selling_Conversion_Factor__c = 0.80;
        prodCedar.RecordTypeId =strRecordTypeId;      
        insert prodCedar;
         RebateClaim rci = TestDataUtilityClass.createRebateClaim(rc.id,pr.id);
         RebateClaim rci2 = TestDataUtilityClass.createRebateClaim(rc.id,prodCedar.id);
         // DPE_Base_Calculation__c dbc = TestDataUtilityClass.createDPEBaseCalculation(rci.id);
         List<DPE_Base_Calculation__c> dbc = new List<DPE_Base_Calculation__c>();
         
         for (Integer i=0;i<10;i++) {
             dbc.add(TestDataUtilityClass.createBaseCalculation(rci.id));
             dbc.add(TestDataUtilityClass.createBaseCalculation(rci2.id));
         }
         TransactionJournal tj = TestDataUtilityClass.createTransactionJournal(rci.id,pr.id,rc.id,rpm.id);
         TransactionJournal tj2 = TestDataUtilityClass.createTransactionJournal(rci2.id,prodCedar.id,rc.id,rpm.id);

         Credential__c cr = TestDataUtilityClass.createCredential(40.0);
         Assigned_Credential__c acr = TestDataUtilityClass.createAssignedCredential(cont.id,acc.id,cr.id,10.0);
         Assigned_Credential__c acrn = TestDataUtilityClass.createAssignedCredential(cont.id,acc.id,cr.id,null);
         Assigned_Credential_Account__c acccr = TestDataUtilityClass.createAssignedCredentialAccount(cont.id,acc.id,cr.id,null);
        
         test.startTest(); 
         BatchToCalculateTransactionvalue batcalcu = new BatchToCalculateTransactionvalue();
         id reqJobId =Database.executeBatch(batcalcu);
         test.stopTest();
     }
}