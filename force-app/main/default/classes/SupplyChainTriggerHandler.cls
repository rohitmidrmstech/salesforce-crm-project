public class SupplyChainTriggerHandler {
    static String mtoRecordTypeId = Schema.SObjectType.Supply_Chain__c.getRecordTypeInfosByDeveloperName().get('New_MTO_SS_Request').getRecordTypeId();
    
    public static void beforeInsert(List<Supply_Chain__c> newMTOList) {
        List<Supply_Chain__c> filteredMTO = new List<Supply_Chain__c>();
        
        for (Supply_Chain__c supChain : newMTOList) {
            if (supChain.RecordTypeId == mtoRecordTypeId) {
                filteredMTO.add(supChain);
            }
        }
        if (!filteredMTO.isEmpty()) {
        updateRepeatMTO(filteredMTO,null,true);
        }
    }
    
    public static void beforeUpdate(List<Supply_Chain__c> newMTOList, Map<Id, Supply_Chain__c> oldMTOMap) {
        List<Supply_Chain__c> filteredMTO = new List<Supply_Chain__c>();
        
        for (Supply_Chain__c supChain : newMTOList) {
            if (supChain.RecordTypeId == mtoRecordTypeId
                && (supChain.Account__c != oldMTOMap.get(supChain.Id).Account__c
                    || supChain.Product__c != oldMTOMap.get(supChain.Id).Product__c)) {
                filteredMTO.add(supChain);
            }
        }
        if (!filteredMTO.isEmpty()) {
            updateRepeatMTO(filteredMTO,oldMTOMap,false);
        }
    }
    
    public static void updateRepeatMTO(List<Supply_Chain__c> newMTOList, Map<Id, Supply_Chain__c> oldMTO, boolean isInsert) {
        Date lastYearDate = System.today().addYears(-1);
        Set<String> accountIdSet = new Set<String>();
        Set<String> productIdSet = new Set<String>();
        Set<String> warehouseIdSet = new Set<String>();
        Set<String> filteredProductIdSet = new Set<String>();
        Map<String, Account> filteredAccountMap = new Map<String, Account>();
        /* ware house replacing with plant for IPG Full*/
        Map<String, Plants__c> filteredWarehouseMap = new Map<String, Plants__c>();
        MTO_Process__c mtoCS = MTO_Process__c.getOrgDefaults();
        User u = [Select Sales_Administrator__c from User where id=:UserInfo.getUserId()];
        
        for (Supply_Chain__c supChain : newMTOList) {
            if (String.isNotBlank(supChain.Account__c)) {
                accountIdSet.add(supChain.Account__c);
            }
            if (String.isNotBlank(supChain.Manufacturing_Location__c)) {
                warehouseIdSet.add(supChain.Manufacturing_Location__c);
            }
            if (String.isNotBlank(supChain.Product__c) ) {
                productIdSet.add(supChain.Product__c);
            }
        }
            for (Account acc : [SELECT Name,OwnerId, Id
                                FROM Account 
                                WHERE Id IN :accountIdSet]) {
                                //AND CreatedDate > :lastYearDate]) {
                                    filteredAccountMap.put(acc.Id, acc);
                              system.debug('acc.Id'+ acc.Id);
                                }
        
            for (Plants__c  w : [SELECT  Plant_Manager__c,Plant_Controller__c, Id
                                FROM Plants__c  
                                 WHERE Id IN :warehouseIdSet]){
                               // AND CreatedDate > :lastYearDate]) {
                                    filteredWarehouseMap.put(w.Id, w);
                                }
        
            for (Supply_Chain__c supChain1 : [SELECT Name, Account__c, MTO_Type__c, Product__c, Pricing_Admin__c,
                                              Account__r.OwnerId, Manufacturing_Location__r.Plant_Manager__c
                                              FROM Supply_Chain__c 
                                              WHERE Account__c IN :accountIdSet
                                              AND Product__c IN :productIdSet
                                              AND CreatedDate > :lastYearDate]) {
                                                  filteredProductIdSet.add(supChain1.Product__c);
                                                  filteredAccountMap.put(supChain1.Account__c, supChain1.Account__r);
                                              }
      
        for (Supply_Chain__c supChain : newMTOList) {
            if(filteredWarehouseMap.containsKey(supChain.Manufacturing_Location__c)){
               if (filteredWarehouseMap.get(supChain.Manufacturing_Location__c).Plant_Manager__c != null) {
               
                    //supChain.Plant_Controller__c = filteredWarehouseMap.get(supChain.Manufacturing_Location__c).Plant_Manager__c;
                    // Updated Code as per CHG1055112 
                    supChain.Plant_Controller__c = filteredWarehouseMap.get(supChain.Manufacturing_Location__c).Plant_Controller__c;
                    system.debug('@@@@@supChain.Plant_Controller__c ++++'+supChain.Plant_Controller__c);
                    
                }
            }
           If (filteredProductIdSet.contains(supChain.Product__c) && filteredAccountMap.containsKey(supChain.Account__c)) {
                supChain.Same_Customer__c = true;
            }
            if (filteredAccountMap.containsKey(supChain.Account__c)) {
                
                supChain.Territory_Manager__c = filteredAccountMap.get(supChain.Account__c).OwnerId;
                system.debug('supChain.Territory_Manager__c'+supChain.Territory_Manager__c);
            }
            if (supChain.SBU_Group__c != null && supChain.SBU_Group__c == 'Technical') {
                supChain.Product_Manager__c = mtoCS.Technical_PM_Id__c;
            } else if (supChain.SBU_Group__c != null && supChain.SBU_Group__c == 'Residential') {
                supChain.Product_Manager__c = mtoCS.Residential_PM_Id__c;
            } else if (supChain.SBU_Group__c != null && supChain.SBU_Group__c == 'Canadian Residential') {
                supChain.Product_Manager__c = mtoCS.Canadian_Residential_Id__c;
            } else if (supChain.SBU_Group__c != null && supChain.SBU_Group__c == 'Canadian Technical') {
                supChain.Product_Manager__c = mtoCS.Canadian_Technical_Id__c;
            } else if (supChain.SBU_Group__c != null && supChain.SBU_Group__c == 'Duct Wrap') {
                supChain.Product_Manager__c = mtoCS.Duct_Wrap_Id__c;
            } else if (supChain.SBU_Group__c != null && supChain.SBU_Group__c == 'Loosefill') {
                supChain.Product_Manager__c = mtoCS.Loosefill_Id__c;
            } else if (supChain.SBU_Group__c != null && supChain.SBU_Group__c == 'MBI') {
                supChain.Product_Manager__c = mtoCS.MBI_Id__c;
            }
          
            if (supChain.MTO_Type__c == 'Repeat' && (supChain.Pricing_Admin__c == null || (oldMTO != null && supChain.Pricing_Admin__c != oldMTO.get(supChain.Id).Pricing_Admin__c))) {
                    
                    supChain.Pricing_Admin__c = u.Sales_Administrator__c;
            }
        }
    }
}