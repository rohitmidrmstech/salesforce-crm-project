/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Controller class for Case Item related list lightning component. 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Deepak Regala (dregala@liquidhub.com)
* @verstion       1.0
* @created        2017-06-14
*/
public with sharing class CT_CaseItemController {
    
    /* Function to return list of case order items.
* @param - parent case Id that case items refer to. 
* @return - Map of Case Item Id and CaseOrderItem.
* @description - This function will return the case item related to the cases.
*/
    @AuraEnabled
    public static Map<String, CaseOrderItem> fetchCaseItemsData(String caseId) {
        
        // variable declaration
        List<CaseOrderItem> listOfCaseItems = new List<CaseOrderItem>();
        Map<String, CaseOrderItem> caseItemsMap = new Map<String, CaseOrderItem>();
        
        // build query on Case_Order_Items__c
        // removed Item_Status__c, 
        String caseItemsQuery = ' SELECT Name, Available_Quantity__c, CR__c, IS__c, Order_num__c, Order__c, Order__r.Name, ' + 
                                		' Product__c, Inserted_From_Trigger__c, Product__r.Name,Qty_Ordered__c, Quantity__c, RB__c, Discount_Percentage__c, ' + 
                                        ' Total_Price__c, Unit_Price__c, Price_Uom__c, Qty_Uom__c, Product__r.CORP_CLASS__c, Product_Code__c ' +
                                ' FROM Case_Order_Items__c ';
        if(String.isNotBlank(caseId)){
            caseItemsQuery += ' WHERE Case__c = :caseId ';
        }
        for(Case_Order_Items__c caseItem : Database.query(caseItemsQuery)){
            system.debug('order Name'+caseItem.Order__r.Name);
            listOfCaseItems.add(new CaseOrderItem(caseItem));
            caseItemsMap.put(caseItem.Id, new CaseOrderItem(caseItem));
        }
        
        return caseItemsMap;
    }
    
    /* Function to update case order item.
* @param - case order item record. 
* @return - status of the dml operation.
* @description - This function will update the case item information.
*/
    @AuraEnabled
    public static String updateCaseOrderItems(String caseItemsJson) {
        system.debug('caseITemsJson'+ caseItemsJson);
        String status = '';
        Database.SaveResult result;
        CaseOrderItem caseItm = (CaseOrderItem)JSON.deserialize(caseItemsJson, CaseOrderItem.class);
        
        // Create Case_Order_Items__c object with provided record Id to update.
        Case_Order_Items__c c = new Case_Order_Items__c(Id = caseItm.itemId);
        if(caseItm.quantity != null)
            c.Quantity__c = Decimal.valueOf(caseItm.quantity);
        c.CR__c = caseItm.itemCR;
        c.IS__c = caseItm.itemIS;
        c.RB__c = caseItm.itemRB;
        c.Product__c = caseItm.productId;
        c.Unit_Price__c = (caseItm.unitPrice != null) ? Decimal.valueOf(caseItm.unitPrice) : null;
        c.Total_Price__c = (caseItm.totalPrice != null) ? Decimal.valueOf(caseItm.totalPrice) : null;
        
        // Update operation for Case_Order_Items__c
        result = Database.update(c);
        
        if(result.isSuccess()){
            status = 'Success';
        }else{
            for(Database.Error err : result.getErrors()){
                status += err.getStatusCode() + ': ' + err.getMessage();
                status += '\n The following error has occurred. \n Case Item fields that affected this error: ' + err.getFields();
            }
        }
        return status;
    }
    
    @AuraEnabled
    public static CaseWrapper getCaseDetails(String caseId){
        CaseWrapper casewrap = new CaseWrapper();
        system.debug('acalled apex method');
        casewrap.currentCase = [Select id,CaseNumber,Status,RecordType.Name from Case Where Id=: caseId Limit 1];
        casewrap.profileName = getUserProfileName();
        casewrap.groupNames = new List<String>();
        List<GroupMember> gNames = [SELECT Id, Group.Type, Group.Name from GroupMember Where UserOrGroupId = :UserInfo.getUserId() AND Group.Type = 'Regular'];
        if(gNames.size() > 0){
            for(GroupMember gn : gNames){
                casewrap.groupNames.add(gn.Group.Name);
            }
            
        }
        system.debug('cs returned'+casewrap);
        system.debug('cs returned Group Name'+casewrap.groupNames);
        return casewrap;
    }
    
    public static String getUserProfileName(){
        return [SELECT Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
    }
    
    /* Function to updates list of case order items.
* @param - list of case order items. 
* @return - status of the dml operation.
* @description - This function will update the case item information.
*/
    @AuraEnabled
    public static String updateCaseOrderItemList(String caseItemsListJson) {
        system.debug('caseItemsJsonList'+caseItemsListJson);
        List<Case_Order_Items__c> caseOrderItemsList = new List<Case_Order_Items__c>();
        List<CaseOrderItem> caseItmlist = (List<CaseOrderItem>)JSON.deserialize(caseItemsListJson, List<CaseOrderItem>.class);
       
        for(CaseOrderItem caseitem : caseItmlist){
            Case_Order_Items__c c = new Case_Order_Items__c(Id = caseitem.itemId);
            if(caseitem.quantity != null)
                c.Quantity__c = Decimal.valueOf(caseitem.quantity);
            c.CR__c = caseitem.itemCR;
            c.IS__c = caseitem.itemIS;
            c.RB__c = caseitem.itemRB;
            c.Product__c = caseitem.productId;
            c.Unit_Price__c = (caseitem.unitPrice != null) ? Decimal.valueOf(caseitem.unitPrice) : null;
            c.Total_Price__c = (caseitem.totalPrice != null) ? Decimal.valueOf(caseitem.totalPrice) : null;
            caseOrderItemsList.add(c);
        }
        System.debug(caseItmlist);
        
        update caseOrderItemsList;
        
        return 'Success';
    }
    
    // Wrapper Class 
    // 		- constructs a case order item object.
    public class CaseOrderItem {
        
        @AuraEnabled public Boolean isEdit;
        @AuraEnabled public Boolean isSave;
        @AuraEnabled public String itemId;
        @AuraEnabled public String itemName;
        @AuraEnabled public Boolean itemCR;
        @AuraEnabled public BOOlean itemIS;
        @AuraEnabled public BOOlean itemRB;
        @AuraEnabled public String orderName;
        @AuraEnabled public String productCode;
        @AuraEnabled public String productName;
        @AuraEnabled public String productId;
        @AuraEnabled public String unitPrice;
        @AuraEnabled public String uomPrice;
        @AuraEnabled public String uomQuantity;
        @AuraEnabled public String quantity;
        @AuraEnabled public String quantityAvailable;
        @AuraEnabled public String totalPrice;
        @AuraEnabled public Boolean insertedFromTrigger;
        
        public CaseOrderItem(Case_Order_Items__c caseItem){
            this.isEdit = false;
            this.isSave = true;
            this.itemId = caseItem.Id;
            this.itemName = caseItem.Name;
            this.itemCR = caseItem.CR__c;
            this.itemIS = caseItem.IS__c;
            this.itemRB = caseItem.RB__c;
            this.insertedFromTrigger = caseItem.Inserted_From_Trigger__c;
            this.orderName = caseItem.Order__r.Name;
            this.productCode = caseItem.Product_Code__c;
            this.productName = caseItem.Product__r.Name;
            this.productId = caseItem.Product__c;

            Decimal unitPrice = caseItem.Unit_Price__c;
            if (unitPrice!=null) unitPrice = unitPrice.setScale(2);
            this.unitPrice = String.valueOf(unitPrice);

            this.uomPrice = caseItem.Price_Uom__c;
            this.uomQuantity = caseItem.Qty_Uom__c;
            this.quantity = String.valueOf(caseItem.Quantity__c);
            this.quantityAvailable = String.valueOf(caseItem.Available_Quantity__c);
            this.totalPrice = String.valueOf(caseItem.Total_Price__c);
        }
    }
    
    public class CaseWrapper{
        @AuraEnabled public Case currentCase;
        @AuraEnabled public String profileName;
        @AuraEnabled public List<String> groupNames;
    }
}