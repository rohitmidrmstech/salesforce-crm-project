public class OpportunityHandlerRolup {
    public static void updateAccAmount(set<id> setacc){
        List<Account> lstacc = new List<Account>();
        Map<id,Account> mapval = new map<id,Account>([SELECT ID ,Name,OppAmounttotal__c,(SELECT ID ,Amount FROM Opportunities)FROM Account WHERE ID IN : setacc]);
        for(Account acc : mapval.values()){
            decimal sum = 0;
            Account a = mapval.get(acc.id);
            for(opportunity opps : a.Opportunities){
                //if(opps.Amount != null && opps.Amount != ''){
                   sum = sum + (opps.Amount!=null ? opps.Amount:0);
            }
                acc.OppAmounttotal__c = sum;
                lstacc.add(acc);              
            }
         update lstacc;
        }
        
    }