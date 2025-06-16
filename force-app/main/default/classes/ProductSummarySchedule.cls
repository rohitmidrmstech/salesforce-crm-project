// ==================================================================================
//   Object: ProductSummarySchedule
//  Company: CertainTeed Gypsum
//   Author: Mohan Kumar (Huron)
// Comments: To schedule the ProductSummaryBatch class to run every night.
//			 System.Schedule('ProductSummaryBatch', '0 0 2 * * ?', new ProductSummaryBatch());
// ==================================================================================
//  Changes: 2013-04-29 Initial version.
// ==================================================================================

global class ProductSummarySchedule implements Schedulable {
	
	global void execute(SchedulableContext SC) {
		Integer year;
		if(System.today().month()<11){
			year = System.today().year();
		}else if(System.today().month()>= 11){
			year = System.today().year() + 1;
		}
		String curYear = String.valueOf(year);
		ProductSummary__c newSummaryObj;
		List<ProductSummary__c> summaryObj = [Select p.Year__c, p.Actual_VAP__c, p.Actual_Tape__c, p.Actual_Finishing__c, p.Actual_All_Board__c, p.Planned_VAP__c, p.Planned_Tape__c, p.Planned_Finishing__c, p.Planned_All_Boards__c, p.Name, p.Id, p.Budget_VAP__c, p.Budget_Tape__c, p.Budget_Finishing__c, p.Budget_All_Boards__c From ProductSummary__c p Where Year__c =: curYear];
		if(summaryObj.size() == 0) {
			newSummaryObj = new ProductSummary__c();
			newSummaryObj.Name = curYear;
			newSummaryObj.Year__c = curYear;
		} else {
			newSummaryObj = summaryObj[0];
		}
		
		newSummaryObj.Budget_All_Boards__c = 0;
		newSummaryObj.Budget_Finishing__c = 0;
		newSummaryObj.Budget_Tape__c = 0;
		newSummaryObj.Budget_VAP__c = 0;
		newSummaryObj.Planned_All_Boards__c = 0;
		newSummaryObj.Planned_Finishing__c = 0;
		newSummaryObj.Planned_Tape__c = 0;
		newSummaryObj.Planned_VAP__c = 0;
		newSummaryObj.Actual_All_Board__c = 0;
		newSummaryObj.Actual_Finishing__c = 0;
		newSummaryObj.Actual_Tape__c = 0;
		newSummaryObj.Actual_VAP__c = 0;
		upsert newSummaryObj;
		
		Id BatchProcessId = Database.executeBatch(new ProductSummaryBatch(), 1000);
	}
}