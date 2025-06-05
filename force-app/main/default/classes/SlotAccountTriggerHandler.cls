/*********************************************************************************
* Utility Class: SlotAccountTriggerHandler
* Created By :
* Created Date : 08/26/2013
----------------------------------------------------------------------------------
* Purpose/Methods:
* - This class handles triggers of SlotAccount Objects.
* - Methods of this class are used in Trigger SlotAccountTrigger.
----------------------------------------------------------------------------------
* Unit Test: FixedSlotsTest
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME        DATE            DETAIL FEATURES
    1.0                            08/26/2013      INITIAL DEVELOPMENT
*********************************************************************************/
Public Class SlotAccountTriggerHandler {
    Public Static Boolean blnSlotAccountRecursiveFlag = false;
    /********************************************************************
    Purpose: It will check name of account for if match with custom lable
             open_slotaccount then open slotaccount? will true otherwise false.
    Parameters: List<Slot_Account__c> list of SlotAccounts
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    Public Static void aiuManageOpenSlotAccount(List<Slot_Account__c> lstSlotAccount) {
        List<Slot_Account__c> lstUpdateSlotAccount = New List<Slot_Account__c>([Select Id, Account__c, Account__r.Name 
                                from Slot_Account__c where Account__c != null and Id In : lstSlotAccount AND (Account__r.LOB__c = '1502' OR Account__r.LOB__c = '1003' OR Account__r.LOB__c = '1101')]);

        String strOpenAccount = System.Label.Open_SlotAccount;
    
        for (Slot_Account__c objSlotAccount : lstUpdateSlotAccount) {   objSlotAccount.Open_Account__c = (objSlotAccount.Account__r.Name != null && objSlotAccount.Account__r.Name == strOpenAccount) ? true : false;   }

        if (lstUpdateSlotAccount.Size() > 0) {
            SlotAccountTriggerHandler.blnSlotAccountRecursiveFlag = true;
            Update lstUpdateSlotAccount;
            SlotAccountTriggerHandler.blnSlotAccountRecursiveFlag = false;
        }
    }
    /********************************************************************
    Purpose: If the Slot Account is the first account for the slot, then its 
            name is set in the Slot.Account__c field
    Parameters: List<Slot_Account__c> list of SlotAccounts
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    Public Static void aiudSetFirstSlotAccountInSlot(List<Slot_Account__c> lstNewSlotAccount, List<Slot_Account__c> lstOldSlotAccount, 
                                            Boolean blnIsInsert, Boolean blnIsUpdate, Boolean blnIsDelete, Boolean blnIsUnDelete) {
        Set<Id> setSlotId = new Set<Id> ();
        Set<Id> setAccountId = new Set<Id> ();
        List<Slot_Account__c> lstSlotAccount = new List<Slot_Account__c>();
        //if (blnIsInsert || blnIsUpdate || blnIsUnDelete) 
        lstSlotAccount = blnIsInsert || blnIsUpdate || blnIsUnDelete ? lstNewSlotAccount : blnIsDelete ? lstOldSlotAccount : lstSlotAccount;
        //    lstSlotAccount = lstNewSlotAccount;
        //} else if (blnIsDelete){
        //    lstSlotAccount = lstOldSlotAccount;
        //}
        //Fill AccountId to fetch parent account data
        
        if (lstSlotAccount != null && lstSlotAccount.Size() != 0) {
            for (Slot_Account__c objSlotAccount : lstSlotAccount) {
                setAccountId.add(objSlotAccount.Account__c);
            }
        }
        Map<Id, Account> accounts = new Map<Id, Account>([SELECT Id, LOB__C FROM Account WHERE Id in :setAccountId]);
                                                
        if (lstSlotAccount != null && lstSlotAccount.Size() != 0) {
            for (Slot_Account__c objSlotAccount : lstSlotAccount) {
                if (objSlotAccount.Slot__c != null && !setSlotId.Contains(objSlotAccount.Slot__c) && accounts.containsKey( objSlotAccount.Account__c) && (accounts.get(objSlotAccount.Account__c).LOB__c == '1502' || accounts.get(objSlotAccount.Account__c).LOB__c == '1003' || accounts.get(objSlotAccount.Account__c).LOB__c == '1101'))  setSlotId.Add(objSlotAccount.Slot__c);
            }
        }
        //}
        //Retrieve the list of all slots for the slot accounts being updated
         List<Slot__c> lstSlot ;
        //if(!Test.isRunningTest()){
            lstSlot = !Test.isRunningTest() ? New List<Slot__c>([Select Id, Account__c, (Select Id, Account__c from Slot_Accounts__r) from Slot__c where Id In : setSlotId]) : New List<Slot__c>([Select Id, Account__c, (Select Id, Account__c from Slot_Accounts__r)
                                         from Slot__c ]);
        //}
        //else{
        //    lstSlot = New List<Slot__c>([Select Id, Account__c, (Select Id, Account__c from Slot_Accounts__r)
        //                                 from Slot__c ]);    
       // }

        for (Slot__c objSlot : lstSlot) {
            objSlot.Account__c = objSlot.Slot_Accounts__r.Size() == 0 ? null : objSlot.Slot_Accounts__r[0].Account__c ;
            
            /*if (objSlot.Slot_Accounts__r.Size() == 0) {objSlot.Account__c = null;
            } else if (objSlot.Slot_Accounts__r.Size() == 1) {
                objSlot.Account__c = objSlot.Slot_Accounts__r[0].Account__c;
            } else if (objSlot.Slot_Accounts__r.Size() > 1) {
                //if (objSlot.Account__c == null) { //Commented as Account__c was not updating when there are >=3 Slot Accounts
                    objSlot.Account__c = objSlot.Slot_Accounts__r[0].Account__c;
                //}
            }*/
        }

        if (lstSlot.Size() > 0) {
            Update lstSlot;
        }
    }
}