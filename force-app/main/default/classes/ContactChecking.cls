public class ContactChecking {
    public static void DeleteExistingNameRecord(List<contact> lstcon){
        set<string> setname = new set<string>();
        for(contact con : lstcon){
            setname.add(con.LastName);
        }
        List<string> lstcondelete = new List<string>();
        //list<string> lstname = new list<string>();
         List<contact> lstcons =[SELECT ID ,LastName FROM contact];  
        for(contact con : lstcons){
             lstcondelete.add(con.LastName);             
            }
    }
}