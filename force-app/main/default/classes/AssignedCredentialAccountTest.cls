@istest
public class AssignedCredentialAccountTest {
    @testSetup
    static void createDiffrentCredentialv1(){
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
        
        
        // Insert Rebate Program for Previous year.    
        RebateProgram ccbProgramPreviousYear = new RebateProgram(Name = 'Contractor Cash Back-' +previousYear,
                                                                 StartDate =Date.newInstance(Date.today().year()-1, 1, 1),  
                                                                 EndDate =Date.newInstance(Date.today().year()-1, 12, 31),
                                                                 Frequency='Annually',
                                                                 Status='Active',Rebate_Program_Type__c='CCB',
                                                                 No_of_Grace_Days_for_Claim__c=60,Country__c='US');
        // Insert Rebate program for previous year CCB
        insert ccbProgramPreviousYear;
        // creating UnitOfMeasure as a Box. 
        UnitOfMeasure unitMeasure= new UnitOfMeasure(Name='SQ',UnitCode='SQFT',
                                                     Description='SQ',Type='Area');
        // Insert unitMeasure
        Insert unitMeasure;
        id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
        Account testAccount = new Account(Name = 'Test new ',Status__c='Active',RecordTypeId=RecordTypeId);
        
        Insert testAccount;
        Contact testContact = new Contact(FirstName = 'Test', LastName = 'John',
                                          AccountId = testAccount.Id,
                                          Enable_for_Promotion__c=true,
                                          Status__c='Active',
                                          CCB_Eligibility__c='Eligible');
        // Insert testContact
        insert testContact;
        
        RevalidateRebateQuickActionController.assignedCredentialWithContact.put(testContact.id,testContact.Id);
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
        insert ccbProgramMemberPrevious;
        
        
        
        // Create Crededential for previosYear
        Credential__c certaCredentialpreviousYear= new Credential__c(Name='CERTAplank',Status__c='Active',
                                                                     Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=40,
                                                                     Unit_of_Measure__c=unitMeasure.Id,
                                                                     Product_Category__c='CERTAplank Reinforced Siding',
                                                                     Start_Date__c = Date.newInstance(Date.today().year()-1, 1, 1), 
                                                                     End_Date__c = Date.newInstance(Date.today().year()-1, 12, 31) 
                                                                    );
        
        // Insert Credential for CertaPlank product Category for previous Year.
        Insert certaCredentialpreviousYear;
        //creating data for Certa plank as a Assigned Credential Account.
        Assigned_Credential_Account__c certaAssignedCredentialAccount= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
                                                                                                          Credential__c=certaCredentialpreviousYear.Id,
                                                                                                          Status__c='Active',
                                                                                                          Max_Payout_Quantity_Claimed__c=0 
                                                                                                         );
        // Insert Assigned Credential for certaPlank
        Insert certaAssignedCredentialAccount;
        Assigned_Credential__c certaAssignedCred= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
                                                                             RecordTypeId='0123w000001YemGAAS',
                                                                             Credential__c=certaCredentialpreviousYear.Id,
                                                                             Assigned_Credential_Account__c=certaAssignedCredentialAccount.Id,
                                                                             Account__c=testAccount.Id,
                                                                             Max_Payout_Quantity_Claimed__c=0
                                                                            );
        // Insert Assigned_Credential for certaPlank on contact level.
        Insert certaAssignedCred;
        
        Credential__c certaCredentialCurrentYear= new Credential__c(Name='CERTAplank',Status__c='Active',
                                                                    Applicable_Program__c='CCB;BSP',Max_Payout_Quantity__c=40,
                                                                    Unit_of_Measure__c=unitMeasure.Id,
                                                                    Product_Category__c='CERTAplank Reinforced Siding',
                                                                    Start_Date__c = Date.newInstance(Date.today().year(), 1, 1), 
                                                                    End_Date__c = Date.newInstance(Date.today().year(), 12, 31) 
                                                                   );
        
        // Insert Credential for CertaPlank product Category for previous Year.
        Insert certaCredentialCurrentYear;
        //creating data for Certa plank as a Assigned Credential Account.
        Assigned_Credential_Account__c certaAssignedCredentialCurrentYear= new Assigned_Credential_Account__c(Account__c=testAccount.Id,
                                                                                                              Credential__c=certaCredentialCurrentYear.Id,
                                                                                                              Status__c='Active',
                                                                                                              Max_Payout_Quantity_Claimed__c=0 
                                                                                                             );
        // Insert Assigned Credential for certaPlank
        Insert certaAssignedCredentialCurrentYear;
        Assigned_Credential__c certaAssignedCredCurrentYear= new Assigned_Credential__c(Contact__c=testContact.Id,Status__c='Active',
                                                                                        RecordTypeId='0123w000001YemGAAS',
                                                                                        Credential__c=certaCredentialCurrentYear.Id,
                                                                                        Assigned_Credential_Account__c=certaAssignedCredentialCurrentYear.Id,
                                                                                        Account__c=testAccount.Id,
                                                                                        Max_Payout_Quantity_Claimed__c=0
                                                                                       );
        // Insert Assigned_Credential for certaPlank on contact level.
        Insert certaAssignedCredCurrentYear;
    }
    
    @isTest
    static void createDiffrentCredential(){
        Set<Id> accountSet = new Set<Id>();
        Set<Id> creds = new Set<Id>();
        for(Assigned_Credential__c ac: [select id,Credential__c,Assigned_Credential_Account__c,Contact__c,Account__c from Assigned_Credential__c]){
            TransactionJournalCreatorForRebateClaims.assignedCredentialWithContact.put(ac.Assigned_Credential_Account__c,ac.Contact__c);
            TransactionJournalCreatorForRebateClaims.assignedCredentialWithContact.put(ac.Assigned_Credential_Account__c,ac.Contact__c);
            RevalidateRebateQuickActionController.assignedCredentialWithContact.put(ac.Assigned_Credential_Account__c,ac.Contact__c);
            RevalidateRebateQuickActionController.assignedCredentialWithContact.put(ac.Assigned_Credential_Account__c,ac.Contact__c);
            accountSet.add(ac.Account__c);
            creds.add(ac.Credential__c);
        }
        string credcat;
        Set<String> productCategory = new Set<String>();
        Map<string,Assigned_Credential_Account__c> assignedmap = new Map<string,Assigned_Credential_Account__c>();
        List<Assigned_Credential_Account__c> Assccred = [SELECT Id,Credential__c, Status__c,Credential_Category__c FROM Assigned_Credential_Account__c Limit 1];
        for (Assigned_Credential_Account__c rebateClaim : Assccred) {
            rebateClaim.Max_Payout_Quantity_Claimed__c = 20.0;
            for(string str:creds){
                if(str != rebateClaim.Credential__c){
                    credcat = str;
                }
            }
            assignedmap.put(rebateClaim.Id,rebateClaim);
            productCategory.add(rebateClaim.Credential_Category__c.toUpperCase());
        }
        update Assccred;
        
    }
    
    
    
}