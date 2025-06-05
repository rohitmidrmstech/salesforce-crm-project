/* **********************************************************************************************************************************
* Class Name   : AssignedCredentialAccountTriggerHandler
* Description  : Class to to handle carry forward scenario on assigned credential account. So that both 
*				 Assigned credential account will be in sync.
* Author       : Rohit
* Modified On  : 25/11/2024
* Test Class   : AssignedCredentialAccountTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------

**************************************************************************************************************************************/
public class AssignedCredentialAccountTriggerHandler {
    @testvisible static Set<Id> credentailsSet = new Set<Id>();
    public static Id contactId;
    static Map<String, String> mapFromOtherClass;
    
    public static void updateQuantity(Map<Id, Assigned_Credential_Account__c> newMap, Map<Id, Assigned_Credential_Account__c> oldMap){
        try {
            Date currentYear = Date.newInstance(2025, 1, 1);
            mapFromOtherClass = TransactionJournalCreatorForRebateClaims.assignedCredentialWithContact;
            
            if (RevalidateRebateQuickActionController.assignedCredentialWithContact != null && !RevalidateRebateQuickActionController.assignedCredentialWithContact.isEmpty()) {
                mapFromOtherClass = RevalidateRebateQuickActionController.assignedCredentialWithContact;
            }
            
            Set<Id> contactIdSet = new Set<Id>();
            for (Id values : newMap.keySet()) {
                if (mapFromOtherClass != null && mapFromOtherClass.containsKey(values)) {
                    contactIdSet.add(mapFromOtherClass.get(values));
                }
            }
            
            List<RebateProgramMember> rMember = [
                SELECT Id, Contact__c, RebateProgram.Hard_Close_Date__c
                FROM RebateProgramMember
                WHERE Contact__c IN :contactIdSet
                AND RebateProgram.Program_Active_Year__c = :String.valueOf((currentYear.addYears(-1)).year())
            ];
            
            Map<Id, RebateProgramMember> rebateMemberWithContact = new Map<Id, RebateProgramMember>();
            for (RebateProgramMember rebateMember : rMember) {
                rebateMemberWithContact.put(rebateMember.Contact__c, rebateMember);
            }
            
            if (!rMember.isEmpty()) {
                updateTheQuantityForValidRecords(newMap, oldMap, rebateMemberWithContact);
            }
        } catch (Exception e) {
            System.debug('Error in updateQuantity: ' + e.getMessage());
        }
    }
    
    public static void updateTheQuantityForValidRecords(Map<Id, Assigned_Credential_Account__c> newMap,
                                                        Map<Id, Assigned_Credential_Account__c> oldMap,
                                                        Map<Id, RebateProgramMember> rebateMemberWithContact) 
    {
        try {
            Set<Id> accountIdSet = new Set<Id>();
            Map<String, Assigned_Credential_Account__c> accountCredMap = new Map<String, Assigned_Credential_Account__c>();
            Set<String> productCategory = new Set<String>();
            
            for (DefineProductLevel__mdt metadataRecord : [SELECT Id, Product_Category__c FROM DefineProductLevel__mdt WHERE Carry_Forward__c = true]) {
                if (metadataRecord.Product_Category__c != null) {
                    productCategory.add(metadataRecord.Product_Category__c.toUpperCase());
                }
            }
            
            for (Assigned_Credential_Account__c assignedCredObj : newMap.values()) {
                if (mapFromOtherClass != null && mapFromOtherClass.containsKey(assignedCredObj.Id) && 
                    rebateMemberWithContact != null && rebateMemberWithContact.containsKey(mapFromOtherClass.get(assignedCredObj.Id))) {
                        
                        RebateProgramMember rebateMember = rebateMemberWithContact.get(mapFromOtherClass.get(assignedCredObj.Id));
                        if (rebateMember.RebateProgram.Hard_Close_Date__c >= System.today() &&
                            assignedCredObj.Max_Payout_Quantity_Claimed__c != oldMap.get(assignedCredObj.Id).Max_Payout_Quantity_Claimed__c) {
                                
                                if (!credentailsSet.contains(assignedCredObj.Credential__c)) {
                                    accountCredMap.put(assignedCredObj.Account__c + assignedCredObj.Credential_Category__c, assignedCredObj);
                                    accountIdSet.add(assignedCredObj.Account__c);
                                    credentailsSet.add(assignedCredObj.Credential__c);
                                }
                            }
                    }
            }
            
            if (accountCredMap != null && !accountCredMap.isEmpty()) {
                updateTheQuantityInIncreaseOrder(accountCredMap, accountIdSet, productCategory);
            }
        } catch (Exception e) {
            System.debug('Error in updateTheQuantityForValidRecords: ' + e.getMessage());
        }
    }
    
