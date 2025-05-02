public class opportunityDispatcherRoll {
    public static set<id> SortAccid(List<opportunity> lstopp , Boolean isupdate, MAP<id,opportunity> mapold){
     set<id> setaccid = new set<id>();
        for(opportunity opp : lstopp){
            if(isupdate){
               string oldacc = mapold.get(opp.Id).Accountid;
                setaccid.add(oldacc);
                setaccid.add(opp.AccountId);
            } else {
                setaccid.add(opp.AccountId);
            }
        }
        return setaccid;
        
        
        
    }
}