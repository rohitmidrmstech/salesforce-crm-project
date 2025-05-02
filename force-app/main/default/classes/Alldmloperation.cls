public class Alldmloperation {
    public void insertrecord(){
        Account acc = new Account() ;
        acc.Name = 'rohit ';
        insert acc;
        ID accid = acc.Id;
        system.debug('dmnsdn= '+ accid);
    }
    
    public void bulkkinsert(){
        list<Account> lstacc = new list<Account>();
        Account con = new Account(Name = 'rohit');
        Account con1 = new Account(Name = 'karan');
        lstacc.add(con);
        lstacc.add(con1);
        insert lstacc;   
        list<Account> lstcon = new list<Account>(); 
        for(Account cons : lstacc){
            if(cons.Name != null){
                cons.phone = '8888328060';
                lstcon.add(cons);
            } 
        }
        update lstcon;
    }
    public void upsertrecord(){
        Account con = new Account(Name ='sarjerao') ;       
        insert con;
        con.AccountNumber = '4334343';
        Account con1 = new Account(Name = 'pritam sir');
        list<Account> lstacc = new list<Account>{con,con1};    
            upsert lstacc;
        
    }
    public void deleterecord(){
       list<Account> acc =[SELECT id FROM Account Where Name = 'rohit'] ;
        delete acc;
        system.debug(acc);
    }      
        
    }