/****************************************************************************************
* @Author       Lou Bui
* @Date         08/02/2023
* @Description  
Batch class to create payment records to fund Contractor Cash Back (CCB)
and Change Pays (CP) Program.

Change Log:
2/15/2024 - Lou Bui - Added automation controller to enable / disable records from being created/queried/updated.
06/05/2025 - Hithesh Ravuri - Modified the batch class to handle the for the BP Canada Contractor Cashback program.
*****************************************************************************************/

global class LoyaltyCardPaymentLoadBatch implements Database.Batchable<sObject>,Schedulable {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT '
        + 'Id, '
        + 'Business_Unit__c,'
        + 'Card_Value__c,'
        + 'Sent_To_Payment_Details__c,'
        + 'Rebate_Claims__r.Id,'
        + 'Rebate_Claims__r.RecordTypeId,'
        + 'Rebate_Claims__r.RecordType.DeveloperName,'
        + 'Rebate_Claims__r.Claim_Currency__c,'
        + 'Rebate_Claims__r.Name,'
        + 'Rebate_Claims__r.Status__c,'
        + 'Rebate_Claims__r.Submitted_By__c,'
        + 'Rebate_Claims__r.Submitted_By__r.Contact_Card_Active__c, '
        + 'Rebate_Claims__r.Submitted_By__r.Contact_Card_Expiration__c '
        + 'FROM ProgramRebateTypePayout '
        + 'WHERE Card_Value__c > 0 AND Rebate_Claims__r.RecordType.Name= \'CCB\' AND ' 
        + 'Rebate_Claims__r.Status__c = \'Pending Card Funding\' AND Sent_To_Payment_Details__c = FALSE AND '
        + 'Rebate_Claims__r.Submitted_By__r.Contact_Card_Active__c = TRUE';
        
            
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<ProgramRebateTypePayout> lstProgramRebateTypePayout) {
          
        //Added automation controller to enable / disable records from being created.
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
        List<Loyalty_Card_Payment_Detail__c> lstPaymentDetails = new List<Loyalty_Card_Payment_Detail__c>();
        
            string todayDate = string.valueOfGmt(datetime.now());
            string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
            string batchNumber = todayDate + uniqueNumber;
            // process each batch of records default size is 200
                for(ProgramRebateTypePayout item : lstProgramRebateTypePayout){
                    Loyalty_Card_Payment_Detail__c payment = new Loyalty_Card_Payment_Detail__c();
                    payment.Program_Rebate_Type_Payout__c = item.id;
                    payment.Rebate_Claim__c = item.Rebate_Claims__c;
                    payment.Rebate_Amount__c = item.Card_Value__c;
                    payment.Business_Unit__c = item.Business_Unit__c;
                    payment.Claim_Currency__c = item.Rebate_Claims__r.Claim_Currency__c;
                    payment.Rebate_Program__c = item.Rebate_Claims__r.RecordType.DeveloperName;
                    payment.Contact_Card_Active__c = item.rebate_Claims__r.Submitted_By__r.Contact_Card_Active__c;
                    payment.Contact_Card_Expiration__c = item.rebate_Claims__r.Submitted_By__r.Contact_Card_Expiration__c;
                    payment.SF_Batch_Number__c  = batchNumber;
                    payment.Contact__c = item.Rebate_Claims__r.Submitted_By__c;
                    payment.Create_Date__c = date.today();
                    payment.Payment_Reference_Id__c = 'R' + datetime.now().format('yyyyMMddhmmssa');
                    
                    lstPaymentDetails.add(payment);
                }
            
        	
            for(ProgramRebateTypePayout p : lstProgramRebateTypePayout){
                p.Sent_To_Payment_Details__c = TRUE;
				p.Sent_To_Payment_Details_Date__c = System.today();
            }
        
        try {
             //Insert records to Loyalty_Card_Payment_Detail__c
             insert lstPaymentDetails;
             //Update ProgramRebateTypePayout
             update lstProgramRebateTypePayout;
         
        } catch(Exception e) {
            System.debug(e);
            String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
            String subject = 'Error with DML operation for LoyaltyCardPaymentLoadBatch.';
            String body = 'Error with DML operation for LoyaltyCardPaymentLoadBatch. Error: ' + e;
            EmailUtil.sendMessage(toAddress, body,subject);
        }
         
    }   
    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
    global void execute(SchedulableContext sc){
    
        LoyaltyCardPaymentLoadBatch b = new LoyaltyCardPaymentLoadBatch();
    	Database.executeBatch(b);
        
    }
    
}