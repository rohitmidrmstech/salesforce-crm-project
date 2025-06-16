/**
* -------------------------------------------------------------------------------------------------
* Invoice Line Item Trigger Handler class
* -------------------------------------------------------------------------------------------------
* @author         Gautam Kumar (gkumar@liquidhub.com)
* @verstion       1.0
* @created        2017-08-20
*/
public class CT_InvoiceLineItem_TriggerHandler {

   
    public void beforeInsertHandler(List<Invoice_Line_Item__c> newList){
        calculateValues(newList);
    }
    
    public void beforeUpdateHandler(List<Invoice_Line_Item__c> newList){
        calculateValues(newList);
    }

    public void calculateValues(List<Invoice_Line_Item__c> newList){
        
        //create a set to store the invoice Ids
        Set<Id> invoiceIds = new Set<Id>();
        
        //iterate through all invoices coming in and get all invoice ids, store in invoiceIds set
        for(Invoice_Line_Item__c i: newList){
            invoiceIds.add(i.invoice__c);
        }
        //create a map to store the invoice id and respective sales org
        map<Id,invoice__c> invToSalesOrgMap = new map<Id, invoice__c>([select id, sales_org__c from invoice__c where ID IN : invoiceIds]);
            
		//create new list to process & iterate through invoiceIds and determine if ct/ins
		list<Invoice_Line_Item__c> CTInvoicesToProcess = new list<Invoice_Line_Item__c>();
        for(Invoice_Line_Item__c ili: newlist){
            String iliSalesOrg = invToSalesOrgMap.get(ili.Invoice__c).Sales_Org__c;
            if(iliSalesOrg != '1503' && iliSalesOrg != '1300'){
                CTInvoicesToProcess.add(ili);
            }
        }
        
        // make sure there are CT items that need to be calculated
        if(CTInvoicesToProcess.size() > 0){
            for(Invoice_Line_Item__c invli: CTInvoicesToProcess){
                Decimal productPrice = invli.Product_Price__c!=null ? invli.Product_Price__c : 0;
                Decimal discountPercent = (invli.Discount_Percentage__c!=null ? invli.Discount_Percentage__c : 0) / 100;
                Decimal discountFactor = 1-discountPercent;
                Decimal netPrice = productPrice * discountFactor;
    
                invli.Net_Price__c = netPrice;
    
                Decimal pricingQty = invli.Pricing_Qty__c!=null ? invli.Pricing_Qty__c : 0;
                if(pricingQty != 0)
                    invli.Net_Value__c = netPrice * pricingQty;
        	}	
        }
    }
    
}