// ==================================================================================
//   Object: OnlineFormController
//  Company: Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Online From acts as Force.com site which stores the Online From data and
//           associated VOC's 
// ==================================================================================
//  Changes: 2013-10-29 Initial version.
//           1. Madan (Jun 9, 2014) - added below logic for bind dipendent picklist values.
//           2. Arpit (Dec 8, 2014) - added logic to store data in Temperory object and resume it from Temp.
//           3. Arpit
// ==================================================================================

public class OnlineFormController_Siding {

    public Online_Form__c onlineForm {get;set;}
    public Online_Form_Temp__c onlineFormTemp{get;set;}
    public VOC_Data_Entry__c voc{get;set;}
    public VOC_Data_Entry_Temp__c vocTemp{get;set;}
    public List<VOCLine> productLineList {get;set;}
    public List<VOCLine> salesLineList {get;set;}
    public List<VOCLine> serviceLineList {get;set;}
    public List<VOCLine> otherLineList {get;set;}
    public List<Online_Form_Temp__c> onlineVocFormTempList{get;set;}
    public Boolean showOnlineForm {get;set;}
    public String captchaValue {get;set;}
    public Boolean blnShowConfirmBox {get; set;}
    public String onlineVocFromTempId {get;set;}
    
    private String onlineFormId;
    
    
    
