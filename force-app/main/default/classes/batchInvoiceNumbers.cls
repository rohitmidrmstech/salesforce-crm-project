// ==================================================================================
//   Object: batchInvoiceNumbers
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Find the associated Invoices matching the Invoice Number and set the Invoice 
//			 field on a Case record.
// ==================================================================================
//  Changes: 2013-04-29 Initial version.
// ==================================================================================

global class batchInvoiceNumbers  implements Database.Batchable<SObject>, Database.AllowsCallouts {
	
	global database.Querylocator start(Database.BatchableContext BC) {
    	
        if(Test.isRunningTest()) {
            return Database.getQueryLocator([Select c.Invoice__c, c.Invoice_Number__c, c.Id From Case c Where Invoice_Number__c != null AND
        									Invoice__c = null Limit 100 ]);
        }
         
        return Database.getQueryLocator([Select c.Invoice__c, c.Invoice_Number__c, c.Id From Case c Where Invoice_Number__c != null AND Invoice__c = null]);
    }
    
    global void execute(Database.BatchableContext BC,Sobject[] scope) {
		try { 
			Set<String> invoiceNumbers = new Set<String>();
			//group all the Invoice Numbers from the Case records
			for(sobject s : scope) {
				Case c = (Case)s;
				invoiceNumbers.add(c.Invoice_Number__c);
			}
			
			//fetch the Invoices matching to the case Invoice Number and prepare a map out of it.
			List<Invoice__c> invoiceList = [Select i.Name, i.Id, i.Invoice_Number__c From Invoice__c i Where Invoice_Number__c IN :invoiceNumbers and Invoice_Number__c != null];
			Map<String, Id> invoiceNumberMap = new Map<String, Id>();
			for(Invoice__c i : invoiceList) {
				invoiceNumberMap.put(i.Invoice_Number__c, i.Id);
			}
			//populate the Invoice field on the Case if there was match found based on Invoice Number 
			List<Case> updateList = new List<Case>();
			for(sobject s : scope) {
				Case c = (Case)s;
				c.Invoice__c = invoiceNumberMap.get(c.Invoice_Number__c);
				updateList.add(c);
			}
			update updateList;
		} catch(Exception ex) {}
    }
    
    global void finish(Database.BatchableContext BC) {
 
    }
}