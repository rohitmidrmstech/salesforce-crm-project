public class helperclass2 {
    public void showAccounts(){
      Childcontact objchild = new Childcontact();
        list<Account> lstacc = objchild.showAccounts();
        for(Account acc : lstacc){
            integer size ;
            system.debug(acc.Name + ' ' + acc.BillingCountry );
        }
        
    }
    
    
}