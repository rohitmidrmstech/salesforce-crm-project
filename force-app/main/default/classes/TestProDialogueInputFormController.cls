// ==================================================================================
//   Object: TestWTUNoteController
//  Company: Threshold
//   Author: Mohan Kumar (Threshold)
// Comments: Test converage for ProDialogueInputFormController class
// ==================================================================================
//  Changes: 2014-01-30 Initial version.
// ==================================================================================

@isTest
private class TestProDialogueInputFormController {

    /*static testMethod void myUnitTest1() {
        ProDialogue_Input__c dialog = new ProDialogue_Input__c();
        ProDialogueInputFormController obj = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));
        obj.addProductLine();
        obj.addSalesLine();
        obj.addServiceLine();
        obj.addOtherLine();
        obj.addAttendee();
        System.currentPageReference().getParameters().put('rIndex', '0');
        obj.removeProductLine();
        obj.removeSalesLine();
        obj.removeServiceLine();
        obj.removeOtherLine();
        obj.removeAttendee();
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.getProductFamily();
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.getBrand();
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
       
        obj.productLineList[0].vocEntry.Market_Family__c = 'EverNew LT';
        obj.getMarketSegment();
        obj.facilitator = 'john';
        obj.tm = 'john';
        obj.searchFacilitator();
        obj.searchTM();
        obj.resetFacilitator();
        obj.resetTM();
        //obj.resetUserPanel(showUserSearchPanel, usersFound);
        obj.resetMessageFlag();
        
        dialog = new ProDialogue_Input__c();
        dialog.Meeting_Date__c = Date.today();
        dialog.City_State__c = 'ab, cd';
        dialog.Facilitator__c = Userinfo.getUserId();
        dialog.TM__c = Userinfo.getUserId();
        dialog.Information_Source__c = '1 on 1';
        dialog.Region__c = 'Canada';
        dialog.Audience__c = 'Retail';
        insert dialog;
        
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
        ProDialogue_Input_Attendee__c pAttendee = new ProDialogue_Input_Attendee__c();
        pAttendee.ProDialogue_Input__c = dialog.Id;
        pAttendee.Role__c = 'Other';
        pAttendee.Lead__c = l.id;
        pAttendee.Contact__c = c.Id;
        pAttendee.Account__c = acc.Id;
        insert pAttendee;
        obj.proDialogue.Sales_Role__c = 'TM';
        obj.proDialogue.Information_Source__c = 'Test';
        for(ProDialogueInputFormController.Attendee att : obj.attendeeList) {
            att.selAttendeeType = 'Account';
            att.attendeeValue.Account__c = acc.Id;
        }
        obj.saveProdialogue();
        obj = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));
    }
    */
    static testMethod void myUnitTest2() {
        ProDialogue_Input__c dialog = new ProDialogue_Input__c();
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
        ProDialogueInputFormController obj = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));
        for(ProDialogueInputFormController.Attendee att : obj.attendeeList) {
            att.selAttendeeType = 'Account';
            att.attendeeValue.Account__c = acc.Id;
        }
        obj.saveProDialogue();
        
        /*for(ProDialogueInputFormController.Attendee att : obj.attendeeList) {
            att.selAttendeeType = 'Contact';
            att.attendeeValue.Account__c = c.Id;
        }
        obj.saveProDialogue();
        
        for(ProDialogueInputFormController.Attendee att : obj.attendeeList) {
            att.selAttendeeType = 'Lead';
            att.attendeeValue.Account__c = l.Id;
        }
        obj.saveProDialogue();*/
        //CF S-490560 Start
        dialog.Meeting_Date__c = Date.today();
        dialog.City_State__c = 'ab, cd';
        dialog.Facilitator__c = Userinfo.getUserId();
        dialog.TM__c = Userinfo.getUserId();
        dialog.Information_Source__c = '1 on 1';
        dialog.Region__c = 'Canada';
        dialog.Audience__c = 'Retail';
        dialog.Sales_Role__c = 'SAM';
        insert dialog;
        ProDialogue_Input_Attendee__c pAttendee = new ProDialogue_Input_Attendee__c();
        pAttendee.ProDialogue_Input__c = dialog.Id;
        insert pAttendee;
        for(ProDialogueInputFormController.Attendee att : obj.attendeeList) {
            att.proDialogueAttendee = pAttendee;
        }
        VOC_Input_Form_Temp__c vift = new VOC_Input_Form_Temp__c(city_state__c = 'Temp', Meeting_Date__c = System.today(), User_Id__c = Userinfo.getUserId());
        insert vift;
        
        VOC_Data_Entry_Temp__c vdet1 = new VOC_Data_Entry_Temp__c(Topic__c = 'Board', Product_Family__c = 'Test', Market_Family__c = 'Test', Brand__c = 'Test', Product_Line__c = 'test', VOC_Input_Temp_Form__c = vift.Id);
        VOC_Data_Entry_Temp__c vdet2 = new VOC_Data_Entry_Temp__c(Topic__c = 'Finishing', Product_Family__c = 'Test', Market_Family__c = 'Test', Brand__c = 'Test', Product_Line__c = 'test', VOC_Input_Temp_Form__c = vift.Id);
        VOC_Data_Entry_Temp__c vdet3 = new VOC_Data_Entry_Temp__c(Topic__c = 'Both', Product_Family__c = 'Test', Market_Family__c = 'Test', Brand__c = 'Test', Product_Line__c = 'test', VOC_Input_Temp_Form__c = vift.Id);
        List<VOC_Data_Entry_Temp__c> vdetList = new List<VOC_Data_Entry_Temp__c>{vdet1, vdet2, vdet3};
        insert vdetList;

        VOC_Input_Temp_Form_Attendee__c vitfa1 = new VOC_Input_Temp_Form_Attendee__c(Contact__c = c.Id, VOC_Input_Temp_Form__c = vift.Id);
        VOC_Input_Temp_Form_Attendee__c vitfa3 = new VOC_Input_Temp_Form_Attendee__c(Lead__c = l.Id, VOC_Input_Temp_Form__c = vift.Id);
        VOC_Input_Temp_Form_Attendee__c vitfa4 = new VOC_Input_Temp_Form_Attendee__c(Account__c = acc.Id, VOC_Input_Temp_Form__c = vift.Id);
        VOC_Input_Temp_Form_Attendee__c vitfa2 = new VOC_Input_Temp_Form_Attendee__c(Account__c = acc.Id, Lead__c = l.Id, VOC_Input_Temp_Form__c = vift.Id, Contact__c = c.Id, Record_Id__c = String.valueOF(pAttendee.id));
        List<VOC_Input_Temp_Form_Attendee__c> inputAttendeelist = new LIst<VOC_Input_Temp_Form_Attendee__c>{vitfa1, vitfa2,vitfa3,vitfa4};
        insert inputAttendeelist;
        obj.proDialogue = dialog;
        obj.updateTempObj();
        obj.proDialogue.Sales_Role__c = 'Customer Service';
        obj.updateTempObj();
        obj.proDialogue.Sales_Role__c = 'Tech Services';
        //CF S-490560 End 
        obj.updateTempObj();
        obj.proDialogue.Meeting_Date__c = Date.today();
        obj.proDialogue.City_State__c = 'ab, cd';
        obj.proDialogue.Facilitator__c = Userinfo.getUserId();
        obj.proDialogue.TM__c = Userinfo.getUserId();
        obj.proDialogue.Information_Source__c = '1 on 1';
        obj.proDialogue.Region__c = 'Canada';
        obj.proDialogue.Audience__c = 'Retail';
        obj.saveProDialogue();
        obj.facilitatorId = Userinfo.getUserId();
        obj.tmId = Userinfo.getUserId();
        
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
        obj.saveProDialogue();
        obj.saveButton();
    }
    
     static testMethod void myUnitTest3() {
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
        VOC_Input_Form_Temp__c dialog = new VOC_Input_Form_Temp__c();
        ProDialogueInputFormController obj = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));
        for(ProDialogueInputFormController.Attendee att : obj.attendeeList) {
            att.selAttendeeType = 'Contact';
            att.attendeeValue.Contact__c = c.Id;
        }
        obj.saveProDialogue();
        obj.saveButton();
        obj.proDialogue.Meeting_Date__c = Date.today();
        obj.proDialogue.City_State__c = 'ab, cd';
        obj.proDialogue.Facilitator__c = Userinfo.getUserId();
        obj.proDialogue.TM__c = Userinfo.getUserId();
        obj.proDialogue.Information_Source__c = '1 on 1';
        obj.proDialogue.Region__c = 'Canada';
        obj.proDialogue.Audience__c = 'Retail';
        obj.saveButton();
        obj.facilitatorId = Userinfo.getUserId();
        obj.tmId = Userinfo.getUserId();
        
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
        obj.saveButton();
        obj.discardMethod();
    }
  
    static testMethod void myUnitTest4() {
        ProDialogue_Input__c dialog = new ProDialogue_Input__c();
        dialog.Meeting_Date__c = System.today();
        dialog.Meeting_Date__c = Date.today();
        dialog.City_State__c = 'ab, cd';
        dialog.Facilitator__c = Userinfo.getUserId();
        dialog.TM__c = Userinfo.getUserId();
        dialog.Information_Source__c = '1 on 1';
        dialog.Region__c = 'Canada';
        dialog.Audience__c = 'Retail';
        insert dialog;
        Apexpages.currentPage().getParameters().put('sc','1');
        ProDialogueInputFormController obj = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));

        obj.saveProDialogue();
        obj.proDialogue.Meeting_Date__c = Date.today();
        obj.proDialogue.City_State__c = 'ab, cd';
        obj.proDialogue.Facilitator__c = Userinfo.getUserId();
        obj.proDialogue.TM__c = Userinfo.getUserId();
        obj.proDialogue.Information_Source__c = '1 on 1';
        obj.proDialogue.Region__c = 'Canada';
        obj.proDialogue.Audience__c = 'Retail';
        obj.saveProDialogue();
        obj.facilitatorId = Userinfo.getUserId();
        obj.tmId = Userinfo.getUserId();
        
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
        obj.saveProDialogue();
        
        
        VOC_Input_Form_Temp__c dialog2 = new VOC_Input_Form_Temp__c();
       // ProDialogueInputFormController obj1 = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));
        
        
        dialog2.TM__c = Userinfo.getUserId();
        dialog2.User_Id__c = Userinfo.getUserId();
        dialog2.Meeting_Date__c = Date.today();
        dialog2.City_State__c = 'ab, cd';
        dialog2.Facilitator__c = Userinfo.getUserId();
        dialog2.Information_Source__c = '1 on 1';
        dialog2.Record_Id__c = dialog.Id;
        dialog2.Region__c = 'Canada';
        dialog2.Audience__c = 'Retail';
       // dialog1.Record_Id__c = Userinfo.getUserId();
        insert dialog2;
        System.debug('dialog2::'+dialog2);
        
        obj.proDialogue.Meeting_Date__c = dialog2.Meeting_Date__c;
        obj.proDialogue.City_State__c = dialog2.City_State__c;
        obj.proDialogue.Facilitator__c = dialog2.Facilitator__c;
        obj.proDialogue.TM__c = dialog2.TM__c;
        obj.proDialogue.Information_Source__c = dialog2.Information_Source__c;
        obj.proDialogue.Region__c = dialog2.Region__c;
        obj.proDialogue.Audience__c = dialog2.Audience__c;
        String vocInputFormTempId = dialog2.Id;
        System.debug('vocInputFormTempId::'+vocInputFormTempId);
        obj.vocInputFormTemp = dialog2;
        obj.updateTempObj();
        obj.discardMethod();
        obj.facilitatorId = Userinfo.getUserId();
        obj.tmId = Userinfo.getUserId();
        
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.productLineList[0].vocEntry.Brand__c = 'Deck';
        obj.vocInputFormTemp = dialog2;
        obj.updateTempObj();
        
        obj.addProductLine();
        obj.addSalesLine();
        obj.addServiceLine();
        obj.addOtherLine();
        obj.addAttendee();
        System.currentPageReference().getParameters().put('rIndex', '0');
        obj.removeProductLine();
        obj.removeSalesLine();
        obj.removeServiceLine();
        obj.removeOtherLine();
        obj.removeAttendee();    
        VOC_Input_Temp_Form_Attendee__c  pAttendee = new VOC_Input_Temp_Form_Attendee__c ();
        pAttendee.VOC_Input_Temp_Form__c  = dialog2.Id;
        pAttendee.Role__c = 'Host';
        insert pAttendee;  
        //CF S-490560 Start
        VOC_Data_Entry__c  vde = new VOC_Data_Entry__c(Product_Line__c = 'Test', Product_Family__c = 'Test', Brand__c ='Test', Market_Family__c = 'Test', Competitor_Topic__c = 'Test', ProDialogue_Input__c = dialog.Id,Category__c  = 'Products');
        insert vde;
        
        obj.vocInputFormTemp = dialog2;
        obj.updateTempObj();
        ApexPages.currentPage().getParameters().put('id',dialog.Id);
        
        Apexpages.currentPage().getParameters().put('sc',null);
        ProDialogueInputFormController tmpObj = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));
        ApexPages.currentPage().getParameters().put('sc', '1');
        //CF S-490560 End
        ProDialogue_Input_Attendee__c  pia = new ProDialogue_Input_Attendee__c(ProDialogue_Input__c = dialog.Id);
        insert pia;
        obj.discardMethod();
        obj.saveProDialogue();
        obj.uploadAttachment();
        obj.proDialogue.Sales_Role__c = 'SAM';
        obj.getMarketingTopic();
        obj.getSalesTopic();
        for(VOCLine vol : obj.productLineList){
            vol.vocEntry.Topic__c = 'Board';  
        }
        obj.changeSelectoption();
        for(VOCLine vol : obj.productLineList){
            vol.vocEntry.Topic__c = 'Finishing';  
        }
        obj.changeSelectoption();
        for(VOCLine vol : obj.productLineList){
            vol.vocEntry.Topic__c = 'Both';  
        }
        obj.changeSelectoption();
        for(VOCLine vol : obj.productLineList){
            vol.vocEntry.Topic__c = 'Systems';  
        }
        obj.changeSelectoption();
        obj.clearSelectoption();
        obj.getIsSF1();
        obj.getTopic();
        obj.changetopic();
        for(VOCLine vol : obj.productLineList){
            vol.vocEntry.Category__c = 'Marketing';  
        }
        obj.changetopic();
        for(VOCLine vol : obj.productLineList){
            vol.vocEntry.Category__c = 'Sales & Service';  
        }
        obj.changetopic();
        obj.getProDialogueRegion();
    }
    
    static testMethod void myUnitTest5() {
        ProDialogue_Input__c dialog = new ProDialogue_Input__c();
        ProDialogueInputFormController obj = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));
        obj.resumeAfterNo();
        obj.vocInputFromTempId = '';
        obj.setCountry();
        obj.uploadAtt();
        obj.uploadAttach();
    }
    
}