/****************************************************************************************************************************************
*    @description     : it processes incoming customer data, checks for duplicates while Creating If Found Any duplicate"AIMS_Customer__c" Id it will Ignore that Account record,
and creates new Salesforce Account records. It also handles errors and logs integration details for future reference.
*    @ date           : 06-OCT-2023
*    @ Created By     : Sujata p. Galinde
*****************************************************************************************************************************************/
@RestResource(urlMapping='/aimsCustomerIntegration')
global class AimsCustomerIntegration {
    @HttpPost
    global static AimsIntegrationResult createAccounts(List<SObject> customers){
        System.debug('customers==' + customers);
        AimsIntegrationResult accountsInsertResult = new AimsIntegrationResult();
        String CustTypeLog= 'AIMS Customer Integration Log';
        try{
            Set<String> setCustomerCodes = new Set<String>();
            Map<String, Id> mapExistingCustomersCustIds = new Map<String, Id> ();
            List<AimsIntegrationResult.SaveResult> existingAccounts = new List<AimsIntegrationResult.SaveResult> ();
            List<AimsIntegrationResult.SaveResult> lstUnprocessedCustomers = new List<AimsIntegrationResult.SaveResult> ();
            for (SObject customer : customers) {
                String aimsCustomerValue = (String) customer.get('AIMS_Customer__c');
                System.debug('aimsCustomerValue==' + aimsCustomerValue);
               setCustomerCodes.add(aimsCustomerValue);
            }       
            List<Account> lstAccounts = [SELECT Id, AIMS_Customer__c FROM Account WHERE AIMS_Customer__c IN :setCustomerCodes];
            for (Account account : lstAccounts) {
                mapExistingCustomersCustIds.put(account.AIMS_Customer__c, account.Id);
            }
            List<Account> lstAccountsToInsert = new List<Account> ();
            // User ownerUser = [SELECT Id, Name FROM User WHERE Name = 'Clinton Pundick'];
            //Recordtype busineeAccountRecordType= [SELECT Id ,Name FROM RecordType WHERE Name ='Business Account'];
            for (SObject cust : customers) {
                try{
                    String custcode = (String) cust.get('AIMS_Customer__c');
                    if (mapExistingCustomersCustIds.containsKey(custcode)) {
                        existingAccounts.add(new AimsIntegrationResult.SaveResult(custCode,CustTypeLog, true, 'Existing Account', mapExistingCustomersCustIds.get(custcode)));
                    }else{
                        SObject sb = Schema.getGlobalDescribe().get('Account').newSObject();
                        String pattern = '[0-9]+$';
                        String Name = (String) cust.get('Name');
                        String AccountName = Name?.replaceAll(pattern, '').trim();
                        sb.put('Name' , AccountName);
                        sb.put('AIMS_Customer__c' , (String) cust.get('AIMS_Customer__c'));
                        sb.put('Type' , (String) cust.get('Type'));
                        sb.put('BillingPostalCode' , (String) cust.get('BillingPostalCode'));
                        sb.put('Phone' , (String) cust.get('Phone'));
                        sb.put('BillingCity' , (String) cust.get('BillingCity'));
                        sb.put('BillingStreet' , (String) cust.get('BillingStreet'));
                        sb.put('Address_Description__c' , (String) cust.get('Address_Description__c'));
                        Account newAccount = (Account) sb;
                        lstAccountsToInsert.add(newAccount);
                        System.debug('lstAccountsToInsert ==' + lstAccountsToInsert);
                   }
                }catch(Exception e){
                    String custcode = (String) cust.get('AIMS_Customer__c');
                    lstUnprocessedCustomers.add(new AimsIntegrationResult.SaveResult(custcode,CustTypeLog, false, 'Error while converting Customer to Salesforce Account - ' + e.getMessage(), ''));
                }
            }
            List<Database.SaveResult>  lstInsertAccountsRes = Database.insert(lstAccountsToInsert, false);         
            Integer i = 0;
            for(Database.SaveResult res : lstInsertAccountsRes){
               accountsInsertResult.addIndividualResult(new AimsIntegrationResult.SaveResult(lstAccountsToInsert[i].AIMS_Customer__c,CustTypeLog, res));
                i++;
            }
            accountsInsertResult.addResults(existingAccounts);
            accountsInsertResult.addResults(lstUnprocessedCustomers);
            List<AIMSIntegrationLog__c> logss = accountsInsertResult.getIntegrationLogss();
            Database.Insert(logss, false);
        }catch(Exception e){
            AIMSIntegrationLog__c errorLog = new AIMSIntegrationLog__c(Name = CustTypeLog , Success__c=false, Error_Details__c = 'Error in AimsCustomerIntegration : ' + e.getMessage());
            insert errorLog;
           throw new AimsIntegrationException(e);
        }finally{
            
        }
        return accountsInsertResult;
    }
    
}