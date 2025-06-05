/**
 * @description Perform action on Warranty Registration and Transfer
*/
public class WOD_CTWRInternalController {

    /**
     * @description Picklist Wrapper
    */
    public class PicklistWrapper{
        @AuraEnabled
        public List<String> productGroup;
        @AuraEnabled
        public Map<String,List<String>> installedLocationMap;
    } 
    /**
     * @description This method used to get Install Location Picklist Values
     * @param buType Business unit Siding/Roofing
     * @return Wrapper
    */   
    /*@AuraEnabled(cacheable=true)
    public static PicklistWrapper getInstallLocationPicklistValuesWT(String buType){
        PicklistWrapper pkWrapper = new PicklistWrapper();
        Map<String,List<String>> locationMap = new Map<String,List<String>>();
        if(buType=='Siding'){
            locationMap.put('Residential',new List<String>{'Single Family Home','Barn','Detached Garage','Duplex','Garage','Rental Property','Other','Condominium/Townhouse' ,'Perimeter Fence'}); 
            locationMap.put('Commercial',new List<String>{'Commercial Building','Other','Condominium/Townhouse' ,'Perimeter Fence'});
            pkWrapper.installedLocationMap = locationMap;
        }else{
            locationMap.put('Residential',new List<String>{'Single Family Home','Condominium/Townhouse','Barn','Detached Garage','Duplex','Garage','Rental Property','Other'}); 
            locationMap.put('Commercial',new List<String>{'Barn','Commercial Building','Other'});
            
            pkWrapper.installedLocationMap = locationMap;  
        }        
        return pkWrapper;        
    }*/
    //------------CER-211---------------
        @AuraEnabled(cacheable=true)
        public static PicklistWrapper getInstallLocationPicklistValuesWT(String buType){
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
    //--------------CER-211-------END--------
    /**
     * @description This method used to get Warranty Registration of Record Type
     * @return List of Warranty Registration Record Type
    */ 
    @AuraEnabled
    public static  List<String>  WRegRecordType(){
        List<String> RecordTypeResult =  new List<String>();
        List<RecordType> RecordTypeList = [Select Id , Name From RecordType  Where SobjectType = 'WOD_2__Warranty_Registration__c' and isActive=true];
        system.debug(' RecordTypeList'+ RecordTypeList);
        WOD_2__Configuration_Setting__mdt extendedWRAllow   = [select id, Label, WOD_2__isActive__c from WOD_2__Configuration_Setting__mdt where DeveloperName = 'DisplayExtendedWRonWRNew'];
        System.debug('extendedWRAllow  ' + extendedWRAllow);
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        System.debug('profileName ' + profileName);
        
        if(RecordTypeList.size() >0)
        { 
            for (RecordType fieldName : RecordTypeList){
                if(extendedWRAllow.WOD_2__isActive__c && profileName=='System Administrator' ){
                    if(fieldName.Name != 'Master'){
                        RecordTypeResult.add(fieldName.Name);
                        System.debug('field name is ' + fieldName.Name);
                    } 
                }else{
                    if(fieldName.Name != 'Master' && fieldName.Name !='Extended Warranty Registration'){
                        RecordTypeResult.add(fieldName.Name);
                        System.debug('field name is ' + fieldName.Name);
                    }
                }
                
                
            }
        }    
        RecordTypeResult.sort();
        system.debug('******'+RecordTypeResult);
        return RecordTypeResult;
    }
    /**
     * @description This method used to get Warranty Transfer of Record Type
     * @return List of Warranty Transfer Record Type
    */ 
    @AuraEnabled
    public static  List<String>  WTegRecordType(){
        List<String> RecordType =  new List<String>();
        Schema.DescribeSObjectResult d = Schema.SObjectType.WOD_Warranty_Transfer__c; 
        Map<String,Schema.RecordTypeInfo> rtMapByName = d.getRecordTypeInfosByName();
        
        for (String fieldName : rtMapByName.keySet()){
            if(fieldName != 'Master'){
                RecordType.add(fieldName);
                System.debug('field name is ' + fieldName);
            }
            
        }
        RecordType.sort();
        system.debug('******'+RecordType);
        return RecordType;
    }
    /**
     * @description This method used to get Sales Org picklist values
     * @return List of BU
    */ 
    @AuraEnabled
    public static List<String> getSalesOrgPickList(){
        List<String> result = new List<String>(); Id userId = UserInfo.getUserId();
        List<User> userSalesOrgeList = [SELECT Id, Sales_Org__c FROM User where id=:userId] ;
        if(userSalesOrgeList.size() != 0){
            try{
                String userSalesOrgeValue =userSalesOrgeList[0].Sales_Org__c;
                List<String> SalesOrgePickList = userSalesOrgeValue.split(';');
                List<String> BussinessUnitPicklist = new  List<String>();
                
                for(String  salesOrgValue : SalesOrgePickList){
                    if( salesOrgValue =='1502' || salesOrgValue =='1018' || salesOrgValue =='1019' || salesOrgValue =='1020'){ //CER-230
                        BussinessUnitPicklist.add('Siding');
                    }else if(salesOrgValue =='1501' || salesOrgValue =='1111' || salesOrgValue =='1021'){
                        BussinessUnitPicklist.add('Roofing');
                        BussinessUnitPicklist.add('Solar Solutions');
                        BussinessUnitPicklist.add('Commercial Building & Infrastructure');
                    }
                }
                Set<String> myset = new Set<String>();
                myset.addAll(BussinessUnitPicklist);
                result.addAll(myset);
                result.sort();
                system.debug('Reverse result'+result);
            }
            catch (System.NullPointerException e){
                
            }
        } 
        system.debug('result'+result);
        return result;
    }
    /**
     * @description This method used to get BCC Records
     * @param BUName Business unit Siding/Roofing
     * @return List of BCC
    */ 
    @AuraEnabled
    public static List<WOD_2__Business_Category_Configuration__c> getBCCRecords( String BUName){
        List<WOD_2__Business_Category_Configuration__c> lstBCC;
        lstBCC = [select id,Name from WOD_2__Business_Category_Configuration__c  where  Name =:BUName];
        return lstBCC;
    }
    /**
     * @description This method used to Submit Warranty Registration
     * @param mailingWrapper User Mailng Address
     * @param buildingWrapper User Building Address
     * @param productInfoWrapper Product Information
     * @param selectedRecordType Warranty Registration Record Type
     * @param BUType Business unit Siding/Roofing
     * @param isEdit Flag for Edit Action
     * @param WRid Warranty Registration Id
     * @return Wrapper 
    */
    @AuraEnabled
    public Static ResponseWrapper WRSubmit(mailingSectionWrapper mailingWrapper ,buildingSectionWrapper buildingWrapper ,
                                           productInformationSectionWrapper  productInfoWrapper, String selectedRecordType ,String BUType ,String selecteddivision,boolean isEdit ,String WRid )
    {
        
        mailingSectionWrapper  mailingWrapperResult = new mailingSectionWrapper();
        mailingWrapperResult = mailingWrapper;
        
        // Building Section Wrapper
        buildingSectionWrapper  buildingWrapperResult = new buildingSectionWrapper();
        buildingWrapperResult = buildingWrapper;
        
        // Product Information Section Wrapper
        productInformationSectionWrapper  productInfoWrapperResult = new productInformationSectionWrapper();
        productInfoWrapperResult = productInfoWrapper;        
        
        String WRTrackingNumber ;
        String RecordID;
        
        ResponseWrapper response=new ResponseWrapper('',false,'');
        WOD_2__Business_Category_Configuration__c BUId =  [SELECT Id, Name FROM WOD_2__Business_Category_Configuration__c where Name=: BUType ];
        Id devRecordTypeId;
        string selectedRegistartionType = '';
        if(!isEdit){
            if( selectedRecordType =='Residential')
            {             
                devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='Residential' and SobjectType='WOD_2__Warranty_Registration__c' limit 1].Id;
                selectedRegistartionType = 'Standard Registration' ;
            }
            /*if( selectedRecordType =='Commercial')
            {
                devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='Commercial' and SobjectType='WOD_2__Warranty_Registration__c' limit 1].Id;
            }*/
            
            if( selectedRecordType =='International')
            {             
                devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='International' and SobjectType='WOD_2__Warranty_Registration__c' limit 1].Id;
                selectedRegistartionType = selectedRecordType;
            }
            
            if( selectedRecordType =='Extended Warranty Registration')
            {             
                devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='SSP_Warranty_Registration' and SobjectType='WOD_2__Warranty_Registration__c' limit 1].Id;
                selectedRegistartionType = selectedRecordType;
            }
            
            
            WOD_2__Warranty_Registration__c  wr = new WOD_2__Warranty_Registration__c();
            String quantitValue = ((productInfoWrapper.quantity) == null ? '0':(productInfoWrapper.quantity));
            String unitOfMeasure = ((productInfoWrapper.productUnitOfmeasure) == null ? '0':(productInfoWrapper.productUnitOfmeasure));
            
