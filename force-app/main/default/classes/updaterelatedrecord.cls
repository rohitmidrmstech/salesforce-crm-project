public class updaterelatedrecord {
    public void getrecord(){
        list<contact> lstcon = new list<contact>();
        list<Account> lstacc = new list<Account>();
        for(contact acc : [select id ,Name,Account.id ,Account.Name from contact]) {
           acc.phone = '9156420720';
            
           lstcon.add(acc); 
            
        }  
      update lstcon;
        
        
    }
}