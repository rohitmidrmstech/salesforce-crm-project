/**
 * Created by alanbrown on 5/10/19.
 */

global class BatchUpdateCTCInvoiceLineItemExtAmt implements Database.batchable<sObject> {
    global String strQuery;


    global BatchUpdateCTCInvoiceLineItemExtAmt() {
        this.strQuery = 'Select invoice__c, product__c, product_value__c, invoice__r.order__c from Invoice_line_item__c'+
                ' where ceilings_id__c != null and product__c != null order by createddate desc';
    }

    global BatchUpdateCTCInvoiceLineItemExtAmt (String queryString) {
        strQuery = queryString;
    }


    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(strQuery);
    }

    global Void execute(Database.BatchableContext BC, List<sObject> scope) {
        batchUpdateInvoices(scope);
    }
    void batchUpdateInvoices(List<sObject> scope) {
        List<Invoice_line_item__c> invoiceLineItems = (List<Invoice_line_item__c>) scope;
        processInvoiceLineItems(invoiceLineItems);
    }

    global void finish(Database.BatchableContext BC) {
    }

    Map<Id, Map<id, OrderItem>> getOrderItemsForOrders(Set<id> orderIds) {
        Map<Id, Map<id, OrderItem>> result = new Map<Id, Map<id, OrderItem>>();
        List<OrderItem> orderItems =
                [select orderid, Product2Id, extended_amount__c from OrderItem where orderId in :orderIds];
        for (OrderItem oi : orderItems) {
            System.debug('### found OI with extAmount: ' + oi.extended_amount__c);
            if (oi.Product2Id != null) {
                if (result.get(oi.orderid) == null)
                    result.put(oi.orderid, new Map<id, OrderItem>());
                result.get(oi.orderid).put(oi.Product2Id, oi);
                System.debug('### oi product id is ' + oi.Product2Id);
            }
        }

        return result;
    }

    Map <id, List<Invoice_Line_Item__c>> getInvoiceToILIs(List<Invoice_Line_Item__c> invoiceLineItems) {
        Map<id, List<Invoice_Line_Item__c>> result = new Map<id, List<Invoice_Line_Item__c>>();
        for (Invoice_Line_item__c ili : invoiceLineItems) {
            if (result.get(ili.invoice__c) == null)
                result.put(ili.invoice__c, new List<Invoice_Line_Item__c>());
            result.get(ili.invoice__c).add(ili);

        }
        return result;

    }


    private void processInvoiceLineItems(List<Invoice_Line_Item__c> invoiceLineItems) {
        //get Orders for the invoices and put them in InvoiceID -> orderId map
        Map<id,id> invoiceToOrderIdMap = new Map<id,id>();
        Set<id> orderIds = new Set<id>();

        for (Invoice_Line_Item__c inv : invoiceLineItems) {
            invoiceToOrderIdMap.put(inv.invoice__c, inv.invoice__r.order__c);
            orderIds.add(inv.invoice__r.order__c);
        }
        System.debug('### Number of ILIs is ' + invoiceLineItems.size());

        //get order Items for the orders and put them in OrderId -> Map<ProductId, OrderItem> map
        Map<Id, Map<id, OrderItem>> ordersToProductOIMap =  getOrderItemsForOrders(orderIds);

        //get invoice items for the invoices and put them in InvoiceId -> List<InvoiceLineItem> map
        Map<id, List<Invoice_Line_Item__c>> invoiceToILIMap = getInvoiceToILIs(invoiceLineItems);

        List<Invoice_Line_item__c> ilisToUpdate = new List<Invoice_Line_item__c>();
        //for each invoice
        for (id invId : invoiceToILIMap.keySet()) {
            id orderId = invoiceToOrderIdMap.get(invId);
            Map<id, OrderItem> productToOIMap = ordersToProductOIMap.get(orderId);

            System.debug('### productToOIMap.size() is ' + productToOIMap.size());
            System.debug('### invoice id is ' + invId);

            //...get the ILIs and the map of OrderItems from the related order
            for(Invoice_Line_Item__c ili : invoiceToILIMap.get(invId)) {
                System.debug('### invoiceLineItem id is ' + ili.id);
                //.......get the product from the ILI and then get the equivalent OrderItem from the OImap
                if (productToOIMap == null) {
                    System.debug('*** orderId ' + orderId + ' has no items with referenced products');
                } else {
                    System.debug('### ili.product__c is ' + ili.product__c);
                    OrderItem oi = productToOIMap.get(ili.product__c);

                    //.......Populate ILI.Product_value__c with the ExtendedAmount
                    if (oi != null && oi.Extended_Amount__c != null) {
                        ili.Product_Value__c = oi.Extended_Amount__c;
                        System.debug('***  Invoiceid:' + ili.invoice__c + ', ili.id:' + ili.id + ', value: ' + ili.Product_Value__c);
                        ilisToUpdate.add(ili);
                    } else {
                        System.debug('*** oi is ' + oi);
                        if (oi != null)
                            System.debug('*** oi.extended_amount__c = ' + oi.extended_amount__c);

                    }
                }
            }
        }
        if (ilisToUpdate.size() > 0)
            update ilisToUpdate;
    }




}