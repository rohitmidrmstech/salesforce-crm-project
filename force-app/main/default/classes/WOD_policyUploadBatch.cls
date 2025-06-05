/**
 * @description Batch class to create Policies for today created Dummy Policy 
*/
global class WOD_policyUploadBatch implements Database.Batchable<sObject> {
    /**
	 * @description Batch class start method
	 * @param BC BatchableContext
	 * @return QueryLocator
	*/
    global Database.QueryLocator start(Database.BatchableContext BC) {
        String query = 'select Id, Name, Algae_Protection_YR__c, Building_Type_Application__c, '+ 
        'Claim_Type__c, Defect_Code__c, End_Date__c, Homeowner_s_Insurance_First_Y_N__c, Ignore_Defect_Code__c, Labor_Included_Y_N__c, '+ 
        'Market_Family_Code__c, Material_Included_Y_N__c, Maxiumum_Liability__c, Ownership__c, PAT_Policy_ExternalId__c, ' +
        'Policy_Active_Y_N__c, Priority__c, Product_Type_Code__c, Prorated_Y_N__c, Proration_Schedule__c, Reduction_Factor_MO__c, '+
        'Second_Owner_IN_Surestart__c, Second_Owner_OUT_Surestart__c, Start_Date__c, SureStart_Period__c, '+
        'Unique_Warranty_Registration__c, WR_External_Id__c, Warranty_Period__c, Warranty_Registration_Type__c, Wind_Speed__c, '+
        'Wind_Warranty_Term_Years__c, Workmanship_Coverage_Years__c, Description__c, Policy_Full_Name__c, '+
        'Warranty_Period_2nd_owner_after_SS__c, Warranty_Period_2nd_owner_within_SS__c, Roofing_Id__c, Siding_Id__c, Sales_Org__c, '+
        'Business_Units__c from WOD_Policy_Dummy__c where CREATEDDATE = TODAY';
        return Database.getQueryLocator(query);
    }
    /**
	 * @description Batch class execute method
	 * @param BC BatchableContext
     * @param scope List of dummy policies
	*/
    global void execute(Database.BatchableContext BC, List<WOD_Policy_Dummy__c > scope) {
        WOD_InsertPolicies ct=new WOD_InsertPolicies();
        ct.insertPolicies(scope);
    }   
    /**
	 * @description Batch class finish method
	 * @param BC BatchableContext
	*/
    global void finish(Database.BatchableContext BC) {
    }
}