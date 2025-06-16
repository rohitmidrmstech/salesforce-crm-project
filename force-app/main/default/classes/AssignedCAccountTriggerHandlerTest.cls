@isTest
public class AssignedCAccountTriggerHandlerTest {
    @testSetup
    static void setupTestData() {
        // Insert Rebate program for current year CCB
        Date today = Date.today();
        Integer currentYear = today.year();
        Integer previousYear = currentYear - 1;
        RebateProgram ccbProgram = new RebateProgram(Name = 'Contractor Cash Back-'+ Date.today().Year(),
                                                     StartDate =Date.newInstance(Date.today().year(), 1, 1),  
                                                     EndDate =Date.newInstance(Date.today().year(), 12, 31),
                                                     Frequency='Annually',
                                                     Status='Active',Rebate_Program_Type__c='CCB',
                                                     No_of_Grace_Days_for_Claim__c=90,Country__c='US');
        // Insert Rebate program for current year CCB
        insert ccbProgram;
        
        RebateProgram ccbProgramPreviousYear = new RebateProgram(Name = 'Contractor Cash Back-' +previousYear,
                                                     StartDate =Date.newInstance(Date.today().year()-1, 1, 1),  
                                                     EndDate =Date.newInstance(Date.today().year()-1, 12, 31),
                                                     Frequency='Annually',
                                                     Status='Active',Rebate_Program_Type__c='CCB',
                                                     No_of_Grace_Days_for_Claim__c=90,Country__c='US');
        // Insert Rebate program for previous year CCB
        insert ccbProgramPreviousYear;
        
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
        
        // creating member for CCB-Currrent year
        RebateProgramMember ccbProgramMemberCurrent = new RebateProgramMember(
            Name = 'Contractor Cash Back -'+ Date.today().Year() +'-test contact',
            RebateProgramId = ccbProgram.Id, // Linking the Program
            AccountId = testAccount.Id, // Linking the Account
            Contact__c = testContact.Id, // Linking the Contact
            MemberStatus = 'Active'
        );
        // Insert ccbProgramMember for CCB-2024
        insert ccbProgramMemberCurrent;
        
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
        
        // creating UnitOfMeasure as a SQ. 
        UnitOfMeasure unitMeasure= new UnitOfMeasure(Name='SQ',UnitCode='SQFT',
                                                     Description='SQ',Type='Area');
        // Insert unitMeasure
        Insert unitMeasure;
        
        Credential__c certaCredentialCurrentYear= new Credential__c(Name='CERTAplank',Status__c='Active',
                                                                    Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=40,
                                                                    Unit_of_Measure__c=unitMeasure.Id,
                                                                    Product_Category__c='CERTAplank Reinforced Siding',
                                                                    Start_Date__c = Date.newInstance(Date.today().year(), 1, 1), 
                                                                    End_Date__c = Date.newInstance(Date.today().year(), 12, 31) 
                                                                   );
        
        // Insert Credential for CertaPlank product Category for current year.
        Insert certaCredentialCurrentYear;
        
        Credential__c certaCredentialFutureYear= new Credential__c(Name='CERTAplank',Status__c='Active',
                                                                   Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=40,
                                                                   Unit_of_Measure__c=unitMeasure.Id,
                                                                   Product_Category__c='CERTAplank Reinforced Siding',
                                                                   Start_Date__c = Date.newInstance(Date.today().year()-1, 1, 1), 
                                                                   End_Date__c = Date.newInstance(Date.today().year()-1, 12, 31) 
                                                                  );
        
        // Insert Credential for CertaPlank product Category for Future Year.
        Insert certaCredentialFutureYear;
        
        //creating data for Certa plank as a Assigned Credential Account.
        Assigned_Credential_Account__c certaAssignedCredentialAccount= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
                                                                                                          Credential__c=certaCredentialCurrentYear.Id,
                                                                                                          Status__c='Active',
                                                                                                          Max_Payout_Quantity_Claimed__c=0
                                                                                                         );
        // Insert Assigned Credential for certaPlank
        Insert certaAssignedCredentialAccount;
        Assigned_Credential__c certaAssignedCred= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
                                                                             RecordTypeId='0123w000001YemGAAS',
                                                                             Credential__c=certaCredentialCurrentYear.Id,
                                                                             Assigned_Credential_Account__c=certaAssignedCredentialAccount.Id,
                                                                             Account__c=testAccount.Id,
                                                                             Max_Payout_Quantity_Claimed__c=0
                                                                            );
        // Insert Assigned_Credential for certaPlank on contact level.
        Insert certaAssignedCred;
        //creating data for Certa plank as a Assigned Credential Account.
        Assigned_Credential_Account__c certaAssignedCredAccount= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
                                                                                                    Credential__c=certaCredentialFutureYear.Id,
                                                                                                    Status__c='Active',
                                                                                                    Max_Payout_Quantity_Claimed__c=0
                                                                                                   );
        // Insert Assigned Credential Account for certaPlank.
        Insert certaAssignedCredAccount;
        Assigned_Credential__c certaAssignedCred1= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
                                                                              RecordTypeId='0123w000001YemGAAS',
                                                                              Credential__c=certaCredentialFutureYear.Id,
                                                                              Assigned_Credential_Account__c=certaAssignedCredAccount.Id,
                                                                              Account__c=testAccount.Id,
                                                                              Max_Payout_Quantity_Claimed__c=0
                                                                             );
        // Insert Assigned_Credential for certaPlank on contact level.
        Insert certaAssignedCred1;
    }
      @isTest
    static void testupdateQuantity() {
        
        List<Assigned_Credential_Account__c> assignedCredentialAccount = [select id,Credential_Category__c,Account__c,
                                                                          Max_Payout_Quantity_Claimed__c,Credential__c
                                                                          from Assigned_Credential_Account__c];
        System.debug('assignedCredentialAccount==>'+assignedCredentialAccount);
        List<Assigned_Credential_Account__c> updateAcredAccount= new List<Assigned_Credential_Account__c>();
        for(Assigned_Credential_Account__c acredAccount :assignedCredentialAccount){
            Assigned_Credential_Account__c credAccount= new Assigned_Credential_Account__c();
            credAccount.Id =acredAccount.Id;
            credAccount.Max_Payout_Quantity_Claimed__c=10;
            updateAcredAccount.add(credAccount);            
        }
        update updateAcredAccount;
        Map<Id, Assigned_Credential_Account__c> newMap = new Map<Id, Assigned_Credential_Account__c>(updateAcredAccount);
         Map<Id, Assigned_Credential_Account__c> oldmap = new Map<Id, Assigned_Credential_Account__c>(assignedCredentialAccount);
        Test.startTest();
       // AssignedCredentialAccountTriggerHandler.updateQuantity(newMap, oldMap);
        Test.stopTest();
    }
    
}