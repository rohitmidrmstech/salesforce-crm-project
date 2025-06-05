// ==================================================================================
//   Object: ProDialogueInputFormController
//  Company: Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Prodialogue page controller class to capture the voc's and store them
// ==================================================================================
//  Changes: 2013-10-29 Initial version.
//           1. Madan (Jun 9, 2014) - added below logic for bind dipendent picklist values.
//           2. Arpit (Dec 8, 2014) - added logic to store data in Temperory object and resume it from Temp.
//           3. Arpit (Feb 20, 2015) - added logic for discard button from the page.
// ==================================================================================

public with sharing class ProDialogueInputFormController_Siding {
    public ProDialogue_Input__c proDialogue {get;set;}
    public VOC_Input_Form_Temp__c vocInputFormTemp {get;set;}
    public List<VOC_Input_Form_Temp__c> vocInputFormTempList{get;set;}
    public List<Attendee> attendeeList {get;set;}
    public List<VOCLine> productLineList {get;set;}
    public List<VOCLine> salesLineList {get;set;}
    public List<VOCLine> serviceLineList {get;set;}
    public List<VOCLine> otherLineList {get;set;}
    public String selectedIndexToDelete {get;set;}
    
    public String facilitator {get;set;}
    public String tm {get;set;}
    public String facilitatorId {get;set;}
    public String tmId {get;set;}
    public List<User> facilitatorFound {get;set;}
    public List<User> tmFound {get;set;}
    public Boolean showFacilitatorSearchPanel {get;set;}
    public Boolean showTMSearchPanel {get;set;}
    public Boolean showErrorMessage {get;set;}
    public Boolean blnShowConfirmBox {get; set;}
    public String vocInputFromTempId {get;set;}
    
    private String proDialogueId;
    
    public ProDialogueInputFormController_Siding(Apexpages.standardController sc) {
        proDialogue = new ProDialogue_Input__c();
        attendeeList = new List<Attendee>();
        productLineList = new List<VOCLine>();
        salesLineList = new List<VOCLine>();
        serviceLineList = new List<VOCLine>();
        otherLineList = new List<VOCLine>();
        showFacilitatorSearchPanel = false;
        showTMSearchPanel = false;
        showErrorMessage = false;
        blnShowConfirmBox = false;
        facilitatorFound = new List<User>();
        tmFound = new List<User>();
        
        proDialogueId = sc.getId();
        System.debug('jjj'+proDialogueId);
        
        String scVar = Apexpages.currentPage().getParameters().get('sc');
        if(scVar != null && scVar != ''){
            updateTempObj();
        } else {
            if(proDialogueId != null) {
                proDialogue = [Select p.TM__c, p.TM__r.Name, p.Region__c, p.OwnerId, p.Other_Participants__c, p.Notes__c, p.No1_of_Attendees__c , p.Name, 
                                p.Meeting_Date__c, p.Information_Source__c, p.Id, p.Facilitator__c, p.Facilitator__r.Name, p.City_State__c, p.Audience__c, p.Active__c 
                                From ProDialogue_Input__c p Where Id =: proDialogueId];
                
                Integer indexCounter = 0;
                if(proDialogue.TM__r.Name != null) {
                    tm = proDialogue.TM__r.Name;
                    tmId = proDialogue.TM__c;
                }
                if(proDialogue.Facilitator__r.Name != null) {
                    facilitator = proDialogue.Facilitator__r.Name;
                    facilitatorId = proDialogue.Facilitator__c;
                }
                //load Attendees
                List<ProDialogue_Input_Attendee__c> proAttendees = [Select p.Role__c, p.ProDialogue_Input__c, p.Name, p.Lead__c, p.Id, p.Contact__c 
                                                                    From ProDialogue_Input_Attendee__c p Where ProDialogue_Input__c =: proDialogueId];
                for(ProDialogue_Input_Attendee__c p : proAttendees) {
                    Attendee att = new Attendee();
                    att.rIndex = indexCounter;
                    att.proDialogueAttendee = p;
                    if(p.Lead__c != null) att.attendeeValue.WhoId = p.Lead__c;
                    if(p.Contact__c != null) att.attendeeValue.WhoId = p.Contact__c;
                    attendeeList.add(att);
                    indexCounter++;
                }
                
                //load voc for each category
                VOCUtil_Siding.VOCItemWrapper existingVOCs = VOCUtil_Siding.fetchExistingVOCs(proDialogueId);
                productLineList = existingVOCs.productLineList;
                
                //Name - Madan (Jun 9, 2014)
                //Description - added below logic for bind dipendent picklist values.
                //-----------------------------------------------
                for(VOCLine obj : productLineList){
                    if(obj.vocEntry.Product_Line__c != null){
                        obj.pFamilyOptions = VOCUtil_Siding.prepareProductFamily(obj.vocEntry.Product_Line__c);
                    }
                    if(obj.vocEntry.Product_Family__c != null){
                        obj.brandOptions = VOCUtil_Siding.prepareBrand(obj.vocEntry.Product_Family__c);
                    }
                    if(obj.vocEntry.Brand_siding__c != null){
                        obj.mFamilyOptions = VOCUtil_Siding.prepareMarketFamily(obj.vocEntry.Brand_siding__c);
                    }
                    if(obj.vocEntry.Market_Family__c != null){
                        obj.mSegmentOptions = VOCUtil_Siding.prepareMarketSegment(obj.vocEntry.Market_Family__c);
                    }
                }
                //------------------------------------------------
                
                salesLineList = existingVOCs.salesLineList;
                serviceLineList = existingVOCs.serviceLineList;
                otherLineList = existingVOCs.otherLineList;
                
            }
            //add default attendees
            if(attendeeList.size() == 0) {
                Attendee att = new Attendee();
                att.rIndex = 0;
                attendeeList.add(att);
            }
            
            //add default voc's
            if(productLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Products';
                productLineList.add(vLine);
            }
            
            if(salesLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Marketing Supports';
                salesLineList.add(vLine);
            }
            
            if(serviceLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Marketing Programs';
                serviceLineList.add(vLine);
            }
            
            if(otherLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Miscellaneous';
                otherLineList.add(vLine);
            }
            
            
            //-----------------------------------Arpit adding code resume data from temp---------------------------
            String vocInputFromTemp = 'Select id from VOC_Input_Form_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
            if(proDialogueId != null) vocInputFromTemp += ' and Record_Id__c = ' +'\''+ proDialogueId+'\'';
            else if(proDialogueId == null) vocInputFromTemp += ' and Record_Id__c = null';
            
            vocInputFormTempList = new List<VOC_Input_Form_Temp__c>();
            vocInputFormTempList = Database.query(vocInputFromTemp);
            if(vocInputFormTempList.size() > 0){
                blnShowConfirmBox = true;
            }
            //-------------------------------------------------------------------------------------------------------       
        }
    }
    
    public void searchFacilitator() {
        facilitatorId = null;
        facilitatorFound = searchUsers(facilitator, facilitatorFound, showFacilitatorSearchPanel);
        showFacilitatorSearchPanel = showPanel(facilitatorFound, showFacilitatorSearchPanel);
        System.debug('showFacilitatorSearchPanel: '+showFacilitatorSearchPanel);
    }
    
    public void searchTM() {
        tmId = null;
        tmFound = searchUsers(tm, tmFound, showTMSearchPanel);
        showTMSearchPanel = showPanel(tmFound, showTMSearchPanel);
        System.debug('showTMSearchPanel: '+showTMSearchPanel);
    }
    
    private Boolean showPanel(List<User> usersFound, Boolean showUserSearchPanel) {
        if(usersFound != null && usersFound.size() > 0) showUserSearchPanel = true;
        return showUserSearchPanel;
    }
    
    //Search for the matching user name and emails
    private List<User> searchUsers(String temp, List<User> usersFound, Boolean showUserSearchPanel) {
        usersFound.clear();
        if(temp != null && temp != '' && temp.length() > 2) {
            showUserSearchPanel = true;
            String key = '%' + temp + '%';
            List<User> userList = [Select Id, Name, Email From User Where (Name like :key OR Email like :key) and Email != null and IsActive = true limit 201];
            //Integer i = 0;
            for(User u : userList) {
                usersFound.add(u);
            }
            //if(usersFound.size() == 0) userSearchMessage = 'No Contacts Found';
        } else {
            showUserSearchPanel = false;
        }
        return usersFound;
    }
    
    public void resetFacilitator() {
        showFacilitatorSearchPanel = resetUserPanel(showFacilitatorSearchPanel, facilitatorFound);
    }
    
    public void resetTM() {
        showTMSearchPanel = resetUserPanel(showTMSearchPanel, tmFound);
    }
    
    public Boolean resetUserPanel(Boolean showUserSearchPanel, List<User> usersFound) {
        showUserSearchPanel = false;
        usersFound.clear();
        return showUserSearchPanel;
    }
    
    public void addProductLine() {
        productLineList = VOCUtil_Siding.addProductLine(productLineList, null, null, null, null, null, null);
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
    
    public void addAttendee() {
        Attendee att = new Attendee();
        att.rIndex = attendeeList.size();
        attendeeList.add(att);
    }
    
    public void removeAttendee() {
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        if(delIndex != null && delIndex != '') {
            Id attendeeId = attendeeList.get(Integer.valueOf(delIndex)).proDialogueAttendee.Id;
            if(attendeeId != null) delete [Select Id From ProDialogue_Input_Attendee__c Where Id =: attendeeId];
            attendeeList.remove(Integer.valueOf(delIndex));
            Integer newIndex = 0;
            List<Attendee> temp = new List<Attendee>();
            for(Attendee a : attendeeList) {
                a.rIndex = newIndex;
                temp.add(a);
                newIndex++;
            }
            attendeeList = temp;
        }
    }
    
    public void resetMessageFlag() {
        showErrorMessage = false;
    }
    
    private Boolean validateFacilitatorAndTM(String fId, String tId) {
        Boolean isValid = true;
        Set<String> userIds = new Set<String>();
        if(fId != null && fId != '') userIds.add(fId);
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Facilitator selected. Please select a valid one and try again.'));
            isValid = false;
        }
        if(tId != null && tId != '') userIds.add(tId);
        else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid TM selected. Please select a valid one and try again.'));
            isValid = false;
        }
        if(!isValid) return isValid;
        Map<Id, User> userResult = new Map<Id, User>([Select Id From User Where Id IN :userIds]);
        if(userResult != null && !userResult.containsKey(fId)) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Facilitator selected. Please select a valid one and try again.')); return false; }
        if(userResult != null && !userResult.containsKey(tId)) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid TM selected. Please select a valid one and try again.')); return false; }
        
        return true;
    } 
    
    public Pagereference saveProDialogue() {
        Pagereference pr;
        Savepoint sp = Database.setSavepoint();
        showErrorMessage = true;
        try {
            Boolean validationFailed = VOCUtil_Siding.validateVOC(productLineList, 'Products', '');
            if(validationFailed) return pr;
            
            if(!validateFacilitatorAndTM(facilitatorId, tmId)) return pr;
            proDialogue.Facilitator__c = facilitatorId;
            proDialogue.TM__c = tmId;
            
            upsert proDialogue;
            
            //add Attendees
            List<ProDialogue_Input_Attendee__c> attendeesInsert = new List<ProDialogue_Input_Attendee__c>();
            for(Attendee att : attendeeList) {
                if(att.attendeeValue.WhoId != null) {
                    String attendeeId = att.attendeeValue.WhoId;
                    if(attendeeId.startsWith('003')) {
                        att.proDialogueAttendee.Contact__c = att.attendeeValue.WhoId;
                        att.proDialogueAttendee.Lead__c = null; 
                    }
                    if(attendeeId.startsWith('00Q')) {
                        att.proDialogueAttendee.Lead__c = att.attendeeValue.WhoId;
                        att.proDialogueAttendee.Contact__c = null;
                    }
                    if(att.proDialogueAttendee.ProDialogue_Input__c == null) att.proDialogueAttendee.ProDialogue_Input__c = proDialogue.Id;
                    attendeesInsert.add(att.proDialogueAttendee);
                }
            }
            
            if(attendeesInsert.size() > 0) upsert attendeesInsert;
            
            
            //iterate and add valid voc entries
            List<VOC_Data_Entry__c> vocInsert = new List<VOC_Data_Entry__c>();
            vocInsert = VOCUtil_Siding.doAdd(vocInsert, productLineList, 'Products', 'ProDialogue', proDialogue.Id);
            vocInsert = VOCUtil_Siding.doAdd(vocInsert, salesLineList, 'Marketing Supports', 'ProDialogue', proDialogue.Id);
            vocInsert = VOCUtil_Siding.doAdd(vocInsert, serviceLineList, 'Marketing Programs', 'ProDialogue', proDialogue.Id);
            vocInsert = VOCUtil_Siding.doAdd(vocInsert, otherLineList, 'Miscellaneous', 'ProDialogue', proDialogue.Id);
            
            if(vocInsert.size() > 0) upsert vocInsert;
            deleteMethod();
            
            pr = new Pagereference('/' + proDialogue.Id);
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
        }
        
        return pr;
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
            if(options.size() == 2) {
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
            if(options.size() == 2) {
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
            if(options.size() == 2) {
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
            if(options.size() == 2) productLineList.get(rIndex).vocEntry.Market_Segment__c = options.get(1).getValue();
        }
    }
    
    public class Attendee {
        public ProDialogue_Input_Attendee__c proDialogueAttendee {get;set;}
        public Task attendeeValue {get;set;}
        public Integer rIndex {get;set;}
        
        public Attendee() {
            proDialogueAttendee = new ProDialogue_Input_Attendee__c();
            attendeeValue = new Task();
        }
    }
    
    
    
    //-------------------------------------Arpit Adding code for storing in temp obj------------------------------------------
    
    public void saveButton(){
        try{
            
            vocInputFormTemp = new VOC_Input_Form_Temp__c();
            System.debug('abcdef'+tmId);
            deleteMethod();
            
            Boolean validationFailed = VOCUtil_Siding.validateVOC(productLineList, 'Products', '');
            //if(validationFailed) return pr;
            
            System.debug('123456'+facilitatorId);
            //if(!validateFacilitatorAndTM(facilitatorId, tmId)) return pr;
            if(facilitatorId != null && facilitatorId != '') proDialogue.Facilitator__c = facilitatorId;
            if(tmId != null && tmId != '') proDialogue.TM__c = tmId;
            
            //copying values from page to temp DB variables
            vocInputFormTemp.Meeting_Date__c = proDialogue.Meeting_Date__c;
            vocInputFormTemp.City_State__c = proDialogue.City_State__c;
            vocInputFormTemp.Facilitator__c = proDialogue.Facilitator__c;
            vocInputFormTemp.TM__c = proDialogue.TM__c;
            vocInputFormTemp.Information_Source__c = proDialogue.Information_Source__c;
            vocInputFormTemp.Region__c = proDialogue.Region__c;
            vocInputFormTemp.Audience__c = proDialogue.Audience__c;
            vocInputFormTemp.Other_Participants__c = proDialogue.Other_Participants__c;
            vocInputFormTemp.Notes__c = proDialogue.Notes__c;
            vocInputFormTemp.Active__c = proDialogue.Active__c;
            System.debug('aaaaaaaaaaa');
            vocInputFormTemp.User_Id__c = UserInfo.getUserId();
            System.debug('abcdef');
            if(proDialogueId != null){
                vocInputFormTemp.Record_Id__c = proDialogueId;
            }
            System.debug('vvvvvv');
            upsert vocInputFormTemp;
            System.debug('ccccc');
            
            //---------------------saving records for Attendee temp object--------------------------------
            List<VOC_Input_Temp_Form_Attendee__c> attendeesTempInsert = new List<VOC_Input_Temp_Form_Attendee__c>();
            for(Attendee att : attendeeList) {
                VOC_Input_Temp_Form_Attendee__c tempObj = new VOC_Input_Temp_Form_Attendee__c();
                if(att.attendeeValue.WhoId != null) {
                    String attendeeId = att.attendeeValue.WhoId;
                    if(attendeeId.startsWith('003')) {
                        tempObj.Contact__c = att.attendeeValue.WhoId;
                        tempObj.Lead__c = null; 
                    }
                    if(attendeeId.startsWith('00Q')) {
                        tempObj.Lead__c = att.attendeeValue.WhoId;
                        tempObj.Contact__c = null;
                    }
                    tempObj.Role__c = att.proDialogueAttendee.Role__c;
                    tempObj.VOC_Input_Temp_Form__c = vocInputFormTemp.Id;
                    if (att.proDialogueAttendee.Id != null) tempObj.Record_Id__c = att.proDialogueAttendee.Id;
                    attendeesTempInsert.add(tempObj);
                }
            }
            System.debug('xxxxxx');
            if(attendeesTempInsert.size() > 0) upsert attendeesTempInsert;
            
            //---------------------saving the recods for VOC in Temp Object-------------------------------
            List<VOC_Data_Entry_Temp__c> vocTempInsert = new List<VOC_Data_Entry_Temp__c>();
            
            vocTempInsert = VOCUtil_Siding.doTempAdd(vocTempInsert, productLineList, 'Products', 'ProDialogue', vocInputFormTemp.Id);
            vocTempInsert = VOCUtil_Siding.doTempAdd(vocTempInsert, salesLineList, 'Marketing Supports', 'ProDialogue', vocInputFormTemp.Id);
            vocTempInsert = VOCUtil_Siding.doTempAdd(vocTempInsert, serviceLineList, 'Marketing Programs', 'ProDialogue', vocInputFormTemp.Id);
            vocTempInsert = VOCUtil_Siding.doTempAdd(vocTempInsert, otherLineList, 'Miscellaneous', 'ProDialogue', vocInputFormTemp.Id);
            
            if(vocTempInsert.size() > 0) upsert vocTempInsert;
            showErrorMessage = true;System.debug('zzzzzf');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes saved successfully.'));
            
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record not saved'));
        }
    }
    
    
    
    private void deleteMethod(){
        List<VOC_Data_Entry_Temp__c> vocList = new List<VOC_Data_Entry_Temp__c>();
        List<VOC_Input_Form_Temp__c> vocTempList = new List<VOC_Input_Form_Temp__c>();
        List<VOC_Input_Temp_Form_Attendee__c> vocAttendeeList = new List<VOC_Input_Temp_Form_Attendee__c>();
        
        String vocTempQuery = 'Select id from VOC_Input_Form_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
        if(proDialogueId != null && proDialogueId != '') vocTempQuery += ' and Record_Id__c = ' +'\''+ proDialogueId+'\'';
        else vocTempQuery += ' and Record_Id__c = null';
        vocTempList = Database.query(vocTempQuery);
        if(vocTempList.size() > 0) {
            String vocQuery = 'Select id from VOC_Data_Entry_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\''+' and VOC_Input_Temp_Form__c ='+'\''+vocTempList[0].Id+'\'';
            String vocAttendeeQuery = 'Select id from VOC_Input_Temp_Form_Attendee__c where Record_Id__c = ' +'\''+ proDialogueId+'\''+' and VOC_Input_Temp_Form__c ='+'\''+vocTempList[0].Id+'\'';
            vocAttendeeList = Database.query(vocAttendeeQuery);
            vocList = Database.query(vocQuery);
            if(vocList.size() > 0) {
                delete vocList;
            }
            if(vocAttendeeList.size() > 0){
                delete vocAttendeeList;
            }
            delete vocTempList;
        }
    }
    
    
    
    public void updateTempObj(){
        try{
            blnShowConfirmBox = false;
            Integer indexCounter = 0;
            Attendee attAdd = new Attendee();
            VOC_Data_Entry_Temp__c vocTemp = new VOC_Data_Entry_Temp__c();
            
            
            
            String vocInputFromTempQuery = 'Select v.Facilitator__r.Name, v.TM__r.Name, v.User_Id__c, v.TM__c, v.Region__c, v.Record_Id__c, v.OwnerId, v.Other_Participants__c, v.Notes__c, v.No_of_Attendees__c, v.No1_of_Attendees__c, v.Name, v.Meeting_Date__c, v.Information_Source__c, v.Id, v.Facilitator__c, v.City_State__c, v.Audience__c, v.Active__c From VOC_Input_Form_Temp__c v where v.User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
            if(proDialogueId != null && proDialogueId != '') vocInputFromTempQuery += ' and Record_Id__c = ' +'\''+ proDialogueId+'\'';
            else if(proDialogueId == null) vocInputFromTempQuery += ' and Record_Id__c = null';
            //vocInputFormTemp = Database.query(vocInputFromTempQuery);
            System.debug('vocInputFromTempQuery:::'+vocInputFromTempQuery);
            
            List<VOC_Input_Form_Temp__c> lstvocInputFormTemp = Database.query(vocInputFromTempQuery);
            System.debug('lstvocInputFormTemp:::::'+lstvocInputFormTemp);
            if(lstvocInputFormTemp.size() > 0){
                vocInputFormTemp = lstvocInputFormTemp[0];
            } else vocInputFormTemp = null;
            System.debug('vocInputFormTemp:::::'+vocInputFormTemp);
            
            if(vocInputFormTemp != null){
                vocInputFromTempId = String.valueOf(vocInputFormTemp.Id); 
            
            
                //copying value from temp DB to page
                proDialogue.Meeting_Date__c = vocInputFormTemp.Meeting_Date__c;
                proDialogue.City_State__c = vocInputFormTemp.City_State__c;
                if(vocInputFormTemp.Facilitator__c != null) proDialogue.Facilitator__c = vocInputFormTemp.Facilitator__c;
                if(vocInputFormTemp.Facilitator__r.Name != null && vocInputFormTemp.Facilitator__r.Name != '') facilitator = vocInputFormTemp.Facilitator__r.Name;
                if(vocInputFormTemp.TM__c != null) proDialogue.TM__c = vocInputFormTemp.TM__c;
                if(vocInputFormTemp.TM__r.Name != null && vocInputFormTemp.TM__r.Name != '') tm = vocInputFormTemp.TM__r.Name;
                proDialogue.Information_Source__c = vocInputFormTemp.Information_Source__c;
                proDialogue.Region__c = vocInputFormTemp.Region__c;
                proDialogue.Audience__c = vocInputFormTemp.Audience__c;
                proDialogue.No_of_Attendees__c = vocInputFormTemp.No_of_Attendees__c;
                proDialogue.Other_Participants__c = vocInputFormTemp.Other_Participants__c;
                proDialogue.Notes__c = vocInputFormTemp.Notes__c;
                proDialogue.Active__c = vocInputFormTemp.Active__c;
                
                
                //load Attendees    
                
                String proTempAttendeesQuery = 'Select p.Record_Id__c,p.Role__c, p.VOC_Input_Temp_Form__c, p.Name, p.Lead__c, p.Id, p.Contact__c From VOC_Input_Temp_Form_Attendee__c p Where VOC_Input_Temp_Form__c = ' +'\''+ vocInputFromTempId+'\'';
                List<VOC_Input_Temp_Form_Attendee__c> proTempAttendees = Database.query(proTempAttendeesQuery);
                
                List<Attendee> newAttendeeList = new List<Attendee>();
                
                if(attendeeList != null) indexCounter = attendeeList.size();
                indexCounter = 0;
                for(VOC_Input_Temp_Form_Attendee__c p : proTempAttendees) {
                    Attendee attNew = new Attendee();
                    if(p.Record_Id__c != null){
                        for(Attendee attExist : attendeeList){
                            if(attExist.proDialogueAttendee.Id == p.Record_Id__c){
                                    attNew = attExist;
                                    attNew.rIndex = indexCounter;
                                    if(attNew.proDialogueAttendee.Contact__c != p.Contact__c) {
                                        attNew.attendeeValue.WhoId = p.Contact__c;
                                        attNew.proDialogueAttendee.Contact__c = p.Contact__c;
                                    }
                                    if(attNew.proDialogueAttendee.Lead__c != p.Lead__c) {
                                        attNew.attendeeValue.WhoId = p.Lead__c;
                                        attNew.proDialogueAttendee.Lead__c = p.Lead__c;
                                    }
                                    if(attNew.proDialogueAttendee.Role__c != p.Role__c) attNew.proDialogueAttendee.Role__c = p.Role__c;
                                    newAttendeeList.add(attNew);
                                    indexCounter++;
                            }
                        }
                    } else if(p.Record_Id__c == null){
                        attNew.proDialogueAttendee.Contact__c = p.Contact__c;
                        attNew.proDialogueAttendee.Lead__c = p.Lead__c;
                        attNew.proDialogueAttendee.Role__c = p.Role__c;
                        if(attNew.proDialogueAttendee.Lead__c != null) attNew.attendeeValue.WhoId = p.Lead__c;
                        else if(attNew.proDialogueAttendee.Contact__c != null) attNew.attendeeValue.WhoId = p.Contact__c;
                        
                        attNew.rIndex = indexCounter;
                        newAttendeeList.add(attNew);
                        indexCounter++;
                        
                    }
                }
                
                 //add default attendees
                Attendee att = new Attendee();
                att.rIndex = indexCounter;
                newAttendeeList.add(att);
                attendeeList = newAttendeeList;
                
                //Mohan 02.18.2015: clear the list to avoid the email VOC entry to be display before appending the resumed VOCs
                productLineList.clear();
                salesLineList.clear();
                serviceLineList.clear();
                otherLineList.clear();
                
                //load voc for each category
                    VOCUtil_Siding.VOCItemWrapper existingVOCs = VOCUtil_Siding.fetchExistingVOCsInTemp(productLineList,salesLineList,serviceLineList,otherLineList,vocInputFromTempId);
                    productLineList = existingVOCs.productLineList;
                    
                    for(VOCLine obj : productLineList){
                        
                            if(obj.vocEntry.Product_Line__c != null && obj.vocEntry.Product_Line__c != vocTemp.Product_Line__c){
                                obj.pFamilyOptions = VOCUtil_Siding.prepareProductFamily(obj.vocEntry.Product_Line__c);
                            }
                            if(obj.vocEntry.Product_Family__c != null && obj.vocEntry.Product_Family__c != vocTemp.Product_Family__c){
                                obj.brandOptions = VOCUtil_Siding.prepareBrand(obj.vocEntry.Product_Family__c);
                            }
                            if(obj.vocEntry.Brand_siding__c != null && obj.vocEntry.Brand_siding__c != vocTemp.Brand__c){
                                obj.mFamilyOptions = VOCUtil_Siding.prepareMarketFamily(obj.vocEntry.Brand_siding__c);
                            }
                            if(obj.vocEntry.Market_Family__c != null && obj.vocEntry.Market_Family__c != obj.vocEntry.Market_Family__c){
                                obj.mSegmentOptions = VOCUtil_Siding.prepareMarketSegment(obj.vocEntry.Market_Family__c);
                            }
                            
                    }
                    salesLineList = existingVOCs.salesLineList;
                    serviceLineList = existingVOCs.serviceLineList;
                    otherLineList = existingVOCs.otherLineList;
                    
            } else {
                showErrorMessage = true;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'There is no data for resuming.'));
            }
            
            
            //add default attendees
            if(attendeeList.size() == 0) {
                Attendee att = new Attendee();
                att.rIndex = 0;
                attendeeList.add(att);
            }
            
            
            if(productLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Products';
                productLineList.add(vLine);
            }
            
            if(salesLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Marketing Supports';
                salesLineList.add(vLine);
            }
            
            if(serviceLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Marketing Programs';
                serviceLineList.add(vLine);
            }
            
            if(otherLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Miscellaneous';
                otherLineList.add(vLine);                                                   
            }
            
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Data not resume properly'));
        }
    }
    
    //--------Arpit 19-Feb-2015: Adding this method to make fields visible when user clicks No at the Prompt Up of Resuming temporary data--------------------
    public void resumeAfterNo(){
        try { 
            blnShowConfirmBox = false;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in loading new form.'));
        }
    }
    //-----------------------------------------------End of Arpit 19-Feb-2015 Updates-------------------------------------------------------------------------
    
    //--------------------------------------Arpit 20-Feb-2015: Adding code for Discard button------------------------------------------
    public void discardMethod() {
        try { 
            deleteMethod();
            proDialogue = new ProDialogue_Input__c();
            attendeeList = new List<Attendee>();
            productLineList = new List<VOCLine>();
            salesLineList = new List<VOCLine>();
            serviceLineList = new List<VOCLine>();
            otherLineList = new List<VOCLine>();
            facilitatorFound = new List<User>();
            tmFound = new List<User>();
            facilitator = '';
            tm = '';
            String proId = ApexPages.currentPage().getParameters().get('id');
            if(proId != null && proId != ''){
                proDialogue = [Select p.TM__c, p.TM__r.Name, p.Region__c, p.OwnerId, p.Other_Participants__c, p.Notes__c, p.No1_of_Attendees__c , p.Name, 
                                p.Meeting_Date__c, p.Information_Source__c, p.Id, p.Facilitator__c, p.Facilitator__r.Name, p.City_State__c, p.Audience__c, p.Active__c 
                                From ProDialogue_Input__c p Where Id =: proDialogueId];
                
                Integer indexCounter = 0;
                if(proDialogue.TM__r.Name != null) {
                    tm = proDialogue.TM__r.Name;
                    tmId = proDialogue.TM__c;
                }
                if(proDialogue.Facilitator__r.Name != null) {
                    facilitator = proDialogue.Facilitator__r.Name;
                    facilitatorId = proDialogue.Facilitator__c;
                }
                //load Attendees
                List<ProDialogue_Input_Attendee__c> proAttendees = [Select p.Role__c, p.ProDialogue_Input__c, p.Name, p.Lead__c, p.Id, p.Contact__c 
                                                                    From ProDialogue_Input_Attendee__c p Where ProDialogue_Input__c =: proDialogueId];
                for(ProDialogue_Input_Attendee__c p : proAttendees) {
                    Attendee att = new Attendee();
                    att.rIndex = indexCounter;
                    att.proDialogueAttendee = p;
                    if(p.Lead__c != null) att.attendeeValue.WhoId = p.Lead__c;
                    if(p.Contact__c != null) att.attendeeValue.WhoId = p.Contact__c;
                    attendeeList.add(att);
                    indexCounter++;
                }
                
                //load voc for each category
                VOCUtil_Siding.VOCItemWrapper existingVOCs = VOCUtil_Siding.fetchExistingVOCs(proDialogueId);
                productLineList = existingVOCs.productLineList;
                
                //Name - Madan (Jun 9, 2014)
                //Description - added below logic for bind dipendent picklist values.
                //-----------------------------------------------
                for(VOCLine obj : productLineList){
                    if(obj.vocEntry.Product_Line__c != null){
                        obj.pFamilyOptions = VOCUtil_Siding.prepareProductFamily(obj.vocEntry.Product_Line__c);
                    }
                    if(obj.vocEntry.Product_Family__c != null){
                        obj.brandOptions = VOCUtil_Siding.prepareBrand(obj.vocEntry.Product_Family__c);
                    }
                    if(obj.vocEntry.Brand_siding__c != null){
                        obj.mFamilyOptions = VOCUtil_Siding.prepareMarketFamily(obj.vocEntry.Brand_siding__c);
                    }
                    if(obj.vocEntry.Market_Family__c != null){
                        obj.mSegmentOptions = VOCUtil_Siding.prepareMarketSegment(obj.vocEntry.Market_Family__c);
                    }
                }
                //------------------------------------------------
                
                salesLineList = existingVOCs.salesLineList;
                serviceLineList = existingVOCs.serviceLineList;
                otherLineList = existingVOCs.otherLineList;
            
            }
            
            //add default attendees
            if(attendeeList.size() == 0) {
                Attendee att = new Attendee();
                att.rIndex = 0;
                attendeeList.add(att);
            }
            
            //add default voc's
            if(productLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Products';
                productLineList.add(vLine);
            }
            
            if(salesLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Marketing Supports';
                salesLineList.add(vLine);
            }
            
            if(serviceLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Marketing Programs';
                serviceLineList.add(vLine);
            }
            
            if(otherLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Miscellaneous';
                otherLineList.add(vLine);
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in deleting record.'));
        }
    }
    
    //-------------------------------------End of Arpit 20-Feb-2015--------------------------------------------------------------------
    //--------------------------------------End of Arpit updated code---------------------------------------------------------
}