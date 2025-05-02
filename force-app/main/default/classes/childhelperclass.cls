public class childhelperclass {
    public void showAccounts(){
        Childcontact lstcon = new ChildContact();
        list<contact> lstcontact = lstcon.getcontacts();        
        for(contact con : lstcontact){
            system.debug(con.id + ' ' + con.MailingCountry);
        }
    }
    public void  getaccounts(){
        Childcontact c1 = new Childcontact();  
        list<Account> acc =  c1.getaccounts();
        for(Account lstacc : acc){
            system.debug(lstacc.id+ ' ' + lstacc.BillingCountry);
            
        }
    }
}