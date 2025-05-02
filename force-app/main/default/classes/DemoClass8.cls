public class DemoClass8 {
    
    public void bulkinsert(integer noofacc){
        
        list<Account> aclst=new list<Account>();
        list<Contact> lstcon=new list<Contact>();
        list<Opportunity>lstop=new list<Opportunity>();
        
        integer i=0;
        for(i=0;i<=noofacc;i++){
            Account obj= getaccount(i);
            aclst.add(obj);   
        }
        insert aclst;
        
        for(Account acc:aclst){
            Contact con= getcont(acc);
            lstcon.add(con);
            
        }
        insert lstcon;
        
        for(account acc :[SELECT Id, Name, (SELECT Id, Name FROM Contacts) FROM Account]){
            for(contact con: acc.Contacts){
                Opportunity ops=getop(acc, con);
                lstop.add(ops);
            }
        }
        insert lstop;
    }
    
    public Account getaccount(integer index){
        Account obj=new Account();
        obj.Name=getname(index);
        obj.AccountNumber='12345';
        obj.AnnualRevenue=85000;
        return obj;
    }
    
    public Contact getcont(Account obj){
        Contact cn=new Contact();
        cn.FirstName =obj.Name;
        cn.LastName='-contact1';
        cn.AccountId=obj.Id;
        return cn;
    }
    
    public Opportunity getop( Account obj , Contact cn){
        Opportunity op=new Opportunity();
        op.Name=cn.Name + ' opps1';
        op.CloseDate=date.newInstance(2021, 12, 12);
        op.StageName='suclosed won';
        op.ContactId= cn.Id;
        op.AccountId=obj.Id;
        return op;
    }
    public string getname(integer index){
        list<string> lstname=new list<string>();
        lstname.add('suyog22');
        lstname.add('suyog12');
        lstname.add('Amol12');
        lstname.add('Mangesh12');
        lstname.add('Rohit12');
        lstname.add('Piyush12');
        
        string name= lstname[index];
        return name;
        
    }
    
}