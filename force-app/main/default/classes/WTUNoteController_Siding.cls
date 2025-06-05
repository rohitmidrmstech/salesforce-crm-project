// ==================================================================================
//   Object: WTUNoteController
//  Company: Navivo
//   Author: Mohan Kumar (Threshold)
// Comments: WTU Notes and VOC sections for each category
//           TestWTUNoteController includes the test methods for code coverage. 
// ==================================================================================
//  Changes: 2013-10-28 Initial version.
// ==================================================================================

public with sharing class WTUNoteController_Siding {

    public WTU_Note__c wNote {get;set;}
    public Boolean addVoc {get;set;}
    public String priority {get;set;}
    public String audience {get;set;}
    public String lob {get;set;}
    public String topic {get;set;}
    public String vocNotes {get;set;}
    public Boolean showVOC {get;set;}
    public List<VOC_Data_Entry__c> vocList {get;set;}
    public List<VOCLine> productLineList {get;set;}
    public List<VOCLine> salesLineList {get;set;}
    public List<VOCLine> serviceLineList {get;set;}
    public List<VOCLine> otherLineList {get;set;}
    public String selectedIndexToDelete {get;set;}
    
    //custom picklist
    public List<Selectoption> wtuPFamilyOptions {get;set;}
    public List<Selectoption> wtuBrandOptions {get;set;}
    public List<Selectoption> wtuMFamilyOptions {get;set;}
    public List<Selectoption> wtuMSegmentOptions {get;set;}
    
    private String wtuId = '';
    private String wtuNoteId = '';
    private WTU_Note__c wNoteOldValue = new WTU_Note__c();
    private Boolean autoFill = true;    //specifies whether the hierarchy picklist needs to be autofilled (Product Family, Branch, etc.)
 
    public WTUNoteController_Siding(Apexpages.Standardcontroller sc) {
 
        wtuNoteId = sc.getId();
        showVOC = false;
        vocList = new List<VOC_Data_Entry__c>();
        vocList.add(new VOC_Data_Entry__c());
        wtuId = Apexpages.currentPage().getParameters().get('CF00N30000008eW4V_lkid');
        autoFill = false;
        if(wtuNoteId != null) {
            wNote = [Select w.Week_Ends__c, w.WTU__c, w.Type__c, w.Task__c, w.Task_ID__c, w.Subject__c, w.Special_Topic__c, w.Sales_Call__c, 
                        w.Project__c, w.Product_Line__c, w.Note__c, w.Note_Type__c, w.Name, w.Market_Segment__c, w.Market_Family__c, 
                        w.Line_of_Business__c, w.Lead__c, w.Id, w.Event_ID__c, w.Contact__c, w.Add_to_VOC_Products__c, w.Brand__c, 
                        w.Add_to_VOC_Miscellaneous__c, w.Add_to_VOC_Marketing_Supports__c, w.Add_to_VOC_Marketing_Programs__c, w.Account__c 
                        From WTU_Note__c w Where Id =: wtuNoteId];
            wNoteOldValue = wNote;
            
        } else {
            wNote = new WTU_Note__c();
            wNote.WTU__c = wtuId;
            wtuPFamilyOptions = new List<Selectoption>();
            wtuPFamilyOptions.add(new Selectoption('', '--None--'));
            wtuBrandOptions = new List<Selectoption>();
            wtuBrandOptions.add(new Selectoption('', '--None--'));
            wtuMFamilyOptions = new List<Selectoption>();
            wtuMFamilyOptions.add(new Selectoption('', '--None--'));
            wtuMSegmentOptions = new List<Selectoption>();
            wtuMSegmentOptions.add(new Selectoption('', '--None--'));
        }
        
        //add default values
        productLineList = new List<VOCLine>();
        VOCLine vLine = new VOCLine();
        vLine.rIndex = productLineList.size();
        vLine.vocEntry.Category__c = 'Products';
        productLineList.add(vLine);
        salesLineList = new List<VOCLine>();
        vLine = new VOCLine();
        vLine.rIndex = salesLineList.size();
        vLine.vocEntry.Category__c = 'Marketing Supports';
        salesLineList.add(vLine);
        serviceLineList = new List<VOCLine>();
        vLine = new VOCLine();
        vLine.rIndex = serviceLineList.size();
        vLine.vocEntry.Category__c = 'Marketing Programs';
        serviceLineList.add(vLine);
        otherLineList = new List<VOCLine>();
        vLine = new VOCLine();
        vLine.rIndex = otherLineList.size();
        vLine.vocEntry.Category__c = 'Miscellaneous';
        otherLineList.add(vLine);
        
        autoFill = true;
        
    }
    
    public void autoRun() {
        //Copy WTU Notes from associated record
        wNote = VOCUtil_Siding.copyNotes(Apexpages.currentPage().getParameters().get('rId'), wNote);
        //identify the WTU
        if(wNote.WTU__c == null) wNote.WTU__c = VOCUtil_Siding.findWTU(Apexpages.currentPage().getParameters().get('ownerId'));
        Id wNoteId = VOCUtil_Siding.getWTUNoteId(wNote.WTU__c, wNote.Type__c);
        if(wNoteId != null) {
            wNote = [Select w.Week_Ends__c, w.WTU__c, w.Type__c, w.Task__c, w.Task_ID__c, w.Subject__c, w.Special_Topic__c, w.Sales_Call__c, 
                        w.Project__c, w.Product_Line__c, w.Note__c, w.Note_Type__c, w.Name, w.Market_Segment__c, w.Market_Family__c, 
                        w.Line_of_Business__c, w.Lead__c, w.Id, w.Event_ID__c, w.Contact__c, w.Add_to_VOC_Products__c, w.Brand__c, 
                        w.Add_to_VOC_Miscellaneous__c, w.Add_to_VOC_Marketing_Supports__c, w.Add_to_VOC_Marketing_Programs__c, w.Account__c 
                        From WTU_Note__c w Where Id =: wNoteId];
            wNote.Add_to_VOC_Products__c = false;
            wNote.Add_to_VOC_Marketing_Supports__c = false;
            wNote.Add_to_VOC_Marketing_Programs__c = false;
            wNote.Add_to_VOC_Miscellaneous__c = false;
            getWTUProductFamily();
            getWTUBrand();
            getWTUMarketFamily();
            getWTUMarketSegment();
        }
    }
    
    public Pagereference saveWtuNote() {
        Pagereference pr;
        Savepoint sp = Database.setSavepoint();
        try {
            Boolean validationFailed = VOCUtil_Siding.validateVOC(productLineList, 'Products', '');
            if(validationFailed) return pr;
            
            //adjust the VOC fields
            if(wNoteOldValue.Add_to_VOC_Products__c && !wNote.Add_to_VOC_Products__c) wNote.Add_to_VOC_Products__c =true;
            if(wNoteOldValue.Add_to_VOC_Marketing_Supports__c && !wNote.Add_to_VOC_Marketing_Supports__c) wNote.Add_to_VOC_Marketing_Supports__c =true;
            if(wNoteOldValue.Add_to_VOC_Marketing_Programs__c && !wNote.Add_to_VOC_Marketing_Programs__c) wNote.Add_to_VOC_Marketing_Programs__c =true;
            if(wNoteOldValue.Add_to_VOC_Miscellaneous__c && !wNote.Add_to_VOC_Miscellaneous__c) wNote.Add_to_VOC_Miscellaneous__c =true;
            upsert wNote;
            
            List<VOC_Data_Entry__c> vocInsert = new List<VOC_Data_Entry__c>();
            vocInsert = VOCUtil_Siding.doAdd(vocInsert, productLineList, 'Products', 'WTU Note', wNote.Id);
            vocInsert = VOCUtil_Siding.doAdd(vocInsert, salesLineList, 'Marketing Supports', 'WTU Note', wNote.Id);
            vocInsert = VOCUtil_Siding.doAdd(vocInsert, serviceLineList, 'Marketing Programs', 'WTU Note', wNote.Id);
            vocInsert = VOCUtil_Siding.doAdd(vocInsert, otherLineList, 'Miscellaneous', 'WTU Note', wNote.Id);
            
            if(vocInsert.size() > 0) insert vocInsert;
            
            pr = new Pagereference('/' + wNote.Id);
            pr.setRedirect(true);
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
        }
        return pr;
    }
    
    public Pagereference saveWtuNoteAndNew() {
        Pagereference pr = saveWtuNote();
        if(pr != null) {
            //String url = '/apex/WTUNote?ent=WTU+Notes&rId=' + Apexpages.currentPage().getParameters().get('rId') + '&ownerId=' + Apexpages.currentPage().getParameters().get('ownerId') + '&retURL=/' + Apexpages.currentPage().getParameters().get('rId') + '&save_new=1&sfdc.override=1';
            String url = '/apex/WTUNote_Siding';
            String params = '';
            for(String s : Apexpages.currentPage().getParameters().keyset()) {
                if(s == 'AJAXREQUEST' || s == 'brand' || s == 'com.salesforce.visualforce.ViewStateCSRF' || s == 'com.salesforce.visualforce.ViewStateVersion') continue;
                if(params != '') params += '&';
                params += s + '=' + Apexpages.currentPage().getParameters().get(s);
            }
            if(params != '') url = url + '?' + params;
            System.debug('url: '+url);
            pr = new Pagereference(url);
            pr.setRedirect(true);
        }
        return pr;
    }
    
    public void addProductLine() {
        String pLine = Apexpages.currentPage().getParameters().get('pLine');
        String lBusiness = Apexpages.currentPage().getParameters().get('lBusiness');
        String brand = Apexpages.currentPage().getParameters().get('brand');
        String mFamily = Apexpages.currentPage().getParameters().get('mFamily');
        String mSegment = Apexpages.currentPage().getParameters().get('mSegment');
        String notes = Apexpages.currentPage().getParameters().get('plNotes');
        productLineList = VOCUtil_Siding.addProductLine(productLineList, pLine, lBusiness, brand, mFamily, mSegment, notes);
        
        autoFill = false;
        System.currentPageReference().getParameters().put('rIndex', String.valueOf(productLineList.size() - 1));
        getProductFamily();
        getBrand();
        getMarketFamily();
        getMarketSegment();
        autoFill = true;
        //productLineList = VOCUtil.addProductLine(productLineList, null, null, null, null, null, null);
    }
    
    public void addSalesLine() {
        
        salesLineList = VOCUtil_Siding.addLineItem(salesLineList, null, 'Marketing Supports');
    }
    
    public void addServiceLine() {
        
        serviceLineList = VOCUtil_Siding.addLineItem(serviceLineList, null, 'Marketing Programs');
    }
    
    public void addOtherLine() {
        
        otherLineList = VOCUtil_Siding.addLineItem(otherLineList, null, 'Miscellaneous');
    }
    
    public void removeProductLine() {
        System.debug(':selectedIndexToDelete: '+selectedIndexToDelete);
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        productLineList = VOCUtil_Siding.removeLineItem(productLineList, delIndex);
    }
    
    public void removeSalesLine() {
        System.debug(':selectedIndexToDelete: '+selectedIndexToDelete);
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        salesLineList = VOCUtil_Siding.removeLineItem(salesLineList, delIndex);
    }
    
    public void removeServiceLine() {
        System.debug(':selectedIndexToDelete: '+selectedIndexToDelete);
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        serviceLineList = VOCUtil_Siding.removeLineItem(serviceLineList, delIndex);
    }
    
    public void removeOtherLine() {
        System.debug(':selectedIndexToDelete: '+selectedIndexToDelete);
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        otherLineList = VOCUtil_Siding.removeLineItem(otherLineList, delIndex);
    }
    
    public void clearProductLineItems() {
        productLineList = VOCUtil_Siding.clearLineItems(productLineList);
    }
    
    public void clearSalesLineItems() {
        salesLineList = VOCUtil_Siding.clearLineItems(salesLineList);
    }
    
    public void clearServiceLineItems() {
        serviceLineList = VOCUtil_Siding.clearLineItems(serviceLineList);
    }
    
    public void clearOtherLineItems() {
        otherLineList = VOCUtil_Siding.clearLineItems(otherLineList);
    }
    
    public void copyWtuDataToVOCProduct() {
        productLineList[0].vocEntry.Product_Line__c = wNote.Product_Line__c;
        productLineList[0].vocEntry.Product_Family__c = wNote.Line_of_Business__c;
        productLineList[0].vocEntry.Brand_siding__c = wNote.Brand__c;
        productLineList[0].vocEntry.Market_Family__c = wNote.Market_Family__c;
        productLineList[0].vocEntry.Market_Segment__c = wNote.Market_Segment__c;
        productLineList[0].vocEntry.Note__c = wNote.Note__c;
        autoFill = false;
        System.currentPageReference().getParameters().put('rIndex', '0');
        getProductFamily();
        getBrand();
        getMarketFamily();
        getMarketSegment();
        autoFill = true;
    }
    
    public void getWTUProductFamily() {
        List<Selectoption> options = VOCUtil_Siding.prepareProductFamily(wNote.Product_Line__c);
        wtuPFamilyOptions = options;
        wtuBrandOptions = new Selectoption[]{new Selectoption('', '--None--')};
        wtuMFamilyOptions = new Selectoption[]{new Selectoption('', '--None--')};
        wtuMSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
        if(options.size() == 2 && autoFill) {
            wNote.Line_of_Business__c = options.get(1).getValue();
            getWTUBrand();
        }
    }
    
    public void getWTUBrand() {
        List<Selectoption> options = VOCUtil_Siding.prepareBrand(wNote.Line_of_Business__c);
        wtuBrandOptions = options;
        wtuMFamilyOptions = new Selectoption[]{new Selectoption('', '--None--')};
        wtuMSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
        if(options.size() == 2 && autoFill) {
            wNote.Brand__c = options.get(1).getValue();
            getWTUMarketFamily();
        }
    }
    
    public void getWTUMarketFamily() {
        List<Selectoption> options = VOCUtil_Siding.prepareMarketFamily(wNote.Brand__c);
        wtuMFamilyOptions = options;
        wtuMSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
        if(options.size() == 2 && autoFill) {
            wNote.Market_Family__c = options.get(1).getValue();
            getWTUMarketSegment();
        }
    }
    
    public void getWTUMarketSegment() {
        List<Selectoption> options = VOCUtil_Siding.prepareMarketSegment(wNote.Market_Family__c);
        wtuMSegmentOptions = options;
        if(options.size() == 2 && autoFill) wNote.Market_Segment__c = options.get(1).getValue();
    }
    
    public void getProductFamily() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
            List<Selectoption> options = VOCUtil_Siding.prepareProductFamily(productLineList.get(rIndex).vocEntry.Product_Line__c);
            productLineList.get(rIndex).pFamilyOptions = options;
            productLineList.get(rIndex).brandOptions = new Selectoption[]{new Selectoption('', '--None--')};
            productLineList.get(rIndex).mFamilyOptions = new Selectoption[]{new Selectoption('', '--None--')};
            productLineList.get(rIndex).mSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
            if(options.size() == 2 && autoFill) {
                productLineList.get(rIndex).vocEntry.Product_Family__c = options.get(1).getValue();
                getBrand();
            }
        }
    }
    
    public void getBrand() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
            List<Selectoption> options = VOCUtil_Siding.prepareBrand(productLineList.get(rIndex).vocEntry.Product_Family__c);
            productLineList.get(rIndex).brandOptions = options;
            productLineList.get(rIndex).mFamilyOptions = new Selectoption[]{new Selectoption('', '--None--')};
            productLineList.get(rIndex).mSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
            if(options.size() == 2 && autoFill) {
                productLineList.get(rIndex).vocEntry.Brand_siding__c = options.get(1).getValue();
                getMarketFamily();
            }
        }
    }
    
    public void getMarketFamily() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
            List<Selectoption> options = VOCUtil_Siding.prepareMarketFamily(productLineList.get(rIndex).vocEntry.Brand_siding__c);
            productLineList.get(rIndex).mFamilyOptions = options;
            productLineList.get(rIndex).mSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
            if(options.size() == 2 && autoFill) {
                productLineList.get(rIndex).vocEntry.Market_Family__c = options.get(1).getValue();
                getMarketSegment();
            }
        }
    }
    
    public void getMarketSegment() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
            List<Selectoption> options = VOCUtil_Siding.prepareMarketSegment(productLineList.get(rIndex).vocEntry.Market_Family__c);
            productLineList.get(rIndex).mSegmentOptions = options;
            if(options.size() == 2 && autoFill) productLineList.get(rIndex).vocEntry.Market_Segment__c = options.get(1).getValue();
        }
    }

}