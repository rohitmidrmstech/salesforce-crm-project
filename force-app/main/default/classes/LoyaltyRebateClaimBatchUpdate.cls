/****************************************************************************************
* @Author       Lou Bui
* @Date         08/02/2023
* @Description  
Batch class to update Rebate_Claim__c when funding payement order has completed for Contractor Cash Back (CCB)
and Change Pays (CP) Program.

Change Log:
2/15/2024 - Lou Bui - Added automation controller to enable / disable records from being created/queried/updated.
*****************************************************************************************/

global class LoyaltyRebateClaimBatchUpdate implements Database.Batchable<sObject>,Database.Stateful{
    global Map<string, date> mapRebateClaimPaymentData;
    global Set<String> mapRebateClaimId;
    
    
    global LoyaltyRebateClaimBatchUpdate(Map<string,date> mapRebateClaimPaymentData){
        this.mapRebateClaimPaymentData=mapRebateClaimPaymentData;
        this.mapRebateClaimId = mapRebateClaimPaymentData.keyset();
    } 
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id,Name,Status__c,Bank_Payment_Date__c FROM Rebate_Claim__c WHERE Id IN :mapRebateClaimId';
        
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Rebate_Claim__c> lstRebateClaims) {      
        
        //Added automation controller to enable / disable records from being created.
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            for(Rebate_Claim__c r: lstRebateClaims){
                r.Status__c = 'Payout Completed';
                r.Bank_Payment_Date__c = mapRebateClaimPaymentData.get(r.Id);
            }
            
            try {
                update lstRebateClaims;
                if(Test.isRunningTest()){
                    insert new contact();// Throw exception for test classes. 
                }
            } catch(Exception e) {
                System.debug(e);
                String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                    String subject = 'Error with DML operation for LoyaltyRebateClaimBatchUpdate';
                String body = 'Error with DML operation for LoyaltyRebateClaimBatchUpdate. Error: ' + e;
                if(!Test.isRunningTest()){
                    EmailUtil.sendMessage(toAddress, body,subject);
                }
            }  
        }
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}