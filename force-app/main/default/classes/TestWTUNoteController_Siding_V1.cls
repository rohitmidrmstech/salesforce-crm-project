@isTest
public class TestWTUNoteController_Siding_V1{

  @isTest
    static void testRmApproverEmailTrigger(){

//WTUNoteController_Siding WTUSiding = new WTUNoteController_Siding();
           Opportunity opportunityToCreate = new Opportunity();
        opportunityToCreate.StageName = 'Sourcing Demand';
        opportunityToCreate.Name = 'Test Opportunity Triggers';
        opportunityToCreate.CloseDate = System.today();
        insert opportunityToCreate;
        
        
            Weekly_Territory_Update__c wtuObj = new Weekly_Territory_Update__c();
            Insert wtuObj;
           
            WTU_Note__c wtuNote1 = new WTU_Note__c();
            wtuNote1.WTU__c = wtuObj.Id;
            wtuNote1.Type__c = 'Best Practices';
            wtuNote1.Task_ID__c = 'Test';
            wtuNote1.Subject__c = 'Testing';
            wtuNote1.Special_Topic__c = 'Testing1';
            wtuNote1.Project__c = opportunityToCreate.Id;
            wtuNote1.Name = 'TestName';
            Insert wtuNote1;
           
            // Create an Account.
            Account a = new Account(Name = 'New Account', Status__c = 'Active');
            a.WTU_Notes__c = wtuNote1.Id;
            insert a;
           
            list<WTU_Note__c> notes = [SELECT Id FROM WTU_Note__c WHERE Account__c = :a.Id LIMIT 1];
            WTU_Note__c wtuNote;
            if(notes.size() > 0) wtuNote = notes[0];
           
            Apexpages.currentPage().getParameters().put('rId', a.Id);
            Apexpages.currentPage().getParameters().put('ownerId', Userinfo.getUserId());
            Apexpages.currentPage().getParameters().put('retURL', '/' + a.Id);
            WTUNoteController_Siding wNote = new WTUNoteController_Siding (new Apexpages.Standardcontroller(wtuNote1));
            wNote.autoRun();
            wNote.addProductLine();
            wNote.addSalesLine();
            wNote.addServiceLine();
            wNote.addOtherLine();
           
            System.currentPageReference().getParameters().put('rIndex', '0');
            wNote.removeProductLine();
            wNote.removeSalesLine();
            wNote.removeServiceLine();
            wNote.removeOtherLine();
           
            //wNote.clearProductLineItems();
            wNote.clearSalesLineItems();
            wNote.clearServiceLineItems();
            wNote.clearOtherLineItems();
            wNote.copyWtuDataToVOCProduct();
            wNote.saveWtuNoteAndNew();
            wNote.getWTUProductFamily();
            wNote.getWTUBrand();
            wNote.getWTUMarketFamily();
            wNote.getWTUMarketSegment();
        wtuNote1 = new WTU_Note__c();
       WTUNoteController wNote1 = new WTUNoteController(new Apexpages.Standardcontroller(wtuNote1));
        //}
       /* catch(Exception ex){
            system.debug(ex.getMessage());
        }*/



}
 static testMethod void wtuNoteControllerTestMethod2() {
        ID primary;
        primary = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' And Name = 'Read-Only BPCS Record'].Id;
        /* list<RecordType> recordTypes =
            [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];
        for (RecordType rt : recordTypes)
        {
            if (rt.Name.startsWith('BPCS'))
            {
                primary = rt.Id;
                break;
            }
        } */
       
        test.startTest();
       
        //try{
        
        Opportunity opportunityToCreate = new Opportunity();
        opportunityToCreate.StageName = 'Sourcing Demand';
        opportunityToCreate.Name = 'Test Opportunity Triggers';
        opportunityToCreate.CloseDate = System.today();
        insert opportunityToCreate;
        
        
        Weekly_Territory_Update__c wtuObj = new Weekly_Territory_Update__c();
        Insert wtuObj;
        
        WTU_Note__c wtuNote1 = new WTU_Note__c();
        wtuNote1.WTU__c = wtuObj.Id;
        wtuNote1.Type__c = 'Best Practices';
        wtuNote1.Task_ID__c = 'Test';
        wtuNote1.Subject__c = 'Testing';
        wtuNote1.Special_Topic__c = 'Testing1';
        wtuNote1.Project__c = opportunityToCreate.Id;
        wtuNote1.Name = 'TestName';
        Insert wtuNote1;
        
        
            // Create an Account.
            Account a = new Account(Name = 'New Account', Status__c = 'Active', RecordTypeId = primary );
            a.WTU_Notes__c = wtuNote1.Id;
            insert a;
           
            /*Opportunity opportunityToCreate = new Opportunity();
            opportunityToCreate.StageName = 'Sourcing Demand';
            opportunityToCreate.Name = 'Test Opportunity Triggers';
            insert opportunityToCreate; */
           
         /*  Weekly_Territory_Update__c wtuObj = new Weekly_Territory_Update__c();
            Insert wtuObj;
           
            WTU_Note__c wtuNote = new WTU_Note__c();
            wtuNote.WTU__c = wtuObj.CreatedById;
            wtuNote.Type__c = 'Best Practices';
            wtuNote.Task_ID__c = 'Test';
            wtuNote.Subject__c = 'Testing';
            wtuNote.Special_Topic__c = 'Testing1';
            wtuNote.Project__c = opportunityToCreate.Id;
            wtuNote.Name = 'TestName';
            Insert wtuNote; */
           
            Apexpages.currentPage().getParameters().put('rId', a.Id);
            Apexpages.currentPage().getParameters().put('ownerId', Userinfo.getUserId());
            Apexpages.currentPage().getParameters().put('retURL', '/' + a.Id);
            WTUNoteController_Siding wNote = new WTUNoteController_Siding (new Apexpages.Standardcontroller(wtuNote1));
            wNote.autoRun();
            wNote.wNote.Add_to_VOC_Products__c = true;
            wNote.wNote.Add_to_VOC_Marketing_Supports__c = true;
            wNote.wNote.Add_to_VOC_Marketing_Programs__c = true;
            wNote.wNote.Add_to_VOC_Miscellaneous__c = true;
            if(wNote.productLineList.size() > 0) {
                wNote.productLineList[0].vocEntry.Priority__c = 'Medium';
                wNote.productLineList[0].vocEntry.Note__c = 'test note';
            }
            if(wNote.salesLineList.size() > 0) {
                wNote.salesLineList[0].vocEntry.Priority__c = 'Medium';
                wNote.salesLineList[0].vocEntry.Note__c = 'test note';
            }
            if(wNote.serviceLineList.size() > 0) {
                wNote.serviceLineList[0].vocEntry.Priority__c = 'Medium';
                wNote.serviceLineList[0].vocEntry.Note__c = 'test note';
            }
            if(wNote.otherLineList.size() > 0) {
                wNote.otherLineList[0].vocEntry.Priority__c = 'Medium';
                wNote.otherLineList[0].vocEntry.Note__c = 'test note';
            }
           
            wNote.saveWtuNoteAndNew();
        //}
        /* catch(Exception ex){
            system.debug(ex.getMessage());
        }*/
    }
   
    
   





}