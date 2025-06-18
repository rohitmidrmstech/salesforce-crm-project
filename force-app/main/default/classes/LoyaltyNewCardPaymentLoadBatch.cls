/****************************************************************************************
* @Author       Lou Bui
* @Date         08/02/2023
* @Description  
Batch class to create records for ordering plastic cards for Contractor Cash Back (CCB)
and Change Pays (CP) Program.

Change Log:
2/15/2024 - Lou Bui - Added automation controller to enable / disable records from being created/queried/updated.
05/07/2025 - Hithesh Ravuri - Modified the batch class to use Database.Stateful because it was creating duplicate 
							  records when the same contact appeared in multiple batches. By enabling stateful mode, 
							  we can retain state across batches and ensure only one unique record is created per contact.
06/05/2025 - Hithesh Ravuri - Modified the batch class to handle the for the BP Canada Contractor Cashback program.
*****************************************************************************************/

global class LoyaltyNewCardPaymentLoadBatch implements Database.Batchable<sObject>,Schedulable,Database.Stateful {
    set<Id> contactIds = new set<Id>();
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
            + 'Rebate_Claims__r.Submitted_By__r.Contractor_ID__c,'
            + 'Rebate_Claims__r.Submitted_By__r.Contact_Card_Active__c, '
            + 'Rebate_Claims__r.Submitted_By__r.Contact_Card_Expiration__c '
            + 'FROM ProgramRebateTypePayout '
            + 'WHERE Rebate_Claims__r.RecordType.Name = \'CCB\' AND ' 
            + 'Rebate_Claims__r.Status__c = \'Pending Card Funding\' AND '
            + 'Rebate_Claims__r.Submitted_By__r.Contractor_ID__c != \'NULL\' AND '
            + '((Sent_To_Payment_Details__c = FALSE AND Sent_Request_For_New_Card__c = FALSE '
            + 'AND Rebate_Claims__r.Submitted_By__r.Contact_Card_Active__c = FALSE AND Rebate_Claims__r.Submitted_By__r.Contact_Card_Order_Status__c = NULL)'
            + 'OR Rebate_Claims__r.Submitted_By__r.Contact_Card_Expiration__c < TODAY)';
        
        system.debug('Database.getQueryLocator(query) =>' + Database.Query(query));
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<ProgramRebateTypePayout> lstProgramRebateTypePayout) {
        
        //Added automation controller to enable / disable records from being created.
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            
            List<Loyalty_Card_Payment_Detail__c> lstPaymentDetails = new List<Loyalty_Card_Payment_Detail__c>();
            List<Id> lstContactsIds = new List<Id>();
            List<Contact> lstContactsToUpdate = new List<Contact>();
            system.debug('Size of contactIds ==='+contactIds.size());
            system.debug('Contact Ids==='+contactIds);
            
            string todayDate = string.valueOfGmt(datetime.now());
            string uniqueNumber =  String.valueOf(Integer.valueof((Math.random() * 1000)));
            string batchNumber = todayDate + uniqueNumber;
            
            Map<String,ProgramRebateTypePayout> mapStrByLoyaltyCard=new Map<String,ProgramRebateTypePayout>();
            for(ProgramRebateTypePayout prtp:lstProgramRebateTypePayout){
                mapStrByLoyaltyCard.put(prtp.Rebate_Claims__r.Submitted_By__r.Contractor_ID__c,prtp);//This is map and hence it will always have unique values 
            }
            //system.debug('mapStrByLoyaltyCard count => '+ mapStrByLoyaltyCard.size());
            //system.debug('mapStrByLoyaltyCard List return'+mapStrByLoyaltyCard.values());        
            
            
            
            // process each batch of records default size is 200
            for(ProgramRebateTypePayout item : mapStrByLoyaltyCard.values()){
                if(!contactIds.contains(item.Rebate_Claims__r.Submitted_By__c)){
                    Loyalty_Card_Payment_Detail__c payment = new Loyalty_Card_Payment_Detail__c();
                    payment.Program_Rebate_Type_Payout__c = item.id;
                    payment.Rebate_Claim__c = item.Rebate_Claims__c;
                    payment.Rebate_Amount__c = 0;
                    payment.Business_Unit__c = item.Business_Unit__c;
                    payment.Claim_Currency__c = item.Rebate_Claims__r.Claim_Currency__c;
                    payment.Rebate_Program__c = item.Rebate_Claims__r.RecordType.DeveloperName;
                    payment.Contact_Card_Active__c = item.rebate_Claims__r.Submitted_By__r.Contact_Card_Active__c;
                    payment.Contact_Card_Expiration__c = item.rebate_Claims__r.Submitted_By__r.Contact_Card_Expiration__c;
                    payment.SF_Batch_Number__c  = batchNumber;
                    payment.Contact__c = item.Rebate_Claims__r.Submitted_By__c;
                    payment.Create_Date__c = date.today();
                    payment.Payment_Reference_Id__c = 'C' + datetime.now().format('yyyyMMddhmmssa');
                    
                    lstContactsIds.add(item.Rebate_Claims__r.Submitted_By__c);
                    contactIds.add(item.Rebate_Claims__r.Submitted_By__c);
                    lstPaymentDetails.add(payment);
                }
            }
            
            //Get list of contacts to update contact card order status to pending.
            for(Contact c : [Select id,Contact_Card_Order_Status__c From Contact Where id IN :lstContactsIds]){
                c.Contact_Card_Order_Status__c = 'Pending';
                lstContactsToUpdate.add(c);
            }
            //**Update Program ReabteTypePayout**
            for(ProgramRebateTypePayout p : lstProgramRebateTypePayout){
                p.Sent_Request_For_New_Card__c = TRUE;
                p.Sent_Request_For_New_Card_Date__c = System.today();
            }
            system.debug('Size of contactIds ==='+contactIds.size());
            
            try {
                //Insert records to Loyalty_Card_Payment_Detail__c
                insert lstPaymentDetails;
                //Update ProgramRebateTypePayout
                update lstProgramRebateTypePayout;
                //Update Contact c.Contact_Card_Order_Status__c = 'Pending';
                update lstContactsToUpdate;
                
            } catch(Exception e) {
                
                System.debug(e);
                String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                    String subject = 'Error with DML operation for LoyaltyNewCardPaymentLoadBatch.';
                String body = 'Error with DML operation for LoyaltyNewCardPaymentLoadBatch. Error: ' + e;
                //EmailUtil.sendMessage(toAddress, body,subject);
            }
            
        }   
        
    }
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
    
    global void execute(SchedulableContext sc){
        
        LoyaltyNewCardPaymentLoadBatch b = new LoyaltyNewCardPaymentLoadBatch();
        Database.executeBatch(b);
        
    }
    
}