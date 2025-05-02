public class ContactTriggerCounthandler {
    public static void updateAcountCon(set<id> SetContactID){
        list<Account> lstacc = new list<Account>();
        list<string> conname = new list<string>();
        for(Account acc : [SELECT ID ,total_contact__c,(SELECT ID,LastName FROM contacts ) FROM Account WHERE ID IN : SetContactID]){
            if(acc.contacts.size() > 0){
                for(contact con : acc.contacts) {
                   // acc.total_contact__c = acc.contacts.size();
                    conname.add(con.LastName);
                    //lstacc.add(acc);             
                    
                }
                acc.related_ContactNAme__c = string.join(conname, ',');
            }
            else {
                acc.related_ContactNAme__c = ',' ;
            }
            lstacc.add(acc); 
        }            
            if(!lstacc.isempty()){
                update lstacc;
                system.debug(lstacc);
            }  
        }
    }