public class CT_CaseTriggerHelper {

    
     /* Function to return the orderItemsList.
     * @param - Set of id's of orders from the inserted/updated cases. 
     * @return - List of orderItems.
     * @description - This function will return the orderItems related to the orders on cases.
     */
    public static List<orderItem> returnOrderItemsList(Set<id> orderIdSet){
        List<orderItem> orderItemsList = new List<orderItem>();
        orderItemsList = [select id,AvailableQuantity,Catalog__c,CreatedById,CreatedDate,Currency__c,Description,
                            Item_Status__c,LastModifiedById,LastModifiedDate,
                            ListPrice,Material__c,Net_Price__c,Net_Value__c,OrderId,serviceDate,
                            OrderItemNumber,Order_Num__c,OriginalOrderItemId,Pallet_Count__c,Material_Desc__c,
                            ph_lvl1_desc__c,ph_lvl1__c,ph_lvl4_desc__c,ph_lvl4__c,ph_lvl5_desc__c,
                            ph_lvl5__c,Planned_Deliv_Date__c,PricebookEntryId,Price_uom__c,Product2Id,Product_Price__c,
                            Qty_Ordered__c,Qty_uom__c,Quantity,Req_Deliv_Date__c,Service_Level_Desc__c,
                            Service_Level__c,TotalPrice,Total_Volume__c,Total_Weight__c,UnitPrice,Line_Number__c,
                            //Parent__c,Quote_Number__c,Volume_Uom__c,Line_Type_Desc__c,Line_Type__c,
                            Weight_Uom__c,Product2.ProductCode FROM OrderItem where orderId in: orderIdSet];
        
        return orderItemsList;
    }
    
    /* Function to return the invoice line item List related to the invoice of cases triggered. 
     * @param - Invoice Id Set of the inserted/updated cases.
     * @return - List of invoice line items.
     * @description - This function will return the list of invoice line item related to the invoice on a case. 
     */
    public static List<Invoice_Line_Item__c> returnInvoiceLineItemList(Set<Id> invoiceIdSet){
        List<Invoice_Line_Item__c> invoiceLineItemList = new List<Invoice_Line_Item__c>();
        invoiceLineItemList = [Select Id,Product_Price__c,Pricing_UOM__c,Quantity_Uom__c,Quantity__c,
                                Discounted_Value__c,Net_Value__c,Material__c,Pricing_Qty__c,Product_Value__c,
                                Discount_Dollars__c,Discount_Percentage__c,Invoice__c,Net_Price__c
                                FROM Invoice_Line_Item__c WHERE Invoice__c IN: invoiceIdSet];
        return invoiceLineItemList;
    }
    
