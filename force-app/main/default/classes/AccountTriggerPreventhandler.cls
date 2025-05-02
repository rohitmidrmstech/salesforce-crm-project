public class AccountTriggerPreventhandler {
    public static void preventaccrecord(list<Account> lstacc){
        for(Account acc : lstacc){
            if(acc.Rating == 'Hot'){
                acc.adderror('You can not delete Hot Account');
            }
        }
        
        
    }
}