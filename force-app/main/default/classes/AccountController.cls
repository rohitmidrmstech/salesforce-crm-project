public with sharing class AccountController {
    @AuraEnabled(cacheable = true)
    public static Account getSingleAccount() {
        return [SELECT Id, Name ,Phone FROM Account ORDER BY CreatedDate desc Limit 1 ];

    }
}