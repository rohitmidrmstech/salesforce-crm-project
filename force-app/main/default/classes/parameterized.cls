public class parameterized {
        public string firstname;
        public string lastname;
        
        public string accountnumber;
        public string phone;
        
        
        public parameterized(string firstname ,string lastname,string accountnumber){
            this.firstname = firstname;
            this.lastname = lastname;
            this.accountnumber = accountnumber;
        }       
        public parameterized(string accountnumber , string phone){
            this.accountnumber = accountnumber;
            this.phone = phone;
            
        }        
        public void detail(){
            system.debug('first name is:'+ firstname);
            system.debug('lastname is:'+ lastname);
            system.debug('accountnumberis:'+ accountnumber);
            system.debug('phone no is:'+ phone);
            
        }        
    }