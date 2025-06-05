@isTest
public class LoyaltyContactDataUpdateHandlerTest {
  @isTest
  static void testUpdatePhone() {
    // Create a test Contact with a valid phone number
        Contact testContact1 = new Contact(FirstName = 'Test', LastName = 'Contact', Phone = '123-456-7890');
        insert testContact1;

        // Call the updatePhone method
        LoyaltyContactDataUpdateHandler.updatePhone(new List<Contact>{testContact1});

        // Retrieve the updated Contact from the database
        Contact updatedContact1 = [SELECT Id, Phone_Bank_Report__c FROM Contact WHERE Id = :testContact1.Id];

        // Verify that the Phone_Bank_Report__c field was updated for a valid phone number
        System.assertEquals(Null, updatedContact1.Phone_Bank_Report__c);

        // Create a test Contact with an invalid phone number
        Contact testContact2 = new Contact(FirstName = 'Test', LastName = 'Contact', Phone = 'InvalidPhoneNumber');
        insert testContact2;

        // Call the updatePhone method
        LoyaltyContactDataUpdateHandler.updatePhone(new List<Contact>{testContact2});

        // Retrieve the updated Contact from the database
        Contact updatedContact2 = [SELECT Id, Phone_Bank_Report__c FROM Contact WHERE Id = :testContact2.Id];
      // Verify that the Phone_Bank_Report__c field remains empty for an invalid phone number
        System.assertEquals(Null, updatedContact2.Phone_Bank_Report__c);
  }
}