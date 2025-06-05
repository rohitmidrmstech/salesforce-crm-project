@isTest
public class ChangeLangTest {
    
    @isTest
    static void testChangeLang(){
    // Create a test user
    User testUser = new User(Username = 'tesetuser@testemail.com', 
                             LastName = 'test', 
                             Email = 'tesetuser@testemail.com', 
                             Alias = 'testuser', 
                             TimeZoneSidKey = 'America/New_York', 
                             EmailEncodingKey = 'ISO-8859-1', 
                             ProfileId = '00ed00000016siJAAQ',
                             LocaleSidKey = 'en_US',
                             LanguageLocaleKey = 'en_US');
    insert testUser;
    
    //Call ChangeLang method with languauge selection
    String results = ChangeLang.changeLang('en_US');
        
    // Verify that the method returns OK
    System.assertEquals('OK',results);    
    }

}