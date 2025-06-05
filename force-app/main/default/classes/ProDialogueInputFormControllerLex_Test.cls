// ==================================================================================
//  Name: ProDialogueInputFormControllerLex_Test
//  Company: Appirio
//  Author: Nishant Singh Panwar (Offshore)
// Comments: Test Coverage for Server Side handler of Lightning VOC Page
// ==================================================================================
//  Changes: 2018-01-28 Initial version.
// ==================================================================================
@isTest
public class ProDialogueInputFormControllerLex_Test {
    static testMethod void validateInitialLoad() {
        ProDialogue_Input__c voc = ProDialogueInputFormControllerLex.initVoc();
        List<VOC_Data_Entry__c> vocLst = ProDialogueInputFormControllerLex.getVocData(voc);
        ProDialogue_Input__c voc2 = ProDialogueInputFormControllerLex.getVocRecord(null);
        List<ProDialogue_Input_Attendee__c> vocAtt = ProDialogueInputFormControllerLex.getattendees(null);
        List < String > opts = ProDialogueInputFormControllerLex.getselectOptions(voc,'Region__c');
        Map<String, List<String>> opts2 = ProDialogueInputFormControllerLex.getDependentOptionsImpl('ProDialogue_Input__c','Sales_Role__c','Information_Source__c');
        ProDialogueInputFormControllerLex.clearTempData(null);
        Account acc = ProDialogueInputFormControllerLex.getAccount(null);
        Contact ct =ProDialogueInputFormControllerLex.getContact(null);
        Lead ld = ProDialogueInputFormControllerLex.getLead(null);
    }
    static testMethod void validateDataFetch(){
        Account acc = new Account();
        acc.Name = 'Test AccountName';
        acc.BillingStreet = 'Test';
        acc.BillingCity = 'Lewiston';
        acc.BillingState = 'New York';
        acc.BillingPostalCode = '10254';
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('US Speciality Account').getRecordTypeId();
        insert acc;
        
        Contact c = new Contact();
        c.LastName = 'Dodge Contact';
        c.AccountId = acc.Id;
        c.Phone = '012365487';
        c.Email = 'test@test.com';
        c.RecordTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Gypsum Canada Contact').getRecordTypeId();
        insert c;
        
        Lead l = new Lead(LastName = 'Test',Company = 'Testing');
        insert l;
        
        //Calling to fetch for Pill Update
        Account acc1 = ProDialogueInputFormControllerLex.getAccount(acc.id);
        Contact ct =ProDialogueInputFormControllerLex.getContact(c.id);
        Lead ld = ProDialogueInputFormControllerLex.getLead(l.id);
        
        ProDialogue_Input__c dialog = new ProDialogue_Input__c();
        dialog.Meeting_Date__c = Date.today();
        dialog.City_State__c = 'ab, cd';
        dialog.Facilitator__c = Userinfo.getUserId();
        dialog.TM__c = Userinfo.getUserId();
        dialog.Information_Source__c = '1 on 1';
        dialog.Region__c = 'Canada';
        dialog.Audience__c = 'Retail';
        dialog.Market_Segment__c ='Residential';
        dialog.Sales_Role__c = 'ASM';
        dialog.Segment_Type__c = 'Type';
        dialog.Country__c ='USA';
        dialog.Additional_Info_Source__c= 'test';
        insert dialog;
        
        ProDialogue_Input_Attendee__c pAttendee = new ProDialogue_Input_Attendee__c();
        pAttendee.ProDialogue_Input__c = dialog.Id;
        pAttendee.Role__c = 'Other';
        pAttendee.Lead__c = l.id;
        pAttendee.Contact__c = c.Id;
        pAttendee.Account__c = acc.Id;
        insert pAttendee;
        
        VOC_Data_Entry__c  vde = new VOC_Data_Entry__c(Product_Line__c = 'Test', Product_Family__c = 'Test', Brand__c ='Test', Market_Family__c = 'Test', Competitor_Topic__c = 'Test', ProDialogue_Input__c = dialog.Id,Category__c  = 'Products');
        insert vde;
        List<ProDialogue_Input_Attendee__c> pAttList = new List<ProDialogue_Input_Attendee__c>();
        pAttList.add(pAttendee);
        List<VOC_Data_Entry__c> vocItemList = new List<VOC_Data_Entry__c>();
        vocItemList.add(vde);
        ProDialogue_Input__c vocCopy = ProDialogueInputFormControllerLex.getVocRecord(dialog.id);
        Map<String,String> res = ProDialogueInputFormControllerLex.upsertVoc(dialog,pAttList,vocItemList);
        Map<String,String> res2 = ProDialogueInputFormControllerLex.upsertVocTemp(dialog,pAttList,vocItemList);
        Map<String,List<sobject>> res3 = ProDialogueInputFormControllerLex.getTempData(dialog.id);
        Map<String,String> res4 = ProDialogueInputFormControllerLex.removeVocData(vde.id);
        
        //cause exception
        Map<String,String> res5 = ProDialogueInputFormControllerLex.removeVocData(vde.id);
        
        //Insert case
       	dialog.id=null;
        Map<String,String> res6 = ProDialogueInputFormControllerLex.upsertVoc(dialog,pAttList,vocItemList);
        
    }
    
}