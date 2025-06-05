// ==================================================================================
//   Object: testBiuMarketFamilyPlan 
//  Company: CT-SPG
//   Author: John Westenhaver (Sales Optimizer)
// Comments: Test the biuMarketFamilyPlan trigger. 
// ==================================================================================
//  Changes: 2011-04-07 Initial version.
// ==================================================================================

@isTest
private class testBiuMarketFamilyPlan
{
    public static testmethod void unitTest()
    {
/*
    	// Get record types.
    	ID recordTypePrimary;
    	ID recordTypeSecondary;
    	List<RecordType> typeList = 
    		[SELECT Id, Name FROM RecordType WHERE SObjectType = 'Account' AND Name IN ('BPCS Bill-To', 'Secondary')];
    	for (RecordType rt : typeList)
    	{
    		if (rt.Name == 'BPCS Bill-To (Siding)') recordTypePrimary = rt.Id;
    		if (rt.Name == 'End User or Lumberyard Indirect Prospect') recordTypeSecondary = rt.Id;
    	} 
    	
        // Create Accounts for each record type.
        Account a1 = new Account(Name = 'Test Primary Account', RecordTypeId = recordTypePrimary);
        insert a1;
        Account a2 = new Account(Name = 'Test Secondary Account', RecordTypeId = recordTypeSecondary);
        insert a2;
        
        // Create Plan.
        Plan__c p = new Plan__c(Account__c = a1.Id, Product_Line__c = 'Siding');
        insert p;
        
        // Create Market Family Plan.
        Market_Family_Plan__c mfp = new Market_Family_Plan__c(Plan__c = p.Id);
        insert mfp;
*/
    }
}