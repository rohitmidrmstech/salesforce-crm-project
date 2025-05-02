public class ContactUpdates {
    public static void updateAcc(set<id> setAccid){
        List<Account> lstacc = new List<Account>();
        //List<string> conname = new List<string>();
        for(Account acc : [SELECT ID ,Name,Active_contacts__c,(SELECT ID ,Active__c FROM contacts) FROM Account WHERE ID IN : setAccid]){ 
            for(contact con : acc.contacts){
                if(con.Active__c == true){
                   acc.Active_contacts__c= acc.contacts.size();
                    lstacc.add(acc);
                system.debug('acy=tive conatct'+ acc.contacts.size());
                }
            }
        }
        if(!lstacc.isempty()){
            update lstacc;
        }
    }
}