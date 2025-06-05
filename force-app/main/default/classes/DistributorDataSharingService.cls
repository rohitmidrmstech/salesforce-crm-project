public class DistributorDataSharingService {
    
    public static void shareRecordsWithAllEligiblePartnerUsers() {
        //Partner Community Contractor User Profile Id
        Id partnerProfileId = [SELECT Id FROM Profile WHERE Name = 'Partner Community Contractor User' LIMIT 1].Id;
        
        //contact has Distributor__c = 'Yes'
        List<User> partnerUsers = [SELECT Id, ContactId FROM User WHERE ProfileId = :partnerProfileId AND Contact.Distributor__c = 'Yes' 
                                   AND IsActive = true];
        
        system.debug('List of partner users='+partnerUsers);
        
        if (partnerUsers.isEmpty()) {
            return;
        }
        
        Id soldToRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        
        List<AccountShare> accountShares = new List<AccountShare>();
        List<ContactShare> contactShares = new List<ContactShare>();
        List<OrderShare> orderShares = new List<OrderShare>();
        
        //Loop through users
        for (User u : partnerUsers) {
            if (u.ContactId != null) {
                List<AccountContactRelation> acrList = [SELECT AccountId FROM AccountContactRelation WHERE ContactId = :u.ContactId];
                
                Set<Id> accountIds = new Set<Id>();
                for (AccountContactRelation acr : acrList) {
                    accountIds.add(acr.AccountId);
                }
                
                if (!accountIds.isEmpty()) {
                    List<Account> soldToAccounts = [SELECT Id FROM Account WHERE Id IN :accountIds AND RecordTypeId = :soldToRecordTypeId];
                    system.debug('soldToAccounts sharing class'+soldToAccounts);
                    
                    if (!soldToAccounts.isEmpty()) {
                      //  Id soldToAccountId = soldToAccounts[0].Id;
                        
                        List<Order> orders = [SELECT Id FROM Order WHERE AccountId IN: soldToAccounts];
                        
                        
                        for(account acc:soldToAccounts){
                        accountShares.add(new AccountShare(
                            AccountId = acc.id,
                            UserOrGroupId = u.Id,
                            AccountAccessLevel = 'Read',
                            OpportunityAccessLevel = 'None',
                            RowCause = Schema.AccountShare.RowCause.Manual
                        ));
                        }
                        
                        contactShares.add(new ContactShare(
                            ContactId = u.ContactId,
                            UserOrGroupId = u.Id,
                            ContactAccessLevel = 'Read',
                            RowCause = Schema.ContactShare.RowCause.Manual
                        ));
                        
                        for (Order o : orders) {
                            orderShares.add(new OrderShare(
                                OrderId = o.Id,
                                UserOrGroupId = u.Id,
                                OrderAccessLevel = 'Read',
                                RowCause = Schema.OrderShare.RowCause.Manual
                            ));
                        }
                    }
                }
            }
        }
        // Insert all sharing records
        insert accountShares;
        insert contactShares;
        if (!orderShares.isEmpty()) {
            insert orderShares;
        }
    }
}