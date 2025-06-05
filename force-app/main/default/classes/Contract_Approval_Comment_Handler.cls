public class Contract_Approval_Comment_Handler {
    @future
    public static void updateContractComment(set<id> cList){
        
        List<Contract> Contracts = [Select c.Id, c.Copy_Approval_Comments__c, c.Approval_Comments__c, (Select ActorId, Comments, CreatedDate From ProcessSteps order by CreatedDate) 
                                    From 
                                    Contract c
                                    where 
                                    c.Copy_Approval_Comments__c = True AND 
                                    c.id IN: cList];
            
        List<Contract> ContractsToUpdate = new List<Contract>(); //stores records to be updated
        
        //creates map of users that are active and non portal users 
        Map<ID, User> uMap = new Map<ID, User>([SELECT Id, Name FROM User WHERE IsActive =: true]);
        system.debug('User Map >>>>> ' + uMap);
        
        System.debug('******************************************** Contract = ' + Contracts);
        System.debug('******************************************** Size of Contract = ' + Contracts.size());
        
        if (Contracts.size() > 0){
            for(Contract con: Contracts){
                if(con.ProcessSteps.size() > 0 ){  
                    con.Approval_Comments__c = '';
                    for (ProcessInstanceHistory ps : con.ProcessSteps){
                        // Modified below if() NSCHUMACHER C-00203993 8.16.2017 This adds null check for ActorID and contains for uMap
                        if (ps.Comments != null && ps.ActorId != null && uMap.containsKey(ps.ActorId)){
                            string username = uMap.get(ps.ActorId).name;   
                            con.Approval_Comments__c += '\n' + username + ': ' + ps.Comments;          
                             System.debug('*********************************************** Comments copied:' + ps.comments);
                         }
                     }
                     con.Copy_Approval_Comments__c =false;
                     ContractsToUpdate.add(con);
                 }
             }
        }
        
        if( ContractsToUpdate.size()> 0 ){
        
            Database.SaveResult[] srList = Database.update(ContractsToUpdate, false);
        
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