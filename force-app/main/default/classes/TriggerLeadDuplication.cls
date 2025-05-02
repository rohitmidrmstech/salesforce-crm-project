public class TriggerLeadDuplication {
    public static void ChecKMPHone(List<lead> lstlead){
        List<contact> lstacc = [SELECT ID ,Phone FROM contact WHERE MobilePhone != null];
        Map<string ,contact> conval = new Map<string,contact>();
        for(contact con : lstacc){
            conval.put(con.Phone ,con);
        }
        for(Lead lcc : lstlead){
            if(lcc.MobilePhone != null){
                if(conval.containskey(lcc.MobilePhone)){
                  lcc.adderror('the dupicate phone is plz add alternate PN');  
                }
                    }
        }
        
    }
}