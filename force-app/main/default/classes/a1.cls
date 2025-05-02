public class a1 {
    public Account accrecord(string n,string an,decimal ar){
        Account obja = new Account();
        obja.Name = n;
        obja.AccountNumber = an;
        obja.AnnualRevenue =ar;
        insert obja;
        return obja;
    }
    public contact conrecord(string ln,string e,string n){
        contact objc = new contact();
        objc.LastName = ln;
        objc.Email = e;
        objc.Phone = n;
        insert objc;
        return objc;
        
    }
    public void opprecord(string n,decimal am ){
        Opportunity objp = new Opportunity();
        objp.Name = n;
        objp.Amount = am;
        insert objp;
}
}