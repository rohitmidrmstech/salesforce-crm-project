// ==================================================================================
//   Object: TestOnlineFormController
//  Company: Threshold
//   Author: Mohan Kumar (Threshold)
// Comments: Test converage for OnlineFormController class
// ==================================================================================
//  Changes: 2014-01-30 Initial version.
// ==================================================================================

@isTest
private class TestOnlineFormController_Siding {

    static testMethod void myUnitTest1() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController_Siding obj = new OnlineFormController_Siding(new Apexpages.Standardcontroller(oForm));
        obj.addProductLine();
        obj.addSalesLine();
        obj.addServiceLine();
        obj.addOtherLine();
        System.currentPageReference().getParameters().put('rIndex', '0');
        obj.removeProductLine();
        obj.removeSalesLine();
        obj.removeServiceLine();
        obj.removeOtherLine();
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.getProductFamily();
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.getBrand();
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
        obj.getProductFamily();
        obj.productLineList[0].vocEntry.Market_Family__c = 'EverNew LT';
        obj.getMarketSegment();
                
        oForm = new Online_Form__c();
        oForm.Information_Source__c = '1 on 1';
        oForm.Region__c = 'Canada';
        oForm.First_Name__c = 'test';
        oForm.Last_Name__c = 'test';
        oForm.Audience__c = 'Retail';
        oForm.Department__c = 'Other';
        insert oForm;
        
        obj = new OnlineFormController_Siding(new Apexpages.Standardcontroller(oForm));
    }
    
    static testMethod void myUnitTest2() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController_Siding obj = new OnlineFormController_Siding(new Apexpages.Standardcontroller(oForm));
        obj.onlineForm.Information_Source__c = '1 on 1';
        obj.onlineForm.Region__c = 'Canada';
        obj.onlineForm.First_Name__c = 'test';
        obj.onlineForm.Last_Name__c = 'test';
        obj.onlineForm.Audience__c = 'Retail';
        obj.onlineForm.Department__c = 'Other';
        obj.productLineList[0].vocEntry.What__c = 'Change';
        Apexpages.currentPage().getParameters().put('captchaResult', 'false');
        obj.saveOnlineForm();
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.saveOnlineForm();
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.saveOnlineForm();
    }
    
    static testMethod void myUnitTest3() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController_Siding obj = new OnlineFormController_Siding(new Apexpages.Standardcontroller(oForm));
        obj.onlineForm.Information_Source__c = '1 on 1';
        obj.onlineForm.Region__c = 'Canada';
        obj.onlineForm.First_Name__c = 'test';
        obj.onlineForm.Last_Name__c = 'test';
        obj.onlineForm.Audience__c = 'Retail';
        obj.onlineForm.Department__c = 'Other';
        obj.productLineList[0].vocEntry.What__c = 'Change';
        Apexpages.currentPage().getParameters().put('captchaResult', 'false');
        obj.saveButton();
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.saveButton();
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.saveButton();
    }
    
    static testMethod void myUnitTest4() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController_Siding obj = new OnlineFormController_Siding(new Apexpages.Standardcontroller(oForm));
        obj.onlineForm.Information_Source__c = '1 on 1';
        obj.onlineForm.Region__c = 'Canada';
        obj.onlineForm.First_Name__c = 'test';
        obj.onlineForm.Last_Name__c = 'test';
        obj.onlineForm.Audience__c = 'Retail';
        obj.onlineForm.Department__c = 'Other';
        obj.productLineList[0].vocEntry.What__c = 'Change';
        Apexpages.currentPage().getParameters().put('captchaResult', 'false');
        obj.updateTempObj();
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.updateTempObj();
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.saveButton();
        
        
        Online_Form_Temp__c objTemp = new Online_Form_Temp__c ();
        objTemp.Information_Source__c = '1 on 1';
        objTemp.Region__c = 'Canada';
        objTemp.First_Name__c = 'test';
        objTemp.Last_Name__c = 'test';
        objTemp.Audience__c = 'Retail';
        objTemp.Department__c = 'Other';
        //objTemp.productLineList[0].vocEntry.What__c = 'Change';
        obj.addProductLine();
        obj.addSalesLine();
        obj.addServiceLine();
        obj.addOtherLine();
        System.currentPageReference().getParameters().put('rIndex', '0');
        obj.removeProductLine();
        obj.removeSalesLine();
        obj.removeServiceLine();
        obj.removeOtherLine();
        Apexpages.currentPage().getParameters().put('captchaResult', 'false');
        obj.saveButton();
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.saveButton();
        
         obj.onlineForm.Information_Source__c = objTemp.Information_Source__c;
         obj.onlineForm.Region__c = objTemp.Region__c;
         obj.onlineForm.First_Name__c = objTemp.First_Name__c;
         obj.onlineForm.Audience__c = objTemp.Audience__c;
         obj.onlineForm.Department__c = objTemp.Department__c;
         obj.updateTempObj();
         obj.discardMethod();
         obj.saveButton();
          
    }
    
    static testMethod void myUnitTest5() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController_Siding obj = new OnlineFormController_Siding(new Apexpages.Standardcontroller(oForm));
        obj.resumeAfterNo();
          
    }

}