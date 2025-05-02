public class reviseclass {
    public integer no1;
    public integer no2;
    public  string name;
    public string lname;
    public reviseclass(){
        no1 = 10;
        no2 = 40;
        system.debug('non para');       
    }
    public reviseclass(integer no1 ,integer no2 ) {
        this.no1 = no1;
        this.no2= no2;
        integer result = no1+ no2;
        system.debug('para metereized++' + result );              
    }
    public reviseclass(string fname ,string lname){
        this.name = fname;
        this.lname = lname;
        //system.debug('para ===' + name +  lname);
    }
    public void showdeta (){
       system.debug('the name of setudentd sor =' +(name+ ' ' + lname)) ;
    }
    public void sum(){
        system.debug('non para ++' +(no1+no2));      
    }
    public void sum( integer no1 ,integer no2){
       system.debug('para sum ++'  + (no1+no2));                
    }
    public static reviseclass getdata(){
        reviseclass obj =new reviseclass();
        obj.name = 'rohit';
        obj.lname = 'chormalle';
        return obj;
    }
    //dml insert related record 
    public Account insertAccount(string name,String country){
      Account acc = new Account() ;
        acc.Name = name;
        acc.AccountNumber = '94845454';
        acc.BillingCountry = country;
        return acc;   
    }
    public contact getcontact(Account acc){
        contact con = new contact();
        con.FirstName = acc.Name + 'contact111';
        con.LastName = 'jadhav wada';
        con.Email = 'r@il.com';
        con.AccountId = acc.Id;
        return con;       
    }
    // insert bulk off of related record
    public void Accountrelate(integer noffrecord){
        list<Account> lstacc = new list<Account>();
        list<contact> lstcon = new list<contact>();
        for(integer i = 1 ; i<= noffrecord ;i++){
           Account acc = insertaccount('bulk off Account' ,'newzland');
            lstacc.add(acc);
        }
        if(!lstacc.isempty()){
            insert lstacc;
        }
        for(Account acc: lstacc){
            contact con = getcontact(acc);
            lstcon.add(con);
        }if(!lstcon.isempty()){
            insert lstcon;
        }
            
            
            
        }
    }