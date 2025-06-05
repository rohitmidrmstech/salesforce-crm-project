@isTest
public class OneClickCaseCloseControllerTest{
    public static testMethod void testMethod1() {       
        Case cs = new Case( Subject = 'Test', Campaign__c = 'MECH' , Type = 'General Call');  
        insert cs;
       
        OneClickCaseCloseController obj = new OneClickCaseCloseController ( new ApexPages.StandardController( cs ) );  
        //obj.caseId = '5000q000005VgU9AAK'; Insert case and get the id here
        obj.caseId = cs.id;
        obj.updateCaseStatus();
    }
}