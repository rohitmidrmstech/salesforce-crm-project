public class Contacthandlerdelete1 {
    public static void updateAccDes(List<contact> lstcon){
        List<Account> lstacc = new List<Account>();       
        set<id> setAccid = new set<id>();
        List<string> conname = new List<string>();
        for(contact con : lstcon ){
            setAccid.add(con.AccountId);
            system.debug('setAccidis >>>>' + setAccid);
            
            
        }
        //List<Account> lstacc = new List<Account>();
        List<Account> lstaccc = [SELECT ID ,Name, (SELECT ID ,AccountId, LastName ,email FROM contacts) FROM Account WHERE ID  IN : setAccid];
        for(Account acc :lstaccc){
            for(contact con : acc.contacts){
                conname.add(con.LastName);
                // lstacc.add(acc);
                system.debug('lstaccc is >>>>' + lstaccc);
                //acc.Description = string.join(conname, ',');
                //lstacc.add(acc);
                
            }
        
            acc.Description = string.join(conname, ',');
            lstacc.add(acc);
        }      
        if(!lstacc.isempty()){
            update lstacc;
            system.debug('updated  is >>>>' + lstaccc);
            
        }
    }
}