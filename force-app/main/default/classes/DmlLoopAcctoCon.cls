public class DmlLoopAcctoCon {

 public void insertbulkrecord( integer nooffrecord){
        list<Account> lstaccount = new list<Account>();
     list<contact> lstcon = new list<contact>();
        integer start = 0;
        integer i;
        for(i = start; i<=nooffrecord ; i++){
           Account objacc = getAccount(i);
            lstaccount.add(objacc);
        }
        insert lstaccount;
        
    
    
    for(Account acc : lstaccount){
      //  lstacc.Name = getname(i);
          contact con =contactrecord(acc);
        lstcon.add(con);
        
    } 
     insert lstcon;
 } 
    public Account getAccount(integer index){
        Account lstacc =new Account();
        lstacc.Name = getname(index);
        lstacc.AccountNumber = '348783';
        return lstacc;
        
    }  
    
    
    
    public contact contactrecord(Account lstacc){
        contact con = new contact() ;
        con.FirstName = lstacc.Name + 'Account fetch';
        con.LastName = 'chormalle';
        con.AccountId =lstacc.Id;
        return con;                
    }
    public string getname(integer i){
      list<string> lststr = new list<string>();
        lststr.add('official');
        lststr.add('fan page ');
        lststr.add('business');
        string name = lststr[i];
        return name;
        
    }

}