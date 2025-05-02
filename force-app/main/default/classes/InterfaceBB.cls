public class InterfaceBB Implements interfaceAA{
    helperCc OBJHelperBB = new helperCc();
    helperCc.C1 objInner;
    
    public void Deposite(string accountNo ,decimal Amount){
       objInner= OBJHelperBB.getAccountDetails(accountNo);
        objInner.balance=objInner.balance+Amount;
        system.debug('balance'+ objInner.balance );
        
    }
 }