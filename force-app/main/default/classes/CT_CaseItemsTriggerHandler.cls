/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Case order items Trigger Handler class
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Deepak Regala (dregala@liquidhub.com)
* @version        1.0
* @created        2017-06-22
*/
public class CT_CaseItemsTriggerHandler {
     
    /* After Update Handler function for the case order item trigger.
     * @param - updatedCaseItemsList, updatedCaseItemMap
     * @description - This function will check if the IS__c field has been updated
     * If the field has been updated and it is checked it creates an issue record for that case item. 
     * If the field is unchecked it deletes the issue record for that case item.
     */
    public static void afterUpdateHandler(List<Case_Order_Items__c> updatedCaseItemsList, Map<Id,Case_Order_Items__c> updatedCaseItemMap) {
        
        // variables declaration
        List<Issues__c> issuesToInsert = new List<Issues__c>();
        List<Issues__c> issuesToDelete = new List<Issues__c>();
        List<Issues__c> creditsToDelete = new List<Issues__c>();
        List<Issues__c> rebillsToDelete = new List<Issues__c>();
        List<Issues__c> recordsToDelete = new List<Issues__c>();
        Map<String, List<String>> iscrbMap = new Map<String, List<String>>();
        Set<Id> caseItemIds = new Set<Id>();
        List<Database.SaveResult> insertResult;
        List<Database.DeleteResult> deleteResult;
        String status = '';
        String issueRecTypId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Issues').getRecordTypeId();
        String creditRecTypId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Credit').getRecordTypeId();
        String rebillRecTypId = Schema.SObjectType.Issues__c.getRecordTypeInfosByName().get('Rebill').getRecordTypeId();
        String pricingRecTypId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Pricing').getRecordTypeId();
        String qualityRecTypId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Quality').getRecordTypeId();
        String serviceRecTypId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        System.debug(issueRecTypId + ' ' + creditRecTypId + ' ' + rebillRecTypId);
        System.debug('updatedCaseItemMap ' + updatedCaseItemMap);
        
        List<Case_Order_Items__c> filteredCaseItemsList = [SELECT Id, Name, Available_Quantity__c, CR__c, IS__c, RB__c, Case__c, Case__r.RecordTypeId,
                                                           Product__c, Product_Price__c, Product__r.Name, Product__r.Stocking_to_Selling_Conversion_Factor__c, Quantity__c, 
                                                           Total_Price__c, Unit_Price__c, Price_Uom__c, Qty_Uom__c, Discount_Percentage__c
                                                           FROM Case_Order_Items__c
                                                           WHERE Id in :updatedCaseItemsList];
        
        for(Case_Order_Items__c coditm : filteredCaseItemsList){
            System.debug('coditm ' + coditm);
            // Type Issues
            if(coditm.IS__c != updatedCaseItemMap.get(coditm.Id).IS__c) {
                if(coditm.IS__c){
                    Issues__c issue = new Issues__c();
                    issue.Case__c = coditm.Case__c;
                    issue.Case_Order_Item__c = coditm.Id;
                    issue.RecordTypeId = issueRecTypId;
                    issue.Inserted_From_Trigger__c = true;
                    issue.Product__c = coditm.Product__c;
                    issuesToInsert.add(issue);
                }else if(!coditm.IS__c){
                    if(iscrbMap.get(issueRecTypId) == null){
                        List<String> ciIssuesIds = new List<String>();
                        ciIssuesIds.add(coditm.Id);
                        iscrbMap.put(issueRecTypId, ciIssuesIds);
                    }else{
                        List<String> ciIssuesIds = iscrbMap.get(issueRecTypId);
                        ciIssuesIds.add(coditm.Id);
                        iscrbMap.put(issueRecTypId, ciIssuesIds);
                    } 
                }
            }
            
            // Type Credit
            if(coditm.CR__c != updatedCaseItemMap.get(coditm.Id).CR__c) {
                if(coditm.CR__c){
                    Decimal quantity;
                    Decimal extendQty;                    
                    Decimal extendAmt;
                    if (coditm.Case__r.RecordTypeId == pricingRecTypId || coditm.Case__r.RecordTypeId == qualityRecTypId || coditm.Case__r.RecordTypeId == serviceRecTypId) {
                        quantity = -(coditm.Quantity__c!=null ? coditm.Quantity__c: 1.00);
                        extendQty = Math.abs((coditm.Product__r.Stocking_to_Selling_Conversion_Factor__c != null ? coditm.Product__r.Stocking_to_Selling_Conversion_Factor__c : 1) * quantity);
                       /*shashi Changes*/
                       // extendQty = Math.abs((coditm.Product__r.MSF_MS_Conversion_backup2__c != null ? coditm.Product__r.MSF_MS_Conversion_backup2__c : 1) * quantity);
                        System.debug('fieldss '+coditm.Quantity__c+' '+coditm.Product__r.Stocking_to_Selling_Conversion_Factor__c);
                        //System.debug('fieldss '+coditm.Quantity__c+' '+coditm.Product__r.MSF_MS_Conversion_backup2__c);
                        
                        System.debug('extendQtyy '+extendQty);
                        Decimal price = coditm.Product_Price__c != null ? coditm.Product_Price__c : 0.00;
                        Decimal discount = coditm.Discount_Percentage__c != null ? coditm.Discount_Percentage__c : 0.00;
                        Decimal discountFactor = (1 - (discount/100));
                        extendAmt = -(Math.abs(price * discountFactor * extendQty));
                    } else {
                        quantity = -(coditm.Quantity__c!=null ? coditm.Quantity__c: 0.00);
                        extendQty = (coditm.Available_Quantity__c==null)?1:coditm.Available_Quantity__c;
                        extendAmt = -(coditm.Total_Price__c != null ? coditm.Total_Price__c : 0.00);
                    }
                    System.debug('extendQtyy '+extendQty);
                    Issues__c issue = new Issues__c();
                    issue.Case__c = coditm.Case__c;
                    issue.Case_Order_Item__c = coditm.Id;
                    issue.RecordTypeId = creditRecTypId;
                    issue.Inserted_From_Trigger__c = true;
                    issue.Ext_Qty_Conversion__c = Math.abs(((Decimal) extendQty / quantity).setScale(4));  // ABS VALUE

                    issue.Product__c = coditm.Product__c;

                    issue.QTY_ORD__c = quantity;
                    issue.UOM__c = coditm.Qty_Uom__c;
                    issue.EXT_QTY__c = extendQty;
                    issue.UOM2__c = coditm.Price_Uom__c;
                    issue.UNIT_PRICE__c = coditm.Unit_Price__c;

                    issue.EXT_AMOUNT__c = (coditm.Total_Price__c!=null?coditm.Total_Price__c:0.00); // NOTICE this is Ext Amount 2 non negative
                    // -----------------------------------
                    issue.QTY__c = quantity;
                    issue.PRC__c = coditm.Product_Price__c!=null? coditm.Product_Price__c: 0.00;
                    if (coditm.Discount_Percentage__c!=null && coditm.Discount_Percentage__c>0 ) issue.Discount__c = coditm.Discount_Percentage__c;
                    issue.EXT_AMOUNT2__c = extendAmt; // NEGATING VALUE
                    
                    issuesToInsert.add(issue);

                }else if(!coditm.CR__c){
                    if(iscrbMap.get(creditRecTypId) == null){
                        List<String> ciIssuesIds = new List<String>();
                        ciIssuesIds.add(coditm.Id);
                        iscrbMap.put(creditRecTypId, ciIssuesIds);
                    }else{
                        List<String> ciIssuesIds = iscrbMap.get(creditRecTypId);
                        ciIssuesIds.add(coditm.Id);
                        iscrbMap.put(creditRecTypId, ciIssuesIds);
                    }  
                }
            }
            
            // Type Rebill
            if(coditm.RB__c != updatedCaseItemMap.get(coditm.Id).RB__c) {
                if(coditm.RB__c){
                    Decimal quantity;
                    Decimal extendQty;                    
                    Decimal extendAmt;
                    if (coditm.Case__r.RecordTypeId == pricingRecTypId || coditm.Case__r.RecordTypeId == qualityRecTypId || coditm.Case__r.RecordTypeId == serviceRecTypId) {
                        quantity = (coditm.Quantity__c!=null ? coditm.Quantity__c: 1.00);
                       
                        extendQty = Math.abs((coditm.Product__r.Stocking_to_Selling_Conversion_Factor__c != null ? coditm.Product__r.Stocking_to_Selling_Conversion_Factor__c : 1) * quantity);
                       /*shashi changes*/
                       //extendQty = Math.abs((coditm.Product__r.MSF_MS_Conversion_backup2__c != null ? coditm.Product__r.MSF_MS_Conversion_backup2__c : 1) * quantity);
                       
                        Decimal price = coditm.Product_Price__c != null ? coditm.Product_Price__c : 0.00;
                        Decimal discount = coditm.Discount_Percentage__c != null ? coditm.Discount_Percentage__c : 0.00;
                        Decimal discountFactor = (1 - (discount/100));
                        extendAmt = (Math.abs(price * discountFactor * extendQty));
                    } else {
                        quantity = coditm.Quantity__c!=null? coditm.Quantity__c: 0.00;
                        extendQty = (coditm.Available_Quantity__c==null)?1:coditm.Available_Quantity__c;
                        extendAmt = coditm.Total_Price__c;
                    }
                    
                    Issues__c issue = new Issues__c();
                    issue.Case__c = coditm.Case__c;
                    issue.Case_Order_Item__c = coditm.Id;
                    issue.RecordTypeId = rebillRecTypId;
                    issue.Inserted_From_Trigger__c = true;
                    issue.Ext_Qty_Conversion__c = Math.abs(((Decimal)extendQty / quantity).setScale(4));
                    
                    issue.Product__c = coditm.Product__c;
                    
                    issue.QTY_ORD__c = quantity;
                    issue.UOM__c = coditm.Qty_Uom__c;
                    issue.EXT_QTY__c = extendQty;
                    issue.UOM2__c = coditm.Price_Uom__c;
                    issue.UNIT_PRICE__c = coditm.Unit_Price__c;
                    
                    issue.EXT_AMOUNT__c = coditm.Total_Price__c;
                    // -----------------------------------
                    issue.QTY__c = quantity;
                    issue.PRC__c = coditm.Product_Price__c!=null? coditm.Product_Price__c: 0.00;
                    if (coditm.Discount_Percentage__c!=null && coditm.Discount_Percentage__c>0 ) issue.Discount__c = coditm.Discount_Percentage__c;
                    issue.EXT_AMOUNT2__c = extendAmt;

                    issuesToInsert.add(issue);

                }else if(!coditm.RB__c){
                    if(iscrbMap.get(rebillRecTypId) == null){
                        List<String> ciIssuesIds = new List<String>();
                        ciIssuesIds.add(coditm.Id);
                        iscrbMap.put(rebillRecTypId, ciIssuesIds);
                    }else{
                        List<String> ciIssuesIds = iscrbMap.get(rebillRecTypId);
                        ciIssuesIds.add(coditm.Id);
                        iscrbMap.put(rebillRecTypId, ciIssuesIds);
                    }     
                }
            }
        }
        
        if(!issuesToInsert.isEmpty()){
            insertResult = Database.insert(issuesToInsert);
        }
        
        System.debug('iscrbMap ' + iscrbMap);
        
        if(iscrbMap.get(issueRecTypId) != null){
            issuesToDelete = [SELECT Id FROM Issues__c WHERE Case_Order_Item__c IN :iscrbMap.get(issueRecTypId) AND RecordTypeId = :issueRecTypId];
            recordsToDelete.addAll(issuesToDelete);
        }
        if(iscrbMap.get(creditRecTypId) != null){
            creditsToDelete = [SELECT Id FROM Issues__c WHERE Case_Order_Item__c IN :iscrbMap.get(creditRecTypId) AND RecordTypeId = :creditRecTypId];
            recordsToDelete.addAll(creditsToDelete);
        }
        if(iscrbMap.get(rebillRecTypId) != null){
            rebillsToDelete = [SELECT Id FROM Issues__c WHERE Case_Order_Item__c IN :iscrbMap.get(rebillRecTypId) AND RecordTypeId = :rebillRecTypId];
            recordsToDelete.addAll(rebillsToDelete);
        }
        
        System.debug('recordsToDelete ' + recordsToDelete);
        
        if(!recordsToDelete.isEmpty()){
            deleteResult = Database.delete(recordsToDelete);
        }
        
    }
    
}