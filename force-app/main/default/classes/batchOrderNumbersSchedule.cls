// ==================================================================================
//   Object: batchOrderNumbersSchedule
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: To schedule the batchOrderNumbers class to run every night.
//           System.Schedule('batchOrderNumbers', '0 0 2 * * ?', new batchOrderNumbersSchedule());
// ==================================================================================
//  Changes: 2013-04-29 Initial version.
// ==================================================================================

global class batchOrderNumbersSchedule implements Schedulable {
    
    global void execute(SchedulableContext SC) {
        Id BatchProcessId = Database.executeBatch(new batchOrderNumbers_Siding(), 100);
    }
}