@isTest
public class rebateProgramMemberAutoEnrollmentTest {
    @testSetup
    static void setupTestData() {
        // Create a Rebate Program for the current year
        Date today = System.today();
        Date startDate = Date.newInstance(today.year(), 1, 1); 
        Date endDate = Date.newInstance(today.year(),12,31);

        RebateProgram rebateProgram = new RebateProgram(
            Name = 'Test Program',
            StartDate = startDate, 
            EndDate = endDate,
            Rebate_Program_Sub_Type__c = 'BP',
            Frequency = 'Annually',
            Rebate_Program_Type__c = 'CCB'
        );
        insert rebateProgram;
        System.debug('Inserted Rebate Program: ' + rebateProgram.Id);

        // Create Contacts
        Contact eligibleContact = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            MailingCountry = 'Canada', 
            CCB_Eligibility__c = 'Eligible',
            Distributor__c = 'No',
            Status__C = 'Active'
        );

        Contact ineligibleContact = new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            MailingCountry = 'Canada', // Ensuring formula field computes correctly
            CCB_Eligibility__c = 'Not Eligible',
            Distributor__c = 'No',
            Status__c = 'Active'
        );
        
        Contact eligibleContact1 = new Contact(
            FirstName = 'John active',
            LastName = 'Doe',
            MailingCountry = 'Canada', 
            CCB_Eligibility__c = 'Eligible',
            Distributor__c = 'No',
            Status__C = 'Active'
        );
        
        Contact inactivecon = new Contact(
            FirstName = 'John inactive',
            LastName = 'Doe',
            MailingCountry = 'Canada', 
            CCB_Eligibility__c = 'Eligible',
            Distributor__c = 'No',
            Status__C = 'Active'
        );

        insert new List<Contact>{eligibleContact, ineligibleContact,eligibleContact1,inactivecon};
        System.debug('Inserted Contacts: ' + eligibleContact.Id + ', ' + ineligibleContact.Id);
        
        list<RebateProgramMember> rebateprogramember = new list<RebateProgramMember>();
        RebateProgramMember newmember1 	= new RebateProgramMember();
        newmember1.Contact__c 			= eligibleContact1.Id;
        newmember1.MemberStatus 			= 'Active';
        newmember1.RebateProgramId 		= rebateProgram.id;
        newmember1.Name					= rebateProgram.Name + ' - ' + eligibleContact1.FirstName + ' '+ eligibleContact1.LastName;
        rebateprogramember.add(newmember1);
        
        RebateProgramMember newmember2 	= new RebateProgramMember();
        newmember2.Contact__c 			= inactivecon.Id;
        newmember2.MemberStatus 			= 'Inactive';
        newmember2.RebateProgramId 		= rebateProgram.id;
        newmember2.Name					= rebateProgram.Name + ' - ' + inactivecon.FirstName + ' '+ inactivecon.LastName;
        rebateprogramember.add(newmember2);
        
        insert rebateprogramember;
        
    }
    
    @isTest
    static void testAutoEnrollment() {
        // Retrieve test data
        List<Contact> contacts = [SELECT Id,FirstName,LastName,Mailing_Country_Bank_Report__c,CCB_Eligibility__c,Distributor__c,Status__c FROM Contact];

        // Call the method
        Test.startTest();
        rebateProgramMemberAutoEnrollmentCanada.autoEnrollment(contacts);
        Test.stopTest();

        // Fetch RebateProgramMembers after execution
        List<RebateProgramMember> members = [SELECT Id, MemberStatus, Contact__c FROM RebateProgramMember];

        System.debug('Fetched RebateProgramMembers: ' + members);

        // Assertions
        System.assertEquals(3, members.size(), 'One RebateProgramMember record should be inserted');
        System.assertEquals('Active', members[0].MemberStatus, 'Inserted record should have status Active');
    }
    
    @isTest
    static void testInactiveContactUpdate() {
        // Retrieve test data
        Contact ineligibleContact = [SELECT Id,FirstName,LastName,Mailing_Country_Bank_Report__c,CCB_Eligibility__c,Distributor__c,Status__c FROM Contact WHERE CCB_Eligibility__c = 'Not Eligible' LIMIT 1];

        // Create an existing RebateProgramMember record
        RebateProgram rebateProgram = [SELECT Id FROM RebateProgram LIMIT 1];

        RebateProgramMember existingMember = new RebateProgramMember(
            name = 'test',
            Contact__c = ineligibleContact.Id,
            MemberStatus = 'Active',
            RebateProgramId = rebateProgram.Id
        );
        insert existingMember;
        System.debug('Inserted existing RebateProgramMember: ' + existingMember.Id);

        // Call the method
        Test.startTest();
        rebateProgramMemberAutoEnrollmentCanada.autoEnrollment(new List<Contact>{ineligibleContact});
        Test.stopTest();

        // Fetch the updated record
        RebateProgramMember updatedMember = [SELECT Id, MemberStatus FROM RebateProgramMember WHERE Id = :existingMember.Id];

        System.debug('Updated RebateProgramMember: ' + updatedMember);

        // Assertions
        System.assertEquals('Inactive', updatedMember.MemberStatus, 'RebateProgramMember should be updated to Inactive');
    }
}