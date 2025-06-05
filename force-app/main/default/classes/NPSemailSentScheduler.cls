global class NPSemailSentScheduler implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        
        List<Contact> conListToUpdate = new List<Contact>();
        List<Contact> conList = new List<Contact>();
        Integer CurrentQuater;
        Integer SurveySentQuater; 
        conList = [SELECT Name, Email, Survey_Sent_Date__c, Survey_Email_Sent__c FROM Contact where Survey_Email_Sent__c = True AND RecordType.DeveloperName = 'Gypsum_USA_Contact' AND Email != NULL AND
                   Status__c = 'Active' AND (NOT(Account_Owner_Role_Name__c like '%CRM Administrator%' OR Account_Owner_Role_Name__c like '%Marketing%')) AND Email_Opt_Out__c = FALSE AND
                   (Account_Billing_Country__c != 'Ca' OR Account_Billing_Country__c != 'Can' OR Account_Billing_Country__c != 'Canada') AND Contact_Type__c = 'Dealer' AND
                   (Account_Record_Type__c = 'Payer' OR Account_Record_Type__c = 'Ship-To' OR Account_Record_Type__c = 'Sold-To') AND (Distance_To_Plant__c < 500.00 OR
                   Account_Shipping_Condition_Desc__c LIKE '%RAIL%' OR Account_Billing_State__c = 'TX')];
        system.debug('============conList============'+conList);
        if(conList.size() > 0){
            CurrentQuater = math.round((date.today().month() + 2) / 3); 
            
            for(Contact con : conList){
                SurveySentQuater = math.round((con.Survey_Sent_Date__c.month() + 2) / 3);
                //Integer diff = con.Survey_Sent_Date__c.daysBetween(Date.today());
                //if( diff == 90){
                if(CurrentQuater != SurveySentQuater && con.Survey_Email_Sent__c == true){
                    con.Survey_Email_Sent__c = false;
                    conListToUpdate.add(con);
                }
            }
            if(conListToUpdate.size() > 0 && !Test.isRunningTest()){
                Database.Update(conListToUpdate, false);   
            }  
            
        }
    }
}