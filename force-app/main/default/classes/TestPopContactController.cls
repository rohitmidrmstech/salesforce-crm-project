// ==================================================================================
//   Object: TestPopContactController
//  Company: Certainteed Siding
//   Author: Mohan Kumar (Threshold Inc)
// Comments: Testing of PopContactController class
// ==================================================================================
//  Changes: 2013-05-17 Initial version.
// ==================================================================================

@isTest
private class TestPopContactController {

    static testMethod void myUnitTest1() {
        //Account a1 = TestCaseUtil.sampleAccount('Test Account1');
        Account a1 = new Account();
        a1.Name = 'Test Account1';
        a1.Short_Name__c = 'TA';
        insert a1;
        
        //Contact c1 = TestCaseUtil.sampleContact('Tcontact', a1.Id);
        Contact c1 = new Contact();
        c1.LastName = 'Tcontact';
        c1.AccountId = a1.Id;
        c1.Phone = '9999900000';
        insert c1;
        
        Apexpages.currentPage().getParameters().put('ANI', '9999900000');
        PopContactController_Siding pcc = new PopContactController_Siding();
        pcc.autoRun();
        if(pcc.contList.size() == 0) {
            PopContactController_Siding.PopContactWrapper pcw = new PopContactController_Siding.PopContactWrapper();
            pcw.isSelected = true;
            pcw.rIndex = 0;
            pcw.cont = c1;
            pcc.contList.add(pcw);
        }
        if(pcc.contList.size() > 0) {
            Apexpages.currentPage().getParameters().put('rowIndex', '0');
            pcc.fetchOpenCases();
            pcc.newCase();
        }
    }
    
    static testMethod void myUnitTest2() {
        //Account a1 = TestCaseUtil.sampleAccount('Test Account1');
        Account a1 = new Account();
        a1.Name = 'Test Account1';
        a1.SAP_ACCOUNT__c = '123';
        a1.AccountNumber = '123';
        a1.Short_Name__c = 'TA';
        insert a1;
        
        //Contact c1 = TestCaseUtil.sampleContact('Tcontact', a1.Id);
        Contact c1 = new Contact();
        c1.LastName = 'Tcontact';
        c1.AccountId = a1.Id;
        c1.Phone = '9999900000';
        insert c1;
        
        //Case c = TestCaseUtil.sampleCase();
        Case c = new Case();
        c.Reason = 'FRD Credits';
        //c.Type = 'Wrong Material Disposition';
        c.Status = 'New';
        c.Origin = 'Email';
        c.AccountId = a1.Id;
        c.ContactId = c1.Id;
        insert c;
        
        Apexpages.currentPage().getParameters().put('ANI', '9999900000');
        PopContactController_Siding pcc = new PopContactController_Siding();
        pcc.autoRun();
        if(pcc.contList.size() == 0) {
            PopContactController_Siding.PopContactWrapper pcw = new PopContactController_Siding.PopContactWrapper();
            pcw.isSelected = true;
            pcw.rIndex = 0;
            pcw.cont = c1;
            pcc.contList.add(pcw);
        }
        if(pcc.contList.size() > 0) {
            Apexpages.currentPage().getParameters().put('rowIndex', '0');
            pcc.fetchOpenCases();
        }
        if(pcc.caseList.size() == 0) {
            PopContactController_Siding.PopContactWrapper pcw = new PopContactController_Siding.PopContactWrapper();
            pcw.isSelected = true;
            pcw.rIndex = 0;
            pcw.cse = c;
            pcc.caseList.add(pcw);
        }
        if(pcc.caseList.size() > 0) {
            Apexpages.currentPage().getParameters().put('rowIndex', '0');
            pcc.editCase();
        }
    }
    
    static testMethod void myUnitTest3() {
        PopContactController_Siding pcc = new PopContactController_Siding();
        pcc.autoRun();
        
    }
}