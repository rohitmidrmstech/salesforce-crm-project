public class CT_NoChargeSalesAdjustmentController {
    //99, 100, 106-9, 
    @AuraEnabled
    public static void addSalesAgjustment(Sales_Adjustment_No_Charge__c newSalesAdjustment) {
        insert newSalesAdjustment;
    }
    
    
    @AuraEnabled
    public static void updateSalesAdjustments(String newSalesAdjustments) {
        
        List<SalesAdjustmentNoChargeItem> updatedAdjustments = 
            (List<SalesAdjustmentNoChargeItem>)JSON.deserialize(newSalesAdjustments, List<SalesAdjustmentNoChargeItem>.class);
        List<Sales_Adjustment_No_Charge__c> updatedSObjects = new List<Sales_Adjustment_No_Charge__c>();
        Map<Id,Decimal> productIdToMSFConversionMap = new Map<Id,Decimal>();
        Set<String> productIdSet = new Set<String>();
        
        for(SalesAdjustmentNoChargeItem updatedAdjustment : updatedAdjustments){
            productIdSet.add(updatedAdjustment.productId);
        }
        
         productIdToMSFConversionMap = getProductDetails(productIdSet);
       
        for(SalesAdjustmentNoChargeItem updatedAdjustment : updatedAdjustments) {
            
            Sales_Adjustment_No_Charge__c updatedSObject = new Sales_Adjustment_No_Charge__c();
            if(String.isNotBlank(updatedAdjustment.recordId) && String.valueOf(updatedAdjustment.recordId).length() >= 15)
                updatedSObject.Id = updatedAdjustment.recordId;
            
            updatedSObject.Material_Number__c = updatedAdjustment.materialNumber;
            updatedSObject.Price__c = String.isNotBlank(updatedAdjustment.price) ? Decimal.valueOf(updatedAdjustment.price):0.00;
            updatedSObject.Quantity__c = String.isNotBlank(updatedAdjustment.quantity) ? Decimal.valueOf(updatedAdjustment.quantity):0.00;
            updatedSObject.Product__c = updatedAdjustment.productId;
            updatedSObject.Unit_Of_Measure__c = updatedAdjustment.unitOfMeasure;
            updatedSObject.UOM__c = updatedAdjustment.uom;
            updatedSObject.Case__c = updatedAdjustment.caseId;
            
            Decimal qtyConversion = 1;
            if(updatedSObject.Unit_Of_Measure__c=='MSF' && productIdToMSFConversionMap.containsKey(updatedSObject.Product__c)
               && productIdToMSFConversionMap.get(updatedSObject.Product__c)!=null )
                qtyConversion = productIdToMSFConversionMap.get(updatedSObject.Product__c);
            
            Decimal extQuantity = updatedSObject.Quantity__c*qtyConversion;
            updatedSObject.Ext_Qty_Conversion__c = qtyConversion; 
            updatedSObject.EXT_AMOUNT__c = (updatedSObject.Price__c*extQuantity).setScale(2);
            
            updatedSObjects.add(updatedSObject);
            
        }
        
        upsert updatedSObjects;
    }
    
    @AuraEnabled
    public static List<SalesAdjustmentNoChargeItem> getSalesAdjustments(Id caseId) 
    {
        List<SalesAdjustmentNoChargeItem> salesAdjNoChargeList = new List<SalesAdjustmentNoChargeItem>();
        
        
        for(Sales_Adjustment_No_Charge__c salesAdjustment : [SELECT Id, Product__c, Case__c, Case__r.Status, Product__r.Name, Product__r.Description, Quantity__c,
                                                             UOM_Price__c, UOM_Qty__c,Product__r.ProductCode, Price__c, EXT_AMOUNT__c, Unit_of_Measure__c,
                                                             Material_Number__c, Price_Currency_Code__c,Ext_Qty_Conversion__c,UOM__c FROM Sales_Adjustment_No_Charge__c
                                                             WHERE Case__c =:caseId ORDER BY CREATEDDATE]) 
        {
            SalesAdjustmentNoChargeItem salesAdjustmentItem = new SalesAdjustmentNoChargeItem();
            
            salesAdjustmentItem.recordId = salesAdjustment.Id;
            salesAdjustmentItem.productId = salesAdjustment.Product__c;
            salesAdjustmentItem.productName = salesAdjustment.Product__r.ProductCode;
            salesAdjustmentItem.productDescription = salesAdjustment.Product__r.Name;
            salesAdjustmentItem.caseId = salesAdjustment.Case__c;
            salesAdjustmentItem.materialNumber = salesAdjustment.Material_Number__c;
            salesAdjustmentItem.price = String.valueOf(salesAdjustment.Price__c);
            salesAdjustmentItem.unitOfMeasure = salesAdjustment.Unit_Of_Measure__c;
            salesAdjustmentItem.uom = salesAdjustment.UOM__c;
            salesAdjustmentItem.displayMode = 'Read';
            salesAdjustmentItem.quantity = String.valueOf(salesAdjustment.Quantity__c);
            salesAdjustmentItem.uom_qty = String.valueOf(salesAdjustment.UOM_Qty__c);
            salesAdjustmentItem.uom_prc = String.valueOf(salesAdjustment.UOM_Price__c);
            salesAdjustmentItem.ext_amt = String.valueOf(salesAdjustment.EXT_AMOUNT__c);
            salesAdjustmentItem.qtyConversion = String.ValueOf(salesAdjustment.Ext_Qty_Conversion__c);
            
            salesAdjNoChargeList.add(salesAdjustmentItem);
        }
        
        return salesAdjNoChargeList;
    }
    
    @AuraEnabled
    public static List<SalesAdjustmentNoChargeItem> updateCaseSalesAdjustments(Id caseId, String salesAdjustmentJson) 
    {
        String shipToAccountNo = '';
        String soldToAccountNo = '';
        String salesOrg = '';
        
        List<SalesAdjustmentNoChargeItem> salesAdjustmentList = 
            (List<SalesAdjustmentNoChargeItem>)JSON.deserialize(salesAdjustmentJson,List<SalesAdjustmentNoChargeItem>.class);
        
        Case caseRecord = [SELECT Country__c, Sales_Org__c,Ship_to_No__c, Sold_to_No__c, Rebill_Different_Customers__c ,
                           rebill_ship_to__c, rebill_sold_to__c, rebill_ship_to__r.SAP_ACCOUNT__c, rebill_sold_to__r.SAP_ACCOUNT__c
                           FROM Case WHERE Id=:caseId];
        
        shipToAccountNo = caseRecord.Ship_to_No__c;
        soldToAccountNo = caseRecord.Sold_to_No__c;
        
        if (caseRecord.rebill_ship_to__c!=null && String.isNotBlank(caseRecord.rebill_ship_to__r.SAP_ACCOUNT__c)){
            //shipToAccountNo = caseRecord.rebill_ship_to__r.SAP_ACCOUNT__c;
            //soldToAccountNo = caseRecord.rebill_sold_to__r.SAP_ACCOUNT__c;
        }
        
        salesOrg = caseRecord.Sales_Org__c;
        
        if (String.isEmpty(salesOrg)){
            if (String.isNotEmpty(caseRecord.Country__c)){
                if (caseRecord.Country__c=='USA') salesOrg = '1006';
                else salesOrg = '1100';
            }
        }
        
        
        Map<String,List<SalesAdjustmentNoChargeItem>> salesAdjByProdCode = new Map<String,List<SalesAdjustmentNoChargeItem>>();
        
        Set<String> materialIdSet = new Set<String>();
        Set<String> productIdSet = new Set<String>();
       
        if(!salesAdjustmentList.isEmpty()){
            for(SalesAdjustmentNoChargeItem salesAdjustment : salesAdjustmentList) {
                if(String.isNotBlank(salesAdjustment.productName) && salesAdjustment.displayMode!='Read'){
                    If(!salesAdjByProdCode.containsKey(salesAdjustment.productName)){
                        List<SalesAdjustmentNoChargeItem> tempList = new List<SalesAdjustmentNoChargeItem>();
                        tempList.add(salesAdjustment);
                        salesAdjByProdCode.put(salesAdjustment.productName,tempList);
                    }
                    else{
                        List<SalesAdjustmentNoChargeItem> tempList = salesAdjByProdCode.get(salesAdjustment.productName);
                        tempList.add(salesAdjustment);
                        salesAdjByProdCode.put(salesAdjustment.productName,tempList);
                    }
                    materialIdSet.add(salesAdjustment.productName);
                    productIdSet.add(salesAdjustment.productId);
                }
            }
        }
        
     
        if(!materialIdSet.isEmpty()){
            
            CT_PricingWebService pricingWebService = new CT_PricingWebService();
            Map<String, CT_PricingWebService.PriceInfoContainer> mapPriceInfoContainer = 
                pricingWebService.getPriceInfo(materialIdSet, soldToAccountNo, shipToAccountNo, Date.today(), salesOrg);
            Map<Id,Decimal> productIdToMSFConversionMap = getProductDetails(productIdSet);
            
            for(String materialId : materialIdSet) 
            {
                List<SalesAdjustmentNoChargeItem> salesAdjList = salesAdjByProdCode.get(materialId);
                if(!salesAdjList.isEmpty()) {
                    for(SalesAdjustmentNoChargeItem salesAdjustment: salesAdjList){
                        
                        CT_PricingWebService.PriceInfoContainer pricingContainer =  mapPriceInfoContainer.get(salesAdjustment.productName);
                        System.debug('pricingContainer '+pricingContainer);
                        if(pricingContainer != null) 
                        {
                            Decimal tempDecimalValue = 0.00;
                            Decimal qtyConversion = 1;
                            Decimal webServicePrice = pricingContainer.discountedPriceObject.condValue;
                            
                            
                            if(productIdToMSFConversionMap.containsKey(salesAdjustment.productId) &&  productIdToMSFConversionMap.get(salesAdjustment.productId)!=null
                               && salesAdjustment.unitOfMeasure=='MSF')
                                qtyConversion = productIdToMSFConversionMap.get(salesAdjustment.productId);
                            
                            if (webServicePrice==null || webServicePrice==0) webServicePrice = pricingContainer.listPriceObject.condValue;
                            if (webServicePrice==null) webServicePrice=0;
                            System.Debug(salesOrg+' : Price for material '+materialId+' : '+webServicePrice);
                            salesAdjustment.price = String.ValueOf(webServicePrice);
                            salesAdjustment.materialNumber = String.ValueOf(pricingContainer.listPriceObject.matnr);
                            salesAdjustment.priceCurrencyCode = String.ValueOf(pricingContainer.listPriceObject.currencyCode);    
                            //salesAdjustment.unitOfMeasure = String.ValueOf(pricingContainer.listPriceObject.condUnit);    
                            
                            Decimal quantity = salesAdjustment.quantity != null ? Decimal.ValueOf(salesAdjustment.quantity) : 0.00;
                            Decimal price = salesAdjustment.price != null ? Decimal.ValueOf(salesAdjustment.price) : 0.00; // price was just set from Web Service
                            
                            Decimal extQuantity = quantity*qtyConversion;
                            
                            tempDecimalValue = (extQuantity*price).setScale(2);
                            
                            salesAdjustment.ext_amt = String.ValueOf(tempDecimalValue);
                            
                        }
                    }
                }
            }                
        }
         return salesAdjustmentList;
       
    }
    
    @AuraEnabled
    public Static String deleteNoChargeRecord(String recId){
        String message = null;
        List<Sales_Adjustment_No_Charge__c> deleteSalesAdjustmentList = new List<Sales_Adjustment_No_Charge__c>(); 
         
        deleteSalesAdjustmentList = [Select id From Sales_Adjustment_No_Charge__c where Id=: recId];
        if(!deleteSalesAdjustmentList.isEmpty()){
            delete deleteSalesAdjustmentList;
            message = 'Success';
        }
        
        return message;
    }
    
    
    public static Map<Id,Decimal> getProductDetails(Set<String> productIdSet){
        Map<Id,Decimal> productToMSFConversionMap = new Map<Id,Decimal>();
        
        for(Product2 prod : [Select Id,Name,MSF_Conversion__c From Product2 Where Id IN: productIdSet]){
            productToMSFConversionMap.put(prod.Id,prod.MSF_Conversion__c);
        }
        return productToMSFConversionMap;
    }
    
    public class SalesAdjustmentNoChargeItem 
    {
        @AuraEnabled public String recordId { get; set;}
        @AuraEnabled public String productId { get; set;}
        @AuraEnabled public String caseId { get; set;}
        @AuraEnabled public String productName { get; set;}
        @AuraEnabled public String productDescription { get; set;}
        @AuraEnabled public String materialNumber { get; set;}
        @AuraEnabled public String price { get; set;}
        @AuraEnabled public String uom { get; set;}
        @AuraEnabled public String unitOfMeasure { get; set;}
        @AuraEnabled public String displayMode { get; set;}
        @AuraEnabled public String quantity { get; set;}
        @AuraEnabled public String uom_qty { get; set;}
        @AuraEnabled public String uom_prc { get; set;}
        @AuraEnabled public String ext_amt { get; set;}
        @AuraEnabled public String priceCurrencyCode { get; set;}
        @AuraEnabled public String qtyConversion { get; set;}
        
        public SalesAdjustmentNoChargeItem() {}
    }
       
}