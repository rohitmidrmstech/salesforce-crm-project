public class BatchToCheckUnMappedRebateClaims implements Database.batchable<sobject>{ 
    //Quering data from ProgramRebateTypPayoutSrc object to identify the impacted records for BSP
    public Database.QueryLocator start(Database.BatchableContext BC){
        string query = 'Select Id,ProgramRebateTypePayout.Rebate_Claims__c,ProgramRebateTypePayout.Rebate_Claims__r.Name,Rebate_Business_Unit_Aggregate_Item__r.TransactionJournal.Rebate_Claim__r.Name,Rebate_Business_Unit_Aggregate_Item__r.TransactionJournal.TransactionAmount from ProgramRebateTypPayoutSrc where ProgramRebateTypePayout.Rebate_Claims__r.Program_Name__c =\'Building Solutions Program\' AND  Rebate_Business_Unit_Aggregate_Item__r.TransactionJournal.Rebate_Claim__r.Program_Name__c = \'Contractor Cashback\'AND ProgramRebateTypePayout.Sent_To_SAP__c=false AND (ProgramRebateTypePayout.Rebate_Claims__r.Status__c = \'Claim Approved\'OR ProgramRebateTypePayout.Rebate_Claims__r.Status__c = \'Audit 1\')';
        return database.getquerylocator(query);
    }     
    public void execute(Database.BatchableContext info, List<ProgramRebateTypPayoutSrc> scope){
        try{
            if(scope.size()>0){                
                Map<Id, Decimal> idToAmountSumMap = new Map<Id, Decimal>();                
                list<Rebate_Claim__c> rebateClaimsListUpdate = new list<Rebate_Claim__c>(); 
                set<Id> setidforpayout = new Set<Id>();
                for (ProgramRebateTypPayoutSrc record : scope) {
                    // Check if the map already contains the Id
                    if (idToAmountSumMap.containsKey(record.ProgramRebateTypePayout.Rebate_Claims__c)) {
                        // If the Id exists
                        system.debug('Test-->'+record);
                        idToAmountSumMap.put(record.ProgramRebateTypePayout.Rebate_Claims__c, idToAmountSumMap.get(record.ProgramRebateTypePayout.Rebate_Claims__c) + record.Rebate_Business_Unit_Aggregate_Item__r.TransactionJournal.TransactionAmount);
                    } else{
                        // If the Id doesn't exist
                        idToAmountSumMap.put(record.ProgramRebateTypePayout.Rebate_Claims__c, record.Rebate_Business_Unit_Aggregate_Item__r.TransactionJournal.TransactionAmount);
                    }
                }
                for(id ids : idToAmountSumMap.keyset()){
                    Rebate_Claim__c rebate = new Rebate_Claim__c(id=ids);
                    rebate.Disputed_Amount__c = idToAmountSumMap.get(ids);           //assigning value of diff amount to disputed amount field
                    rebate.Review__c = 'Review Needed';                             //assigning value 'Review Needed' to review__c to the claims which are wrongly tagged.
                    rebate.Status__c = 'Audit 1';
                    rebateClaimsListUpdate.add(rebate);
                }
                if(rebateClaimsListUpdate.size()>0){
                    update rebateClaimsListUpdate;
                } 
            }
        }catch(exception ex){
            system.debug('exception--->'+ex);
            HandleCustomLogsException.LogException(ex);
        }        
    } 
    public void finish(Database.BatchableContext info){     
    } 
}