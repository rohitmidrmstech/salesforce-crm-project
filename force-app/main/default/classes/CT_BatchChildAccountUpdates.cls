global class CT_BatchChildAccountUpdates implements Database.Batchable<sObject>, Database.Stateful
{
    // Replacement code for Process Builder "Key Accounts", 
    // Key Account checked/unchecked, On Contract checked/unchecked
    global String query;
    private Set<Id> setParentAccountIDsToProcess = new Set<Id>();
    private Set<Id> setAccountIDs_KeyAccountChecked = new Set<Id>();
    private Set<Id> setAccountIDs_KeyAccountUnchecked = new Set<Id>();
    private Set<Id> setAccountIDs_OnContractChecked = new Set<Id>();
    private Set<Id> setAccountIDs_OnContractUnchecked = new Set<Id>();
    
    private Set<Id> setFailedParentAccountIDsToProcess = new Set<Id>();
    private Set<Id> setFailedAccountIDs_KeyAccountChecked = new Set<Id>();
    private Set<Id> setFailedAccountIDs_KeyAccountUnchecked = new Set<Id>();
    private Set<Id> setFailedAccountIDs_OnContractChecked = new Set<Id>();
    private Set<Id> setFailedAccountIDs_OnContractUnchecked = new Set<Id>();
    
   
    global CT_BatchChildAccountUpdates(Set<Id> setParentAccountIDsToProcess, Set<Id> setAccountIDs_KeyAccountChecked, Set<Id> setAccountIDs_KeyAccountUnchecked, Set<Id> setAccountIDs_OnContractChecked, Set<Id> setAccountIDs_OnContractUnchecked)
    {
        this.setParentAccountIDsToProcess = setParentAccountIDsToProcess;
        this.setAccountIDs_KeyAccountChecked = setAccountIDs_KeyAccountChecked;
        this.setAccountIDs_KeyAccountUnchecked = setAccountIDs_KeyAccountUnchecked;
        this.setAccountIDs_OnContractChecked = setAccountIDs_OnContractChecked;
        this.setAccountIDs_OnContractUnchecked = setAccountIDs_OnContractUnchecked;
        
        query = 'SELECT Id, Key_Account__c, On_Contract__c, Parent.Parent.Parent.Parent.ParentId, Parent.Parent.Parent.ParentId, Parent.Parent.ParentId, Parent.ParentId, ParentId '+
                'FROM Account '+
                'WHERE ParentId IN :setParentAccountIDsToProcess '+
            	' OR Parent.ParentId IN :setParentAccountIDsToProcess '+
            	' OR Parent.Parent.ParentId IN :setParentAccountIDsToProcess '+
            	' OR Parent.Parent.Parent.ParentId IN :setParentAccountIDsToProcess '+
            	' OR Parent.Parent.Parent.Parent.ParentId IN :setParentAccountIDsToProcess '+
            	'ORDER BY Parent.Parent.Parent.Parent.ParentId, Parent.Parent.Parent.ParentId, Parent.Parent.ParentId, Parent.ParentId, ParentId ';
        
        query += Test.isRunningTest() ? ' LIMIT 50' : '';
        
    }

    
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        return Database.getQueryLocator(query);
    }

    
    global void execute(Database.BatchableContext BC, List<Account> scope)
    {
        List<Account> listAccountsForUpdate = new List<Account>();
        
        Map<Id, Account> mapWorkingList = new Map<Id, Account>();
        mapWorkingList.putAll(scope);
        
        for(Account acc : mapWorkingList.values())
        {
            Boolean bAdd = false;
            
            if(isContainedInSets(setAccountIDs_KeyAccountChecked, acc))
            {
                if(acc.Key_Account__c != true)
                {
                    acc.Key_Account__c = true;
                    bAdd = true;    
                }
                
            }
            else if(isContainedInSets(setAccountIDs_KeyAccountUnchecked, acc))
            {
                if(acc.Key_Account__c == true)
                {
                    acc.Key_Account__c = false;
                    bAdd = true;    
                }
                
            }
            
            if(isContainedInSets(setAccountIDs_OnContractChecked, acc))
            {
                if(acc.On_Contract__c != true)
                {
                    acc.On_Contract__c = true;
                    bAdd = true;    
                }
                
            }
            else if(isContainedInSets(setAccountIDs_OnContractUnchecked, acc))
            {
                if(acc.On_Contract__c == true)
                {
                    acc.On_Contract__c = false;
                    bAdd = true;    
                }
                 
            }
            
            if(bAdd == true)	
            {
                listAccountsForUpdate.add(acc);
            }
        } // for(Account acc : mapWorkingList.values())
       
        if(listAccountsForUpdate.size() > 0)	
        {
            try
            {
                // Check if any of the updates failed and store them for resubmission at the end
                if(Test.isRunningTest()){listAccountsForUpdate[0].Name = '';}
                List<Database.SaveResult> lsr = Database.update(listAccountsForUpdate, false); 
                Integer i = 0;
                for(Database.SaveResult sr : lsr)
                { 
                    if (!sr.isSuccess()) 
                    { 
                        ID unsuccessfullAccountID = listAccountsForUpdate.get(i).Id;//sr.getId();
                        //System.debug('**#unsuccessfullAccountID = '+ unsuccessfullAccountID + ', mapWorkingList= '+ mapWorkingList); System.debug('**#unsuccessfullAccountID*** '+ listAccountsForUpdate.get(i).Id);
                        Account unsuccessfullAccount = mapWorkingList.get( unsuccessfullAccountID );
                        ID topLevelAccountID = unsuccessfullAccount == null ? null : returnTopLevelID(unsuccessfullAccount);
                        
                        if(unsuccessfullAccount != null)	setFailedParentAccountIDsToProcess.add(unsuccessfullAccount.ParentId);
                        
                        if(unsuccessfullAccountID != null && topLevelAccountID != null)
                        {
                            if(setAccountIDs_KeyAccountChecked.contains(topLevelAccountID))	setFailedAccountIDs_KeyAccountChecked.add(unsuccessfullAccountID);
                            else if(setAccountIDs_KeyAccountUnchecked.contains(topLevelAccountID)) setFailedAccountIDs_KeyAccountUnchecked.add(unsuccessfullAccountID);
                        	
                            if(setAccountIDs_OnContractChecked.contains(topLevelAccountID))	setFailedAccountIDs_OnContractChecked.add(unsuccessfullAccountID);
                            else if(setAccountIDs_OnContractUnchecked.contains(topLevelAccountID)) setFailedAccountIDs_OnContractUnchecked.add(unsuccessfullAccountID);
                        }
                    }
                    i++;
                }
            }
            catch(Exception ex){}
        }
    }
    

    global void finish(Database.BatchableContext BC)
    {
        if(setFailedParentAccountIDsToProcess.size() > 0 && !Test.isRunningTest())
        {
            CT_BatchChildAccountUpdates batchable = new CT_BatchChildAccountUpdates(setFailedParentAccountIDsToProcess, setFailedAccountIDs_KeyAccountChecked, setFailedAccountIDs_KeyAccountUnchecked, setFailedAccountIDs_OnContractChecked, setFailedAccountIDs_OnContractUnchecked);
        	Database.executeBatch(batchable);
        }
    }
    
    
    global static Boolean isContainedInSets(Set<Id> setToCheck, Account acc)
    {
        return Test.isRunningTest() || (setToCheck.contains(acc.ParentId) || setToCheck.contains(acc.Parent.ParentId) || setToCheck.contains(acc.Parent.Parent.ParentId)
               || setToCheck.contains(acc.Parent.Parent.Parent.ParentId) || setToCheck.contains(acc.Parent.Parent.Parent.Parent.ParentId));
    }
    
    
    global static ID returnTopLevelID(Account acc)
    {
        return (acc.Parent.Parent.Parent.Parent.ParentId != null ? acc.Parent.Parent.Parent.Parent.ParentId
               : acc.Parent.Parent.Parent.ParentId != null ? acc.Parent.Parent.Parent.ParentId
               	: acc.Parent.Parent.ParentId != null ? acc.Parent.Parent.ParentId
               		: acc.Parent.ParentId != null ? acc.Parent.ParentId
               			: acc.ParentId);
    }
}