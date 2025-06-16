// ==================================================================================
//   Object: VOCUtil
//  Company: Navivo
//   Author: Mohan Kumar (Threshold)
// Comments: Supporting Class
// ==================================================================================
//  Changes: 2013-11-14 Initial version.
//           2014-05-30 Update the 2 following to the auto-population FiberCement & Roofing 
//                      for Product Line, Product Family & Brand picklist
//           2014-06-9 (Madan) added some logic in  fetchExistingVOCs method for OnlineFormController and ProDialogueInputFormController to access related list which  are used in picklist.
// ==================================================================================

public with sharing class VOCUtil {
    public static Boolean aiuCreateVOCProcessed = false;
	public static Boolean aiuCreateCaseVOCProcessed = false;
    //fetch existing VOC for the respective record
    public static VOCItemWrapper fetchExistingVOCs(String parentId) {
        Integer indexCounter = 0;
        VOCItemWrapper item = new VOCItemWrapper();
        
        //Name - Madan (Jun 6, 2014)
        //Description - added below logic for OnlineFormController and ProDialogueInputFormController to access related list which  are used in picklist.
        //----------------------------------------------------------------------------------------------------------------------
        String parentIdKeyPrefix = parentId.substring(0, 3);
        //get sobject describe properties
        Schema.DescribeSObjectResult proDialogueInputSobject = ProDialogue_Input__c.sObjectType.getDescribe();
        Schema.DescribeSObjectResult onlineFormSobject = Online_Form__c.sObjectType.getDescribe();
        
        String queryStr = 'Select v.What__c, v.WTU_Note__c, v.Topic__c, v.Subject__c, v.Product_Line__c, v.Product_Family__c, v.ProDialogue_Input__c, v.Priority__c, v.OwnerId, v.Online_Form__c, v.Note__c, v.Name, v.Market_Segment__c, v.Market_Family__c, v.Line_of_Business__c, v.Id, v.Category__c, v.Case_Number__c, v.Brand__c, v.Account__c,Competitor_Topic__c From VOC_Data_Entry__c v';
        //query = 'v.Online_Form__c, v.Note__c, v.Name, v.Market_Segment__c, v.Market_Family__c, v.Line_of_Business__c, v.Id, v.Category__c, v.Case_Number__c, v.Brand__c, v.Account__c From VOC_Data_Entry__c v';
        
        String whereCondition = null;
        
        if(parentIdKeyPrefix == proDialogueInputSobject.getKeyPrefix()) whereCondition = ' where ProDialogue_Input__c = ' + '\''+parentId+'\'';
        else if(parentIdKeyPrefix == onlineFormSobject.getKeyPrefix()) whereCondition = ' where Online_Form__c = ' + '\''+parentId+'\'';
        
        String q = queryStr + whereCondition + ' and Category__c = \'Products\'';
        List<VOC_Data_Entry__c> productVOCs = Database.query(q);
        //------------------------------------------------------------------------------------------------------------------------
        
        /*List<VOC_Data_Entry__c> productVOCs = [Select v.What__c, v.WTU_Note__c, v.Topic__c, v.Subject__c, v.Product_Line__c, v.Product_Family__c, 
                                                v.ProDialogue_Input__c, v.Priority__c, v.OwnerId, v.Online_Form__c, v.Note__c, v.Name, v.Market_Segment__c, 
                                                v.Market_Family__c, v.Line_of_Business__c, v.Id, v.Category__c, v.Case_Number__c, v.Brand__c, v.Account__c 
                                                From VOC_Data_Entry__c v Where ProDialogue_Input__c =: parentId and Category__c = 'Products'];*/
        for(VOC_Data_Entry__c voc : productVOCs) {
            VOCLine vLine = new VOCLine();
            vLine.rIndex = indexCounter;
            vLine.vocEntry = voc;
            item.productLineList.add(vLine);
            indexCounter++;
        }
        
        //load Sales voc
        indexCounter = 0;
        /*List<VOC_Data_Entry__c> salesVOCs = [Select v.What__c, v.WTU_Note__c, v.Topic__c, v.Subject__c, v.Product_Line__c, v.Product_Family__c, 
                                                v.ProDialogue_Input__c, v.Priority__c, v.OwnerId, v.Online_Form__c, v.Note__c, v.Name, v.Market_Segment__c, 
                                                v.Market_Family__c, v.Line_of_Business__c, v.Id, v.Category__c, v.Case_Number__c, v.Brand__c, v.Account__c 
                                                From VOC_Data_Entry__c v Where ProDialogue_Input__c =: parentId and Category__c = 'Marketing Supports'];*/
        q = queryStr + whereCondition + ' and Category__c = \'Marketing Supports\'';
        List<VOC_Data_Entry__c> salesVOCs = Database.query(q);
        
        for(VOC_Data_Entry__c voc : salesVOCs) {
            VOCLine vLine = new VOCLine();
            vLine.rIndex = indexCounter;
            vLine.vocEntry = voc;
            item.salesLineList.add(vLine);
            indexCounter++;
        }
        
        //load service voc
        indexCounter = 0;
        /*List<VOC_Data_Entry__c> serviceVOCs = [Select v.What__c, v.WTU_Note__c, v.Topic__c, v.Subject__c, v.Product_Line__c, v.Product_Family__c, 
                                                v.ProDialogue_Input__c, v.Priority__c, v.OwnerId, v.Online_Form__c, v.Note__c, v.Name, v.Market_Segment__c, 
                                                v.Market_Family__c, v.Line_of_Business__c, v.Id, v.Category__c, v.Case_Number__c, v.Brand__c, v.Account__c 
                                                From VOC_Data_Entry__c v Where ProDialogue_Input__c =: parentId and Category__c = 'Marketing Programs'];*/
        q = queryStr + whereCondition + ' and Category__c = \'Marketing Programs\'';
        List<VOC_Data_Entry__c> serviceVOCs = Database.query(q);
        
        for(VOC_Data_Entry__c voc : serviceVOCs) {
            VOCLine vLine = new VOCLine();
            vLine.rIndex = indexCounter;
            vLine.vocEntry = voc;
            item.serviceLineList.add(vLine);
            indexCounter++;
        }
        
        //load other voc
        indexCounter = 0;
        /*List<VOC_Data_Entry__c> otherVOCs = [Select v.What__c, v.WTU_Note__c, v.Topic__c, v.Subject__c, v.Product_Line__c, v.Product_Family__c, 
                                                v.ProDialogue_Input__c, v.Priority__c, v.OwnerId, v.Online_Form__c, v.Note__c, v.Name, v.Market_Segment__c, 
                                                v.Market_Family__c, v.Line_of_Business__c, v.Id, v.Category__c, v.Case_Number__c, v.Brand__c, v.Account__c 
                                                From VOC_Data_Entry__c v Where ProDialogue_Input__c =: parentId and Category__c = 'Miscellaneous'];*/
        q = queryStr + whereCondition + ' and Category__c = \'Miscellaneous\'';
        List<VOC_Data_Entry__c> otherVOCs = Database.query(q);
        
        for(VOC_Data_Entry__c voc : otherVOCs) {
            VOCLine vLine = new VOCLine();
            vLine.rIndex = indexCounter;
            vLine.vocEntry = voc;
            item.otherLineList.add(vLine);
            indexCounter++;
        }
        return item;
    }
    
    public static List<VOCLine> addProductLine(List<VOCLine> vLst, String pLine, String lBusiness, String brand, String mFamily, String mSegment, String notes) {
        System.debug('pLine: '+pLine);
        System.debug('lBusiness: '+lBusiness);
        System.debug('mFamily: '+mFamily);
        System.debug('mSegment: '+mSegment);
        System.debug('notes: '+notes);
        
        VOCLine vLine = new VOCLine();
        vLine.rIndex = vLst.size();
        vLine.vocEntry.Product_Line__c = pLine;
        vLine.vocEntry.Line_of_Business__c = lBusiness;
        vLine.vocEntry.Product_Family__c = lBusiness;
        vLine.vocEntry.Brand__c = brand;
        vLine.vocEntry.Market_Family__c = mFamily;
        vLine.vocEntry.Market_Segment__c = mSegment;
        vLine.vocEntry.Note__c = notes;
        vLine.vocEntry.Category__c = 'Products';
        vLst.add(vLine);
        return vLst;
    }
    
    public static List<VOCLine> addLineItem(List<VOCLine> vLst, String notes, String vocCategory) {
        VOCLine vLine = new VOCLine();
        vLine.rIndex = vLst.size();
        vLine.vocEntry.Note__c = notes;
        vLine.vocEntry.Category__c = vocCategory;
        vLst.add(vLine);
        return vLst;
    }
    
    public static List<VOCLine> removeLineItem(List<VOCLine> vLst, String delIndex) {
        if(delIndex != null && delIndex != '') {
            Id vocId = vLst.get(Integer.valueOf(delIndex)).vocEntry.Id;
            if(vocId != null) delete [Select Id From VOC_Data_Entry__c Where Id =: vocId];
            vLst.remove(Integer.valueOf(delIndex));
            Integer newIndex = 0;
            List<VOCLine> temp = new List<VOCLine>();
            for(VOCLine v : vLst) {
                v.rIndex = newIndex;
                temp.add(v);
                newIndex++;
            }
            vLst = temp;
        }
        return vLst;
    }
    
    public static List<VOCLine> clearLineItems(List<VOCLine> vLst) {
        vLst.clear();
        VOCLine vLine = new VOCLine();
        vLine.rIndex = vLst.size();
        vLst.add(vLine);
        return vLst;
    }
    
    public static List<WTUNote> addVOCLine(List<WTUNote> listWTU, Id wnId, String vocCategory, Integer curIndex) {
        List<VOC_Data_Entry__c> vocList = [Select v.What__c, v.WTU_Note__c, v.Topic__c, v.Product_Line__c, v.Product_Family__c, 
                                            v.ProDialogue_Input__c, v.Priority__c, v.OwnerId, v.Online_Form__c, v.Note__c, 
                                            v.Name, v.Market_Segment__c, v.Market_Family__c, v.Line_of_Business__c, v.Id, 
                                            v.Category__c, v.Brand__c From VOC_Data_Entry__c v Where WTU_Note__c =: wnId and Category__c =: vocCategory];
        Integer newIndex = 0;
        for(VOC_Data_Entry__c v : vocList) {
            VOCLine vLine = new VOCLine();
            vLine.rIndex = newIndex;
            vLine.vocEntry = v;
            if(vocCategory == 'Products') listWTU.get(curIndex).productLineList.add(vLine);
            if(vocCategory == 'Marketing Supports') listWTU.get(curIndex).salesLineList.add(vLine);
            if(vocCategory == 'Marketing Programs') listWTU.get(curIndex).serviceLineList.add(vLine);
            if(vocCategory == 'Miscellaneous') listWTU.get(curIndex).otherLineList.add(vLine);
            newIndex++;
        }
        return listWTU;
    }
    
    public static List<VOC_Data_Entry__c> doAdd(List<VOC_Data_Entry__c> vocInsert, List<VOCLine> vocLst, String vocCategory, String vocType, String relatedId) {
        
        for(VOCLine v : vocLst) {
            System.debug('v: '+ v);
            Boolean addRow = false;
            if(vocCategory == 'Products') {
                if((v.vocEntry.What__c != null && v.vocEntry.What__c != '') || (v.vocEntry.Priority__c != null && v.vocEntry.Priority__c != '') 
                || (v.vocEntry.Topic__c != null && v.vocEntry.Topic__c != '') || (v.vocEntry.Product_Line__c != null && v.vocEntry.Product_Line__c != '') 
                || (v.vocEntry.Product_Family__c != null && v.vocEntry.Product_Family__c != '') || (v.vocEntry.Brand__c != null && v.vocEntry.Brand__c != '') 
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
                v.vocEntry.Category__c = vocCategory;
                if(vocType == 'WTU Note') v.vocEntry.WTU_Note__c = relatedId;
                if(vocType == 'ProDialogue') v.vocEntry.ProDialogue_Input__c = relatedId;
                if(vocType == 'Online') v.vocEntry.Online_Form__c = relatedId;
                if(v.vocEntry.Id == null) v.vocEntry.Created_Date__c = Date.today();
                vocInsert.add(v.vocEntry);
            }
        }
        
        return vocInsert;
    }
    
    
    public static List<VOC_Data_Entry_Temp__c> doTempAdd(List<VOC_Data_Entry_Temp__c> vocTempInsert, List<VOCLine> vocLst, String vocCategory, String vocType, String relatedId){
        for(VOCLine v : vocLst) {
            Boolean addRow = false;
            if(vocCategory == 'Products') {
                if((v.vocEntry.What__c != null && v.vocEntry.What__c != '') || (v.vocEntry.Priority__c != null && v.vocEntry.Priority__c != '') 
                || (v.vocEntry.Topic__c != null && v.vocEntry.Topic__c != '') || (v.vocEntry.Product_Line__c != null && v.vocEntry.Product_Line__c != '') 
                || (v.vocEntry.Product_Family__c != null && v.vocEntry.Product_Family__c != '') || (v.vocEntry.Brand__c != null && v.vocEntry.Brand__c != '') 
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
                VOC_Data_Entry_Temp__c vocTempEntry = new VOC_Data_Entry_Temp__c();
                vocTempEntry.Category__c = vocCategory;
                if(vocType == 'ProDialogue') vocTempEntry.VOC_Input_Temp_Form__c = relatedId;
                if(vocType == 'Online') vocTempEntry.Online_VOC_Temp__c = relatedId;
                
                vocTempEntry.Brand__c = v.vocEntry.Brand__c;
                vocTempEntry.Case_Number__c = v.vocEntry.Case_Number__c;
                vocTempEntry.Category__c = v.vocEntry.Category__c;
                vocTempEntry.Line_of_Business__c = v.vocEntry.Line_of_Business__c;
                vocTempEntry.Market_Family__c = v.vocEntry.Market_Family__c;
                vocTempEntry.Market_Segment__c = v.vocEntry.Market_Segment__c;
                vocTempEntry.Note__c = v.vocEntry.Note__c;
                vocTempEntry.Priority__c = v.vocEntry.Priority__c;
                vocTempEntry.Product_Family__c = v.vocEntry.Product_Family__c;
                vocTempEntry.Product_Line__c = v.vocEntry.Product_Line__c;
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
    
    
    public static VOCItemWrapper fetchExistingVOCsInTemp(List<VOCLine> productLineList,List<VOCLine> salesLineList,List<VOCLine> serviceLineList,List<VOCLine> otherLineList,String parentId) {
        try{
            Integer indexCounter = 0;
            VOCItemWrapper item = new VOCItemWrapper();
            
            String parentIdKeyPrefix = parentId.substring(0, 3);
            //get sobject describe properties
            Schema.DescribeSObjectResult proDialogueInputSobject = VOC_Input_Form_Temp__c.sObjectType.getDescribe();
            Schema.DescribeSObjectResult onlineFormSobject = Online_Form_Temp__c.sObjectType.getDescribe();
            
            String queryStr = 'Select v.Created_Date__c,v.Record_Id__c,v.What__c, v.Topic__c, v.Subject__c, v.Product_Line__c, v.Product_Family__c, v.VOC_Input_Temp_Form__c, v.Priority__c, v.OwnerId, v.Online_VOC_Temp__c, v.Note__c, v.Name, v.Market_Segment__c, v.Market_Family__c, v.Line_of_Business__c, v.Id, v.Category__c, v.Case_Number__c, v.Brand__c From VOC_Data_Entry_Temp__c v ';
            
            String whereCondition = null;
            
            if(parentIdKeyPrefix == proDialogueInputSobject.getKeyPrefix()) whereCondition = ' where VOC_Input_Temp_Form__c = ' + '\''+parentId+'\'';
            else if(parentIdKeyPrefix == onlineFormSobject.getKeyPrefix()){
                 whereCondition = ' where Online_VOC_Temp__c = ' + '\''+parentId+'\'';
            }
            String q = queryStr + whereCondition + ' and Category__c = \'Products\'';
            List<VOC_Data_Entry_Temp__c> productVOCs = Database.query(q);
            VOC_Data_Entry_Temp__c vocTempEntry = new VOC_Data_Entry_Temp__c();
            
            if(productLineList != null) indexCounter = productLineList.size();
            loopVariables(productLineList, productVOCs, indexCounter);
        
            item.productLineList = productLineList;
            
            //load Sales voc for marketting support
            indexCounter = 0;
            q = queryStr + whereCondition + ' and Category__c = \'Marketing Supports\'';
            List<VOC_Data_Entry_Temp__c> salesVOCs = Database.query(q);
            
            if(salesLineList != null) indexCounter = salesLineList.size();
            loopVariables(salesLineList, salesVOCs, indexCounter);
        
            item.salesLineList = salesLineList;
            
            
            //load service voc for service VOC
            indexCounter = 0;
            q = queryStr + whereCondition + ' and Category__c = \'Marketing Programs\'';
            List<VOC_Data_Entry_Temp__c> serviceVOCs = Database.query(q);
            
            
            if(serviceLineList != null) indexCounter = serviceLineList.size();
            loopVariables(serviceLineList, serviceVOCs, indexCounter);
        
            item.serviceLineList = serviceLineList;
            
            
            
            //load other voc for Miscellaneous
            indexCounter = 0;
            q = queryStr + ' where Category__c = \'Miscellaneous\'';
            List<VOC_Data_Entry_Temp__c> otherVOCs = Database.query(q);
            
            
            if(otherLineList != null) indexCounter = otherLineList.size();
            loopVariables(otherLineList, otherVOCs, indexCounter);
        
            item.otherLineList = otherLineList;
            return item;
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in Fetch Temp'));
            return null;
        }
        
    }
    
    
    public static void loopVariables(List<VOCLine> listOfVOC, List<VOC_Data_Entry_Temp__c> productVOCs, Integer indexCounter){
        for(VOC_Data_Entry_Temp__c voc : productVOCs){
                if(voc.Record_Id__c != null){
                    for(VOCLine vocLine : listOfVOC){
                        if(vocLine.vocEntry.Id == voc.Record_Id__c){ 
                            if(vocLine.vocEntry.Brand__c != voc.Brand__c)vocLine.vocEntry.Brand__c = voc.Brand__c;
                            if(vocLine.vocEntry.Case_Number__c != voc.Case_Number__c) vocLine.vocEntry.Case_Number__c = voc.Case_Number__c;
                            if(vocLine.vocEntry.Category__c != voc.Category__c) vocLine.vocEntry.Category__c = voc.Category__c;
                            if(vocLine.vocEntry.Line_of_Business__c != voc.Line_of_Business__c) vocLine.vocEntry.Line_of_Business__c = voc.Line_of_Business__c;
                            if(vocLine.vocEntry.Market_Family__c != voc.Market_Family__c)  vocLine.vocEntry.Market_Family__c = voc.Market_Family__c;
                            if(vocLine.vocEntry.Market_Segment__c != voc.Market_Segment__c) vocLine.vocEntry.Market_Segment__c =  voc.Market_Segment__c;
                            if(vocLine.vocEntry.Note__c != voc.Note__c) vocLine.vocEntry.Note__c = voc.Note__c;
                            if(vocLine.vocEntry.Priority__c != voc.Priority__c) vocLine.vocEntry.Priority__c = voc.Priority__c;
                            if(vocLine.vocEntry.Product_Family__c != voc.Product_Family__c) vocLine.vocEntry.Product_Family__c = voc.Product_Family__c;
                            if(vocLine.vocEntry.Product_Line__c != voc.Product_Line__c) vocLine.vocEntry.Product_Line__c = voc.Product_Line__c;
                            if(vocLine.vocEntry.Subject__c != voc.Subject__c) vocLine.vocEntry.Subject__c = voc.Subject__c;
                            if(vocLine.vocEntry.Topic__c != voc.Topic__c) vocLine.vocEntry.Topic__c = voc.Topic__c;
                            if(vocLine.vocEntry.What__c != voc.What__c) vocLine.vocEntry.What__c = voc.What__c;
                        }
                    }
                } else if(voc.Record_Id__c == null){
                        VOCLine vocLine = new VOCLine();
                        vocLine.vocEntry.Brand__c = voc.Brand__c;
                        vocLine.vocEntry.Case_Number__c = voc.Case_Number__c;
                        vocLine.vocEntry.Category__c = voc.Category__c;
                        vocLine.vocEntry.Line_of_Business__c = voc.Line_of_Business__c;
                        vocLine.vocEntry.Market_Family__c = voc.Market_Family__c;
                        vocLine.vocEntry.Market_Segment__c =  voc.Market_Segment__c;
                        vocLine.vocEntry.Note__c = voc.Note__c;
                        vocLine.vocEntry.Priority__c = voc.Priority__c;
                        vocLine.vocEntry.Product_Family__c = voc.Product_Family__c;
                        vocLine.vocEntry.Product_Line__c = voc.Product_Line__c;
                        vocLine.vocEntry.Subject__c = voc.Subject__c;
                        vocLine.vocEntry.Topic__c = voc.Topic__c;
                        vocLine.vocEntry.Created_Date__c = voc.Created_Date__c;
                        vocLine.vocEntry.What__c = voc.What__c;
                        
                        vocLine.rIndex = indexCounter;
                        listOfVOC.add(vocLine);
                        indexCounter++;
                }
            }
    }
    
    public static Boolean validateVOC(List<VOCLine> vocLst, String vocCategory, String wtuTile) {
        Boolean validationFailed = false;
        for(VOCLine v : vocLst) {
            if(vocCategory == 'Products') {
                if((v.vocEntry.What__c != null && v.vocEntry.What__c != '') || (v.vocEntry.Priority__c != null && v.vocEntry.Priority__c != '') 
                || (v.vocEntry.Topic__c != null && v.vocEntry.Topic__c != '') || (v.vocEntry.Product_Line__c != null && v.vocEntry.Product_Line__c != '') 
                || (v.vocEntry.Product_Family__c != null && v.vocEntry.Product_Family__c != '') || (v.vocEntry.Brand__c != null && v.vocEntry.Brand__c != '') 
                || (v.vocEntry.Market_Family__c != null && v.vocEntry.Market_Family__c != '') || (v.vocEntry.Market_Segment__c != null && v.vocEntry.Market_Segment__c != '') 
                || (v.vocEntry.Note__c != null && v.vocEntry.Note__c != '')) {
                    
                    if(v.vocEntry.Product_Line__c == null || v.vocEntry.Product_Line__c == '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, wtuTile + 'Product Line cannot be blank'));
                        validationFailed = true;
                    }
                    if(v.vocEntry.Product_Family__c == null || v.vocEntry.Product_Family__c == '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, wtuTile + 'Product Family cannot be blank'));
                        validationFailed = true;
                    }
                    if(v.vocEntry.Brand__c == null || v.vocEntry.Brand__c == '') {
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, wtuTile + 'Brand cannot be blank'));
                        validationFailed = true;
                    }
                }
            }
        }
        return validationFailed;
    }
    
    //Identify the associated WTU for the record Owner
    public static Id findWTU(String ownerId) {
        Id wtuId;
        
        // Calculate a range of dates that includes defines this week.
        // Start of week according to SFDC is Sunday; according to CT-SPG, Monday is the start of the week.
        Date monday = system.today().toStartofWeek().addDays(1);
        Date sunday = system.today().addDays(7).toStartOfWeek();
        if(ownerId != null && ownerId != '') {
            // Get a list of existing WTUs for this week for this list of Account owners.
            // There may be none or there may be one for each owner ID.
            list<Weekly_Territory_Update__c> wtuList = 
                [SELECT Id, Name, TM__c FROM Weekly_Territory_Update__c WHERE TM__c =: ownerId AND Week_Ends__c = :sunday limit 1];
            if(wtuList.size() > 0) {
                wtuId = wtuList[0].Id;
            } else {
                Weekly_Territory_Update__c newWtu = new Weekly_Territory_Update__c(TM__c = ownerId, Week_Ends__c = sunday);
                insert newWtu;
                wtuId = newWtu.Id;
            }
        }
        return wtuId;
    }
    
    //get WTU Note record
    public static Id getWTUNoteId(Id wtuId, String wNoteType) {
        Id wNoteId;
        if(wtuId != null) {
            // Now get a list of WTU Notes for these WTUs. If this Note appears on the WTU already,
            // we will update it; otherwise we will insert it.
            list<WTU_Note__c> wtuNoteList = [SELECT Id, Name, Account__c, Note__c, Type__c, WTU__c
                                                FROM WTU_Note__c WHERE WTU__c =: wtuId AND Type__c =: wNoteType];
            if(wtuNoteList.size() > 0) wNoteId = wtuNoteList[0].Id;
        }
        return wNoteId;
    }
    
    //get sobject describe properties
    public static Schema.DescribeSObjectResult accountSobject = Account.sObjectType.getDescribe();
    public static Schema.DescribeSObjectResult contactSobject = Contact.sObjectType.getDescribe();
    public static Schema.DescribeSObjectResult opportunitySobject = Opportunity.sObjectType.getDescribe();
    public static Schema.DescribeSObjectResult leadSobject = Lead.sObjectType.getDescribe();
    public static Schema.DescribeSObjectResult eventSobject = Event.sObjectType.getDescribe();
    public static Schema.DescribeSObjectResult taskSobject = Task.sObjectType.getDescribe();
    
    public static WTU_Note__c copyNotes(String recordId, WTU_Note__c wNote) {
        if(recordId != null) {
            String recordIdKeyPrefix = recordId.substring(0, 3);
            if(recordIdKeyPrefix == accountSobject.getKeyPrefix()) {
                Account a = [Select Id, Name, WTU_Notes__c From Account Where Id =: recordId];
                wNote.Account__c = a.Id;
                wNote.Note__c = a.WTU_Notes__c;
                wNote.Name = a.Name;
                wNote.Type__c = 'Account';
                return wNote;
            }
            if(recordIdKeyPrefix == contactSobject.getKeyPrefix()) {
                Contact c = [Select Id, WTU_Notes__c, FirstName, LastName From Contact Where Id =: recordId];
                wNote.Contact__c = c.Id;
                wNote.Note__c = c.WTU_Notes__c;
                wNote.Name = (c.FirstName == null ? '' : c.FirstName + ' ') + c.LastName;
                wNote.Type__c = 'Contact';
                return wNote;
                
            }
            if(recordIdKeyPrefix == opportunitySobject.getKeyPrefix()) {
                Opportunity o = [Select Id, Account.Short_Name__c, Short_Name__c, CreatedDate, WTU_Notes__c From Opportunity Where Id =: recordId];
                wNote.Project__c = o.Id;
                wNote.Note__c = o.WTU_Notes__c;
                wNote.Name = o.Account.Short_Name__c + '-' + o.Short_Name__c + '-' + o.CreatedDate.format('MMM').toUpperCase() + String.valueOf(o.CreatedDate.year());
                wNote.Type__c = 'Opportunity';
                return wNote;
            }
            if(recordIdKeyPrefix == leadSobject.getKeyPrefix()) {
                Lead l = [Select Id, Company, WTU_Notes__c From Lead Where Id =: recordId];
                wNote.Project__c = l.Id;
                wNote.Note__c = l.WTU_Notes__c;
                wNote.Name = l.Company;
                wNote.Type__c = 'Lead';
                return wNote;
            }
            if(recordIdKeyPrefix == eventSobject.getKeyPrefix()) {
                Event e = [Select Id, Subject, WTU_Notes__c From Event Where Id =: recordId];
                wNote.Project__c = e.Id;
                wNote.Note__c = e.WTU_Notes__c;
                wNote.Name = e.Subject;
                wNote.Subject__c = e.Subject;
                wNote.Type__c = 'Sales Call';
                return wNote;
            }
            if(recordIdKeyPrefix == taskSobject.getKeyPrefix()) {
                Task t = [Select Id, Subject, WTU_Notes__c From Task Where Id =: recordId];
                wNote.Project__c = t.Id;
                wNote.Note__c = t.WTU_Notes__c;
                wNote.Name = t.Subject;
                wNote.Subject__c = t.Subject;
                wNote.Type__c = 'Task';
                return wNote;
            }
            
        }
        return wNote;
    }
    
    public static List<Selectoption> prepareProductFamily(String controllingValue) {
        List<Selectoption> options = new List<Selectoption>();
        options.add(new Selectoption('', '--None--'));
        if(controllingValue == 'Deck') options.add(new Selectoption('Deck', 'Deck'));
        else if(controllingValue == 'Fence') options.add(new Selectoption('Fence', 'Fence'));
        else if(controllingValue == 'FiberCement') options.add(new Selectoption('FiberCement', 'FiberCement'));
        else if(controllingValue == 'Housewrap') options.add(new Selectoption('Housewrap', 'Housewrap'));
        else if(controllingValue == 'Other Material/Category') options.add(new Selectoption('Other Material/Category', 'Other Material/Category'));
        else if(controllingValue == 'PVC Trim') options.add(new Selectoption('PVC Trim', 'PVC Trim'));
        else if(controllingValue == 'Rail') options.add(new Selectoption('Rail', 'Rail'));
        else if(controllingValue == 'Polymer Shakes') options.add(new Selectoption('Panel - Polymer', 'Panel - Polymer'));
        else if(controllingValue == 'Vinyl Siding') { options.add(new Selectoption('Panel', 'Panel')); options.add(new Selectoption('Soffit', 'Soffit')); options.add(new Selectoption('Accessory', 'Accessory')); }
        else if(controllingValue == 'Roofing') options.add(new Selectoption('Roofing', 'Roofing'));
        return options;
        
    }
    
    public static List<Selectoption> prepareBrand(String controllingValue) {
        List<Selectoption> options = new List<Selectoption>();
        options.add(new Selectoption('', '--None--'));
        if(controllingValue == 'Panel') { options.add(new Selectoption('CertainTeed/Wolverine brand - Vinyl Panel', 'CertainTeed/Wolverine brand - Vinyl Panel')); options.add(new Selectoption('Norandex brand - Vinyl Panel', 'Norandex brand - Vinyl Panel')); options.add(new Selectoption('Vytec brand - Vinyl Panel', 'Vytec brand - Vinyl Panel')); }
        else if(controllingValue == 'Soffit') { options.add(new Selectoption('CertainTeed/Wolverine brand - Vinyl Soffit', 'CertainTeed/Wolverine brand - Vinyl Soffit')); options.add(new Selectoption('Norandex brand - Vinyl Soffit', 'Norandex brand - Vinyl Soffit')); options.add(new Selectoption('Vytec brand - Vinyl Soffit', 'Vytec brand - Vinyl Soffit')); }
        else if(controllingValue == 'Accessory') { options.add(new Selectoption('CertainTeed/Wolverine brand - Vinyl Accessory', 'CertainTeed/Wolverine brand - Vinyl Accessory')); options.add(new Selectoption('Norandex brand - Vinyl Accessory', 'Norandex brand - Vinyl Accessory')); options.add(new Selectoption('Vytec brand - Vinyl Accessory', 'Vytec brand - Vinyl Accessory')); }
        else if(controllingValue == 'Deck') options.add(new Selectoption('Deck', 'Deck'));
        else if(controllingValue == 'Rail') options.add(new Selectoption('Rail', 'Rail'));
        else if(controllingValue == 'Housewrap') options.add(new Selectoption('Housewrap', 'Housewrap'));
        else if(controllingValue == 'Other Material/Category') options.add(new Selectoption('Other Material/Category', 'Other Material/Category'));
        else if(controllingValue == 'Fence') options.add(new Selectoption('Bufftech', 'Bufftech')); 
        else if(controllingValue == 'PVC Trim') { options.add(new Selectoption('Restoration Milwork', 'Restoration Milwork')); options.add(new Selectoption('CertaTrim', 'CertaTrim')); }
        else if(controllingValue == 'Panel - Polymer') { options.add(new Selectoption('CertainTeed/Wolverine Brand - Polymer', 'CertainTeed/Wolverine Brand - Polymer')); options.add(new Selectoption('Norandex Brand - Polymer', 'Norandex Brand - Polymer')); options.add(new Selectoption('Vytec Brand - Polymer', 'Vytec Brand - Polymer')); }
        else if(controllingValue == 'FiberCement') options.add(new Selectoption('FiberCement', 'FiberCement'));
        else if(controllingValue == 'Roofing') options.add(new Selectoption('Roofing', 'Roofing'));
        //else if(controllingValue == '') options.add(new Selectoption('', ''));
        
        return options;
    }
    
    public static List<Selectoption> prepareMarketFamily(String controllingValue) {
        List<Selectoption> options = new List<Selectoption>();
        options.add(new Selectoption('', '--None--'));
        //if(controllingValue == 'Bufftech' || controllingValue == 'CertainTeed Selects') {
        if(controllingValue == 'Bufftech' ) {
            options.add(new Selectoption('Classic', 'Classic')); options.add(new Selectoption('Contemporary', 'Contemporary')); options.add(new Selectoption('Garden', 'Garden')); options.add(new Selectoption('Gates', 'Gates'));
            options.add(new Selectoption('Hardware-Accessories', 'Hardware-Accessories')); options.add(new Selectoption('Post & Rail', 'Post & Rail'));
            options.add(new Selectoption('Privacy', 'Privacy')); options.add(new Selectoption('Semi- Private', 'Semi- Private')); options.add(new Selectoption('Traditional', 'Traditional'));
        }
        else if(controllingValue == 'WeatherBoards') { 
            options.add(new Selectoption('FC Accessories', 'FC Accessories')); options.add(new Selectoption('FC Laps', 'FC Laps')); options.add(new Selectoption('FC Shakes', 'FC Shakes'));
            options.add(new Selectoption('FC Soffit', 'FC Soffit')); options.add(new Selectoption('FC Trim', 'FC Trim')); options.add(new Selectoption('FC UL BB', 'FC UL BB')); options.add(new Selectoption('FC Vertical Siding', 'FC Vertical Siding'));
        }
        else if(controllingValue == 'Restoration Milwork' || controllingValue == 'CertaTrim') { 
            options.add(new Selectoption('Accessories', 'Accessories')); options.add(new Selectoption('Beadboard', 'Beadboard')); options.add(new Selectoption('Column', 'Column'));
            options.add(new Selectoption('Corners', 'Corners')); options.add(new Selectoption('Sheets', 'Sheets')); options.add(new Selectoption('Specialty', 'Specialty')); options.add(new Selectoption('Trim Board', 'Trim Board'));
        }
        else if(controllingValue == 'CertainTeed/Wolverine Brand - Polymer') options.add(new Selectoption('Cedar Impressions', 'Cedar Impressions'));
        else if(controllingValue == 'Norandex Brand - Polymer' || controllingValue == 'Vytec Brand - Polymer') { options.add(new Selectoption('Scallops', 'Scallops')); options.add(new Selectoption('Shakes', 'Shakes')); }
        else if(controllingValue == 'Deck') { options.add(new Selectoption('EverNew LT', 'EverNew LT')); options.add(new Selectoption('EverNew PT', 'EverNew PT')); options.add(new Selectoption('EverNew Vinyl', 'EverNew Vinyl')); options.add(new Selectoption('UnderShield', 'UnderShield')); }
        else if(controllingValue == 'Rail') {
            options.add(new Selectoption('Accessories', 'Accessories')); options.add(new Selectoption('Hand Rail', 'Hand Rail')); options.add(new Selectoption('Kingston', 'Kingston'));
            options.add(new Selectoption('Oxford', 'Oxford')); options.add(new Selectoption('Panorama', 'Panorama')); options.add(new Selectoption('Porch Products –Posts & Columns', 'Porch Products –Posts & Columns'));
        }
        else if(controllingValue == 'Housewrap') { options.add(new Selectoption('Housewrap', 'Housewrap')); options.add(new Selectoption('Housewrap Accessories', 'Housewrap Accessories')); }
        else if(controllingValue == 'Other Material/Category') {
            options.add(new Selectoption('Brick', 'Brick')); options.add(new Selectoption('Next Gen Siding', 'Next Gen Siding')); options.add(new Selectoption('Other', 'Other'));
            options.add(new Selectoption('Stone', 'Stone')); options.add(new Selectoption('Stucco', 'Stucco'));
        }
        if(controllingValue == 'CertainTeed/Wolverine brand - Vinyl Panel') {
            options.add(new Selectoption('American Legend', 'American Legend')); options.add(new Selectoption('Beaded', 'Beaded'));
            options.add(new Selectoption('Board & Batten', 'Board & Batten')); options.add(new Selectoption('Carolina Beaded', 'Carolina Beaded'));
            options.add(new Selectoption('CedarBoards', 'CedarBoards')); options.add(new Selectoption('Chamfer Board', 'Chamfer Board'));
            options.add(new Selectoption('Encore', 'Encore')); options.add(new Selectoption('Hamilton Park', 'Hamilton Park'));
            options.add(new Selectoption('Mainstreet', 'Mainstreet')); options.add(new Selectoption('Millennium', 'Millennium'));
            options.add(new Selectoption('Monogram', 'Monogram')); options.add(new Selectoption('Newtown', 'Newtown'));
            options.add(new Selectoption('Northwoods', 'Northwoods')); options.add(new Selectoption('Restoration Classic', 'Restoration Classic'));
        }
        if(controllingValue == 'Norandex brand - Vinyl Panel') {
            options.add(new Selectoption('Bd & Batten', 'Bd & Batten')); options.add(new Selectoption('Bd Porch panel', 'Bd Porch panel'));
            options.add(new Selectoption('Cam Beaded', 'Cam Beaded')); options.add(new Selectoption('Ced Reflections', 'Ced Reflections'));
            options.add(new Selectoption('Gr Barrier', 'Gr Barrier')); options.add(new Selectoption('Polar Wall', 'Polar Wall'));
            options.add(new Selectoption('Rustic Blend', 'Rustic Blend')); options.add(new Selectoption('Sagebrush', 'Sagebrush'));
            options.add(new Selectoption('Shakes', 'Shakes')); options.add(new Selectoption('Shenandoah', 'Shenandoah'));
            options.add(new Selectoption('Sterling', 'Sterling')); options.add(new Selectoption('Summit Manor', 'Summit Manor'));
            options.add(new Selectoption('Woodsman Select', 'Woodsman Select'));
        }
        if(controllingValue == 'Vytec brand - Vinyl Panel') {
            options.add(new Selectoption('Bd & Batten', 'Bd & Batten')); options.add(new Selectoption('Bd Porch panel', 'Bd Porch panel'));
            options.add(new Selectoption('Eminence', 'Eminence')); options.add(new Selectoption('Full Bead', 'Full Bead'));
            options.add(new Selectoption('Nantucket', 'Nantucket')); options.add(new Selectoption('Prestige II', 'Prestige II'));
            options.add(new Selectoption('Proside LG', 'Proside LG')); options.add(new Selectoption('Scallops', 'Scallops'));
            options.add(new Selectoption('Shakes', 'Shakes')); options.add(new Selectoption('Yukon Board', 'Yukon Board'));
        }
        if(controllingValue == 'CertainTeed/Wolverine brand - Vinyl Soffit') {}
        if(controllingValue == 'Norandex brand - Vinyl Soffit') {}
        if(controllingValue == 'Vytec brand - Vinyl Soffit') {}
        
        if(controllingValue == 'CertainTeed/Wolverine brand - Vinyl Accessory' || controllingValue == 'Norandex brand - Vinyl Accessory' || controllingValue == 'Vytec brand - Vinyl Accessory') {
            options.add(new Selectoption('Alum.Trim Coil-PVC Coated', 'Alum.Trim Coil-PVC Coated')); options.add(new Selectoption('Cedar Impressions Accessories', 'Cedar Impressions Accessories'));
            options.add(new Selectoption('Corner Insert', 'Corner Insert')); options.add(new Selectoption('Corner Lineals', 'Corner Lineals'));
            options.add(new Selectoption('Cornerposts', 'Cornerposts')); options.add(new Selectoption('Cove Trim', 'Cove Trim'));
            options.add(new Selectoption('Crown Molding', 'Crown Molding')); options.add(new Selectoption('Drip Cap', 'Drip Cap'));
            options.add(new Selectoption('Fascia', 'Fascia')); options.add(new Selectoption('F Channel', 'F Channel'));
            options.add(new Selectoption('Finish Board', 'Finish Board')); options.add(new Selectoption('Flexible J Channel', 'Flexible J Channel'));
            options.add(new Selectoption('H Divider Bar', 'H Divider Bar'));
            options.add(new Selectoption('Insulated Band Board', 'Insulated Band Board')); options.add(new Selectoption('J Channel', 'J Channel'));
            options.add(new Selectoption('Soffit Molding', 'Soffit Molding')); options.add(new Selectoption('Soffit Receiver', 'Soffit Receiver'));
            options.add(new Selectoption('Starter Strip', 'Starter Strip')); options.add(new Selectoption('Undersill Trim', 'Undersill Trim'));
            options.add(new Selectoption('Window and Door Casing', 'Window and Door Casing')); 
        }
        return options;
        
    }
    
    public static List<Selectoption> prepareMarketSegment(String controllingValue) {
        List<Selectoption> options = new List<Selectoption>();
        options.add(new Selectoption('', '--None--'));
        if(controllingValue == 'Encore' || controllingValue == 'Hamilton Park' 
            || controllingValue == 'Nantucket' || controllingValue == 'Summit Manor') options.add(new Selectoption('Economy', 'Economy'));
        if(controllingValue == 'Board & Batten' || controllingValue == 'Cam Beaded' || controllingValue == 'Carolina Beaded'
            || controllingValue == 'CedarBoards' || controllingValue == 'Ced Reflections'
            || controllingValue == 'Chamfer Board' || controllingValue ==  'Eminence'
            || controllingValue == 'Full Bead' || controllingValue == 'Gr Barrier'
            || controllingValue == 'Monogram' || controllingValue == 'Millennium'
            || controllingValue == 'Polar Wall' || controllingValue == 'Prestige II'
            || controllingValue == 'Restoration Classic' || controllingValue == 'Rustic Blend'
            || controllingValue == 'Sagebrush' || controllingValue == 'Shenandoah'
            || controllingValue == 'Sterling' || controllingValue == 'Yukon Board') options.add(new Selectoption('Premium', 'Premium'));
        if(controllingValue == 'Accessories' || controllingValue == 'Mainstreet'
            || controllingValue == 'Proside LG' || controllingValue == 'Woodsman Select') options.add(new Selectoption('Standard', 'Standard'));
        if(controllingValue == 'Cedar Impressions' || controllingValue == 'Northwoods'
            || controllingValue == 'Scallops' || controllingValue == 'Shakes') options.add(new Selectoption('Super Premium', 'Super Premium'));
        return options;
        
    }
    
    public class VOCItemWrapper {
        public List<VOCLine> productLineList {get;set;}
        public List<VOCLine> salesLineList {get;set;}
        public List<VOCLine> serviceLineList {get;set;}
        public List<VOCLine> otherLineList {get;set;}
        
        public VOCItemWrapper() {
            productLineList = new List<VOCLine>();
            salesLineList = new List<VOCLine>();
            serviceLineList = new List<VOCLine>();
            otherLineList = new List<VOCLine>();
        }
    }
}