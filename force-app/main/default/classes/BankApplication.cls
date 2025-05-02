public abstract class BankApplication {    //abstarct Class
    public String accountNo;
    public String accountType;   //Gobal Variable Declaration
    public String customerName;
    public String branchName;
    
    
    public abstract void checkAccountBalance(); //Abstract Method
    
    public void getData(String accountNo,String accountType,String customerName,String branchName){ //get value though Object
            this.accountNo=accountNo;
            this.accountType=accountType;  //Value are passed to Global Variable
            this.customerName=customerName;
            this.branchName=branchName;
        
     }
    Public void Display(){  // Print Value
        System.debug('account No-->'+accountNo+' || '+'Account Type :'+accountType +'|| '+'customerName-->'+'  '+customerName+' || '+'branchName-->'+branchName);
    }
    
}