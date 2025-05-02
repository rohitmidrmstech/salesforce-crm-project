public class updateOppAmounttoAccount {
    public static void afterOpportunityCreation(List<Opportunity>newlist){
        List<Account> acctobeUpdated = new List<Account>();
       set<Id> AccountIdsset = new  set<Id>();
        for(Opportunity opp : newlist){
            if(opp.AccountId != null){
              AccountIdsset.add(opp.AccountId);
            }
        }
        
       acctobeUpdated =   calculateAnnualRevenue(AccountIdsset);    
        if(!acctobeUpdated.isEmpty()){
            Update acctobeUpdated;
        }
    }
    Public static List<Account> calculateAnnualRevenue(Set<Id>accid){
        List<Account> toUpdateaccAnnual= new  List<Account>();
        List<Opportunity>oppList = [SELECT Id ,Amount,AccountId FROM Opportunity WHERE AccountId IN : accid];
        Map<Id, decimal> accIdandAnnualRevenue= new   Map<Id, decimal>();
        for(Opportunity opp :oppList){
            Decimal Total = 0;
            if(opp.Amount != null)
                if(accIdandAnnualRevenue.ContainsKey(opp.AccountId)){
                    Total = accIdandAnnualRevenue.get(opp.AccountId) + opp.Amount;
                    accIdandAnnualRevenue.put(opp.AccountId,Total);
                }
               accIdandAnnualRevenue.put(opp.AccountId, opp.Amount);
}
        for( Id i :accIdandAnnualRevenue.Keyset()){
           Account acc = new Account();
            acc.Id= i;
            acc.AnnualRevenue= accIdandAnnualRevenue.get(i);
            toUpdateaccAnnual.add(acc);
        }
        
        return toUpdateaccAnnual;
}
     public static Map<String, Integer> getAccountCountByIndustry() {
        // Map to hold the industry and their corresponding account counts
        Map<String, Integer> industryCountMap = new Map<String, Integer>();
        
        // SOQL query to get the count of accounts grouped by Industry
        AggregateResult[] groupedResults = [SELECT Industry, COUNT(Id)cou FROM Account GROUP BY Industry];
        System.debug('groupedResults==' + groupedResults);
        // Iterate through the results and populate the map
        for (AggregateResult result : groupedResults) {
            String industry = (String) result.get('Industry');
            System.debug('industry==' + industry);
            Integer count = ((Decimal) result.get('cou')).intValue(); // Convert Decimal to Integer
                        System.debug('count==' + count);
            industryCountMap.put(industry, count);
        }
        
        // Return the map with industry counts
        return industryCountMap;
    }

}