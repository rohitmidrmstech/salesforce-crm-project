// ==================================================================================
//   Object: TestOnlineFormController
//  Company: Threshold
//   Author: Mohan Kumar (Threshold)
// Comments: Test converage for OnlineFormController class
// ==================================================================================
//  Changes: 2014-01-30 Initial version.
// ==================================================================================

@isTest
private class TestOnlineFormController {

    static testMethod void myUnitTest1() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController obj = new OnlineFormController(new Apexpages.Standardcontroller(oForm));
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
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
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
        
        obj = new OnlineFormController(new Apexpages.Standardcontroller(oForm));
    }
    
    static testMethod void myUnitTest2() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController obj = new OnlineFormController(new Apexpages.Standardcontroller(oForm));
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
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.saveOnlineForm();
    }
    
    static testMethod void myUnitTest3() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController obj = new OnlineFormController(new Apexpages.Standardcontroller(oForm));
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
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
        Apexpages.currentPage().getParameters().put('captchaResult', 'true');
        obj.saveButton();
    }
    
    static testMethod void myUnitTest4() {
        
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController obj = new OnlineFormController(new Apexpages.Standardcontroller(oForm));
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
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
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
        Account acc = new Account();
        acc.Name = 'Test AccountName';
        acc.BillingStreet = 'Test';
        acc.BillingCity = 'Lewiston';
        acc.BillingState = 'New York';
        acc.BillingPostalCode = '10254';
        for(RecordType rt : [Select id From RecordType Where Name = 'US Speciality Account' AND sObjectType = 'Account' Limit 1]){
            acc.RecordTypeId = rt.Id;
        }
        
        insert acc;
        Contact c = new Contact();
        c.LastName = 'Dodge Contact';
        c.AccountId = acc.Id;
        c.Phone = '012365487';
        c.Email = 'test@test.com';
        for(RecordType rt : [Select id From RecordType Where Name = 'Gypsum Canada Contact' AND sObjectType = 'Contact' Limit 1]){
            c.RecordTypeId = rt.Id;
        }
        insert c;
        Lead l = new Lead(LastName = 'Test',Company = 'Testing');
        insert l;
        Opportunity o = new Opportunity(Name = 'Test', StageName = 'Test', CloseDate = System.Today());
        insert o;
        Event e = new Event(DurationInMinutes = 35,ActivityDateTime = System.now());
        insert e;
        Task t = new Task();
        //insert t;
        Online_Form__c oForm = new Online_Form__c();
        OnlineFormController obj = new OnlineFormController(new Apexpages.Standardcontroller(oForm));
        obj.resumeAfterNo();
        WTUNote w = new WTUNote();
        List<WTUNote> listWTU = new List<WTUNote>();
        Weekly_Territory_Update__c  wtu = new Weekly_Territory_Update__c();
        insert wtu;
        WTU_Note__c wn = new WTU_Note__c(Special_Topic__c = 'Test',WTU__c = wtu.Id);
        insert wn;
        VOC_Data_Entry__c  vde = new VOC_Data_Entry__c(WTU_Note__c = wn.Id, Category__c = 'Products');
        insert vde;
        try{
        VOCUtil.addVOCLine(listWTU, wn.Id, 'Products', 1);
        VOCUtil_Siding.addVOCLine(listWTU, wn.Id, 'Products', 1);
        } catch (Exception ex){}
        
        VOCUtil.prepareMarketFamily('Bufftech');
        VOCUtil.prepareMarketFamily('WeatherBoards');
        VOCUtil.prepareMarketFamily('Restoration Milwork');
        VOCUtil.prepareMarketFamily('Rail');
        VOCUtil.prepareMarketFamily('Other Material/Category');
        VOCUtil.prepareMarketFamily('CertainTeed/Wolverine brand - Vinyl Panel');
        VOCUtil.prepareMarketFamily('Norandex brand - Vinyl Panel');
        VOCUtil.prepareMarketFamily('CertainTeed/Wolverine brand - Vinyl Accessory');
        VOCUtil.copyNotes(c.Id,wn);
        VOCUtil.copyNotes(o.Id,wn);
        VOCUtil.copyNotes(l.Id,wn);
        VOCUtil.copyNotes(e.Id,wn);
        VOCUtil.copyNotes(t.Id,wn);
        VOCUtil_Siding.copyNotes(c.Id,wn);
        VOCUtil_Siding.copyNotes(o.Id,wn);
        VOCUtil_Siding.copyNotes(l.Id,wn);
        VOCUtil_Siding.copyNotes(e.Id,wn);
        VOCUtil_Siding.copyNotes(t.Id,wn);
        VOCLine  volin = new VOCLine();
        volin.vocEntry = vde;
        List<VOCLine> listOfVOC = new List<VOCLine>();
        listOfVOC.add(volin);
        //VOCUtil_Siding.clearLineItems(listOfVOC);
       // VOCUtil_Siding.addVOCLine(listWTU,wn.Id,'Products', 1);
        
        VOCUtil_Siding vocs = new VOCUtil_Siding ();
        //vocs.
        VOC_Data_Entry_Temp__c  vdetemp = new VOC_Data_Entry_Temp__c(Record_Id__c = vde.Id);
        insert vdetemp;
        List<VOC_Data_Entry_Temp__c> productVOCs = new List<VOC_Data_Entry_Temp__c>();
        productVOCs.add(vdetemp);
        VOCUtil.loopVariables(listOfVOC,productVOCs,0);
        for(VOC_Data_Entry_Temp__c  vtemp : productVOCs){
           vtemp.Record_Id__c = null;
        }
        VOCUtil.loopVariables(listOfVOC,productVOCs,0);
        VOCUtil_Siding.loopVariables(listOfVOC,productVOCs,0);
        VOCUtil_Siding.findWTU(vde.ownerId);
                
        VOCUtil_Siding.prepareMarketFamily('Bufftech');
        VOCUtil_Siding.prepareMarketFamily('WeatherBoards');
        VOCUtil_Siding.prepareMarketFamily('Restoration Milwork');
        VOCUtil_Siding.prepareMarketFamily('Rail');
        VOCUtil_Siding.prepareMarketFamily('Other Material/Category');
        VOCUtil_Siding.prepareMarketFamily('CertainTeed/Wolverine brand - Vinyl Panel');
        VOCUtil_Siding.prepareMarketFamily('Norandex brand - Vinyl Panel');
        VOCUtil_Siding.prepareMarketFamily('CertainTeed/Wolverine brand - Vinyl Accessory');
        VOCUtil_Siding.prepareMarketFamily('CertainTeed Accessories');
        VOCUtil_Siding.prepareMarketFamily('Vytec Panels');
        VOCUtil_Siding.prepareMarketFamily('Norandex Panels');
        VOCUtil_Siding.prepareMarketFamily('CertainTeed Panels');
        
        VOCUtil_Siding.prepareBrand('Panel');
        VOCUtil_Siding.prepareBrand('Soffit');
        VOCUtil_Siding.prepareBrand('Accessory');
        VOCUtil_Siding.prepareBrand('Deck');
        VOCUtil_Siding.prepareBrand('Rail');
        VOCUtil_Siding.prepareBrand('Housewrap');
        VOCUtil_Siding.prepareBrand('Other Material/Category');
        VOCUtil_Siding.prepareBrand('Fence');
        VOCUtil_Siding.prepareBrand('PVC Trim');
        VOCUtil_Siding.prepareBrand('Panel - Polymer');
        VOCUtil_Siding.prepareBrand('FiberCement');
        VOCUtil_Siding.prepareBrand('Roofing');
    }
}