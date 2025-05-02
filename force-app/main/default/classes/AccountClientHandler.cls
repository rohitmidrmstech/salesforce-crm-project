public class AccountClientHandler {
    public static void UpdateClientlookup(List<Account> lstacc){
        List<contact> lstcon = new List<contact>();
        List<Account> lstac = new List<Account>();
        for(Account acc : lstacc){
            lstcon.add( new contact (LastName = 'contact' , AccountID = acc.Id));
        }if(!lstcon.isempty()){
            insert lstcon;
        }
        set<id> setaccid = new set<id>();
        for(Account acc : lstacc){
            setaccid.add(acc.id);
        }
        
        //List<account> lstac = new list<account>();
        List<Account> lstaccount = [SELECT ID ,Name,Contact_Client__c ,(SELECT ID ,LastName FROM contacts)FROM Account WHERE ID IN :setAccid];
        for(Account acc : lstaccount){
            acc.Contact_Client__c = acc.id;
            lstac.add(acc);
        }if(!lstac.isempty()){
            update lstac;
        }
        
    }
    
}