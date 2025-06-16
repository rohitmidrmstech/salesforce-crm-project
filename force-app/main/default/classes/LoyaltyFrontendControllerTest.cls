@isTest
public class LoyaltyFrontendControllerTest {

    @isTest
    static void testgetLang(){
    
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
        
    //Call getLang method with languauge selection
    String results = LoyaltyFrontendController.getLang();
        
    // Verify that the method returns OK
    System.assertEquals('en_US',results);    
        
    }
   
    
}