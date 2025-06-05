global class CT_BatchAccountUpdatesFromTerritories implements Database.Batchable<sObject>, Database.Stateful
{
    global String query;
    private Set<Id> setTerritoryIDs;
    private Set<Id> setTerritoryIDsSoldToShipTo;
    private Set<Id> setTerritoryIDsIGAccounts;
    private Map<Id, Territory__c> mapTerritories;
    private Integer iCount;
    private Integer iTMUpdatedFromSalesRep;
    private Integer iOwnerIdResidentialTSalesRep;
    private Integer iOwnerIdMechanicalTSalesRep;
    private Integer iMechUser;
    private Integer iResidentialCAUser;
    private Integer iInsideSalesUser;
    private List<String> lstSoldToShipToRTIDs;

   
    global CT_BatchAccountUpdatesFromTerritories(Set<Id> setTerritoryIDs, Set<Id> setTerritoryIDsSoldToShipTo, Set<Id> setTerritoryIDsIGAccounts)
    {
        this.setTerritoryIDs = setTerritoryIDs;
        this.setTerritoryIDsSoldToShipTo = setTerritoryIDsSoldToShipTo;
        this.setTerritoryIDsIGAccounts = setTerritoryIDsIGAccounts;
        this.iCount = 0;
        this.iTMUpdatedFromSalesRep = 0;
        this.iOwnerIdResidentialTSalesRep = 0;
        this.iOwnerIdMechanicalTSalesRep = 0;
        this.iMechUser = 0;
        this.iResidentialCAUser = 0;
        this.iInsideSalesUser = 0;
        
        List<Territory__c> listTerritories = new List<Territory__c>([SELECT Id, Sales_Rep__c FROM Territory__c WHERE Id IN :setTerritoryIDs]);
        System.Debug('+++ List TerritoryIds: '+ listTerritories );
        mapTerritories = new Map<Id, Territory__c>();
        mapTerritories.putAll(listTerritories);
        
        String RTID_SoldTo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        String RTID_ShipTo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship-To').getRecordTypeId();
        lstSoldToShipToRTIDs = new List<String>();
        lstSoldToShipToRTIDs.add(RTID_SoldTo);
        lstSoldToShipToRTIDs.add(RTID_ShipTo);
        
        query = 'SELECT Id, TM__c, OwnerId, Territory__c, Mechanical_Territory__c, Finishing_Territory__c, Z3_Partner__c, '+
                     'Residential_CA_Territory_User__c, ' + //Z2 Territory User
                     'Finishing_TM__c, ' + //Z2 Territory User
                     'Mechanical_Territory_User__c, '+ // Z1 Territory User
                     'Inside_Sales__c, RecordTypeId '+
                'FROM Account '+
                'WHERE (Territory__c IN :setTerritoryIDsSoldToShipTo AND (RecordTypeId = \'' + String.escapeSingleQuotes(RTID_SoldTo) + '\' OR RecordTypeId = \'' + String.escapeSingleQuotes(RTID_ShipTo) +'\') ) '+
                    ' OR Territory__c IN :setTerritoryIDsIGAccounts '+
                    ' OR Mechanical_Territory__c IN :setTerritoryIDsIGAccounts '+
                    //' OR Finishing_Territory__c IN :setTerritoryIDsIGAccounts '+  // Sandip - 01/27/2022 - INC0999638 
                    ' OR Finishing_Territory__c IN :setTerritoryIDs'+
                    ' OR Z3_Partner__c IN :setTerritoryIDsIGAccounts '+
                'ORDER BY Territory__c, Mechanical_Territory__c, Finishing_Territory__c, Z3_Partner__c ';
        
        query += Test.isRunningTest() ? ' LIMIT 50' : '';
        system.Debug('========Query: ' + query);
    }

    //run the above constructor formed query to fetch case records
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        system.Debug('========Query: ' + query);
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
       //SYSTEM.DEBUG('+++++ mapTerritories : ' + mapTerritories.size());
       iCount += scope.size();
        
        List<Account> listAccountsForUpdate = new List<Account>();
        for(Account acc : scope) 
        {
            Boolean bAddAccount = false;
            
            Territory__c theT; 
            if(acc.Territory__c != null && mapTerritories.containsKey(acc.Territory__c) && lstSoldToShipToRTIDs.contains(acc.RecordTypeId))
            {
                theT = mapTerritories.get(acc.Territory__c);
                if(setTerritoryIDsSoldToShipTo.contains(theT.Id) && (acc.TM__c != theT.Sales_Rep__c))
                {
                    acc.TM__c = theT.Sales_Rep__c;
                    acc.OwnerId = theT.Sales_Rep__c; // INC0970887 - Sandip - 21th Sep 2021
                    bAddAccount = true; 
                    iTMUpdatedFromSalesRep += 1;
                }
            }
            
            
            Territory__c ResidentialTerritory;  //Territory.Accounts_Residential_Territory
            if(acc.Territory__c != null && mapTerritories.containsKey(acc.Territory__c))    
            {
                ResidentialTerritory = mapTerritories.get(acc.Territory__c);
                if(acc.OwnerId != ResidentialTerritory.Sales_Rep__c && setTerritoryIDsIGAccounts.contains(ResidentialTerritory.Id))
                {
                    acc.OwnerId = ResidentialTerritory.Sales_Rep__c;
                    bAddAccount = true;
                    iOwnerIdResidentialTSalesRep += 1;
                }
            }
            
            Territory__c MechanicalTerritory; // Territory.Accounts_Mechanical_Territory
            if(acc.Mechanical_Territory__c != null && mapTerritories.containsKey(acc.Mechanical_Territory__c))  
            {
                MechanicalTerritory = mapTerritories.get(acc.Mechanical_Territory__c);
                if(acc.Territory__c == null && (acc.OwnerId != MechanicalTerritory.Sales_Rep__c) && setTerritoryIDsIGAccounts.contains(MechanicalTerritory.Id))
                {
                    acc.OwnerId = MechanicalTerritory.Sales_Rep__c;
                    bAddAccount = true;
                    iOwnerIdMechanicalTSalesRep += 1;
                }  
                
                if((acc.Mechanical_Territory_User__c != MechanicalTerritory.Sales_Rep__c) && setTerritoryIDsIGAccounts.contains(MechanicalTerritory.Id)) // Z1 Territory User
                {
                    acc.Mechanical_Territory_User__c = MechanicalTerritory.Sales_Rep__c;
                    bAddAccount = true;
                    iMechUser += 1;
                }
            }
            
            Territory__c FinishingTerritory; // Territory.Accounts_ResidentialCA_Territory__r
            System.Debug ('+++Acc Finishing Terri: ' + acc.Finishing_Territory__c);
            if(acc.Finishing_Territory__c != null && mapTerritories.containsKey(acc.Finishing_Territory__c))    
            {
                System.Debug ('Finishing Terri Condtion: ' + acc.Finishing_Territory__c);
                FinishingTerritory = mapTerritories.get(acc.Finishing_Territory__c);
                //if(acc.Residential_CA_Territory_User__c != FinishingTerritory.Sales_Rep__c && setTerritoryIDsIGAccounts.contains(FinishingTerritory.Id)) // Sandip - 01/27/2022 - INC0999638 
                if(acc.Residential_CA_Territory_User__c != FinishingTerritory.Sales_Rep__c && setTerritoryIDs.contains(FinishingTerritory.Id))
                {
                    acc.Residential_CA_Territory_User__c = FinishingTerritory.Sales_Rep__c;
                    acc.Finishing_TM__c = FinishingTerritory.Sales_Rep__c; // Sandip - 01/20/2022 - INC0999638 
                    bAddAccount = true;
                    iResidentialCAUser += 1;
                }
                
            }
            
            Territory__c Z3PartnerTerritory; //Territory.Accounts2
            if(acc.Z3_Partner__c != null && mapTerritories.containsKey(acc.Z3_Partner__c))  
            {
                Z3PartnerTerritory = mapTerritories.get(acc.Z3_Partner__c);
                if(acc.Inside_Sales__c != Z3PartnerTerritory.Sales_Rep__c && setTerritoryIDsIGAccounts.contains(Z3PartnerTerritory.Id))
                {
                    acc.Inside_Sales__c = Z3PartnerTerritory.Sales_Rep__c;
                    bAddAccount = true;
                    iInsideSalesUser += 1;
                }
            }
            
            if(bAddAccount == true) listAccountsForUpdate.add(acc);
        }
        
        if(listAccountsForUpdate.size() > 0)    update listAccountsForUpdate;
    }

    global void finish(Database.BatchableContext BC)
    {
        SYSTEM.DEBUG('+++++ iCount: ' + iCount);
        SYSTEM.DEBUG('+++++ iTMUpdatedFromSalesRep: ' + iTMUpdatedFromSalesRep);
        SYSTEM.DEBUG('+++++ iOwnerIdResidentialTSalesRep: ' + iOwnerIdResidentialTSalesRep);
        SYSTEM.DEBUG('+++++ iOwnerIdMechanicalTSalesRep: ' + iOwnerIdMechanicalTSalesRep);
        SYSTEM.DEBUG('+++++ iMechUser: ' + iMechUser);
        SYSTEM.DEBUG('+++++ iResidentialCAUser: ' + iResidentialCAUser);
        SYSTEM.DEBUG('+++++ iInsideSalesUser: ' + iInsideSalesUser);
    }
}