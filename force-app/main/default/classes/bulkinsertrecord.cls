public class bulkinsertrecord {
    public Account Accountrecord(){
        Account acc = new Account();
        acc.AccountNumber = '376376';
        acc.AnnualRevenue = 8383.22;
        acc.Name = 'sameer';
        acc.Phone ='37373';
        insert acc;
        return acc;                        
    }   
    public contact contactrecord(Account acc) {
        contact con = new contact();
        con.FirstName = 'omkar';
        con.LastName = 'bainwad';
        con.AccountId =acc.Id;
        insert con;
        return con;                      
    }   
    public void opportunityrecord( Account acc,contact con) {
        opportunity opp = new opportunity();
        opp.Name = 'rushi gitte';
        opp.CloseDate = date.today();
        opp.ContactId = con.Id;
        opp.AccountId = acc.Id;
        opp.StageName = 'Closed Won';
        insert opp;
        
        
        
    }   
    
    
    
}