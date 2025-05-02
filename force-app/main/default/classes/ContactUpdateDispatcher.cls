public class ContactUpdateDispatcher {
    public static Set<id> sortAccid(List<contact> lstcon,Map<id,contact> oldmap ,map<id,contact> newmap){
        set<id> setAccid = new set<id>();                  
        for(contact con : lstcon){
            if(con.AccountId != null){
                setAccid.add(con.AccountId);
                //return setAccid; 
            }
        }
        return setAccid; 
        
    }
}