public class processRebateClaimQueueable  implements Queueable {
  public  List<Id> rebateClaimIds;
  public  List<Rebate_Claim__c>  listrebateClaims;
  public String oldMapJson;
    public processRebateClaimQueueable(List<Id> rebateClaimIds,
                                       List<Rebate_Claim__c> listrebateClaims,
                                       String oldMapJson
                                      ) {
        this.rebateClaimIds = rebateClaimIds;
        this.listrebateClaims=listrebateClaims;
        this.oldMapJson=oldMapJson;
                                    
    }

    public void execute(QueueableContext context) {
        // Delete related transaction records related to the  rebate claim
         Map<Id, Rebate_Claim__c> oldMap = (Map<Id, Rebate_Claim__c>) JSON.deserialize(oldMapJson, Map<Id, Rebate_Claim__c>.class);
        List<TransactionJournal> transactionJournal = [SELECT Id,Rebate_Claim__c  FROM TransactionJournal WHERE Rebate_Claim__c IN :rebateClaimIds];
        if (!transactionJournal.isEmpty()) {
            delete transactionJournal;
        }

        // Call the method to process rebate claims
       TransactionJournalCreatorForRebateClaims.processQACompletedRebateClaim(rebateClaimIds,listrebateClaims,oldMap);
    }   

}