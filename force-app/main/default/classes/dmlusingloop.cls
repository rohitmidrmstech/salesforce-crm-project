public class dmlusingloop {
        public account accoutrecord(string name ,string accountno){
            Account acc= new Account();
            acc.name = name;
            acc.AccountNumber = accountno;
            acc.AnnualRevenue = 867687;
            insert acc;
            return acc;
        }  
        public void contactrecord(Account acc){
            
            if(acc.Name == 'rohit') {
                contact con = new contact();
                con.Phone = '76556';
                con.AccountId = acc.Id;
                con.Email = 'v@gmail.com';
                con.LastName = 'kadam';
                insert con;
                
                
            }      
            
        }
    }