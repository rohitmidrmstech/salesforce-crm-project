public with sharing class GetAllOpportunityRecords {
         @AuraEnabled(cacheable=true)
    public static list<opportunity> getopportunityList(string searchKey) {
        string searchKeyword = '%' + searchKey + '%';		
        list<opportunity> opportunityListRecord = new list<opportunity>();    
        for(opportunity opp: [Select id,Name,StageName
                            From Opportunity
                            WHERE Name LIKE : searchKeyword]){
           opportunityListRecord.add(opp);
        }       
        return opportunityListRecord;
    }
         @AuraEnabled
    public static List<opportunity> updateRecord(string oppid){
        string oppName ='%' + oppid + '%';
        List<opportunity> lstopp = new List<opportunity>();
        List<opportunity> listopp = [SELECT Id ,Name, StageName FROM Opportunity WHERE Name LIKE: oppName];
        for(opportunity opp :listopp ){
            opp.StageName = 'Closed Won';
            lstopp.add(opp);
        }
        update lstopp;
         return lstopp;
    }
     @AuraEnabled(cacheable=true)
    public static List<Opportunity> getAllOpps() {
        return [SELECT Id, Name ,StageName, CloseDate ,Type ,Probability,Account.Name from Opportunity limit 10];
    }
      @AuraEnabled()
    public static void updateOpportunityNames(String[] ids) {

        List<Opportunity> opportunitiesToUpdate = new List<Opportunity>();
        List<Opportunity> selectedOpportunities = [SELECT Id, Name FROM Opportunity WHERE Id in :ids];

        Integer i = 0;
        for (Opportunity opportunity : selectedOpportunities){
                          
            opportunity.StageName = 'Closed';
            opportunitiesToUpdate.add(opportunity);
            i++;
    	}
        

        update opportunitiesToUpdate;
    }
   
}