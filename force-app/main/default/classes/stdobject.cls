public class stdobject {
    public Account accrecord(string n,string an,decimal ar){
        Account obja = new Account();
        obja.Name = n;
        obja.AccountNumber = an;
        obja.AnnualRevenue =ar;
        insert obja;
        return obja;
    }
    public contact conrecord(string ln,string e,string n ,Account obja){
        contact objc = new contact();
        objc.LastName = ln;
        objc.Email = e;
        objc.Phone = n;
        objc.AccountId = obja.Id;
        insert objc;
        return objc;
        
    }
    public void opprecord(string n,decimal am ,contact objc,Account obja,string st,date cd){
        Opportunity objp = new Opportunity();
        objp.Name = n;
        objp.Amount = am;
        objp.AccountId = obja.Id;
        objp.StageName = st;
        objp.CloseDate = cd;
        objp.ContactId = objc.Id;
        insert objp;
    }
}