public class ContactHandlerCountOnAcc {
    public static void updateonAcccount(set<id> setAccid){
        
        List<Account> lstacc = new List<Account>();
        for(Account acc : [SELECT Id ,Total_count_off_contacts__c,(SELECT ID ,Name FROM contacts)FROM Account WHERE Id IN :setAccid]){
                acc.Total_count_off_contacts__c = acc.contacts.size();
                lstacc.add(acc);
            }
        if(!lstacc.isempty()){
            update lstacc;
        }
        
    }
}