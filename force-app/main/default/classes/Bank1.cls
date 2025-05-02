public class Bank1 extends BankApplication {  //Concrete Class
    public decimal Amount;
    public decimal Balance=1000;      //Declare global variable
    
    public void getDeposite(decimal Amount){       //get amount value through object
        this.Amount=Amount;           //pass value to global variable
        Balance=Balance+Amount;
        Display();
        system.debug('You have Deposite-->' +Amount);
        checkAccountBalance();
    }
    
    public void getWithreawal(decimal Amount){
        try{
        this.Amount=Amount;
            if( Balance>1000){
                Display();
                Balance=Balance-Amount;
                system.debug('You have Withdrawal Rs-->' +Amount);
                checkAccountBalance();
                
                
            }else{
                Display();
                
                system.debug('Minimum  Balance is Require 1000 Rs ,You Can not Withdraw Amount Rs'+Amount);
                checkAccountBalance();
            }
        } catch(nullpointerexception ex){
            DebugLog__c debugobj  = CatchErrorClass.exceptionerror(ex.getLineNumber(),ex.getMessage(),ex.getTypeName(),'Bank1','nullpointerexception type');
            insert debugobj;
            
        }
        
        
    }
    public override void checkAccountBalance(){
        
        System.debug('Your Account No:  '+accountNo+' || '+'Current Balance:: '+Balance);
        
    }
}