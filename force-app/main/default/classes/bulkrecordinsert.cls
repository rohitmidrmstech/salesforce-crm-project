public class bulkrecordinsert {
    public void recordcreate(integer noofrecords){
        integer start = 0;
        integer i;
        list<Account> lstacc = new list<Account>();
        list<contact> lstcon = new list<contact>();
        
        for(i=0; i<3; i++) {
            Account obj  = getname(i);
            lstacc.add(obj);
        }  
        insert lstacc;
        for(Account acc : lstacc ){
            contact objcon =getcontact(acc);
            lstcon.add(objcon);
        }
        
    }
    
    
    
    public Account getname(integer s) {
        Account acc = new Account();
        
        acc.Name = getlst(s);
        acc.AccountNumber = '36636';
        return acc;
    } 
    public contact getcontact(Account acc){
        contact con = new contact();
        con.FirstName = acc.Name;
        con.LastName ='---contact';
        con.Email = 'rohir@gmail.com';
        con.AccountId =acc.Id;
        insert con;
        return con;
        
    }
    
    
    
    
    
    public string getlst(integer s){
        list<string> lstacc1 = new list<string>();    
        lstacc1.add('rahul');
        lstacc1.add('nilesh');
        lstacc1.add('rani');
        string name =lstacc1[s]; 
        return name;
        
    }          
    
    }