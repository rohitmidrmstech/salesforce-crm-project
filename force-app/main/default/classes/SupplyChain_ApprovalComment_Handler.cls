public class SupplyChain_ApprovalComment_Handler {
    @future
    public static void updateSupplyChainComment(set<id> scList){

        List<Supply_Chain__c> SCs = [Select sc.Id, sc.Copy_Approval_Comments__c, sc.Approval_Comments__c, (Select ActorId, Comments, CreatedDate From ProcessSteps order by CreatedDate) 
                             From 
                                 Supply_Chain__c sc
                             where 
                                 sc.Copy_Approval_Comments__c = True AND 
                                 sc.id IN: scList];
            
        List<Supply_Chain__c> SCsToUpdate = new List<Supply_Chain__c>(); //stores records to be updated
        
        //creates map of users that are active and non portal users 
        Map<ID, User> uMap = new Map<ID, User>([SELECT Id, Name FROM User WHERE IsActive =: true]);

        if (SCs.size()>0){
            for(Supply_Chain__c sc: SCs){
                if(SC.ProcessSteps.size() >0){  
                    SC.Approval_Comments__c = '';
                    for (ProcessInstanceHistory ps : sc.ProcessSteps){
                        if (ps.Comments != null){
                            string username = uMap.get(ps.ActorId).name;   
                            sc.Approval_Comments__c += '\n' + username + ': ' + ps.Comments;          
                             System.debug('*********************************************** Comments copied:' + ps.comments);
                         }
                     }
                     sc.Copy_Approval_Comments__c =false;
                     SCsToUpdate.add(sc);
                 }
             }
        }
        
        if( SCsToUpdate.size()> 0 ){
        
            Database.SaveResult[] srList = Database.update(SCsToUpdate, false);
        
            // Iterate through each returned result
            for (Database.SaveResult sr : srList) {
                if (sr.isSuccess()) {
                    // Operation was successful, so get the ID of the record that was processed
                    System.debug('Successfully updated record ID: ' + sr.getId());
                } else {
                    // Operation failed, so get all errors                
                    for(Database.Error err : sr.getErrors()) {
                        System.debug('The following error has occurred.');                    
                        System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    }
                }
            }
        }
    }    
}