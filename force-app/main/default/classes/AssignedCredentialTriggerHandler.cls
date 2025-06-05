/* **********************************************************************************************************************************
* Class Name   : AssignedCredentialTriggerHandler
* Description  : Class to to handle carry forward scenario on assigned credential. So that both 
*				 Assigned credential will be in sync.
* Author       : Rohit
* Modified On  : 25/11/2024
* Test Class   : TJCreatorForRebateClaimsTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------

**************************************************************************************************************************************/
public class AssignedCredentialTriggerHandler {
    static Set<Id> credentailsSet = new Set<Id>();
    public static void updateQuantity(Map<Id, Assigned_Credential__c> newMap, 
                                      Map<Id, Assigned_Credential__c> oldMap)
    {
        try {
            Set<Id> contactIdSet = new Set<Id>();
            Date currentYear = Date.newInstance(2025, 1, 1);
            for (Assigned_Credential__c acred : newMap.values()) {
                if (acred.Contact__c != null) {
                    contactIdSet.add(acred.Contact__c);
                }
            }
            
            if (!contactIdSet.isEmpty()) {
                List<RebateProgramMember> rMember = [
                    SELECT Id, Contact__c, RebateProgram.Hard_Close_Date__c 
                    FROM RebateProgramMember 
                    WHERE Contact__c IN :contactIdSet AND 
                    RebateProgram.Program_Active_Year__c = :String.valueOf((currentYear.addYears(-1)).year())
                ];
                
                Map<Id, RebateProgramMember> rebateMemberWithContact = new Map<Id, RebateProgramMember>();
                for (RebateProgramMember rebateMember : rMember) {
                    if (rebateMember.Contact__c != null) {
                        rebateMemberWithContact.put(rebateMember.Contact__c, rebateMember);
                    }
                }
                
                if (!rMember.isEmpty() && rMember.size() > 0) {
                    updateTheQuantityForValidRecords(newMap, oldMap, rebateMemberWithContact);
                }
            }
        } catch (Exception e) {
            System.debug('Error in updateQuantity: ' + e.getMessage());
        }
    }
    
    public static void updateTheQuantityForValidRecords(Map<Id, Assigned_Credential__c> newMap,
                                                        Map<Id, Assigned_Credential__c> oldMap,
                                                        Map<Id, RebateProgramMember> rebateMemberWithContact) 
    {
        try {
            Set<Id> contactIdSet = new Set<Id>();
            Map<String, Assigned_Credential__c> contactCredMap = new Map<String, Assigned_Credential__c>();
            Set<String> productCategory = new Set<String>();
            
            for (DefineProductLevel__mdt metadataRecord : [SELECT Id, Product_Category__c FROM DefineProductLevel__mdt WHERE Carry_Forward__c = true]) {
                if (metadataRecord.Product_Category__c != null) {
                    productCategory.add(metadataRecord.Product_Category__c.toUpperCase());
                }
            }
            
            for (Assigned_Credential__c assignedCredObj : newMap.values()) {
                if (rebateMemberWithContact.containsKey(assignedCredObj.Contact__c)) {
                    RebateProgramMember rebateMember = rebateMemberWithContact.get(assignedCredObj.Contact__c);
                    if (rebateMember != null && rebateMember.RebateProgram.Hard_Close_Date__c >= System.today()) {
                        Assigned_Credential__c oldCred = oldMap.get(assignedCredObj.Id);
                        if (oldCred != null && assignedCredObj.Max_Payout_Quantity_Claimed__c != oldCred.Max_Payout_Quantity_Claimed__c) {
                            if (!credentailsSet.contains(assignedCredObj.Credential__c)) {
                                contactCredMap.put(assignedCredObj.Contact__c + assignedCredObj.Credential_Category__c, assignedCredObj);
                                contactIdSet.add(assignedCredObj.Contact__c);
                                credentailsSet.add(assignedCredObj.Credential__c);
                            }
                        }
                    }
                }
            }
            
            if (!contactCredMap.isEmpty()) {
                updateTheQuantityInIncreaseOrder(contactCredMap, contactIdSet, productCategory);
            }
        } catch (Exception e) {
            System.debug('Error in updateTheQuantityForValidRecords: ' + e.getMessage());
        }
    }
    
    static void updateTheQuantityInIncreaseOrder(Map<String, Assigned_Credential__c> newMap,
                                                 Set<Id> contactIdSet,
                                                 Set<String> productCategory) 
    {
        try {
            List<Assigned_Credential__c> updateRecordList = new List<Assigned_Credential__c>();
            for (Assigned_Credential__c assignObj : [
                SELECT Id, Credential_Category__c, Contact__c, Max_Payout_Quantity_Claimed__c
                FROM Assigned_Credential__c
                WHERE Credential__c NOT IN :credentailsSet AND Contact__c IN :contactIdSet
            ]) {
                if (assignObj.Credential_Category__c != null &&
                    productCategory.contains(assignObj.Credential_Category__c.toUpperCase())) {
                        if (newMap.containsKey(assignObj.Contact__c + assignObj.Credential_Category__c)) {
                            Assigned_Credential__c assigndObj = new Assigned_Credential__c();
                            assigndObj.Id = assignObj.Id;
                            assigndObj.Max_Payout_Quantity_Claimed__c = newMap.get(assignObj.Contact__c + assignObj.Credential_Category__c).Max_Payout_Quantity_Claimed__c;
                            updateRecordList.add(assigndObj);
                        }
                    }
            }
            
            if (!updateRecordList.isEmpty()) {
                update updateRecordList;
            }
        } catch (Exception e) {
            System.debug('Error in updateTheQuantityInIncreaseOrder: ' + e.getMessage());
        }
    }
    
