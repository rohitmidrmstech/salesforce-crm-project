/****************************************************************************************************************************************
*    @description     : The AimsQuoteIntegration class provides a crucial integration point between external systems (possibly a Java SQL server) and Salesforce. 
It processes incoming Quote data, and creates new Salesforce Opportunity  records  and update the existing records Based on ExternalId of "QuoteNumber" It also handles errors and logs integration details for future reference.
*    @ date           : 06-OCT-2023
*    @ Created By     : Sujata p. Galinde
*****************************************************************************************************************************************/
@RestResource(urlMapping='/aimsQuoteIntegration')
global class AimsQuoteIntegration {
    @HttpPost
    global static AimsIntegrationResult  upsertOpportunities(List<SObject> quotes)  {
        System.debug('quotes==' + quotes);
        AimsIntegrationResult opportunityInsertResult = new AimsIntegrationResult();
        AimsIntegrationResult accountsInsertResult = new AimsIntegrationResult();
        List<AimsIntegrationResult.UpsertResult> lstUnprocessedQuotes = new List<AimsIntegrationResult.UpsertResult> ();
        List<AimsIntegrationResult.SaveResult> lstUnprocessedAccount = new List<AimsIntegrationResult.SaveResult>();
        List<Opportunity> listOpportunitiesToUpsert = new List<Opportunity>();
        String quoteTypeLog = 'AIMS Quote Integration Log';
        String custTypeLog ='AIMS Quote Account';       
        //User ownerUser = [SELECT Id, Name FROM User WHERE Name = 'Clinton Pundick'];
        //Recordtype retailSalesProcessRecordTypeId= [SELECT Id ,Name FROM RecordType WHERE Name ='Retail Sales Process'];
       // Recordtype busineeAccountRecordType= [SELECT Id ,Name FROM RecordType WHERE Name ='Business Account'];
        Set<String> AccountCustomercode = new Set<String>();
        try{
            for (SObject qt : quotes){
                System.debug('quotes ===in loop' + quotes);
                  String aimsCustomerValue = (String) qt.get('AccountId');
                  String NewQuoteStatus = (String) qt.get('NewQuoteStatus__c');
                  String order = (String) qt.get('order__c');
                AccountCustomercode.add(aimsCustomerValue);
                if(order == 'LOST'){
                   qt.put('StageName', 'Closed Lost');
                }else if (newQuoteStatus == 'WON'){
                   qt.put('StageName', 'Closed Won');
                }
               if(String.isNotBlank(newQuoteStatus) && String.isNotBlank(order))
                    quoteTypeLog = 'AIMS Won-Lost Quote Integration Log';
            } 
            List<Account> newAccountstoInsert = new List<Account>();
            Map<String, Account> custcodeToExistingAccountMap = new Map<String, Account>();
            Set<String> processedCustcodes = new Set<String>();
            List<Account> lstAccounts = [SELECT Id, AIMS_Customer__c FROM Account WHERE AIMS_Customer__c IN :AccountCustomercode];
            for (Account acc : lstAccounts) {
                custcodeToExistingAccountMap.put(acc.AIMS_Customer__c, acc);
            }
            /* Based on Quote Data Creating Account record on the Basis of AIMS_Customer Code */
            /* If AIMS_Customer  ExternalId Exist Don't create Account for that , creating Account for ExternalId Which is not Existing  */
            for (SObject qts : quotes) {
                  String custcode = (String) qts.get('AccountId');
                if (!processedCustcodes.contains(custcode)) {
                    try{
                        if (custcodeToExistingAccountMap.containsKey(custcode)) {
                            Account existingAccount = custcodeToExistingAccountMap.get(custcode);
                        } else {
                            String pattern = '[0-9]+$';
                              String AccountName = (String) qts.get('Account_Name_Description__c');
                               Account newAccount = new Account(
                                Name = AccountName?.replaceAll(pattern, '').trim(),
                                AIMS_Customer__c = custcode
                            );
                            newAccountstoInsert.add(newAccount);
                        }
                    }
                    catch(Exception e){
                        lstUnprocessedAccount.add(new AimsIntegrationResult.SaveResult(custcode,CustTypeLog, false, 'Error while converting  Quote Customers to Salesforce Account - ' + e.getMessage(), ''));
                    }
                    processedCustcodes.add(custcode);
                }
            }
                List<Database.SaveResult>  lstInsertAccounts = Database.insert(newAccountstoInsert, false);  
                Integer j = 0;
                for(Database.SaveResult res : lstInsertAccounts){
                    accountsInsertResult.addIndividualResult(new AimsIntegrationResult.SaveResult(newAccountstoInsert[j].AIMS_Customer__c,CustTypeLog, res));
                    j++;
                }
            accountsInsertResult.addResults(lstUnprocessedAccount);
            List<AIMSIntegrationLog__c> logss = accountsInsertResult.getIntegrationLogss();
            Database.Insert(logss, false); 
            
           /* Processing Quote and  Won -Lost Quote for Creating Opportunity into Salesforce */
            for (SObject qtes : quotes) {
                try{
                    String Stage = (String) qtes.get('StageName');
                    String lostReason = (String) qtes.get('Lost_Reason__c');
                    if(Stage =='Closed Lost' && lostReason!= null && lostReason!=''){
                          qtes.put('Lost_Reason_for_Other__c', lostReason);
                          qtes.put('Lost_Reason__c', 'Other');
                    }else if(Stage =='Closed Lost' && (lostReason == null || lostReason =='')){
                          qtes.put('Lost_Reason__c', 'Other');
                          qtes.put('Lost_Reason_for_Other__c', 'None');
                    }  
                      SObject sb = Schema.getGlobalDescribe().get('Opportunity').newSObject();
                        String pattern = '[0-9]+$';
                        String Name = (String) qtes.get('Name');
                        String OpportunityName= Name?.replaceAll(pattern, '').trim();  
                        sb.put('Name' , OpportunityName);
                        sb.put('Quote_Number__c' , (String) qtes.get('Quote_Number__c'));      
                        sb.put('CloseDate' , (Date) qtes.get('CloseDate'));
                        sb.put('StageName' , (String) qtes.get('StageName'));  
                        sb.put('ForecastCategoryName' , (String) qtes.get('ForecastCategoryName')); 
                        sb.put('Mailing_Street__c' , (String) qtes.get('Mailing_Street__c')); 
                        sb.put('QuoteDate__c' , (Date) qtes.get('QuoteDate__c')); 
                        sb.put('Amount' , (Decimal) qtes.get('Amount')); 
                        sb.put('Manufacturing_Amount__c' , (Decimal) qtes.get('Manufacturing_Amount__c')); 
                        sb.put('Manufacturing_Required__c' , (String) qtes.get('Manufacturing_Required__c')); 
                        sb.put('LeadSource' , (String) qtes.get('LeadSource')); 
                        sb.put('Lost_Reason__c' , (String) qtes.get('Lost_Reason__c')); 
                        sb.put('Lost_Reason_for_Other__c' , (String) qtes.get('Lost_Reason_for_Other__c')); 
                        sb.put('Account_Name_Description__c' , (String) qtes.get('Account_Name_Description__c')); 
                        String custcode = (String) qtes.get('AccountId');
                        Account accountReference = custcode != null ? new Account(AIMS_Customer__c = custcode) : null;
                        String branchId = (String) qtes.get('Branch__c');
                        Branch__c branchReference = branchId != null ? new Branch__c(Branch_Code__c = branchId) : null;
                        Opportunity newopp = (Opportunity) sb;
                        newopp.Account = accountReference;
                        newopp.Branch__r=branchReference;
                        listOpportunitiesToUpsert.add(newOpp);
                }catch(Exception e){
                   String quoteNumber = (String) qtes.get('Quote_Number__c');
                   String custcode = (String) qtes.get('AccountId');
                   lstUnprocessedQuotes.add(new AimsIntegrationResult.UpsertResult(quoteTypeLog, quoteNumber, custcode, false, 'Error while converting Quote to Salesforce Opportunity - ' + e.getMessage(), ''));
                }
            }
            List<Database.UpsertResult> lstupsertOpportunityRes = Database.upsert(listOpportunitiesToUpsert, Opportunity.Quote_Number__c, false);           
            Integer i = 0;
            for(Database.UpsertResult res : lstupsertOpportunityRes){
                opportunityInsertResult.addIndividualResult(new AimsIntegrationResult.UpsertResult(listOpportunitiesToUpsert[i].Quote_Number__c,quoteTypeLog, res));
                i++;
            }
            opportunityInsertResult.addResults(lstUnprocessedQuotes);
            List<AIMSIntegrationLog__c> logs = opportunityInsertResult.getIntegrationLogs();
            Database.insert(logs, false);
        }
        catch(Exception e){
            AIMSIntegrationLog__c errorLog = new AIMSIntegrationLog__c(Name = quoteTypeLog , Success__c=false, Error_Details__c = 'Error in AimsQuoteIntegration : ' + e.getMessage());
            insert errorLog;
            throw new AimsIntegrationException(e);
        }finally{
        }
        return opportunityInsertResult;
    }
    
}