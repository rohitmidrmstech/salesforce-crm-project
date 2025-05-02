public class contactClass {
    public static void ContactHandler(List<contact> lstcon){
        map<id,contact> newmap = new map<id,contact>();
        for(contact con: lstcon){
            if(con.AccountId != null){
                newmap.put(con.AccountId , con);
            }
        }
        List<contact> lstcontact = new List<contact>();
        for(Account acc :[SELECT ID ,ownerId ,(SELECT Id ,ownerid FROM contacts )FROM Account WHERE ID =: newmap.keySet()]){
            for(contact con : acc.contacts){
                if(con.AccountId != newmap.get(con.id).AccountId){
                 con.OwnerId = acc.OwnerId;
                    lstcontact.add(con);
                }
            }
            
        }
        update lstcontact;
    }
}