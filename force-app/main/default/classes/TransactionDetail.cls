public class TransactionDetail implements Bankingmethod {
     TransactionHelper.details objaccdetail;
    public transactiondetail(){}
    public TransactionDetail(string AccNo) {
       objaccdetail = TransactionHelper.ShowAccountdetails(AccNo);
    }
    
    public void showAccountdetail(){
        try{
        if(objaccdetail != null){
            system.debug('Account details are  ===='  + objaccdetail.Name + ' ' +objaccdetail.AccType +' '+ objaccdetail.Balance) ;
        }
        else {
            system.debug('your Account not found please contact to Branch Manager ');  
        }
        }catch(Exception ex){
            DebugLog__c debugobj  = CatchErrorClass.exceptionerror(ex.getLineNumber(),ex.getMessage(),ex.getTypeName(),'TransactionDetail-','Exception');
            insert debugobj;
        }
    }
    public void checkBalance(){
        if(objaccdetail != null){
        system.debug('Account Balance  ==' + objaccdetail.Name + ' ' + objaccdetail.AccType +' ' + objaccdetail.Balance);
        }
        else {
            system.debug('Account Number not exist');
        }
    }  
    public void withdraw( decimal amount){
        if(objaccdetail != null){
        If(objaccdetail.Balance >= amount){
           objaccdetail.Balance = objaccdetail.Balance -amount; 
        system.debug('withdrwal amount is ===' + objaccdetail.Balance + ' ' + objaccdetail.AccType);
        }
            else{
              system.debug('insufficient balance ') ; 
            }
        }
            else{
               system.debug('Account not found') ;
            }
    } 
 
    public void Deposit(decimal amount){
        if(objaccdetail != null){
          objaccdetail.Balance =( objaccdetail.Balance + amount ) ;
          system.debug('deposit amount is ==>>>' + objaccdetail.Balance);  
        }
        else {
            system.debug( 'your account is not found plz contact to bank');            
        }
    
}   


}