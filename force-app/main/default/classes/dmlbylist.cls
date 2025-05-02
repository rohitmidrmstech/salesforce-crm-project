public class dmlbylist {
    public void insertrecord(){
        list<account> lstacc = new list<Account>();
        
        for(integer i=1; i<4 ;i++){
            account acc1 = new account(name = 'lakhan' ,description = 'kr',accountnumber = '433233');
            account acc2 = new account(name = 'gundre',description = 'shma',accountnumber = '3423233');
            account acc3 = new account(Name = 'reddy',AccountSource ='Phone Inquiry',Industry = 'Biotechnology');
            lstacc.add(acc1);
            lstacc.add(acc2);
            lstacc.add(acc3);
            system.debug('lstaccount 0 :'+lstacc[0]);
            system.debug('lstaccount 1:'+ lstacc[1]);
            
            
        }
        
        
        insert lstacc ;
        
        
        
    }
    
}