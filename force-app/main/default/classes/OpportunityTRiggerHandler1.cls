public class OpportunityTRiggerHandler1 {
    public static void CheckEmail(list<opportunity> lstopp){
        // map<id,opportunity> oldmaps = new map<id,opportunity>([select id ,Name,Email__c FROM opportunity]);
        list<opportunity> oldlst = [select id,Name ,Email__c From opportunity where Email__c != null];
        for(opportunity opp : lstopp) {
            for(opportunity oldopp : oldlst){
                if(opp.Email__c == oldopp.Email__c){
                    opp.Email__c.adderror('Duplicate email') ;
                    system.debug('old record is '+oldlst );
                }else if(opp.Email__c == null){
                    opp.Email__c.adderror('please Enter Email');
                }
            }
        }        
        
    }
}