    public static void insertTheQuantityForValid(Map<Id, Assigned_Credential__c> newMap) 
    {
        try {
            Set<Id> contactIdSet = new Set<Id>();
            Map<String, Assigned_Credential__c> contactCredMap = new Map<String, Assigned_Credential__c>();
            Set<String> productCategory = new Set<String>();
            
            for (DefineProductLevel__mdt metadataRecord : [SELECT Id, Product_Category__c FROM DefineProductLevel__mdt WHERE Carry_Forward__c = true]) {
                if (metadataRecord.Product_Category__c != null) {
                    productCategory.add(metadataRecord.Product_Category__c.toUpperCase());
                }
            }
            
            for (Assigned_Credential__c assignedCredObj : newMap.values()) {
                if (!credentailsSet.contains(assignedCredObj.Credential__c)) {
                    contactCredMap.put(assignedCredObj.Contact__c + assignedCredObj.Credential_Category__c, assignedCredObj);
                    contactIdSet.add(assignedCredObj.Contact__c);
                    credentailsSet.add(assignedCredObj.Credential__c);
                }
            }
            
            if (!contactCredMap.isEmpty() && contactCredMap != null && contactIdSet!=null) {
                updateTheQuantityOnInsert(contactCredMap, contactIdSet, productCategory);
            }
        } catch (Exception e) {
            System.debug('Error in insertTheQuantityForValid: ' + e.getMessage());
        }
    }
    
    static void updateTheQuantityOnInsert(Map<String, Assigned_Credential__c> newMap,
                                          Set<Id> contactIdSet,
                                          Set<String> productCategory) 
    {
        try {
            List<Assigned_Credential__c> updateRecordList = new List<Assigned_Credential__c>();
            for (Assigned_Credential__c assignObj : [
                SELECT Id, Credential_Category__c, Contact__c, Max_Payout_Quantity_Claimed__c
                FROM Assigned_Credential__c
                WHERE Credential__c NOT IN :credentailsSet AND Contact__c IN :contactIdSet]) {
                    if (assignObj.Credential_Category__c != null &&
                        productCategory.contains(assignObj.Credential_Category__c.toUpperCase())) {
                            if (newMap.containsKey(assignObj.Contact__c + assignObj.Credential_Category__c)) {
                                Assigned_Credential__c assigndObj = new Assigned_Credential__c();
                                assigndObj.Id = newMap.get(assignObj.Contact__c + assignObj.Credential_Category__c).Id;
                                assigndObj.Max_Payout_Quantity_Claimed__c = assignObj.Max_Payout_Quantity_Claimed__c;
                                updateRecordList.add(assigndObj);
                            }
                        }
                }
            
            if (!updateRecordList.isEmpty()) {
                update updateRecordList;
            }
        } catch (Exception e) {
            System.debug('Error in updateTheQuantityOnInsert: ' + e.getMessage());
        }
    }
    public class DuplicateCheckQueueable implements Queueable {
        
        private List<Assigned_Credential__c> newList;
        
        public DuplicateCheckQueueable(List<Assigned_Credential__c> newList) {
            this.newList = newList;
        }
        
        public void execute(QueueableContext context) {
            Set<String> duplicateCheckSet = new Set<String>();
            Set<String> contactIdsSet = new Set<String>();
            set<string> accountsetid = new set<string>();
            List<Assigned_Credential__c> accList = new List<Assigned_Credential__c>();
            
            for (Assigned_Credential__c aca : newList) {
                if (aca.Contact__c != null) {
                    contactIdsSet.add(aca.Contact__c); 
                }
            }
            
            for (Assigned_Credential__c acc : [SELECT Id, Contact__c,Assigned_Credential_Account__c,Contact__r.AccountId, Credential__c FROM Assigned_Credential__c WHERE Contact__c IN :contactIdsSet]) {
                
                if (acc.Contact__c != null && acc.Credential__c != null) {
                    
                    String uniqueKey = acc.Contact__c + '' + acc.Credential__c;
                    system.debug('acc.Assigned_Credential_Account__c'+acc.Assigned_Credential_Account__c);
                    if(acc.Assigned_Credential_Account__c != null){
                        accountsetid.add(acc.Contact__r.AccountId);
                    }
                    if (duplicateCheckSet.contains(uniqueKey)) {
                        accList.add(acc); 
                        System.debug('Duplicate Found: ' + acc);
                    } else {
                        duplicateCheckSet.add(uniqueKey);
                        System.debug('Added to Set: ' + uniqueKey);
                    }
                }
            }
            system.debug('accountsetid==='+accountsetid);
            if (!accList.isEmpty()) {
                System.debug('Deleting duplicate records: ' + accList);
                delete accList;
            }
            list<Assigned_Credential_Account__c> acalist = new list<Assigned_Credential_Account__c>();
            for (Assigned_Credential_Account__c acc : [SELECT Id, Account__c, Credential__c FROM Assigned_Credential_Account__c WHERE Account__c IN :accountsetid]) {
                if (acc.Account__c != null && acc.Credential__c != null) {
                    if (duplicateCheckSet.contains(acc.Account__c + '' + acc.Credential__c)) {
                        acalist.add(acc);
                        System.debug('acalist === ' + acalist);
                    } else {
                        duplicateCheckSet.add(acc.Account__c + '' + acc.Credential__c);
                        System.debug('duplicateCheckSet === ' + duplicateCheckSet);
                    }
                }
            }
            if (acalist.size() > 0) {
                System.debug('Deleting duplicate records: ' + acalist);
                delete acalist;
            }
        }
    }
}