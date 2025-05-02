public class contacthandlerActive {
    public static set<id> Sortaccid(List<contact> lstacc , boolean isupdate, map<id,contact> oldmap){
       set<id> setAccid = new set<id>() ;
        for(contact con : lstacc){
            setAccid.add(con.AccountId);          
            if(isupdate) {
                if(con.AccountId != oldmap.get(con.Id).AccountId){
                    setAccid.add(oldmap.get(con.Id).AccountId);                                 
                }
            }
            
        }        
        return setAccid;
    }
}