            try{
                wr.RecordTypeId = devRecordTypeId;
                // mailing  field value
                wr.Name   =    mailingWrapper.firstName;
                wr.Last_Name__c      =    mailingWrapper.lastName;
                wr.Address_1__c     =    mailingWrapper.address1;
                wr.Address_2__c     =    mailingWrapper.address2;
                wr.City__c     =    mailingWrapper.cityName;
                wr.State__c     =    mailingWrapper.state;
                wr.Postal_Code__c     =    mailingWrapper.postalCode;
                wr.Country__c     =    mailingWrapper.country;
                wr.Email__c     =    mailingWrapper.emailVal;
                wr.Phone__c     =    mailingWrapper.phoneVal;
                wr.Organisation__c = mailingWrapper.organizationMailing;
                wr.Is_New_Construction_Mailing_Address__c = Boolean.valueOf(mailingWrapper.IsNewConstructionMailingAddress);
                
                // building field value
                
                //wr.Property_Type__c     =       buildingWrapper.selectedPropertyType; 
                wr.Building_Type__c     =    buildingWrapper.selectedBuildingType ;
                wr.Organisation_BL__c     =    buildingWrapper.organizationBuilding;
                wr.First_Name_BL__c    =    buildingWrapper.firstName;
                wr.Last_Name_BL__c     =    buildingWrapper.lastName;
                wr.Address_1_BL__c     =    buildingWrapper.address1;
                wr.Address_2_BL__c     =    buildingWrapper.address2;
                wr.City_BL__c     =    buildingWrapper.cityName;
                wr.State_BL__c     =    buildingWrapper.state;
                wr.Postal_Code_BL__c     =    buildingWrapper.postalCode;
                wr.Country_BL__c     =    buildingWrapper.country;
                wr.Is_New_Construction__c = Boolean.valueOf(buildingWrapper.IsNewConstruction);
                
                // product info field  value
                wr.Install_Date__c    =    date.valueOf(productInfoWrapper.selectedInstallDate);
                wr.Product_Group__c     =    productInfoWrapper.selectedProductGroup;
                wr.Division__c         =     productInfoWrapper.selecteddivision; //CER-211
                wr.Product_Detail__c    =    productInfoWrapper.productDetailVal;
                wr.Quantity__c    =      decimal.valueOf(quantitValue);
                wr.Unit_of_Measure__c = productInfoWrapper.productUnitOfmeasure;
                wr.installation_Location__c     =    productInfoWrapper.selectedInstallationLoc;
                wr.Installation_Location_other__c =  productInfoWrapper.otherInstallationLocation;
                
                // Validation field  value
                wr.Business_Category_Configuration__c =  BUId.id;
                wr.Business_Units__c  = BUType ;
                wr.WOD_2__Registration_Date__c = date.valueOf(productInfoWrapper.selectedRegistrationDate) ; //date.today();   // productInfoWrapper.selectedRegistrationDate
                wr.WOD_2__Registration_Type__c = selectedRegistartionType;

                insert wr;
                RecordID = wr.Id;
                system.debug('RecordID ::'+RecordID);
                WOD_2__Warranty_Registration__c  wrTackingNumber = [select id,WR_Tracking_Number__c from WOD_2__Warranty_Registration__c where Id=:wr.Id]; 
                WRTrackingNumber =wrTackingNumber.WR_Tracking_Number__c;
                response.data=''+RecordID;
                response.status=true;
                
            }catch(Exception ex){
                system.debug('Exception  Occured ::'+ex.getMessage());
                response.status=false;
                response.errormessage=ex.getMessage();
            } 
        }
        else{
            String quantitValue = ((productInfoWrapper.quantity) == null ? '0':(productInfoWrapper.quantity));
            if(WRid != null && WRid != '')
            {
                WOD_2__Warranty_Registration__c warrantyRegistration=  [SELECT 
                                                                        RecordTypeId,
                                                                        RecordType.Name,
                                                                        
                                                                        Name,Last_Name__c,
                                                                        Address_1__c,Address_2__c,
                                                                        City__c,State__c,
                                                                        Postal_Code__c,Country__c,
                                                                        Email__c,Phone__c,
                                                                        Organisation__c,Is_New_Construction_Mailing_Address__c,
                                                                        
                                                                        Property_Type__c,Building_Type__c,
                                                                        Organisation_BL__c,Is_New_Construction__c,
                                                                        First_Name_BL__c,Last_Name_BL__c,
                                                                        Address_1_BL__c,Address_2_BL__c,
                                                                        City_BL__c,State_BL__c,
                                                                        Postal_Code_BL__c,Country_BL__c,
                                                                        
                                                                        Install_Date__c,Product_Group__c,
                                                                        Product_Detail__c,installation_Location__c,
                                                                        Quantity__c,Unit_of_Measure__c,
                                                                        Installation_Location_other__c,WOD_2__Registration_Date__c,
                                                                        
                                                                        Business_Category_Configuration__c,Business_Units__c 
                                                                        
                                                                        from WOD_2__Warranty_Registration__c  WHERE Id =: WRid];
                
                try{
                    warrantyRegistration.Name   =    mailingWrapper.firstName;
                    warrantyRegistration.Last_Name__c      =    mailingWrapper.lastName;
                    warrantyRegistration.Address_1__c     =    mailingWrapper.address1;
                    warrantyRegistration.Address_2__c     =    mailingWrapper.address2;
                    warrantyRegistration.City__c     =    mailingWrapper.cityName;
                    warrantyRegistration.State__c     =    mailingWrapper.state;
                    warrantyRegistration.Postal_Code__c     =    mailingWrapper.postalCode;
                    warrantyRegistration.Country__c     =    mailingWrapper.country;
                    warrantyRegistration.Email__c     =    mailingWrapper.emailVal;
                    warrantyRegistration.Phone__c     =    mailingWrapper.phoneVal;
                    warrantyRegistration.Organisation__c = mailingWrapper.organizationMailing;
                    warrantyRegistration.Is_New_Construction_Mailing_Address__c = Boolean.valueOf(mailingWrapper.IsNewConstructionMailingAddress);
                    
                    warrantyRegistration.Building_Type__c     =    buildingWrapper.selectedBuildingType ;
                    warrantyRegistration.Organisation_BL__c     =    buildingWrapper.organizationBuilding;
                    warrantyRegistration.First_Name_BL__c    =    buildingWrapper.firstName;
                    warrantyRegistration.Last_Name_BL__c     =    buildingWrapper.lastName;
                    warrantyRegistration.Address_1_BL__c     =    buildingWrapper.address1;
                    warrantyRegistration.Address_2_BL__c     =    buildingWrapper.address2;
                    warrantyRegistration.City_BL__c     =    buildingWrapper.cityName;
                    warrantyRegistration.State_BL__c     =    buildingWrapper.state;
                    warrantyRegistration.Postal_Code_BL__c     =    buildingWrapper.postalCode;
                    warrantyRegistration.Country_BL__c     =    buildingWrapper.country;
                    warrantyRegistration.Is_New_Construction__c = Boolean.valueOf(buildingWrapper.IsNewConstruction);
                    
                    
                    warrantyRegistration.Install_Date__c    =    date.valueOf(productInfoWrapper.selectedInstallDate);
                    warrantyRegistration.Product_Group__c     =    productInfoWrapper.selectedProductGroup;
                     warrantyRegistration.Division__c         =     productInfoWrapper.selecteddivision; //CER-211
                    warrantyRegistration.Product_Detail__c    =    productInfoWrapper.productDetailVal;
                    warrantyRegistration.Quantity__c    =      decimal.valueOf(quantitValue);
                    warrantyRegistration.Unit_of_Measure__c = productInfoWrapper.productUnitOfmeasure;
                    warrantyRegistration.installation_Location__c     =    productInfoWrapper.selectedInstallationLoc;
                    warrantyRegistration.Installation_Location_other__c =  productInfoWrapper.otherInstallationLocation;
                    warrantyRegistration.WOD_2__Registration_Date__c = date.valueOf(productInfoWrapper.selectedRegistrationDate) ;
                    update warrantyRegistration;
                    RecordID = warrantyRegistration.Id;
                    response.data=''+RecordID;
                    response.status=true;
                    
                }
                catch(Exception ex){
                    system.debug('Exception  Occured ::'+ex.getMessage());
                    response.status=false;
                    response.errormessage=ex.getMessage();
                }  
            }
        } 
        return response;
    }
    /**
     * @description This method used to Submit Warranty Transfer
     * @param mailingWrapper User Mailng Address
     * @param buildingWrapper User Building Address
     * @param productInfoWrapper Product Information
     * @param selectedRecordType Warranty Transfer Record Type
     * @param BUType Business unit Siding/Roofing
     * @param isEdit Flag for Edit Action
     * @param WTid Warranty Transfer Id
     * @return Wrapper 
    */
    @AuraEnabled
    public Static ResponseWrapper WTSubmit(mailingSectionWrapper mailingWrapper ,buildingSectionWrapper buildingWrapper ,
                                           productInformationSectionWrapper  productInfoWrapper, String selectedRecordType ,String BUType ,boolean isEdit ,String WTid  )
    {
        
        ResponseWrapper response=new ResponseWrapper('',false,'');  
        mailingSectionWrapper  mailingWrapperResult = new mailingSectionWrapper();
        mailingWrapperResult = mailingWrapper;
        
        // Building Section Wrapper
        buildingSectionWrapper  buildingWrapperResult = new buildingSectionWrapper();
        buildingWrapperResult = buildingWrapper;
        
        // Product Information Section Wrapper
        productInformationSectionWrapper  productInfoWrapperResult = new productInformationSectionWrapper();
        productInfoWrapperResult = productInfoWrapper;        
        
        String WTName ;
        String RecordID;   
        WOD_2__Business_Category_Configuration__c BUId =  [SELECT Id, Name FROM WOD_2__Business_Category_Configuration__c where Name=: BUType ];
        Id devRecordTypeId;
        
        // if( selectedRecordType =='Residential')
        // {             
            devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='Residential' and SobjectType='WOD_Warranty_Transfer__c' limit 1].Id;
        /*}
        else
        {
            devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='Commercial' and SobjectType='WOD_Warranty_Transfer__c' limit 1].Id;
        }*/
        
        WOD_Warranty_Transfer__c  wt = new WOD_Warranty_Transfer__c();
        String quantitValue = ((productInfoWrapper.quantity) == null ? '0':(productInfoWrapper.quantity));
        String unitOfMeasure = ((productInfoWrapper.productUnitOfmeasure) == null ? '0':(productInfoWrapper.productUnitOfmeasure));
        
        if(!isEdit){
            try{
                wt.RecordTypeId = devRecordTypeId;
                // mailing  field value
                wt.First_Name__c   =    mailingWrapper.firstName;
                wt.Last_Name__c      =    mailingWrapper.lastName;
                wt.Address_1__c     =    mailingWrapper.address1;
                wt.Address_2__c     =    mailingWrapper.address2;
                wt.City__c     =    mailingWrapper.cityName;
                wt.State__c     =    mailingWrapper.state;
                wt.Postal_Code__c     =    mailingWrapper.postalCode;
                wt.Country__c     =    mailingWrapper.country;
                wt.Email__c     =    mailingWrapper.emailVal;
                wt.Phone__c     =    mailingWrapper.phoneVal;
                wt.Organisation__c     =    mailingWrapper.organizationMailing;
                wt.Is_New_Construction_Mailing_Address__c = Boolean.valueOf(mailingWrapper.IsNewConstructionMailingAddress);
                
                // building field value
                
                //wt.Property_Type__c     =       buildingWrapper.selectedPropertyType; 
                wt.Building_Type__c     =    buildingWrapper.selectedBuildingType ;
                wt.Organisation_BL__c     =    buildingWrapper.organizationBuilding;
                wt.First_Name_BL__c    =    buildingWrapper.firstName;
                wt.Last_Name_BL__c     =    buildingWrapper.lastName;
                wt.Address_1_BL__c     =    buildingWrapper.address1;
                wt.Address_2_BL__c     =    buildingWrapper.address2;
                wt.City_BL__c     =    buildingWrapper.cityName;
                wt.State_BL__c     =    buildingWrapper.state;
                wt.Postal_Code_BL__c     =    buildingWrapper.postalCode;
                wt.Country_BL__c     =    buildingWrapper.country;
                wt.Is_New_Construction__c = Boolean.valueOf(buildingWrapper.IsNewConstruction);
                wt.Install_Date__c    =    date.valueOf(productInfoWrapper.selectedInstallDate);
                wt.Transfered_Date__c    =    date.valueOf(productInfoWrapper.selectedTransferDate);
                wt.Product_Group__c     =    productInfoWrapper.selectedProductGroup;
                wt.Division__c         =     productInfoWrapper.selecteddivision; //CER-211
                wt.Product_Detail__c    =    productInfoWrapper.productDetailVal;
                wt.Quantity__c    =      decimal.valueOf(quantitValue);
                wt.Unit_of_Measure__c = productInfoWrapper.productUnitOfmeasure;
                wt.installation_Location__c     =    productInfoWrapper.selectedInstallationLoc;
                wt.Installation_Location_other__c =  productInfoWrapper.otherInstallationLocation;
                
                // Validation field  value
                wt.Business_Category_Configuration__c =BUId.id;
                wt.Business_Units__c  = BUType ;
                insert wt;
                WOD_Warranty_Transfer__c  wtTackingNumber = [select id,Name from WOD_Warranty_Transfer__c where Id=:wt.Id]; 
                WTName =wtTackingNumber.Name;
                RecordID = wt.id;
                response.data=''+RecordID;
                response.status=true;
                
                
            }catch(Exception ex){
                system.debug('Exception  Occured ::'+ex.getMessage());
                response.status=false;
                response.errormessage=ex.getMessage();
            }
            
        }else {
            
            if(WTid != null && WTid != '') {
                WOD_Warranty_Transfer__c warrantyTransfer=  [SELECT 
                                                             RecordTypeId,
                                                             RecordType.Name,
                                                             
                                                             First_Name__c  , Last_Name__c  ,    
                                                             Address_1__c , Address_2__c  ,     
                                                             City__c  ,  State__c     ,     
                                                             Postal_Code__c , Country__c  ,     
                                                             Email__c   ,  Phone__c     ,  
                                                             Is_New_Construction_Mailing_Address__c,Organisation__c,
                                                             
                                                             Property_Type__c   ,  Building_Type__c ,    
                                                             Organisation_BL__c     ,    Is_New_Construction__c, 
                                                             First_Name_BL__c ,  Last_Name_BL__c  ,     
                                                             Address_1_BL__c  ,  Address_2_BL__c  ,    
                                                             City_BL__c   ,  State_BL__c  ,     
                                                             Postal_Code_BL__c  ,   Country_BL__c  , 
                                                             
                                                             Install_Date__c  , Transfered_Date__c ,     
                                                             Product_Group__c  , Product_Detail__c ,       
                                                             Quantity__c  ,  Unit_of_Measure__c ,  
                                                             installation_Location__c , Installation_Location_other__c ,  
                                                             Business_Category_Configuration__c , Business_Units__c    
                                                             from WOD_Warranty_Transfer__c   WHERE Id =: WTid];
                try{
                    warrantyTransfer.First_Name__c   =    mailingWrapper.firstName;
                    warrantyTransfer.Last_Name__c      =    mailingWrapper.lastName;
                    warrantyTransfer.Address_1__c     =    mailingWrapper.address1;
                    warrantyTransfer.Address_2__c     =    mailingWrapper.address2;
                    warrantyTransfer.City__c     =    mailingWrapper.cityName;
                    warrantyTransfer.State__c     =    mailingWrapper.state;
                    warrantyTransfer.Postal_Code__c     =    mailingWrapper.postalCode;
                    warrantyTransfer.Country__c     =    mailingWrapper.country;
                    warrantyTransfer.Email__c     =    mailingWrapper.emailVal;
                    warrantyTransfer.Phone__c     =    mailingWrapper.phoneVal;
                    warrantyTransfer.Organisation__c     =    mailingWrapper.organizationMailing;
                    warrantyTransfer.Is_New_Construction_Mailing_Address__c = Boolean.valueOf(mailingWrapper.IsNewConstructionMailingAddress);
                    // building field value
                    
                    //warrantyTransfer.Property_Type__c     =       buildingWrapper.selectedPropertyType; 
                    warrantyTransfer.Building_Type__c     =    buildingWrapper.selectedBuildingType ;
                    warrantyTransfer.Organisation_BL__c     =    buildingWrapper.organizationBuilding;
                    warrantyTransfer.First_Name_BL__c    =    buildingWrapper.firstName;
                    warrantyTransfer.Last_Name_BL__c     =    buildingWrapper.lastName;
                    warrantyTransfer.Address_1_BL__c     =    buildingWrapper.address1;
                    warrantyTransfer.Address_2_BL__c     =    buildingWrapper.address2;
                    warrantyTransfer.City_BL__c     =    buildingWrapper.cityName;
                    warrantyTransfer.State_BL__c     =    buildingWrapper.state;
                    warrantyTransfer.Postal_Code_BL__c     =    buildingWrapper.postalCode;
                    warrantyTransfer.Country_BL__c     =    buildingWrapper.country;
                    warrantyTransfer.Is_New_Construction__c = Boolean.valueOf(buildingWrapper.IsNewConstruction);
                    // product info field  value
                    warrantyTransfer.Install_Date__c    =    date.valueOf(productInfoWrapper.selectedInstallDate);
                    warrantyTransfer.Transfered_Date__c    =    date.valueOf(productInfoWrapper.selectedTransferDate);
                    warrantyTransfer.Product_Group__c     =    productInfoWrapper.selectedProductGroup;
                    warrantyTransfer.Division__c         =     productInfoWrapper.selecteddivision; //CER-211
                    warrantyTransfer.Product_Detail__c    =    productInfoWrapper.productDetailVal;
                    warrantyTransfer.Quantity__c    =      decimal.valueOf(quantitValue);
                    warrantyTransfer.Unit_of_Measure__c = productInfoWrapper.productUnitOfmeasure;
                    warrantyTransfer.installation_Location__c     =    productInfoWrapper.selectedInstallationLoc;
                    warrantyTransfer.Installation_Location_other__c =  productInfoWrapper.otherInstallationLocation;
                    update warrantyTransfer;
                    RecordID = warrantyTransfer.Id;
                    response.data=''+RecordID;
                    response.status=true;
                }catch(Exception ex){
                    system.debug('Exception  Occured ::'+ex.getMessage());
                    response.status=false;
                    response.errormessage=ex.getMessage();
                }
            }
            
        }        
        return response;
    }
    /**
     * @description This method used to get Warranty Registration Information
     * @param WRid Warranty Registration Id
     * @return Wrapper 
    */
    @AuraEnabled
    public static WRResponseWrapper getWRInformation(String WRid){
        WRResponseWrapper response=new WRResponseWrapper();
        if(WRid != null && WRid != ''){
            WOD_2__Warranty_Registration__c warrantyRegistration=  [SELECT 
                                                                    RecordTypeId,
                                                                    RecordType.Name,
                                                                    
                                                                    Name,Last_Name__c,
                                                                    Address_1__c,Address_2__c,
                                                                    City__c,State__c,
                                                                    Postal_Code__c,Country__c,
                                                                    Email__c,Phone__c,
                                                                    Organisation__c,Is_New_Construction_Mailing_Address__c,
                                                                    
                                                                    Property_Type__c,Building_Type__c,
                                                                    Organisation_BL__c,Is_New_Construction__c,
                                                                    First_Name_BL__c,Last_Name_BL__c,
                                                                    Address_1_BL__c,Address_2_BL__c,
                                                                    City_BL__c,State_BL__c,
                                                                    Postal_Code_BL__c,Country_BL__c,
                                                                    Division__c,
                                                                    Install_Date__c,Product_Group__c,
                                                                    Product_Detail__c,installation_Location__c,
                                                                    Quantity__c,Unit_of_Measure__c,
                                                                    Installation_Location_other__c,WOD_2__Registration_Date__c,
                                                                    
                                                                    Business_Category_Configuration__c,Business_Units__c
                                                                    
                                                                    from WOD_2__Warranty_Registration__c  WHERE Id =: WRid];
            
            response.WR=warrantyRegistration;
            response.BU=warrantyRegistration.Business_Units__c;
            response.status=true;    
        }
        return response;
    }
    /**
     * @description This method used to get Warranty Transfer Information
     * @param WTid Warranty Transfer Id
     * @return Wrapper 
    */
    @AuraEnabled
    public static WTResponseWrapper getWTInformation(String WTid){
        WTResponseWrapper response=new WTResponseWrapper();
        if(WTid != null && WTid != ''){
            WOD_Warranty_Transfer__c warrantyTransfer=  [SELECT 
                                                         RecordTypeId,
                                                         RecordType.Name,
                                                         
                                                         First_Name__c  , Last_Name__c  ,    
                                                         Address_1__c , Address_2__c  ,     
                                                         City__c  ,  State__c     ,     
                                                         Postal_Code__c , Country__c  ,     
                                                         Email__c   ,  Phone__c     ,  
                                                         Is_New_Construction_Mailing_Address__c,Organisation__c,
                                                         
                                                         Property_Type__c   ,  Building_Type__c ,    
                                                         Organisation_BL__c     ,   Is_New_Construction__c,  
                                                         First_Name_BL__c ,  Last_Name_BL__c  ,     
                                                         Address_1_BL__c  ,  Address_2_BL__c  ,    
                                                         City_BL__c   ,  State_BL__c  ,     
                                                         Postal_Code_BL__c  ,   Country_BL__c  , 
                                                         Division__c,
                                                         Install_Date__c  , Transfered_Date__c ,     
                                                         Product_Group__c  , Product_Detail__c ,       
                                                         Quantity__c  ,  Unit_of_Measure__c ,  
                                                         installation_Location__c , Installation_Location_other__c ,  
                                                         Business_Category_Configuration__c , Business_Units__c    
                                                         from WOD_Warranty_Transfer__c   WHERE Id =: WTid];
            
            
            response.WT=warrantyTransfer;
            response.BU=warrantyTransfer.Business_Units__c;
            response.status=true;    
        }
        return response;
    }
    /**
     * @description Wrapper Class
    */
    public class WRResponseWrapper{
        @AuraEnabled
        public WOD_2__Warranty_Registration__c WR;
        @AuraEnabled
        public String BU;
        @AuraEnabled
        public Boolean status;
        @AuraEnabled
        public String errormessage;
        
        public WRResponseWrapper(){
            
        }
    }
    /**
     * @description Wrapper Class
    */
    public class WTResponseWrapper{
        @AuraEnabled
        public WOD_Warranty_Transfer__c WT;
        @AuraEnabled
        public String BU;
        @AuraEnabled
        public Boolean status;
        @AuraEnabled
        public String errormessage;
        
        public WTResponseWrapper(){
            
        }
    }
    /**
     * @description Wrapper Class
    */
    public class mailingSectionWrapper{
        @AuraEnabled 
        public String firstName{get;set;}
        @AuraEnabled 
        public String lastName{get;set;}
        @AuraEnabled 
        public String address1{get;set;}
        @AuraEnabled 
        public String address2{get;set;}
        @AuraEnabled 
        public String cityName{get;set;}
        @AuraEnabled 
        public String postalCode{get;set;}
        @AuraEnabled 
        public String state{get;set;}
        @AuraEnabled 
        public String country{get;set;}
        @AuraEnabled 
        public String emailVal{get;set;}
        @AuraEnabled 
        public String phoneVal{get;set;}
        @AuraEnabled 
        public String organizationMailing{get;set;}
        @AuraEnabled 
        public String IsNewConstructionMailingAddress{get;set;}
    }
    /**
     * @description Wrapper Class
    */
    public class buildingSectionWrapper{
        @AuraEnabled 
        public String firstName{get;set;}
        @AuraEnabled 
        public String lastName{get;set;}
        @AuraEnabled 
        public String address1{get;set;}
        @AuraEnabled 
        public String address2{get;set;}
        @AuraEnabled 
        public String cityName{get;set;}
        @AuraEnabled 
        public String postalCode{get;set;}
        @AuraEnabled 
        public String state{get;set;}
        @AuraEnabled 
        public String country{get;set;}
        @AuraEnabled 
        public String selectedPropertyType{get;set;}
        @AuraEnabled 
        public String WRType{get;set;}
        @AuraEnabled 
        public String selectedBuildingType{get;set;}
        @AuraEnabled 
        public String organizationBuilding{get;set;}
        @AuraEnabled 
        public String IsNewConstruction{get;set;}
    }
    /**
     * @description Wrapper Class
    */
    public class productInformationSectionWrapper{
        @AuraEnabled 
        public String selectedInstallDate{get;set;}
        @AuraEnabled 
        public String selectedRegistrationDate{get;set;}
        @AuraEnabled 
        public String selectedTransferDate{get;set;}
        @AuraEnabled 
        public String selectedProductGroup{get;set;}
         @AuraEnabled 
        public String selecteddivision{get;set;}
        @AuraEnabled 
        public String productDetailVal{get;set;}
        @AuraEnabled 
        public String quantity{get;set;}
        @AuraEnabled 
        public String productUnitOfmeasure{get;set;}
        @AuraEnabled 
        public String selectedInstallationLoc{get;set;}
        @AuraEnabled 
        public String otherInstallationLocation{get;set;}
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