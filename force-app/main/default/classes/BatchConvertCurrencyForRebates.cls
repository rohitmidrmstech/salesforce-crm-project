global class BatchConvertCurrencyForRebates implements Database.Batchable<sObject>, Database.Stateful, Schedulable{
    global static final String CAD_CURRENCY = 'CAD';
    global static final String CANADA_FULL_NAME = 'Canada';
    global static final String CANADA_COUNTRY_CODE = 'CA';
    global static final String CLAIM_REBATE_APPROVED_STATUS = 'claim Approved';
    global static final String STATUS_AFTER_CURRENCY_CONVERSION = 'Pending Card Funding';
    global static boolean currencyConversionInProgress = false;
    
    Exchange_Rate__c latestExchangeRate;
    Id cpRebateClaimRecordTypeId;

    global Database.QueryLocator start(Database.BatchableContext BC) {
        latestExchangeRate = getLatestExchangeRate(CAD_CURRENCY);
        cpRebateClaimRecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CP_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId();

        Set<Id> recordTypesForCurrencyConversion = new Set<Id>();
        recordTypesForCurrencyConversion.add(Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(CCBClaimFormController.CCB_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId());
        recordTypesForCurrencyConversion.add(cpRebateClaimRecordTypeId);
        system.debug('Test');
        system.debug('recordId'+recordTypesForCurrencyConversion);
		system.debug('Rebates'+[Select Id, Submitted_By__c, Submitted_By__r.MailingCountry, RecordTypeId, Total_Rebate_Amount__c, Rebate_Program_Member__r.RebateProgram.Name FROM Rebate_Claim__c WHERE Status__c =:CLAIM_REBATE_APPROVED_STATUS AND RecordTypeId in: recordTypesForCurrencyConversion AND Rebate_Program_Member__r.RebateProgram.Name LIKE 'Contractor%']);
        return Database.getQueryLocator('Select Id, Submitted_By__c, Submitted_By__r.MailingCountry, RecordTypeId, Total_Rebate_Amount__c, Rebate_Program_Member__r.RebateProgram.Name FROM Rebate_Claim__c WHERE Status__c =:CLAIM_REBATE_APPROVED_STATUS AND RecordTypeId in: recordTypesForCurrencyConversion AND Rebate_Program_Member__r.RebateProgram.Name LIKE \'Contractor%\'');
    }
    global Void execute(Database.BatchableContext BC, List<sObject> scope) {
        BatchConvertCurrencyForRebates.currencyConversionInProgress = true;
        List<Rebate_Claim__c> rebateClaims = (List<Rebate_Claim__c>)scope;
        Set<Id> canadianRebateClaimIds = new Set<Id>();
        for(Rebate_Claim__c rebateClaim: rebateClaims){
            if(rebateClaim.Submitted_By__c != null 
            && (CANADA_COUNTRY_CODE.equalsIgnoreCase(rebateClaim.Submitted_By__r.MailingCountry) || CANADA_FULL_NAME.equalsIgnoreCase(rebateClaim.Submitted_By__r.MailingCountry))){
                canadianRebateClaimIds.add(rebateClaim.Id);
            }
        }
        System.debug(JSON.serialize(rebateClaims));
        system.debug('test');

        //maps
        Map<Id,List<TransactionJournal>> transactionJournalsByRebateClaimMap = new Map<Id,List<TransactionJournal>>();
        Map<Id,List<RebateMemberProductAggregate>> rebateMemberProductAggregatesByRebateClaimMap = new Map<Id,List<RebateMemberProductAggregate>>();
        Map<Id,List<RebateMemberAggregateItem>> rebateMemberAggregateItemsByRebateClaimMap = new Map<Id,List<RebateMemberAggregateItem>>();
        Map<Id,List<Rebate_Claim_Aggregate__c>> rebateClaimAggregateByRebateClaimMap = new Map<Id,List<Rebate_Claim_Aggregate__c>>();
        Map<Id,List<ProgramRebateTypePayout>> rebateTypePayoutByRebateClaimMap = new Map<Id,List<ProgramRebateTypePayout>>();
        Map<Id,List<ProgramRebateTypPayoutSrc>> rebateTypePayoutSrcByRebateClaimMap = new Map<Id,List<ProgramRebateTypPayoutSrc>>();

        

        if(!canadianRebateClaimIds.isEmpty() && latestExchangeRate != null){
            Decimal currencyMultiplier = 1/latestExchangeRate.Exchange_Rate__c;

            populateJournalsMap(canadianRebateClaimIds, transactionJournalsByRebateClaimMap, currencyMultiplier, latestExchangeRate);
            populateRebateMemberProductAggregatesMap(canadianRebateClaimIds, rebateMemberProductAggregatesByRebateClaimMap, currencyMultiplier,latestExchangeRate);
            populateRebateMemberAggregateItemsMap(canadianRebateClaimIds, rebateMemberAggregateItemsByRebateClaimMap, currencyMultiplier, latestExchangeRate);
            populateRebateClaimAggregatesMap(canadianRebateClaimIds, rebateClaimAggregateByRebateClaimMap, currencyMultiplier, latestExchangeRate);   
            populateRebateTypePayoutsMap(canadianRebateClaimIds, rebateTypePayoutByRebateClaimMap, currencyMultiplier, latestExchangeRate); 
            populateRebateTypePayoutSrcMap(canadianRebateClaimIds, rebateTypePayoutSrcByRebateClaimMap, currencyMultiplier, latestExchangeRate);
        }      
        
        //loop through all Rebate Claims and Update status and conver currency on associated records as needed
        for(Rebate_Claim__c rebateClaim: rebateClaims){
            Savepoint sp = Database.setSavepoint();
            try{
                
                if(transactionJournalsByRebateClaimMap.containsKey(rebateClaim.Id)){
                    update transactionJournalsByRebateClaimMap.get(rebateClaim.Id);
                    System.debug('transactionJournalsByRebateClaimMap: ' + JSON.serialize(transactionJournalsByRebateClaimMap.get(rebateClaim.Id)));
                }
                if(rebateMemberProductAggregatesByRebateClaimMap.containsKey(rebateClaim.Id)){
                    update rebateMemberProductAggregatesByRebateClaimMap.get(rebateClaim.Id);
                    System.debug('populateRebateMemberProductAggregatesMap: ' + JSON.serialize(rebateMemberProductAggregatesByRebateClaimMap.get(rebateClaim.Id)));
                }
                if(rebateMemberAggregateItemsByRebateClaimMap.containsKey(rebateClaim.Id)){
                    update rebateMemberAggregateItemsByRebateClaimMap.get(rebateClaim.Id);
                    System.debug('rebateMemberAggregateItemsByRebateClaimMap: ' + JSON.serialize(rebateMemberAggregateItemsByRebateClaimMap.get(rebateClaim.Id)));
                }
                if(rebateClaimAggregateByRebateClaimMap.containsKey(rebateClaim.Id)){
                    update rebateClaimAggregateByRebateClaimMap.get(rebateClaim.Id);
                    System.debug('rebateClaimAggregateByRebateClaimMap: ' + JSON.serialize(rebateClaimAggregateByRebateClaimMap.get(rebateClaim.Id)));
                }
                if(rebateTypePayoutByRebateClaimMap.containsKey(rebateClaim.Id)){
                    update rebateTypePayoutByRebateClaimMap.get(rebateClaim.Id);
                    System.debug('rebateTypePayoutByRebateClaimMap: ' + JSON.serialize(rebateTypePayoutByRebateClaimMap.get(rebateClaim.Id)));
                }
                if(rebateTypePayoutSrcByRebateClaimMap.containsKey(rebateClaim.Id)){
                    update rebateTypePayoutSrcByRebateClaimMap.get(rebateClaim.Id);
                    System.debug('rebateTypePayoutSrcByRebateClaimMap: ' + JSON.serialize(rebateTypePayoutSrcByRebateClaimMap.get(rebateClaim.Id)));
                }

                //update rebate claim
                if(!canadianRebateClaimIds.contains(rebateClaim.Id) || (canadianRebateClaimIds.contains(rebateClaim.Id) && latestExchangeRate != null)){
                    //update status
                    rebateClaim.Status__c = STATUS_AFTER_CURRENCY_CONVERSION;

                    if(canadianRebateClaimIds.contains(rebateClaim.Id)){
                        if(rebateClaim.Total_Rebate_Amount__c != null){
                            rebateClaim.Total_rebate_amt_USD_before_conv__c = rebateClaim.Total_Rebate_Amount__c;
                            rebateClaim.Total_Rebate_Amount__c = ((1/latestExchangeRate.Exchange_Rate__c) * rebateClaim.Total_Rebate_Amount__c).setScale(2);
                        }
                        rebateClaim.Claim_Currency__c = CAD_CURRENCY;
                        rebateClaim.Applied_Exchange_Rate__c = latestExchangeRate.Id;
                    }
                    System.debug('**** rebateClaim: ' + JSON.serialize(rebateClaim));
                    update rebateClaim;                    
                }
            }
            catch(Exception ex){
                Database.rollback(sp);
            }
        }
    }
    
    void populateJournalsMap(Set<Id> canadianRebateClaimIds,   Map<Id,List<TransactionJournal>> transactionJournalsByRebateClaimMap, Decimal currencyMultiplier, Exchange_Rate__c latestExchangeRate){
        //get transaction journals 
        for(TransactionJournal transactionJournal: [Select Id, Rebate_Claim__c, Rebate_Claim__r.RecordTypeId, TransactionAmount, 
                                                    Stone_Facade_Rebate_Amount__c,Applied_Benefit_Value__c, Claim_Currency__c 
                                                    from TransactionJournal 
                                                    where Rebate_Claim__c in: canadianRebateClaimIds]){
            if(!transactionJournalsByRebateClaimMap.containsKey(transactionJournal.Rebate_Claim__c)){
                transactionJournalsByRebateClaimMap.put(transactionJournal.Rebate_Claim__c, new List<TransactionJournal>());
            }
            //convert currency fields to CAD and save originals to original fields
            if(transactionJournal.TransactionAmount != null){
                transactionJournal.Transaction_Amount_in_USD_Before_Conv__c = transactionJournal.TransactionAmount;
                transactionJournal.TransactionAmount = (currencyMultiplier * transactionJournal.TransactionAmount).setScale(2);
            }
            if(transactionJournal.Stone_Facade_Rebate_Amount__c != null){
                transactionJournal.Stone_Facade_Rebate_in_USD_Before_Conv__c = transactionJournal.Stone_Facade_Rebate_Amount__c;
                transactionJournal.Stone_Facade_Rebate_Amount__c = (currencyMultiplier * transactionJournal.Stone_Facade_Rebate_Amount__c).setScale(2);
            }
            if(transactionJournal.Rebate_Claim__r.RecordTypeId != cpRebateClaimRecordTypeId && transactionJournal.Applied_Benefit_Value__c != null){
                transactionJournal.Applied_Benefits_in_CAD__c = (currencyMultiplier * transactionJournal.Applied_Benefit_Value__c).setScale(2);
            }
            transactionJournal.Applied_Exchange_Rate__c = latestExchangeRate.Id;
            transactionJournal.Claim_Currency__c = CAD_CURRENCY;

            //add transaction Journal to map
            transactionJournalsByRebateClaimMap.get(transactionJournal.Rebate_Claim__c).add(transactionJournal);
        }
    }

    void populateRebateMemberProductAggregatesMap(Set<Id> canadianRebateClaimIds,   Map<Id,List<RebateMemberProductAggregate>> rebateMemberProductAggregatesByRebateClaimMap, Decimal currencyMultiplier, Exchange_Rate__c latestExchangeRate){
        //get RebateMemberProductAggregate
        for(RebateMemberProductAggregate rebateMemberProductAggregate: [Select Id,Rebate_Claim__c, TotalTransactionAmount, Claim_Currency__c
                                                                        from RebateMemberProductAggregate 
                                                                        where Rebate_Claim__c in: canadianRebateClaimIds]){
            if(!rebateMemberProductAggregatesByRebateClaimMap.containskey(rebateMemberProductAggregate.Rebate_Claim__c)){
                rebateMemberProductAggregatesByRebateClaimMap.put(rebateMemberProductAggregate.Rebate_Claim__c, new List<RebateMemberProductAggregate>());
            }
            if(rebateMemberProductAggregate.TotalTransactionAmount != null){
                rebateMemberProductAggregate.Total_transaction_amt_USD_before_conv__c = rebateMemberProductAggregate.TotalTransactionAmount;
                rebateMemberProductAggregate.TotalTransactionAmount = (currencyMultiplier * rebateMemberProductAggregate.TotalTransactionAmount).setScale(2);
            }
            rebateMemberProductAggregate.Claim_Currency__c = CAD_CURRENCY;
            rebateMemberProductAggregate.Applied_Exchange_Rate__c = latestExchangeRate.Id;
            rebateMemberProductAggregatesByRebateClaimMap.get(rebateMemberProductAggregate.Rebate_Claim__c).add(rebateMemberProductAggregate);
        }
    }

    void populateRebateMemberAggregateItemsMap(Set<Id> canadianRebateClaimIds,   Map<Id,List<RebateMemberAggregateItem>> rebateMemberAggregateItemsByRebateClaimMap, Decimal currencyMultiplier, Exchange_Rate__c latestExchangeRate){
        //get RebateMemberAggregateItem
        for(RebateMemberAggregateItem rebateMemberAggregateItem: [Select Id,Rebate_Claim__c, TransactionAmount, RebateAmount, Claim_Currency__c
                                                                 from RebateMemberAggregateItem 
                                                                 where Rebate_Claim__c in: canadianRebateClaimIds]){
            if(!rebateMemberAggregateItemsByRebateClaimMap.containskey(rebateMemberAggregateItem.Rebate_Claim__c)){
                rebateMemberAggregateItemsByRebateClaimMap.put(rebateMemberAggregateItem.Rebate_Claim__c, new List<RebateMemberAggregateItem>());
            }
            if(rebateMemberAggregateItem.TransactionAmount != null){
                rebateMemberAggregateItem.Transaction_Amount_in_USD_Before_Conv__c = rebateMemberAggregateItem.TransactionAmount;
                rebateMemberAggregateItem.TransactionAmount = (currencyMultiplier * rebateMemberAggregateItem.TransactionAmount).setScale(2);
            }
            if(rebateMemberAggregateItem.RebateAmount != null){
                rebateMemberAggregateItem.Rebate_Amt_in_USD_before_conv__c = rebateMemberAggregateItem.RebateAmount;
                rebateMemberAggregateItem.RebateAmount = currencyMultiplier * rebateMemberAggregateItem.RebateAmount;
            }
            rebateMemberAggregateItem.Claim_Currency__c = CAD_CURRENCY;
            rebateMemberAggregateItem.Applied_Exchange_Rate__c = latestExchangeRate.Id;
            rebateMemberAggregateItemsByRebateClaimMap.get(rebateMemberAggregateItem.Rebate_Claim__c).add(rebateMemberAggregateItem);
        }
    }

    void populateRebateClaimAggregatesMap(Set<Id> canadianRebateClaimIds,   Map<Id,List<Rebate_Claim_Aggregate__c>> rebateClaimAggregateByRebateClaimMap, Decimal currencyMultiplier, Exchange_Rate__c latestExchangeRate){
        //get Rebate_Claim_Aggregate__c
        for(Rebate_Claim_Aggregate__c rebateClaimAggregate: [Select Id,Rebate_Claim__c, Total_Rebate_Amount__c,  Currency__c
                                                                 from Rebate_Claim_Aggregate__c 
                                                                 where Rebate_Claim__c in: canadianRebateClaimIds]){
            if(!rebateClaimAggregateByRebateClaimMap.containskey(rebateClaimAggregate.Rebate_Claim__c)){
                rebateClaimAggregateByRebateClaimMap.put(rebateClaimAggregate.Rebate_Claim__c, new List<Rebate_Claim_Aggregate__c>());
            }
            if(rebateClaimAggregate.Total_Rebate_Amount__c != null){
                rebateClaimAggregate.Total_rebate_amt_USD_before_conv__c = rebateClaimAggregate.Total_Rebate_Amount__c;
                rebateClaimAggregate.Total_Rebate_Amount__c = (currencyMultiplier * rebateClaimAggregate.Total_Rebate_Amount__c).setScale(2);
            }
            
            rebateClaimAggregate.Currency__c = CAD_CURRENCY;
            rebateClaimAggregate.Applied_Exchange_Rate__c = latestExchangeRate.Id;
            rebateClaimAggregateByRebateClaimMap.get(rebateClaimAggregate.Rebate_Claim__c).add(rebateClaimAggregate);
        }
    }

    void populateRebateTypePayoutsMap(Set<Id> canadianRebateClaimIds,   Map<Id,List<ProgramRebateTypePayout>> rebateTypePayoutByRebateClaimMap, Decimal currencyMultiplier, Exchange_Rate__c latestExchangeRate){
        //get ProgramRebateTypePayout
        for(ProgramRebateTypePayout programRebateTypePayout: [Select Id, Transaction_Amount__c, Claim_Currency__c, Rebate_Claims__c
                                                                 from ProgramRebateTypePayout 
                                                                 where Rebate_Claims__c in: canadianRebateClaimIds]){
            if(!rebateTypePayoutByRebateClaimMap.containskey(programRebateTypePayout.Rebate_Claims__c)){
                rebateTypePayoutByRebateClaimMap.put(programRebateTypePayout.Rebate_Claims__c, new List<ProgramRebateTypePayout>());
            }
            if(programRebateTypePayout.Transaction_Amount__c != null){
                programRebateTypePayout.Transaction_Amount_in_USD_Before_Conv__c = programRebateTypePayout.Transaction_Amount__c;
                programRebateTypePayout.Transaction_Amount__c = currencyMultiplier * programRebateTypePayout.Transaction_Amount__c;
            }
            
            programRebateTypePayout.Claim_Currency__c = CAD_CURRENCY;
            programRebateTypePayout.Applied_Exchange_Rate__c = latestExchangeRate.Id;
            rebateTypePayoutByRebateClaimMap.get(programRebateTypePayout.Rebate_Claims__c).add(programRebateTypePayout);
        }
    }

    void populateRebateTypePayoutSrcMap(Set<Id> canadianRebateClaimIds,   Map<Id,List<ProgramRebateTypPayoutSrc>> rebateTypePayoutSrcByRebateClaimMap, Decimal currencyMultiplier, Exchange_Rate__c latestExchangeRate){
        //get ProgramRebateTypPayoutSrc
        for(ProgramRebateTypPayoutSrc programRebateTypPayoutSrc: [Select Id, Claim_Currency__c, ProgramRebateTypePayout.Rebate_Claims__c, RebateAmount
                                                                 from ProgramRebateTypPayoutSrc 
                                                                 where ProgramRebateTypePayout.Rebate_Claims__c in: canadianRebateClaimIds]){
            if(!rebateTypePayoutSrcByRebateClaimMap.containskey(programRebateTypPayoutSrc.ProgramRebateTypePayout.Rebate_Claims__c)){
                rebateTypePayoutSrcByRebateClaimMap.put(programRebateTypPayoutSrc.ProgramRebateTypePayout.Rebate_Claims__c, new List<ProgramRebateTypPayoutSrc>());
            }
            if(programRebateTypPayoutSrc.RebateAmount != null){
                programRebateTypPayoutSrc.Rebate_Amt_in_USD_before_conv__c = programRebateTypPayoutSrc.RebateAmount;
                programRebateTypPayoutSrc.RebateAmount = (currencyMultiplier * programRebateTypPayoutSrc.RebateAmount).setScale(2);
            }
            
            programRebateTypPayoutSrc.Claim_Currency__c = CAD_CURRENCY;
            programRebateTypPayoutSrc.Applied_Exchange_Rate__c = latestExchangeRate.Id;
            rebateTypePayoutSrcByRebateClaimMap.get(programRebateTypPayoutSrc.ProgramRebateTypePayout.Rebate_Claims__c).add(programRebateTypPayoutSrc);
        }
    }


    static Exchange_Rate__c getLatestExchangeRate(String currencyCode){
        Exchange_Rate__c latestExchangeRate;
        List<Exchange_Rate__c> exchangeRates = [Select Id,Date__c, Exchange_Rate__c, Currency__c 
                                                from Exchange_Rate__c 
                                                where Currency__c =: currencyCode order by Date__c desc, Createddate desc limit 1];
        if(!exchangeRates.isEmpty()){
            latestExchangeRate = exchangeRates[0];
        }
        return latestExchangeRate;
    }

    global void finish(Database.BatchableContext BC) {
    }

    global void execute(SchedulableContext sc) {
        Integer batchSize = 10;
        if(Rebate_Settings__c.getInstance() != null && Rebate_Settings__c.getInstance().Currency_Conversion_Batch_Size__c != null){
            batchSize = Integer.valueOf(Rebate_Settings__c.getInstance().Currency_Conversion_Batch_Size__c);
        }
        Database.executeBatch(new BatchConvertCurrencyForRebates(), batchSize);
    }
}