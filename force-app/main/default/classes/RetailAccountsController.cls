/*
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Controller class for retailAccountSelector Lightning Web Component.
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Lou Bui (the.bui@saint-gobain.com)
        * @verstion       1.0
        * @created        2022-10-28
*/
/* Function to return list of Account records.
* @param
    *     - searchValue : search value from screen flow Retail Call Logger. This can be either a ZIP Code or City or Store Number.
    *     - searchMethod : search method value from screen flow Retail Call Logger. This can be either: CITY or ZIP or STORE.
    * @return - List of Account object records.
*/

public with sharing class RetailAccountsController {
    
    	@AuraEnabled(cacheable=true)
        public static List<Account> getRetailAccounts(string searchValue, string searchMethod) {
            
            //Adding logic to make searchValue usable in SOQL LIKE statement. 
            //This will enable searching for any number or word that contains the search value, rather than an exact match.
            String fuzzySearch = '%' + searchValue + '%';

            //Initializing a variable that only includes Retail Accounts to be used in SOQL query.
            Set<String> accountNameMatches = new Set<String> {'Lowe%','Home Depot%','Menard%'};

            //Base String Query
            String accountQuery = 'SELECT Id, Name, LOB__c, BillingStreet, BillingPostalCode, Type, RecordTypeId FROM Account WHERE RecordType.Name = \'Sold-To\' AND Name LIKE :accountNameMatches AND ';
            
            //logic to append the string query to either use the ZIP Code, or City, or Store Number to find the accounts.
            if(searchMethod == 'ZIP') {
                accountQuery += 'BillingPostalCode LIKE :fuzzySearch AND BillingPostalCode != null LIMIT 25';
            }
            else if(searchMethod == 'CITY') {
                accountQuery += 'BillingCity LIKE :fuzzySearch AND BillingCity != null LIMIT 25';
            }
            else if(searchMethod == 'STORE') {
                accountQuery += 'Store__c LIKE :fuzzySearch AND Store__c != null LIMIT 25';
            }
            
            
            List<Account> accounts = Database.query(accountQuery);    

            //returning list of result via SOQL query.
            return accounts;  
            
        }
    
   		@AuraEnabled(cacheable=true)
        public static List<Order> getRetailOrders(string accountId, string status, string orderStartDate) {
                
            Set<String> allStatus = new Set<String> {'ENTERED','ORDER CREATED','CREDIT HOLD','INCOMPLETE','REJECTED','SHIPPED','INVOICED','DELIVERY BLOCK'};
            
            String searchStatus;
 
            //Base String Query
            String orderQuery = 'Select Id, Name, Sold_To__r.Name, EffectiveDate, Status, Order_Total__c, Planned_Ship_Date__c, Ship_Date__c, Sold_To__c From Order WHERE Sold_To__c = :accountId AND '; 
            
             if(status == 'ALL') {
                orderQuery += 'EffectiveDate != null AND EffectiveDate >= ' + orderStartDate + ' AND Status IN :allStatus ORDER BY EffectiveDate DESC';
            }
            else {
                orderQuery += 'EffectiveDate != null AND EffectiveDate >= ' + orderStartDate + ' AND Status = :status ORDER BY EffectiveDate DESC';
            }
            
            system.debug('orderQuery:' + orderQuery);
            
            
            List<Order> lstOrders = Database.query(orderQuery);    

            //returning list of result via SOQL query.
            return lstOrders;  
            
        }
    	
    	@AuraEnabled(cacheable=true)
        public static List<Order> getRetailOrdersByPo(string poNumber) {
                
            //Base String Query
            String orderQuery = 'Select Id, Name, Sold_To__r.Name, EffectiveDate, Status, Order_Total__c, Planned_Ship_Date__c, Ship_Date__c, Sold_To__c From Order WHERE PoNumber = :poNumber AND PoNumber != null ORDER BY EffectiveDate DESC';
            
            List<Order> lstOrders = Database.query(orderQuery);    

            //returning list of result via SOQL query.
            return lstOrders;  
            
        }
    
    
    }