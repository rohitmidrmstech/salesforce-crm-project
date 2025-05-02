public class contactThandler {
    public static void updateAcc(set<id> setAccid){
        List<Account> lstacc = new List<Account>();
        //List<string> conname = new List<string>();
        for(Account acc : [SELECT ID ,Name,total_contact__c,related_ContactNAme__c,(SELECT ID ,LastName FROM contacts) FROM Account WHERE ID IN : setAccid]){              
            acc.total_contact__c = acc.contacts.size();
            lstacc.add(acc);                                                
        }
        if(!lstacc.isempty()){
            update lstacc;
        }
    }
    public static void updatingname(set<id> setaccid){
        List<Account> lstacc = new List<Account>();
        List<string> conname = new List<string>();
        for(Account acc : [SELECT ID ,related_ContactNAme__c,(SELECT ID ,LastName FROM contacts)FROM Account WHERE ID IN : Setaccid]){
            if(acc.contacts.size()>0){
                for(contact con : acc.contacts){
                    conname.add(con.LastName);
                } 
                acc.related_ContactNAme__c = string.join(conname, ',');
            } else {
                acc.related_ContactNAme__c = ',';
            }
            lstacc.add(acc);  
        }
        if(!lstacc.isempty()){
            update lstacc;
        }
    }
    // calculate max amount from the contact and roll up to Account
    public static void MaxAmountRollup(set<id> setaccid){
        List<Account> lstmax = new List<Account> ();
        for(Account acc : [SELECT ID ,Name,(SELECT ID ,Amount__c FROM contacts)FROM Account WHERE ID IN : setaccid]){ 
            decimal maxvalue = acc.contacts[0].Amount__c; 
            integer nooffcontact = acc.contacts.size();
            for(integer i = 1 ; i<nooffcontact ;i++ ){
                if(acc.contacts[i].Amount__c > maxvalue){
                    maxvalue =  acc.contacts[i].Amount__c;
                }       
            }
            acc.max_amount__c = maxvalue;
            lstmax.add(acc);
        }
        if(!lstmax.isempty()){
        update lstmax;
        }
        
    }
    public static void minimumAmount (set<id> setaccid){
       List<Account> lstacc = new List<Account>();
        For(Account acc : [SELECT ID ,min_Amount__c,(SELECT ID ,Name,Amount__c FROM contacts) FROM Account WHERE ID IN : setaccid]){
            decimal minamount = acc.contacts[0].Amount__c;
            decimal total = acc.contacts[0].Amount__c;
            integer nooffcontact = acc.contacts.size();
            for(integer i =1 ; i<nooffcontact ; i++){
                if(acc.contacts[i].Amount__c < minamount){
                    minamount = acc.contacts[i].Amount__c;
                }  
                total = total + acc.contacts[i].Amount__c; 
            }
            acc.min_Amount__c = minamount;
            acc.Total_amount__c = total;
            acc.Avg_Amount__c = (total/acc.contacts.size());
            lstacc.add(acc);
        }if(!lstacc.isempty()){
            update lstacc;
        }
        
        
    }
}