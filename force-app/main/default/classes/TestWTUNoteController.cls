// ==================================================================================
//   Object: TestWTUNoteController
//  Company: Threshold
//   Author: Mohan Kumar (Threshold)
// Comments: Test converage for WTUNoteController and WTUNoteListView class
// ==================================================================================
//  Changes: 2013-11-26 Initial version.
// ==================================================================================

@isTest
private class TestWTUNoteController {
   
    static testMethod void wtuNoteControllerTestMethod1() {
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
            Account a = new Account(Name = 'New Account', Status__c = 'Active', RecordTypeId = primary);
            a.WTU_Notes__c = wtuNote1.Id;
            insert a;
           
            list<WTU_Note__c> notes = [SELECT Id FROM WTU_Note__c WHERE Account__c = :a.Id LIMIT 1];
            WTU_Note__c wtuNote;
            if(notes.size() > 0) wtuNote = notes[0];
           
            Apexpages.currentPage().getParameters().put('rId', a.Id);
            Apexpages.currentPage().getParameters().put('ownerId', Userinfo.getUserId());
            Apexpages.currentPage().getParameters().put('retURL', '/' + a.Id);
            WTUNoteController wNote = new WTUNoteController(new Apexpages.Standardcontroller(wtuNote1));
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
            WTUNoteController wNote = new WTUNoteController(new Apexpages.Standardcontroller(wtuNote1));
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
   
    static testMethod void wtuNoteListViewTestMethod1() {
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
       
        // Create an Account.
        List<Account> aList = new List<Account>();
        Account a1 = new Account(Name = 'Test Account1', Status__c = 'Active');
        a1.WTU_Notes__c = 'Test Account WTU Notes';
        aList.add(a1);
        Account a2 = new Account(Name = 'Test Account1', Status__c = 'Active');
        a2.WTU_Notes__c = 'Test Account WTU Notes';
        aList.add(a2);
        Account a3 = new Account(Name = 'Test Account1', Status__c = 'Active');
        a3.WTU_Notes__c = 'Test Account WTU Notes';
        aList.add(a3);
        Account a4 = new Account(Name = 'Test Account1', Status__c = 'Active');
        a4.WTU_Notes__c = 'Test Account WTU Notes';
        aList.add(a4);
        insert aList;
       
        Opportunity opportunityToCreate = new Opportunity();
        opportunityToCreate.StageName = 'Sourcing Demand';
        opportunityToCreate.Name = 'Test Opportunity Triggers';
        opportunityToCreate.CloseDate = System.today();
        insert opportunityToCreate;
       
        Weekly_Territory_Update__c wtuObj = new Weekly_Territory_Update__c();
       
        Insert wtuObj;
       
        WTU_Note__c wtuNote = new WTU_Note__c();
        wtuNote.WTU__c = wtuObj.id;
        wtuNote.Type__c = 'Best Practices';
        wtuNote.Task_ID__c = 'Test';
        wtuNote.Subject__c = 'Testing';
        wtuNote.Special_Topic__c = 'Testing1';
        wtuNote.Project__c = opportunityToCreate.Id;
        wtuNote.Name = 'TestName';
        Insert wtuNote;
       
        //WTU_Note__c wtuNote = new WTU_Note__c();
        WTUNoteListView wNote = new WTUNoteListView(new Apexpages.Standardcontroller(wtuNote));
        wNote.MAX_WTU_Notes_PER_PAGE = 2;
        wNote.getSortDirection();
        wNote.sortDirection = 'DESC';
        wNote.sortDirection = 'ASC';
        wNote.retrieveWTUNotes();
       
        wNote.startDate.Created_Date__c = Date.today();
        wNote.endDate.Created_Date__c = Date.today().addDays(-7);
        wNote.retrieveWTUNotes();
       
        wNote.startDate.Created_Date__c = Date.today().toStartOfWeek();
        wNote.endDate.Created_Date__c = Date.today().toStartOfWeek().addDays(7);
        wNote.retrieveWTUNotes();
       
        wNote.startDate.Created_Date__c = Date.today().toStartOfWeek();
        wNote.endDate.Created_Date__c = Date.today().addMonths(1);
        wNote.retrieveWTUNotes();
       
        wNote.selectedIndexToNew = '0';
        wNote.checkBoxValue = 'true';
       
        WTUNote wtuNoteObj = new WTUNote();
        wtuNoteObj.addproduct = true;
        wNote.saveWtuNote();
        wNote.addProductLine();
       
        wNote.selectedIndexToNew = '0';
        wNote.checkBoxValue = 'true';
        wNote.addSalesLine();
       
        wNote.selectedIndexToNew = '0';
        wNote.checkBoxValue = 'true';
        wNote.addServiceLine();
       
        wNote.selectedIndexToNew = '0';
        wNote.checkBoxValue = 'true';
        wNote.addOtherLine();
       
        System.currentPageReference().getParameters().put('rIndex', '0');
        System.currentPageReference().getParameters().put('wIndex', '0');
        wNote.removeProductLine();
        wNote.removeSalesLine();
        wNote.removeServiceLine();
        wNote.removeOtherLine();
       
        wNote.gotoNextPage();
        wNote.gotoPreviousPage();
       
        wNote.sortData();
        //START Added by Kritika Bhati for S-490567 on 26/6/2017
        wNote.doReviewed();
        wNote.clearProductLineItems();
       // wNote.getMarketSegment();
        wNote.handleNextEvent();
        //wNote.clearSalesLineItems();
        wNote.clearServiceLineItems();
        wNote.clearOtherLineItems();
        wNote.addProductLine();
        //wNote.getProductFamily();
        //END S-490567
        /*}
catch(Exception ex){
system.debug(ex.getMessage());
}*/
       
    }
   
    static testMethod void wtuNoteListViewTestMethod2() {
        ID primary;
        primary = [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account' And Name = 'Read-Only BPCS Record'].Id;
        /*list<RecordType> recordTypes =
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
        try{
           
            // Create an Account.
            List<Account> aList = new List<Account>();
            Account a1 = new Account(Name = 'Test Account1', RecordTypeId = primary);
            a1.WTU_Notes__c = 'Test Account WTU Notes';
            aList.add(a1);
            Account a2 = new Account(Name = 'Test Account1', RecordTypeId = primary);
            a2.WTU_Notes__c = 'Test Account WTU Notes';
            aList.add(a2);
            Account a3 = new Account(Name = 'Test Account1', RecordTypeId = primary);
            a3.WTU_Notes__c = 'Test Account WTU Notes';
            aList.add(a3);
            Account a4 = new Account(Name = 'Test Account1', RecordTypeId = primary);
            a4.WTU_Notes__c = 'Test Account WTU Notes';
            aList.add(a4);
            insert aList;
           
            WTU_Note__c wtuNote = new WTU_Note__c();
            WTUNoteListView wNote = new WTUNoteListView(new Apexpages.Standardcontroller(wtuNote));
            wNote.MAX_WTU_Notes_PER_PAGE = 2;
            wNote.getSortDirection();
            wNote.startDate.Created_Date__c = Date.today().toStartOfWeek();
            wNote.endDate.Created_Date__c = Date.today().addMonths(1);
            wNote.retrieveWTUNotes();
           
            wNote.selectedIndexToNew = '0';
            wNote.checkBoxValue = 'true';
            wNote.addProductLine();
           
            wNote.selectedIndexToNew = '0';
            wNote.checkBoxValue = 'true';
            wNote.addSalesLine();
           
            wNote.selectedIndexToNew = '0';
            wNote.checkBoxValue = 'true';
            wNote.addServiceLine();
           
            wNote.selectedIndexToNew = '0';
            wNote.checkBoxValue = 'true';
            wNote.addOtherLine();
           
            System.currentPageReference().getParameters().put('rIndex', '0');
            System.currentPageReference().getParameters().put('wIndex', '0');
           
            if(wNote.listWTU[0].productLineList.size() > 0) {
                wNote.listWTU[0].addProduct = true;
                wNote.listWTU[0].productLineList[0].vocEntry.Priority__c = 'Medium';
                wNote.listWTU[0].productLineList[0].vocEntry.Note__c = 'test note';
            }
            if(wNote.listWTU[0].salesLineList.size() > 0) {
                wNote.listWTU[0].addSales = true;
                wNote.listWTU[0].salesLineList[0].vocEntry.Priority__c = 'Medium';
                wNote.listWTU[0].salesLineList[0].vocEntry.Note__c = 'test note';
            }
            if(wNote.listWTU[0].serviceLineList.size() > 0) {
                wNote.listWTU[0].addService = true;
                wNote.listWTU[0].serviceLineList[0].vocEntry.Priority__c = 'Medium';
                wNote.listWTU[0].serviceLineList[0].vocEntry.Note__c = 'test note';
            }
            if(wNote.listWTU[0].otherLineList.size() > 0) {
                wNote.listWTU[0].addOther = true;
                wNote.listWTU[0].otherLineList[0].vocEntry.Priority__c = 'Medium';
                wNote.listWTU[0].otherLineList[0].vocEntry.Note__c = 'test note';
            }
            wNote.saveWtuNote();
           
            wNote = new WTUNoteListView(new Apexpages.Standardcontroller(wtuNote));
            wNote.MAX_WTU_Notes_PER_PAGE = 2;
            wNote.getSortDirection();
            wNote.startDate.Created_Date__c = Date.today().toStartOfWeek();
            wNote.endDate.Created_Date__c = Date.today().addMonths(1);
            wNote.retrieveWTUNotes();
           
            wNote.selectedIndexToNew = '0';
            wNote.checkBoxValue = 'true';
            wNote.addProductLine();
           
            wNote.selectedIndexToNew = '0';
            wNote.checkBoxValue = 'true';
            wNote.addSalesLine();
           
            wNote.selectedIndexToNew = '0';
            wNote.checkBoxValue = 'true';
            wNote.addServiceLine();
           
            wNote.selectedIndexToNew = '0';
            wNote.checkBoxValue = 'true';
            wNote.addOtherLine();
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
    //START Added by Kritika Bhati for S-490567 on 26/6/2017
    static testMethod void wtuNoteListViewTestMethod4() {
        Opportunity opportunityToCreate = new Opportunity();
        opportunityToCreate.StageName = 'Sourcing Demand';
        opportunityToCreate.Name = 'Test Opportunity Triggers';
        opportunityToCreate.CloseDate = System.today();
        insert opportunityToCreate;
       
        Weekly_Territory_Update__c wtuObj = new Weekly_Territory_Update__c();
       
        Insert wtuObj;
       
        WTU_Note__c wtuNote = new WTU_Note__c();
        wtuNote.WTU__c = wtuObj.id;
        wtuNote.Type__c = 'Best Practices';
        wtuNote.Task_ID__c = 'Test';
        wtuNote.Subject__c = 'Testing';
        wtuNote.Special_Topic__c = 'Testing1';
        wtuNote.Project__c = opportunityToCreate.Id;
        wtuNote.Name = 'TestName';
        wtuNote.Add_to_VOC_Products__c = true;
        Insert wtuNote;
       
      
        WTUNoteListView wNote = new WTUNoteListView(new Apexpages.Standardcontroller(wtuNote));
         wNote.addVoc =True;
         wNote.priority ='Urgent';
         wNote.audience ='test';
         wNote.lob ='testLob';
         wNote.topic ='test';
         wNote.vocNotes ='testvocNotes ';
         wNote.showVOC =TRUE;
         wNote.selectedIndexToDelete = 'testselectedIndexToDelete';
         wNote.temp ='testtemp';
        wNote.viewType = 'Current Year';
        wNote.checkBoxValue = 'true';
        wNote.selectedIndexToNew = '0';
        System.currentPageReference().getParameters().put('rIndex', '0');
        System.currentPageReference().getParameters().put('wIndex', '0');
        //wNote.getBrand();
        //wNote.getMarketFamily();
        //wNote.getMarketSegment();
        //wNote.handleNextEvent();
        wNote.handlePrevEvent();
        wNote.handleSaveEvent();
        wNote.viewType = 'Current Year';
        wNote.handleSaveEvent();
        wNote.viewType = 'Past Year';
        wNote.handleSaveEvent();
        wNote.viewType = 'This Week';
        wNote.handleSaveEvent();
        wNote.viewType = 'Last Week';
        wNote.handleSaveEvent();
        wNote.viewType = 'Today';
        wNote.handleSaveEvent();
        wNote.viewType = 'All Reviewed';
        wNote.handleSaveEvent();
        wNote.viewType = 'All Un-Reviewed';
        wNote.handleSaveEvent();
        wNote.SelectedWTUNoteId = wtuNote.id;
        wNote.doReviewed();
        
        wNote.showPopup();
        
        VOCLine vLine = new VOCLine();
        vLine.rIndex = 0;
        vLine.vocEntry.Category__c = 'Products';
        
        WTUNote wtuNoteObj = new WTUNote();
        wtuNoteObj.wNote= wtuNote;
        wtuNoteObj.wNote.Add_to_VOC_Products__c = true;
        wtuNoteObj.addProduct = true;
        wtuNoteObj.productLineList.add(vLine);
        wNote.listWTU.add(wtuNoteObj);
        
        WTUNote wtuNoteObj1 = new WTUNote();
        wtuNoteObj.wNote= wtuNote;
        wtuNoteObj.wNote.Add_to_VOC_Products__c = true;
        wtuNoteObj.addSales = true;
        wNote.listWTU.add(wtuNoteObj1);
        
        WTUNote wtuNoteObj2 = new WTUNote();
        wtuNoteObj.wNote= wtuNote;
        wtuNoteObj.wNote.Add_to_VOC_Products__c = true;
        wtuNoteObj.addService = true;
        wNote.listWTU.add(wtuNoteObj2);
        
        WTUNote wtuNoteObj3 = new WTUNote();
        wtuNoteObj.wNote= wtuNote;
        wtuNoteObj.wNote.Add_to_VOC_Products__c = true;
        wtuNoteObj.addOther = true;
        wNote.listWTU.add(wtuNoteObj3);
        
        
        wNote.getProductFamily();
        wNote.getBrand(); 
        wNote.getMarketFamily();
        wNote.saveWtuNote();
    }
    //END S-490567
    
   

}