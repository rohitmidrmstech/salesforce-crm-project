public with sharing class IndirectAccountLookupController {
    
    @AuraEnabled
    public static List<AggregateResult> getAccounts(string accountName, string stateFilter, boolean loyaltyFilter){
        try{
        Id currentUser = UserInfo.getUserId();
        String stateFilterUpper;
            
        if(stateFilter !=null ){
           stateFilterUpper = stateFilter.toUppercase();
        }        
        //Get current list of territor for logged on user.
        List<Territory__c> lstTerritory = [SELECT id FROM Territory__c 
                                           WHERE (Active__c = true) AND
                                           (Sales_Rep__c = :currentUser OR 
                                            Sales_Rep2__c = :currentUser OR
                                            Sales_Rep3__c = :currentUser OR
                                            Sales_Rep4__c = :currentUser OR
                                            Sales_Rep5__c = :currentUser)
                                          ];
        
        List<Territory_Assignment__c> lstTerritoryAssignment = [SELECT FIPS_Code__c FROM Territory_Assignment__c WHERE Territory__c IN :lstTerritory];
        
        Set<String> setFipsCode = new Set<String>();
        
        For(Territory_Assignment__c ta : lstTerritoryAssignment){
            
            setFipsCode.add(ta.FIPS_Code__c);
        }
        
        List<Zip_to_Fips__c> lstZiptoFips = [SELECT Name FROM Zip_to_Fips__c WHERE FIPS_Code__c IN :setFipsCode];
        
        Set<String> setZipCodes = new Set<String>();
        
        for(Zip_to_Fips__c zipToFip : lstZiptoFips){
            setZipCodes.add(zipToFip.Name);
        }
        
        
        //Adding logic to make searchValue usable in SOQL LIKE statement. 
        //This will enable searching for any number or word that contains the search value, rather than an exact match.
        String fuzzySearch = '%' + accountName + '%';
        
        //Base String Query
        String accountContactQuery = 'Select account.id, account.Name, account.BillingStreet,'
            + ' account.BillingCity, account.BillingState, account.BillingPostalCode,'
            + ' account.BillingCountry, account.Phone'
            + ' from Contact'
            + ' WHERE (account.RecordType.Name = \'Indirect Accounts\' AND account.BillingPostalCode != Null AND account.BillingPostalCode IN :setZipCodes)'; 
        
        //system.debug(fuzzySearch);
        //All search conditions filled in.
        if(accountName != null && stateFilterUpper != null && loyaltyFilter) {
            accountContactQuery += ' AND ((account.Name LIKE :fuzzySearch AND account.BillingState = :stateFilterUpper) AND (CCB_Eligibility__c = \'Eligible\'))';
        }
        //Account Name and Loyalty filter.
        else if(accountName != null && stateFilterUpper == null && loyaltyFilter) {
            accountContactQuery += ' AND (account.Name LIKE :fuzzySearch) AND (CCB_Eligibility__c = \'Eligible\')';
        }
        //State and Account filter.
        else if(accountName != null && stateFilterUpper != null) {
            accountContactQuery += ' AND (account.Name LIKE :fuzzySearch AND account.BillingState = :stateFilterUpper)';
        }
        //State and Loyalty filter.
        else if(accountName == null && stateFilterUpper != null && loyaltyFilter) {
            accountContactQuery += ' AND (account.BillingState = :stateFilterUpper) AND (CCB_Eligibility__c = \'Eligible\')';
        }  
        //State filter.
        else if(stateFilterUpper != null) {
            accountContactQuery += ' AND (account.BillingState = :stateFilterUpper)';
        }
        //Account filter.
        else if(accountName != null) {
            accountContactQuery += ' AND (account.Name LIKE :fuzzySearch)';
        }
        //Loyalty filter.
        else if(loyaltyFilter) {
            accountContactQuery += ' AND (CCB_Eligibility__c = \'Eligible\')';
        }
        
        accountContactQuery += ' GROUP BY account.id, account.Name, account.BillingStreet, '
            				+ 'account.BillingCity,account.BillingState, account.BillingPostalCode, '
             				+ 'account.BillingCountry, account.Phone ORDER BY account.Name DESC LIMIT 10000';
        
        system.debug('accountContactQuery => ' + accountContactQuery);
        
        List<AggregateResult> accountContacts = new List<AggregateResult>();
            
		accountContacts = Database.query(accountContactQuery); 
        
        //returning list of result via SOQL query.
        return accountContacts;        
    }catch(Exception e){
        system.debug(e);
        system.debug(e.getLineNumber());
        return null;
    }

    }    
 
    @AuraEnabled
    public static List<String> getStates(){
        
        Id currentUser = UserInfo.getUserId();
        
        //Get current list of territor for logged on user.
        List<Territory__c> lstTerritory = [SELECT id FROM Territory__c 
                                           WHERE (Active__c = true) AND
                                           (Sales_Rep__c = :currentUser OR 
                                            Sales_Rep2__c = :currentUser OR
                                            Sales_Rep3__c = :currentUser OR
                                            Sales_Rep4__c = :currentUser OR
                                            Sales_Rep5__c = :currentUser)
                                          ];
        
        List<Territory_Assignment__c> lstTerritoryAssignment = [SELECT FIPS_Code__c FROM Territory_Assignment__c WHERE Territory__c IN :lstTerritory];
        
        Set<String> setFipsCode = new Set<String>();
        
        For(Territory_Assignment__c ta : lstTerritoryAssignment){
            
            setFipsCode.add(ta.FIPS_Code__c);
        }
        
        List<Zip_to_Fips__c> lstZiptoFips = [SELECT Name FROM Zip_to_Fips__c WHERE FIPS_Code__c IN :setFipsCode];
        
        Set<String> setZipCodes = new Set<String>();
        
        for(Zip_to_Fips__c zipToFip : lstZiptoFips){
            setZipCodes.add(zipToFip.Name);
        }
        
        List<AggregateResult> lstConatcts = [SELECT account.BillingState
                                     FROM Contact
                                     WHERE (account.RecordType.Name = 'Indirect Accounts' 
                                     AND account.BillingPostalCode != Null AND account.BillingPostalCode IN :setZipCodes) GROUP BY account.BillingState];
        
        Set<String> setStates = new Set<String>();
        
        for(AggregateResult  c : lstConatcts){
            string stateCode = String.valueOf(c.get('BillingState'));
            setStates.add(stateCode);
        }
        
        List<String> lstStates = new List<String>();
        
        for(String sc : setStates){
            
            lstStates.add(sc);
        }
        
        return lstStates;
        
    }
    
}