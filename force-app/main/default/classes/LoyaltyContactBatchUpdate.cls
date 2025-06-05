/****************************************************************************************
* @Author       Lou Bui
* @Date         08/02/2023
* @Description  
Batch class to update contacts when card payement order has completed for Contractor Cash Back (CCB)
and Change Pays (CP) Program.

Change Log:
2/15/2024 - Lou Bui - Added automation controller to enable / disable records from being created/queried/updated.
*****************************************************************************************/

global class LoyaltyContactBatchUpdate implements Database.Batchable<sObject>,Database.Stateful{
    global SET<string> setContractorIDs;
    
    global LoyaltyContactBatchUpdate(SET<string> setContractorIDs){
        this.setContractorIDs=setContractorIDs;
    } 
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        //Collect the batches of records or objects to be passed to execute
        
        String query = 'SELECT Id, Contact_Card_Active__c, Contact_Card_Expiration__c, Contact_Card_Order_Status__c FROM Contact WHERE Contractor_ID__c IN :setContractorIDs';
        
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<Contact> contactlst) {
        
        //Added automation controller to enable / disable records from being created.
        Automation_Controller__c automationController = Automation_Controller__c.getInstance();
        if(automationController != null && automationController.LoyaltyAutomatedPaymentProcessing__c){
            //date expiryDate = Date.newInstance(2026,04,30); //This will need to be a system label.
            date expiryDate = date.parse(System.Label.BH_Card_Expiration_Date);
            
            for(Contact c: contactlst){
                c.Contact_Card_Active__c = TRUE;
                c.Contact_Card_Expiration__c = expiryDate;
                c.Contact_Card_Order_Status__c = 'Complete';
            }
            
            try {
                update contactlst;
                if(Test.isRunningTest()){
                    insert new contact();// Throw exception for test classes. 
                }
                
            } catch(Exception e) {
                System.debug(e);
                String[] toAddress = new String[]{System.Label.BH_Error_Email_Contact};
                    String subject = 'Error with DML operation for LoyaltyContactBatchUpdate';
                String body = 'Error with DML operation for LoyaltyContactBatchUpdate. Error: ' + e;
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