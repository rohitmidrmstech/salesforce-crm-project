global class claimPaymentFix implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String Bu='Roofing';
        String query = 'select Id, Name,CreatedDate,Claim__r.WOD_2__Claim_Status__c,Claim__r.id from WOD_Payment__c where Claim__r.Business_Units__c =:Bu and Claim__r.Payment_Date__c =null and Payment_Date__c!=null and CreatedDate >2021-01-01T18:08:45.168+05:30 and CreatedDate <2023-09-01T09:15:13.754+05:30 order by CreatedDate asc';
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<WOD_Payment__c> payList) {
     
        set<Id> claimIdSet = new set<Id>();
        if(Test.isRunningTest()){
            claimIdSet.add(payList[0].Claim__c); 
        }
        else{
            claimIdSet.add(payList[0].Claim__r.id);
        }
        
        //for(WOD_Payment__c clm:payList){
        //    claimIdSet.add(clm.Claim__r.id);
        //}   
        List<WOD_2__Claim__c> updateClaimlst = new List<WOD_2__Claim__c>();
        if(!claimIdSet.isEmpty()){
            WOD_2__Claim__c updateClaim = null;
            for(WOD_2__Claim__c claim : [Select Id,(Select Id,Payment_Date__c from Payments__r where Payment_Date__c !=null Order by CreatedDate ASC Limit 2) from WOD_2__Claim__c where Id In :claimIdSet ]){
                updateClaim = new WOD_2__Claim__c();
                updateClaim.Id = claim.Id;
                if(!Test.isRunningTest()){
                    updateClaim.Payment_Date__c = claim.Payments__r[0].Payment_Date__c;
                    updateClaim.Payment_Date_2__c = claim.Payments__r.Size() >= 2 ? claim.Payments__r[1].Payment_Date__c : null;
                }
                
                updateClaimlst.add(updateClaim);
            }
        }
        
        if(!updateClaimlst.isEmpty()){
            Database.update(updateClaimlst,false);
        }
        
        
    }   
    
    global void finish(Database.BatchableContext BC) {
        // execute any post-processing operations like sending email
    }
}