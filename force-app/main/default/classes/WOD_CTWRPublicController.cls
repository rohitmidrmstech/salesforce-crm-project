/**
 * @description Perform action on Warranty Registration and Transfer
*/
public without sharing class WOD_CTWRPublicController {

    /**
     * @description to get data from Custom Metadata
     * @return Map of values
    */
    @AuraEnabled //(cacheable=true)
    public Static  Map<String,String> getUnitOfMeasure()
    {
        List<WOD_CertainTeed_ShortTerm_Period__mdt> CTShortTermPeriodList=new List<WOD_CertainTeed_ShortTerm_Period__mdt>();
        CTShortTermPeriodList =[Select Id,Label,DeveloperName,WOD_Unit_of_Measure__c from WOD_CertainTeed_ShortTerm_Period__mdt];
        
        Map<String,String> UnitOfMeasureMap=new Map<String,String>();
        
        
        if(CTShortTermPeriodList != null && CTShortTermPeriodList.size()>0){
            for(WOD_CertainTeed_ShortTerm_Period__mdt   UnitOfMeasure: CTShortTermPeriodList){
                UnitOfMeasureMap.put(UnitOfMeasure.DeveloperName,UnitOfMeasure.WOD_Unit_of_Measure__c);
            } 
        }
        
        return UnitOfMeasureMap;
    }
    /**
     * @description This method used to Submit Warranty Registration and Transfer
     * @param mailingSectionWrapper1 User Mailng Address
     * @param buildingSectionWrapper1 User Building Address
     * @param productInformationSectionWrapper1 Product Information
     * @param registrationType  Registration/Transfer
     * @param BUType Business unit Siding/Roofing
     * @return Wrapper 
    */
    @AuraEnabled //(cacheable=true)
    public Static ResponseWrapper SaveRecord(mailingSectionWrapper mailingSectionWrapper1 ,buildingSectionWrapper buildingSectionWrapper1 ,
                                             productInformationSectionWrapper  productInformationSectionWrapper1 ,String registrationType , String BUType)
    {
        
        System.debug('registrationType======='+registrationType);
        System.debug('BUType======='+BUType);
        
        
        // Mailing Section Wrapper
        mailingSectionWrapper  mailingWrapper = new mailingSectionWrapper();
        mailingWrapper = mailingSectionWrapper1;
        
        // Building Section Wrapper
        buildingSectionWrapper  buildingWrapper = new buildingSectionWrapper();
        buildingWrapper = buildingSectionWrapper1;
        
        // Product Information Section Wrapper
        productInformationSectionWrapper  productInfoWrapper = new productInformationSectionWrapper();
        productInfoWrapper = productInformationSectionWrapper1;
        
        // return type
        ResponseWrapper response=new ResponseWrapper('','',false,'','');
        
        if(registrationType=='transfer')
        { 
            response= WTSubmit(mailingWrapper ,buildingWrapper ,productInfoWrapper,BUType);
        }
        else{
            response=  WRSubmit(mailingWrapper ,buildingWrapper , productInfoWrapper,BUType);
        }
        
        return response;
        
        
    }
    //CER-242 Changes Start
    @AuraEnabled(cacheable=true)
    public static Map<String,List<String>> getDependentOptions(String objName, String contfieldName, String depfieldName,Boolean addUSCanadafilter){
        map<string,List<String>>mapOfDevisionsWithBuName = WOD_PicklistFieldController.getDependentOptions(objName,contfieldName,depfieldName,addUSCanadafilter);
        map<string,List<String>>mapOfDevisionsWithBuNameforSite = new map<string,List<String>>();
        List<string>lstOfDivision = new List<string>();
        if(mapOfDevisionsWithBuName.size()>0){
            for(string buname : mapOfDevisionsWithBuName.keySet()){
                if((buname == 'Roofing') && (objName == 'WOD_Warranty_Transfer__c' || objName == 'WOD_2__Warranty_Registration__c')){
                    List<string>lstOfDivisionRoofing= new List<string>{'Residential','SBM Residential WP'};
                    mapOfDevisionsWithBuNameforSite.put(buname,lstOfDivisionRoofing);
                }
                else if(buname == 'Siding'){
                    List<String> lstOfDivisionSliding = new List<String>{
                        'SPG Polymer Shakes', 
                        'SPG CT Siding', 
                        'SPG Wolverine Siding', 
                        'SPG Stone', 
                        'SPG Hardboard Siding', 
                        'SPG Millwork', 
                        'SPG CT Metal'
                    };
                    if(objName != 'WOD_2__Warranty_Registration__c'){
                        lstOfDivisionSliding.add('Fiber Cement');
                        lstOfDivisionSliding.add('Windows');
                    }
                    mapOfDevisionsWithBuNameforSite.put(buname,lstOfDivisionSliding);
                }else{
                    mapOfDevisionsWithBuNameforSite.put(buname,mapOfDevisionsWithBuName.get(buname));
                }
            }
        }
        return mapOfDevisionsWithBuNameforSite;
    }
    //CER-242 Changes End
    /**
     * @description This method used to Submit Warranty Registration
     * @param mailingWrapper User Mailng Address
     * @param buildingWrapper User Building Address
     * @param productInfoWrapper Product Information
     * @param BUType Business unit Siding/Roofing
     * @return Wrapper 
    */
    public Static ResponseWrapper WRSubmit(mailingSectionWrapper mailingWrapper ,buildingSectionWrapper buildingWrapper ,
                                           productInformationSectionWrapper  productInfoWrapper, String BUType )
    {
        
        String WRTrackingNumber ;
        
        ResponseWrapper response=new ResponseWrapper('','',false,'','');
        string BuId = '';
        if(productInfoWrapper.selectedBusinessUnit !=null ||productInfoWrapper.selectedBusinessUnit != ''){
            BuId = productInfoWrapper.selectedBusinessUnit;
        }
        WOD_2__Business_Category_Configuration__c Bcc =  [SELECT Id, Name FROM WOD_2__Business_Category_Configuration__c where Id=: BuId ];
        //Id devRecordTypeId;
        
        /*if( buildingWrapper.selectedPropertyType =='Residential')
        {             
            devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='Residential' and SobjectType='WOD_2__Warranty_Registration__c' limit 1].Id;
        }
        else
        {
            devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='Commercial' and SobjectType='WOD_2__Warranty_Registration__c' limit 1].Id;
        }*/
        Id devRecordTypeId = Schema.SObjectType.WOD_2__Warranty_Registration__c.getRecordTypeInfosByDeveloperName().get('Residential').getRecordTypeId();
        
        WOD_2__Warranty_Registration__c  wr = new WOD_2__Warranty_Registration__c();
        String quantitValue = ((productInfoWrapper.quantity) == null ? '0':(productInfoWrapper.quantity));
        
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
            
            // building field value
            
            //wr.Property_Type__c     =       buildingWrapper.selectedPropertyType; 
            wr.Building_Type__c     =    buildingWrapper.selectedBuildingType ;
            wr.Organisation_BL__c     =    buildingWrapper.organization;
            wr.First_Name_BL__c    =    buildingWrapper.firstName;
            wr.Last_Name_BL__c     =    buildingWrapper.lastName;
            wr.Address_1_BL__c     =    buildingWrapper.address1;
            wr.Address_2_BL__c     =    buildingWrapper.address2;
            wr.City_BL__c     =    buildingWrapper.cityName;
            wr.State_BL__c     =    buildingWrapper.state;
            wr.Postal_Code_BL__c     =    buildingWrapper.postalCode;
            wr.Country_BL__c     =    buildingWrapper.country;
            wr.WOD_2__Registration_Type__c = 'Standard Registration' ;
            
            // product info field  value
            wr.Install_Date__c    =    date.valueOf(productInfoWrapper.selectedInstallDate);
            wr.Product_Group__c     =    productInfoWrapper.selectedProductGroup;
            wr.Division__c         =     productInfoWrapper.selecteddivision; //CER-211
            wr.Product_Detail__c    =    productInfoWrapper.productDetailVal;
            // wr.Quantity__c    =      decimal.valueOf(productInfoWrapper.quantity);
            wr.Quantity__c    =      decimal.valueOf(quantitValue);
            wr.installation_Location__c     =    productInfoWrapper.selectedInstallationLoc;
            wr.Installation_Location_other__c =  productInfoWrapper.otherInstallationLocation;
            
            // Validation field  value
            wr.Business_Category_Configuration__c =  Bcc.id;
            wr.Business_Units__c  = Bcc.Name ;
            wr.WOD_2__Registration_Date__c = date.today();
            
            //wr.WOD_2__Customer__c =acc.id; 
            //Added by Raviteja
            if(wr.Product_Group__c != null && wr.Product_Group__c != '' && wr.Product_Group__c != '--None--'){
                WOD_CertainTeed_ShortTerm_Period__mdt deoMdt =  [SELECT MasterLabel, QualifiedApiName, WOD_Unit_of_Measure__c, WOD_Validity_Period__c FROM WOD_CertainTeed_ShortTerm_Period__mdt where MasterLabel=:wr.Product_Group__c LIMIT 1]; 
                if(deoMdt != null){
                    wr.Unit_of_Measure__c = deoMdt.WOD_Unit_of_Measure__c;
                }
            }
            //End
            
            insert wr;
            
            WOD_2__Warranty_Registration__c  wrTackingNumber = [select id,WR_Tracking_Number__c,Unit_of_Measure__c from WOD_2__Warranty_Registration__c where Id=:wr.Id]; 
            WRTrackingNumber =wrTackingNumber.WR_Tracking_Number__c;
            String recordID = wr.Id;
            system.debug('WRTrackingNumber'+WRTrackingNumber);
            response.data=''+WRTrackingNumber;
            response.status=true;
            response.recId =wrTackingNumber.Id;
            response.unitMeasure = wrTackingNumber.Unit_of_Measure__c;
        }catch(Exception ex){
            system.debug('Exception  Occured ::'+ex.getMessage());
            response.status=false;
            response.errormessage=ex.getMessage();
        }
        // response.data=String.valueOf(wr.WR_Tracking_Number__c);
        
        return response;
        
    }
    /**
     * @description This method used to Submit Warranty Transfer
     * @param mailingWrapper User Mailng Address
     * @param buildingWrapper User Building Address
     * @param productInfoWrapper Product Information
     * @param BUType Business unit Siding/Roofing
     * @return Wrapper 
    */
    public Static ResponseWrapper WTSubmit(mailingSectionWrapper mailingWrapper ,buildingSectionWrapper buildingWrapper ,
                                           productInformationSectionWrapper  productInfoWrapper , String BUType)
    {
        String WTName ;
        
        ResponseWrapper response=new ResponseWrapper('','',false,'','');
        string BuId = '';
        if(productInfoWrapper.selectedBusinessUnit !=null ||productInfoWrapper.selectedBusinessUnit != ''){
            BuId = productInfoWrapper.selectedBusinessUnit;
        }
        WOD_2__Business_Category_Configuration__c Bcc =  [SELECT Id, Name FROM WOD_2__Business_Category_Configuration__c where Id=: BuId ];

        //Id devRecordTypeId;
        
        /*if( buildingWrapper.selectedPropertyType =='Residential')
        {             
            devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='Residential' and SobjectType='WOD_Warranty_Transfer__c' limit 1].Id;
        }
        else
        {
            devRecordTypeId=[select Id,DeveloperName from recordtype where DeveloperName='Commercial' and SobjectType='WOD_Warranty_Transfer__c' limit 1].Id;
        }*/
        Id devRecordTypeId = Schema.SObjectType.WOD_Warranty_Transfer__c.getRecordTypeInfosByDeveloperName().get('Residential').getRecordTypeId();
        WOD_Warranty_Transfer__c  wt = new WOD_Warranty_Transfer__c();
        String quantitValue = ((productInfoWrapper.quantity) == null ? '0':(productInfoWrapper.quantity));
        
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
            
            // building field value
            
            //wt.Property_Type__c     =       buildingWrapper.selectedPropertyType; 
            wt.Building_Type__c     =    buildingWrapper.selectedBuildingType ;
            wt.Organisation_BL__c     =    buildingWrapper.organization;
            wt.First_Name_BL__c    =    buildingWrapper.firstName;
            wt.Last_Name_BL__c     =    buildingWrapper.lastName;
            wt.Address_1_BL__c     =    buildingWrapper.address1;
            wt.Address_2_BL__c     =    buildingWrapper.address2;
            wt.City_BL__c     =    buildingWrapper.cityName;
            wt.State_BL__c     =    buildingWrapper.state;
            wt.Postal_Code_BL__c     =    buildingWrapper.postalCode;
            wt.Country_BL__c     =    buildingWrapper.country;
            
            // product info field  value
            wt.Install_Date__c    =    date.valueOf(productInfoWrapper.selectedInstallDate);
            wt.Transfered_Date__c    =    date.valueOf(productInfoWrapper.selectedTransferDate);
            wt.Product_Group__c     =    productInfoWrapper.selectedProductGroup;
            wt.Division__c         =     productInfoWrapper.selecteddivision;//CER-211
            wt.Product_Detail__c    =    productInfoWrapper.productDetailVal;
            // wr.Quantity__c    =      decimal.valueOf(productInfoWrapper.quantity);
            wt.Quantity__c    =      decimal.valueOf(quantitValue);
            wt.installation_Location__c     =    productInfoWrapper.selectedInstallationLoc;
            wt.Installation_Location_other__c =  productInfoWrapper.otherInstallationLocation;
            
            // Validation field  value
            wt.Business_Category_Configuration__c =  Bcc.id;
            wt.Business_Units__c  = Bcc.Name ;
            //wt.WOD_2__Registration_Date__c = date.today();
            //Added by Raviteja
            if(wt.Product_Group__c != null && wt.Product_Group__c != '' && wt.Product_Group__c != '--None--'){
                WOD_CertainTeed_ShortTerm_Period__mdt deoMdt =  [SELECT MasterLabel, QualifiedApiName, WOD_Unit_of_Measure__c, WOD_Validity_Period__c FROM WOD_CertainTeed_ShortTerm_Period__mdt where MasterLabel=:wt.Product_Group__c LIMIT 1]; 
                if(deoMdt != null){
                    wt.Unit_of_Measure__c = deoMdt.WOD_Unit_of_Measure__c;
                }
            }
            //End
            insert wt;
            
            WOD_Warranty_Transfer__c  wtTackingNumber = [select id,Name,Unit_of_Measure__c from WOD_Warranty_Transfer__c where Id=:wt.Id]; 
            WTName =wtTackingNumber.Name;
            response.data=''+WTName;
            response.status=true;
            response.recId =  wtTackingNumber.ID;
            response.unitMeasure = wtTackingNumber.Unit_of_Measure__c;
            
        }catch(Exception ex){
            system.debug('Exception  Occured ::'+ex.getMessage());
            response.status=false;
            response.errormessage=ex.getMessage();
        }
        // response.data=String.valueOf(wr.WR_Tracking_Number__c);
        
        return response;
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
        public String selectedBuildingType{get;set;}
        @AuraEnabled 
        public String organization{get;set;}
    }
    
    /**
     * @description Wrapper Class
    */
    public class productInformationSectionWrapper{
        @AuraEnabled 
        public String selectedInstallDate{get;set;}
        @AuraEnabled 
        public String selectedTransferDate{get;set;}
        @AuraEnabled 
        public String selectedProductGroup{get;set;} //CER-211
        @AuraEnabled 
        public String productDetailVal{get;set;}
        @AuraEnabled 
        public String quantity{get;set;}
        @AuraEnabled 
        public String selectedInstallationLoc{get;set;}
        @AuraEnabled 
        public String otherInstallationLocation{get;set;}
        @AuraEnabled 
        public String selectedBusinessUnit{get;set;}
        @AuraEnabled
        public String selecteddivision{get;set;}
    }
    /**
     * @description Wrapper Class
    */
    public class ResponseWrapper{
        @AuraEnabled
        public String data;
        @AuraEnabled
        public String recId;
        @AuraEnabled
        public Boolean status;
        @AuraEnabled
        public String errormessage;
        @AuraEnabled
        public String unitMeasure;
        
        public ResponseWrapper(){
            
        }
        public ResponseWrapper(String data,string recId, Boolean status, string errormessage, String unitMeasure) {
            this.data = data;
            this.status = status;
            this.errormessage = errormessage;
            this.recId = recId;
            this.unitMeasure = unitMeasure;
        }
    }
    
}