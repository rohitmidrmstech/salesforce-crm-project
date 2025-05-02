public class contactThhandler {
    public static void updatecon(List<contact> lstcon){        
        set<id> setaccid = new set<id>();
        for(contact con : lstcon){
            if(con.AccountId != null){
                setaccid.add(con.Accountid);
            }
        }
        if(setaccid.size()> 0){
            map<id,Account> newmap = new map<id,Account>([select id ,Name ,Phone FROM Account WHERE ID IN :setaccid]);
            for(contact con : lstcon){
                if(con.AccountId !=null && newmap.containsKey(con.AccountId) != null) {
                    if(newmap.get(con.AccountId).phone != null){
                        con.Phone = newmap.get(con.AccountId).phone;
                    }
                } 
            }
        }
    }
}