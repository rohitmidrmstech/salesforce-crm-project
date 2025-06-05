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
private class TestRegionTMPopulate {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        test.starttest();
        
         // Create Region
        Region__c r = new Region__c(Name='Southeast', Zip_Code__c='73455', TM__c='99');
        insert r;
        
        for(User u : [Select Id,Name,User_Territory_Code__c from User Where User_Territory_Code__c =: r.TM__c  and isActive = true ]){
            r.TM_Name__c = u.Name;
        }
        
         for(Region__c acc: [Select Id,TM__c, TM_Name__c From Region__c Where Id = : r.Id ]) {
        	system.assertEquals(acc.TM_Name__c, r.TM_Name__c);
        }
        
        test.stoptest();
    }
}