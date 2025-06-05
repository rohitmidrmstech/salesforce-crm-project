// ==================================================================================
//  Name: ProDialogueInputFormControllerLex
//  Company: Appirio
//  Author: Nishant Singh Panwar (Offshore)
// Comments: VOC Form controller for lightning component
// ==================================================================================
//  Changes: 2018-01-28 Initial version.
// ==================================================================================
public with sharing class ProDialogueInputFormControllerLex{
    @AuraEnabled public static ProDialogue_Input__c initVoc() { 
        ProDialogue_Input__c p = new ProDialogue_Input__c(Meeting_Date__c=system.today());
        return p;
    }
    @AuraEnabled public static List<VOC_Data_Entry__c> getVocData(ProDialogue_Input__c voc) { 
        List<VOC_Data_Entry__c> dataEntryList = new List<VOC_Data_Entry__c>();
        if(voc.Id!=null){
            
        }
        else{
            VOC_Data_Entry__c vocEntry = new VOC_Data_Entry__c();
            dataEntryList.add(vocEntry);
        }
        return dataEntryList;
    }
    @AuraEnabled public static ProDialogue_Input__c getVocRecord(string recId) { 
        if(recId != NULL){
            ProDialogue_Input__c p = [SELECT Active__c,Additional_Info_Source__c,Audience__c,City_State__c,
                                      Country__c,Facilitator__c,Id,Information_Source__c,Market_Segment__c,
                                      Meeting_Date__c,Name,No1_of_Attendees__c,Notes__c,No_of_Attendees__c,
                                      Other_Participants__c,OwnerId,Region__c,Sales_Role__c,Segment_Type__c,
                                      TM__c,Weekly_Report__c,
                                      (SELECT Role__c, ProDialogue_Input__c, Name, Account__c, Lead__c, Id, Contact__c 
                                      From ProDialogue_Input_Attendees__r),
                                      (Select Brand__c,Sub_Brand__c, WTU_Note__c, Competitor_Topic__c, Topic__c, Insight__c,
                                       Subject__c, Product_Line__c, Priority__c, OwnerId, Online_Form__c, 
                                       Note__c, Name, Market_Segment__c, Market_Family__c, Line_of_Business__c, Id, Category__c,
                                       Case_Number__c, Account__c From VOC__r) 
                                      FROM ProDialogue_Input__c WHERE id=: recId];
            return p;
        }
        else{
            return NULL;
        }
    }
    @AuraEnabled public static List<ProDialogue_Input_Attendee__c> getattendees(string proDialogueId) { 
        if(proDialogueId != NULL){
            List<ProDialogue_Input_Attendee__c> proAttendees = [Select p.Role__c, p.ProDialogue_Input__c, p.Name, p.Account__c, p.Lead__c, p.Id, p.Contact__c 
                                                                    From ProDialogue_Input_Attendee__c p Where ProDialogue_Input__c =: proDialogueId];
            return proAttendees;
        }
        else{
            return NULL;
        }
    }

 @AuraEnabled
 public static List < String > getselectOptions(sObject objObject, string fld) {
     
         List < String > allOpts = new list < String > ();
         // Get the object type of the SObject.
         Schema.sObjectType objType = objObject.getSObjectType();
         
         // Describe the SObject using its object type.
         Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
         
         // Get a map of fields for the SObject
         map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
         
         // Get the list of picklist values for this field.
         list < Schema.PicklistEntry > values =
             fieldMap.get(fld).getDescribe().getPickListValues();
         
         // Add these values to the selectoption list.
         for (Schema.PicklistEntry a: values) {
             allOpts.add(a.getValue());
         }
         system.debug('allOpts ---->' + allOpts);
         allOpts.sort();
         return allOpts;
     }
    @AuraEnabled public static Map<String,List<sobject>> getTempData(string proDialogueId){
        Map<String,List<sobject>> responseMap = new Map<String,List<sobject>>();
        
        List<ProDialogue_Input__c> proDialogueList = new List<ProDialogue_Input__c>();
            List<VOC_Data_Entry__c> voc = new List<VOC_Data_Entry__c>();
            List<ProDialogue_Input_Attendee__c> vocAttendees = new List<ProDialogue_Input_Attendee__c>();
        
            List<VOC_Data_Entry_Temp__c> vocTemp = new List<VOC_Data_Entry_Temp__c>();
            List<VOC_Input_Temp_Form_Attendee__c> vocAttendeesTemp = new List<VOC_Input_Temp_Form_Attendee__c>();
            
            VOC_Input_Form_Temp__c vocInputFormTemp = new VOC_Input_Form_Temp__c();
            String vocInputFromTempId;
            
            String vocInputFromTempQuery = 'Select Weekly_Report__c, Facilitator__r.Name,Market_Segment__c, Sales_Role__c, Segment_Type__c,';
            vocInputFromTempQuery +='Country__c, TM__r.Name, User_Id__c, TM__c, Region__c, Record_Id__c, OwnerId, Other_Participants__c, Notes__c, No_of_Attendees__c,';
            vocInputFromTempQuery +=' No1_of_Attendees__c, Name, Meeting_Date__c, Information_Source__c,Additional_Info_Source__c, Id, Facilitator__c, City_State__c, Audience__c,Active__c, ';
            vocInputFromTempQuery +='(SELECT Role__c, Name, Account__c, Lead__c, Id, Contact__c From VOC_Input_Temp_Form_Attendee__r),';
            vocInputFromTempQuery +='(Select Brand__c,Sub_Brand__c, Competitor_Topic__c, Topic__c, Insight__c, Subject__c, Product_Line__c, Priority__c,';
            vocInputFromTempQuery +=' Note__c, Name, Market_Segment__c, Market_Family__c, Line_of_Business__c, Id, Category__c From VOC_Temp__r)';
            vocInputFromTempQuery +='From VOC_Input_Form_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
            if(proDialogueId != null && proDialogueId != '') {
                vocInputFromTempQuery += ' and Record_Id__c = ' +'\''+ proDialogueId+'\'';
            }
            else if(proDialogueId == null) {
                vocInputFromTempQuery += ' and Record_Id__c = null';
            }
            
            List<VOC_Input_Form_Temp__c> lstvocInputFormTemp = Database.query(vocInputFromTempQuery);
            System.debug('lstvocInputFormTemp:::::'+lstvocInputFormTemp);
            if(lstvocInputFormTemp.size() > 0){
                vocInputFormTemp = lstvocInputFormTemp[0];
            } else vocInputFormTemp = null;
            System.debug('vocInputFormTemp:::::'+vocInputFormTemp);
            
            if(vocInputFormTemp != null){
                ProDialogue_Input__c proDialogue = new ProDialogue_Input__c();
                
                vocInputFromTempId = String.valueOf(vocInputFormTemp.Id); 
                
                //copying value from temp DB to page
                proDialogue.Meeting_Date__c = vocInputFormTemp.Meeting_Date__c;
                proDialogue.City_State__c = vocInputFormTemp.City_State__c;
                
                proDialogue.Market_Segment__c = vocInputFormTemp.Market_Segment__c;
                proDialogue.Sales_Role__c = vocInputFormTemp.Sales_Role__c;
                proDialogue.Segment_Type__c = vocInputFormTemp.Segment_Type__c;
                proDialogue.Country__c = vocInputFormTemp.Country__c;
                
                proDialogue.Information_Source__c = vocInputFormTemp.Information_Source__c;
                proDialogue.Additional_Info_Source__c = vocInputFormTemp.Additional_Info_Source__c;
                proDialogue.Region__c = vocInputFormTemp.Region__c;
                proDialogue.Audience__c = vocInputFormTemp.Audience__c;
                proDialogue.No_of_Attendees__c = vocInputFormTemp.No_of_Attendees__c;
                proDialogue.Other_Participants__c = vocInputFormTemp.Other_Participants__c;
                proDialogue.Notes__c = vocInputFormTemp.Notes__c;
                proDialogue.Active__c = vocInputFormTemp.Active__c;
                proDialogue.Weekly_Report__c = vocInputFormTemp.Weekly_Report__c;
                
                for(VOC_Input_Temp_Form_Attendee__c attTemp: vocInputFormTemp.VOC_Input_Temp_Form_Attendee__r){
                    ProDialogue_Input_Attendee__c vocAtt = new ProDialogue_Input_Attendee__c();
                    vocAtt.Role__c = attTemp.Role__c;
                    vocAtt.Account__c = attTemp.Account__c;
                    vocAtt.Lead__c = attTemp.Lead__c;
                    vocAtt.Contact__c = attTemp.Contact__c;
                    vocAttendees.add(vocAtt);
                }
                for(VOC_Data_Entry_Temp__c dataTemp : vocInputFormTemp.VOC_Temp__r){
                    VOC_Data_Entry__c data = new VOC_Data_Entry__c();
                    data.Brand__c = dataTemp.Brand__c;
                    data.Sub_Brand__c = dataTemp.Sub_Brand__c;
                    data.Competitor_Topic__c = dataTemp.Competitor_Topic__c;
                    data.Topic__c = dataTemp.Topic__c;
                    data.Insight__c = dataTemp.Insight__c;
                    data.Note__c = dataTemp.Note__c;
                    data.Category__c = dataTemp.Category__c;
                    voc.add(data);
                }
                proDialogueList.add(proDialogue);
                responseMap.put('vocInfo',proDialogueList);
                if(voc.size()>0){
                    responseMap.put('voc',voc);
                }
                if(vocAttendees.size()>0){
                    responseMap.put('vocAttendees',vocAttendees);
                }
                
            }
        return responseMap;
    }
    
    @AuraEnabled
    public static Map<String, List<String>> getDependentOptionsImpl(String objApiName, String contrfieldApiName, String depfieldApiName)
    {
        Map<String, List<String>> mapofValues = new Map<String, List<String>>();

        List<Controlling_Option__mdt> cOpList = new List<Controlling_Option__mdt>([Select MasterLabel, Controlling_Field__c, Object_Name__c, Dependent_Field__c, (Select MasterLabel, Controlling_Value__c FROM Dependent_Values__r) FROM Controlling_Option__mdt WHERE Object_Name__c=:objApiName AND Controlling_Field__c=:contrfieldApiName AND Dependent_Field__c=:depfieldApiName LIMIT 1]);
        system.debug('data ::'+cOpList);
        if(!cOpList.isEmpty()){
            for(Dependent_Value__mdt option : cOpList[0].Dependent_Values__r){
                if(mapofValues.containsKey(option.Controlling_Value__c)){
                    List<String> depValues = mapofValues.get(option.Controlling_Value__c);
                    depValues.add(option.MasterLabel);
                    mapofValues.put(option.Controlling_Value__c,depValues);
                }
                else{
                    List<String> depValues = new List<String>();
                    depValues.add(option.MasterLabel);
                    mapofValues.put(option.Controlling_Value__c,depValues);
                }
            }
        }
        return mapofValues;
    }

    @AuraEnabled
    public static void clearTempData (string proDialogueId){
        String vocInputFromTempQuery = 'Select id,';
            vocInputFromTempQuery +='(SELECT id From VOC_Input_Temp_Form_Attendee__r),';
            vocInputFromTempQuery +='(Select id From VOC_Temp__r)';
            vocInputFromTempQuery +='From VOC_Input_Form_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
            /*if(proDialogueId != null && proDialogueId != '') {
                vocInputFromTempQuery += ' and Record_Id__c = ' +'\''+ proDialogueId+'\'';
            }
            else if(proDialogueId == null) {
                vocInputFromTempQuery += ' and Record_Id__c = null';
            }*/
        List<VOC_Input_Form_Temp__c> lstvocInputFormTemp = Database.query(vocInputFromTempQuery);
        List<VOC_Data_Entry_Temp__c> listVocTemp = new List<VOC_Data_Entry_Temp__c>();

            for(VOC_Input_Form_Temp__c tempRec : lstvocInputFormTemp){
                if(tempRec.VOC_Temp__r.size()>0){
                    listVocTemp.addAll(tempRec.VOC_Temp__r);
                }
            }
            delete listVocTemp;
            delete lstvocInputFormTemp;

    }
    @AuraEnabled
    public static Map<String,String> upsertVocTemp(ProDialogue_Input__c voc, List<ProDialogue_Input_Attendee__c> inputAttendee, List<VOC_Data_Entry__c> vocData){
        Map<String,String> resultMap = new Map<String,String>();
        String errorMessaage = '';
        String proDialogueId = voc.id;
        String vocInputFromTempQuery = 'Select id,';
            vocInputFromTempQuery +='(SELECT id From VOC_Input_Temp_Form_Attendee__r),';
            vocInputFromTempQuery +='(Select id From VOC_Temp__r)';
            vocInputFromTempQuery +='From VOC_Input_Form_Temp__c where User_Id__c = '+'\''+UserInfo.getUserId()+'\'';
            if(proDialogueId != null && proDialogueId != '') {
                vocInputFromTempQuery += ' and Record_Id__c = ' +'\''+ proDialogueId+'\'';
            }
            else if(proDialogueId == null) {
                vocInputFromTempQuery += ' and Record_Id__c = null';
            }
        List<VOC_Input_Form_Temp__c> lstvocInputFormTemp = Database.query(vocInputFromTempQuery);
        
        VOC_Input_Form_Temp__c tempRec = new VOC_Input_Form_Temp__c();
        List<VOC_Input_Temp_Form_Attendee__c> inputAttendeeInsert = new List<VOC_Input_Temp_Form_Attendee__c>();
        List<VOC_Data_Entry_Temp__c> vocDataInsert = new List<VOC_Data_Entry_Temp__c>();
        
        Savepoint sp = Database.setSavepoint();
        try{  
        
            if(lstvocInputFormTemp.size()>0){
                tempRec = lstvocInputFormTemp[0];
                //clear old Data
                delete tempRec.VOC_Input_Temp_Form_Attendee__r;
                delete tempRec.VOC_Temp__r;
            }
            //Map temp data
            tempRec.Meeting_Date__c = voc.Meeting_Date__c;
            tempRec.City_State__c = voc.City_State__c;
            
            tempRec.Market_Segment__c = voc.Market_Segment__c;
            tempRec.Sales_Role__c = voc.Sales_Role__c;
            tempRec.Segment_Type__c = voc.Segment_Type__c;
            tempRec.Country__c = voc.Country__c;
            
            tempRec.Information_Source__c = voc.Information_Source__c;
            tempRec.Additional_Info_Source__c = voc.Additional_Info_Source__c;
            tempRec.Region__c = voc.Region__c;
            tempRec.Audience__c = voc.Audience__c;
            tempRec.No_of_Attendees__c = voc.No_of_Attendees__c;
            tempRec.Other_Participants__c = voc.Other_Participants__c;
            tempRec.Notes__c = voc.Notes__c;
            tempRec.Active__c = voc.Active__c;
            tempRec.Weekly_Report__c = voc.Weekly_Report__c;
            tempRec.User_Id__c = UserInfo.getUserId();
            tempRec.Record_Id__c = proDialogueId;
            
            upsert(tempRec);
            
            for(ProDialogue_Input_Attendee__c att: inputAttendee){
                VOC_Input_Temp_Form_Attendee__c attTemp = new VOC_Input_Temp_Form_Attendee__c();
                attTemp.Role__c = att.Role__c;
                attTemp.Account__c = att.Account__c;
                attTemp.Lead__c = att.Lead__c;
                attTemp.Contact__c = att.Contact__c;
                attTemp.VOC_Input_Temp_Form__c = tempRec.Id;
                inputAttendeeInsert.add(attTemp);
            }
            for(VOC_Data_Entry__c data: vocData){
                VOC_Data_Entry_Temp__c dataTemp = new VOC_Data_Entry_Temp__c();
                dataTemp.Brand__c = data.Brand__c;
                dataTemp.Sub_Brand__c = data.Sub_Brand__c;
                dataTemp.Competitor_Topic__c = data.Competitor_Topic__c;
                dataTemp.Topic__c = data.Topic__c;
                dataTemp.Insight__c = data.Insight__c;
                dataTemp.Note__c = data.Note__c;
                dataTemp.Category__c = data.Category__c;
                dataTemp.VOC_Input_Temp_Form__c = tempRec.Id;
                vocDataInsert.add(dataTemp);
            }
            if(inputAttendeeInsert.size()>0){
                insert inputAttendeeInsert;
            }
            if(vocDataInsert.size()>0){
                insert vocDataInsert;
            }
            
            resultMap.put('isSuccess','true');
            
        }
        catch (exception e){
            Database.rollback(sp);
            resultMap.put('isSuccess','false');
            resultMap.put('error',e.getMessage());
            resultMap.put('line',String.valueOf(e.getLineNumber()));
            resultMap.put('stackTrace',e.getStackTraceString());
            resultMap.put('type',e.getTypeName());
            
        }
        return resultMap;
    }
    @AuraEnabled
    public static Map<String,String> upsertVoc(ProDialogue_Input__c voc, List<ProDialogue_Input_Attendee__c> inputAttendee, List<VOC_Data_Entry__c> vocData){
        Map<String,String> resultMap = new Map<String,String>();
        String errorMessaage = '';
        
        List<ProDialogue_Input_Attendee__c> inputAttendeeInsert = new List<ProDialogue_Input_Attendee__c>();
        List<ProDialogue_Input_Attendee__c> inputAttendeeUpdate = new List<ProDialogue_Input_Attendee__c>();  
        
        List<VOC_Data_Entry__c> vocDataInsert = new List<VOC_Data_Entry__c>();
        List<VOC_Data_Entry__c> vocDataUpdate = new List<VOC_Data_Entry__c>();  
            
        Savepoint sp = Database.setSavepoint();
        try{
            upsert(voc);
            for(ProDialogue_Input_Attendee__c att: inputAttendee){
                if(att.ProDialogue_Input__c==NULL){
                    att.ProDialogue_Input__c = voc.id;
                }
                if(att.id!=null){
                    inputAttendeeUpdate.add(att);
                }
                else{
                    if(att.Account__c!=null || att.Contact__c!=null || att.Lead__c!=null){
                        inputAttendeeInsert.add(att);
                    }
                }
            }
            system.debug('attendees'+inputAttendee);
            
            if(inputAttendeeInsert.size()>0)
                insert(inputAttendeeInsert);
            if(inputAttendeeUpdate.size()>0)
                update(inputAttendeeUpdate);
            
            for(VOC_Data_Entry__c vocLine : vocData){
                if(vocLine.proDialogue_Input__c== NULL){
                    vocLine.proDialogue_Input__c = voc.id;
                }
                if(vocLine.id!=null){
                    vocDataUpdate.add(vocLine);
                }
                else{
                    if(vocLine.Topic__c!=null){
                        vocDataInsert.add(vocLine);   
                    }
                }
            }
            if(vocDataInsert.size()>0)
                insert(vocDataInsert);
            if(vocDataUpdate.size()>0)
                update(vocDataUpdate);
            
            //Clear Temporary Data
            clearTempData(voc.Id);
            
            //Task Creation
            Database.SaveResult result = createTask(voc);
            if(result.isSuccess()){
                resultMap.put('isSuccess','true');
                resultMap.put('vocId',String.valueOf(voc.id));
            }
            else{
                Database.rollback(sp);
                resultMap.put('isSuccess','false');
                List<Database.Error> errors = result.getErrors();
                String message = '';
                for(Database.Error e : errors){
                    message = message + e.getMessage() + ' ';
                }
                resultMap.put('error',message);
            }
        }
        catch (exception e){
            Database.rollback(sp);
            resultMap.put('isSuccess','false');
            resultMap.put('error',e.getMessage());
            resultMap.put('line',String.valueOf(e.getLineNumber()));
            resultMap.put('stackTrace',e.getStackTraceString());
            resultMap.put('type',e.getTypeName());
            
        }
        return resultMap;
    }
    
    private static Database.SaveResult createTask(ProDialogue_Input__c proDialogue){
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
        Database.SaveResult res = Database.insert(taskObject) ;  
       
        return res;
    }
    @AuraEnabled
    public static Account getAccount(id accId){
        List<Account> acc = [Select Id, Name from Account where id=:accId];
        if(acc.size()>0){
            return acc[0];
        }
        else{
            return NULL;
        }
    }
    @AuraEnabled
    public static Contact getContact(id contId){
        List<Contact> con = [Select Id, Name from Contact where id=:contId];
        if(con.size()>0){
            return con[0];
        }
        else{
            return NULL;
        }
    }
    @AuraEnabled
    public static Lead getLead(id leadId){
        List<Lead> leadList = [Select Id, Name from Lead where id=:leadId];
        if(leadList.size()>0){
            return leadList[0];
        }
        else{
            return NULL;
        }
    }
    @AuraEnabled
    public static Map<String,String> removeVocData(id vocDataId){
        Map<String,String> resultMap = new Map<String,String>();
        try{
            String prefix = Schema.getGlobalDescribe().get('VOC_Data_Entry__c').getDescribe().getKeyPrefix();
            String myIdPrefix = String.valueOf(vocDataId).substring(0,3);
            if(prefix!=null && prefix.equals(myIdPrefix)){
                VOC_Data_Entry__c vocEntry = new VOC_Data_Entry__c(id=vocDataId);
                delete vocEntry;
                resultMap.put('isSuccess','true');
            }
        }
        catch(exception e){
            resultMap.put('isSuccess','false');
            resultMap.put('error',e.getMessage());
            resultMap.put('line',String.valueOf(e.getLineNumber()));
            resultMap.put('stackTrace',e.getStackTraceString());
            resultMap.put('type',e.getTypeName());
        }
        return resultMap;
    }
    
    
}