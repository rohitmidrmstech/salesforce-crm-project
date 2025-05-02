public virtual class ParentAccount {
    public virtual list<Account> getaccounts(){
     list<Account> lstacc = [select id, name , BillingCountry FROM Account] ;  
        return lstacc;
        
    }
}