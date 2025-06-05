/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test for Product object Trigger. 
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Vincent Ip (vip@liquidhub.com)
* @version      1.0
* @created      2017-08-08
*
* NOTE : the Trigger REQUIRES that a Standard Price Book exists. 
* (i.e. any price book marked with the "Is Standard Price Book" check box on)
*/
@isTest
private class CT_Product2TriggerHandlerTest {
    @TestSetup
    static void init(){

        /*CT_Common_Settings__c config = new CT_Common_Settings__c(
            Force_PriceBookEntry_Create_on_Update__c = true
        );
        insert config;*/
        
         Profile p = [select id from profile where name='System Administrator'];
    
       User u = new User(alias = 'standt', email='noEmail@testorg.com',emailencodingkey='UTF-8', lastname='Testo', 
       languagelocalekey='en_US', localesidkey='en_US', profileid = p.Id, timezonesidkey='America/Los_Angeles', 
       username='MrTestUser@testorg.com1');

        Plants__c newPlant0 = new Plants__c(Name='TestPlant0', SAP_Plant__c='0600',Plant_Manager__c = u.id);
        insert newPlant0; 
        Plants__c newPlant1 = new Plants__c(Name='TestPlant1', SAP_Plant__c='0601',Plant_Manager__c = u.id);
        insert newPlant1;
        //insert new Plants__c[]{ newPlant0, newPlant1 };
    }

    @isTest
    static void testTrigger(){
   
        Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing1232324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c='0600';
        insert Testingplant1;
        
        
        product2 nProduct = new product2();
        nProduct.name='Test Product';
        nProduct.productCode = 'labor3456';
        nProduct.Plants__c ='Apex Plant';
        nProduct.ApprovingPlant__c =Testingplant1.id;
        nProduct.Plant_Names__c='GYP Amaranth Mine, MB';
        insert nProduct; 
        system.debug('@@'+nProduct.id);
            
            //update newProduct;

        // check plant translation worked
        Product2 newProduct = [SELECT id, Plant_Names__c,ApprovingPlant__c  from Product2 where id =:nProduct.Id];
        //System.assertEquals('GYP Amaranth Mine, MB', newProduct.Plant_Names__c);


        // check the trigger creates a PriceBookEntry
        List<PriceBookEntry> pbeList = [Select Id from PriceBookEntry];
        System.assertEquals(1, pbeList.size());


        // check that an update will also create one (the settings are forcing this action)
        delete pbeList;


        newProduct.Plants__c = '0601';
        update newProduct;


        // check plant translation worked on update
        newProduct = [SELECT id, Plant_Names__c,ApprovingPlant__c  from Product2 where id =:newProduct.Id];
        System.assertEquals('TestPlant1', newProduct.Plant_Names__c);


        // check the trigger creates a PriceBookEntry
        pbeList = [Select Id from PriceBookEntry];
        //System.assertEquals(1, pbeList.size());
    }
}