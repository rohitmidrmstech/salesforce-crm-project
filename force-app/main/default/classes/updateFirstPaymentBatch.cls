global class updateFirstPaymentBatch implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
         // String salesOrg = '1502'; CER-230 
        Set<String> salesOrg = new Set<String>{'1502', '1018', '1019','1020'}; // CER-230
        String paidYN='Yes';
        String sentToSAP ='Success';
        String logRTname='Log';
        String query = 'select id, Claim__r.id from WOD_Payment__c where Sales_Org__c =:salesOrg and Paid_Y_N__c =:paidYN and Updated_First_Payment__c=false and (Sent_to_SAP__c like \'%'+ sentToSAP +'%\' or recordtype.developername=:logRTname)';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<WOD_Payment__c> paymentList) {
        List<Id> claimIds=new List<Id>();
        // process each batch of records default size is 200
        for(WOD_Payment__c rec : paymentList) {        
            // Update the Account Name 
            claimIds.add(rec.Claim__r.id);
        }
        try {
            WOD_ClaimTriggerHandler.updateOldestPaymentdateOnClaim(claimIds);
         
        } catch(Exception e) {
            System.debug(e);
        }
         
    }   
     
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}