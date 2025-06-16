// ==================================================================================
//   Object: WTUNoteListView
//  Company: Siding
//   Author: Mohan Kumar (Threshold)
// Comments: List view of WTU Notes match to the data range and view the existing  
//           or add new voc's.
//           TestWTUNoteController includes the test methods for code coverage.
// ==================================================================================
//  Changes: 2013-10-29 Initial version.
// ==================================================================================

public with sharing class WTUNoteListView {
    //public WTU_Note__c wNote {get;set;}
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
    public String selectedIndexToNew {get;set;}
    public String checkBoxValue {get;set;}
    public String temp {get;set;}
    public VOC_Data_Entry__c startDate {get;set;}
    public VOC_Data_Entry__c endDate {get;set;}
    public String viewType {get;set;}
    public String searchMessage {get;set;}
    public Boolean disableReview {get;set;}
    
    private String wtuId = '';
    private String wtuNoteId = '';
    //private Map<Id, WTU_Note__c> wNoteOldValues = new Map<Id, WTU_Note__c>();
    //------------------------------------------------------
    public List<WTUNote> listWTU {get;set;}
    //public List<WTU_Note__c> listWTURec;
    public Boolean isModified {get;set;}
    public Boolean displayPopup {get; set;}
    public Boolean isNext {get;set;}
    public Boolean isSave {get;set;}
    public Boolean flag;
    private Boolean hasVOCValidationFailures;
    //----------------------------------------------------
    //paging
    public String recordsShowing {get;set;}
    public Integer rowStart {get;set;}
    public Boolean nextButton {get;set;}
    public Boolean previousButton {get;set;} 
    public Long totalPages = 0;
    public Integer MAX_WTU_Notes_PER_PAGE {get;set;}
    public string SelectedWTUNoteId {get;set;}
    public Integer recordsFound;
    
    //SORTING
    private String sortExp = '';
    public String sortDirection = 'ASC';
    
    public WTUNoteListView(Apexpages.Standardcontroller sc) {
        listWTU = new List<WTUNote>();
        isModified = false;
        isNext = false;
        isSave = false;
        flag = false;
        hasVOCValidationFailures = false;
        rowStart = 0;
        MAX_WTU_Notes_PER_PAGE = 10;
        //MAX_WTU_Notes_PER_PAGE = 4;
        disableReview = true;
        sortExpression = 'Name';
        sortDirection = 'ASC';
        startDate = new VOC_Data_Entry__c();
        startDate.Created_Date__c = null;
        endDate = new VOC_Data_Entry__c();
        endDate.Created_Date__c = null;
        viewType = '';
        
        User curUser = [Select Id, ProfileId, Profile.Name From User Where Id =: Userinfo.getUserId()];
        if(curUser.ProfileId != null && (curUser.Profile.Name == 'Marketing Admin' || curUser.Profile.Name.contains('System Administrator'))) disableReview = false;
    }
    
    public void retrieveWTUNotes() {
        //System.debug('retrieveWTUNotes Called');
        listWTU = new List<WTUNote>();
        rowStart = 0;
        recordsShowing = '';
        Boolean hasError = false;
        if(startDate.Created_Date__c == null && (viewType == null || viewType == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Start Date'));
            hasError = true;
        }
        if(endDate.Created_Date__c == null && (viewType == null || viewType == '')) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select End Date'));
            hasError = true;
        }
        if(startDate.Created_Date__c != null && endDate.Created_Date__c != null && (viewType == null || viewType == '') && endDate.Created_Date__c < startDate.Created_Date__c) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Sorry, End Date cannot be past date!'));
            hasError = true;
        }
        if(hasError) return;
        performQuery(false);
    }
    //---------------------------------------
    public void closePopup()
    {       
        displayPopup = false;   
    }    
    public void showPopup()
    {
        displayPopup = true;   
    }   
    //----------------------------------------
    private void performQuery(Boolean isSorting) {
        listWTU = new List<WTUNote>();
        if(!isSorting) {
            sortExpression = 'Name';
            sortDirection = 'ASC';
        }
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        /*List<WTU_Note__c> listWTURec = [Select w.Week_Ends__c, w.WTU__c, w.Type__c, w.Task__c, w.Task_ID__c, w.Subject__c, w.Special_Topic__c, w.Sales_Call__c, 
                        w.Project__c, w.Product_Line__c, w.Note__c, w.Note_Type__c, w.Name, w.Market_Segment__c,w.Reviewed__c, w.Market_Family__c, 
                        w.Line_of_Business__c, w.Lead__c, w.Id, w.Event_ID__c, w.Contact__c, w.Account__c, Add_to_VOC_Products__c, 
                        Add_to_VOC_Marketing_Supports__c, Add_to_VOC_Marketing_Programs__c, Add_to_VOC_Miscellaneous__c  
                        From WTU_Note__c w Where Week_Ends__c >= :startDate AND Week_Ends__c < :endDate 
                        AND Add_to_VOC_Marketing_Programs__c = false AND Add_to_VOC_Marketing_Supports__c = false 
                        AND Add_to_VOC_Miscellaneous__c = false AND Add_to_VOC_Products__c = false ];*/
        List<WTU_Note__c> listWTURec;
        Date sDate = startDate.Created_Date__c;
        Date eDate = endDate.Created_Date__c;
        String viewCondition = '';
        if(viewType != null && viewType != '') {
            if(viewType == 'Current Year') {
                viewCondition = 'Where Week_Ends__c = THIS_YEAR ';
            }
            if(viewType == 'Past Year') {
                viewCondition = 'Where Week_Ends__c = LAST_YEAR ';
            }
            if(viewType == 'This Week') {
                viewCondition = 'Where Week_Ends__c = THIS_WEEK ';
            }
            if(viewType == 'Last Week') {
                viewCondition = 'Where Week_Ends__c = LAST_WEEK ';
            }
            if(viewType == 'Today') {
                viewCondition = 'Where Week_Ends__c = TODAY ';
            }
            if(viewType == 'All Reviewed') {
                viewCondition = 'Where Reviewed__c = true ';
            }
            if(viewType == 'All Un-Reviewed') {
                viewCondition = 'Where Reviewed__c = false ';
            }
        } else if(viewType == null || viewType == '') {
            viewCondition = 'Where Week_Ends__c >= :sDate AND Week_Ends__c < :eDate';
        }
        if(isSorting) {
            String qCondi;
            if(viewCondition != null && viewCondition != '') {
                qCondi = viewCondition + ' and ' + sortExpression + ' != null ';
            } else { 
                qCondi = 'Where ' + sortExpression + ' != null ';
            }
            listWTURec = Database.query('Select w.Week_Ends__c, w.WTU__c, w.Type__c, w.Task__c, w.Task_ID__c, w.Subject__c, w.Special_Topic__c, w.Sales_Call__c, ' +
                        'w.Project__c, w.Product_Line__c, w.Note__c, w.Note_Type__c, w.Name, w.Market_Segment__c, w.Reviewed__c,w.Market_Family__c, ' +
                        'w.Line_of_Business__c, w.Lead__c, w.Id, w.Event_ID__c, w.Contact__c, w.Account__c, Add_to_VOC_Products__c, ' +
                        'Add_to_VOC_Marketing_Supports__c, Add_to_VOC_Marketing_Programs__c, Add_to_VOC_Miscellaneous__c ' +
                        'From WTU_Note__c w ' + qCondi + ' order by ' + sortFullExp);
            
            if(viewCondition != null && viewCondition != '') {
                qCondi = viewCondition + ' and ' + sortExpression + ' = null ';
            } else {
                qCondi = 'Where ' + sortExpression + ' = null ';
            }
            if(viewType != 'All') {
                List<WTU_Note__c> listWTURecWithNull = Database.query('Select w.Week_Ends__c, w.WTU__c, w.Type__c, w.Task__c, w.Task_ID__c, w.Subject__c, w.Special_Topic__c, w.Sales_Call__c, ' +
                            'w.Project__c, w.Product_Line__c, w.Note__c, w.Note_Type__c, w.Name, w.Market_Segment__c, w.Reviewed__c,w.Market_Family__c, ' +
                            'w.Line_of_Business__c, w.Lead__c, w.Id, w.Event_ID__c, w.Contact__c, w.Account__c, Add_to_VOC_Products__c, ' +
                            'Add_to_VOC_Marketing_Supports__c, Add_to_VOC_Marketing_Programs__c, Add_to_VOC_Miscellaneous__c ' +
                            'From WTU_Note__c w ' + qCondi + ' order by ' + sortFullExp);
                if(listWTURecWithNull.size() > 0) {
                    listWTURec.addAll(listWTURecWithNull);
                }
            }
        } else {
            /*if(viewCondition != '') {
                viewCondition = viewCondition.replace('and', '');
                viewCondition = ' and ' + viewCondition;
            }*/
            System.debug('query:'+ 'Select w.Week_Ends__c, w.WTU__c, w.Type__c, w.Task__c, w.Task_ID__c, w.Subject__c, w.Special_Topic__c, w.Sales_Call__c, ' +
                        'w.Project__c, w.Product_Line__c, w.Note__c, w.Note_Type__c, w.Name, w.Market_Segment__c, w.Reviewed__c,w.Market_Family__c, ' +
                        'w.Line_of_Business__c, w.Lead__c, w.Id, w.Event_ID__c, w.Contact__c, w.Account__c, Add_to_VOC_Products__c, ' +
                        'Add_to_VOC_Marketing_Supports__c, Add_to_VOC_Marketing_Programs__c, Add_to_VOC_Miscellaneous__c ' +
                        'From WTU_Note__c w ' + viewCondition + ' order by ' + sortFullExp);
            listWTURec = Database.query('Select w.Week_Ends__c, w.WTU__c, w.Type__c, w.Task__c, w.Task_ID__c, w.Subject__c, w.Special_Topic__c, w.Sales_Call__c, ' +
                        'w.Project__c, w.Product_Line__c, w.Note__c, w.Note_Type__c, w.Name, w.Market_Segment__c, w.Reviewed__c,w.Market_Family__c, ' +
                        'w.Line_of_Business__c, w.Lead__c, w.Id, w.Event_ID__c, w.Contact__c, w.Account__c, Add_to_VOC_Products__c, ' +
                        'Add_to_VOC_Marketing_Supports__c, Add_to_VOC_Marketing_Programs__c, Add_to_VOC_Miscellaneous__c ' +
                        'From WTU_Note__c w ' + viewCondition + ' order by ' + sortFullExp);
        }
        //wNoteOldValues = new Map<Id, WTU_Note__c>(listWTURec);
        System.debug('listWTURec lst == ' + listWTURec.size());
        System.debug('rowStart: '+rowStart);
        System.debug('MAX_WTU_Notes_PER_PAGE = ' + MAX_WTU_Notes_PER_PAGE);
        for(Integer i=rowStart; i < (rowStart + MAX_WTU_Notes_PER_PAGE);i++){
            if(i >= listWTURec.size()) break;
            WTUNote w = new WTUNote();
            w.wNote = listWTURec[i];
            System.debug('listWTURec[i]'+listWTURec[i]);
            w.wIndex = listWTU.size();
            listWTU.add(w);
        }
        System.debug('listWTU'+listWTU.size());

        recordsFound = listWTURec.size();
        //recordsFound = listWTU.size();
        Decimal ttlPages = Decimal.valueOf(recordsFound).divide(MAX_WTU_Notes_PER_PAGE, 2, System.RoundingMode.UP);
        System.debug('ttlPages: '+ttlPages);
        totalPages = ttlPages.round(System.RoundingMode.UP);
        if(recordsFound > MAX_WTU_Notes_PER_PAGE) {
            previousButton = false;
            nextButton = true;
        }
        System.debug('Record Found::'+recordsFound);
        System.debug('Max_WTU_Notes_PER_PAGE:: '+MAX_WTU_Notes_PER_PAGE);
        recordShowingMessage(recordsFound);
        if(recordsFound == 0)searchMessage = 'No records found';
    }
    
    private void recordShowingMessage(Integer recordsFound) {
        System.debug('rowStart: '+rowStart);
        System.debug('MAX_WTU_Notes_PER_PAGE: '+MAX_WTU_Notes_PER_PAGE);
        if(recordsFound > MAX_WTU_Notes_PER_PAGE) {
            Integer tmp1 = ((rowStart/MAX_WTU_Notes_PER_PAGE) * MAX_WTU_Notes_PER_PAGE) + 1;
            Integer tmp2 = rowStart + MAX_WTU_Notes_PER_PAGE;
            if(tmp2 > recordsFound) {
                tmp2 = tmp1 + (recordsFound - tmp1);
            }
            recordsShowing = 'showing ' + String.valueOf(tmp1) + '-' + String.valueOf(tmp2) + ' of ' + String.valueOf(recordsFound) + ((recordsFound == 1) ? ' record' : ' records');
        } else {
            recordsShowing = 'showing 1-' + String.valueOf(recordsFound) + ' of ' + String.valueOf(recordsFound) + ((recordsFound == 1) ? ' record' : ' records');
        }
    }
    
    public Pagereference saveWtuNote() {
        isModified = false;
        isSave = true;
        closePopup();
        //------------------------
        Pagereference pr;
        System.debug('listWTU Value Before Save::::'+listWTU);
        Savepoint sp = Database.setSavepoint();
        try {
            List<VOC_Data_Entry__c> vocUpsert = new List<VOC_Data_Entry__c>();
            List<WTU_Note__c> wtuNoteUpdate = new List<WTU_Note__c>();
            hasVOCValidationFailures = false;
            
            for(WTUNote w : listWTU) {
                System.debug('w.addProduct'+w.addProduct);
                if(w.addProduct) {
                    Boolean validationFailed = VOCUtil.validateVOC(w.productLineList, 'Products', w.wNote.Name + ': ');
                    System.debug('validationFailed value:: '+validationFailed);
                    if(validationFailed) hasVOCValidationFailures = true;
                    System.debug('hasVOCValidationFailures value:: '+hasVOCValidationFailures);
                }
            }
            if(hasVOCValidationFailures) return pr;
            
            for(WTUNote w : listWTU) {
                Boolean updateWNote = false;
                if(w.addProduct) {
                    List<VOC_Data_Entry__c> voctemp = new List<VOC_Data_Entry__c>();
                    voctemp = VOCUtil.doAdd(voctemp, w.productLineList, 'Products', 'WTU Note', w.wNote.Id);
                    if(voctemp.size() > 0) {
                        vocUpsert.addAll(vocTemp);
                        if(!w.wNote.Add_to_VOC_Products__c) {
                            w.wNote.Add_to_VOC_Products__c = true;
                            updateWNote = true;
                        }
                    }
                }
                if(w.addSales) {
                    List<VOC_Data_Entry__c> voctemp = new List<VOC_Data_Entry__c>();
                    voctemp = VOCUtil.doAdd(voctemp, w.salesLineList, 'Marketing Supports', 'WTU Note', w.wNote.Id);
                    if(voctemp.size() > 0) {
                        vocUpsert.addAll(vocTemp);
                        if(!w.wNote.Add_to_VOC_Marketing_Supports__c) {
                            w.wNote.Add_to_VOC_Marketing_Supports__c = true;
                            updateWNote = true;
                        }
                    }
                }
                if(w.addService) {
                    List<VOC_Data_Entry__c> voctemp = new List<VOC_Data_Entry__c>();
                    voctemp = VOCUtil.doAdd(voctemp, w.serviceLineList, 'Marketing Programs', 'WTU Note', w.wNote.Id);
                    if(voctemp.size() > 0) {
                        vocUpsert.addAll(vocTemp);
                        if(!w.wNote.Add_to_VOC_Marketing_Programs__c) {
                            w.wNote.Add_to_VOC_Marketing_Programs__c = true;
                            updateWNote = true;
                        }
                    }
                }
                if(w.addOther) {
                    List<VOC_Data_Entry__c> voctemp = new List<VOC_Data_Entry__c>();
                    voctemp = VOCUtil.doAdd(voctemp, w.otherLineList, 'Miscellaneous', 'WTU Note', w.wNote.Id);
                    if(voctemp.size() > 0) {
                        vocUpsert.addAll(vocTemp);
                        if(!w.wNote.Add_to_VOC_Miscellaneous__c) {
                            w.wNote.Add_to_VOC_Miscellaneous__c = true;
                            updateWNote = true;
                        }
                    }
                }
                if(updateWNote) wtuNoteUpdate.add(w.wNote);
            }
            if(vocUpsert.size() > 0) upsert vocUpsert;
            //System.debug('listWTU values::::'+listWTU);
            if(wtuNoteUpdate.size() > 0) upsert wtuNoteUpdate;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Your changes were saved successfully'));
            
            performQuery(false);
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
        }
        System.debug('listWTU Value After Save::::'+listWTU);       
        return pr;
    }
    
    
    public void addProductLine() {
        if(checkBoxValue == 'true'){
            isModified = true;
            isNext = false;
            isSave = false;
            flag = true;
        }
        else if(checkBoxValue == null && flag == true){
            isModified = true;
        }
        else isModified = false;
     //  System.debug('selectedIndexToNew: '+selectedIndexToNew);
        //System.debug('checkBoxValue: '+checkBoxValue);
        if(selectedIndexToNew != null && selectedIndexToNew != '') {
            Integer curIndex = Integer.valueOf(selectedIndexToNew);
            if(checkBoxValue == 'true' || checkBoxValue == null) {
                WTU_Note__c wn = listWTU.get(curIndex).wNote;
                System.debug('WTUNote__c Value:::'+wn);
                if(wn.Add_to_VOC_Products__c && checkBoxValue == 'true') {
                    listWTU = VOCUtil.addVOCLine(listWTU, wn.Id, 'Products', curIndex);
                    for(VOCLine obj : listWTU.get(curIndex).productLineList){
                        if(obj.vocEntry.Product_Line__c != null){
                            obj.pFamilyOptions = VOCUtil.prepareProductFamily(obj.vocEntry.Product_Line__c);
                        }
                        if(obj.vocEntry.Product_Family__c != null){
                            obj.brandOptions = VOCUtil.prepareBrand(obj.vocEntry.Product_Family__c);
                        }
                        if(obj.vocEntry.Brand__c != null){
                            obj.mFamilyOptions = VOCUtil.prepareMarketFamily(obj.vocEntry.Brand__c);
                        }
                        if(obj.vocEntry.Market_Family__c != null){
                            obj.mSegmentOptions = VOCUtil.prepareMarketSegment(obj.vocEntry.Market_Family__c);
                        }
                    }
                } else {
                    VOCLine vLine = new VOCLine();
                    vLine.rIndex = listWTU.get(curIndex).productLineList.size();
                    vLine.vocEntry.Category__c = 'Products';
                    listWTU.get(curIndex).productLineList.add(vLine);
                    System.debug('listWTU ####'+ listWTU);
                    //System.debug('listWTU currentIndex'+listWTU.get(curIndex).productLineList.add(vLine));
                }
            } else if(checkBoxValue == 'false') {
                System.currentPageReference().getParameters().put('wIndex', selectedIndexToNew);
                clearProductLineItems();
            }
            selectedIndexToNew = null;
            checkBoxValue = null;
        }
    }
    
    public void addSalesLine() {
        if(checkBoxValue == 'true'){
            isModified = true;
            isNext = false;
            isSave = false;
            flag = true;
        }
        else if(checkBoxValue == null && flag == true){
            isModified = true;
        }
        else isModified = false;
        if(selectedIndexToNew != null && selectedIndexToNew != '') {
            Integer curIndex = Integer.valueOf(selectedIndexToNew);
            if(checkBoxValue == 'true' || checkBoxValue == null) {
                WTU_Note__c wn = listWTU.get(curIndex).wNote;
                if(wn.Add_to_VOC_Marketing_Supports__c && checkBoxValue == 'true') {
                    listWTU = VOCUtil.addVOCLine(listWTU, wn.Id, 'Marketing Supports', curIndex);
                } else {
                    VOCLine vLine = new VOCLine();
                    vLine.rIndex = listWTU.get(curIndex).salesLineList.size();
                    vLine.vocEntry.Category__c = 'Marketing Supports';
                    listWTU.get(curIndex).salesLineList.add(vLine);
                }
            } else if(checkBoxValue == 'false') {
                System.currentPageReference().getParameters().put('wIndex', selectedIndexToNew);
                clearSalesLineItems();
            }
            selectedIndexToNew = null;
            checkBoxValue = null;
        }
    }
    
    public void addServiceLine() {
        if(checkBoxValue == 'true'){
            isModified = true;
            isNext = false;
            isSave = false;
            flag = true;
        }
        else if(checkBoxValue == null && flag == true){
            isModified = true;
        }
        else isModified = false;
        if(selectedIndexToNew != null && selectedIndexToNew != '') {
            Integer curIndex = Integer.valueOf(selectedIndexToNew);
            if(checkBoxValue == 'true' || checkBoxValue == null) {
                WTU_Note__c wn = listWTU.get(curIndex).wNote;
                if(wn.Add_to_VOC_Marketing_Programs__c && checkBoxValue == 'true') {
                    listWTU = VOCUtil.addVOCLine(listWTU, wn.Id, 'Marketing Programs', curIndex);
                } else {
                    VOCLine vLine = new VOCLine();
                    vLine.rIndex = listWTU.get(curIndex).serviceLineList.size();
                    vLine.vocEntry.Category__c = 'Marketing Programs';
                    listWTU.get(curIndex).serviceLineList.add(vLine);
                }
            } else if(checkBoxValue == 'false') {
                System.currentPageReference().getParameters().put('wIndex', selectedIndexToNew);
                clearServiceLineItems();
            }
            selectedIndexToNew = null;
            checkBoxValue = null;
        }
    }
    
    public void addOtherLine() {
        if(checkBoxValue == 'true'){
            isModified = true;
            isNext = false;
            isSave = false;
            flag = true;
        }
        else if(checkBoxValue == null && flag == true){
            isModified = true;
        }
        else isModified = false;
        if(selectedIndexToNew != null && selectedIndexToNew != '') {
            Integer curIndex = Integer.valueOf(selectedIndexToNew);
            if(checkBoxValue == 'true' || checkBoxValue == null) {
                WTU_Note__c wn = listWTU.get(curIndex).wNote;
                if(wn.Add_to_VOC_Miscellaneous__c && checkBoxValue == 'true') {
                    listWTU = VOCUtil.addVOCLine(listWTU, wn.Id, 'Miscellaneous', curIndex);
                } else {
                    VOCLine vLine = new VOCLine();
                    vLine.rIndex = listWTU.get(curIndex).otherLineList.size();
                    vLine.vocEntry.Category__c = 'Miscellaneous';
                    listWTU.get(curIndex).otherLineList.add(vLine);
                }
            } else if(checkBoxValue == 'false') {
                System.currentPageReference().getParameters().put('wIndex', selectedIndexToNew);
                clearOtherLineItems();
            }
            selectedIndexToNew = null;
            checkBoxValue = null;
        }
    }
    
    public void removeProductLine() {
        isModified = true;
        String rInd = System.currentPageReference().getParameters().get('rIndex');
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(rInd != null && wInd != null) {
            Integer rIndex = Integer.valueOf(rInd);
            Integer wIndex = Integer.valueOf(wInd);
            Id vocId = listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Id;
            if(vocId != null) delete [Select Id From VOC_Data_Entry__c Where Id =: vocId];
            listWTU.get(wIndex).productLineList.remove(rIndex);
            Integer newIndex = 0;
            List<VOCLine> temp = new List<VOCLine>();
            for(VOCLine v : listWTU.get(wIndex).productLineList) {
                v.rIndex = newIndex;
                temp.add(v);
                newIndex++;
            }
            listWTU.get(wIndex).productLineList = temp;
        }
    }
    
    public void removeSalesLine() {
        isModified = true;
        String rInd = System.currentPageReference().getParameters().get('rIndex');
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(rInd != null && wInd != null) {
            Integer rIndex = Integer.valueOf(rInd);
            Integer wIndex = Integer.valueOf(wInd);
            Id vocId = listWTU.get(wIndex).salesLineList.get(rIndex).vocEntry.Id;
            if(vocId != null) delete [Select Id From VOC_Data_Entry__c Where Id =: vocId];
            listWTU.get(wIndex).salesLineList.remove(rIndex);
            Integer newIndex = 0;
            List<VOCLine> temp = new List<VOCLine>();
            for(VOCLine v : listWTU.get(wIndex).salesLineList) {
                v.rIndex = newIndex;
                temp.add(v);
                newIndex++;
            }
            listWTU.get(wIndex).salesLineList = temp;
        }
    }
    
    public void doReviewed(){
        for(WTU_Note__c w : [Select Id, Reviewed__c From WTU_Note__c Where Id = : SelectedWTUNoteId ]){
            if(w.Reviewed__c == true){
                w.Reviewed__c = false;
            }
            else if(w.Reviewed__c == false){
                w.Reviewed__c = true;
            }
            
            update w;
        }   
    }
    
    public void removeServiceLine() {
        isModified = true;
        String rInd = System.currentPageReference().getParameters().get('rIndex');
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(rInd != null && wInd != null) {
            Integer rIndex = Integer.valueOf(rInd);
            Integer wIndex = Integer.valueOf(wInd);
            Id vocId = listWTU.get(wIndex).serviceLineList.get(rIndex).vocEntry.Id;
            if(vocId != null) delete [Select Id From VOC_Data_Entry__c Where Id =: vocId];
            listWTU.get(wIndex).serviceLineList.remove(rIndex);
            Integer newIndex = 0;
            List<VOCLine> temp = new List<VOCLine>();
            for(VOCLine v : listWTU.get(wIndex).serviceLineList) {
                v.rIndex = newIndex;
                temp.add(v);
                newIndex++;
            }
            listWTU.get(wIndex).serviceLineList = temp;
        }
    }
    
    public void removeOtherLine() {
        isModified = true;
        String rInd = System.currentPageReference().getParameters().get('rIndex');
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(rInd != null && wInd != null) {
            Integer rIndex = Integer.valueOf(rInd);
            Integer wIndex = Integer.valueOf(wInd);
            Id vocId = listWTU.get(wIndex).otherLineList.get(rIndex).vocEntry.Id;
            if(vocId != null) delete [Select Id From VOC_Data_Entry__c Where Id =: vocId];
            listWTU.get(wIndex).otherLineList.remove(rIndex);
            Integer newIndex = 0;
            List<VOCLine> temp = new List<VOCLine>();
            for(VOCLine v : listWTU.get(wIndex).otherLineList) {
                v.rIndex = newIndex;
                temp.add(v);
                newIndex++;
            }
            listWTU.get(wIndex).otherLineList = temp;
        }
    }
    
    public void clearProductLineItems() {
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(wInd != null) {
            listWTU.get(Integer.valueOf(wInd)).productLineList.clear();
        }
    }
    
    public void clearSalesLineItems() {
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(wInd != null) {
            listWTU.get(Integer.valueOf(wInd)).salesLineList.clear();
        }
    }
    
    public void clearServiceLineItems() {
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(wInd != null) {
            listWTU.get(Integer.valueOf(wInd)).serviceLineList.clear();
        }
    }
    
    public void clearOtherLineItems() {
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(wInd != null) {
            listWTU.get(Integer.valueOf(wInd)).otherLineList.clear();
        }
    }
    
    
    public void getProductFamily() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        System.debug('listWTU before'+listWTU);
        if(rowIndex != null && rowIndex != '') {
            System.debug('listWTU'+listWTU);
            Integer rIndex = Integer.valueOf(rowIndex);
            Integer wIndex = Integer.valueOf(wInd);
            System.debug('wIndex ###'+ wIndex);
            
            
            System.debug('listWTU'+listWTU.size());
            System.debug('listWTU.get(wIndex).productLineList' +listWTU.get(wIndex).productLineList.size());
            List<Selectoption> options = VOCUtil.prepareProductFamily(listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Product_Line__c);
            listWTU.get(wIndex).productLineList.get(rIndex).pFamilyOptions = options;
            listWTU.get(wIndex).productLineList.get(rIndex).brandOptions = new Selectoption[]{new Selectoption('', '--None--')};
                listWTU.get(wIndex).productLineList.get(rIndex).mFamilyOptions = new Selectoption[]{new Selectoption('', '--None--')};
                    listWTU.get(wIndex).productLineList.get(rIndex).mSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
                        if(options.size() == 2) {
                            listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Product_Family__c = options.get(1).getValue();
                            getBrand();
                        }
        }
    }
    
    public void getBrand() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        System.debug('wInd'+wInd);
        System.debug('wInd'+rowIndex);
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
            Integer wIndex = Integer.valueOf(wInd);
            System.debug('listWTU in get Brand'+listWTU.size());
            System.debug('wIndex in get Brand'+ wIndex);
            System.debug('rIndex in get Brand'+ rIndex);
            System.debug('listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Product_Family__c'+listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Product_Family__c);
            System.debug('listWTU.get(wIndex).productLineList'+listWTU.get(wIndex).productLineList);
            List<Selectoption> options = VOCUtil.prepareBrand(listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Product_Family__c);
            
            listWTU.get(wIndex).productLineList.get(rIndex).brandOptions = options;
            listWTU.get(wIndex).productLineList.get(rIndex).mFamilyOptions = new Selectoption[]{new Selectoption('', '--None--')};
            listWTU.get(wIndex).productLineList.get(rIndex).mSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
            if(options.size() == 2) {
                listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Brand__c = options.get(1).getValue();
                getMarketFamily();
            }
        }
    }
    
    public void getMarketFamily() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
            Integer wIndex = Integer.valueOf(wInd);
            List<Selectoption> options = VOCUtil.prepareMarketFamily(listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Brand__c);
            listWTU.get(wIndex).productLineList.get(rIndex).mFamilyOptions = options;
            listWTU.get(wIndex).productLineList.get(rIndex).mSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
            if(options.size() == 2) {
                listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Market_Family__c = options.get(1).getValue();
                getMarketSegment();
            }
        }
    }
    
    public void getMarketSegment() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        String wInd = System.currentPageReference().getParameters().get('wIndex');
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
            Integer wIndex = Integer.valueOf(wInd);
            List<Selectoption> options = VOCUtil.prepareMarketSegment(listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Market_Family__c);
            listWTU.get(wIndex).productLineList.get(rIndex).mSegmentOptions = options;
            if(options.size() == 2) listWTU.get(wIndex).productLineList.get(rIndex).vocEntry.Market_Segment__c = options.get(1).getValue();
        }
    }
    
    public void handleNextEvent(){
        if(isModified){
            isModified = false;
            isNext = true;
            showPopup();
        }
        else{
            gotoNextPage();
        }
    }
    
    public void handlePrevEvent(){
        if(isModified){
            isModified = false;
            isNext = false;
            showPopup();
        }
        else{
            gotoPreviousPage();
        }
    }
    
    public void handleSaveEvent(){
        saveWtuNote();
        if(!hasVOCValidationFailures){
            if(isNext){
                gotoNextPage();
            }
            else{
                gotoPreviousPage();
            }
        }
        else isModified = true;
    }
    
    public void gotoNextPage() {
        try {
            isModified = false;
            closePopup();
            rowStart = pagingVisibility(rowStart, '+');
            //System.debug('Row Start:::::' + rowStart);
            //---------------------------------------------------------------------------------
            performQuery(false);
            Decimal ttlPages = Decimal.valueOf(recordsFound).divide(MAX_WTU_Notes_PER_PAGE, 2, System.RoundingMode.UP);
            //System.debug('Total Pages::::: '+ttlPages);
            //System.debug('ttlPages: '+ttlPages);
            totalPages = ttlPages.round(System.RoundingMode.UP);
            //--------------------------------------------------------------------------------------------
            previousButton = true;
            //	System.debug('totalPages: '+totalPages);
            if(((rowStart / MAX_WTU_Notes_PER_PAGE) + 1) == totalPages) nextButton = false;
            else nextButton = true;
            recordShowingMessage(recordsFound);
        } catch(Exception ex) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); }
    }
    
    public void gotoPreviousPage() {
        try {
            isModified = false;
            closePopup();
            rowStart = pagingVisibility(rowStart, '-');
            //---------------------------------------------------------------------------------
            performQuery(false);
            Decimal ttlPages = Decimal.valueOf(recordsFound).divide(MAX_WTU_Notes_PER_PAGE, 2, System.RoundingMode.UP);
            //System.debug('ttlPages: '+ttlPages);
            totalPages = ttlPages.round(System.RoundingMode.UP);
            //--------------------------------------------------------------------------------------------
            nextButton = true;
            if((rowStart / MAX_WTU_Notes_PER_PAGE) == 0) previousButton = false;
            else previousButton = true;
            recordShowingMessage(recordsFound);
        } catch(Exception ex) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage())); }
    }
    
    private Integer pagingVisibility(Integer rs, String operator) {
        Integer oldPageIndex = rs / MAX_WTU_Notes_PER_PAGE;
        if(operator == '+') rs = rowStart + MAX_WTU_Notes_PER_PAGE;
        if(operator == '-') rs = rowStart - MAX_WTU_Notes_PER_PAGE;
        return rs;
    }
    
    //SETS THE SORT DIRECTION FOR THE SORTING COLUMN
    public String sortExpression{
        get {
            return sortExp;
        }
        set {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'DESC')? 'ASC' : 'DESC';
            else
                sortDirection = 'ASC';
                sortExp = value;
        }
    }
    
    //method returning sort direction value i.e ASC
    public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    //METHOD TO SORT THE SEARCH RESULT COLUMNS
    public void sortData() {
        if(listWTU.size() > 0) {
            listWTU = new List<WTUNote>();
            rowStart = 0;
            recordsShowing = '';
            performQuery(true);
        }
    }
}