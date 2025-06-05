/**
* -------------------------------------------------------------------------------------------------
* @description This class is controller class of "wod_QC" lightning web component.
* -------------------------------------------------------------------------------------------------
* @author         Pintoo<pintoo.jadaun@tavant.com>
* @created        10-FEB-2021
* --------------------------------------------------------------------------------------------------
**/
public with sharing class WOD_QCController {

    /**
     * @description Fetch QC record on edit.
     * @param recordId QC Record Id
     * @return List of QC Records
    */
    @AuraEnabled
    public static List<WOD_QC__c> getQC (String recordId){
         List<WOD_QC__c> qcRecList = [SELECT Id,Active__c,Claim__c,Claim__r.WOD_2__Claim_Type__c,Claim__r.Property_Type__c,isClassAction__c,Is_Fiberglass_Horizon_Class_Action__c,Class_Action_Form_Received__c,Date_of_Installation__c,
                            Date_of_Transfer__c,Defect_Details__c,Lab_Comments__c,Lab_Status__c,Material__c,Material__r.Name,Other_Reason__c,Ownership_Type__c,Photo_Comments__c,
                            Plant__c,Plant__r.Name,Primary_Defect_Code__c,Primary_Defect_Code__r.Name,Product_Group__c,Reject_Reason__c,Secondary_Defect_Code__c,Secondary_Defect_Code__r.Name,
                            Tape_Code_A__c,Tape_Code_B__c,Tape_Code_C__c,Tape_Code_D__c,Quantity__c,material_quantity__c FROM WOD_QC__c where Id =: recordId];
                                                                                    
         
        return qcRecList;
    }
    /**
     * @description Load The questionnaire section 
     * @param primaryDefectCodeId Primary Defect Code record id
     * @param qcId QC Id
     * @return List of DynaControl
    */
    @AuraEnabled(cacheable=true)
    public static List<DynaControl>  loadDynamicControls(String primaryDefectCodeId,String qcId){
        List<DynaControl> lstDynaControls = new List<DynaControl>();
        List<WOD_Claim_Question__c> lstWCQ = new List<WOD_Claim_Question__c>();
        List<WOD_Defect_Detail__c> defectDtlList = new List<WOD_Defect_Detail__c>();
        
        try{
            if(String.IsNotBlank(qcId)){
                defectDtlList = [Select Id, Claim__c, Claim_Question__c, Value__c From WOD_Defect_Detail__c Where QC__c = :qcId];
            }
            lstWCQ = [select Id, Name,Control_Type__c,Options__c,Order__c, Help_Text__c,Required__c from WOD_Claim_Question__c Where Warranty_Code__c = :primaryDefectCodeId];
            
            if(String.IsNotBlank(primaryDefectCodeId)){
                for(WOD_Claim_Question__c cqs:[select Id, Name,Control_Type__c,Options__c,Order__c, Help_Text__c,Required__c
                            from WOD_Claim_Question__c Where Warranty_Code__c = :primaryDefectCodeId ]){
                                            
                    system.debug('WOD_Claim_Question__c-->>' + cqs);
                    DynaControl  dynaControl=new DynaControl();
                    dynaControl.cqId = cqs.Id;
                    dynaControl.controlLabel = cqs.Name;
                    dynaControl.controlType = cqs.Control_Type__c;
                    dynaControl.controlOrder = Integer.valueOf(cqs.Order__c);
                    dynaControl.helpText = cqs.Help_Text__c;
                    dynaControl.required = cqs.Required__c;
                    dynaControl.showReqErrorMsg = false;
                    dynaControl.controlVal = '';
            
                    if(cqs.Control_Type__c == 'Text'){
                        dynaControl.isText = true;
                    }
                    else if(cqs.Control_Type__c == 'TextMask'){
                        dynaControl.isTextMask = true;
                    }
                    else if(cqs.Control_Type__c == 'Textarea'){
                        dynaControl.isTextArea = true;
                    }
                    else if(cqs.Control_Type__c == 'Radio'){
                        dynaControl.isRadio = true;
                        if(cqs.Options__c!=null){
                            String[] options = cqs.Options__c.split(',');
                            if(options.size()>1){
                                dynaControl.controlOptions = cqs.Options__c.split(',');
                            }
                            else{
                                dynaControl.inputTextLabel = cqs.Options__c;
                            }
                        }
                    }
                    

                    if(defectDtlList.size()>0){
                        for(WOD_Defect_Detail__c ddlc:defectDtlList){
                            if(ddlc.Claim_Question__c == cqs.Id){
                                dynaControl.controlVal = ddlc.Value__c;
                            }
                        }
                    }
                    lstDynaControls.add(dynaControl);
                    lstDynaControls.sort();
                }
            }
        }

        catch(Exception ex){
            system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
        }
        system.debug('@@@lstDynaControls'+lstDynaControls);
        return lstDynaControls;

    }

/**
 * @description Create QC record for a claim
 * @param qcObj QC Object
 * @param primaryDefectName Primary Defect Name
 * @param lstDynaControl List of DynaControl Records
 * @param buName Business unit Siding/Roofing
 * @return Wrapper
*/
@AuraEnabled
public static ResponseWrapper createQC(WOD_QC__c qcObj,String primaryDefectName,List<DynaControl> lstDynaControl,String buName){

    ResponseWrapper response = new ResponseWrapper('',false,'');
    WOD_2__Claim__c objClaim = [select id,Property_Type__c from WOD_2__Claim__c where id=:qcObj.Claim__c];
    List<WOD_Defect_Detail__c> defectlist = new List<WOD_Defect_Detail__c>();
    String classActionDefCodeName ='PREM';
    system.debug('qcObj.Material__c-->'+qcObj.Material__c);
    
    try{
    WOD_2__Warranty_Product__c recQC;
        if(qcObj.Material__c != null){
            recQC= [select id,Product_Type__r.name from WOD_2__Warranty_Product__c where id=:qcObj.Material__c];
        }
    
    if(String.IsNotBlank(qcObj.Tape_Code_A__c))
        qcObj.Tape_Code_A__c = qcObj.Tape_Code_A__c.replace('&#160;',' ');
    if(String.IsNotBlank(qcObj.Tape_Code_B__c))    
        qcObj.Tape_Code_B__c = qcObj.Tape_Code_B__c.replace('&#160;',' ');
    if(String.IsNotBlank(qcObj.Tape_Code_C__c))
        qcObj.Tape_Code_C__c = qcObj.Tape_Code_C__c.replace('&#160;',' ');
    if(String.IsNotBlank(qcObj.Tape_Code_D__c))
        qcObj.Tape_Code_D__c = qcObj.Tape_Code_D__c.replace('&#160;',' ');

    List<WOD_Defect_Detail__c> defectdtllist = [Select Id, Claim__c, Claim_Question__c From WOD_Defect_Detail__c Where QC__c = :qcObj.Id];
    Delete defectdtllist;

    WOD_Defect_Detail__c defectdetail = null;
    
    if(String.isNotBlank(buName)){
        List<WOD_2__Business_Category_Configuration__c> bccRecord = [Select WOD_Class_Action_Defect_Code__c from WOD_2__Business_Category_Configuration__c where Name=:buName];
        if(bccRecord.size()>0 && String.IsNotBlank(bccRecord[0].WOD_Class_Action_Defect_Code__c))
           classActionDefCodeName = bccRecord[0].WOD_Class_Action_Defect_Code__c;
    }
    
        Set<string> fiberClassHorWP = new Set<String>();
        //system.debug('Warranty Product Type-->'+recQC.Product_Type__r.name);
        for(Fiberglass_Horizon_shingle__mdt each:[SELECT  Id,DeveloperName,Label FROM Fiberglass_Horizon_shingle__mdt LIMIT 2000]){
            fiberClassHorWP.add((each.label).toLowerCase());
        }
        if(recQC != null && recQC.Product_Type__c != null && fiberClassHorWP.contains((recQC.Product_Type__r.name).toLowerCase()) && primaryDefectName!='FUNG'){
            qcObj.Is_Fiberglass_Horizon_Class_Action__c= true;
            qcObj.isClassAction__c = false;
        }else{
            If(String.IsNotBlank(primaryDefectName) && primaryDefectName == classActionDefCodeName){
                qcObj.isClassAction__c = true;
                qcObj.Is_Fiberglass_Horizon_Class_Action__c= false;
            }else{            
                qcObj.isClassAction__c = false;
            } 
            
        }
        upsert qcObj;
        
        for(DynaControl dc:lstDynaControl){
            
            if(dc.controlVal!=null){
            defectdetail = new WOD_Defect_Detail__c();
            defectdetail.name = dc.controlLabel;
            defectdetail.QC__c = qcObj.Id;
            defectdetail.Claim_Question__c = dc.cqId;
            defectdetail.Value__c = dc.controlVal;                
            if(dc.controlLabel =='Wind Speed')
            {
                If(String.IsNotBlank(primaryDefectName) && primaryDefectName == 'SEAL')
                    if(dc.controlVal!='')
                        objClaim.Wind_Speed__c=Decimal.valueof(dc.controlVal);
            }
            defectlist.add(defectdetail);
        }
    }
    system.debug(defectlist);
    
    upsert(defectlist);
    update(objClaim);
    
    Integer count = [Select count() from WOD_QC__c where Claim__c=:objClaim.Id];
    system.debug('count-->'+count);        
    if(count ==1 || qcObj.Active__c){
        WOD_UpdateQCStatus.statusChange(qcObj.Id);
    }
    response.data = qcObj.Id;
    response.status = true;
    
}
    catch(Exception ex){
        system.debug('Exception  Occured ::'+ex.getMessage()+ '--Line number--'+ ex.getLineNumber());
        response.status=false;
        response.errormessage=ex.getMessage();
    }
    return response;

}
/**
 * @description This inner class is used to dynamically generate the components.
*/
public class DynaControl implements Comparable {
    @AuraEnabled
    public String cqId{ get; set; }
    @AuraEnabled
    public String controlType{ get; set; }
    @AuraEnabled
    public String controlLabel{ get; set; }
    @AuraEnabled
    public String inputTextLabel{ get; set; }
    @AuraEnabled
    public String helpText{ get; set; }
    @AuraEnabled
    public List<String> controlOptions { get; set; }
    @AuraEnabled
    public String controlVal {get; set; }
    @AuraEnabled
    public Integer controlOrder {get; set; }
    @AuraEnabled
    public Boolean required {get; set; }
    @AuraEnabled
    public Boolean isText {get; set; }
    @AuraEnabled
    public Boolean isTextArea {get; set; }
    @AuraEnabled
    public Boolean isTextMask {get; set; }
    @AuraEnabled
    public Boolean isRadio {get; set; }
    @AuraEnabled
    public Boolean showReqErrorMsg {get; set; }


    public DynaControl(){ 
    }
    /**
     * @description to compare Records
     * @param ObjToCompare Sobject
     * @return Integer value
    */
    public Integer compareTo(Object ObjToCompare) {
        DynaControl dc = (DynaControl)(ObjToCompare);
        if(this.controlOrder>dc.controlOrder){
            return 1;
        }
        if(this.controlOrder==dc.controlOrder){
            return 0;
        }
        return -1;
    }
}
    /**
     * @description: Wrapper Class
    */
    public class ResponseWrapper{
        @AuraEnabled
        public String data;
        @AuraEnabled
        public Boolean status;
        @AuraEnabled
        public String errormessage;
        
        public ResponseWrapper(String data, Boolean status, string errormessage) {
            this.data = data;
            this.status = status;
            this.errormessage = errormessage;
        }
    }
}