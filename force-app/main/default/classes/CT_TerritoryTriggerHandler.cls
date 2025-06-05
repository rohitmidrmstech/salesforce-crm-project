public class CT_TerritoryTriggerHandler 
{
    public static void processBeforeUpdates(List<Territory__c> newList, List<Territory__c> oldList)
    {
        Set<Id> setTerritoriesWithRepCountChanged = new Set<Id>();
        List<Territory__c> listCandidatesForSalesRepCountUpdates = new List<Territory__c>();
        
        Integer iListSize = newList.size();
        Integer i= 0;
        while(i < iListSize)
        {
            Territory__c newT = newList[i];
            Territory__c oldT = oldList[i];
            
            if(newT.Rep_Count__c != oldT.Rep_Count__c)
                listCandidatesForSalesRepCountUpdates.add(newT);
            
            i++;
        }
        
        if(listCandidatesForSalesRepCountUpdates.size() > 0)    SetTerritoryAdditionalSalesReps(newList, listCandidatesForSalesRepCountUpdates);
    }
    
    
    public static void processAfterInserts(List<Territory__c> newList)
    {
        
    }
    
    public static void processAfterUpdates(List<Territory__c> newList, List<Territory__c> oldList)
    {
        List<Territory__c> listRepCountChanged = new List<Territory__c>();
        
        List<Territory__c> listUpdateSoldToShipToTerritories = new List<Territory__c>();
        List<Territory__c> listUpdateAccountsForIG = new List<Territory__c>();
        Set<Id> setTerritoryIDsSoldToShipTo = new Set<Id>();
        Set<Id> setTerritoryIDsIGAccounts = new Set<Id>();
        Set<Id> setTerritoryIDs = new Set<Id>();
        
        List<Territory__c> listUpdateAccountsForBatch = new List<Territory__c>();
        
        List<String> lstValidOrgsGypsumCeilings = new List<String>{'1006','1100','1003','1101','1022'};
        List<String> lstValidOrgsIG = new List<String>{'1300', '1503', '1502', '1018', '1019', '1020'}; // added Sales org 1502 - INC1050546 - Sandip - 08/03/2022
        
        Integer iListSize = newList.size();
        Integer i= 0;
        while(i < iListSize)
        {
            Territory__c newT = newList[i];
            Territory__c oldT = oldList[i];
            
            if(newT.Sales_Rep__c != oldT.Sales_Rep__c)
            {
                if(lstValidOrgsGypsumCeilings.contains(newT.Sales_Org__c) || lstValidOrgsIG.contains(newT.Sales_Org__c))
                    setTerritoryIDs.add(newT.Id);
                
                if(lstValidOrgsGypsumCeilings.contains(newT.Sales_Org__c))
                    setTerritoryIDsSoldToShipTo.add(newT.Id);       
                
                if(lstValidOrgsIG.contains(newT.Sales_Org__c))
                    setTerritoryIDsIGAccounts.add(newT.Id);  
            }
            
            i++;
        }
        
        if(setTerritoryIDs.size() > 0)
        {
            SYSTEM.DEBUG('++++ CT_TerritoryTriggerHandler setTerritoryIDs.size(): ' + setTerritoryIDs.size());
            SYSTEM.DEBUG('++++ Territory Ids: ' + setTerritoryIDs);
            CT_BatchAccountUpdatesFromTerritories batchable = new CT_BatchAccountUpdatesFromTerritories(setTerritoryIDs, setTerritoryIDsSoldToShipTo, setTerritoryIDsIGAccounts);
            Database.executeBatch(batchable, 200);
        }
        
        
    }
    
    // move this code to CT_BatchAccountUpdatesFromTerritories
    /*public static void updateSoldToShipToAccounts(List<Territory__c> listUpdateSoldToShipToTerritories)
    {
        Id RTID_SoldTo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        Id RTID_ShipTo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship-To').getRecordTypeId();
        Map<Id, Territory__c> mapTerritories = new Map<Id, Territory__c>();
        mapTerritories.putAll(listUpdateSoldToShipToTerritories) ;
        List<Account> listAccountsForUpdate = new List<Account>();
        
        for(Account acc : [SELECT Id, TM__c 
                           FROM Account 
                           WHERE Territory__c IN :mapTerritories.keySet() 
                            AND (RecordTypeId = :RTID_SoldTo OR RecordTypeId = :RTID_ShipTo) ORDER BY Territory__c])
        {
            Territory__c theT = mapTerritories.get(acc.Territory__c);
            if(acc.TM__c != theT.Sales_Rep__c)
            {
                acc.TM__c = theT.Sales_Rep__c;
                listAccountsForUpdate.add( acc );
            }
        }
        
        if(listAccountsForUpdate.size() > 0)    update listAccountsForUpdate;
        
    }*/
    
    // move this code to CT_BatchAccountUpdatesFromTerritories
    /*public static void updateAccountsForIG(List<Territory__c> listUpdateAccountsForIG)
    {
        Map<Id, Territory__c> mapTerritories = new Map<Id, Territory__c>();
        mapTerritories.putAll(listUpdateAccountsForIG) ;
        Set<Id> setTerritoryIDs = new Set<Id>();
        setTerritoryIDs = mapTerritories.keySet();
        List<Account> listAccountsForUpdate = new List<Account>();
        
        //Account.Territory__c --> Accounts_Residential_Territory
        //Account.Mechanical_Territory__c --> Accounts_Mechanical_Territory
        //Finishing_Territory__c --> Accounts_ResidentialCA_Territory__r
        //Z3_Partner__c --> Accounts2__r
        
        for(Account acc : [SELECT Id, OwnerId, Territory__c, Mechanical_Territory__c, Finishing_Territory__c, Z3_Partner__c,
                            Residential_CA_Territory_User__c, //Z2 Territory User
                           Mechanical_Territory_User__c, // Z1 Territory User
                           Inside_Sales__c
                          FROM Account
                          WHERE Territory__c IN :setTerritoryIDs
                            OR Mechanical_Territory__c IN :setTerritoryIDs
                            OR Finishing_Territory__c IN :setTerritoryIDs 
                            OR Z3_Partner__c IN :setTerritoryIDs])
        {
            Boolean bAddAccount = false;
            
            Territory__c ResidentialTerritory;  //Territory.Accounts_Residential_Territory
            if(acc.Territory__c != null && mapTerritories.containsKey(acc.Territory__c))    
            {
                ResidentialTerritory = mapTerritories.get(acc.Territory__c);
                if(acc.OwnerId != ResidentialTerritory.Sales_Rep__c)
                {
                    acc.OwnerId = ResidentialTerritory.Sales_Rep__c;
                    bAddAccount = true;
                }
            }
            
            Territory__c MechanicalTerritory; // Territory.Accounts_Mechanical_Territory
            if(acc.Mechanical_Territory__c != null && mapTerritories.containsKey(acc.Mechanical_Territory__c))  
            {
                MechanicalTerritory = mapTerritories.get(acc.Mechanical_Territory__c);
                if(acc.Territory__c == null && (acc.OwnerId != MechanicalTerritory.Sales_Rep__c))
                {
                    acc.OwnerId = MechanicalTerritory.Sales_Rep__c;
                    bAddAccount = true;
                }  
                
                if(acc.Mechanical_Territory_User__c != MechanicalTerritory.Sales_Rep__c) // Z1 Territory User
                {
                    acc.Mechanical_Territory_User__c = MechanicalTerritory.Sales_Rep__c;
                    bAddAccount = true;
                }
            }
            
            Territory__c FinishingTerritory; // Territory.Accounts_ResidentialCA_Territory__r
            if(acc.Finishing_Territory__c != null && mapTerritories.containsKey(acc.Finishing_Territory__c))    
            {
                FinishingTerritory = mapTerritories.get(acc.Finishing_Territory__c);
                if(acc.Residential_CA_Territory_User__c != FinishingTerritory.Sales_Rep__c)
                {
                    acc.Residential_CA_Territory_User__c = FinishingTerritory.Sales_Rep__c;
                    bAddAccount = true;
                }
                
            }
            
            Territory__c Z3PartnerTerritory; //Territory.Accounts2
            if(acc.Z3_Partner__c != null && mapTerritories.containsKey(acc.Z3_Partner__c))  
            {
                Z3PartnerTerritory = mapTerritories.get(acc.Z3_Partner__c);
                if(acc.Inside_Sales__c != Z3PartnerTerritory.Sales_Rep__c)
                {
                    acc.Inside_Sales__c = Z3PartnerTerritory.Sales_Rep__c;
                    bAddAccount = true;
                }
            }
            
            if(bAddAccount == true) listAccountsForUpdate.add(acc);
        }
        
        if(listAccountsForUpdate.size() > 0)    update listAccountsForUpdate;
    }*/
    
    
    public static void SetTerritoryAdditionalSalesReps(List<Territory__c> newList, List<Territory__c> listCandidatesForSalesRepCountUpdates)
    {
        // replace flow "SetTerritoryAdditionalSalesReps"
        // 1. Find Territory User records for passed-in territories
        // 2. For each "Territory User" record, get User record (id, name)
        // 3. Concatenate User names by territory
        // 4. Update Territory.Additional_Sales_Reps__c with concatenated values
        
        Map<Id, Territory__c> mapCandidates = new Map<Id, Territory__c>();
        mapCandidates.putAll(listCandidatesForSalesRepCountUpdates);
        Map<Id, List<String>> mapTerritoryCandidates = new Map<Id, List<String>>();
        for(Territory_User__c uTerr : [SELECT Id, Territory__c, User__r.Name 
                                       FROM Territory_User__c 
                                       WHERE Territory__c IN :mapCandidates.keySet()
                                      ORDER BY Territory__c, User__r.Name])
        {
            List<String> listLocalCandidates = new List<String>();
            if(mapTerritoryCandidates.containsKey(uTerr.Territory__c))
                listLocalCandidates = mapTerritoryCandidates.get(uTerr.Territory__c);
            
            listLocalCandidates.add(uTerr.User__r.Name);
            
            mapTerritoryCandidates.put(uTerr.Territory__c, listLocalCandidates);
        }
        
        for(Territory__c ter : newList)
        {
            if(listCandidatesForSalesRepCountUpdates.contains(ter))
            {
                String sListCandidates = '';
                if(mapTerritoryCandidates.containsKey(ter.Id))
                {
                    List<String> listTerritoryCandidates = mapTerritoryCandidates.get(ter.Id);
                    Integer iListSize = listTerritoryCandidates.size();
                    Integer j = 0;
                    
                    while(j < iListSize)
                    {
                        sListCandidates += listTerritoryCandidates[j]+',';
                        j++;
                    }
                    sListCandidates = sListCandidates.substringBeforeLast(',');    
                }
                
                if(ter.Additional_Sales_Reps__c != sListCandidates) ter.Additional_Sales_Reps__c = sListCandidates;
            }
        }
    }
}