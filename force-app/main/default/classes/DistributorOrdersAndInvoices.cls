public class DistributorOrdersAndInvoices {
    @AuraEnabled
    public static Map<String, List<SObject>> getOrdersAndInvoices(){
        Id userId = UserInfo.getUserId();
        List<Contact> contacts = [
            SELECT Id 
            FROM Contact 
            WHERE Partner_User_2__c = :userId 
            LIMIT 1
        ];
        
        if (contacts.isEmpty()) {
            throw new AuraHandledException('No Contact found for current user. User Id='+UserId);
        }
        
        Id contactId = contacts[0].Id;
        
        // Get AccountContactRelation
        List<AccountContactRelation> acrList = [
            SELECT AccountId 
            FROM AccountContactRelation 
            WHERE ContactId = :contactId
        ];
        
        if (acrList.isEmpty()) {
            throw new AuraHandledException('No accounts linked to this contact.');
        }
        
        Set<Id> accountIds = new Set<Id>();
        for (AccountContactRelation acr : acrList) {
            accountIds.add(acr.AccountId);
        }
        system.debug('accountIds=='+accountIds);
        
        
        // Get RecordTypeId for Sold to
        Id soldToRecordTypeId = null;
        try {
            soldToRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        } catch (Exception e) {
            throw new AuraHandledException('Sold to record type not found.');
        }
        
        // Find Sold to account
        List<Account> soldToAccounts = [
            SELECT Id 
            FROM Account 
            WHERE Id IN :accountIds AND RecordTypeId = :soldToRecordTypeId 
        ];
        system.debug('SoldtoAccounts'+soldToAccounts);
        
        if (soldToAccounts.isEmpty()) {
            throw new AuraHandledException('No Sold to account found for this user.');
        }
        
        // Id soldToAccountId = soldToAccounts[0].Id;
        
        // Fetch Orders
        List<Order> orders = [
            SELECT Id, OrderNumber, Status, EffectiveDate, TotalAmount , AccountId ,Account.Name, EndDate
            FROM Order 
            WHERE AccountId IN:soldToAccounts
        ];
        
        // Fetch Invoices
        List<Invoice__c> Invoices = [SELECT Id,Name, Billing_Date__c, Net_Value__c, Sold_To_Lookup__c ,Ship_To_Lookup__r.Name,Ship_To_Lookup__c,Sold_To_Lookup__r.Name  FROM Invoice__c WHERE Order__c IN: Orders];
        
        return new Map<String, List<SObject>>{
            'orders' => orders,
                'invoices' => invoices
                };
                    }
    @AuraEnabled
    public static List<Order> searchOrders(String searchKey, Id userId, Date startDate, Date endDate, String status) {
        List<String> filters = new List<String>();
        Map<String, Object> params = new Map<String, Object>();
        
        String baseQuery = 'SELECT Id, OrderNumber, Status, EffectiveDate, TotalAmount, Account.Name, AccountId FROM Order WHERE ';
        
        if (String.isNotBlank(searchKey)) {
            filters.add('(OrderNumber LIKE :searchKey OR Status = :searchKey)');
        }
        if (startDate != null) {
            filters.add('EffectiveDate >= :startDate');
        }
        if (endDate != null) {
            filters.add('EffectiveDate <= :endDate');
        }
        if (String.isNotBlank(status)) {
            filters.add('Status = :status');
        }
        
        if (filters.isEmpty()) {
            throw new AuraHandledException('No search criteria provided.');
        }
        
        String finalQuery = baseQuery + String.join(filters, ' AND ');
        System.debug('Executing Order query: ' + finalQuery);
        
        return Database.query(finalQuery);
    }
    
    
    @AuraEnabled
    public static List<Invoice__c> searchInvoices(String searchKey, Id userId) {
        try {
            system.debug('Search key==='+searchkey);
            return [SELECT Id, Name, Billing_Date__c, Net_Value__c, Sold_To_Lookup__c,
                    Ship_To_Lookup__r.Name, Ship_To_Lookup__c, Sold_To_Lookup__r.Name
                    FROM Invoice__c
                    WHERE Name LIKE :('%' + searchkey + '%')];
        } catch (Exception e) {
            throw new AuraHandledException('Error in Invoice search: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<Invoice__c> searchInvoicesByOrders(List<Id> orderIds) {
        if (orderIds == null || orderIds.isEmpty()) {
            return new List<Invoice__c>();
        }
        
        return [
            SELECT Id, Name, Billing_Date__c, Net_Value__c, Sold_To_Lookup__c,
                    Ship_To_Lookup__r.Name, Ship_To_Lookup__c, Sold_To_Lookup__r.Name
            FROM Invoice__c
            WHERE Order__c IN :orderIds
        ];
    }
    
    
}