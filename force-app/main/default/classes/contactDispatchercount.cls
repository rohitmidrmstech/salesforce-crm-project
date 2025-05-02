public class contactDispatchercount {
    public static set<id> sortAccid (List<contact> lstcon ,boolean isupdate,Map<id,contact> oldmap){
        set<id> setAccid = new set<id>() ;
        for(contact con : lstcon){
            setAccid.add(con.AccountId);          
            if(isupdate) {
                if(con.AccountId != oldmap.get(con.Id).AccountId){
                    setAccid.add(oldmap.get(con.Id).AccountId);                                 
                }
            }
            
        }        
        return setAccid;
    }
    public static void Duplicatename(List<contact> lstacc){
        set<id> setconid = new set<id>();
        for(contact con : lstacc){
            setconid.add(con.id);
            system.debug('setconid >>>>' + setconid);
            
        }
        //List<contact> lstcon = [SELECT Id ,LastName,email FROM contact ];
        Map<string,contact> newmap = new map<string,contact>([SELECT email FROM contact WHERE ID IN : setconid]);
        for(contact con : lstacc){
            //newmap.put(con.Email,con);
            if(newmap.containskey(con.email)){
                con.adderror('duplicate email found');
            }
            //system.debug('lstcon after updated  >>>>' + newmap);
            
        }
        /*for(contact con : lstacc){
            if(newmap.containskey(con.email)){
                con.adderror('duplicate email found'); 
            }*/
        }
        
        
    }