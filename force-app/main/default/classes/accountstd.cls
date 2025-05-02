public class accountstd {
    public Account createaccount(string name){
        Account obj = new Account();
            obj.Name =name;
        
        insert obj;
        return obj;
        
    }  
    public void createcontact(Account msg,string firstname,string lastname){
        contact c1 = new contact();
        c1.FirstName= firstname;
        c1.LastName=lastname;
        c1.AccountId = msg.id;
        
        insert c1;
    }       
        
}