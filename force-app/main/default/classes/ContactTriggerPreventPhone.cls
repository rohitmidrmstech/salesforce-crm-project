public class ContactTriggerPreventPhone {
    public static void DuplicatePhone(List<contact> lstcon){
        set<id> setconId = new set<id>();
        for(contact con : lstcon){
            setconid.add(con.id);
        }
        List<contact> lstcons = [SELECT ID ,Phone FROM contact WHERE Phone != null];
        set<string> setoffPhone = new set<string>();
        for(contact con : lstcons){
            setoffphone.add(con.phone);
        }for(contact con : lstcon){
            if(setoffPhone.contains(con.Phone) != null){
                con.adderror('This phone is Already exist');
            }
        }
    }
}