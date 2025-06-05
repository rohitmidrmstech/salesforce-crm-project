/**
 * @description Batch class to share Claim Records with territory.
*/
public class WOD_BatchClassShare implements Database.Batchable<sObject>{
    
    String startDate;
    public  WOD_BatchClassShare(){
        
    }
    public  WOD_BatchClassShare(String startDate){
        this.startDate=startDate;
    }
    /**
	 * @description Batch class start method
	 * @param bc BatchableContext
	 * @return QueryLocator
	*/
   public Database.QueryLocator start(Database.BatchableContext bc)
   {
       String query='select id, Territory__c, Territory__r.Territory_SalesOrg__c from WOD_2__Claim__c where ' +
                                      ' Territory__c != null and Territory__r.Territory_SalesOrg__c != null';
       if(this.startDate!=null){
        query=query+ ' and createdDate>'+this.startDate;   
       }
       system.debug('query------>'+query);
      return Database.getQueryLocator(query);
   }
 
   /**
	 * @description Batch class execute method
	 * @param bc BatchableContext
     * @param scope List of Claim Records
	*/
   public void execute(Database.BatchableContext bc, List<sObject> scope)
   {
       List<string> listTerritory = new List<string>();
       Map<string,set<Id>> newSharingMap = new Map<string,set<Id>>();
        Map<string,set<Id>> removeSharingMap = new Map<string,set<Id>>();
       List<WOD_2__Claim__c> lstClaims = (List<WOD_2__Claim__c>) scope;
        for(WOD_2__Claim__c t : lstClaims)
            {
                system.debug('lstClaims------->'+lstClaims.size());
               listTerritory.add('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c);
                if(newSharingMap.containsKey('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c))
                {
                    newSharingMap.get('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c).add(t.Id);        
                }else
                {
                    newSharingMap.put('WarrantyGroup_'+ t.Territory__r.Territory_SalesOrg__c, new set<Id>{t.Id});
                }
                
            }
       
        if (newSharingMap!= null && newSharingMap.size() >0 )
               
            {
               
                WOD_RecordSharing.shareRecordsWithRelatedGroup('Claim',listTerritory,newSharingMap,removeSharingMap);     
            } 
       
   }
    /**
	 * @description Batch class finish method
	 * @param bc BatchableContext
	*/
    public void finish(Database.BatchableContext bc){
    }
}