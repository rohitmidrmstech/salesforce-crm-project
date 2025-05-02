public class stdobject1 {
    public void accrecord(){
        list<Account> lstaccount = new list<Account>();
        Account acc = new Account(Name = 'ajit');
        Account acc1 = new Account(Name = 'additya');
        lstaccount.add(acc);
        lstaccount.add(acc1);
        insert lstaccount;
        contact con = new contact(Lastname = 'thackrey',AccountId=acc.id);
        insert con;
        opportunity opp = new opportunity(CloseDate = date.today(),stageName ='prospecting',Name ='new opp',contactId=con.id,AccountId=acc.id);
        insert opp;
    }
}