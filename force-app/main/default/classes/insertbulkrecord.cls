public class insertbulkrecord {
    public void insertbulkrecord1(integer nooffrecord){
        list<Account> lstaccount = new list<Account>();
        integer start = 0;
        for(integer i = start; i<=nooffrecord ; i++){
            Account objacc = new Account();
            objacc.Name = getname(i);
            objacc.AccountNumber = '343434';
            objacc.AnnualRevenue =4344.45;
            lstaccount.add(objacc);
            
        }
        insert lstaccount;
    }
    public string getname(integer i){
        list<string> lststr = new list<string>() ;
        lststr.add('ratan taat111');
        lststr.add('tata birla Account63453');
        lststr.add('PM caree Fund46354');
        string name = lststr[i];
        return name;      
    } 
}