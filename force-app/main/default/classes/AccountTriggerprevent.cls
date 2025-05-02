public class AccountTriggerprevent {
    public static void preventduplicate(List<Account> lstacc){
        List<string> accname = new List<string>();
        for(Account acc : lstacc){
            accname.add(acc.Name);
        }
    List<Account> acclst = [select id ,Name FROM Account where Name IN : accname];
        for(Account acc : lstacc){
            if(acclst.size() != null){
                acc.adderror('duplicate name for contact');
            }
        }
    }
}