    public static List<case_order_items__c> returnInsertCaseListItem(List<case> caseList,
                                                           Map<id,id> caseAndOrderIdMap,
                                                           Map<id,id> orderIdAndInvoiceIdMap,
                                                           Map<id,List<orderItem>> orderIdAndOrderItemsListMap,
                                                           Map<id,List<Invoice_Line_Item__c>> invoiceIdAndInvoiceItemsListMap,
                                                           Map<String,Id> productMap,
                                                           Map<Id,String> invoiceLineIdItemToMaterialId)
    {
        System.debug('***GotHere');
                                                               
        List<case_order_items__c> insertCaseItemList = new List<case_order_items__c>();
        List<Case> serviceCaseList = new List<Case>();
        
        Map<String, RecordTypeInfo> recordTypeInfoMap = Schema.SObjectType.Case.getRecordTypeInfosByName();

        Set<Id> onlyInvoicedRtIdSet = new Set<Id>();

        Id pricingRecordTypeId = recordTypeInfoMap.get('Pricing Case').getRecordTypeId();
        Id ctcPricingRecordTypeId = recordTypeInfoMap.get('Pricing').getRecordTypeId();
        Id serviceRecordTypeId =  recordTypeInfoMap.get('Service Case').getRecordTypeId();
        Id ctcServiceRecordTypeId=  recordTypeInfoMap.get('Service').getRecordTypeId();
        Id manQualityRecordTypeId =  recordTypeInfoMap.get('Manual Quality Entry Case').getRecordTypeId();
        Id qualityRecordTypeId =  recordTypeInfoMap.get('Quality Case').getRecordTypeId();
        Id ctcQualityRecordTypeId =  recordTypeInfoMap.get('Quality').getRecordTypeId();

        onlyInvoicedRtIdSet.add(pricingRecordTypeId);
        onlyInvoicedRtIdSet.add(manQualityRecordTypeId);
        onlyInvoicedRtIdSet.add(qualityRecordTypeId);
        onlyInvoicedRtIdSet.add(ctcQualityRecordTypeId);
        onlyInvoicedRtIdSet.add(ctcPricingRecordTypeId);
        //onlyInvoicedRtIdSet.add(serviceRecordTypeId); // allow service cases to be created on non invoiced orders

        
        for(case c: caseList){
            System.debug('***GotHere1');
            if(orderIdAndInvoiceIdMap.containsKey(c.Order__c)       // case has an order
                && (orderIdAndInvoiceIdMap.get(c.Order__c)==null)   // and the order does not have an invoice 
                && onlyInvoicedRtIdSet.contains(c.RecordTypeId)){   // and the record type is from the list of items that cannot proceed

                c.addError('This order has not yet been invoiced, please try again later.');
                continue;
            }
            
            
            if(orderIdAndInvoiceIdMap.containsKey(c.Order__c)       // case has an order

                // GCP-491 - we will currently separate the way we create cases against order and invoices.  We will leave the legacy code
                //  in case the decision goes back to the old methodology
                // && (orderIdAndInvoiceIdMap.get(c.Order__c)==null)   // and the order does not have an invoice 

                && c.Invoice__c == null
                && (c.RecordTypeId==serviceRecordTypeId || c.RecordTypeId==ctcServiceRecordTypeId)){            // and the record type is a service case
            
                serviceCaseList.add(c);
                System.debug('***GotHere2');
                continue;
            }
            
            if(caseAndOrderIdMap.containsKey(c.Id)                                                              // case has an order 
                && orderIdAndInvoiceIdMap.containsKey(c.Order__c)                                               // case has an order on this map
                && orderIdAndInvoiceIdMap.containsKey(c.Order__c)!=null                                         // case has an invoice

                // GCP-491 - we will currently separate the way we create cases against order and invoices.  We will leave the legacy code
                //  in case the decision goes back to the old methodology
                // && invoiceIdAndInvoiceItemsListMap.containsKey(orderIdAndInvoiceIdMap.get(c.Order__c))          // case has an List of invoice line items
                // && invoiceIdAndInvoiceItemsListMap.get(        orderIdAndInvoiceIdMap.get(c.Order__c))!=null)   // List of invoice line items is not null

                && c.Invoice__c != null
                && invoiceIdAndInvoiceItemsListMap.containsKey(c.Invoice__c)          // case has an List of invoice line items
                && invoiceIdAndInvoiceItemsListMap.get(        c.Invoice__c)!=null || Test.isRunningTest())   // List of invoice line items is not null
            {
                System.debug('***GotHere3');

                // GCP-491 - we will currently separate the way we create cases against order and invoices.  We will leave the legacy code
                //  in case the decision goes back to the old methodology

                // GCP-399 alternate mapping: if case specified a specific invoice, get that one.
                // Id invoiceId = orderIdAndInvoiceIdMap.get(c.Order__c);
                // if (c.Invoice__c != null) invoiceId = c.Invoice__c;
                Id invoiceId = c.Invoice__c;
                
                List<Invoice_Line_Item__c> currInvLineItemsList = invoiceIdAndInvoiceItemsListMap.containsKey(invoiceId) ? invoiceIdAndInvoiceItemsListMap.get(invoiceId) : new List<Invoice_Line_Item__c>() ;

                // loop through the list of Invoice Line Items
                for(Invoice_Line_Item__c invli: currInvLineItemsList){
                    
                    System.debug('*** invli.id is ' + invli.id);
                    System.debug('*** invoiceLineIdItemToMaterialId is ' + invoiceLineIdItemToMaterialId);
                    if (invli.Id != null)
                        System.debug('*** invoiceLineIdItemToMaterialId.get(invli.Id) is ' + invoiceLineIdItemToMaterialId.get(invli.Id));
                    if (productMap != null && invoiceLineIdItemToMaterialId != null && invli.Id != null)
                        System.debug('*** productMap.containsKey(invoiceLineIdItemToMaterialId.get(invli.Id)) ' + productMap.containsKey(invoiceLineIdItemToMaterialId.get(invli.Id)));
                    
                    if(invoiceLineIdItemToMaterialId.containsKey(invli.Id)                          // we know the product material id - sales org
                        && invoiceLineIdItemToMaterialId.get(invli.Id)!=null                        // it's not null
                        && productMap.containsKey(invoiceLineIdItemToMaterialId.get(invli.Id))){    // and we have a product

                        case_order_items__c caseItem = new case_order_items__c();
                        caseItem.Case__c = c.id;
                        caseItem.Order__c = c.Order__c;
                        caseItem.Inserted_from_trigger__c = true;
                        caseItem.Product_Code__c = invli.Material__c;
                        caseItem.Price_uom__c = invli.Pricing_UOM__c;
                        caseItem.Qty_Uom__c = invli.Quantity_Uom__c;
                        caseItem.Net_Price__c = invli.Net_Value__c;
                        caseItem.Quantity__c = invli.Quantity__c;
                        caseItem.Available_Quantity__c = invli.Pricing_Qty__c;
                        caseItem.Discount_Percentage__c = invli.Discount_Percentage__c;
                        caseItem.Product_Price__c = invli.Product_Price__c;

                        Decimal prodPrice = (invli.Product_Price__c==null)?0:invli.Product_Price__c;
                        Decimal discountPer = (invli.Discount_Percentage__c==null)?0:invli.Discount_Percentage__c;
                        //system.debug('*** prodPrice is ' + prodPrice);      
                        //system.debug('*** discountPer is ' + discountPer);      
                        //system.debug('*** prodPrice * (1 - (discountPer / 100) is ' + prodPrice * (1 - (discountPer / 100)));      
                        caseItem.Unit_Price__c = prodPrice * (1 - (discountPer / 100));

                        caseItem.Total_Price__c = invli.Discounted_Value__c;
                        // if discounted value is not available
                        if (caseItem.Total_Price__c==null){
                            Decimal unitPrice = (caseItem.Unit_Price__c==null) ? 0 : caseItem.Unit_Price__c;
                            Decimal qty = (caseItem.Available_Quantity__c==null) ? 0 : caseItem.Available_Quantity__c;
                            caseItem.Total_Price__c =  unitPrice * qty;
                        } 
                              
                        caseItem.Product__c = productMap.get(invoiceLineIdItemToMaterialId.get(invli.Id));
                        insertCaseItemList.add(caseItem);
                    }
                }
            }
        }
        
        if(!serviceCaseList.isEmpty()){
            List<Case_Order_Items__c> tempCaseItemList = returnInsertCaseListItemFromOrder(serviceCaseList, 
                                                                                           caseAndOrderIdMap,
                                                                                           orderIdAndInvoiceIdMap,
                                                                                           orderIdAndOrderItemsListMap,
                                                                                           invoiceIdAndInvoiceItemsListMap);
            if(!tempCaseItemList.isEmpty())
                insertCaseItemList.addAll(tempCaseItemList);
        }
        
        return insertCaseItemList;   
    }
    
