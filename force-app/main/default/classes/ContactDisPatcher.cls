public class ContactDisPatcher {
    public static void SortAccountid(list<contact> lstcontact,boolean isupdate, map<id, contact> mapold){
        //iterate all the contact and add into the set off ID
        set<id> Setaccid = new set<id>();
        for(contact con : lstcontact){   
            if(isupdate){
                string oldAccid = mapold.get(con.Id).AccountID;    
                if(con.AccountId != oldAccid){
                    Setaccid.add(con.AccountId);
                    Setaccid.add(oldAccid);
                    system.debug('oldaccid '+oldAccid);
                    system.debug('oldaccid '+con.AccountId);
                }
            } else {
                Setaccid.add(con.AccountId);
                system.debug('oldaccid '+Setaccid);
                
                
            }
            
        }
        if(!Setaccid.isempty()){
            ContactTriggerCounthandler.updateAcountCon(Setaccid);   
            system.debug(Setaccid);
            
        }
    }
}