public class ContactDispatherOff {
    public static set<id> sortAccid(List<contact> lstacc , boolean isupdate, map<id,contact> oldmap){
        set<id> setAccid = new set<id>();
        for(contact con : lstacc){
            setAccid.add(con.AccountId);
            
            if(isupdate){
                setAccid.add(oldmap.get(con.id).AccountId);
            }else {
                setAccid.add(con.AccountId);
            }
            
            
        }
        return setAccid;    
    }
}