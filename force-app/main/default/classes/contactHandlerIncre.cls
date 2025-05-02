public class contactHandlerIncre {
    public static void Updateacc(List<contact> lstcon){
        set<id> setAccid = new set<id>();
        for(contact con : lstcon){
            if(con.AccountId != null){
                setAccid.add(con.AccountId) ;
            }           
        }
        List<Account> lstacc = new List<Account>();
        integer count;
        for(Account acc : [SELECT ID ,Status_Increment__c,(SELECT ID ,Name ,LeadSource FROM contacts)FROM 
                           Account WHERE ID IN :setAccid]){
                               count =0;
                               for(contact con : acc.contacts) {
                                   if(con.LeadSource == 'web'){
                                       count++;
                                   } 
                               }
                               acc.Status_Increment__c = count;                            
                               lstacc.add(acc);                              
                           }
        update lstacc;
        
    }
}