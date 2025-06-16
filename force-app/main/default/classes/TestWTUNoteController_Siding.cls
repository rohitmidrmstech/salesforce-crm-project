// ==================================================================================
//   Object: TestWTUNoteController
//  Company: Threshold
//   Author: Mohan Kumar (Threshold)
// Comments: Test converage for WTUNoteController and WTUNoteListView class
// ==================================================================================
//  Changes: 2013-11-26 Initial version.
// ==================================================================================

@isTest
private class TestWTUNoteController_Siding {

    static testMethod void wtuNoteControllerTestMethod1() {
        ID primary;
        list<RecordType> recordTypes = 
            [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];
        for (RecordType rt : recordTypes)
        {
            if (rt.Name.startsWith('BPCS')) 
            {
                primary = rt.Id;
                break;
            }
        } 
        
        test.startTest();
        
        try{
             
            // Create an Account.
            Account a = new Account(Name = 'New Account', RecordTypeId = primary);
            a.WTU_Notes__c = 'Test Account WTU Notes';
            insert a;
            
            list<WTU_Note__c> notes = [SELECT Id FROM WTU_Note__c WHERE Account__c = :a.Id LIMIT 1];
            WTU_Note__c wtuNote;
            if(notes.size() > 0) wtuNote = notes[0];
            
            Apexpages.currentPage().getParameters().put('rId', a.Id);
            Apexpages.currentPage().getParameters().put('ownerId', Userinfo.getUserId());
            Apexpages.currentPage().getParameters().put('retURL', '/' + a.Id);
            WTUNoteController_Siding wNote = new WTUNoteController_Siding(new Apexpages.Standardcontroller(wtuNote));
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
            
            wNote.clearProductLineItems();
            wNote.clearSalesLineItems();
            wNote.clearServiceLineItems();
            wNote.clearOtherLineItems();
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
    
    static testMethod void wtuNoteControllerTestMethod2() {
        ID primary;
        list<RecordType> recordTypes = 
            [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];
        for (RecordType rt : recordTypes)
        {
            if (rt.Name.startsWith('BPCS')) 
            {
                primary = rt.Id;
                break;
            }
        } 
        
        test.startTest();
        
        try{
            
             
            // Create an Account.
            Account a = new Account(Name = 'New Account', RecordTypeId = primary);
            //a.WTU_Notes__c = 'Test Account WTU Notes';
            insert a;
            
            WTU_Note__c wtuNote = new WTU_Note__c();
            
            Apexpages.currentPage().getParameters().put('rId', a.Id);
            Apexpages.currentPage().getParameters().put('ownerId', Userinfo.getUserId());
            Apexpages.currentPage().getParameters().put('retURL', '/' + a.Id);
            WTUNoteController_Siding wNote = new WTUNoteController_Siding(new Apexpages.Standardcontroller(wtuNote));
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
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }   
    }
    
    static testMethod void wtuNoteListViewTestMethod1() {
        ID primary;
        list<RecordType> recordTypes = 
            [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];
        for (RecordType rt : recordTypes)
        {
            if (rt.Name.startsWith('BPCS')) 
            {
                primary = rt.Id;
                break;
            }
        } 
        
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
            wNote.clearSalesLineItems();
            wNote.clearServiceLineItems();
            wNote.clearOtherLineItems();
            wNote.getProductFamily();
            //END S-490567
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }   
        
    }
    
    static testMethod void wtuNoteListViewTestMethod2() {
        ID primary;
        list<RecordType> recordTypes = 
            [SELECT Id, Name FROM RecordType WHERE SobjectType = 'Account'];
        for (RecordType rt : recordTypes)
        {
            if (rt.Name.startsWith('BPCS')) 
            {
                primary = rt.Id;
                break;
            }
        } 
        
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
        WTU_Note__c wtuNote = new WTU_Note__c();
        WTUNoteListView wNote = new WTUNoteListView(new Apexpages.Standardcontroller(wtuNote));
        wNote.getBrand();
        wNote.getMarketFamily();
        wNote.getMarketSegment();
        wNote.handleNextEvent();
        wNote.handlePrevEvent();
        wNote.handleSaveEvent();
    }
       //END S-490567
   }