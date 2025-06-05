// ==================================================================================
//   Object: TestaiContact
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Test of aiContact trigger.
// ==================================================================================
//  Changes: 2013-05-06 Initial version.
// ==================================================================================

@isTest
private class TestaiContact {

    static testMethod void myUnitTest() {
        User u1 = TestCaseUtil.sampleUser();
        
        Account a1;
        System.runAs(u1) {
            a1 = TestCaseUtil.sampleAccount('Test Account1');
        }
        
        Case c = TestCaseUtil.sampleCase();
        c.AccountId = a1.Id;
        c.SuppliedName = 'Test Cont Name';
        c.SuppliedEmail = 'testcont@test.com';
        //c.CurrencyIsoCode='USD';
        c.Status='New';
        c.Origin='Email';
        insert c;
        
        Schema.DescribeSObjectResult contObj = Schema.SObjectType.Contact; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = contObj.getRecordTypeInfosByName();
        String sidingRType;
        if(rtMapByName.get('CertainTeed Contact') != null) {
            sidingRType = rtMapByName.get('CertainTeed Contact').getRecordTypeId();
        }
        Contact cont = new Contact();
        cont.Firstname = 'Test Cont Name';
        cont.LastName = 'Test Cont Name';
        cont.Email = 'testcont@test.com';
        cont.AccountId = a1.Id;
        cont.RecordTypeId = sidingRType;
        insert cont;
        
    }
}