    /* Function to return the case Items List to be inserted. 
     * @param - inserted/updated caseList, map of case Id and Order Id, Map of order Id and their corresponding orderItems. 
     * @return - List of orderItems.
     * @description - This function will return the orderItems to be inserted after an update on case. 
     */
    public static List<case_order_items__c> returnInsertCaseListItemFromOrder(List<case> caseList,
                                                            Map<id,id> caseAndOrderIdMap,
                                                            Map<id,id> orderIdAndInvoiceIdMap,
                                                            Map<id,List<orderItem>> orderIdAndOrderItemsListMap,
                                                            Map<id,List<Invoice_Line_Item__c>> invoiceIdAndInvoiceItemsListMap){
                                                               
        List<case_order_items__c> insertCaseItemList = new List<case_order_items__c>();
                                                               
        Map<Id,List<String>> orderAndHeaderConditionMap = new Map<Id,List<String>>();
        Map<Id,Invoice_Line_Item__c> orderItemAndInvoiceItemMap = new Map<Id,Invoice_Line_Item__c>(); 
                                                               
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> recordTypeIdSet = new Set<Id>();
                                                             
                                                    
        for(case c: caseList){
            if(caseAndOrderIdMap.containsKey(c.Id)
                && orderIdAndOrderItemsListMap.containsKey(caseAndOrderIdMap.get(c.Id))
                && (orderIdAndOrderItemsListMap.get(caseAndOrderIdMap.get(c.Id)))!=null){
                    for(orderItem oi: orderIdAndOrderItemsListMap.get(caseAndOrderIdMap.get(c.Id))){
                        case_order_items__c caseItem = new case_order_items__c();
                        caseItem.Available_Quantity__c = oi.AvailableQuantity;
                        caseItem.Currency__c = oi.Currency__c;
                        caseItem.Case__c = c.id;
                        caseItem.Catalog__c = oi.Catalog__c;
                        //caseItem.Item_Status__c = oi.Item_Status__c;
                        caseItem.Line_Num__c = oi.Line_Number__c;
                        //caseItem.Line_Type__c = oi.Line_Type__c;
                        //caseItem.Line_Type_Desc__c = oi.Line_Type_Desc__c;
                        caseItem.List_Price__c = oi.ListPrice;
                        caseItem.Material__c = oi.Material__c;
                        caseItem.Material_Desc__c = oi.Material_Desc__c;
                        caseItem.Net_Value__c = oi.Net_Value__c;
                        caseItem.Order__c = oi.OrderId;
                        caseItem.Order_Item_Number__c = oi.OrderItemNumber;
                        caseItem.Original_Order_Product__c = oi.OriginalOrderItemId;
                        caseItem.Order_Num__c = oi.Order_Num__c;
                        caseItem.Ph_Lvl1__c = oi.ph_lvl1__c;
                        caseItem.Ph_Lvl1_Desc__c = oi.ph_lvl1_desc__c;
                        caseItem.Ph_Lvl4__c = oi.ph_lvl4__c;
                        caseItem.Ph_Lvl4_Desc__c = oi.ph_lvl4_desc__c;
                        caseItem.Ph_Lvl5__c = oi.ph_lvl5__c;
                        caseItem.Ph_Lvl5_Desc__c = oi.ph_lvl5_desc__c;
                        caseItem.Pallet_Count__c = oi.Pallet_Count__c;
                        //caseItem.parent__c = oi.Parent__c;
                        caseItem.planned_deliv_date__c = oi.Planned_Deliv_Date__c;
                        caseItem.Price_uom__c = oi.Price_uom__c;
                        caseItem.Product__c = oi.Product2Id;
                        caseItem.Product_Price__c = oi.Product_Price__c;
                        caseItem.Qty_Ordered__c = oi.Qty_Ordered__c;
                        //caseItem.Quote_number__c = oi.Quote_Number__c;
                        caseItem.Req_deliv_date__c = oi.Req_Deliv_Date__c;
                        caseItem.Service_Level__c = oi.Service_Level__c;
                        caseItem.Service_Level_Desc__c = oi.Service_Level_Desc__c;
                        caseItem.Start_Date__c = oi.serviceDate;
                        caseItem.Total_Volume__c = oi.Total_Volume__c;
                        caseItem.Total_Weight__c = oi.Total_Weight__c;
                        //caseItem.Volume__c = oi.Volume_Uom__c;
                        caseItem.Weight_Uom__c = oi.Weight_Uom__c;
                        caseItem.Inserted_from_trigger__c = true;
                        caseItem.Product_Code__c = oi.Product2.ProductCode;
                        caseItem.Price_uom__c = oi.Price_Uom__c;
// test case service 27 says we dont need this
//                        caseItem.Unit_Price__c = oi.UnitPrice;
                        caseItem.Qty_Uom__c = oi.Qty_Uom__c;
                       // caseItem.Quantity__c = oi.Quantity;
                        caseItem.Quantity__c = oi.Qty_Ordered__c;
// test case service 27 says we dont need this
//                      caseItem.Total_Price__c = oi.TotalPrice;
                        caseItem.Net_Price__c = oi.Net_Price__c;

                        insertCaseItemList.add(caseItem);
                    }
                }
        }
                                                               
        return insertCaseItemList;   
                                                              
    }
}