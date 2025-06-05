/**
* @description This class has  been used to hadle claim from public site which includes 
account creation,claim creation,address validation, gitting picklist values etc.
*/
public without sharing class WOD_CTClaimPublicController {
    /**
* @description To Get Record Type of Objects
* @param sObjName Object API Name
* @return List of Record Type
*/
    @AuraEnabled
    public Static List<RecordType> getPaymentRecordTypes(String sObjName){        
        return [Select Id,Name,Description from RecordType where sobjectType=:sObjName and IsActive=:true];
    }
    
    /**
* @description This method used for address validation
* @param  address1 for Address 1
* @param  address2 for Address 2
* @param  cityName for City
* @param  stateName for State
* @param  zipCode for Zip
* @param  country for Country
* @param  email for Email
* @param  bu for BU
* @return wraper of WOD_CTUtil.validateBuildingLocationAddress
*/
    @AuraEnabled/* (cacheable=true) */
    public Static WOD_CTUtil.validateBuildingLocationAddress verifyBuildingLocation(String address1,String address2,String cityName,String stateName,String zipCode,String country,String email,String bu){   
        return WOD_CTUtil.addressValidation(address1,address2,cityName,stateName,zipCode,country,email,bu);
    } 
    /**
* @description This method used for claim submission
* @param userupdatedaddresswrapper for Address Wrapper of User
* @param buildingupdatedwrapper for Building Address Wrapper
* @param claimwrapper Claim Wrapper 
* @param otherinformationwrapper Mis. Claim Details Wrapper 
* @param issidingcreation flag for siding validation
* @return WOD_2__Claim__c objects
*/
    @AuraEnabled(cacheable=false)
    public Static WOD_2__Claim__c submit(WOD_CTUtil.EndUserDetails userupdatedaddresswrapper,WOD_CTUtil.BuildingDetails buildingupdatedwrapper,
                                         WOD_CTUtil.ClaimDetails claimwrapper,WOD_CTUtil.OtherSiteDetails otherinformationwrapper,Boolean issidingcreation){
                                             system.debug('claimwrapper:::'+claimwrapper);
                                             system.debug('claimwrapper:::'+claimwrapper.selectedBusinessUnit);
                                             //String bu; 
                                             String validityPeriod='';                         
                                             /*if(issidingcreation){
                                                 bu ='Siding';                             
                                             }else{
                                                 bu=claimwrapper.selectedBusinessUnit;
                                             }*/
                                             String bu=claimwrapper.selectedBusinessUnit;
                                             WOD_2__Business_Category_Configuration__c bcc = [Select id,Name from WOD_2__Business_Category_Configuration__c where Id=:bu limit 1];                         
                                             Id claimRecordType;
                                             if(bcc.Name == 'Solar Solutions'){
                                                claimRecordType = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByDeveloperName().get('Solar').getRecordTypeId();
                                             }else if(bcc.Name == 'Commercial Building & Infrastructure'){
                                                claimRecordType = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByDeveloperName().get('Commercial_Extended_Warranty_NDL').getRecordTypeId();
                                             }else{
                                                claimRecordType = Schema.SObjectType.WOD_2__Claim__c.getRecordTypeInfosByDeveloperName().get('Standard').getRecordTypeId();
                                             }
                                             System.debug(issidingcreation+'====bu'+bu);                        
                                             WOD_2__Claim__c claim = new WOD_2__Claim__c();
                                             
                                             String vendorName;
                                             if(buildingupdatedwrapper.country =='Canada'){
                                                 vendorName = 'Standard_CAN';
                                             }else{
                                                 vendorName = 'Standard';
                                             }
                                             WOD_CT_SAP_Vendor_Number__mdt vendorSAPNumber =[Select Id,Label,WOD_SAP_Vendor_Number__c from WOD_CT_SAP_Vendor_Number__mdt where Label=:vendorName];
                                             if(null != claimwrapper.productValue && '' != claimwrapper.productValue && 'undefined' != claimwrapper.productValue && '--None--' != claimwrapper.productValue ){
                                                 WOD_CertainTeed_ShortTerm_Period__mdt shortTermPeriod=[Select Label,WOD_Validity_Period__c from WOD_CertainTeed_ShortTerm_Period__mdt where Label =:claimwrapper.productValue];
                                                 validityPeriod = String.valueOf(shortTermPeriod.WOD_Validity_Period__c);
                                             }else{
                                                 validityPeriod =''; 
                                             }
                                             
                                             Account acc = WOD_CTUtil.accountCreation(buildingupdatedwrapper.address1,buildingupdatedwrapper.address2,buildingupdatedwrapper.cityName,
                                                                                      buildingupdatedwrapper.state,buildingupdatedwrapper.country,buildingupdatedwrapper.postalCode);
                                             claim.WOD_2__BusinessCategory__c = bcc.Id;
                                             claim.Business_Units__c          = bcc.Name;
                                             claim.First_Name_BL__c           = buildingupdatedwrapper.firstName;
                                             claim.Last_Name_BL__c            = buildingupdatedwrapper.lastName;
                                             claim.Address_1_BL__c            = buildingupdatedwrapper.address1;
                                             claim.Address_2_BL__c            = buildingupdatedwrapper.address2;
                                             claim.City_BL__c                 = buildingupdatedwrapper.cityName;
                                             claim.State_BL__c                = buildingupdatedwrapper.state;
                                             claim.Postal_Code_BL__c          = buildingupdatedwrapper.postalCode;
                                             claim.Country_BL__c              = buildingupdatedwrapper.country;
                                             //claim.Property_Type__c           = otherinformationwrapper.buildingProductType;
                                             claim.Organization_BL__c         = otherinformationwrapper.buildingProductName;
                                             claim.Unit_of_Measure__c         = validityPeriod;
                                             claim.WOD_2__Claim_Type__c       = 'Standard';
                                             //claim.Product_Group__c           = claimwrapper.productValue;
                                             claim.Division_Code__c           = claimwrapper.selecteddivision;// CER-211
                                             claim.Building_Type__c           = claimwrapper.buildingValue;
                                             
                                             claim.First_Name__c              = userupdatedaddresswrapper.firstName;
                                             claim.Last_Name__c               = userupdatedaddresswrapper.lastName;
                                             claim.City__c                    = userupdatedaddresswrapper.cityName; 
                                             claim.Phone__c                   = otherinformationwrapper.userPhone;
                                             claim.Postal_Code__c             = userupdatedaddresswrapper.postalCode;
                                             claim.Zip_Code_Postal_Code__c    = userupdatedaddresswrapper.postalCode;
                                             claim.Email__c                   = otherinformationwrapper.userEmail;
                                             claim.Address_1__c               = userupdatedaddresswrapper.address1;   
                                             claim.Address_2__c               = userupdatedaddresswrapper.address2;
                                             claim.Country__c                 = userupdatedaddresswrapper.country;
                                             claim.State__c                   = userupdatedaddresswrapper.state; 
                                             claim.WOD_2__Account__c          = acc.Id;
                                             claim.Customer__c                = acc.Id;
                                             if( bu=='Roofing'){
                                             claim.Quantity__c                = claimwrapper.concernedSquare;
                                             claim.material_quantity__c       = claimwrapper.appliedSuare;
                                             }
                                             else{
                                                claim.Quantity__c             =claimwrapper.appliedSuare; 
                                             claim.material_quantity__c       = claimwrapper.concernedSquare;  
                                             }
                                             claim.Install_Date__c            = claimwrapper.installedDate;
                                             claim.Installation_Location__c   = claimwrapper.locationValue;
                                             claim.Installation_Location_other__c = claimwrapper.otherLocationValue;
                                             claim.Name_BL__c                 = claim.First_Name_BL__c +' '+claim.Last_Name_BL__c;
                                             if(null !=claimwrapper.concernDetails && '' !=claimwrapper.concernDetails && claimwrapper.concernDetails.length()>255){                         
                                                 claim.Nature_of_Problem__c       = claimwrapper.concernDetails.substring(0,244);
                                             }else{
                                                 claim.Nature_of_Problem__c       = claimwrapper.concernDetails;
                                             }
                                             if(null !=claimwrapper.productDetails && '' !=claimwrapper.productDetails && claimwrapper.productDetails.length()>255){
                                                 claim.Product_Detail__c = claimwrapper.productDetails.substring(0,244);    
                                             }else{
                                                 claim.Product_Detail__c  = claimwrapper.productDetails;
                                             } 
                                             claim.WOD_2__Claim_Status__c ='Pre-Claim';                         
                                             claim.SAP_Vendor_Number__c       = vendorSAPNumber.WOD_SAP_Vendor_Number__c;
                                             claim.RecordTypeId               = claimRecordType;
                                             /*
                                             List<sObject> territoryS = WOD_TerritoryManger.populateTMSiding(buildingupdatedwrapper.state,'',buildingupdatedwrapper.country, buildingupdatedwrapper.cityName);
                                             if(territoryS != null && territoryS.size() > 0){
                                                 id territoryId = territoryS[0].Id;
                                                 if(null !=territoryId){                         
                                                     claim.Territory__c=territoryId;
                                                     claim.Territory_Manager__c=WOD_TerritoryManger.returnTM(territoryId);
                                                 }    
                                             }   
                                             */
                                             //Added by Ashraf 
                                             WOD_TerritoryManger ctTM=new WOD_TerritoryManger();
                                             new WOD_ClaimTriggerHandler().calcSalesOrgonInsert(claim);
                                             if(claim.Business_Units__c == 'Roofing' || claim.Business_Units__c == 'Solar Solutions' || claim.Business_Units__c == 'Commercial Building & Infrastructure'){ //CER-211
                                                String zipCode=claim.Postal_Code_BL__c;
                                                if(claim.Postal_Code_BL__c != null && claim.Postal_Code_BL__c != ''){
                                                    if(claim.Postal_Code_BL__c.contains('-')){
                                                        String[] zip=claim.Postal_Code_BL__c.split('-');
                                                        zipCode=zip[0];
                                                    }
                                                }
                                                /*
                                                string strPropertyType=''; //CER-211
                                                if(bu == 'Roofing' || bu == 'Solar Solutions'){
                                                    strPropertyType ='Residential';
                                                }else if(bu == 'Commercial Building & Infrastructure'){
                                                    strPropertyType ='Commercial';
                                                }
                                                */
                                                List<String> resTM = New List<String>(); 
                                                //List<String> resTM=ctTM.populateTM(claim.State_BL__c,zipCode,claim.Property_Type__c,claim.Country_BL__c, claim.City_BL__C /*TECP-731*/);
                                                if(claim.Sales_Org__c!=null){
                                                    resTM=ctTM.populateTM(claim.State_BL__c,zipCode,'',claim.Country_BL__c, claim.City_BL__C /*TECP-731*/,claim.Sales_Org__c, claim.Division_Code__c);
                                                    if(resTM != null && resTM.size() > 0){
                                                        claim.Territory__c = resTM[0];
                                                        claim.Territory_Manager__c = resTM[1];
                                                    }
                                                    system.debug('Site resTM-- ' + resTM);
                                                }
                                                
                                             }
                                            //Added by Ashraf  CER-69
                                             if(bu == 'Siding' /*&& claim.Property_Type__c == 'Commercial'* CER-211*/ && (claim.Building_Type__c == null || claim.Building_Type__c == '')){
                                                claim.Building_Type__c = 'Other';
                                             }
                                             claim.Warranty_Registration_Type__c ='Standard';
                                             //Added by Raviteja
                                             if(claim.Product_Group__c != null && claim.Product_Group__c != ''){
                                                 WOD_CertainTeed_ShortTerm_Period__mdt deoMdt =  [SELECT MasterLabel, QualifiedApiName, WOD_Unit_of_Measure__c, WOD_Validity_Period__c FROM WOD_CertainTeed_ShortTerm_Period__mdt where MasterLabel=:claim.Product_Group__c LIMIT 1]; 
                                                 if(deoMdt != null){
                                                     claim.Unit_of_Measure__c = deoMdt.WOD_Unit_of_Measure__c;
                                                 }
                                             }
                                             //CER-92
                  String WarrantyRegistrationType = '';                            
                 if(claim.WOD_2__Claim_Type__c == 'Standard'){
                String WarrantyRegistrationResult = wod_CTUtil.warrantyRegistrationCreation(claim,'newStandard',null); 
                system.debug('------------WarrantyRegistrationResult---------'+WarrantyRegistrationResult);
                if(WarrantyRegistrationResult!=null && WarrantyRegistrationResult.contains('_')){
                    WarrantyRegistrationType = WarrantyRegistrationResult.split('_')[0];
                    claim.Warranty_Registration_Type__c = WarrantyRegistrationType;                    
                    if(WarrantyRegistrationResult.split('_')[1] == 'InWarranty')
                        claim.SureShort_Expiration__c = false;
                    else if(WarrantyRegistrationResult.split('_')[1] == 'OutOfWarranty')
                        claim.SureShort_Expiration__c = true;
                    
                    
                }
                else{
                    WarrantyRegistrationType = WarrantyRegistrationResult;
                    claim.Warranty_Registration_Type__c = 'Standard';
                }
                
            }
                //End
                insert claim;                              
                return serachClaim(claim.Id,'','','');                         
        }
    
    /**
* @description This method user for searching claim for Thank you page.We can reuse the method.
* @param  claimId Claim Id
* @param  claimnumber Claim Number
* @param  buildingLastName Building Last Name
* @param  buildingZipcode Building Zip Code
* @return WOD_2__Claim__c object
*/
    @AuraEnabled(cacheable=false)
    public static WOD_2__Claim__c serachClaim(String claimId,String claimnumber,string buildingLastName,String buildingZipcode){
        WOD_2__Claim__c claim = new WOD_2__Claim__c();
        String query= 'Select Id,WOD_2__Claim_Auto_Number__c,WOD_claimStatusTracking__c,WOD_2__BusinessCategory__c,WOD_2__BusinessCategory__r.Name,WOD_2__Claim_Status__c,First_Name__c,Last_Name__c,City__c,Phone__c,Name_BL__c,Tracking_Number__c,Install_Date__c,Nature_of_Problem__c,Organization__c,Zip_Code_Postal_Code__c,'+
            'Product_Group__c,Quantity__c,Product_Detail__c,Name,createdDate,LastModifiedDate,First_Name_BL__c,Last_Name_BL__c,material_quantity__c,'+
            'Postal_Code__c,Email__c,Address_1__c,Address_2__c,Country__c,State__c,Unit_of_Measure__c ,isDuplicate__c,Sales_Org__c,Installation_Location__c,'+
            'City_BL__c,State_BL__c,Phone_BL__c,Address_1_BL__c,Address_2_BL__c,Postal_Code_BL__c,Organization_BL__c,Business_Units__c,Division_Code__c,'+
            'Country_BL__c from WOD_2__Claim__c where Name !=\'\'';
        if(null != claimId && claimId !='' && claimId !='undefined'){
            query = query+' and Id=\'' + claimId +'\'';
        }
        if(null != claimnumber && claimnumber !='' && claimnumber !='undefined'){
            query = query = query+' and Name=\'' + claimnumber +'\'';
        }
        if(null != buildingLastName && buildingLastName !='' && buildingLastName !='undefined'){
            query = query = query+' and Last_Name_BL__c=\'' + buildingLastName +'\'';     
        }
        if(null != buildingZipcode && buildingZipcode !='' && buildingZipcode !='undefined'){
            query = query = query+' and Postal_Code_BL__c Like \'%' + buildingZipcode + '%\'';
        }
        query = query+' limit 1';
        return Database.query(query);
    }
    /**
* @description This method user get Picklist values
* @param  isSiding Flag for filter
* @return Picklist Wrapper
*/
//--------Commented for CER-211 Changes
    /*@AuraEnabled(cacheable=true)
    public static PicklistWrapper getAllPicklistValues(Boolean isSiding){
        PicklistWrapper pkWrapper = new PicklistWrapper();
        Map<String,List<String>> locationMap = new Map<String,List<String>>();
        if(isSiding){
            //pkWrapper.productGroup =new List<String>{'--None--','Siding','Fence','Rail','Decking','Windows','Millwork','Fiber Cement'}; 
            pkWrapper.productGroup = WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c','Business_Units__c','Product_Group__c',false).get('Siding');  
            locationMap.put('--None--',null);
            locationMap.put('Residential',new List<String>{'--None--','House','Barn','Attached Garage','Condominium/Townhouse','Detached Garage','Duplex','Perimeter Fence','Rental Property','Other'}); 
            locationMap.put('Commercial',new List<String>{'--None--','Commercial Building','Condominium/Townhouse','Perimeter Fence','Other'});
            pkWrapper.installedLocationMap = locationMap;
        }else{
            //pkWrapper.productGroup =new List<String>{'--None--','Roofing','Commercial Roofing','Metal Roofing','Solar','Ventilation'};    
            pkWrapper.productGroup = WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c','Business_Units__c','Product_Group__c',false).get('Roofing');    
            locationMap.put('--None--',null);
            locationMap.put('Single Family Home',new List<String>{'--None--','House','Attached Garage','Detached Garage','Barn','Rental Property','Other'}); 
            locationMap.put('Other',new List<String>{'--None--','Apartment','Church','Commercial Building – City/Town/Gov’t Building',
                'Commercial Building - Education','Commercial Building - Medical','Commercial Building – Retail','Commercial Building - Office/Manufacturing',
                'Condominium Association','Condominium/Townhouse','Duplex','Townhome Association','Other'});
            pkWrapper.installedLocationMap = locationMap;  
        }        
        return pkWrapper;        
    }*///--------Commented for CER-211 Changes
    @AuraEnabled(cacheable=true)
public static PicklistWrapper getAllPicklistValues(Boolean isSiding){
    PicklistWrapper pkWrapper = new PicklistWrapper();
    Map<String,List<String>> locationMap = new Map<String,List<String>>();
    list<string> divicodevals = new list<string>();
    if(isSiding){
        // Handle Siding
        pkWrapper.productGroup = WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c','Business_Units__c','Division_Code__c',false).get('Siding');  
        locationMap.put('--None--',null);
        locationMap.put('Single Family Home',new List<String>{'--None--','House','Barn','Attached Garage','Condominium/Townhouse','Detached Garage','Duplex','Perimeter Fence','Rental Property','Other'}); 
        locationMap.put('Other',new List<String>{'--None--','Commercial Building','Condominium/Townhouse','Perimeter Fence','Other'});
        pkWrapper.installedLocationMap = locationMap;
    } else {
        // Handle other cases
        pkWrapper.productGroup = WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c','Business_Units__c','Division_Code__c',false).get('Roofing');  
        List<String> roofingValues = pkWrapper.productGroup;
        divicodevals.addAll(roofingValues);

        pkWrapper.productGroup = WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c','Business_Units__c','Division_Code__c',false).get('Commercial Building & Infrastructure');    
        List<String> commercialValues = pkWrapper.productGroup;
        divicodevals.addAll(commercialValues);

        pkWrapper.productGroup = WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c','Business_Units__c','Division_Code__c',false).get('Solar Solutions');   
        List<String> solarValues = pkWrapper.productGroup;
        divicodevals.addAll(solarValues);
        if(divicodevals.size()>0){
            pkWrapper.productGroup = divicodevals;    
        }
        locationMap.put('--None--',null);
        locationMap.put('Single Family Home',new List<String>{'--None--','House','Attached Garage','Detached Garage','Barn','Rental Property','Other'}); 
        locationMap.put('Other',new List<String>{'--None--','Apartment','Church','Commercial Building – City/Town/Gov’t Building',
            'Commercial Building - Education','Commercial Building - Medical','Commercial Building – Retail','Commercial Building - Office/Manufacturing',
            'Condominium Association','Condominium/Townhouse','Duplex','Townhome Association','Other'});
        pkWrapper.installedLocationMap = locationMap;  
    }        
    return pkWrapper;        
}
//--------CER-211- claim and warranty Sites--
        @AuraEnabled(cacheable=true)
        public static List<WOD_2__Business_Category_Configuration__c> getroofingBCCRecords(Boolean isSiding) {
            List<WOD_2__Business_Category_Configuration__c> lstBCC = new List<WOD_2__Business_Category_Configuration__c>();
            if(isSiding){
                lstBCC = [SELECT Id, Name FROM WOD_2__Business_Category_Configuration__c WHERE Name = 'Siding' ORDER BY Name];
                System.debug('Siding Fetched Records: ' + lstBCC);
            }else{
                lstBCC = [SELECT Id, Name FROM WOD_2__Business_Category_Configuration__c WHERE Name != 'Siding' ORDER BY Name];
                System.debug('Roofing Fetched Records: ' + lstBCC);
            }
            return lstBCC;
        }
  //---------**--END CER-211- claim and warranty Sites--**---

    /**
* @description This method user get Installation Location Picklist values
* @param  buType Roofing/Siding
* @return Picklist Wrapper
*/
    /*@AuraEnabled(cacheable=true)
    public static PicklistWrapper getInstallLocationPicklistValues(String buType){
        PicklistWrapper pkWrapper = new PicklistWrapper();
        Map<String,List<String>> locationMap = new Map<String,List<String>>();
        if(buType=='Siding'){
            locationMap.put('Residential',new List<String>{'Single Family Home','Barn','Detached Garage','Duplex','Garage','Rental Property','Condominium/Townhouse' ,'Perimeter Fence','Other'}); 
            locationMap.put('Commercial',new List<String>{'Commercial Building','Condominium/Townhouse','Other','Perimeter Fence'});
            pkWrapper.installedLocationMap = locationMap;
        }else{
            locationMap.put('Residential',new List<String>{'Single Family Home','Condominium/Townhouse','Barn','Detached Garage','Duplex','Garage','Rental Property','Other'}); 
            locationMap.put('Commercial',new List<String>{'Barn','Commercial Building','Other'});
            
            pkWrapper.installedLocationMap = locationMap;  
        }        
        return pkWrapper;        
    }*/
    //------CER-211------------
        @AuraEnabled(cacheable=true)
        public static PicklistWrapper getInstallLocationPicklistValues(String buType){
        PicklistWrapper pkWrapper = new PicklistWrapper();
        Map<String,List<String>> locationMap = new Map<String,List<String>>();
        if(buType=='Roofing' || buType=='Commercial Building & Infrastructure' || buType=='Solar Solutions'){
            locationMap.put('Single Family Home',new List<String>{'Single Family Home','Condominium/Townhouse','Barn','Detached Garage','Duplex','Garage','Rental Property','Other'}); 
            locationMap.put('Other',new List<String>{'Barn','Commercial Building','Other'});
            pkWrapper.installedLocationMap = locationMap;  
        }else{
            locationMap.put('Single Family Home',new List<String>{'Single Family Home','Barn','Detached Garage','Duplex','Garage','Rental Property','Other','Condominium/Townhouse' ,'Perimeter Fence'}); 
            locationMap.put('Other',new List<String>{'Commercial Building','Other','Condominium/Townhouse' ,'Perimeter Fence'});
            pkWrapper.installedLocationMap = locationMap;
        }        
        return pkWrapper;        
    }
    //-----------CER-211-------END---------
    /**
* @description This method user get loggedin user information.
* @return User object
*/
    @AuraEnabled(cacheable=false)
    public static User getCurrentUser(){
        return [Select id,Name,ProfileId,Profile.Name from User where id=: Userinfo.getUserId()];   
    } 
    
    /**
* @description This method user get ZipFile information.
* @param businessUnit Roofing/Siding
* @return List of WOD_ZipFile__c object
*/
    @AuraEnabled(cacheable=true)
    public static List<WOD_ZipFile__c> getZipFileRecords(String businessUnit){
       /*List<WOD_ZipFile__c> resultList = new List<WOD_ZipFile__c>();
        List<WOD_ZipFile__c> resultList2 = new List<WOD_ZipFile__c>();
        List<WOD_ZipFile__c> zipFileslist = [Select id,Name,Name__c,Priority__c,Roofing_Id__c,Siding_Id__c,Status__c from WOD_ZipFile__c where Status__c = true and Business_Unit__c =:businessUnit];
        for(WOD_ZipFile__c zipFile : zipFileslist){
            if(zipFile.Business_Unit__c == 'Roofing'){
                if(zipFile.Name == 'Standard Claim Form and Instructions'){
                    resultList.add(zipFile);
                }else{
                    resultList2.add(zipFile);
                }
            }else{
                resultList.add(zipFile);
            }
        }
        if(resultList2.size()>0){
            resultList.addAll(resultList2);
        }*/
        return [Select id,Name,Name__c,Priority__c,Roofing_Id__c,Siding_Id__c,Status__c from WOD_ZipFile__c where Status__c = true and Business_Unit__c =:businessUnit];
  } 
    /**
* @description This method used for get Information for downloadable file
* @param claimTrackingId Claim Id
* @param frmName Zip file name
* @param businessUnit Roofing/Siding
* @return downLoadWrapper Wrapper
*/
    @AuraEnabled
    public static downLoadWrapper downloadFile(String claimTrackingId , String frmName , String businessUnit)
    {
        Map<string,Certain_Teed__c> CertainTeed = Certain_Teed__c.getAll(); 
        List<WOD_ZipFile__c> formList = [Select Id,Name from WOD_ZipFile__c where Status__c=true and Name = :frmName and Business_Unit__c =:businessUnit ORDER BY priority__c];  
        String downloadURL =null;
        String formName ;
        WOD_2__Claim__c claim = new WOD_2__Claim__c();
        Id ClaimNumber ;
        boolean modalRender = false;
        boolean isSiding = false; // = CertainTeed.get('isSiding').BooleanValue__c;
        boolean isRoofing =false;//= CertainTeed.get('isRoofing').BooleanValue__c;   
        Boolean EnablePoller = false;
        //String formId ='a192800000112Mc'; 
        if(!formList.isEmpty())
            formName=formList[0].Name;
        /* if(isSiding){
UnitsOfMeasure='Affected Quantity';
}
if(isRoofing){
UnitsOfMeasure='Number of Squares Affected by Concern';
}*/      
        if(claimTrackingId !='' && claimTrackingId !=null)
        {
            claim=[select First_Name__c,Last_Name__c,City__c,Phone__c,Business_Units__c,Name_BL__c,Tracking_Number__c,Install_Date__c,Nature_of_Problem__c,Organization__c,Zip_Code_Postal_Code__c,
                   Product_Group__c,Quantity__c,Product_Detail__c, WOD_2__Claim_Status__c,Name,createdDate,First_Name_BL__c,Last_Name_BL__c,material_quantity__c,
                   Postal_Code__c,Email__c,Address_1__c,Address_2__c,Country__c,State__c,Unit_of_Measure__c ,
                   City_BL__c,State_BL__c,Phone_BL__c,Address_1_BL__c,Address_2_BL__c,Postal_Code_BL__c,Division_Code__c,
                   Country_BL__c  from WOD_2__Claim__c where Id=:claimTrackingId];
            if(claim != null && claim.Business_Units__c == 'Roofing'){
                isRoofing = true ;
            }else if(claim != null && claim.Business_Units__c == 'Siding'){
                isSiding =true;
            }
        }
        system.debug('===========>claim.Product_Group__c'+claim.Product_Group__c);
        if (claim.Division_Code__c != null && isSiding) {
            if (claim.Division_Code__c == 'SPG Polymer Shakes' || 
                claim.Division_Code__c == 'SPG CT Siding' ||
                claim.Division_Code__c == 'SPG Wolverine Siding' ||
                claim.Division_Code__c == 'SPG Stone' ||
                claim.Division_Code__c == 'SPG Hardboard Siding' ||
                claim.Division_Code__c == 'SPG CT Metal') {
                formName = 'Vinyl Siding Claim Form';
            }
            else if (claim.Division_Code__c == 'SPG Millwork') {
                formName = 'Millwork Trim Claim Form';
            }
            else if (claim.Division_Code__c == 'Fiber Cement') {
                formName = 'Fiber Cement Claim Form';
            }
            else if (claim.Division_Code__c == 'Windows') {
                formName = 'Windows Claim Form';
            }
        }
        //formName='Vinyl Siding Claim Form.docx';
        //claim.Id='a062800000BEiIZ';
        ClaimNumber=claim.Id;
        /* try{
downloadURL=[select Id,DistributionPublicUrl from ContentDistribution where Name=:formName+'.docx' and RelatedRecordId=:ClaimNumber LIMIT 1].DistributionPublicUrl;     
modalRender=true;
EnablePoller=true;
system.debug('downloadURL-->'+downloadURL);
}
catch(exception e){
modalRender=true;
EnablePoller=true;
wod_zipperFuture.sendMail(formName,claim.Id);
}*/
        downLoadWrapper dw = new downLoadWrapper();
        dw.modalRender = true;
        dw.ClaimNumber = ClaimNumber;
        dw.downloadURL = downloadURL;
        dw.formName = formName;
        dw.EnablePoller = true;
        List<ContentDistribution> cdList = [select Id,DistributionPublicUrl from ContentDistribution where Name=:formName+'.docx' and RelatedRecordId=:ClaimNumber LIMIT 1];
        if(cdList.size() > 0){
            downloadURL = cdList[0].DistributionPublicUrl;
            dw.downloadURL = downloadURL;
            return dw;
        }else{
            wod_zipperFuture.sendMail(formName,claim.Id);
            downLoadWrapper dwc = actionPoller(dw);
            dw = dwc;
            return dw;
        }
        
        
    }
    /**
* @description This method used for get Information for downloadable file
* @param dw downLoadWrapper Wrapper
* @return downLoadWrapper Wrapper
*/
    @AuraEnabled    
    public static downLoadWrapper actionPoller(downLoadWrapper dw)
    {  
        /* system.debug('downLoadWrapper111'+dw1);
JSONParser parser = JSON.createParser(dw1);
downLoadWrapper dw = (downLoadWrapper)parser.readValueAs(downLoadWrapper.class);
system.debug('modalRender outside try'+dw.modalRender);
system.debug('downLoadWrapper'+dw);*/
        Id ContentDistributionId;
        String formName;
        String downloadURL;
        boolean modalRender;
        List<WOD_ZipFile__c> formList ;
        boolean EnablePoller;
        downLoadWrapper dlw = new downLoadWrapper();
        try{
            system.debug('formName-->'+dw.formName);
            system.debug('ClaimNumber'+dw.ClaimNumber);            
            Id AttachmentId=[select Id,Name from Attachment where ParentId=:dw.ClaimNumber and name =:dw.formName+'.docx' LIMIT 1].Id;            
            system.debug('AttachmentId'+AttachmentId); 
            system.debug('modalRender outside 1st'+dw.modalRender);
            
            if(AttachmentId!=null){
                dlw.downLoadFileStatus = true;
                Attachment att=[Select Id,body from Attachment where Id=:AttachmentId];
                ContentDistribution cd=new ContentDistribution();
                try{
                    ContentDistributionId=[select Id,DistributionPublicUrl from ContentDistribution where Name=:dw.formName+'.docx' and RelatedRecordId=:dw.ClaimNumber LIMIT 1].Id; 
                }
                catch(exception e){
                    if(ContentDistributionId==null){      
                        formName=dw.formName+'.docx';
                        ContentVersion content = new ContentVersion();
                        content.versionData = att.body;
                        content.title = formName;
                        content.pathOnClient = formName;
                        System.debug('DMLLimitis***** ' + Limits.getDMLStatements() );
                        insert content;                                    
                        cd.ContentVersionId=content.Id;
                        cd.PreferencesAllowPDFDownload=true;
                        cd.Name=formName;
                        cd.RelatedRecordId=dw.ClaimNumber;
                        cd.PreferencesAllowOriginalDownload=false;
                        cd.PreferencesNotifyOnVisit=false;
                        insert cd;
                        ContentDistributionId=cd.Id;                    
                    }
                }
                if(ContentDistributionId!=null){
                    system.debug('ContentDistributionId-->'+ContentDistributionId);
                    cd=[select Id,DistributionPublicUrl from ContentDistribution where Id=:ContentDistributionId];
                    downloadURL=cd.DistributionPublicUrl;
                    ContentDistributionId=null;
                    system.debug('DistributionPublicUrl' + cd.DistributionPublicUrl);
                }
            }
            if(AttachmentId!=null &&  modalRender==true)
            {                
                modalRender=false;
                dlw.downLoadFileStatus = true;
                system.debug('modalRender inside 1st'+modalRender);
                //return null;
            }
            system.debug('modalRender outside 2nd'+modalRender);
            if(AttachmentId!=null)
            {
                modalRender=false;
                dlw.downLoadFileStatus = true;
                EnablePoller=false;
                system.debug('modalRender inside 2nd'+modalRender);
                formList=[Select Id,Name from WOD_ZipFile__c where Status__c=true];
                if(!formList.isEmpty())
                    formName=formList[0].Name;
                // PageReference pg=new PageReference('/servlet/servlet.FileDownload?file='+AttachmentId);
                // pg.setRedirect(false);                
                // return pg;
                //return null;
            }
        }
        catch(Exception e){
            modalRender=true;
            dlw.downLoadFileStatus = false;
            //return null;
        }
        
        dlw.modalRender = modalRender;
        dlw.downloadURL = downloadURL;
        dlw.formName = formName;
        dlw.EnablePoller = EnablePoller;
        return dlw;
        //return null;
    }
    /**
* @description Wrapper Class for Picklist Value
*/
    public class PicklistWrapper{
        @AuraEnabled
        public List<String> productGroup;
        @AuraEnabled
        public Map<String,List<String>> installedLocationMap;
    }
    /**
* @description Wrapper Class for download Value
*/
    public class downLoadWrapper{
        @AuraEnabled
        public Boolean  modalRender;
        @AuraEnabled
        public String  formName;
        @AuraEnabled
        public String  downloadURL;
        @AuraEnabled
        public String  ClaimNumber;
        @AuraEnabled
        public Boolean  EnablePoller;
        @AuraEnabled
        public Boolean  downLoadFileStatus = true;
    }      
}