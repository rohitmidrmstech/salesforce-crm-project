public class LocationHandler {
    public static void CreateconOnLocation(List<Account> Lstacc){
        //set<id> setAccid = new set<id>();
        List<contact> lstcon = new List<contact>();
        //map<id,decimal> newmap = trigger.newmap;
       // map<id,decimal> oldmap = trigger.oldmap;
        map<id,decimal> mapAcc = new map<id,decimal>();
        for(Account acc : Lstacc){
            if(acc.nooffocation__c != null){
                mapAcc.put(acc.id , acc.nooffocation__c);
            }
        }
            /*if(isupdate){
                if(oldmap.get(acc.Id) != null){
                    mapAcc.put(acc.id,acc.nooffocation__c);                  
                }
            }else {
                mapAcc.put(acc.id,acc.nooffocation__c);                  
                
            }*/
            
            // List<contact> lstcon = new List<contact>();
            if(mapAcc.size()>0 && mapAcc!=null){
                for(id accid : mapAcc.keyset()){
                    for(integer i = 0; i< mapAcc.get(accid); i++ ){
                        contact con = new contact() ;
                        con.AccountId = accid;
                        con.LastName = 'contact' + i;
                        lstcon.add(con);
                    }
                }
            }
            if(lstcon.size() > 0 && lstcon!=null){
                insert lstcon;
            }
        }
    
    public static void RestricitLocation(list<Account> lstacc){
        //map<id,Account> oldmaps = new map<id,Account>([SELECT Id ,Name ,nooffocation__c FROM Account ]);
        for(Account acc : lstacc){
            if(acc.nooffocation__c != null){
                acc.adderror('you can not edit already entered location');
            }
        }
    }
}