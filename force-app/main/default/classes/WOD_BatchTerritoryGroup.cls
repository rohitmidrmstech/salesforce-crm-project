/**
 * @description Batch class to create/update Public Group from Territory or User.
*/
public class WOD_BatchTerritoryGroup implements Database.Batchable<sObject>{
    /**
     * @description Batch class start method
     * @param bc BatchableContext
     * @return QueryLocator
    */
   public Database.QueryLocator start(Database.BatchableContext bc)
   {
      return Database.getQueryLocator('Select Id, Sales_Org__c, Territory_SalesOrg__c, Sales_Rep__c, Sales_Rep__r.IsActive, Sales_Rep2__c, Sales_Rep2__r.IsActive, Sales_Rep3__c, Sales_Rep3__r.IsActive, Sales_Rep4__c, Sales_Rep4__r.IsActive, Sales_Rep5__c,Sales_Rep5__r.IsActive  from Territory__c where ' +
                                      ' (Sales_Org__c = \'1501\' or Sales_Org__c = \'1502\' or Sales_Org__c = \'1102\') and Territory_SalesOrg__c != null');
   }
    /**
     * @description Batch class execute method
     * @param bc BatchableContext
     * @param scope List of Claim Records
    */
   public void execute(Database.BatchableContext bc, List<sObject> scope)
   {
       List<Territory__c> lstEligibleTerritory = new List<Territory__c>();
       List<Territory__c> lstTerritory = (List<Territory__c>) scope;
       Map<string,set<Id>> mapNewUserToTerritory = new Map<string,set<Id>>();
        Map<string,set<Id>> mapRemoveUserFromTerritory = new Map<string,set<Id>>();
       
         for(Territory__c t : lstTerritory)
         { 
             
             set<Id> usrTerritory = new set<Id>();    
             
              If(t.Sales_Rep__c != null && t.Sales_Rep__r.isActive)  
                  usrTerritory.add(t.Sales_Rep__c);
             If(t.Sales_Rep2__c != null && t.Sales_Rep2__r.isActive)  
                 usrTerritory.add(t.Sales_Rep2__c);
             If(t.Sales_Rep3__c != null && t.Sales_Rep3__r.isActive)  
                 usrTerritory.add(t.Sales_Rep3__c);
             If(t.Sales_Rep4__c != null && t.Sales_Rep4__r.isActive)  
                 usrTerritory.add(t.Sales_Rep4__c);
             If(t.Sales_Rep5__c != null && t.Sales_Rep5__r.isActive)  
                 usrTerritory.add(t.Sales_Rep5__c); 
             
             if(usrTerritory != null && usrTerritory.size() > 0)
             {
                 lstEligibleTerritory.add(t);
                 mapNewUserToTerritory.put('WarrantyGroup_' + t.Territory_SalesOrg__c,usrTerritory);
             }             
         }
       
         if (
             (  lstEligibleTerritory != null && lstEligibleTerritory.size() > 0 ||
              mapNewUserToTerritory!= null && mapNewUserToTerritory.size() >0
             )
            )
         {
             WOD_RecordSharing.warrantyPublicGroupModified = true;
             WOD_RecordSharing.isCalledFromBatch = true;
             WOD_RecordSharing.createpublicGroupfromTerritoryAndUpdateUser(lstEligibleTerritory,mapNewUserToTerritory,mapRemoveUserFromTerritory);     
         }    
   }
    /**
     * @description Batch class finish method
     * @param bc BatchableContext
    */
    public void finish(Database.BatchableContext bc){
   }

}