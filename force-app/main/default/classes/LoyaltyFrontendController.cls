public class LoyaltyFrontendController {
@AuraEnabled 
public static string getLang(){
    String currentuserId = UserInfo.getUserId(); 
    User currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId() LIMIT 1];
    system.debug(currentUserInfo.LanguageLocaleKey);
    return currentUserInfo.LanguageLocaleKey;    
    }
    
}