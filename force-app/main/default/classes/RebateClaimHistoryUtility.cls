public class RebateClaimHistoryUtility {
    
	@AuraEnabled
    Public Static List<ClaimHistory> getHistory(String rebateClaimId){
        
        List<ClaimHistory> resultsHistory = new List<ClaimHistory>();
        List<RebateClaimHistory> results = [Select Id,CreatedBy.Name,CreatedDate,Field,DataType,OldValue,NewValue FROM RebateClaimHistory WHERE RebateClaimId =:rebateClaimId ORDER BY CreatedDate DESC];  

        for(RebateClaimHistory r : results){
            ClaimHistory c = new ClaimHistory();
            	Datetime cd = r.CreatedDate;
                c.CreateDate = cd;
                c.Field = r.Field;
                c.User = r.CreatedBy.Name;
           		if(r.DataType == 'Text'){
                 c.OrginalValue = (string)r.OldValue;
                 c.NewValue = (string)r.Newvalue;
                }
            	else if(r.DataType == 'Double'){
                 c.OrginalValue = String.valueOf(r.OldValue);   
                 c.NewValue = String.valueOf(r.Newvalue);  
                }
             	else if(r.DataType == 'DateTime'){
                 c.OrginalValue = String.valueOf(r.OldValue);   
                 c.NewValue = String.valueOf(r.Newvalue);  
                }
            	else
                {
                 c.OrginalValue = (string)r.OldValue;
                 c.NewValue = (string)r.Newvalue;
                }   
            resultsHistory.Add(c);
        }
              
        return resultsHistory;
    }
    
    // Wrapper class for RebateClaimHistory
    Public Class ClaimHistory
    {
         @AuraEnabled public Datetime CreateDate;
         @AuraEnabled public String Field;
         @AuraEnabled public String User;
         @AuraEnabled public String OrginalValue;
         @AuraEnabled public String NewValue;
        
    }
    
}