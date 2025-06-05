// ==================================================================================
//   Object: TestWTUNoteController
//  Company: Threshold
//   Author: Mohan Kumar (Threshold)
// Comments: Test converage for ProDialogueInputFormController class
// ==================================================================================
//  Changes: 2014-01-30 Initial version.
// ==================================================================================

@isTest
private class TestProDialogueInputFormController_Sidng {

    static testMethod void myUnitTest1() {
        ProDialogue_Input__c dialog = new ProDialogue_Input__c();
        ProDialogueInputFormController_Siding obj = new ProDialogueInputFormController_Siding(new Apexpages.Standardcontroller(dialog));
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
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
        obj.getProductFamily();
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
        
        ProDialogue_Input_Attendee__c pAttendee = new ProDialogue_Input_Attendee__c();
        pAttendee.ProDialogue_Input__c = dialog.Id;
        pAttendee.Role__c = 'Other';
        insert pAttendee;
        obj = new ProDialogueInputFormController_Siding(new Apexpages.Standardcontroller(dialog));
    }
    
    static testMethod void myUnitTest2() {
        ProDialogue_Input__c dialog = new ProDialogue_Input__c();
        ProDialogueInputFormController_Siding obj = new ProDialogueInputFormController_Siding(new Apexpages.Standardcontroller(dialog));
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
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
        obj.saveProDialogue();
    }
    
     static testMethod void myUnitTest3() {
        VOC_Input_Form_Temp__c dialog = new VOC_Input_Form_Temp__c();
        ProDialogueInputFormController_Siding obj = new ProDialogueInputFormController_Siding(new Apexpages.Standardcontroller(dialog));
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
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
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
        ProDialogueInputFormController_Siding obj = new ProDialogueInputFormController_Siding(new Apexpages.Standardcontroller(dialog));
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
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
        obj.saveProDialogue();
        
        
        VOC_Input_Form_Temp__c dialog2 = new VOC_Input_Form_Temp__c();
       // ProDialogueInputFormController obj1 = new ProDialogueInputFormController(new Apexpages.Standardcontroller(dialog));
        
        
        dialog2.TM__c = Userinfo.getUserId();
        dialog2.Meeting_Date__c = Date.today();
        dialog2.City_State__c = 'ab, cd';
        dialog2.Facilitator__c = Userinfo.getUserId();
        dialog2.Information_Source__c = '1 on 1';
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
        obj.updateTempObj();
        obj.discardMethod();
        obj.facilitatorId = Userinfo.getUserId();
        obj.tmId = Userinfo.getUserId();
        
        obj.productLineList[0].vocEntry.Product_Line__c = 'Deck';
        obj.productLineList[0].vocEntry.Product_Family__c = 'Deck';
        obj.productLineList[0].vocEntry.Brand_siding__c = 'Deck';
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
        
        obj.updateTempObj();
        ApexPages.currentPage().getParameters().put('id',dialog.Id);
        obj.discardMethod();
        obj.saveProDialogue();
        
    }
    
    static testMethod void myUnitTest5() {
        
        ProDialogue_Input__c dialog = new ProDialogue_Input__c();
        ProDialogueInputFormController_Siding obj = new ProDialogueInputFormController_Siding(new Apexpages.Standardcontroller(dialog));
        obj.resumeAfterNo();
    }

}