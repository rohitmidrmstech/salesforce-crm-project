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
private class Opportunities_Triggers_Test {

    static testMethod void TriggerTest(){
        
            try{
            
                Opportunity x = new  Opportunity();
                x.name = 'testing-trigger';
                //x.project_stage__c = 'Planning';
                x.project_stage_ins__c = 'Planning';
                x.Project_Start_Date__c = Date.today();
                x.CloseDate = Date.today();
                X.StageName = 'Tender Stage';
                x.RecordTypeId =  Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Insulation').getRecordTypeId();
                
                User u = [select id from User limit 1];
                x.Assigned_TM_User__c = u.id;
                
                insert x;
                System.debug('*** Record Type: ' + x.RecordTypeId);
        
            }catch(exception e){
            System.debug(e);}
    }
}