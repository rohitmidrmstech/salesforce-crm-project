public class AccountOwnerUpdate {
    public static void UpdateAcc(List<Account> lstacc){
       set<id> setOffId = new set<id>();
        for(Account acc : lstacc){
            setOffId.add(acc.OwnerId);
        }
       user usr = [SELECT Id ,Name FROM USER WHERE ID IN :setOffId ];
        for(Account acc : lstacc){
            acc.Sales_rep__c = usr.Name;
        }
        
    }
}