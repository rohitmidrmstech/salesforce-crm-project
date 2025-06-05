@isTest
private class ContactControllerTest {
    @isTest
    static void testGetContactList() {
        List<Contact> contacts = new List<Contact>();
        // Create test contacts
        for (Integer i = 0; i < 5; i++) {
            contacts.add(new Contact(LastName = 'Test Contact ' + i, Title = 'Test Title ' + i));
        }
        insert contacts;
        
        Test.startTest();
        List<Contact> result = ContactController.getContactList();
        Test.stopTest();
        
        // Assert the returned contacts match the created test contacts
        System.assertEquals(5, result.size());
        for (Integer i = 0; i < 5; i++) {
            //System.assertEquals('Test Contact ' + i, result[i].LastName);
            System.assertEquals('Test Title ' + i, result[i].Title);
        }
    }
    
    @isTest
    static void testFindContacts() {
        List<Contact> contacts = new List<Contact>();
        // Create test contacts
        for (Integer i = 0; i < 5; i++) {
            contacts.add(new Contact(LastName = 'Test Contact ' + i, Title = 'Test Title ' + i));
        }
        insert contacts;
        
        Test.startTest();
        List<Contact> result = ContactController.findContacts('Test');
        Test.stopTest();
        
        // Assert the returned contacts match the created test contacts
        System.assertEquals(5, result.size());
        for (Integer i = 0; i < 5; i++) {
            //System.assertEquals('Test Contact ' + i, result[i].LastName);
            System.assertEquals('Test Title ' + i, result[i].Title);
        }
    }
    
    @isTest
    static void testGetSingleContact() {
        List<Contact> contacts = new List<Contact>();
        // Create test contacts
        contacts.add(new Contact(LastName = 'Test Contact', Title = 'Test Title'));
        insert contacts;
        
        Test.startTest();
        Contact result = ContactController.getSingleContact();
        Test.stopTest();
        
        // Assert the returned contact matches the created test contact
        //System.assertEquals('Test Contact', result.LastName);
        System.assertEquals('Test Title', result.Title);
    }
}