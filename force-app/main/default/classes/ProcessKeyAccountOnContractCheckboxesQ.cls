public class ProcessKeyAccountOnContractCheckboxesQ implements Queueable{

    // Replacement code for Process Builder "Key Accounts", 
    // Key Account checked/unchecked, On Contract checked/unchecked
    List<Account> newList = new List<Account>();
    Map<Id, Account> oldMap = new Map<Id, Account>();
    public ProcessKeyAccountOnContractCheckboxesQ(List<Account> newList, Map<Id, Account> oldMap){
        this.newList = newList;
        this.oldMap = oldMap;
    }

    public void execute(QueueableContext context) {
        Integer iListSize = newList.size();
        Integer i = 0;
        Set<Id> setAccountIDs_KeyAccountChecked = new set<Id>();
        Set<Id> setAccountIDs_KeyAccountUnchecked = new set<Id>();
        Set<Id> setAccountIDs_OnContractChecked = new set<Id>();
        Set<Id> setAccountIDs_OnContractUnchecked = new set<Id>();
        Set<Id> setParentAccountIDsToProcess = new Set<Id>();
        
        while(i < iListSize)
        {
            Account aNew = newList[i];
            Account aOld = oldMap.get(newList[i].Id);
            setParentAccountIDsToProcess.add(aNew.Id);
            
            // Key Account checked --> update ChildAccounts.Key_Account__c
            if(aNew.Key_Account__c == true && aOld.Key_Account__c != true)  setAccountIDs_KeyAccountChecked.add(aNew.Id);
                
            
            // Key Account unchecked
            if(aNew.Key_Account__c != true && aOld.Key_Account__c == true)  setAccountIDs_KeyAccountUnchecked.add(aNew.Id);
                
            
            // On Contract checked
            if(aNew.On_Contract__c == true && aOld.On_Contract__c != true)  setAccountIDs_OnContractChecked.add(aNew.Id);
                
            
            // On Contract unchecked
            if(aNew.On_Contract__c != true && aOld.On_Contract__c == true)   setAccountIDs_OnContractUnchecked.add(aNew.Id);
               
            
            i++;
        }
        
        SYSTEM.DEBUG('++++ setAccountIDs_KeyAccountChecked SIZE: ' + setAccountIDs_KeyAccountChecked.size());
        SYSTEM.DEBUG('+++++ setAccountIDs_KeyAccountUnchecked SIZE: ' + setAccountIDs_KeyAccountUnchecked.size());
        if(setAccountIDs_KeyAccountChecked.size() > 0 || setAccountIDs_KeyAccountUnchecked.size() > 0 || setAccountIDs_OnContractChecked.size() > 0 || setAccountIDs_OnContractUnchecked.size() > 0)    
        {   
            CT_BatchChildAccountUpdates batchable = new CT_BatchChildAccountUpdates(setParentAccountIDsToProcess, setAccountIDs_KeyAccountChecked, setAccountIDs_KeyAccountUnchecked, setAccountIDs_OnContractChecked, setAccountIDs_OnContractUnchecked);
            if(!SYSTEM.isBatch()) Database.executeBatch(batchable);
        }
    }
}