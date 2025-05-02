public class Accountprehandler {
    public static void preventAcc(List<Account> Oldlst){
        set<id> setAccid = new set<id>();
        map<id,Account> oldmap = new map<id,Account>();
        for(Account acc : Oldlst) {
            setAccid.add(acc.id);
        }  
        //Map<id,Account> newmap = new Map<id,Account>([SELECT ID ,Name ,(SELECT Id,LastName FROM contacts) FROM Account WHERE ID In :setAccid]);
        for(Account acc : [SELECT ID ,Name ,(SELECT Id ,LastName FROM contacts )FROM Account WHERE ID IN : setAccid]) {  
            oldmap.put(acc.id , acc);
        }
        for(Account acc : oldlst){
            if(oldmap.get(acc.id).contacts.size() >= 2){
                acc.adderror('related Account is two or greater then you can not delete');
            }
        }
        
        //if(newmap.get(acc.id).contacts.size()>1){
        //acc.adderror('you can not delete if 1 con is related');
    }
    public static void Deletion(List<Account> lstacc){
        set<id> setAccid = new set<id>();
        map<id,Account> oldmap = new map<id,Account>();
        for(Account acc : lstacc){
            setAccid.add(acc.id);
            system.debug('setAccid is >>>>' + setAccid);
        }
        List<Account> lstold = [SELECT ID ,(SELECT Id FROM Opportunities) FROM Account WHERE ID IN : setAccid];
        for(Account acc : lstold){
            oldmap.put(acc.id, acc);
            system.debug('oldmap id off Acc >>>>>>.'+ oldmap);
            if(oldmap.get(acc.id).opportunities.size()> 0){
                acc.adderror('you cannot delete account has related opp');
                system.debug('Account record >>>>>>.'+ lstold);
                
            }
            /*for(opportunity opp : acc.opportunities){
if(acc.opportunities.size()> 0){
acc.adderror('you cannot delete account has related opp');
}*/
        }
    }
}