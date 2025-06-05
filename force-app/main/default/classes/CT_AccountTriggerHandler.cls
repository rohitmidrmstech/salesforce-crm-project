/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Account Trigger Handler class
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Deepak Regala (dregala@liquidhub.com) and Vincent Ip (vip@liquidhub.com)
* @version        1.0
* @created        2017-07-12
*/
public without sharing class CT_AccountTriggerHandler 
{
  
    public Map<Id, Territory__c> territoriesMap
    {
        get
        {
            if(territoriesMap == null)
            {
                territoriesMap = new Map<Id, Territory__c>(
                    [SELECT Id, Territory_Code__c, 
                        Sales_Rep__c, Sales_Rep__r.Profile.Name, Sales_Rep__r.ManagerId
                    FROM Territory__c]);
            }
            return territoriesMap;
        }
        set;
    }
                    
    //public SET<Id> SAPRecordTypeIds;                //added to store RT ID of 'Payer', 'Ship-To', and 'Sold-To' recordTypes (SAP Accounts)
    
    public CT_AccountTriggerHandler(){    }
    
    
    
    public Set<Id> SAPRecordTypeIds 
    {
        get 
        {
            if(SAPRecordTypeIds == null)
            {
                SAPRecordTypeIds = new Set<ID>();
                //for(RecordType SAPAccountRecordType : [SELECT Id,Name FROM RecordType WHERE SobjectType='Account' AND (Name ='Payer' OR Name = 'Ship-To'  OR Name ='Sold-To')])
                    //SAPRecordTypeIds.add(SAPAccountRecordType.id);
                    //@SS: 06/29/2021 Replaced with Schema call, so avoid too many SOQL issue
                SAPRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payer').getRecordTypeId());
                SAPRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship-To').getRecordTypeId());
                SAPRecordTypeIds.add(Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId());
            }
            return SAPRecordTypeIds;
        }
        set;
    }
    
    // Merged getSAPAccounts and get13001503SAPAccounts Methods Added By Sunny Singh
    public Map<String, List<Account>> getFilteredSapAccounts(List<Account> newList){
        List<Account> SAPAccounts = new List<Account>();
        Set<String> setValidLOBs = new Set<String>{'1300','1503'};
        Map<String, List<Account>> filteredAccountMap = new Map<String, List<Account>>();
        for(Account a : newList){
            // Implement getSAPAccounts() Method Code
            if(SAPRecordTypeIds.contains(a.RecordTypeId)){
                SAPAccounts.clear();
                if(filteredAccountMap.containsKey('SAPAccounts')){
                    SAPAccounts = filteredAccountMap.get('SAPAccounts');
                    SAPAccounts.add(a);
                    filteredAccountMap.put('SAPAccounts', SAPAccounts);
                }else{
                    SAPAccounts.add(a);
                    filteredAccountMap.put('SAPAccounts', SAPAccounts);
                }
                //SAPAccounts.add(a);
            }
            // Implement get13001503SAPAccounts() Method Code
            if(setValidLOBs.contains(a.LOB__c)){
                SAPAccounts.clear();
                if(filteredAccountMap.containsKey('13001503SAPAccounts')){
                    SAPAccounts = filteredAccountMap.get('13001503SAPAccounts');
                    SAPAccounts.add(a);
                    filteredAccountMap.put('13001503SAPAccounts', SAPAccounts);
                }else{
                    SAPAccounts.add(a);
                    filteredAccountMap.put('13001503SAPAccounts', SAPAccounts);
                }
                //SAPAccounts.add(a);
            }
        }
        return filteredAccountMap;
    }


    public void beforeInsert(List<Account> newList)
    {
        //Commented and Implemented By Sunny 
        /*List<Account> NewSAPAccounts = getSAPAccounts(newList); //added to only fire on SAP Account RT's.
        if(NewSAPAccounts.size() > 0)   mapTmRsmFromTerritory(newList, NewSAPAccounts);*/
        Map<String, List<Account>> filteredAccountMap = getFilteredSapAccounts(newList);
        if(filteredAccountMap.size() > 0 && filteredAccountMap.containsKey('SAPAccounts'))   mapTmRsmFromTerritory(newList, filteredAccountMap.get('SAPAccounts'));
        
        // Capgemini, David Berman, 14 July 2021 : replace "SAP Account Partner Ownership" Process Builder
        /*List<Account> New13001503SAPAccounts = get13001503SAPAccounts(newList);*/ //Commented and Implemented By Sunny
        if(filteredAccountMap.size() > 0 && filteredAccountMap.containsKey('13001503SAPAccounts'))   mapTmRsmFromTerritory13001503(newList, filteredAccountMap.get('13001503SAPAccounts'));
        
    }
    
    public void beforeUpdate(List<Account> newList, Map<Id, Account> oldMap)
    {
        //Commented and Implemented By Sunny 
        /*List<Account> UpdatedSAPAccounts = getSAPAccounts(newList);        //added to only fire on SAP Account RT's
        SYSTEM.DEBUG('+++++ UpdatedSAPAccounts SIZE: ' + UpdatedSAPAccounts.size());
        if( UpdatedSAPAccounts.size() > 0)  checkMapTmRsmFromTerritory(newList, UpdatedSAPAccounts, oldMap);*/
        Map<String, List<Account>> filteredAccountMap = getFilteredSapAccounts(newList);
        if(filteredAccountMap.size() > 0 && filteredAccountMap.containsKey('SAPAccounts'))  checkMapTmRsmFromTerritory(newList, filteredAccountMap.get('SAPAccounts'), oldMap);
        
        // Capgemini, David Berman, 14 July 2021 : replace "SAP Account Partner Ownership" Process Builder
        /*List<Account> New13001503SAPAccounts = get13001503SAPAccounts(newList);*/ //Commented and Implemented By Sunny
        if(filteredAccountMap.size() > 0 && filteredAccountMap.containsKey('13001503SAPAccounts'))   checkMapTmRsmFromTerritory13001503(newList, filteredAccountMap.get('13001503SAPAccounts'), oldMap);
    }
    
    public void afterInsert(List<Account> newList)
    {
        processAccountTeamMembers(newList);
    }
    
    public void afterUpdate(List<Account> newList, Map<Id, Account> oldMap)
    {
        Boolean processKeyAccounts; 
        SYSTEM.DEBUG('++++  newList SIZE: ' + newList.size());
        system.debug('++++++ processAccountTeamMembers');
        processAccountTeamMembers(newList);
        // Below Code Comment and Impelemented By Sunny
        /*system.debug('++++++ processKeyAccountOnContractCheckboxes');
        processKeyAccountOnContractCheckboxes(newList, oldMap);*/
        
        processKeyAccounts = false;
        for(Account acc: newList){
            if(oldMap.get(acc.Id).Key_Account__c != acc.Key_Account__c || oldMap.get(acc.Id).On_Contract__c != acc.On_Contract__c){
                processKeyAccounts = true;
            }
        }
        if(processKeyAccounts){                                   // INC0970887 - Sandip - 22th Sep 2021
            ProcessKeyAccountOnContractCheckboxesQ obj = new ProcessKeyAccountOnContractCheckboxesQ(newList, oldMap);
            ID jobID = System.enqueueJob(obj);
        }        
    }
    
    
    public static MAP<Id,User> mapUsers 
    {
        get 
        {
            if(mapUsers == null)
            {
                mapUsers = new MAP<Id,User>([Select Id ,User_Territory_Code__c   From User Where User_Territory_Code__c != null AND IsActive = TRUE]);
            }
            return mapUsers;
        }
        set;
    }
   
        
    public static void processAccountTeamMembers(List<Account> newList)
    {
        set<Id> setParentId = new set<Id>();
        map<Id, Id> mapAccOwner = new map<Id, Id>();
        map<Id, Id> mapParentAcc = new map<Id, Id>();
        set<Id> setAccountId = new set<Id>();
        set<Id> setOwnerId = new set<Id>();
    
        for(Account a : newList )
        {
            
            if(a.ParentId != null )
            {
                setParentId.add(a.ParentId);
                mapParentAcc.put(a.ParentId, a.Id);
            }
            
            mapAccOwner.put(a.Id, a.OwnerId);
            setAccountId.add(a.Id);
            setOwnerId.add(a.OwnerId);  
        }
    
    
        List<AccountShare> listAccountShare = new List<AccountShare>();
        
        
        if(setOwnerId.size() > 0)
        {
            
            MAP<Id,User> mapUser = new MAP<Id,User>(); //([Select Id ,User_Territory_Code__c   From User Where Id IN: setOwnerId AND User_Territory_Code__c != null AND IsActive = TRUE]);
            
            for(User u : mapUsers.values()) if(setOwnerId.contains(u.Id))   mapUser.put(u.Id, u); 
            
            
            SET<string> setTerCode = new SET<string>();
            
            for(Account a : newList )
                if(mapUser.containsKey(a.OwnerId) ) setTerCode.add(mapUser.get(a.OwnerId).User_Territory_Code__c) ;
                
            
            if(setTerCode.size() > 0)
            {
                
                List<AccountTeamMember> listATM = new List<AccountTeamMember>();
                
                for(User u : mapUser.values()) //[Select Id,User_Territory_Code__c From User Where User_Territory_Code__c IN : setTerCode AND IsActive = true])
                {
                    //if(setTerCode.contains(u.User_Territory_Code__c))
                    for(Account a : newList )
                    {
                        if(mapUser.containsKey(a.OwnerId) )
                        {
                            if(mapUser.get(a.OwnerId).User_Territory_Code__c == u.User_Territory_Code__c && a.OwnerId != u.Id )
                            {
                                AccountTeamMember atm = new AccountTeamMember();
                                atm.AccountId = a.Id;
                                atm.UserId = u.Id;
                                //atm.AccountAccessLevel = 'Edit';
                                
                                listATM.add(atm);
                                
                                // Create Account Share
                                AccountShare ash = new AccountShare();
                                
                                ash.AccountId = a.Id;
                                ash.AccountAccessLevel = 'Edit';
                                ash.CaseAccessLevel = 'Edit'; 
                                ash.OpportunityAccessLevel = 'Edit';
                                ash.UserOrGroupId = u.Id ;
                                
                                listAccountShare.add(ash);
                                
                            }
                        }
                    }
                    
                }
                
                // Create Account team members
                if(listATM.size() > 0){
                    insert listATM;
                }
                
            }
        }
    }

    public void checkMapTmRsmFromTerritory(List<Account> triggerList, List<Account> newList, Map<Id, Account> oldMap)
    {
        List<Account> workingList = new List<Account>();
        for (Account currAcct : newList)
        {
            if (currAcct.Territory__c != null){
                Territory__c currTerr = territoriesMap.get(currAcct.Territory__c);
                
                if ( currAcct.Territory__c != oldMap.get(currAcct.Id).Territory__c ||   // if the territory changed
                     (currTerr!=null && currAcct.OwnerId != currTerr.Sales_Rep__c)      // if the territory owner is not the account owner
                ){
                    workingList.add(currAcct);
                }
            }
        }
        SYSTEM.DEBUG('+++++ workingList SIZE: ' + workingList.size());
        if(workingList.size() > 0)  mapTmRsmFromTerritory(triggerList, workingList);
    }
    
    /* before trigger handler for Account records
     * @param 
     *      - new inserted/updated accounts list
     * @description - populate corresponding user to RSM User field based on the region. 
    */
    public void mapTmRsmFromTerritory(List<Account> triggerList, List<Account> newList){
        
        for(Account currAcct : triggerList)
        {
            if(newList.contains(currAcct) && currAcct.Territory__c != null){
                Territory__c currTerr = territoriesMap.get(currAcct.Territory__c);

                if (currTerr!=null && currTerr.Sales_Rep__c!=null)
                {
                    if(currAcct.OwnerId != currTerr.Sales_Rep__c)   currAcct.OwnerId = currTerr.Sales_Rep__c;
                    
                    if(currAcct.TM__c != currTerr.Sales_Rep__c) currAcct.TM__c = currTerr.Sales_Rep__c;
                    
                    if(currAcct.RSM__c != currTerr.Sales_Rep__r.ManagerId)  currAcct.RSM__c = currTerr.Sales_Rep__r.ManagerId;
                    
                    if (currTerr.Sales_Rep__r.Profile.Name.contains('RSM') && (currAcct.RSM__c != currTerr.Sales_Rep__c)) currAcct.RSM__c = currTerr.Sales_Rep__c;
                }
            }
        }
    }
    
    // Capgemini, David Berman, 14 July 2021 : replace "SAP Account Partner Ownership" Process Builder
    public void checkMapTmRsmFromTerritory13001503(List<Account> triggerList, List<Account> newList, Map<Id, Account> oldMap)
    {
        Map<Id, Account> mapWorkingList = new Map<Id,Account>();
        for (Account currAcct : newList)
        {
            //Residential
            Territory__c currTerr = territoriesMap.get(currAcct.Territory__c);
            if ( currAcct.Territory__c != oldMap.get(currAcct.Id).Territory__c ||  (currTerr!=null && currAcct.OwnerId != currTerr.Sales_Rep__c)    )   mapWorkingList.put(currAcct.Id, currAcct);  // if the territory changed or the territory owner is not the account owner
            
            //Mechanical
            Territory__c mechTerr = territoriesMap.get(currAcct.Mechanical_Territory__c);
            if ( currAcct.Mechanical_Territory__c != oldMap.get(currAcct.Id).Mechanical_Territory__c ||  (mechTerr!=null && currAcct.OwnerId != mechTerr.Sales_Rep__c)    ) mapWorkingList.put(currAcct.Id, currAcct);  // if the mechanical territory changed or the territory owner is not the account owner
            
            //Z3 Partner
            Territory__c Z3Terr = territoriesMap.get(currAcct.Z3_Partner__c);
            if ( currAcct.Z3_Partner__c != oldMap.get(currAcct.Id).Z3_Partner__c ||  (Z3Terr!=null && currAcct.OwnerId != Z3Terr.Sales_Rep__c)    ) mapWorkingList.put(currAcct.Id, currAcct);  // if the Z3 Partner changed or the territory owner is not the account owner

            //Residential CA Territory
            Territory__c FinishingTerr = territoriesMap.get(currAcct.Finishing_Territory__c);
            if ( currAcct.Finishing_Territory__c != oldMap.get(currAcct.Id).Finishing_Territory__c ||  (FinishingTerr !=null && currAcct.OwnerId != FinishingTerr.Sales_Rep__c)    )    mapWorkingList.put(currAcct.Id, currAcct);  // if the Residential CA changed or the territory owner is not the account owner

        }
        SYSTEM.DEBUG('+++++ workingList SIZE: ' + mapWorkingList.size());
        if(mapWorkingList.size() > 0)   mapTmRsmFromTerritory13001503(triggerList, mapWorkingList.values());
    }
    
    // Capgemini, David Berman, 14 July 2021 : replace "SAP Account Partner Ownership" Process Builder
    public void mapTmRsmFromTerritory13001503(List<Account> triggerList, List<Account> newList)
    {
        
        for(Account currAcct : triggerList)
        {
            if(newList.contains(currAcct))
            {
                Territory__c ResidentialTerritory;  //Territory.Accounts_Residential_Territory
                if(currAcct.Territory__c != null && territoriesMap.containsKey(currAcct.Territory__c))  
                {
                    ResidentialTerritory = territoriesMap.get(currAcct.Territory__c);
                    if(ResidentialTerritory != null && currAcct.OwnerId != ResidentialTerritory.Sales_Rep__c )  currAcct.OwnerId = ResidentialTerritory.Sales_Rep__c;
                }
                
                Territory__c MechanicalTerritory;
                if(currAcct.Mechanical_Territory__c != null && territoriesMap.containsKey(currAcct.Mechanical_Territory__c))    
                {
                    MechanicalTerritory = territoriesMap.get(currAcct.Mechanical_Territory__c);
                    if(MechanicalTerritory != null && (currAcct.Mechanical_Territory_User__c != MechanicalTerritory.Sales_Rep__c) ) currAcct.Mechanical_Territory_User__c = MechanicalTerritory.Sales_Rep__c; // Z1 Territory User
                    
                    if(currAcct.Territory__c == null && (currAcct.OwnerId != MechanicalTerritory.Sales_Rep__c)) currAcct.OwnerId = MechanicalTerritory.Sales_Rep__c;
                        
                }
                
                Territory__c Z3PartnerTerritory;
                if(currAcct.Z3_Partner__c != null && territoriesMap.containsKey(currAcct.Z3_Partner__c))    
                {
                    Z3PartnerTerritory = territoriesMap.get(currAcct.Z3_Partner__c);
                    if(Z3PartnerTerritory != null && currAcct.Inside_Sales__c != Z3PartnerTerritory.Sales_Rep__c )  currAcct.Inside_Sales__c = Z3PartnerTerritory.Sales_Rep__c;
                }
                
                Territory__c FinishingTerritory; 
                if(currAcct.Finishing_Territory__c != null && territoriesMap.containsKey(currAcct.Finishing_Territory__c))  
                {
                    FinishingTerritory = territoriesMap.get(currAcct.Finishing_Territory__c);
                    if(FinishingTerritory != null && currAcct.Residential_CA_Territory_User__c != FinishingTerritory.Sales_Rep__c){
                        currAcct.Residential_CA_Territory_User__c = FinishingTerritory.Sales_Rep__c;
                        currAcct.Finishing_TM__c = FinishingTerritory.Sales_Rep__c; // Sandip - 01/20/2022 - INC0999638 
                    }  
                }
            }
            
        }
    }
    
    
    // Code Merged Source(Outmerge) to Target(Inmerge)
    public void autoNumberCMID(List<Account> newList){
        SFDCCMID_Autonumber__c cSettings = SFDCCMID_Autonumber__c.getValues('AutoNum1');
        if (cSettings != null) {
            Decimal LatestNumber = cSettings.AutoNum__c;
            String rtype;
            Map<ID, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosById();
            
            for(Account acc : newList){        
                rtype = rtMap.get(acc.RecordTypeId).getName();
                System.Debug('Acc Rec Type: ' + rtype);
                if(acc.SFDCCMID__c == null && (rtype == 'Customer Master Request' || rtype == 'New Prospect, Target, Customer' || rtype == 'Read-Only BPCS Record')){
                    acc.SFDCCMID__c =  'IG-' + String.valueOf(LatestNumber + 1).leftPad(9, '0');                      
                    LatestNumber = LatestNumber + 1;
                }
            }
            cSettings.AutoNum__c = LatestNumber;
            update cSettings;
        }
    }
}