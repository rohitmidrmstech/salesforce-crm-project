public class OppTriggerHandler {
    public static void updateoppstage(List<opportunity> lstopp ) {
        List<opportunity> lstopps = new list<opportunity>();
        for(opportunity opp : lstopp){
            if(opp.StageName != 'Closed won'){
                opp.stageName = 'closed won ';
                opp.CloseDate = system.today();
                opp.Type = 'new customer';
                lstopps.add(opp);
            }
        }      
            update lstopps;
        }
    }