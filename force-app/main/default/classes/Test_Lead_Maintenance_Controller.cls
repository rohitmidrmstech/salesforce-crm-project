/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_Lead_Maintenance_Controller {

    //Attributes
    static List<Lead> selectedLeads;
    static Lead_Maintenance_Controller controller;
    
    static void InitializeLeads(){

        selectedLeads = new List<Lead>();
        
        for(Integer i = 0;i<10;i++){
            
            Lead newlead = new Lead(Company='Test Unit Company '+i,LastName='Test Last Name '+i,Status='Qualified');
            selectedLeads.add(newlead);
        }
        
        insert selectedLeads;
    }
    
    static void SetFieldSelection(String sField,String sValue){
        
        controller.selop=sField;
        
        if(sField != 'None')
            controller.dummyLead.put(sField,sValue);
    }
    
    static testMethod void TestMaintenanceControllerInitWithSelection() {

        PageReference pageRef;// = Page.Lead_Maintenance;
        //Test.setCurrentPageReference(pageRef);
                
        InitializeLeads();
        
        ApexPages.StandardSetController StdSetController = new ApexPages.StandardSetController(selectedLeads);
        StdSetController.setSelected(selectedLeads);
        
        controller = new Lead_Maintenance_Controller(StdSetController);
        
        List<Lead> lSelectedLeads = controller.getSelectedLeads();
        controller.avoidRefresh();
        
        SetFieldSelection('Notes__c','Testing Group Change in Notes');
        controller.changeField();
        SetFieldSelection('None','Foo');
        controller.changeField();               
    }

    static testMethod void TestMaintenanceControllerInitWithOutSelection() {

        PageReference pageRef;// = Page.Lead_Maintenance;
        //Test.setCurrentPageReference(pageRef);
                
        InitializeLeads();
        
        ApexPages.StandardSetController StdSetController = new ApexPages.StandardSetController(selectedLeads);
        controller = new Lead_Maintenance_Controller(StdSetController);
        
        List<Lead> lSelectedLeads = controller.getSelectedLeads();
        controller.avoidRefresh();
        
        SetFieldSelection('Notes__c','Testing Group Change in Notes');
        controller.changeField();
        SetFieldSelection('None','Foo');
        controller.changeField();           
    }

    static testMethod void TestMaintenanceControllerUpdate() {

        PageReference pageRef;// = Page.Lead_Maintenance;
        //Test.setCurrentPageReference(pageRef);
                
        InitializeLeads();
        
        ApexPages.StandardSetController StdSetController = new ApexPages.StandardSetController(selectedLeads);
        StdSetController.setSelected(selectedLeads);
        
        controller = new Lead_Maintenance_Controller(StdSetController);
        
        List<Lead> lSelectedLeads = controller.getSelectedLeads();
        controller.avoidRefresh();
        
        SetFieldSelection('Notes__c','Testing Group Change in Notes');
        controller.changeField();
        controller.updateRecords();
    }

    static testMethod void TestMaintenanceControllerDelete() {

        PageReference pageRef;// = Page.Lead_Maintenance;
        //Test.setCurrentPageReference(pageRef);
                
        InitializeLeads();
        
        ApexPages.StandardSetController StdSetController = new ApexPages.StandardSetController(selectedLeads);
        StdSetController.setSelected(selectedLeads);
        
        controller = new Lead_Maintenance_Controller(StdSetController);
        
        controller.deleteRecords();
    }
}