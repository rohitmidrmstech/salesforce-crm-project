@isTest
public class ZipToFIPSTerritoryControllerTest {
    @isTest private static void testController() {
        Test.setCurrentPage(Page.ZipToFIPSTerritoryPage);
        ZipToFIPSTerritoryController controller = new ZipToFIPSTerritoryController();
        
        Test.startTest();
            controller.zipCode = '19020';
            controller.showCity();
        
            controller.zipCode = '0000';
            controller.showCity();
            
            controller.zipCode = null;
            controller.showCity();
        
            controller.showTerryid = null;
            controller.showTerritory();
        controller.salesOrgValue = '1103';
        controller.getTypeDivision();
            
            controller.getSalesOrg();
        Test.stopTest();
    }
    
    @testSetup private static void createTestData() {
        FIPS__c fips = new FIPS__c(Name = 'BUCKS - Pennsylvania - USA', 
                                   Country__c = 'USA', 
                                   County__c = 'BUCKS', 
                                   FIPS_Code__c = '42017', 
                                   State__c = 'Pennsylvania');
        insert fips;
        
        Zip_to_Fips__c ztf = new Zip_to_Fips__c(Name = '19020', 
                                                City__c = 'EDDINGTON',
                                                State_Code__c = 'PA',
                                                FIPS_Code_Name__c = fips.Id);
        insert ztf;
        
        Territory__c terr = new Territory__c(Name = 'IG TECH 2244', 
                                             Territory_Code__c = 'TIM2244',
                                             Sales_Org__c = '1503',
                                             SAP_TM_Name__c = 'Test, User',
                                             SAP_TM_Number__c = '0000013033',
                                             Sales_Rep__c = UserInfo.getUserId());
        insert terr;
        
        Territory_Assignment__c terrAssign = new Territory_Assignment__c(IGSBU__c = 'MECH', 
                                                                         Territory__c = terr.Id, 
                                                                         FIPS__c = fips.Id);
        insert terrAssign;
    }
}