public class OpportunityTriggerHandlerstage {
    public static void updateacc(List<opportunity> lstopp){
        set<id> setoppid = new set<id>() ;
        for(opportunity opp : lstopp){
            setoppid.add(opp.AccountId);
        }
        
        List<Account> lstacc = new List<Account>();
        integer count;
        for(Account acc : [SELECT ID ,Name ,Stage__c ,(select id ,Name ,Stage__c FROM opportunities)  FROM Account WHERE ID IN : setoppid]){
            count = 0;
            for(opportunity opp : acc.opportunities){
                if(opp.stage__c == 'new'){
                    count++;
                }
                if(count == acc.opportunities.size()){
                    acc.Stage__c = 'new';
                    lstacc.add(acc);
                }             
                else {
                    acc.Stage__c = 'old';
                    lstacc.add(acc);
                }
            }
        }if(!lstacc.isempty()){
            update lstacc;
        }
        
        
    }
}