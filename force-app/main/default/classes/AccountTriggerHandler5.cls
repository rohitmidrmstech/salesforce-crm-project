public class AccountTriggerHandler5{
    public static void CreateRelated(List<Account>Lstacc){
        system.debug('lstacc is ' + Lstacc);
        set<id> setAccountId = new set<id>();
        for(Account acc : Lstacc){
            // if(acc.AnnualRevenue > 50000){
            setAccountId.add(acc.id);
            system.debug('set off AccountId' + setAccountId);
            //}  
        }
        list<contact> Lstcon = new List<contact>();
        for(Account acc1 :[SELECT Id ,Name ,AnnualRevenue,(SELECT Id ,Name FROM contacts ) FROM Account WHERE ID IN :setAccountId]){
            //Lstcon.add(new contact(LastName = 'Rich Account' , AccountId = acc1.Id));
            //for(contact con : acc1.contacts){
            if(acc1.AnnualRevenue > 100){
                contact con = new contact();
                system.debug('llist off acc >>>>' + setAccountId);
                con.Lastname = 'Rich Account';
                con.AccountId = acc1.id;
                Lstcon.add(con);
                system.debug('list off con' + Lstcon);
                
            }
            if(!Lstcon.isempty()){
                insert Lstcon;
            }
        }
        
    }
    
    
}