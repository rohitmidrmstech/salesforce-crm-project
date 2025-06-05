@isTest(SeeAllData = true)
public class RebateClaimHistoryUtilityTest {
    
    public static testMethod void testHistoryGetMethod()
    {
        //Get Recordtype Ids
        Id recTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        // Test data
        test.startTest();
        RebateClaim rc1 = new RebateClaim(Quantity = 1,ClaimAmount = 1, ClaimDate = System.today(), RecordTypeId = recTypeId, ProductCode='test',Unit_Price__c =2);
        
        insert rc1;
        
        List<RebateClaimHistory> histList=new List<RebateClaimHistory>();
        RebateClaimHistory hist=new RebateClaimHistory(Field='Quantity',RebateClaimId = rc1.id);
        histList.add(hist);
        //insert histList;
        RebateClaimHistory hist2=new RebateClaimHistory(Field='ProductCode',RebateClaimId = rc1.id);
        histList.add(hist2);
        RebateClaimHistory hist3=new RebateClaimHistory(Field='Unit_Price__c ',RebateClaimId = rc1.id);
        histList.add(hist3);
        insert histList;
        
        RebateClaimHistoryUtility.getHistory(rc1.id);
        
        
        // System.assertEquals(1, results.size());
        // System.assertEquals('Name|null|null', results[0]);
    }
    
    /*  @isTest
static void testGetHistory() {

//Get Recordtype Ids
Id recTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
// Test data
RebateClaim rc1 = new RebateClaim(Quantity = 1,ClaimAmount = 1, ClaimDate = System.today(), RecordTypeId = recTypeId);

insert rc1;

RebateClaimHistory historyRecord = new RebateClaimHistory(
Field = 'Quantity',
DataType = 'Double',
RebateClaimId = rc1.id
);

historyRecord = (RebateClaimHistory) TestingUtils.setReadOnlyField(historyRecord,

new Map<String, Object>{

'OldValue' => 1,
'NewValue' => 2
}

);

insert historyRecord;

RebateClaimHistoryUtility.getHistory(rc1.id);       

}*/
    
}