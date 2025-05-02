public class AccountTriggerHandlerBySanjayGupta {
    public static void beforeInsertSetFieldValue(List<Account> accList){
        for(Account acc : accList){
            acc.Description ='Account is Created';
            if(acc.Type != null && acc.Type=='Prospect'){
                acc.Phone = '9156420720';
            }
        }
    }
    public static void beforeUpdateAccountPhone(List<Account> accList , Map<Id,Account> OldList){
        for(Account acc :accList){
            if(OldList!=null && OldList.get(acc.Id).Phone != acc.Phone){
                 acc.Description= 'Phone no is updated' + acc.Phone;
}
        }
        
    }
    public static void beforeDeleteAccount(List<Account> oldList){
        for(Account acc :oldList){
            if(acc.isActive__c =true){
                acc.addError('You cant Delete Active Account');
            }
        }
    }
     public static void updateRelatedOpptoPhone(List<Account> accList , Map<Id,Account> OldList){
         System.debug('accList==' + accList + 'OldList==' + OldList);
         List<Opportunity> cupdateOppList= new List<Opportunity>();
         Map<Id, Account> accListwithnew = new  Map<Id, Account> ();
        for(Account acc :accList){
            if(OldList!=null && OldList.get(acc.Id).Phone != acc.Phone){
             accListwithnew.put(acc.Id , acc);             
}
        } 
         List<Opportunity>  oppList = [SELECT Id ,AccountId,Amount FROM Opportunity WHERE AccountId IN :accListwithnew.keySet()];
                  System.debug('oppList==' + oppList );
         List<Opportunity> updateOppAmount= new List<Opportunity>();
         for(Opportunity opp : oppList)  {
             if(accListwithnew.ContainsKey(opp.AccountId)){
             Opportunity  oppupdate= new Opportunity();
             oppupdate.Id = opp.Id;
             oppupdate.Phone__c= accListwithnew.get(opp.AccountId).Phone;
             updateOppAmount.add(oppupdate);
             }
         }
         if(!updateOppAmount.isEmpty()){
            update updateOppAmount; 
         }
         
        
    }
    public static void CreateRelatedOpportunity(List<Account> accList){
        List<Opportunity> createOppList= new List<Opportunity>();
        for(Account acc :accList){
            Opportunity opp = new Opportunity(Name= acc.Name, StageName='Closed Won' , CloseDate= System.Today(), AccountId= acc.Id);
            createOppList.add(opp);
        }
        if(!createOppList.isEmpty()){
            Insert createOppList;
        }
        
    }
}