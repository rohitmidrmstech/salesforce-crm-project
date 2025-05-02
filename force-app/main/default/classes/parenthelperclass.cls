public class parenthelperclass {
    public void showaccount(){
     ParentAccount objpar = new PArentAccount() ;
    list<Account> lstacc =    objpar.getaccounts();
        for(Account acc : lstacc) {
          system.debug(acc.id + ' ' + acc.BillingCountry);  
            
        }       
        
        
        
    }
}