    static void updateTheQuantityInIncreaseOrder(Map<String, Assigned_Credential_Account__c> newMap,
                                                 Set<Id> accountSet,
                                                 Set<String> productCategory) 
    {
        try {
            List<Assigned_Credential_Account__c> updateRecordList = new List<Assigned_Credential_Account__c>();
            
            for (Assigned_Credential_Account__c assignObj : [
                SELECT Id, Credential_Category__c, Account__c, Max_Payout_Quantity_Claimed__c
                FROM Assigned_Credential_Account__c
                WHERE Credential__c NOT IN :credentailsSet AND Account__c IN :accountSet
            ]) {
                if (productCategory.contains(assignObj.Credential_Category__c.toUpperCase())) {
                    if (newMap.containsKey(assignObj.Account__c + assignObj.Credential_Category__c)) {
                        Assigned_Credential_Account__c assignedObj = new Assigned_Credential_Account__c();
                        assignedObj.Id = assignObj.Id;
                        // Added below change by Rohit to Sync the Status between carry forward.
                        // assignedObj.Status__c = newMap.get(assignObj.Account__c + assignObj.Credential_Category__c).Status__c;
                        assignedObj.Max_Payout_Quantity_Claimed__c = newMap.get(assignObj.Account__c + assignObj.Credential_Category__c).Max_Payout_Quantity_Claimed__c;
                        updateRecordList.add(assignedObj);
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
    
    public static void insertTheQuantityForValid(Map<Id, Assigned_Credential_Account__c> newMap) {
        try {
            Set<Id> accountIdSet = new Set<Id>();
            Map<String, Assigned_Credential_Account__c> accountCredMap = new Map<String, Assigned_Credential_Account__c>();
            Set<String> productCategory = new Set<String>();
            
            for (DefineProductLevel__mdt metadataRecord : [SELECT Id, Product_Category__c FROM DefineProductLevel__mdt WHERE Carry_Forward__c = true]) {
                if (metadataRecord.Product_Category__c != null) {
                    productCategory.add(metadataRecord.Product_Category__c.toUpperCase());
                }
            }
            
            for (Assigned_Credential_Account__c assignedCredObj : newMap.values()) {
                if (!credentailsSet.contains(assignedCredObj.Credential__c)) {
                    accountCredMap.put(assignedCredObj.Account__c + assignedCredObj.Credential_Category__c, assignedCredObj);
                    accountIdSet.add(assignedCredObj.Account__c);
                    credentailsSet.add(assignedCredObj.Credential__c);
                }
            }
            
            if (accountCredMap != null && !accountCredMap.isEmpty()) {
                updateTheQuantityOnInsert(accountCredMap, accountIdSet, productCategory);
            }
        } catch (Exception e) {
            System.debug('Error in insertTheQuantityForValid: ' + e.getMessage());
        }
    }
    
    static void updateTheQuantityOnInsert(Map<String, Assigned_Credential_Account__c> newMap,
                                          Set<Id> accountSet,
                                          Set<String> productCategory) 
    {
        try {
            List<Assigned_Credential_Account__c> updateRecordList = new List<Assigned_Credential_Account__c>();
            
            for (Assigned_Credential_Account__c assignObj : [
                SELECT Id, Credential_Category__c, Account__c, Max_Payout_Quantity_Claimed__c
                FROM Assigned_Credential_Account__c
                WHERE Credential__c NOT IN :credentailsSet AND Account__c IN :accountSet
            ]) {
                if (productCategory.contains(assignObj.Credential_Category__c.toUpperCase())) {
                    if (newMap.containsKey(assignObj.Account__c + assignObj.Credential_Category__c)) {
                        Assigned_Credential_Account__c assignedObj = new Assigned_Credential_Account__c();
                        assignedObj.Id = newMap.get(assignObj.Account__c + assignObj.Credential_Category__c).Id;
                        assignedObj.Max_Payout_Quantity_Claimed__c = assignObj.Max_Payout_Quantity_Claimed__c;
                        updateRecordList.add(assignedObj);
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
    
}