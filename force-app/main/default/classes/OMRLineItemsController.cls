/**
    Name        : OMRLineItemsController
    Date        : 21 January 2020
    Author      : 
    Description : This is the parent window when ever an user click on Lookup button then open child window Using JS Code.
                  Here we have 'addRow' button that create an row dynamically.
                  setSelectedProduct method set the selected lookup value.
**/
public class OMRLineItemsController{
    public Integer indexNum{get;set;}
    public String productId{get;set;}
    public String caseId{get;set;}
    public Case caseRecord{get;set;}
    public String whatAction{get;set;}
    public List<OMRItemWrapper> wrapperList{get;set;}
    public OMRLineItemsController(ApexPages.StandardController ctrl){
        caseId = ApexPages.CurrentPage().getparameters().get('id');
        caseRecord = [SELECT Id, CaseNumber, Type, Subject FROM Case WHERE Id =: caseId];
        wrapperList = new List<OMRItemWrapper>();
    }
    
    // This code add one row in table means we add one instaint in list.
    public void addRow(){
        wrapperList.add(new OMRItemWrapper(new Product2(), new Order_Mgmt_Request_Item__c(Invoice__c = 0, Suggested__c = 0), false));
    }
    
    // This code update the Order_Mgmt_Request_Item__c object value.
    public void setSelectedProduct(){
        System.debug('@@@productId@@@'+productId);
        if(String.isNotBlank(productId)){
            List<Product2> productList = [SELECT Id, Name, ProductCode, Description, Item_Class__c, Item_Class_Description__c FROM Product2 WHERE Id =: productId];
            system.debug('@@@productList@@@'+productList);
            if(productList.size() > 0){
                List<Order_Mgmt_Request_Item__c> omrList = [SELECT Id, Promo_No__c, OM_Request__c, Warehouse_Acpt__c, Warehouse_Rec_d__c, Invoice__c, Suggested__c, Quantity__c FROM Order_Mgmt_Request_Item__c WHERE Item__c =: productId];
                system.debug('@@@omrList@@@'+omrList);
                  system.debug('@@@omrListSize@@@'+omrList.size());
                if(omrList.size() > 0){
                    wrapperList.get(indexNum).omrRecord = omrList[0];
                }
                wrapperList.get(indexNum).productRecord = productList[0];
            }
        }
    }
    
    // When Click On Save Button Excute This Method
    public void saveRecords(){
        List<Order_Mgmt_Request_Item__c> omrItemListForUpsert = new List<Order_Mgmt_Request_Item__c>();
        List<Order_Mgmt_Request_Item__c> omrItemListForDelete = new List<Order_Mgmt_Request_Item__c>();
        List<OMRItemWrapper> cloneWrapperList = new List<OMRItemWrapper>();
        // Copy the list
        cloneWrapperList.addAll(wrapperList);
        System.debug('@@@wrapperList@@@'+wrapperList);
        Integer idx = 0;
        for(OMRItemWrapper record : cloneWrapperList){
            if(String.isNotBlank(record.productRecord.Id)){
                // Checkbox uncheck then execute this method
                if(record.isDelete == false){
                    Order_Mgmt_Request_Item__c omrItem = record.omrRecord;
                    omrItem.Item__c = record.productRecord.Id;
                    if(String.isBlank(omrItem.OM_Request__c)){
                        omrItem.OM_Request__c = caseId;
                    }
                    omrItemListForUpsert.add(omrItem);
                }// Child Record Already Save Then execute this block.
                else if(String.isNotBlank(record.omrRecord.Id)){
                    omrItemListForDelete.add(new Order_Mgmt_Request_Item__c(id = record.omrRecord.Id));
                    wrapperList.remove(idx);
                    idx--;
                }// If Child Record Not Have id and Checkbox value checked then excute.
                else if(record.isDelete == true){
                    wrapperList.remove(idx);
                    idx--;
                }
            }// If User not Select Lookup And Checked on check box then excute this block;
            else if(record.isDelete == true){
                wrapperList.remove(idx);
                idx--;
            }
            idx++;
        }
        if(omrItemListForUpsert.size() > 0){
            UPSERT omrItemListForUpsert;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Update Successfully'));
        }
        if(omrItemListForDelete.size() > 0){
            DELETE omrItemListForDelete;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Update Successfully'));
        }
        //ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Update Successfully'));
        
    }
    
    public class OMRItemWrapper{
        public Product2 productRecord{get;set;}
        public Boolean isDelete{get;set;}
        public Order_Mgmt_Request_Item__c omrRecord{get;set;}
        public OMRItemWrapper(Product2 productRecord, Order_Mgmt_Request_Item__c omrRecord, Boolean isDelete){
            this.omrRecord = omrRecord;
            this.productRecord = productRecord;
            this.isDelete = isDelete;
        }
    }
}