public class HelperCc {
     
  public C1 getAccountDetails(string accountNo){
        
        map<string,C1> mapCC=new map<string,C1>();
        
        C1 objCC;
        
        mapCC.put('1',new C1('1',90000));
        mapCC.put('2',new C1('2',80000));  
        mapCC.put('3',new C1('3',70000));
        mapCC.put('4',new C1('4',50000));
        
        
        if(mapCC.containsKey(accountNo))
        {
             objCC=mapCC.get(accountNo);
            
        }
           return objCC;
        
    }
    
    public class C1{
         public string accountNo;
         public decimal balance;
        
        C1(){}
        
        C1(string accountNo,decimal balance){
            
                this.accountNo=accountNo;
                this.balance=balance;
          
        }
    }
}