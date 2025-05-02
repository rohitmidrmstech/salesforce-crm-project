public class oppHandlerStage {
    public static void updateAccStage(List<opportunity> lstopp){
        set<id> setoppid = new set<id>();
        for(opportunity opp : lstopp){
            setoppid.add(opp.id);
            system.debug('setoppid list is '+ setoppid);
            
        }
        List<Account> lstacc = new List<Account>();
        //for(opportunity opp :[SELECT ID ,Name ,Stage__c ,AccountID, Account.Stage__c FROM Opportunity WHERE ID IN : setoppid]){
            system.debug('opp list is ' +lstacc);           
            for(Account acc : [SELECT ID ,Name ,Stage__c,(SELECT ID ,Stage__c,AccountID  FROM Opportunities) FROM ACCOUNT WHERE ID IN :setoppid]) {
                system.debug('acc list is '+ acc); 
                for(opportunity opp : acc.Opportunities){
                if(opp.Stage__c != null) {
                    //Account acc = new Account();
                    acc.Stage__c = opp.Stage__c;
                    lstacc.add(acc);
                    system.debug('lstacc is >>>'+ lstacc);
                }
            }
            }
            
        if(!lstacc.isempty()){
            update lstacc;
            system.debug('updated list is +'+ lstacc);
        }
    }
}