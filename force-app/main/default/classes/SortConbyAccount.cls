public class SortConbyAccount {
    public void mappingoffAccToCon(){
        list<Account> lstacc = [SELECT Id , Name ,BillingCountry	 ,(SELECT Id, Name, MailingCountry FROM contacts) FROM Account];
        map<string ,list<Account>> mapoffacc = new map<string ,list<Account>>();
        
        
        
        
        
        
    }
    
    
    
}