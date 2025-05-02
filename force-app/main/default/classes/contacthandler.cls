public class contacthandler {
    public static void updateAccphone(set<id> setAccid,Map<id,contact> oldmap , map<id ,contact> newmap){
        List<Account> lstacc = new List<Account>();
        for(Account acc : [SELECT ID , Name ,Phone,otherphone__c ,(SELECT ID ,Name ,Phone FROM contacts ) FROM Account WHERE ID IN : setAccid]){
            for(contact con : acc.contacts){
                acc.Phone = oldmap.get(con.id).Phone;
                acc.otherphone__c = newmap.get(con.id).Phone;
                lstacc.add(acc);
            }
        }
        if(!lstacc.isempty()){
            update lstacc;
        }
    }
    public static void insertnewcon(set<id> setAccid){
        // list<string> setnames = new list<string>();
        List<Account> lstacc = new List<Account>();
        for(Account acc : [SELECT ID ,related_ContactNAme__c,(SELECT ID , LastName FROM contacts ) FROM Account WHERE ID IN :setAccid]){
            list<string> lstaccname = new list<string>();           
            if(acc.contacts.size()>0){
                for(contact con : acc.contacts) {
                    lstaccname.add(con.LastName);
                }
                acc.related_ContactNAme__c = string.join(lstaccname, ',');
                //lsacc.add(acc);                          
            } 
            else {
                acc.related_ContactNAme__c = ',';
            }
            lstacc.add(acc);
        }if(!lstacc.isempty()){
            update lstacc;
        }
        
    }
    
    
}