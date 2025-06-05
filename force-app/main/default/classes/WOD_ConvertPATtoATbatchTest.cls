/**
 * @description Test class for WOD_ConvertPATtoATbatch
*/
@isTest
public class WOD_ConvertPATtoATbatchTest {
    /**
     * @description method to cover test coverage
    */
    static testMethod void test() 
    {
        WOD_2__Policy_Definition__c pd=new WOD_2__Policy_Definition__c(Name='test',WOD_2__Business_Units__c='Roofing',WOD_2__Months_Covered__c=180,WOD_2__Priority__c=400000,WOD_2__Status__c='Active',WOD_2__Type__c='Standard',Roofing_Id__c='123',WOD_2__Active_From__c= System.today()-10,WOD_2__Active_Until__c= System.today()+5);
        insert pd;
        WOD_2__Policy_Applicability_Term__c pat=new WOD_2__Policy_Applicability_Term__c(WOD_2__Applicability_SubType__c='RecordType.DeveloperName',WOD_2__Applicability_Term_Type__c='Inclusion',WOD_2__Applicability_Value__c='Standard',WOD_2__Policy_Definition__c=pd.id,Roofing_Id__c='123');
        insert pat;
        WOD_2__Policy_Applicability_Term__c pat1=new WOD_2__Policy_Applicability_Term__c(WOD_2__Applicability_SubType__c='WOD_2__Warranty_Product__r.Market_Family__r.BPCS_Code__c',WOD_2__Applicability_Term_Type__c='Inclusion',WOD_2__Applicability_Value__c='Standard',WOD_2__Policy_Definition__c=pd.id,Roofing_Id__c='1234');
        insert pat1;
        WOD_2__Warranty_Rule__c wr=new WOD_2__Warranty_Rule__c(WOD_2__Enabled__c=true,WOD_2__Logical_Grouping__c='OR',WOD_2__Object_Name__c='WOD_2__Claim__c',WOD_2__Rule_Type__c='Eligibility Rule',Roofing_Id__c='123');
        insert wr;
        WOD_2__Warranty_Rule_Criteria__c wrc=new WOD_2__Warranty_Rule_Criteria__c(WOD_2__Warranty_Rule__c=wr.id,WOD_2__Criteria_Type__c='Not Equal To',WOD_2__Criteria_Value__c='221',WOD_2__Related_Object__c='twod__Warranty_Code__c',Roofing_Id__c='123');
        insert wrc;
        WOD_2__Warranty_Rule_Criteria__c wrc1=new WOD_2__Warranty_Rule_Criteria__c(WOD_2__Warranty_Rule__c=wr.id,WOD_2__Criteria_Type__c='Not Equal To',WOD_2__Criteria_Value__c='221',WOD_2__Related_Object__c='twod__Warranty_Code__c',Roofing_Id__c='1234');
        insert wrc1;
        WOD_2__Warranty_Rule_Association__c wra=new WOD_2__Warranty_Rule_Association__c(WOD_2__Warranty_Rule__c=wr.id,WOD_2__Is_Active__c=true,WOD_2__Policy_Definition__c=pd.id,Roofing_Id__c='123');
        insert wra;
        
        
        WOD_2__Policy_Definition__c pd_s=new WOD_2__Policy_Definition__c(Name='test',WOD_2__Business_Units__c='Siding',WOD_2__Months_Covered__c=180,WOD_2__Priority__c=400001,WOD_2__Status__c='Active',WOD_2__Type__c='Standard',Siding_Id__c='123',WOD_2__Active_From__c= System.today()-10,WOD_2__Active_Until__c= System.today()+5);
        insert pd_s;
        WOD_2__Policy_Applicability_Term__c pat_s=new WOD_2__Policy_Applicability_Term__c(WOD_2__Applicability_SubType__c='RecordType.DeveloperName',WOD_2__Applicability_Term_Type__c='Inclusion',WOD_2__Applicability_Value__c='Standard',WOD_2__Policy_Definition__c=pd_S.id,Siding_Id__c='123');
        insert pat_S;
         WOD_2__Policy_Applicability_Term__c pat2_s=new WOD_2__Policy_Applicability_Term__c(WOD_2__Applicability_SubType__c='OwnershipType__c',WOD_2__Applicability_Term_Type__c='Inclusion',WOD_2__Applicability_Value__c='Standard',WOD_2__Policy_Definition__c=pd_S.id,Siding_Id__c='12345');
         insert pat2_S;
        WOD_2__Policy_Applicability_Term__c pat1_S=new WOD_2__Policy_Applicability_Term__c(WOD_2__Applicability_SubType__c='WOD_2__Warranty_Product__r.Market_Family__r.BPCS_Code__c',WOD_2__Applicability_Term_Type__c='Inclusion',WOD_2__Applicability_Value__c='Standard',WOD_2__Policy_Definition__c=pd_S.id,Siding_Id__c='1234');
        insert pat1_S;
        WOD_2__Warranty_Rule__c wr_S=new WOD_2__Warranty_Rule__c(WOD_2__Enabled__c=true,WOD_2__Logical_Grouping__c='OR',WOD_2__Object_Name__c='WOD_2__Claim__c',WOD_2__Rule_Type__c='Eligibility Rule',Siding_Id__c='123');
        insert wr_S;
        WOD_2__Warranty_Rule_Criteria__c wrc_S=new WOD_2__Warranty_Rule_Criteria__c(WOD_2__Warranty_Rule__c=wr_S.id,WOD_2__Criteria_Type__c='Not Equal To',WOD_2__Criteria_Value__c='221',WOD_2__Related_Object__c='twod__Warranty_Code__c',Siding_Id__c='123');
        insert wrc_S;
        WOD_2__Warranty_Rule_Criteria__c wrc1_S=new WOD_2__Warranty_Rule_Criteria__c(WOD_2__Warranty_Rule__c=wr_s.id,WOD_2__Criteria_Type__c='Not Equal To',WOD_2__Criteria_Value__c='221',WOD_2__Related_Object__c='twod__Warranty_Code__c',Siding_Id__c='1234');
        insert wrc1_S;
        WOD_2__Warranty_Rule_Association__c wra_S=new WOD_2__Warranty_Rule_Association__c(WOD_2__Warranty_Rule__c=wr_s.id,WOD_2__Is_Active__c=true,WOD_2__Policy_Definition__c=pd.id,Siding_Id__c='123');
        insert wra_S;
        Test.startTest();
        Database.executeBatch(new WOD_ConvertPATtoATbatch(pd.id.to15()), 500);
        Database.executeBatch(new WOD_ConvertPATtoATbatch(pd_s.id.to15()), 500);
        Test.stopTest();
    }
}