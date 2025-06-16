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

public with sharing class ProDialogueInputFormController {
    public ProDialogue_Input__c proDialogue {get;set;}
    public VOC_Input_Form_Temp__c vocInputFormTemp {get;set;}
    public List<VOC_Input_Form_Temp__c> vocInputFormTempList{get;set;}
    public List<Attendee> attendeeList {get;set;}
    public List<VOCLine> productLineList {get;set;}
    public List<VOCLine> salesLineList {get;set;}
    public List<VOCLine> serviceLineList {get;set;}
    public List<VOCLine> otherLineList {get;set;}
    public String selectedIndexToDelete {get;set;}
    public Integer tIndex {get;set;}
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
    
    public ProDialogueInputFormController(Apexpages.standardController sc) {
        tIndex = 0;
        proDialogue = new ProDialogue_Input__c();
        proDialogue.Sales_Role__c = 'ASM';
        proDialogue.Meeting_Date__c = Date.Today();
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
        myAttach = new Attachment();
        cShowPopup = false;
        System.debug('jjj'+proDialogueId);
        
        String scVar = Apexpages.currentPage().getParameters().get('sc');
        if(scVar != null && scVar != ''){
            updateTempObj();
        } else {
            if(proDialogueId != null) {
                proDialogue = [Select p.Country__c, p.Market_Segment__c, p.TM__c, p.TM__r.Name, p.Region__c, p.OwnerId, p.Other_Participants__c, p.Notes__c, p.No1_of_Attendees__c ,
                                p.Name, p.Meeting_Date__c, p.No_of_Attendees__c, p.Sales_Role__c, p.Segment_Type__c,p.Weekly_Report__c, 
                                p.Information_Source__c, p.Additional_Info_Source__c, p.Id, p.Facilitator__c, p.Facilitator__r.Name, p.City_State__c, p.Audience__c, p.Active__c 
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
                List<ProDialogue_Input_Attendee__c> proAttendees = [Select p.Role__c, p.ProDialogue_Input__c, p.Name, p.Account__c, p.Lead__c, p.Id, p.Contact__c 
                                                                    From ProDialogue_Input_Attendee__c p Where ProDialogue_Input__c =: proDialogueId];
                for(ProDialogue_Input_Attendee__c p : proAttendees) {
                    Attendee att = new Attendee();
                    att.rIndex = indexCounter;
                    att.proDialogueAttendee = p;
                    if(p.Lead__c != null){
                        att.selAttendeeType = 'Lead';
                        att.attendeeValue.Lead__c = p.Lead__c;
                        att.attendeeValue.Account__c = null;
                        att.attendeeValue.Contact__c = null;
                    }
                    if(p.Contact__c != null){
                        att.selAttendeeType = 'Contact';
                        att.attendeeValue.Contact__c = p.Contact__c;
                        att.attendeeValue.Account__c = null;
                        att.attendeeValue.Lead__c = null;
                    }
                    if(p.Account__c != null){
                        att.selAttendeeType = 'Account';
                        att.attendeeValue.Account__c = p.Account__c;
                        att.attendeeValue.Contact__c = null;
                        att.attendeeValue.Lead__c = null;
                    }
                    attendeeList.add(att);
                    indexCounter++;
                }
                
                //load voc for each category
                VOCUtil.VOCItemWrapper existingVOCs = VOCUtil.fetchExistingVOCs(proDialogueId);
                productLineList = existingVOCs.productLineList;
                for(VOCLine vol : productLineList){
                    System.debug('vol'+vol);
                    System.debug('vol.vocEntry'+vol.vocEntry);
                    System.debug('vol.vocEntry.Competitor_Topic__c'+vol.vocEntry.Competitor_Topic__c);
                    tIndex = vol.rIndex;
                    if(vol.vocEntry!=null && vol.vocEntry.Competitor_Topic__c!=null && vol.vocEntry.Competitor_Topic__c!=''){
                        vol.selectedcompetitors = new List<String>();
                        for(String s : vol.vocEntry.Competitor_Topic__c.split(';')){
                            
                            vol.selectedcompetitors.add(s);
                        }
                    }
                    changeSelectoption();
                }
                //Name - Madan (Jun 9, 2014)
                //Description - added below logic for bind dipendent picklist values.
                //-----------------------------------------------
                for(VOCLine obj : productLineList){
                    if(obj.vocEntry.Product_Line__c != null){
                        obj.pFamilyOptions = VOCUtil.prepareProductFamily(obj.vocEntry.Product_Line__c);
                    }
                    if(obj.vocEntry.Product_Family__c != null){
                        obj.brandOptions = VOCUtil.prepareBrand(obj.vocEntry.Product_Family__c);
                    }
          /*          if(obj.vocEntry.Brand__c != null){
                        obj.mFamilyOptions = VOCUtil.prepareMarketFamily(obj.vocEntry.Brand__c);
                    }
            */
                    if(obj.vocEntry.Market_Family__c != null){
                        obj.mSegmentOptions = VOCUtil.prepareMarketSegment(obj.vocEntry.Market_Family__c);
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
                vLine.vocEntry.Category__c = 'Marketing General';
                salesLineList.add(vLine);
            }
            
            if(serviceLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Sales General';
                serviceLineList.add(vLine);
            }
            
            if(otherLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Competitor';
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
        System.debug('****111***'+productLineList);
        productLineList = VOCUtil.addProductLine(productLineList, null, null, null, null, null, null);
        System.debug('****222***'+productLineList);
    }
    
    public void addSalesLine() {
        salesLineList = VOCUtil.addLineItem(salesLineList, null, 'Marketing General');
    }
    
    public void addServiceLine() {
        serviceLineList = VOCUtil.addLineItem(serviceLineList, null, 'Sales General');
    }
    
    public void addOtherLine() {
        otherLineList = VOCUtil.addLineItem(otherLineList, null, 'Competitor');
    }
    
    public void removeProductLine() {
        System.debug(':selectedIndexToDelete: '+selectedIndexToDelete);
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        productLineList = VOCUtil.removeLineItem(productLineList, delIndex);
    }
    
    public void removeSalesLine() {
        System.debug(':selectedIndexToDelete: '+selectedIndexToDelete);
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        salesLineList = VOCUtil.removeLineItem(salesLineList, delIndex);
    }
    
    public void removeServiceLine() {
        System.debug(':selectedIndexToDelete: '+selectedIndexToDelete);
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        serviceLineList = VOCUtil.removeLineItem(serviceLineList, delIndex);
    }
    
    public void removeOtherLine() {
        System.debug(':selectedIndexToDelete: '+selectedIndexToDelete);
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        otherLineList = VOCUtil.removeLineItem(otherLineList, delIndex);
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
    //CF NO longer userd commending out S-490560
    //private Boolean validateFacilitatorAndTM(String fId, String tId) {
    //    Boolean isValid = true;
    //    Set<String> userIds = new Set<String>();
    //    if(fId != null && fId != '') userIds.add(fId);
    //    else {
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Facilitator selected. Please select a valid one and try again.'));
    //        isValid = false;
    //    }
    //    if(tId != null && tId != '') userIds.add(tId);
    //    else {
    //        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid TM selected. Please select a valid one and try again.'));
    //        isValid = false;
    //    }
    //    if(!isValid) return isValid;
    //    Map<Id, User> userResult = new Map<Id, User>([Select Id From User Where Id IN :userIds]);
    //    if(userResult != null && !userResult.containsKey(fId)) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid Facilitator selected. Please select a valid one and try again.')); return false; }
    //    if(userResult != null && !userResult.containsKey(tId)) { ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid TM selected. Please select a valid one and try again.')); return false; }
        
    //    return true;
    //} 
    //CF S-490560 End
    
    public Pagereference saveProDialogue() {
        Pagereference pr;
        Savepoint sp = Database.setSavepoint();
        showErrorMessage = true;
        if((proDialogue.Sales_Role__c!=null || proDialogue.Sales_Role__c!='') && (proDialogue.Information_Source__c==null || proDialogue.Information_Source__c==null)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select an info source.'));
            return null;
        }
        try {
            Boolean validationFailed = VOCUtil.validateVOC(productLineList, 'Products', '');
            if(validationFailed) return pr;
            
            //if(!validateFacilitatorAndTM(facilitatorId, tmId)) return pr;
            proDialogue.Facilitator__c = facilitatorId;
            proDialogue.TM__c = tmId;
            upsert proDialogue;
            //Shakti Insert attachment records.
            if(myAttach.Body != null && myAttach.Name != null){
              myAttach.ParentId = proDialogue.Id;  
              insert myAttach;
              myAttach = new Attachment();
            }
            //add Attendees
            List<ProDialogue_Input_Attendee__c> attendeesInsert = new List<ProDialogue_Input_Attendee__c>();
            for(Attendee att : attendeeList) {
                if(att.selAttendeeType != null && att.selAttendeeType != '' && (att.attendeeValue.Account__c!=null || att.attendeeValue.Contact__c!=null || att.attendeeValue.Lead__c!=null)) {
                    if(att.selAttendeeType=='Account' && att.attendeeValue.Account__c!=null) {
                        att.proDialogueAttendee.Account__c = att.attendeeValue.Account__c;
                        att.proDialogueAttendee.Contact__c = null; 
                        att.proDialogueAttendee.Lead__c = null; 
                    }
                    if(att.selAttendeeType=='Contact' && att.attendeeValue.Contact__c!=null) {
                        att.proDialogueAttendee.Contact__c = att.attendeeValue.Contact__c;
                        att.proDialogueAttendee.Lead__c = null; 
                        att.proDialogueAttendee.Account__c = null; 
                    }
                    if(att.selAttendeeType=='Lead' && att.attendeeValue.Lead__c!=null) {
                        att.proDialogueAttendee.Lead__c = att.attendeeValue.Lead__c;
                        att.proDialogueAttendee.Account__c = null; 
                        att.proDialogueAttendee.Contact__c = null; 
                    }
                    if(att.proDialogueAttendee.ProDialogue_Input__c == null) att.proDialogueAttendee.ProDialogue_Input__c = proDialogue.Id;
                    attendeesInsert.add(att.proDialogueAttendee);
                }
            }
            
            if(attendeesInsert.size() > 0) upsert attendeesInsert;
            
            
            //iterate and add valid voc entries
            List<VOC_Data_Entry__c> vocInsert = new List<VOC_Data_Entry__c>();
            vocInsert = doAdd(vocInsert, productLineList, '', 'ProDialogue', proDialogue.Id);
            vocInsert = VOCUtil.doAdd(vocInsert, salesLineList, 'Marketing General', 'ProDialogue', proDialogue.Id);
            vocInsert = VOCUtil.doAdd(vocInsert, serviceLineList, 'Sales General', 'ProDialogue', proDialogue.Id);
            vocInsert = VOCUtil.doAdd(vocInsert, otherLineList, 'Competitor', 'ProDialogue', proDialogue.Id);
            
            if(vocInsert.size() > 0) upsert vocInsert;
            deleteMethod();
            //List<Event> evnt = new List<Event>();
           /* Datetime startTime = Datetime.Now().addhours(1);
            Event eventObject=new Event(Subject='VOC Form',OwnerId = UserInfo.getUserId(),whatID=proDialogue.Id,StartDateTime=startTime,EndDateTime=startTime.addHours(1));
                //evnt.add(eventObject);
            insert eventObject;*/
            
            String strcomment = '';
            if(proDialogue.Meeting_Date__c!=null){
                strcomment+='Meeting Date='+proDialogue.Meeting_Date__c+',';
            }
            if(proDialogue.City_State__c!=null && proDialogue.City_State__c!=''){
                strcomment+='City, State or Province='+proDialogue.City_State__c+',';
            }
            if(proDialogue.Market_Segment__c!=null && proDialogue.Market_Segment__c!=''){
                strcomment+='Market Segment='+proDialogue.Market_Segment__c+',';
            }
            if(proDialogue.Sales_Role__c!=null && proDialogue.Sales_Role__c!=''){
                strcomment+='Role='+proDialogue.Sales_Role__c+',';
            }
            if(proDialogue.Region__c!=null && proDialogue.Region__c!=''){
                strcomment+='Region='+proDialogue.Region__c+',';
            }
            if(proDialogue.Segment_Type__c!=null && proDialogue.Segment_Type__c!=''){
                strcomment+='Segment Type='+proDialogue.Segment_Type__c+',';
            }
            if(proDialogue.Country__c!=null && proDialogue.Country__c!=''){
                strcomment+='Country='+proDialogue.Country__c+',';
            }
            if(proDialogue.Information_Source__c!=null && proDialogue.Information_Source__c!=''){
                strcomment+='Info Source='+proDialogue.Information_Source__c+',';
            }
            if(proDialogue.Additional_Info_Source__c!=null && proDialogue.Additional_Info_Source__c!=''){
                strcomment+='Additional Info Source='+proDialogue.Additional_Info_Source__c;
            }
            
            if(strcomment.length()>0 && strcomment.subString(strcomment.length()-1,strcomment.length())==','){
                strcomment=strcomment.subString(0,strcomment.length()-1);
            }
            String countryType='USA Task';
             if(proDialogue.Region__c=='Northeast' || proDialogue.Region__c=='Southeast' || proDialogue.Region__c=='South Central' || proDialogue.Region__c=='Midwest' || proDialogue.Region__c=='Northwest' || proDialogue.Region__c=='North Central' || proDialogue.Region__c=='Southwest'){
                    countryType = 'USA Task';
            }else if(proDialogue.Region__c=='Atlantic' || proDialogue.Region__c=='Quebec' || proDialogue.Region__c=='Central Ontario' || proDialogue.Region__c=='Western Canada'){
                    countryType = 'Canada Task';
            }
            Task taskObject=new Task(Subject='VOC Form',Activity_Type__c='VOC',Weekly_Report__c=proDialogue.Weekly_Report__c,OwnerId = UserInfo.getUserId(),whatID=proDialogue.Id,ActivityDate=proDialogue.Meeting_Date__c,Status='Completed',RecordTypeId=Schema.SObjectType.Task.getRecordTypeInfosByName().get(countryType).getRecordTypeId(),Description=strcomment);
            if(countryType == 'USA Task'){
                taskObject.Region_USA__c = proDialogue.Region__c;
            }
            insert taskObject;  
             System.debug('taskObject>>>>>>>>>>>>>>>>>>>>>>>>>>: '+ taskObject);          
            pr = new Pagereference('/' + proDialogue.Id);
        } catch(Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            Database.rollback(sp);
        }
        
        return pr;
    }
    
    public List<VOC_Data_Entry__c> doAdd(List<VOC_Data_Entry__c> vocInsert, List<VOCLine> vocLst, String vocCategory, String vocType, String relatedId) {
        
        for(VOCLine v : vocLst) {
            System.debug('v: '+ v);
            Boolean addRow = false;
            if(v.vocEntry.Category__c == 'Products') {
                if((v.vocEntry.What__c != null && v.vocEntry.What__c != '') || (v.vocEntry.Priority__c != null && v.vocEntry.Priority__c != '') 
                || (v.vocEntry.Topic__c != null && v.vocEntry.Topic__c != '') || (v.vocEntry.Product_Line__c != null && v.vocEntry.Product_Line__c != '') 
                || (v.vocEntry.Product_Family__c != null && v.vocEntry.Product_Family__c != '') 
                   // DB || (v.vocEntry.Brand__c != null && v.vocEntry.Brand__c != '') || (v.vocEntry.Sub_Brand__c != null && v.vocEntry.Sub_Brand__c != '')
                || (v.vocEntry.Market_Family__c != null && v.vocEntry.Market_Family__c != '') || (v.vocEntry.Market_Segment__c != null && v.vocEntry.Market_Segment__c != '') 
                || (v.vocEntry.Note__c != null && v.vocEntry.Note__c != '')) {
                    addRow = true;
                }
                
            } else {
                if((v.vocEntry.What__c != null && v.vocEntry.What__c != '') || (v.vocEntry.Priority__c != null && v.vocEntry.Priority__c != '') 
                || (v.vocEntry.Topic__c != null && v.vocEntry.Topic__c != '') || (v.vocEntry.Note__c != null && v.vocEntry.Note__c != '')) {
                    addRow = true;
                }
            }
            
            if(addRow) {
                if(vocType == 'WTU Note') v.vocEntry.WTU_Note__c = relatedId;
                if(vocType == 'ProDialogue') v.vocEntry.ProDialogue_Input__c = relatedId;
                if(vocType == 'Online') v.vocEntry.Online_Form__c = relatedId;
                if(v.vocEntry.Id == null) v.vocEntry.Created_Date__c = Date.today();
                
                String interests = '';
                Boolean Start = true;
                if(v.selectedcompetitors.size()>0){
                    for(String selectedcomp :  v.selectedcompetitors){
                        if(Start) {
                            interests = selectedcomp;
                            Start = false;
                        } else {               
                            interests = interests + ';' + selectedcomp;
                        }
                    }
                }
                v.vocEntry.Competitor_Topic__c = interests;
                
                vocInsert.add(v.vocEntry);
            }
        }
        
        return vocInsert;
    }
    
    public void getProductFamily() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
            List<Selectoption> options = VOCUtil.prepareProductFamily(productLineList.get(rIndex).vocEntry.Product_Line__c);
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
            List<Selectoption> options = VOCUtil.prepareBrand(productLineList.get(rIndex).vocEntry.Product_Family__c);
            productLineList.get(rIndex).brandOptions = options;
            productLineList.get(rIndex).mFamilyOptions = new Selectoption[]{new Selectoption('', '--None--')};
            productLineList.get(rIndex).mSegmentOptions = new Selectoption[]{new Selectoption('', '--None--')};
            if(options.size() == 2) {
           // DB     productLineList.get(rIndex).vocEntry.Brand__c = options.get(1).getValue();
                getMarketFamily();
            }
        }
    }
    
    public void getMarketFamily() {
        String rowIndex = System.currentPageReference().getParameters().get('rIndex');
        if(rowIndex != null && rowIndex != '') {
            Integer rIndex = Integer.valueOf(rowIndex);
       List<Selectoption> options; // DB = VOCUtil.prepareMarketFamily(productLineList.get(rIndex).vocEntry.Brand__c);
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
            List<Selectoption> options = VOCUtil.prepareMarketSegment(productLineList.get(rIndex).vocEntry.Market_Family__c);
            productLineList.get(rIndex).mSegmentOptions = options;
            if(options.size() == 2) productLineList.get(rIndex).vocEntry.Market_Segment__c = options.get(1).getValue();
        }
    }
    
    public class Attendee {
        public ProDialogue_Input_Attendee__c proDialogueAttendee {get;set;}
        public ProDialogue_Input_Attendee__c attendeeValue{get;set;}
        public String selAttendeeType{get;set;}
        public List<SelectOption> options{get;set;}
        public Integer rIndex {get;set;}
        
        public Attendee() {
            proDialogueAttendee = new ProDialogue_Input_Attendee__c();
            attendeeValue = new ProDialogue_Input_Attendee__c();
            selAttendeeType = 'Account';
            options = new List<SelectOption>();
            options.add(new SelectOption('Account', 'Account'));
            options.add(new SelectOption('Contact', 'Contact'));
            options.add(new SelectOption('Lead', 'Lead'));
        }
    }
    
    
    
    //-------------------------------------Arpit Adding code for storing in temp obj------------------------------------------
    
    public void saveButton(){
        if((proDialogue.Sales_Role__c!=null || proDialogue.Sales_Role__c!='') && (proDialogue.Information_Source__c==null || proDialogue.Information_Source__c==null)){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select an info source.'));
            return;
        }
        try{
            vocInputFormTemp = new VOC_Input_Form_Temp__c();
            System.debug('abcdef'+tmId);
            deleteMethod();
            
            Boolean validationFailed = VOCUtil.validateVOC(productLineList, 'Products', '');
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
            vocInputFormTemp.Additional_Info_Source__c = proDialogue.Additional_Info_Source__c;
            vocInputFormTemp.Region__c = proDialogue.Region__c;
            vocInputFormTemp.Audience__c = proDialogue.Audience__c;
            vocInputFormTemp.Other_Participants__c = proDialogue.Other_Participants__c;
            vocInputFormTemp.Notes__c = proDialogue.Notes__c;
            vocInputFormTemp.Active__c = proDialogue.Active__c;
            
            vocInputFormTemp.Market_Segment__c = proDialogue.Market_Segment__c;
            vocInputFormTemp.Sales_Role__c = proDialogue.Sales_Role__c;
            vocInputFormTemp.Segment_Type__c = proDialogue.Segment_Type__c;
            vocInputFormTemp.Country__c = proDialogue.Country__c;
            vocInputFormTemp.Weekly_Report__c = proDialogue.Weekly_Report__c;
      
            System.debug('aaaaaaaaaaa');
            vocInputFormTemp.User_Id__c = UserInfo.getUserId();
            System.debug('abcdef');
            if(proDialogueId != null){
                vocInputFormTemp.Record_Id__c = proDialogueId;
                //Shakti Insert attachment records.
                if(myAttach.Body != null && myAttach.Name != null){
                  myAttach.ParentId = proDialogueId;  
                  insert myAttach;
                  myAttach = new Attachment();
                }
            }
            System.debug('vvvvvv');
            upsert vocInputFormTemp;
            System.debug('ccccc');
            //---------------------saving records for Attendee temp object--------------------------------
            List<VOC_Input_Temp_Form_Attendee__c> attendeesTempInsert = new List<VOC_Input_Temp_Form_Attendee__c>();
            for(Attendee att : attendeeList) {
                VOC_Input_Temp_Form_Attendee__c tempObj = new VOC_Input_Temp_Form_Attendee__c();
                
                if(att.selAttendeeType != null && att.selAttendeeType != '' && (att.attendeeValue.Account__c!=null || att.attendeeValue.Contact__c!=null || att.attendeeValue.Lead__c!=null)) {
                    if(att.selAttendeeType=='Account' && att.attendeeValue.Account__c!=null) {
                        tempObj.Account__c = att.attendeeValue.Account__c;
                        tempObj.Contact__c = null; 
                        tempObj.Lead__c = null; 
                    }
                    if(att.selAttendeeType=='Contact' && att.attendeeValue.Contact__c!=null) {
                        tempObj.Contact__c = att.attendeeValue.Contact__c;
                        tempObj.Lead__c = null; 
                        tempObj.Account__c = null; 
                    }
                    if(att.selAttendeeType=='Lead' && att.attendeeValue.Lead__c!=null) {
                        tempObj.Lead__c = att.attendeeValue.Lead__c;
                        tempObj.Account__c = null; 
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
            
            vocTempInsert = doTempAdd(vocTempInsert, productLineList, '', 'ProDialogue', vocInputFormTemp.Id);
            vocTempInsert = VOCUtil.doTempAdd(vocTempInsert, salesLineList, 'Marketing General', 'ProDialogue', vocInputFormTemp.Id);
            vocTempInsert = VOCUtil.doTempAdd(vocTempInsert, serviceLineList, 'Sales General', 'ProDialogue', vocInputFormTemp.Id);
            vocTempInsert = VOCUtil.doTempAdd(vocTempInsert, otherLineList, 'Competitor', 'ProDialogue', vocInputFormTemp.Id);
            
            if(vocTempInsert.size() > 0) upsert vocTempInsert;
            showErrorMessage = true;System.debug('zzzzzf');
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes saved successfully.'));
            
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record not saved'));
        }
    }
    
    public List<VOC_Data_Entry_Temp__c> doTempAdd(List<VOC_Data_Entry_Temp__c> vocTempInsert, List<VOCLine> vocLst, String vocCategory, String vocType, String relatedId){
        for(VOCLine v : vocLst) {
            Boolean addRow = false;
            //if(v.vocEntry.Category__c == 'Products') {
                if((v.vocEntry.What__c != null && v.vocEntry.What__c != '') || (v.vocEntry.Priority__c != null && v.vocEntry.Priority__c != '') 
                || (v.vocEntry.Topic__c != null && v.vocEntry.Topic__c != '') || (v.vocEntry.Product_Line__c != null && v.vocEntry.Product_Line__c != '') 
                || (v.vocEntry.Product_Family__c != null && v.vocEntry.Product_Family__c != '') 
                   // DB || (v.vocEntry.Brand__c != null && v.vocEntry.Brand__c != '') || (v.vocEntry.Sub_Brand__c != null && v.vocEntry.Sub_Brand__c != '')
                || (v.vocEntry.Market_Family__c != null && v.vocEntry.Market_Family__c != '') || (v.vocEntry.Market_Segment__c != null && v.vocEntry.Market_Segment__c != '') 
                || (v.vocEntry.Note__c != null && v.vocEntry.Note__c != '')) {
                    addRow = true;
                }
                
            /*} else {
                if((v.vocEntry.What__c != null && v.vocEntry.What__c != '') || (v.vocEntry.Priority__c != null && v.vocEntry.Priority__c != '') 
                || (v.vocEntry.Topic__c != null && v.vocEntry.Topic__c != '') || (v.vocEntry.Note__c != null && v.vocEntry.Note__c != '')) {
                    addRow = true;
                }
            }*/
            
            if(addRow) {
                VOC_Data_Entry_Temp__c vocTempEntry = new VOC_Data_Entry_Temp__c();
                if(vocType == 'ProDialogue') vocTempEntry.VOC_Input_Temp_Form__c = relatedId;
                if(vocType == 'Online') vocTempEntry.Online_VOC_Temp__c = relatedId;
                
             // DB   vocTempEntry.Brand__c = v.vocEntry.Brand__c;
                vocTempEntry.Sub_Brand__c = v.vocEntry.Sub_Brand__c;
                vocTempEntry.Case_Number__c = v.vocEntry.Case_Number__c;
                vocTempEntry.Category__c = v.vocEntry.Category__c;
                vocTempEntry.Line_of_Business__c = v.vocEntry.Line_of_Business__c;
                vocTempEntry.Market_Family__c = v.vocEntry.Market_Family__c;
                vocTempEntry.Market_Segment__c = v.vocEntry.Market_Segment__c;
                vocTempEntry.Note__c = v.vocEntry.Note__c;
                vocTempEntry.Priority__c = v.vocEntry.Priority__c;
                String interests = '';
                Boolean Start = true;
                //CF S-490560 Adding null Check
                if(v.selectedcompetitors != null && v.selectedcompetitors.size()>0){
                    //CF ENd
                    for(String selectedcomp :  v.selectedcompetitors){
                        if(Start) {
                            interests = selectedcomp;
                            Start = false;
                        } else {               
                            interests = interests + ';' + selectedcomp;
                        }
                    }
                    vocTempEntry.Competitor_Topic__c = interests;
                }
                vocTempEntry.Product_Family__c = v.vocEntry.Product_Family__c;
                vocTempEntry.Product_Line__c = v.vocEntry.Product_Line__c;
                vocTempEntry.Insight__c = v.vocEntry.Insight__c;
                vocTempEntry.Subject__c = v.vocEntry.Subject__c;
                vocTempEntry.Topic__c = v.vocEntry.Topic__c;
                vocTempEntry.What__c = v.vocEntry.What__c;
                vocTempEntry.User_Id__c = UserInfo.getUserId();
                if(v.vocEntry.Id != null){
                    vocTempEntry.Record_Id__c = v.vocEntry.Id;
                }
                vocTempInsert.add(vocTempEntry);
            }
        }
        
        return vocTempInsert;
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
            
            
            
            String vocInputFromTempQuery = 'Select v.Weekly_Report__c,v.Facilitator__r.Name,v.Market_Segment__c, v.Sales_Role__c, v.Segment_Type__c,v.Country__c, v.TM__r.Name, v.User_Id__c, v.TM__c, v.Region__c, v.Record_Id__c, v.OwnerId, v.Other_Participants__c, v.Notes__c, v.No_of_Attendees__c, v.No1_of_Attendees__c, v.Name, v.Meeting_Date__c, v.Information_Source__c,v.Additional_Info_Source__c, v.Id, v.Facilitator__c, v.City_State__c, v.Audience__c, v.Active__c From VOC_Input_Form_Temp__c v where v.User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
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
                
                proDialogue.Market_Segment__c = vocInputFormTemp.Market_Segment__c;
                proDialogue.Sales_Role__c = vocInputFormTemp.Sales_Role__c;
                proDialogue.Segment_Type__c = vocInputFormTemp.Segment_Type__c;
                proDialogue.Country__c = vocInputFormTemp.Country__c;
                
                if(vocInputFormTemp.Facilitator__c != null) proDialogue.Facilitator__c = vocInputFormTemp.Facilitator__c;
                if(vocInputFormTemp.Facilitator__r.Name != null && vocInputFormTemp.Facilitator__r.Name != '') facilitator = vocInputFormTemp.Facilitator__r.Name;
                if(vocInputFormTemp.TM__c != null) proDialogue.TM__c = vocInputFormTemp.TM__c;
                if(vocInputFormTemp.TM__r.Name != null && vocInputFormTemp.TM__r.Name != '') tm = vocInputFormTemp.TM__r.Name;
                proDialogue.Information_Source__c = vocInputFormTemp.Information_Source__c;
                proDialogue.Additional_Info_Source__c = vocInputFormTemp.Additional_Info_Source__c;
                proDialogue.Region__c = vocInputFormTemp.Region__c;
                proDialogue.Audience__c = vocInputFormTemp.Audience__c;
                proDialogue.No_of_Attendees__c = vocInputFormTemp.No_of_Attendees__c;
                proDialogue.Other_Participants__c = vocInputFormTemp.Other_Participants__c;
                proDialogue.Notes__c = vocInputFormTemp.Notes__c;
                proDialogue.Active__c = vocInputFormTemp.Active__c;
                proDialogue.Weekly_Report__c = vocInputFormTemp.Weekly_Report__c;
                
                
                //load Attendees    
                
                String proTempAttendeesQuery = 'Select p.Record_Id__c,p.Role__c, p.VOC_Input_Temp_Form__c, p.Name, p.Account__c,p.Account__r.name, p.Lead__c, p.Id, p.Contact__c From VOC_Input_Temp_Form_Attendee__c p Where VOC_Input_Temp_Form__c = ' +'\''+ vocInputFromTempId+'\'';
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
                                    if(attNew.proDialogueAttendee.Contact__c != p.Contact__c && p.Contact__c!=null) {
                                        attNew.selAttendeeType = 'Contact';
                                        attNew.attendeeValue.Contact__c = p.Contact__c;
                                        attNew.attendeeValue.Lead__c = null;
                                        attNew.attendeeValue.Account__c = null;
                                        attNew.proDialogueAttendee.Contact__c = p.Contact__c;
                                    }
                                    if(attNew.proDialogueAttendee.Lead__c != p.Lead__c && p.Lead__c!=null) {
                                        attNew.selAttendeeType = 'Lead';
                                        attNew.attendeeValue.Lead__c = p.Lead__c;
                                        attNew.attendeeValue.Contact__c = null;
                                        attNew.attendeeValue.Account__c = null;
                                        attNew.proDialogueAttendee.Lead__c = p.Lead__c;
                                    }
                                    if(attNew.proDialogueAttendee.Account__c != p.Account__c && p.Account__c!=null) {
                                        attNew.selAttendeeType = 'Account';
                                        attNew.attendeeValue.Account__c = p.Account__c;
                                        attNew.attendeeValue.Contact__c = null;
                                        attNew.attendeeValue.Lead__c = null;
                                        attNew.proDialogueAttendee.Account__c = p.Account__c;
                                    }
                                    if(attNew.proDialogueAttendee.Role__c != p.Role__c) attNew.proDialogueAttendee.Role__c = p.Role__c;
                                    newAttendeeList.add(attNew);
                                    indexCounter++;
                            }
                        }
                    } else if(p.Record_Id__c == null){
                        attNew.proDialogueAttendee.Account__c = p.Account__c;
                        attNew.proDialogueAttendee.Contact__c = p.Contact__c;
                        attNew.proDialogueAttendee.Lead__c = p.Lead__c;
                        attNew.proDialogueAttendee.Role__c = p.Role__c;
                        if(attNew.proDialogueAttendee.Lead__c != null){
                            attNew.selAttendeeType = 'Lead';
                            attNew.attendeeValue.Lead__c = p.Lead__c;
                            attNew.attendeeValue.Account__c = null;
                            attNew.attendeeValue.Contact__c = null;
                        }else if(attNew.proDialogueAttendee.Contact__c != null){
                            attNew.selAttendeeType = 'Contact';
                            attNew.attendeeValue.Contact__c = p.Contact__c;
                            attNew.attendeeValue.Account__c = null;
                            attNew.attendeeValue.Lead__c = null;
                        }else if(attNew.proDialogueAttendee.Account__c != null){
                            attNew.selAttendeeType = 'Account';
                            attNew.attendeeValue.Account__c = p.Account__c;
                            attNew.attendeeValue.Contact__c = null;
                            attNew.attendeeValue.Lead__c = null;
                        }
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
                    VOCUtil.VOCItemWrapper existingVOCs = VOCUtil.fetchExistingVOCsInTemp(productLineList,salesLineList,serviceLineList,otherLineList,vocInputFromTempId);
                    productLineList = existingVOCs.productLineList;
                    
                    for(VOCLine obj : productLineList){
                        
                        if(obj.vocEntry.Product_Line__c != null && obj.vocEntry.Product_Line__c != vocTemp.Product_Line__c){
                            obj.pFamilyOptions = VOCUtil.prepareProductFamily(obj.vocEntry.Product_Line__c);
                        }
                        if(obj.vocEntry.Product_Family__c != null && obj.vocEntry.Product_Family__c != vocTemp.Product_Family__c){
                            obj.brandOptions = VOCUtil.prepareBrand(obj.vocEntry.Product_Family__c);
                        }
                 /* DB       if(obj.vocEntry.Brand__c != null && obj.vocEntry.Brand__c != vocTemp.Brand__c){
                            obj.mFamilyOptions = VOCUtil.prepareMarketFamily(obj.vocEntry.Brand__c);
                        }
                */
                        //CF S-490560 Start
                        if(obj.vocEntry.Market_Family__c != null && obj.vocEntry.Market_Family__c != vocTemp.Market_Family__c){
                            obj.mSegmentOptions = VOCUtil.prepareMarketSegment(obj.vocEntry.Market_Family__c);
                        }
                        //CF S-490560 End
                        List<SelectOption> options = new List<SelectOption>();
                        options.add(new SelectOption('', '--None--'));
                     /* DB   Schema.DescribeFieldResult fieldResultbrand = VOC_Data_Entry__c.Brand__c.getDescribe();
                        List<Schema.PicklistEntry> brandple = fieldResultbrand.getPicklistValues();
                        if(obj.vocEntry.Topic__c=='Board'){
                            //For Brand Values
                            for(Schema.PicklistEntry pbnd : brandple){
                                if((proDialogue.Sales_Role__c == 'SAM' || proDialogue.Sales_Role__c == 'ASM' || proDialogue.Sales_Role__c == 'RSM' || proDialogue.Sales_Role__c == 'TM' || proDialogue.Sales_Role__c == 'Sales/Service' || proDialogue.Sales_Role__c == 'Finishing')
                            && (pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Diamondback' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='All' || pbnd.getValue()=='None')){
                                    options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                                } else if((proDialogue.Sales_Role__c == 'Customer Service' || proDialogue.Sales_Role__c == 'Marketing') && (pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Diamondback' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='All' || pbnd.getValue()=='None')){
                                    options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                                } else if((proDialogue.Sales_Role__c == 'Tech Services' )&& (pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Diamondback' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='GlasRoc Interior' || pbnd.getValue()=='All' || pbnd.getValue()=='None'|| pbnd.getValue()=='Xroc')){
                                    options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                                }
                            }
                        }else if(obj.vocEntry.Topic__c=='Finishing'){
                            //For Brand Values
                            for(Schema.PicklistEntry pbnd : brandple){
                                if((proDialogue.Sales_Role__c == 'SAM' || proDialogue.Sales_Role__c == 'ASM' || proDialogue.Sales_Role__c == 'RSM' || proDialogue.Sales_Role__c == 'TM' || proDialogue.Sales_Role__c == 'Sales/Service' || proDialogue.Sales_Role__c == 'Finishing')
                            && (pbnd.getValue()=='Ready Mix' || pbnd.getValue()=='No Coat' || pbnd.getValue()=='Proline' || pbnd.getValue()=='Leveline' || pbnd.getValue()=='AquaBead' || pbnd.getValue()=='HydroTrim' || pbnd.getValue()=='Setting Comp' || pbnd.getValue()=='Setting Compound' || pbnd.getValue()=='Paper Tape' || pbnd.getValue()=='FibaFuse' || pbnd.getValue()=='Texture' || pbnd.getValue()=='Cornerbeads - Other' || pbnd.getValue()=='All' || pbnd.getValue()=='None')){
                                    options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                                } else if((proDialogue.Sales_Role__c == 'Customer Service' || proDialogue.Sales_Role__c == 'Marketing' || proDialogue.Sales_Role__c == 'Tech Services')&& (pbnd.getValue()=='Ready Mix' || pbnd.getValue()=='No Coat' || pbnd.getValue()=='Proline' || pbnd.getValue()=='Leveline' || pbnd.getValue()=='AquaBead' || pbnd.getValue()=='HydroTrim' || pbnd.getValue()=='Setting Comp' || pbnd.getValue()=='Setting Compound' || pbnd.getValue()=='Paper Tape' || pbnd.getValue()=='FibaFuse' || pbnd.getValue()=='Texture' || pbnd.getValue()=='Cornerbeads - Other' || pbnd.getValue()=='All' || pbnd.getValue()=='None')){
                                    options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                                }
                            }
                        } else if(obj.vocEntry.Topic__c=='Both'){
                            //For Brand Values
                            for(Schema.PicklistEntry pbnd : brandple){
                                if(pbnd.getValue()=='Ready Mix' || pbnd.getValue()=='No Coat' || pbnd.getValue()=='Proline' || pbnd.getValue()=='Leveline' || pbnd.getValue()=='AquaBead' || pbnd.getValue()=='HydroTrim' || pbnd.getValue()=='Setting Comp' || pbnd.getValue()=='Setting Compound' || pbnd.getValue()=='Paper Tape' || pbnd.getValue()=='FibaFuse' || pbnd.getValue()=='Texture' || pbnd.getValue()=='Cornerbeads - Other' || pbnd.getValue()=='All' || pbnd.getValue()=='None' || pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='Xroc'){
                                    options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                                }
                            }
                        }
                */
                        obj.brandvalues = options;
                            
                    }
                    //salesLineList = existingVOCs.salesLineList;
                    //serviceLineList = existingVOCs.serviceLineList;
                    //otherLineList = existingVOCs.otherLineList;
                    productLineList = existingVOCs.productLineList;
                    
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
                vLine.vocEntry.Category__c = 'Marketing General';
                salesLineList.add(vLine);
            }
            
            if(serviceLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Sales General';
                serviceLineList.add(vLine);
            }
            
            if(otherLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Competitor';
                otherLineList.add(vLine);                                                   
            }
            System.Debug('1111111111111111111111111111111'+productLineList);
            
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
                proDialogue = [Select p.TM__c, p.TM__r.Name, p.Sales_Role__c, p.Region__c, p.OwnerId, p.Other_Participants__c, p.Notes__c, p.No1_of_Attendees__c , p.Name,p.Weekly_Report__c, 
                                p.Meeting_Date__c, p.Information_Source__c,p.Additional_Info_Source__c, p.Id, p.Facilitator__c, p.Facilitator__r.Name, p.City_State__c, p.Audience__c, p.Active__c 
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
                List<ProDialogue_Input_Attendee__c> proAttendees = [Select p.Role__c, p.ProDialogue_Input__c, p.Name, p.Account__c, p.Lead__c, p.Id, p.Contact__c 
                                                                    From ProDialogue_Input_Attendee__c p Where ProDialogue_Input__c =: proDialogueId];
                for(ProDialogue_Input_Attendee__c p : proAttendees) {
                    Attendee att = new Attendee();
                    att.rIndex = indexCounter;
                    att.proDialogueAttendee = p;
                    if(p.Lead__c != null){
                        att.selAttendeeType = 'Lead';
                        att.attendeeValue.Lead__c = p.Lead__c;
                        att.attendeeValue.Contact__c = null;
                        att.attendeeValue.Account__c = null;
                    }
                    if(p.Contact__c != null){
                        att.selAttendeeType = 'Contact';
                        att.attendeeValue.Contact__c = p.Contact__c;
                        att.attendeeValue.Lead__c = null;
                        att.attendeeValue.Account__c = null;
                    }
                    if(p.Account__c != null){
                        att.selAttendeeType = 'Account';
                        att.attendeeValue.Account__c = p.Account__c;
                        att.attendeeValue.Lead__c = null;
                        att.attendeeValue.Contact__c = null;
                    }
                    attendeeList.add(att);
                    indexCounter++;
                }
                
                //load voc for each category
                VOCUtil.VOCItemWrapper existingVOCs = VOCUtil.fetchExistingVOCs(proDialogueId);
                productLineList = existingVOCs.productLineList;
                
                //Name - Madan (Jun 9, 2014)
                //Description - added below logic for bind dipendent picklist values.
                //-----------------------------------------------
                for(VOCLine obj : productLineList){
                    if(obj.vocEntry.Product_Line__c != null){
                        obj.pFamilyOptions = VOCUtil.prepareProductFamily(obj.vocEntry.Product_Line__c);
                    }
                    if(obj.vocEntry.Product_Family__c != null){
                        obj.brandOptions = VOCUtil.prepareBrand(obj.vocEntry.Product_Family__c);
                    }
                /* DB    if(obj.vocEntry.Brand__c != null){
                        obj.mFamilyOptions = VOCUtil.prepareMarketFamily(obj.vocEntry.Brand__c);
                    }
                */
                    if(obj.vocEntry.Market_Family__c != null){
                        obj.mSegmentOptions = VOCUtil.prepareMarketSegment(obj.vocEntry.Market_Family__c);
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
                vLine.vocEntry.Category__c = 'Marketing General';
                salesLineList.add(vLine);
            }
            
            if(serviceLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Sales General';
                serviceLineList.add(vLine);
            }
            
            if(otherLineList.size() == 0) {
                VOCLine vLine = new VOCLine();
                vLine.rIndex = 0;
                vLine.vocEntry.Category__c = 'Competitor';
                otherLineList.add(vLine);
            }
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in deleting record.'));
        }
    }
    
    //-------------------------------------End of Arpit 20-Feb-2015--------------------------------------------------------------------
    //--------------------------------------End of Arpit updated code---------------------------------------------------------
    //Shakti 10/28/2015 Set the country field value based on region field value.
    public void setCountry(){
        if(proDialogue.Region__c=='Northeast' || proDialogue.Region__c=='Southeast' || proDialogue.Region__c=='South Central' || proDialogue.Region__c=='Midwest' 
            || proDialogue.Region__c=='Northwest' || proDialogue.Region__c=='North Central' || proDialogue.Region__c=='Southwest' || proDialogue.Region__c=='North Finishing' || proDialogue.Region__c=='South Finishing' || proDialogue.Region__c=='West Finishing'){
            proDialogue.Country__c = 'USA';
        }else if(proDialogue.Region__c=='Atlantic' || proDialogue.Region__c=='Quebec' || proDialogue.Region__c=='Central Ontario' || proDialogue.Region__c=='Western Canada'){
            proDialogue.Country__c = 'Canada';
        }
    }
    
    //Shakti 10/29/2015 code for add the attachments.
    public string fileName{get;set;}
    public Blob fileBody{get;set;}
    private Attachment myAttach;
    public Boolean cShowPopup {get;set;}
    
    public void uploadAtt(){
        cShowPopup = true;
    }
    
    public void uploadAttach(){
        myAttach.Body = fileBody;
        myAttach.Name = fileName;
        fileBody = null;
        fileName = null;
        cShowPopup = false;
    }
    public Pagereference uploadAttachment(){
        System.Debug('>>>>>>>>>>'+proDialogue);
        Pagereference pr;
        if(proDialogue==null || proDialogue.Id==null){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please save and submit the form to upload the attachment.'));
            return null;
        } else if(proDialogue!=null && proDialogue.Id!=null){
            pr = new Pagereference('/apex/AttachmentUpload?id=' + proDialogue.Id);    
        }
        return pr;
    }
    
    /*
    @Name   :getMarketingTopic
    @Description :To get Topic picklist values
    */
    public List<SelectOption> getMarketingTopic(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        Schema.DescribeFieldResult fieldResult = VOC_Data_Entry__c.Topic__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            if((proDialogue.Sales_Role__c == 'SAM' || proDialogue.Sales_Role__c == 'ASM' || proDialogue.Sales_Role__c == 'RSM' || proDialogue.Sales_Role__c == 'TM' || proDialogue.Sales_Role__c == 'Sales/Service' || proDialogue.Sales_Role__c == 'Finishing')
                && (p.getValue()=='Tools' || p.getValue()=='Collateral' || p.getValue()=='Events' || p.getValue()=='Website' || p.getValue()=='Apps' || p.getValue()=='Other' || p.getValue()=='Mechandising')){
                options.add(new SelectOption(p.getValue(), p.getValue()));
            } else if((proDialogue.Sales_Role__c == 'Tech Services' || proDialogue.Sales_Role__c == 'Customer Service' || proDialogue.Sales_Role__c == 'Marketing') && (p.getValue()=='Tools' || p.getValue()=='Collateral' || p.getValue()=='Events' || p.getValue()=='Website' ||  p.getValue()=='Apps' || p.getValue()=='Other' || p.getValue()== 'Responsiveness')){
                options.add(new SelectOption(p.getValue(), p.getValue()));
            }
        }
        return options;
    }
    /*
    @Name   :getSalesTopic
    @Description :To get Topic picklist values
    */
    public List<SelectOption> getSalesTopic(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        Schema.DescribeFieldResult fieldResult = VOC_Data_Entry__c.Topic__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            if((proDialogue.Sales_Role__c == 'SAM' || proDialogue.Sales_Role__c == 'ASM' || proDialogue.Sales_Role__c == 'RSM' || proDialogue.Sales_Role__c == 'TM' || proDialogue.Sales_Role__c == 'Sales/Service' || proDialogue.Sales_Role__c == 'Finishing')
                && (p.getValue()=='Covergage' || p.getValue()=='Responsiveness' || p.getValue()=='Training' || p.getValue()=='Skills' || p.getValue()=='Strategy' || p.getValue()=='Other')){
                options.add(new SelectOption(p.getValue(), p.getValue()));
            } else if((proDialogue.Sales_Role__c == 'Tech Services' || proDialogue.Sales_Role__c == 'Customer Service' || proDialogue.Sales_Role__c == 'Marketing') && (p.getValue()=='Covergage' || p.getValue()=='Training' || p.getValue()=='Skills' || p.getValue()=='Strategy' ||  p.getValue()=='Other' || p.getValue()== 'Responsiveness')){
                options.add(new SelectOption(p.getValue(), p.getValue()));
            }
        }
        return options;
    }
    public void changeSelectoption(){
        if(productLineList.size()>0){
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('', '--None--'));
            List<SelectOption> insightList = new List<SelectOption>();
            insightList.add(new SelectOption('', '--None--'));
       /* DB     Schema.DescribeFieldResult fieldResultbrand = VOC_Data_Entry__c.Brand__c.getDescribe();
            List<Schema.PicklistEntry> brandple = fieldResultbrand.getPicklistValues();
            Schema.DescribeFieldResult fieldResultInsight = VOC_Data_Entry__c.Insight__c.getDescribe();
            List<Schema.PicklistEntry> insight = fieldResultInsight.getPicklistValues();
            for(Schema.PicklistEntry pickListItem : insight){
                            if(pickListItem.getValue() == 'New Product Idea' || pickListItem.getValue() == 'Acoustics' ||pickListItem.getValue() == 'Apps' || pickListItem.getValue() == 'Availability' || pickListItem.getValue() == 'Compliance and Regulation' || pickListItem.getValue() == 'Covergage' || pickListItem.getValue() == 'Durability' || pickListItem.getValue() == 'Installation' || pickListItem.getValue() == 'Events' || pickListItem.getValue() == 'Fire Rating' || pickListItem.getValue() == 'IAQ' || pickListItem.getValue() == 'Lead Time' || pickListItem.getValue() == 'Literature' || pickListItem.getValue() == 'Logistics' || pickListItem.getValue() == 'Merchandising' || pickListItem.getValue() == 'Mold & Moisture'|| pickListItem.getValue() == 'Order Entry' || pickListItem.getValue() == 'Packaging' || pickListItem.getValue() == 'POP' || pickListItem.getValue() == 'Price'|| pickListItem.getValue() == 'Promotion' || pickListItem.getValue() == 'Quality' || pickListItem.getValue() == 'Responsiveness' || pickListItem.getValue() == 'Retail'|| pickListItem.getValue() == 'Samples' || pickListItem.getValue() == 'Service' || pickListItem.getValue() == 'Skills' || pickListItem.getValue() == 'Specification'|| pickListItem.getValue() == 'Strategy' || pickListItem.getValue() == 'Sustainability' || pickListItem.getValue() == 'Tools' || pickListItem.getValue() == 'Training'|| pickListItem.getValue() == 'Website' || pickListItem.getValue() == 'Other'){
                                insightList.add(new SelectOption(pickListItem.getValue(), pickListItem.getValue()));
                            }
            }
            for(VOCLine vol : productLineList){
                if(vol.rIndex==tIndex){
                    if(vol.vocEntry.Topic__c=='Board'){
                        //For Brand Values
                        for(Schema.PicklistEntry pbnd : brandple){
                            if((proDialogue.Sales_Role__c == 'SAM' || proDialogue.Sales_Role__c == 'ASM' || proDialogue.Sales_Role__c == 'RSM' || proDialogue.Sales_Role__c == 'TM' || proDialogue.Sales_Role__c == 'Sales/Service' || proDialogue.Sales_Role__c == 'Finishing')
                        && (pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Diamondback' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='All' || pbnd.getValue()=='None')){
                                options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                            } else if((proDialogue.Sales_Role__c == 'Customer Service' || proDialogue.Sales_Role__c == 'Marketing') && (pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Diamondback' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='All' || pbnd.getValue()=='None')){
                                options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                            } else if((proDialogue.Sales_Role__c == 'Tech Services' )&& (pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Diamondback' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='GlasRoc Interior' || pbnd.getValue()=='All' || pbnd.getValue()=='None'|| pbnd.getValue()=='Xroc')){
                                options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                            }
                        }
                    }else if(vol.vocEntry.Topic__c=='Finishing'){
                        //For Brand Values
                        for(Schema.PicklistEntry pbnd : brandple){
                            if((proDialogue.Sales_Role__c == 'SAM' || proDialogue.Sales_Role__c == 'ASM' || proDialogue.Sales_Role__c == 'RSM' || proDialogue.Sales_Role__c == 'TM' || proDialogue.Sales_Role__c == 'Sales/Service' || proDialogue.Sales_Role__c == 'Finishing')
                        && (pbnd.getValue()=='Ready Mix' || pbnd.getValue()=='No Coat' || pbnd.getValue()=='Proline' || pbnd.getValue()=='Leveline' || pbnd.getValue()=='AquaBead' || pbnd.getValue()=='HydroTrim' || pbnd.getValue()=='Setting Comp' || pbnd.getValue()=='Setting Compound' || pbnd.getValue()=='Paper Tape' || pbnd.getValue()=='FibaFuse' || pbnd.getValue()=='Texture' || pbnd.getValue()=='Cornerbeads - Other' || pbnd.getValue()=='All' || pbnd.getValue()=='None')){
                                options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                            } else if((proDialogue.Sales_Role__c == 'Customer Service' || proDialogue.Sales_Role__c == 'Marketing' || proDialogue.Sales_Role__c == 'Tech Services')&& (pbnd.getValue()=='Ready Mix' || pbnd.getValue()=='No Coat' || pbnd.getValue()=='Proline' || pbnd.getValue()=='Leveline' || pbnd.getValue()=='AquaBead' || pbnd.getValue()=='HydroTrim' || pbnd.getValue()=='Setting Comp' || pbnd.getValue()=='Setting Compound' || pbnd.getValue()=='Paper Tape' || pbnd.getValue()=='FibaFuse' || pbnd.getValue()=='Texture' || pbnd.getValue()=='Cornerbeads - Other' || pbnd.getValue()=='All' || pbnd.getValue()=='None')){
                                options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                            }
                        }
                    } else if(vol.vocEntry.Topic__c=='Both'){
                        //For Brand Values
                        for(Schema.PicklistEntry pbnd : brandple){
                            if(pbnd.getValue()=='Ready Mix' || pbnd.getValue()=='No Coat' || pbnd.getValue()=='Proline' || pbnd.getValue()=='Leveline' || pbnd.getValue()=='AquaBead' || pbnd.getValue()=='HydroTrim' || pbnd.getValue()=='Setting Comp' || pbnd.getValue()=='Setting Compound' || pbnd.getValue()=='Paper Tape' || pbnd.getValue()=='FibaFuse' || pbnd.getValue()=='Texture' || pbnd.getValue()=='Cornerbeads - Other' || pbnd.getValue()=='All' || pbnd.getValue()=='None' || pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='Xroc'){
                                options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                            }
                        }
                    } else if(vol.vocEntry.Topic__c=='Systems'){
                        //For Brand Values
                        for(Schema.PicklistEntry pbnd : brandple){
                            if(pbnd.getValue()=='Ready Mix' || pbnd.getValue()=='No Coat' || pbnd.getValue()=='Proline' || pbnd.getValue()=='Leveline' || pbnd.getValue()=='AquaBead' || pbnd.getValue()=='HydroTrim' || pbnd.getValue()=='Setting Comp' || pbnd.getValue()=='Setting Compound' || pbnd.getValue()=='Paper Tape' || pbnd.getValue()=='FibaFuse' || pbnd.getValue()=='Texture' || pbnd.getValue()=='Cornerbeads - Other' || pbnd.getValue()=='All' || pbnd.getValue()=='None' || pbnd.getValue()=='1/4 Flex & Regular' || pbnd.getValue()=='AirRenew' || pbnd.getValue()=='Easi-Lite' || pbnd.getValue()=='GlasRoc' || pbnd.getValue()=='Habito' || pbnd.getValue()=='Abuse' || pbnd.getValue()=='M2Tech' || pbnd.getValue()=='SilentFX' || pbnd.getValue()=='TC Sheathing' || pbnd.getValue()=='Type C' || pbnd.getValue()=='Type X' || pbnd.getValue()=='Veneer' || pbnd.getValue()=='Xroc'){
                                options.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                            }
                        }
                    }
                    vol.brandvalues = options;
                    vol.insightOptions=insightList;
                }
            }
            */
        }
                
            
    }
    public void clearSelectoption(){
        if(productLineList.size()>0){
            for(VOCLine vol : productLineList){
                vol.insightOptions = new List<Selectoption>();
                vol.brandvalues = new List<Selectoption>();
                vol.vocEntry.Insight__c = null;
           // DB     vol.vocEntry.Brand__c = null;
                vol.vocEntry.Sub_Brand__c = null;
                tIndex = vol.rindex;
                changeSelectoption();
            }
            
        }
        if(salesLineList.size()>0){
            for(VOCLine vol : salesLineList){
                vol.vocEntry.Topic__c = null;
            }
        }
        if(serviceLineList.size()>0){
            for(VOCLine vol : serviceLineList){
                vol.vocEntry.Topic__c = null;
            }
        }
        if(otherLineList.size()>0){
            for(VOCLine vol : otherLineList){
                vol.vocEntry.Topic__c = null;
            }
        }
    }
    
    public Boolean getIsSF1(){
        if(String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameHost')) ||
            String.isNotBlank(ApexPages.currentPage().getParameters().get('sfdcIFrameOrigin')) ||
            ApexPages.currentPage().getParameters().get('isdtp') == 'p1' ||
            (ApexPages.currentPage().getParameters().get('retURL') != null && ApexPages.currentPage().getParameters().get('retURL').contains('projectone') )){
            return true;
        }else{
            return false;
        }
    }
     /*
    @Name   :getTopic
    @Description :To get Topic picklist values
    */
    public List<SelectOption> getTopic(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Product', 'Products'));
        options.add(new SelectOption('Marketing General', 'Marketing General'));
        options.add(new SelectOption('Sales General', 'Sales General'));
        return options;
    }
    public void changetopic(){
        if(productLineList.size()>0){
            Schema.DescribeFieldResult fieldResultInsight = VOC_Data_Entry__c.Insight__c.getDescribe();
            List<Schema.PicklistEntry> insightple = fieldResultInsight.getPicklistValues();
          /* DB  Schema.DescribeFieldResult fieldResultbrand = VOC_Data_Entry__c.Brand__c.getDescribe();
            List<Schema.PicklistEntry> brandple = fieldResultbrand.getPicklistValues();
            
            for(VOCLine vol : productLineList){
                if(vol.rIndex==tIndex && (vol.vocEntry.Category__c == 'Marketing')){
                    List<SelectOption> options = new List<SelectOption>();
                    List<SelectOption> options1 = new List<SelectOption>();
                    vol.vocEntry.Topic__c = 'Marketing General';
                    options.add(new SelectOption('Marketing General', 'Marketing General'));
                    for(Schema.PicklistEntry pbnd : insightple){
                        if((pbnd.getValue()=='Acoustics' || pbnd.getValue()=='Apps' || pbnd.getValue()=='Availability' || pbnd.getValue()=='Compliance and Regulation' || pbnd.getValue()=='Covergage' || pbnd.getValue()=='Durability' || pbnd.getValue()=='Installation' || pbnd.getValue()=='Events' || pbnd.getValue()=='Fire Rating' || pbnd.getValue()=='IAQ' || pbnd.getValue()=='Literature' || pbnd.getValue()=='Lead Time' || pbnd.getValue()=='Literature' || pbnd.getValue()=='Logistics' || pbnd.getValue()=='Mechandising' || pbnd.getValue()=='Mold & Moisture' || pbnd.getValue()=='Order Entry' || pbnd.getValue()=='Other' || pbnd.getValue()=='Packaging' || pbnd.getValue()=='POP' || pbnd.getValue()=='Price' || pbnd.getValue()=='Promotion' || pbnd.getValue()=='Quality' || pbnd.getValue()=='Responsiveness' || pbnd.getValue()=='Retail' || pbnd.getValue()=='Samples' || pbnd.getValue()=='Service' || pbnd.getValue()=='Skills' || pbnd.getValue()=='Specification' || pbnd.getValue()=='Strategy' || pbnd.getValue()=='Sustainability' || pbnd.getValue()=='Tools' || pbnd.getValue()=='Training' || pbnd.getValue()=='Website')){
                            options1.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                        }
                    }
                    vol.brandvalues = options;
                    vol.insightOptions = options1;
                } else if(vol.rIndex==tIndex && (vol.vocEntry.Category__c == 'Products')){
                    List<SelectOption> options = new List<SelectOption>();
                    List<SelectOption> options1 = new List<SelectOption>();
                    options.add(new SelectOption('--None--', '--None--'));
                    options1.add(new SelectOption('--None--', '--None--'));
                    vol.brandvalues = options;
                    vol.insightOptions = options1;
                }
                if(vol.rIndex==tIndex && (vol.vocEntry.Category__c == 'Sales & Service')){
                    List<SelectOption> options = new List<SelectOption>();
                    List<SelectOption> options1 = new List<SelectOption>();
                    options.add(new SelectOption('Sales General', 'Sales General'));
                    vol.vocEntry.Topic__c = 'Sales General';
                    for(Schema.PicklistEntry pbnd : insightple){
                        if((pbnd.getValue()=='Acoustics' || pbnd.getValue()=='Apps' || pbnd.getValue()=='Availability' || pbnd.getValue()=='Compliance and Regulation' || pbnd.getValue()=='Covergage' || pbnd.getValue()=='Durability' || pbnd.getValue()=='Installation' || pbnd.getValue()=='Events' || pbnd.getValue()=='Fire Rating' || pbnd.getValue()=='IAQ' || pbnd.getValue()=='Literature' || pbnd.getValue()=='Lead Time' || pbnd.getValue()=='Literature' || pbnd.getValue()=='Logistics' || pbnd.getValue()=='Mechandising' || pbnd.getValue()=='Mold & Moisture' || pbnd.getValue()=='Order Entry' || pbnd.getValue()=='Other' || pbnd.getValue()=='Packaging' || pbnd.getValue()=='POP' || pbnd.getValue()=='Price' || pbnd.getValue()=='Promotion' || pbnd.getValue()=='Quality' || pbnd.getValue()=='Responsiveness' || pbnd.getValue()=='Retail' || pbnd.getValue()=='Samples' || pbnd.getValue()=='Service' || pbnd.getValue()=='Skills' || pbnd.getValue()=='Specification' || pbnd.getValue()=='Strategy' || pbnd.getValue()=='Sustainability' || pbnd.getValue()=='Tools' || pbnd.getValue()=='Training' || pbnd.getValue()=='Website')){
                            options1.add(new SelectOption(pbnd.getValue(), pbnd.getValue()));
                        }
                    }
                    vol.brandvalues = options;
                    vol.insightOptions = options1;
                } else if(vol.rIndex==tIndex && (vol.vocEntry.Category__c == 'Products')){
                    List<SelectOption> options = new List<SelectOption>();
                    List<SelectOption> options1 = new List<SelectOption>();
                    options.add(new SelectOption('--None--', '--None--'));
                    options1.add(new SelectOption('--None--', '--None--'));
                    vol.brandvalues = options;
                    vol.insightOptions = options1;
                }
            }
        */
        }
    }
    public List<SelectOption> getProDialogueRegion(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Northeast', 'Northeast'));
        options.add(new SelectOption('Southeast', 'Southeast'));
        options.add(new SelectOption('South Central', 'South Central'));
                                options.add(new SelectOption('Midwest', 'Midwest'));
        options.add(new SelectOption('Northwest', 'Northwest'));
        options.add(new SelectOption('North Central', 'North Central'));
                                options.add(new SelectOption('Southwest', 'Southwest'));
        options.add(new SelectOption('Atlantic', 'Atlantic'));
        options.add(new SelectOption('Quebec', 'Quebec'));
                                options.add(new SelectOption('Central Ontario', 'Central Ontario'));
        options.add(new SelectOption('Western Canada', 'Western Canada'));
        options.add(new SelectOption('North Finishing', 'North Finishing'));
                                options.add(new SelectOption('South Finishing', 'South Finishing'));
        options.add(new SelectOption('West Finishing', 'West Finishing'));
        options.add(new SelectOption('Corporate','Corporate'));
        return options;
    }
    // START NSINGH - S-538910 - Added new method for redirecting
    public pagereference redirectPage(){
            system.debug(UserInfo.getUiThemeDisplayed());
         if(UserInfo.getUiThemeDisplayed() == 'Theme4d'){
             pagereference p;
             if(proDialogueId!=null && proDialogueId!=''){
                 p = new pagereference('/one/one.app#/n/VOC_Input_Form?id='+proDialogueId);
             }
             else{
                 p = new pagereference('/one/one.app#/n/VOC_Input_Form');
             }
             p.setredirect(false);
            return p;
         }
        return null;
    }
    // END NSINGH - S-538910
}