/************************
 Creadted by : Kritika Bhati
 Created Date : 27/7/2017
 Description : Test class for aiuCreateCaseVOC S-490569
 
 ***********************/

@isTest
public class aiuCreateCaseVOCTest {


    static testMethod void testCaseTrigger(){
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        
        Id rtId = [Select Id from RecordType where sObjectType='Case' and Name='General Call'].Id;
        Case cs = new Case();
        cs.RecordTypeId = rtId;
        cs.Campaign__c = 'MECH';
        insert cs;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Account__c = a.Id;
        voc.Meeting_Date__c = System.today();
        voc.Cases_id__c = cs.Id;
        voc.City_State__c = 'ajmer';
        insert voc;
        
        cs.Category__c = 'Test';
        update cs;
        
    }

}