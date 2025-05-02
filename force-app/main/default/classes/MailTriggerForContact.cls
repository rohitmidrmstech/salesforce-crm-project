public class MailTriggerForContact {
    public static void EmailForInsertedCon(List<contact> Lstcontact){
        List< messaging.SingleEmailMessage > emailList = new List< messaging.SingleEmailMessage>();          
        for(contact con : Lstcontact){
            if(con.Email != '' && con.Email != null){
                // MailTriggerForContact.emailMethod(); 
                messaging.SingleEmailMessage emailto = new messaging.SingleEmailMessage() ;
                emailto.setHtmlBody('hi Dear , your contact is successfully inserted');
                emailto.setSenderDisplayName('Mk Exim New PVT>LTd');
                emailto.setSubject('Regarding Insertion Of conatct');
                List<string> emailtoset = new List<string>();
                emailtoset.add( con.Email);
                emailto.setToAddresses(emailtoset);
                emailList.add( emailto);
            }
            
            
        }
        messaging.sendEmail(emailList);
        
    }
    public static void CreateCOnTOOpp(List<contact> lstcontact){
        // set<id> setConids = new set<id>();
        List<opportunity> lstopp = new List<opportunity>();
        for(contact con : lstcontact){
            if(con.FirstName != null && con.LastName != null){
                opportunity opp = new opportunity();
                opp.Name = con.FirstName + 'This from Contact' ;
                opp.StageName= 'Close won';
                opp.CloseDate= system.today() + 5;
                opp.contact__c = con.Id;
                lstopp.add(opp);
            }
        }
        insert lstopp;
    }
    public static void contactRecord(List<contact> lstcontact){
        for(contact con : lstcontact){
            con.LastName = con.LastName + 'Coperation contact';
        }
    }
}