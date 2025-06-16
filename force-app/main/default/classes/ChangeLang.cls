public class ChangeLang {
@AuraEnabled
public static string changeLang(String lang) {
    String currentuserId = UserInfo.getUserId();
    system.debug(currentuserId);
    User currentUserInfo = [select LanguageLocaleKey from User where Id = :UserInfo.getUserId() LIMIT 1];
    currentUserInfo.LanguageLocaleKey = lang;
    update currentUserInfo;
    return 'OK';
	}
}