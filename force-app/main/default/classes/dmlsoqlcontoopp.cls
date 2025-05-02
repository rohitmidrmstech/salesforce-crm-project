public class dmlsoqlcontoopp {
    public void contacttoopportunity(){
        list<opportunity> lstopp = new list<opportunity>() ;
        
        for(Account acc :[select id, Name ,(select id ,Name FROM contacts)FROM Account]){
            
            for(contact con : acc.contacts){
                opportunity opps = new opportunity();
                opps.Name = con.Name +'---oppp';
                opps.CloseDate =date.today();
                opps.StageName = 'Prospecting';
                opps.AccountId = acc.Id;
                lstopp.add(opps);
                
                
            } 
             update lstopp;
        }        
        
    }
}