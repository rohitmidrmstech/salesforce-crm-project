public class DispatcherOpportunity {
    public static void sortAccId(list<opportunity> lstopp){
        set<id> accid = new set<id>() ;
        list<Account> lstAccounts = new list<Account>();
        for(opportunity opp : lstopp){ 
            accid.add(opp.AccountId) ;
            
            if(!accid.isempty()){
                accid.add(opp.AccountId) ;
                system.debug('id off record ==' + opp.AccountId);
            }
            
        } 
        boolean isAllclosed;
        for(Account acclst : [SELECT Id ,Name,Rating ,(SELECT Id ,Name,StageName FROM Opportunities)FROM Account where id IN :accid]){
            isallclosed = true;         
            for(opportunity opp : acclst.Opportunities){
                // isallclosed = true;
                if(opp.StageName != 'Closed Won') { // Closed Won , Prospecting
                    isAllClosed = false; 
                }
            }
            if(isallclosed && acclst.Rating != 'Hot'  ){
                acclst.Rating = 'Hot'; 
                lstAccounts.add(acclst);
                
            } else if(isallclosed == false && acclst.Rating != 'cold'){
                acclst.Rating = 'cold';
                lstAccounts.add(acclst);
                
            }
            if(!lstAccounts.isEmpty()){
                update acclst;
            }         
            
        }
    }      
}