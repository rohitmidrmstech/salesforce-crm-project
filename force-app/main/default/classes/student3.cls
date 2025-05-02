public class student3 {
    public void mainrefrenceme(){
        account a= new account();
        a.name='test account';
        a.website='www.main.method';
        
        system.debug('before the refrence:'+a);
        passbyvalue(a);
        system.debug('after the refrence: '+a);
        
    }    
    private void passbyvalue(account a) {
         a.name= 'rohit';
      a.website ='www.pass.method' ; 
    }
    }