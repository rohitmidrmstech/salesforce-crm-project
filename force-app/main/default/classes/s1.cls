public class s1 {
    public void contacttoaccount() {
        list<contact> lstcon = new list<contact> () ;
        for(contact con : [select id , name, Account.Name,Account.id FROM contact]){
            system.debug('lstAccount=' + con.Account);
            system.debug('name is =' + Account.Name);
            
            
        }
        update lstcon; 
        system.debug('name is =' + Account.Name);
        
        
        
        
    }    
    
    
}