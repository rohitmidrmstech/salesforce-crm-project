/**
 * @description Test class for Wod_InsertPolicies
*/
@isTest
public class Wod_InsertPoliciesTest {
    /**
     * @description data set up and execution
    */
     static testMethod void methodA() {
        List<Id> polIds = new List<Id>();
        
        WOD_Policy_Dummy__c policy=new WOD_Policy_Dummy__c();
        policy.Building_Type_Application__c='SFD';
        policy.Defect_Code__c='FUNG';
        policy.End_Date__c=system.today();
        policy.Ignore_Defect_Code__c='';
        policy.Market_Family_Code__c='BP06';
        policy.Ownership__c='2';
        policy.PAT_Policy_ExternalId__c='RBE_FIRESCREEN_SFD_2_FUNG_STANDARDAfter_200331';
        policy.Proration_Schedule__c='SFD';
        policy.Start_Date__c=system.today();
        policy.SureStart_Period__c=0;
        policy.Warranty_Period__c=0;
        policy.Product_Type_Code__c='RBE';
        policy.Second_Owner_IN_Surestart__c=0;
        policy.Second_Owner_OUT_Surestart__c=2;       
        policy.Reduction_Factor_MO__c='1/240';
        policy.Maxiumum_Liability__c=35;
        policy.Claim_Type__c='STANDARD';        
        policy.Priority__c=1037412;
        policy.Policy_Active_Y_N__c='Y';
        policy.WR_External_Id__c='WR10374';       
        policy.Unique_Warranty_Registration__c='FUNG';
        insert policy;
        
        WOD_Policy_Dummy__c policy1=policy.clone();
        policy1.PAT_Policy_ExternalId__c='RBE_FIRESCREEN_SFD_2_FUNG_STANDARDAfter_200342';
        policy1.Priority__c=232112;
        policy1.Product_Type_Code__c='RBE.AMD.VXC';
        insert policy1;
        
        List<WOD_Policy_Dummy__c> listPolicy=new List<WOD_Policy_Dummy__c>();
        listPolicy.add(policy);
        listPolicy.add(policy1);
        polIds.add(policy.Id);
        polIds.add(policy1.Id);
            wod_policyUploadBatch obj=new wod_policyUploadBatch();
            DataBase.executeBatch(obj);        
            wod_InsertPolicies ct=new wod_InsertPolicies();
            //ct.queryPolicies(polIds);
        
    }
    /**
     * @description data set up and execution
    */
    static testMethod void methodB() {
        List<Id> polIds = new List<Id>();
        
        WOD_Policy_Dummy__c policy=new WOD_Policy_Dummy__c();
        policy.Building_Type_Application__c='SFD';
        policy.Defect_Code__c='FUNG';
        policy.End_Date__c=system.today();
        policy.Ignore_Defect_Code__c='';
        policy.Market_Family_Code__c='BP06';
        policy.Ownership__c='2';
        policy.PAT_Policy_ExternalId__c='RBE_FIRESCREEN_SFD_2_FUNG_STANDARDAfter_200331';
        policy.Proration_Schedule__c='SFD';
        policy.Start_Date__c=system.today();
        policy.SureStart_Period__c=0;
        policy.Warranty_Period__c=0;
        policy.Product_Type_Code__c='RBE';
        policy.Second_Owner_IN_Surestart__c=0;
        policy.Second_Owner_OUT_Surestart__c=2;       
        policy.Reduction_Factor_MO__c='1/240';
        policy.Maxiumum_Liability__c=35;
        policy.Claim_Type__c='STANDARD';        
        policy.Priority__c=1037412;
        policy.Policy_Active_Y_N__c='Y';
        policy.WR_External_Id__c='WR10374';       
        policy.Unique_Warranty_Registration__c='FUNG';
        insert policy;
        
        WOD_Policy_Dummy__c policy1=policy.clone();
        policy1.PAT_Policy_ExternalId__c='RBE_FIRESCREEN_SFD_2_FUNG_STANDARDAfter_200342';
        policy1.Priority__c=232112;
        policy1.Product_Type_Code__c='RBE.AMD.VXC';
        insert policy1;
        
        List<WOD_Policy_Dummy__c> listPolicy=new List<WOD_Policy_Dummy__c>();
        listPolicy.add(policy);
        listPolicy.add(policy1);
        polIds.add(policy.Id);
        polIds.add(policy1.Id);                 
        wod_InsertPolicies ct=new wod_InsertPolicies();
        ct.queryPolicies(polIds);
        
    }
}