    public OnlineFormController_Siding(Apexpages.standardController sc) {
        onlineForm = new Online_Form__c();
        voc = new VOC_Data_Entry__c();
        productLineList = new List<VOCLine>();
        salesLineList = new List<VOCLine>();
        serviceLineList = new List<VOCLine>();
        otherLineList = new List<VOCLine>();
        blnShowConfirmBox = false;
        showOnlineForm = true;
        
        onlineFormId = sc.getId();
        System.debug('Online Form Id:::' + onlineFormId);
        String scVar = Apexpages.currentPage().getParameters().get('sc');
        if(scVar != null && scVar != ''){
            updateTempObj();
        } else {
            if(onlineFormId != null) {
                
                onlineForm = [Select o.Region__c, o.OwnerId, o.Name, o.Last_Name__c, o.Information_Source__c, o.Id, o.First_Name__c, 
                                o.Email__c, o.Department__c, o.Audience__c From Online_Form__c o Where Id =: onlineFormId];
                                
                //load voc for each category
                VOCUtil_Siding.VOCItemWrapper existingVOCs = VOCUtil_Siding.fetchExistingVOCs(onlineFormId);
                productLineList = existingVOCs.productLineList;
                System.debug('existingVOCs List:::' + existingVOCs);
                
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
            
            //------------------------------------Arpit adding code to resume temp data from temp obj--------------
            String onlineVocFromTemp = 'Select id from Online_Form_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
            if(onlineFormId != null) onlineVocFromTemp += ' and Record_Id__c = ' +'\''+ onlineFormId+'\'';
            else if(onlineFormId == null) onlineVocFromTemp += ' and Record_Id__c = null';
            
            onlineVocFormTempList = new List<Online_Form_Temp__c>();
            onlineVocFormTempList = Database.query(onlineVocFromTemp);
            if(onlineVocFormTempList.size() > 0){
                blnShowConfirmBox = true;
            }
            //-----------------------------------------------------------------------------------------------------
        }
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
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        productLineList = VOCUtil_Siding.removeLineItem(productLineList, delIndex);
    }
    
    public void removeSalesLine() {
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        salesLineList = VOCUtil_Siding.removeLineItem(salesLineList, delIndex);
    }
    
    public void removeServiceLine() {
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        serviceLineList = VOCUtil_Siding.removeLineItem(serviceLineList, delIndex);
    }
    
    public void removeOtherLine() {
        String delIndex = System.currentPageReference().getParameters().get('rIndex');
        System.debug(':delIndex: '+delIndex);
        otherLineList = VOCUtil_Siding.removeLineItem(otherLineList, delIndex);
    }
    
    public Pagereference saveOnlineForm() {
        Pagereference pr;
        
        try {
            //add captcha logic
            if(verify()) {
                Savepoint sp = Database.setSavepoint();
                try {
                    Boolean validationFailed = VOCUtil_Siding.validateVOC(productLineList, 'Products', '');
                    if(validationFailed) return pr;
                    
                    upsert onlineForm;
                    
                    //iterate and add valid voc entries
                    List<VOC_Data_Entry__c> vocInsert = new List<VOC_Data_Entry__c>();
                    vocInsert = VOCUtil_Siding.doAdd(vocInsert, productLineList, 'Products', 'Online', onlineForm.Id);
                    vocInsert = VOCUtil_Siding.doAdd(vocInsert, salesLineList, 'Marketing Supports', 'Online', onlineForm.Id);
                    vocInsert = VOCUtil_Siding.doAdd(vocInsert, serviceLineList, 'Marketing Programs', 'Online', onlineForm.Id);
                    vocInsert = VOCUtil_Siding.doAdd(vocInsert, otherLineList, 'Miscellaneous', 'Online', onlineForm.Id);
                    
                    if(vocInsert.size() > 0) {
                        upsert vocInsert;
                    }
                    deleteMethod();
                    showOnlineForm = false;
                    //pr = new Pagereference('/' + onlineForm.Id);
                } catch(Exception ex) {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
                    Database.rollback(sp);
                }
            }
        } catch(Exception ex) {
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
        return pr;
    }
    
        // Whether the submission has passed reCAPTCHA validation or not
    public Boolean verified { get; private set; }
    
    public Boolean verify() {
        System.debug('reCAPTCHA verification attempt');
        String captchaResult = Apexpages.currentPage().getParameters().get('captchaResult');
        this.verified = (captchaResult.startsWithIgnoreCase('true'));
        
        if(this.verified) {
            return true;
        }
        else {
            // stay on page to re-try reCAPTCHA
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please re-enter the verification code and try again.'));
            return null;
        }
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
    
  //-----------------------------------Arpit adding a method to save records in temp obj--------------------------
    public void saveButton(){
        try{
            onlineFormTemp = new Online_Form_Temp__c();
            vocTemp = new VOC_Data_Entry_Temp__c();
            
            deleteMethod();
            onlineFormTemp.Audience__c = onlineForm.Audience__c;
            onlineFormTemp.Department__c = onlineForm.Department__c;
            onlineFormTemp.Email__c = onlineForm.Email__c;
            onlineFormTemp.First_Name__c = onlineForm.First_Name__c;
            onlineFormTemp.Information_Source__c = onlineForm.Information_Source__c;
            onlineFormTemp.Last_Name__c = onlineForm.Last_Name__c;
            onlineFormTemp.Region__c = onlineForm.Region__c;
            onlineFormTemp.User_Id__c = UserInfo.getUserId();
            if(onlineFormId != null){
                onlineFormTemp.Record_Id__c = onlineFormId;
            }
            upsert onlineFormTemp;
            
            //---------------------saving the recods for VOC in Temp Object-------------------------------
            List<VOC_Data_Entry_Temp__c> vocTempInsert = new List<VOC_Data_Entry_Temp__c>();
            
            vocTempInsert = VOCUtil_Siding.doTempAdd(vocTempInsert, productLineList, 'Products', 'Online', onlineFormTemp.Id);
            vocTempInsert = VOCUtil_Siding.doTempAdd(vocTempInsert, salesLineList, 'Marketing Supports', 'Online', onlineFormTemp.Id);
            vocTempInsert = VOCUtil_Siding.doTempAdd(vocTempInsert, serviceLineList, 'Marketing Programs', 'Online', onlineFormTemp.Id);
            vocTempInsert = VOCUtil_Siding.doTempAdd(vocTempInsert, otherLineList, 'Miscellaneous', 'Online', onlineFormTemp.Id);
            
            if(vocTempInsert.size() > 0) upsert vocTempInsert;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Changes saved successfully.'));
            
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Record not saved'));
        }
    }
    
    private void deleteMethod(){
        List<VOC_Data_Entry_Temp__c> vocList = new List<VOC_Data_Entry_Temp__c>();
        List<Online_Form_Temp__c> onlineList = new List<Online_Form_Temp__c>();
        
        String onlineQuery = 'Select id from Online_Form_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
        if(onlineFormId != null && onlineFormId != '') onlineQuery += ' and Record_Id__c = ' +'\''+ onlineFormId+'\'';
        else onlineQuery += ' and Record_Id__c = null';
        onlineList = Database.query(onlineQuery);
        if(onlineList.size() > 0) {
            String vocQuery = 'Select id from VOC_Data_Entry_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\''+' and Online_VOC_Temp__c ='+'\''+onlineList[0].Id+'\'';
            vocList = Database.query(vocQuery);
            if(vocList.size() > 0) {
                delete vocList;
            }
            delete onlineList;
        }
    }
    
    public void updateTempObj(){
        try{System.debug('dddddvvvvvv');
            blnShowConfirmBox = false;
            System.debug('dddddvvvvvv');
            VOC_Data_Entry_Temp__c vocTemp = new VOC_Data_Entry_Temp__c();
                onlineFormTemp = new Online_Form_Temp__c();
                String onlineVocFromTemp = 'Select o.Region__c, o.OwnerId, o.Name, o.Last_Name__c, o.Information_Source__c, o.Id, o.First_Name__c, o.Email__c, o.Department__c, o.Audience__c from Online_Form_Temp__c o where o.User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
                if(onlineFormId != null && onlineFormId != '') onlineVocFromTemp += ' and Record_Id__c = ' +'\''+ onlineFormId+'\'';
                else if(onlineFormId == null) onlineVocFromTemp += ' and Record_Id__c = null';
                List<Online_Form_Temp__c> lstOnlineFormTemp = Database.query(onlineVocFromTemp);
                System.debug('lstOnlineFormTemp:::::'+lstOnlineFormTemp);
                if(lstOnlineFormTemp.size() > 0){
                    onlineFormTemp = lstOnlineFormTemp[0];
                } else onlineFormTemp = null;
                System.debug('onlineFormTemp:::::'+onlineFormTemp);
                if(onlineFormTemp != null){
                    onlineVocFromTempId = String.valueOf(onlineFormTemp.Id); 
                    onlineForm.Audience__c = onlineFormTemp.Audience__c;
                    onlineForm.Department__c = onlineFormTemp.Department__c;
                    onlineForm.Email__c = onlineFormTemp.Email__c;
                    onlineForm.First_Name__c = onlineFormTemp.First_Name__c;
                    onlineForm.Information_Source__c = onlineFormTemp.Information_Source__c;
                    onlineForm.Last_Name__c = onlineFormTemp.Last_Name__c;
                    onlineForm.Region__c = onlineFormTemp.Region__c;
                                    
                    //load voc for each category
                    //Mohan 02.18.2015: clear the list to avoid the email VOC entry to be display before appending the resumed VOCs
                    productLineList.clear();
                    salesLineList.clear();
                    serviceLineList.clear();
                    otherLineList.clear();
                    
                    VOCUtil_Siding.VOCItemWrapper existingVOCs = VOCUtil_Siding.fetchExistingVOCsInTemp(productLineList,salesLineList,serviceLineList,otherLineList,onlineVocFromTempId);
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
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'There is no data for resuming.'));
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
            onlineForm = new Online_Form__c();
            voc = new VOC_Data_Entry__c();
            productLineList = new List<VOCLine>();
            salesLineList = new List<VOCLine>();
            serviceLineList = new List<VOCLine>();
            otherLineList = new List<VOCLine>();
            
            String onlneVOCId = Apexpages.currentPage().getParameters().get('id');
            
            if(onlneVOCId != null && onlneVOCId != ''){
            
                onlineForm = [Select o.Region__c, o.OwnerId, o.Name, o.Last_Name__c, o.Information_Source__c, o.Id, o.First_Name__c, 
                                o.Email__c, o.Department__c, o.Audience__c From Online_Form__c o Where Id =: onlineFormId];
                                
                //load voc for each category
                VOCUtil_Siding.VOCItemWrapper existingVOCs = VOCUtil_Siding.fetchExistingVOCs(onlineFormId);
                productLineList = existingVOCs.productLineList;
                System.debug('existingVOCs List:::' + existingVOCs);
                
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
    //---------------------------End of Arpit updated code-------------------------------
}