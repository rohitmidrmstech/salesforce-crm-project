public class leadEmailhandler1 {
public static void RestrictEmail(List<lead> lstlead){
        set<string> setemail = new set<string>();
        for(Lead l1 : lstlead){
            setemail.add(l1.email);
        }
       
         set<string> oldemail = new set<string>();
        List<lead> lstleads = [SELECT ID ,Name ,email FROM lead WHERE email != null];
        for(lead l1 : lstlead){
           oldemail.add(l1.Email);
        }
        List<contact> lstcon = [SELECT ID ,email FROM contact];
        set<string> setemils = new set<string>();
        for(contact con : lstcon){
            setemils.add(con.email);
        }
        for(lead l1 : lstlead){
            if(setemils.contains(l1.email) && (oldemail.contains(l1.email))){
                l1.adderror('email is already exist in contact or Lead');
                
            }
        }
    }
}


 /*Map<String, contact> mapContact = new Map<String, contact>();
        List<Contact> lstContact = [SELECT Id, MobilePhone FROM Contact where MobilePhone != null];
       
        for(Contact con : lstContact){
            {
                mapContact.put(con.MobilePhone,con);
            }
            System.debug('Set Handler :: ' + mapContact.put(con.MobilePhone, con));
        }
        System.debug('Map Debug :: ' + mapContact);
       
        for(Lead led :lstLead){
            if(led.MobilePhone != null){
                if(mapContact.containskey(led.MobilePhone)){
                     led.adderror('You have done');
                }
               
            }
        }
    }*/