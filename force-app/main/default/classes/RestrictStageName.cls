public class RestrictStageName {
    public static void restrictAcc(List<opportunity> lstopp,Map<id, opportunity> oldmap){
       // List<opportunity> lstopp = new List<opportunity> ;
        for(opportunity opp : lstopp) {
            if(oldmap.get(opp.id).StageName == 'Closed won' && opp.StageName != 'Closed won'){
               opp.StageName.adderror('you can not already close won opportunity');
            }
        }
    }
}

          //ror:Apex trigger OpportunityTriggerRestrict caused an unexpected exception, contact your administrator:
          // OpportunityTriggerRestrict: execution of BeforeUpdate caused by: System.FinalException:
          //  SObject row does not allow errors: Class.RestrictStageName.restrictAcc: line 6, column 1
    
                
              // oldlst.get(opp.id).StageName = 'Closed won' and opp.StageName != 'Closed won ';
               // oldlst.get(opp.id).StageName.adderror('you can not chan close won opportunity');
                
            
           /* if(oldmap.get(opp.id).StageName == 'Closed won' && opp.StageName != 'Closed won') {
                oldmap.get(opp.id).StageName.adderror('You can not change already close won stage');
                system.debug('List off old opp ' + oldmap);
            } */