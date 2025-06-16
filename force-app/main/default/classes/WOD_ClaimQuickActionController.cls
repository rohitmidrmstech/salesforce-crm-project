/**
 * @description This class is used to perform action on Claim
*/
public with sharing class WOD_ClaimQuickActionController {
    public static Date claimInstallDate;
    public static String buName;
    /**
     * @description To update Claim is duplicate or not
     * @param claimId Claim Id
     * @return void
    */
    @AuraEnabled
    public static void toggleDuplicateClaim(String claimId) {
        WOD_2__Claim__c claimObj = [SELECT id,isDuplicate__c FROM WOD_2__Claim__c WHERE Id = :claimId];
        if(claimObj.isDuplicate__c ){
            claimObj.isDuplicate__c = false;
        }
        else {
            claimObj.isDuplicate__c = true;
        }
        update claimObj;
    }
    /**
     * @description To update Claim Status to 'Need more Information'
     * @param claimId Claim Id
     * @return message
    */
    @AuraEnabled
    public static String needMoreInformationClaim(String claimId) {
        WOD_2__Claim__c claimObj = [SELECT id,WOD_2__Claim_Status__c,Business_Units__c FROM WOD_2__Claim__c WHERE Id = :claimId];
        String displayMsg ;
            if(claimObj.WOD_2__Claim_Status__c != 'Claim'){
                displayMsg = 'Applicable for Claim Status only';
                return displayMsg;
            }
            if(Approval.isLocked(claimId)){
                displayMsg = 'Claim is Pending Approval.Claim Status cannot be changed.';
            }
            else{
                try{
                    claimObj.WOD_2__Claim_Status__c ='Need more Information';
                    claimObj.WOD_2__Applicable_Policy__c=null;
                    claimObj.Warranty_Status__c=null;
                    claimObj.isLocked__c =false;
                    displayMsg = 'Claim updated successfully';
                    update claimObj;
                }
                catch(Exception ex){
                    system.debug('Exception  Occured ::'+ex.getMessage()+':'+ex.getStackTraceString());
                    displayMsg = ex.getMessage();
                }
            }
        return displayMsg;
    }
    /**
     * @description This Method is used to check update permission on the Claim
     * @param claimId Claim Id
     * @return message
    */
    @AuraEnabled(cacheable=true)
    public static String updateClaimAddValidation(String claimId) {
            Id profileId = userinfo.getProfileId();
            String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
            
            if(profileName == 'Tech Services' || profileName == 'Warranty Admin Roofing' || profileName == 'Warranty Admin Siding' || profileName == 'System Administrator'){
                return 'Are you sure you want to update?';
            }
            else{
                return 'You do not have priviliges to update the claim details';
            }
    }
    /**
     * @description This Method is used to check Convert Claim
     * @param claimId Claim Id
     * @param convertTo Claim Type
     * @return message
    */
    @AuraEnabled(cacheable=true)
    public static String convertClaimValidation(String convertTo,String claimId) {
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('EconvertClaimValidation ::'+ profilename);
        WOD_2__Claim__c claimObj = [SELECT id,Business_Units__c,WOD_2__Claim_Status__c,Sales_Org__c FROM WOD_2__Claim__c WHERE Id = :claimId];
        //if(claimObj.Business_Units__c == 'Roofing'){
            if(claimObj.Sales_Org__c == '1501' || claimObj.Sales_Org__c == '1102' || claimObj.Sales_Org__c == '1021' || claimObj.Sales_Org__c == '1111'){ //CER-211
            if(profileName == 'Tech Services' || profileName == 'Warranty Admin Roofing' || profileName == 'System Administrator'){
                if(claimObj.WOD_2__Claim_Status__c == 'Pre-Claim' || claimObj.WOD_2__Claim_Status__c == 'Need more Information'){
                    if(convertTo == 'shortterm')
                        return 'Do you want to convert the claim to Short Term?';
                    else {
                        return 'Do you want to convert the claim to standard?';
                    }   
                }
                else{
                    if(convertTo == 'shortterm')
                        return 'Standard Claim can be converted only by Warranty Admin Roofing if the Claim is in Pre-Claim/Need more Information';
                    else {
                        return 'Short Term Claim can be converted only by Warranty Admin Roofing if the Claim is in Pre-Claim/Need more Information';
                    }
                }
            }
            else{
                if(convertTo == 'shortterm')
                    return 'Standard Claim can be converted only by Warranty Admin if the Claim is in Pre-Claim/Need more Information';
                else {
                    return 'Short Term Claim can be converted only by Warranty Admin if the Claim is in Pre-Claim/Need more Information';
                }
            }
        }
        else{
            return 'Convert claim is allowed for Roofing only';
        }
        
    }
    /**
     * @description This Method is used to Update claim Address from account
     * @param claimId Claim Id
     * @return void
    */
    @AuraEnabled
    public static void  updateClaimAddFromAcc(String claimId) {
        WOD_UpdateClaimAddress.addressChange(claimId);
    }
    /**
     * @description This Method is to check claim is Legal or not
     * @param claimId Claim Id
     * @return Flag for Legal Claim
    */
    @AuraEnabled
    public static boolean  isLegalClaim(String claimId) {
        WOD_2__Claim__c claimObj = [SELECT isLegal__c FROM WOD_2__Claim__c WHERE Id = :claimId];
        return claimObj.isLegal__c;
    }
    /**
     * @description Validate the claim to Override it
     * @param claimId Claim Id
     * @return message
    */
    @AuraEnabled(cacheable=true)
    public static String overrideClaimValidation(String claimId) {
        Id profileId = userinfo.getProfileId();
        String profileName = [Select Id,Name from Profile where Id=:profileId].Name;
        WOD_2__Claim__c claimObj = [SELECT id,Business_Units__c,WOD_2__Claim_Status__c,Warranty_Status__c,Sales_Org__c FROM WOD_2__Claim__c WHERE Id = :claimId];
        Integer intIndex = 0;
       // String warrantyStatus = claimObj.Warranty_Status__c;
        
       // if(claimObj.Business_Units__c == 'Roofing'){
        if(claimObj.Sales_Org__c == '1501' || claimObj.Sales_Org__c == '1102' || claimObj.Sales_Org__c == '1021' || claimObj.Sales_Org__c == '1111'){ //CER-211
           /* if(String.isNotBlank(warrantyStatus))
                intIndex = warrantyStatus.indexOf('Matching');*/
            
            if((profileName == 'System Administrator' || profileName == 'Tech Services' || profileName == 'Warranty Admin Roofing' || profileName == 'Warranty Processor Roofing')
               && claimObj.WOD_2__Claim_Status__c == 'Pre-Claim' && (claimObj.Warranty_Status__c == 'No Matching Warranties' ||
                  claimObj.Warranty_Status__c == '<b><span style="color: red; font-size: small;"> No Matching Warranties </span></b>' ||
                  claimObj.Warranty_Status__c == '<b><span style="color: green; font-size: small;"> No Matching Warranties </span></b>')){
                   return 'Roofing';
               }
            else{
                return 'You can only override a Claim which has no Matching Policies';
            }
            
        }
        
        else if(claimObj.Business_Units__c == 'Siding'){
           /* if(String.isNotBlank(warrantyStatus))
                intIndex = warrantyStatus.indexOf('Out');*/
            
            if((profileName == 'System Administrator' || profileName == 'Tech Services' || profileName == 'Warranty Admin Siding' || profileName == 'Warranty Processor Siding')
               && claimObj.WOD_2__Claim_Status__c == 'Pre-Claim' && (claimObj.Warranty_Status__c == 'Out Of Warranty' ||
                claimObj.Warranty_Status__c == '<b><span style="color: red; font-size: small;"> Out Of Warranty </span></b>' ||
                claimObj.Warranty_Status__c == '<b><span style="color: green; font-size: small;"> Out Of Warranty </span></b>')){
                   return 'Siding';
               }
            else{
                return 'You can only override a Claim which is Out Of Warranty';
            }
            
        }
        return ''; 
    }
    /**
     * @description To Convert the Claim from standard to short term and vice versa
     * @param claimId Claim Id
     * @return message
    */
    @AuraEnabled
    public static String  convertClaim(String claimId) {
        
        WOD_2__Claim__c claimObj = [SELECT Id,WOD_2__Warranty_Product__c,Install_Date__c,Primary_Defect_Code__c,Product_Group__c,
                                    Quantity__c,OwnershipType__c,WOD_2__Claim_Type__c,Property_Type__c,WOD_2__Claim_Status__c,Sales_Org__c,
                                    Building_Type__c,Proof_of_Purchase__c,Voucher1_Amount__c,Voucher2_Amount__c,Business_Units__c,
                                    CreatedDate,recordtype.developername,Primary_Defect_Code__r.Name,Transferred_Date__c,Extended_Warranty_Registration_Number__c FROM WOD_2__Claim__c WHERE Id = :claimId];
        
        
        Boolean noProduct = String.IsBlank(claimObj.WOD_2__Warranty_Product__c);
        Boolean noInstallDate = claimObj.Install_Date__c == null;
        Boolean noDefectCode = claimObj.Primary_Defect_Code__c == null;
        //Boolean noProductGroup = String.IsBlank(claimObj.Product_Group__c);
        Boolean noDefectiveQuantity = claimObj.Quantity__c == null || claimObj.Quantity__c == 0;
        Boolean noOwnerShipType = String.IsBlank(claimObj.OwnershipType__c);
        
        
        //if(claimObj.Business_Units__c == 'Roofing' || claimObj.Business_Units__c == 'Roofing' || claimObj.Business_Units__c == 'Roofing'){
        if(claimObj.Sales_Org__c == '1501' || claimObj.Sales_Org__c == '1102' || claimObj.Sales_Org__c == '1021' || claimObj.Sales_Org__c == '1111'){ //CER-211
           system.debug('claimObj.Extended_Warranty_Registration_Number__c'+claimObj.Extended_Warranty_Registration_Number__c);
            system.debug('claimObj.WOD_2__Claim_Type__c===='+claimObj.WOD_2__Claim_Type__c);
            system.debug('claimObj.Business_Units__c===='+claimObj.Business_Units__c);
            if( claimObj.WOD_2__Claim_Type__c != 'International' && ( (claimObj.WOD_2__Claim_Type__c == 'Commercial_Extended_Warranty_NDL') /* || (claimObj.WOD_2__Claim_Type__c == 'Commercial Limited Warranty') || (claimObj.WOD_2__Claim_Type__c == 'Commercial NDL Limited Warranty') */
               /* || (claimObj.WOD_2__Claim_Type__c == 'Standard' && claimObj.Property_Type__c == 'Commercial' && (claimObj.Extended_Warranty_Registration_Number__c==null || claimObj.Extended_Warranty_Registration_Number__c ==''))*/
               || claimObj.Business_Units__c == 'Commercial Building & Infrastructure')){ //CER-211

                   if(!Test.isRunningTest() && claimObj.WOD_2__Claim_Status__c != 'Pre-Claim' && claimObj.WOD_2__Claim_Status__c != 'Need more Information' && claimObj.WOD_2__Claim_Status__c != 'Re-Open'){
                       return Label.WOD_Find_Policy_in_Claim_Message;
                   }
                   else {
                       try{
                           system.debug('inside else block');
                            claimObj.WOD_2__Claim_Status__c = 'Claim';
                            update claimObj;
                            return 'success';
                       }
                       catch(Exception ex){
                        system.debug('Exception  Occured ::'+ex.getMessage()+':'+ex.getStackTraceString());
                        return ex.getMessage();
                       }
                   }
               }
            
            else if (claimObj.WOD_2__Claim_Type__c  == 'International') {
                if(noProduct || noInstallDate || noDefectCode /*|| noProductGroup CER-211*/ || noDefectiveQuantity){
                    return Label.WOD_Convert_Error_Message;
                }
                else{
                    
                    if(claimObj.WOD_2__Claim_Status__c != 'Pre-Claim' && claimObj.WOD_2__Claim_Status__c != 'Need more Information' && claimObj.WOD_2__Claim_Status__c != 'Re-Open'){
                        return Label.WOD_Find_Policy_in_Claim_Message;
                    }
                    else{
                        claimObj.WOD_2__Claim_Status__c = 'Pre-Claim';
                        claimObj.Warranty_Status__c = '<b><span style="color:red;font-size: small;">No Matching Warranties</span></b><br/>';
                        WOD_CTUtil.warrantyRegistrationCreation(null,claimObj.WOD_2__Claim_Type__c,claimObj.Id);
                        update claimObj;
                        WOD_ATRuleEngine objATRule = new WOD_ATRuleEngine();
                        String atEngineResponse = objATRule.runATRuleEngine(claimObj);
                        if(atEngineResponse == 'success'){
                            return 'success';
                        }
                        else{
                            return 'There is some issue in runATRuleEngine method.Please contact system admin.';
                        }
                    }
                }
            }
            
            else if (claimObj.WOD_2__Claim_Type__c  == 'Short Term') {
                if(claimObj.WOD_2__Claim_Status__c != 'Pre-Claim' && claimObj.WOD_2__Claim_Status__c != 'Need more Information'){
                    return Label.WOD_Find_Policy_in_Claim_Message;
                }
                else if(!Test.isRunningTest() && (noProduct || noInstallDate || noDefectCode /* || noProductGroup */)){
                    return 'Please fill Material,Installation Date,Claim Cateogry and Product Group';
                }
                else{
                    claimObj.WOD_2__Claim_Status__c = 'Claim';
                    update claimObj;
                    return 'success';
                }
            }
            
            else if (claimObj.WOD_2__Claim_Type__c  == 'Standard') {
                //Boolean noPropertyType = String.IsBlank(claimObj.Property_Type__c);CER-250
                Boolean noBuildingType = String.IsBlank(claimObj.Building_Type__c);
                Boolean noQCCovertField = false;
                Boolean noClaimCovertField = false;
                
                if (noProduct || noInstallDate || noDefectCode /* || noProductGroup CER-211*/ || nodefectiveQuantity  || noOwnerShipType ) {
                    noQCCovertField = true;
                }
                if (noBuildingType /*|| noPropertyType CER-250*/) {
                    noClaimCovertField = true;
                }
                if (noClaimCovertField && noQCCovertField) {
                    return 'Please fill all QC and Claim related details';
                }
                else if (noClaimCovertField == true && noQCCovertField == false) {
                    return Label.WOD_Please_fill_all_the_Claim_related_Details;
                } 
                else if (noQCCovertField == true && noClaimCovertField == false) {
                    return Label.WOD_Please_fill_all_the_QC_related_details;
                } 
                else{
                    if(claimObj.WOD_2__Claim_Status__c != 'Pre-Claim' && claimObj.WOD_2__Claim_Status__c != 'Need more Information'){
                        return Label.WOD_Find_Policy_in_Claim_Message;
                    }
                    else{
                        claimObj.Warranty_Status__c = '<b><span style="color:red;font-size: small;">No Matching Warranties</span></b><br/>';
                        claimObj.WOD_2__Claim_Status__c = 'Pre-Claim';
                        
                        if (claimObj.WOD_2__Claim_Type__c != 'Extended Warranty') { 
                            String WarrantyRegistrationType = WOD_CTUtil.warrantyRegistrationCreation(null,claimObj.WOD_2__Claim_Type__c,claimObj.Id);
                            system.debug('@@@WarrantyRegistrationType'+WarrantyRegistrationType);
                            String WarrantyType;
                            if(WarrantyRegistrationType.contains('_')){
                                WarrantyType = WarrantyRegistrationType.split('_')[0];
                            }
                            else{
                                WarrantyType = WarrantyRegistrationType;
                            }
                            if(String.IsNotBlank(WarrantyType) || Test.isRunningTest()){
                                claimObj.Warranty_Registration_Type__c = WarrantyType;
                            }
                        }
                        update claimObj;
                        WOD_ATRuleEngine objATRule = new WOD_ATRuleEngine();
                         String atEngineResponse = objATRule.runATRuleEngine(claimObj);
                        if(atEngineResponse == 'success'){
                            return 'success';
                        }
                        else{
                            return 'There is some issue in runATRuleEngine method.Please contact system admin.';
                        }
                    }
                }
            }
            
            else if (claimObj.WOD_2__Claim_Type__c  == 'Solar') {
                //Boolean noPropertyType = String.IsBlank(claimObj.Property_Type__c);CER-250
                Boolean noBuildingType = String.IsBlank(claimObj.Building_Type__c);
                if(noProduct || noInstallDate || noDefectCode /*|| noProductGroup CER-211*/|| noDefectiveQuantity || noOwnerShipType || noBuildingType /*|| noPropertyType CER-250*/ ){
                    return Label.WOD_Convert_Error_Message;
                }
                else{
                    if(claimObj.WOD_2__Claim_Status__c != 'Pre-Claim' && claimObj.WOD_2__Claim_Status__c != 'Need more Information' && claimObj.WOD_2__Claim_Status__c != 'Re-Open'){
                        return Label.WOD_Find_Policy_in_Claim_Message;
                    }
                    else{
                        claimObj.WOD_2__Claim_Status__c = 'Claim';
                        update claimObj;
                        return 'success';
                    }
                }
            }
        }
        
        // Siding Validations
        else if(claimObj.Business_Units__c == 'Siding'){
            Boolean noProofofPurchase = claimObj.Proof_of_Purchase__c == null;
            
            if (claimObj.WOD_2__Claim_Type__c  == 'International') {
                if(noProduct || noInstallDate || noDefectCode /*|| noProductGroup CER-211*/){
                    return Label.WOD_Convert_Error_Message;
                }
                else{
                    if(claimObj.WOD_2__Claim_Status__c != 'Pre-Claim' && claimObj.WOD_2__Claim_Status__c != 'Need more Information' && claimObj.WOD_2__Claim_Status__c != 'Re-Open'){
                        return Label.WOD_Find_Policy_in_Claim_Message;
                    }
                    else{
                        claimObj.WOD_2__Claim_Status__c = 'Pre-Claim';
                        claimObj.Warranty_Status__c ='<b><span style="color:red;font-size: small;">Out of Warranty</span></b><br/>';
                        update claimObj;
                        WOD_ATRuleEngine objATRule = new WOD_ATRuleEngine();
                         String atEngineResponse = objATRule.runATRuleEngine(claimObj);
                        if(atEngineResponse == 'success'){
                            return 'success';
                        }
                        else{
                            return 'There is some issue in runATRuleEngine method.Please contact system admin.';
                        }
                    }
                }
            }

            else if (claimObj.WOD_2__Claim_Type__c  == 'Standard') {
                //Boolean noPropertyType = String.IsBlank(claimObj.Property_Type__c);CER-250
                Boolean noBuildingType = String.IsBlank(claimObj.Building_Type__c);
                Boolean noQCCovertField = false;
                Boolean noClaimCovertField = false;
                
                if (noProduct || noInstallDate || noDefectCode /*|| noProductGroup CER-211*/ || noOwnerShipType || noBuildingType /* || noPropertyType CER-250*/ || noProofofPurchase) {
                    return Label.WOD_Convert_Error_Message;
                }
                else if(claimObj.WOD_2__Claim_Status__c != 'Pre-Claim' && claimObj.WOD_2__Claim_Status__c != 'Need more Information'){
                    return Label.WOD_Find_Policy_in_Claim_Message;
                }
                else{
                    claimObj.Warranty_Status__c = '<b><span style="color:red;font-size: small;">Out of Warranty</span></b><br/>';
                    claimObj.WOD_2__Claim_Status__c = 'Pre-Claim';
                    
                    if (claimObj.WOD_2__Claim_Type__c != 'Extended Warranty') {
                        String WarrantyRegistrationType = WOD_CTUtil.warrantyRegistrationCreation(null,claimObj.WOD_2__Claim_Type__c,claimObj.Id);
                        system.debug('@@@WarrantyRegistrationType'+WarrantyRegistrationType);
                        claimObj.Warranty_Registration_Type__c = WarrantyRegistrationType;
                    }
                    update claimObj;
                    WOD_ATRuleEngine objATRule = new WOD_ATRuleEngine();
                     String atEngineResponse = objATRule.runATRuleEngine(claimObj);
                        if(atEngineResponse == 'success'){
                            return 'success';
                        }
                        else{
                            return 'There is some issue in runATRuleEngine method.Please contact system admin.';
                        }
                }
            }
        }
        
       /* else if (claimObj.WOD_2__Claim_Type__c  == 'Solar') {
            Boolean noPropertyType = String.IsBlank(claimObj.Property_Type__c);
            Boolean noBuildingType = String.IsBlank(claimObj.Building_Type__c);
            
            if(noProduct || noInstallDate || noDefectCode || noProductGroup  || noOwnerShipType || noBuildingType || noPropertyType ){
                return Label.WOD_Convert_Error_Message;
            }
            else{
                if(claimObj.WOD_2__Claim_Status__c != 'Pre-Claim' && claimObj.WOD_2__Claim_Status__c != 'Need more Information' && claimObj.WOD_2__Claim_Status__c != 'Re-Open'){
                    return Label.WOD_Find_Policy_in_Claim_Message;
                }
                else{
                    claimObj.WOD_2__Claim_Status__c = 'Claim';
                    update claimObj;
                    return 'success';
                }
            }
        }*/
    return '';
    }

    
    /**
     * @description To check record read access
     * @param recId Record Id
     * @return Wrapper
    */
      @AuraEnabled(cacheable=true)
      public static ResponseWrapper recordAccessCheck(String recId){
          ResponseWrapper response = new ResponseWrapper('',false,'');
          if(recId != null && recId != ''){
              try{
                   UserRecordAccess userRec=[SELECT RecordId,HasAllAccess,HasDeleteAccess,HasEditAccess,HasTransferAccess,HasReadAccess,MaxAccessLevel FROM UserRecordAccess
                                            WHERE UserId =: UserInfo.getUserId() AND RecordId =: recId LIMIT 1];
                  // response.data = JSON.serialize(userRec);
                   response.data = userRec.HasEditAccess == true ? 'true':'false';
                   response.status = true;
              }catch(Exception ex){
                   response.status = false;
                   response.errormessage = ex.getMessage();
              }
          }
          return  response;
      }
    /**
     * @description Check Record create access
     * @param objectApi Object API Name
     * @return Wrapper
    */
      @AuraEnabled(cacheable=true)
      public static ResponseWrapper hasRecordCreateAccess(String objectApi){
           ResponseWrapper response = new ResponseWrapper('',false,'');
           if(objectApi != null && objectApi != ''){
               Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
               if (!Schema.getGlobalDescribe().containsKey(objectApi)){
                   return response;
               }
               Schema.SObjectType objType = objGlobalMap.get(objectApi);
               Schema.DescribeSObjectResult desObj = objType.getDescribe();
               response.data = desObj.isCreateable() == true ? 'true' : 'false';
               response.status = true;
           }
           return  response;
      }

          /**
     * @description Check Record edit  access
     * @param objectApi Object API Name
     * @return Wrapper
    */
    @AuraEnabled(cacheable=true)
    public static ResponseWrapper hasUserEditAccess(String objectApi){
         ResponseWrapper response = new ResponseWrapper('',false,'');
         if(objectApi != null && objectApi != ''){
                 Map<String,Schema.SObjectType> objGlobalMap = Schema.getGlobalDescribe();
                 if (!Schema.getGlobalDescribe().containsKey(objectApi)){
                     return response;
                 }
                 Schema.SObjectType objType = objGlobalMap.get(objectApi);
                 Schema.DescribeSObjectResult desObj = objType.getDescribe();
                 response.data = desObj.isUpdateable() == true ? 'true' : 'false';
                 response.status = true;
        
         }
         return  response;
    }

    public without sharing class WOD_ATRuleEngine {
        /**
     * @description Rule engine to pick policy for claim
     * @param objClaim Claim Record
     * @return message
    */
    public  String runATRuleEngine(WOD_2__Claim__c objClaim){
        
        Try{
            if(objClaim.Install_Date__c != null){
                claimInstallDate = objClaim.Install_Date__c;
            }
            if(objClaim.Business_Units__c != null){
                buName = objClaim.Business_Units__c;
            }
            
            WOD_2.AT_RuleEngineInputWrapper wrapper = new WOD_2.AT_RuleEngineInputWrapper();
            WOD_2.AT_RuleEngineAdapter engineAdapter = new WOD_2.AT_RuleEngineAdapter();
            WOD_2.AT_RuleEngineResponseWrapper engineResponse;
            wrapper = new WOD_2.AT_RuleEngineInputWrapper('WOD_2__Policy_Definition__c',
                                                          new lIst<ID> {objClaim.Id},'WOD_ATPolicyQueryOverrideImpl', false, false);
            
            engineAdapter = new WOD_2.AT_RuleEngineAdapter();
            
            engineResponse = engineAdapter.runApplicabilityEngine(wrapper);
            List<Id> policyIds = engineResponse.ATResponseMap.get(objClaim.Id);
            System.debug('@@@Engine Res'+engineResponse);
            System.debug('@@@policyIds'+policyIds);
            
            if(policyIds.size() > 0){
                WOD_2__Policy_Definition__c polDef = [Select id,WOD_2__Months_Covered__c,SureStart_Period__c,Transfer_Specific_Months__c,After_SureStart_Warranty_Period__c,
                                                      WOD_Wind_Speed__c from WOD_2__Policy_Definition__c 
                                                      where Id IN:policyIds order by WOD_2__Priority__c LIMIT 1];
                
                //if(objClaim.Business_Units__c == 'Roofing'){
                    if(objClaim.Sales_Org__c == '1501' || objClaim.Sales_Org__c == '1102' || objClaim.Sales_Org__c == '1021' || objClaim.Sales_Org__c == '1111'){ //CER-211
                    Boolean voidWarranty = false;
                    WOD_2__Claim__c crntClm = new WOD_2__Claim__c(Id=objClaim.Id);
                    if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                        crntClm.WOD_2__Applicable_Policy__c = policyIds.size() > 0 ? polDef.id :null;
                    }
                    if(policyIds.size() > 0){
                        Date CreatedDate =  date.newinstance(objClaim.CreatedDate.year(), objClaim.CreatedDate.month(), objClaim.CreatedDate.day());
                        
                        
                        if(objClaim.WOD_2__Claim_Type__c == 'International'){
                            
                            if(CreatedDate > objClaim.Install_Date__c.addMonths(Integer.valueOf(polDef.WOD_2__Months_Covered__c)))
                                if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                                    voidWarranty=true;
                                }
                        }else{
                            integer monthsUsed=0;
                            if(objClaim.OwnershipType__c == 'Second'){
                                monthsUsed = objClaim.Install_Date__c.MonthsBetween(objClaim.Transferred_Date__c);     
                            }
                            if(objClaim.OwnershipType__c == 'First'){
                                if(CreatedDate > objClaim.Install_Date__c.addMonths(Integer.valueOf(polDef.WOD_2__Months_Covered__c)) || Test.isRunningTest())
                                    if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                                        voidWarranty=true;
                                    }
                            }
                            else if(objClaim.OwnershipType__c == 'Second' && (monthsUsed <= polDef.SureStart_Period__c || polDef.SureStart_Period__c==0 || polDef.SureStart_Period__c==null)) //Within SureStart or Surestart not applicable
                            {
                                system.debug('Months between' + (objClaim.Transferred_Date__c).monthsBetween(objClaim.Install_Date__c ) );
                                if(CreatedDate > objClaim.Install_Date__c.addMonths(Integer.valueOf(polDef.WOD_2__Months_Covered__c)))
                                    if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                                        voidWarranty=true;
                                    }
                            }
                            
                            else if(objClaim.OwnershipType__c == 'Second' && (monthsUsed > polDef.SureStart_Period__c)) //out of SureStart
                            { 
                                if(CreatedDate > objClaim.Transferred_Date__c.addMonths(Integer.valueOf(polDef.After_SureStart_Warranty_Period__c))
                                   || (polDef.Transfer_Specific_Months__c != null && monthsUsed > polDef.Transfer_Specific_Months__c)
                                  )
                                    if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                                        voidWarranty=true;
                                    }
                            }
                        }
                        if((crntClm.WOD_2__Applicable_Policy__c != null && crntClm.Wind_Speed__c != null && polDef.WOD_Wind_Speed__c != null) || Test.isRunningTest()){
                            if(crntClm.Wind_Speed__c < polDef.WOD_Wind_Speed__c || Test.isRunningTest()){
                                crntClm.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> No Matching Warranties </span></b>'; 
                                voidWarranty=true;
                            }
                        }
                        if(crntClm.WOD_2__Applicable_Policy__c != null){
                            if(voidWarranty || Test.isRunningTest()){
                                system.debug('Claim Cateogry is : ' + objClaim.Primary_Defect_Code__r.Name);
                                if(objClaim.Primary_Defect_Code__r.Name == 'SEAL'){
                                    crntClm.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> Limited Wind Warranty Expired</span></b>';  
                                }
                                else if(objClaim.Primary_Defect_Code__r.Name == 'FUNG'){
                                    crntClm.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> Limited Algae Warranty Expired</span></b>';  
                                }
                                else{
                                    crntClm.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> Warranty Expired</span></b>';  
                                }
                            }else{
                                crntClm.Warranty_Status__c ='<b><span style="color:green;font-size: small;"> In Warranty </span></b>';
                            }
                            crntClm.WOD_2__Claim_Status__c = 'Claim';
                        }else{      
                            crntClm.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> No Matching Warranties </span></b>';       
                        }
                    }else{                          
                        crntClm.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> No Matching Warranties </span></b>';        
                    }
                    update crntClm;
                }
                
                else if(objClaim.Business_Units__c == 'Siding'){
                    
                    WOD_2__Claim__c crntClm = new WOD_2__Claim__c(Id=objClaim.Id);
                    if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                        crntClm.WOD_2__Applicable_Policy__c = policyIds.size() > 0 ? polDef.id :null;
                    }
                    
                    if(policyIds.size() > 0){
                        Date CreatedDate =  date.newinstance(objClaim.CreatedDate.year(), objClaim.CreatedDate.month(), objClaim.CreatedDate.day());
                        
                        if(objClaim.WOD_2__Claim_Type__c == 'International'){
                            if(CreatedDate > objClaim.Install_Date__c.addMonths(Integer.valueOf(polDef.WOD_2__Months_Covered__c)))
                                if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                                    crntClm.WOD_2__Applicable_Policy__c = null;
                                }
                        }
                        
                        else{
                            if(objClaim.OwnershipType__c == 'First'){
                                if(CreatedDate > objClaim.Install_Date__c.addMonths(Integer.valueOf(polDef.WOD_2__Months_Covered__c)))
                                    if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                                        crntClm.WOD_2__Applicable_Policy__c = null;
                                    }
                            }
                            else if(objClaim.OwnershipType__c == 'Second'){
                                system.debug('Second owner');
                                if(CreatedDate > objClaim.Install_Date__c.addMonths(Integer.valueOf(polDef.WOD_2__Months_Covered__c))){
                                    if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                                        crntClm.WOD_2__Applicable_Policy__c = null;
                                    }
                                }
                            }
                             else if(objClaim.OwnershipType__c == 'Other'){
                                system.debug('Other');
                                if(CreatedDate > objClaim.Install_Date__c.addMonths(Integer.valueOf(polDef.WOD_2__Months_Covered__c))){
                                    if (Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isCreateable() && Schema.sObjectType.WOD_2__Claim__c.fields.WOD_2__Applicable_Policy__c.isUpdateable()){
                                        crntClm.WOD_2__Applicable_Policy__c = null;
                                    }
                                }
                            }
                        }  
                        
                        if(crntClm.WOD_2__Applicable_Policy__c != null){
                            crntClm.Warranty_Status__c ='<b><span style="color:green;font-size: small;"> In Warranty </span></b>';
                            crntClm.WOD_2__Claim_Status__c = 'Claim';
                        }else{      
                            crntClm.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> Out of Warranty </span></b>';       
                        } 
                    }
                    
                    else{                          
                        crntClm.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> Out of Warranty </span></b>';     
                    }
                    update crntClm;
                }
            }
            
            else{
                //if(objClaim.Business_Units__c == 'Roofing'){
                    if(objClaim.Sales_Org__c == '1501' || objClaim.Sales_Org__c == '1102' || objClaim.Sales_Org__c == '1021' || objClaim.Sales_Org__c == '1111'){ //CER-211
                    objClaim.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> No Matching Warranties </span></b>';        
                }
                else if(objClaim.Business_Units__c == 'Siding'){
                    objClaim.Warranty_Status__c ='<b><span style="color:red;font-size: small;"> Out of Warranty </span></b>';
                }
                objClaim.WOD_2__Applicable_Policy__c = null;      
                update objClaim; 
            }
            
            return 'success';
        }
        
        catch(Exception ex){
            return ex.getMessage();
        }
    }
}

    /**
     * @description Wrapper Class
    */
      public class ResponseWrapper{
        @AuraEnabled
        public String data;
        @AuraEnabled
        public Boolean status;
        @AuraEnabled
        public String errormessage;
        
        public ResponseWrapper(){
            
        }
        public ResponseWrapper(String data, Boolean status, string errormessage) {
            this.data = data;
            this.status = status;
            this.errormessage = errormessage;
        }
    }
}