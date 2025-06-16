// ==================================================================================
//   Object: batchInvoiceNumbersSchedule
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: To schedule the batchInvoiceNumbers class to run every night.
//			 System.Schedule('batchInvoiceNumbers', '0 0 2 * * ?', new batchInvoiceNumbersSchedule());
// ==================================================================================
//  Changes: 2013-04-29 Initial version.
// ==================================================================================

global class batchInvoiceNumbersSchedule implements Schedulable {
	
	global void execute(SchedulableContext SC) {
		Id BatchProcessId = Database.executeBatch(new batchInvoiceNumbers(), 100);
	}
}