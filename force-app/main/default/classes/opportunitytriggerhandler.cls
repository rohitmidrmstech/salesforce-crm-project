public class opportunitytriggerhandler {
    public static void updatedescription(list<opportunity> lstopp){
        for(opportunity opp : lstopp){
            if(opp.StageName == 'closed won') {
                opp.description  = 'you won the opportunity';
            }
        }         
    }
    public static void createarchiveopp(list<opportunity> lstopp){
        List<Opportunity_Archieve__c> lstarropp = new List<Opportunity_Archieve__c>(); 
        for(opportunity opp : lstopp) {
            Opportunity_Archieve__c lstarr = new Opportunity_Archieve__c(); 
            lstarr.Name = opp.Name;
            lstarr.close_Date__c = opp.CloseDate;
            lstarr.Stage_Name__c = opp.StageName;
            lstarr.Opportunity__c = opp.Id;
            lstarropp.add(lstarr);
            
        }      
        insert lstarropp;
        
    }
}