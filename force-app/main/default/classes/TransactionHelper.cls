public class TransactionHelper {
    public static details ShowAccountdetails(string AccNo){
        map<string , details> mapdetails = new  map<string,details>();
        details objaccdetail; 
        
        mapdetails.put('MGB100',new details('Rohit' , 'Saving', 5000));
        mapdetails.put('MGB101',new details('Rahul' , 'Saving', 6000));
        mapdetails.put('MGB102',new details('Rekha' , 'Saving', 7000));
        mapdetails.put('MGB103',new details('Raju' , 'Saving', 8000));
        if(mapdetails.containskey(AccNo)){
            objaccdetail = mapdetails.get(AccNo); 
        }
        return objaccdetail;
    }
    public class details {
        public string Name;
        public string  AccType;
        public decimal Balance ;
        public details(){}
        public details(string Name , string AccType, decimal Balance){
            this.Name = Name;
            this.AccType = AccType;
            this.Balance = Balance ;
            
            
        } 
        
    }
}