public class insertAccount {
    public void insertaccountrecord(integer listoffrecord){
        list<Account> lstacc = new list<Account>() ;
        integer start = 0;
        integer i;
        for(i=start; i<listoffrecord; i++){
            Account objacc = getaccountrecord(i);
            lstacc.add(objacc);
        }           
        
        insert lstacc;   
        
    }        
    public Account getaccountrecord(integer index){
        Account acc1 = new Account();
        acc1.Name = getname(index);
        acc1.AccountNumber = '48373';        
        return acc1;
    }       
    public string getname(integer index){
        list<string> lstacc1 = new list<string>();
        lstacc1.add('rohit account');
        lstacc1.add('mangesh account');
        lstacc1.add('shsh account');
        lstacc1.add('ajvsvbv account');
        return lstacc1[index];
        
        
        
    }
    
    
}