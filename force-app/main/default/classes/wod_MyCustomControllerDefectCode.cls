/**
 * @description Class to get Miscellaneous information
*/
public class wod_MyCustomControllerDefectCode {
    
    public Flow.Interview.WOD_Perform_Lab_Analysis_siding_flow theFlow {get; set;}
    
    /**
     * @description to get Id
     * @return Id
    */
    public String getmyID() {
        if (theFlow ==null) return '';
        else if(theFlow.CreatedFadeLabAnalysisRecord !=null) return theFlow.CreatedFadeLabAnalysisRecord; 
        else if(theFlow.varCreatedColorLabRecord!=null) return theFlow.varCreatedColorLabRecord; 
        else if(theFlow.varCreatedLAPSLabRecord!=null) return theFlow.varCreatedLAPSLabRecord;       
        else if(theFlow.varCreatedRemainingLabRecord!=null) return theFlow.varCreatedRemainingLabRecord; 
        else return theFlow.varCreatedOtherLabRecord;
    }
    /**
     * @description to get Lab Record
     * @return PageReference of given record
    */
    public PageReference getNewLabRecord(){
        PageReference p = new PageReference('/' + getmyID() );
        p.setRedirect(true);
        return p;
    }
    /**
     * @description to get Sampling Record
     * @param sampleId Sample Id
     * @return Sampling Record
    */
    @AuraEnabled
    public static WOD_Sampling_QC__c getClaimId(Id sampleId){
        WOD_Sampling_QC__c sampleRecord = [Select id ,Claim__c, RecordType.Name from WOD_Sampling_QC__c where ID =: sampleId];
        return sampleRecord;
    }
    /**
     * @description to get Warranty Registration
     * @param wrId Warranty Registration Id
     * @return Wrapper with WR
    */
    @AuraEnabled
    public static wrapperClass getwrId(Id wrId){
        WOD_2__Warranty_Registration__c wrRecord = [Select id,Product_Group__c ,Color__c,Business_Units__c,Inspection_already_initiated__c,Coverage__c,Sales_Org__c from WOD_2__Warranty_Registration__c where ID =: wrId];
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                 FROM User Where id =: userInfo.getUserId()];
        
        wrapperClass wc = new wrapperClass();
        wc.wr = wrRecord;
        wc.ur = oUser;
        system.debug('========>wc'+wc);
        return wc;
    }
    /**
     * @description to get Claim record
     * @param claimId Claim Id
     * @return Wrapper with Claim record
    */
    @AuraEnabled
    public static wrapperClass getClaim(Id claimId){
        WOD_2__Claim__c claimRec = [select id,WOD_2__Claim_Status__c,Approval_Status__c,isReopen__c,Name,Inspection_Initiated_for_Reopen__c,category_of_product__c,
                                   Product_Group__c,Division_Code__c,Product_Color__c,Business_Units__c,Colour__c,Material__c,Product_Name1__c from WOD_2__Claim__c where Id =:claimId];
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                 FROM User Where id =: userInfo.getUserId()];
        Id sampleRoofingrecTypeId = Schema.SObjectType.WOD_Sampling_QC__c.getRecordTypeInfosByName().get('Roofing').getRecordTypeId();
        Id sampleSidingrecTypeId = Schema.SObjectType.WOD_Sampling_QC__c.getRecordTypeInfosByName().get('Siding').getRecordTypeId();
        Id sampleCommercialBuildingInfrastructurerectypId =Schema.SObjectType.WOD_Sampling_QC__c.getRecordTypeInfosByName().get('Commercial Building & Infrastructure').getRecordTypeId();//CER-211
        Id sloarrecId = Schema.SObjectType.WOD_Sampling_QC__c.getRecordTypeInfosByName().get('Solar Solutions').getRecordTypeId();//CER-211
        wrapperClass wc = new wrapperClass();
        wc.cr = claimRec;
        wc.ur = oUser; 
        wc.roofingRecId = sampleRoofingrecTypeId;
        wc.sidingRecId = sampleSidingrecTypeId;
        wc.CommercialBuildingInfrastructureId = sampleCommercialBuildingInfrastructurerectypId;//CER-211
        wc.solarId = sloarrecId;
        return wc;
    }
    /**
     * @description to get Inspection records
     * @param inspecIdSet list of Inspection ids
     * @return Wrapper with Inspection records
    */
    @AuraEnabled 
    public static wrapperClass getInspectionRecords(String[] inspecIdSet){
        system.debug('========'+inspecIdSet);
        List<WOD_Inspection__c> inspectionSet = [Select id,ownerId from WOD_Inspection__c where ID IN:inspecIdSet];
        User oUser = [select id,Name,TimeZoneSidKey,Username,Alias,Country,Email,FirstName,LastName,IsActive,IsPortalEnabled 
                 FROM User Where id =: userInfo.getUserId()];
        wrapperClass wc = new wrapperClass();
        wc.ir = inspectionSet;
        wc.ur = oUser;
        return wc;
    }
    /**
     * @description to update Claim
     * @param objClaimId Claim Id
     * @return flag for update sucess
    */
    @AuraEnabled
    Public static boolean updateClaim(Id objClaimId){
        try{
            if(objClaimId !=null){
                WOD_2__Claim__c objClaim=[select id,Inspection_Initiated_for_Reopen__c from WOD_2__Claim__c where id=:objClaimId];
                objClaim.Inspection_Initiated_for_Reopen__c=true;
                update objClaim;
            }
            
            
        }catch(Exception ex){
            
        }
        return true;
    }
    /**
     * @description to get Report Status
     * @param reportStatusId Report Id
     * @return Report Status Record
    */
    @AuraEnabled
    Public static WOD_Report_Status__c reportStatus(Id reportStatusId){
        WOD_Report_Status__c rStatus = [Select id,Related_Record_Id__c,Questionnaire__r.Max_Question_Count__c,Status__c from WOD_Report_Status__c where id=:reportStatusId];
        return rStatus;
    }
     /**
     * @description Wrapper Class
    */
    public class wrapperClass {
        @AuraEnabled
        public WOD_2__Warranty_Registration__c wr;
        @AuraEnabled
        public WOD_2__Claim__c cr;
        @AuraEnabled
        public user ur ;
         @AuraEnabled
        public List<WOD_Inspection__c> ir;
        @AuraEnabled
        public Id roofingRecId;
        @AuraEnabled
        public Id sidingRecId; 
        @AuraEnabled
        public Id CommercialBuildingInfrastructureId; 
        @AuraEnabled
        public Id solarId;
        public wrapperClass(){
            wr = new WOD_2__Warranty_Registration__c();
            ur = new user();
        }
    }
}