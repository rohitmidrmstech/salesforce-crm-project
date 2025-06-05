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
private class Test_CustomLookUpController {
/**
 *  Purpose         :   This class is used to cover logic of CustomLookUpController.
 *
 *  Created By      :   Padmesh Soni (Appirio Offshore)
 *
 *  Created Date    :   11/7/2017
 *
 *  Current Version :   V_1.0
 *
 *  Revision Log    :   V_1.0 - Created - S-523609
 
 *  Modified by:  Jesse Brown - Case 00221057 - Test was looking for users which failed when system admin had same first name as an active user.  Changed User test and added asserts to check for selective querying for accounts.  Added comments.
 **/
 
    @testSetup static void setupData() {
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();       
        List<Account> sold_To_Accts = new List<Account>();
        for(Integer i=0;i<100;i++) {
            Account act = new Account();
            act.Name = 'TestAcct'+i;
            act.BillingStreet ='Test Address' + i;
            act.BillingCity = 'Houston';
            act.BillingState = 'TX';
            act.BillingCountry ='United States';
            act.BillingPostalCode = '77002';
            act.RecordTypeId = recordTypeId;
            act.SAP_ACCOUNT__c = 'TST' + i;
            //act.Hierarchy_Level_BPCS__c = '4-Sold To';
            act.Status__c= 'Active';
            sold_To_Accts.add(act);
        }
        insert sold_To_Accts;
    }
    @isTest static void testfetchLookUpValues(){   
        customLookUpController.fetchLookUpValues('TST', 'SAP_ACCOUNT__c, Name', ',BillingCity', 'SAP_ACCOUNT__c, Name', 'Hierarchy_Level_BPCS__c = \'4-Sold To\' AND Status__c= \'Active\'', 'Name', 'Account', false);
    }
    @isTest static void testfetchLookUpValues_Globalsearch(){    
        customLookUpController.fetchLookUpValues('TST', 'SAP_ACCOUNT__c, Name', ',BillingCity', 'SAP_ACCOUNT__c, Name', 'Hierarchy_Level_BPCS__c = \'4-Sold To\' AND Status__c= \'Active\'', 'Name', 'Account', true);
    } 
}