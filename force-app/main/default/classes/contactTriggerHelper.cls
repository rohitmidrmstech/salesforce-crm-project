public class contactTriggerHelper {
    public static void rollupcount(list<contact> newcontact,list<contact> oldcontact){
     // list<Account> lstaccount =[select id ,name, (select id  from contacts)from account] ;
        //list<Account> lstaccc = new list<Account> ();
     /* set<id> setAccId = new set<id>();
        
        if(newcontact !=null){
            for(Contact con :newcontact){
                if(con.AccountId!=null){
                    setAccId.add(con.accountid);
                }
            }      
        }if(oldcontact!=null){
            for(Contact con:oldcontact){
                setAccId.add(con.accountid);
            }
        }
        List<Account> lstAccount = [ SELECT Id, Name, (SELECT Id FROM Contacts) FROM Account ];
        if(lstAccount!=null){
            for(Account acc : lstAccount) {
                acc.total_countoffcontacts__c = acc.Contacts.size();
            }
        }
        if (!lstAccount.isEmpty()){
            update lstAccount;
        }
    }*/
    }
}