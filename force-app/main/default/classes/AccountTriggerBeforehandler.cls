public class AccountTriggerBeforehandler {
    public static void preventAccdelete(List<account> oldlst , Map<id,Account> oldmap){
        set<id> setAccid = new set<id>() ;
        for(Account acc : oldlst){
            setAccid.add(acc.id);
        }
        List<opportunity> lstopp = [SELECT ID ,Name,StageName, AccountId FROM opportunity where ID IN : setAccid];
        for(opportunity opp : lstopp){
            if(opp.StageName == 'Closed won'){
                opp.adderror('you can not delete Account WHere  close won opportunity');
            }
            
        }
    }
}