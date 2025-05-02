public class AccountTriggerHandler {
    public static void updatephone(list<Account> newlst, list<Account> oldlst  ,Map<id,Account> newmap , map<id,Account> oldmap){
        for(Account acc : newlst) {
          system.debug('the new map id and value is' + newmap.get(acc.id).Phone);  
        } 
        for(Account acc1 : oldlst){
            system.debug('the old id and value off phone is ' + oldmap.get(acc1.id).phone);
        }
    }
}