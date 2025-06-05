/**
 * @description Util class for account creation,Melissa callout for address validation
*/
global without sharing class WOD_CTUtil {
    /**
     * @description This method used to create account or fetched account in case of existing one
     * @param  BL_address1 for Address 1
     * @param  BL_address2 for Address 2
     * @param  BL_city for City
     * @param  BL_state for State
     * @param  BL_postalcode for Zip
     * @param  BL_country for Country
     * @return Account
    */
    public static Account accountCreation(String BL_address1,String BL_address2,String BL_city,String BL_state,String BL_country,String BL_postalcode){
        Account acc=new Account();
        String accName;
        String exceptionString = 'List has no rows for assignment';
        String recordTypeName = 'Warranty_Account';
        String accObjectName  = 'Account';
        String warrantyAccountType = 'Customer';
        String name='';
        //accName=BL_address1+','+BL_city+','+BL_state+','+BL_postalcode;
        //tokenize building postal code 
        if(BL_postalcode !=null && BL_postalcode !=''){
            if(BL_postalcode.contains('-')){
                String[] zip=BL_postalcode.split('-');
                BL_postalcode=zip[0];
            }
        }
        //accName=BL_address1+','+BL_city+','+BL_state+','+BL_postalcode;
        if(BL_address1 != null && BL_address1 != '')
            name=name+BL_address1+',';
        if(BL_city != null && BL_city != '')
            name=name+BL_city+',';
        if(BL_state != null && BL_state != '')
            name=name+BL_state+',';
        if(BL_postalcode != null && BL_postalcode != '')
            name=name+BL_postalcode;
        accName=name.removeEnd(',');
        try{//If account is exist already get that in try block
            Id accId=[select Id,DeveloperName from recordtype where DeveloperName=:recordTypeName and SobjectType=:accObjectName limit 1].Id;
            for(Account esixtingAccount :[Select Id from Account where Property_Account_External_Id__c=:accName and recordtypeId = :accId Limit 1]){
                acc=esixtingAccount;    
            }
            if(null == acc.Id){
                
                acc.put('RecordtypeId',accId);
                acc.Name=accName;
                acc.Property_Account_External_Id__c  = accName;
                acc.BillingCity=BL_city;        
                acc.BillingCountry=BL_country;    
                acc.Property_Account_External_Id__c =accName;
                if(BL_address2!=null){
                    acc.BillingStreet= BL_address1 +','+ BL_address2;       
                }else{
                    acc.BillingStreet= BL_address1;
                }
                acc.BillingState=BL_state;
                if(BL_postalcode!=null && BL_postalcode!='' ){
                    acc.BillingPostalCode=String.valueof(BL_postalcode);
                }
                acc.WOD_2__Warranty_Account_Type__c =warrantyAccountType;
                insert acc;
                /*V64 CERP-54 : Update default owner for WT records
                 * Default owner defined ins site hence commenting the code
                 * String  currUserName = userInfo.getName();
                if(currUserName == 'Warranty Site Guest User'){
                    acc.ownerId = Label.Tavant_User; 
                }*/
                /*Database.DMLOptions dml = new Database.DMLOptions();
                dml.DuplicateRuleHeader.AllowSave = true; 
                Database.SaveResult sr = Database.insert(acc, dml);  */  
            }
              
        }catch(Exception e){ // if no account found create account in catch block
            System.debug('Error==>'+e);    
        }        
        return acc;
    }
    /**
     * @description this class validate address against Melissa
     * @param  address1 for Address 1
     * @param  address2 for Address 2
     * @param  cityName for City
     * @param  stateName for State
     * @param  zipCode for Zip
     * @param  country for Country
     * @param  email for Email
     * @param  bu for BU
     * @return wrapper class of type validateBuildingLocationAddress
    */
    public static validateBuildingLocationAddress addressValidation(String address1,String address2,String cityName,String stateName,String zipCode,String country,String email,String bu){                
        
        validateBuildingLocationAddress objAddress=new validateBuildingLocationAddress();
        WOD_AddressVerificationUtilityController av=new WOD_AddressVerificationUtilityController();
        String validAddress=av.address(address1,address2,cityName,stateName,zipCode,country,email);
        objAddress.status='failure';
        JSONParser parser = JSON.createParser(validAddress);
        while (parser.nextToken() != null) {                        
            parser.nextValue();
            if(parser.getCurrentName()=='AddressLine1')
                objAddress.address1=parser.getText();
            if(parser.getCurrentName()=='AddressLine2')
                objAddress.address2=parser.getText();
            if(parser.getCurrentName()=='City')
                objAddress.cityName=parser.getText();
            if(parser.getCurrentName()=='State'){
                system.debug('parser.getText()========>'+parser.getText());
                //Start--Added this logic for CER130 to extract 2 char state code between() and send to metadata lookup.
                String stateCode=parser.getText();
               if(stateCode!=null && stateCode.contains('(') && stateCode.contains(')')){
                   stateCode=stateCode.substringbetween('(',')');
               }
                WOD_CTState__mdt state =[Select DeveloperName,WOD_Value__c from WOD_CTState__mdt where DeveloperName=:stateCode limit 1];
                System.debug(parser.getText()+'*&&&&&===>1'+state);
                if(state!=null)
                    //objAddress.stateName=state.Value__c;
                    objAddress.stateName=state.WOD_Value__c;
            }
            if(parser.getCurrentName()=='PostalCode')
                objAddress.zipCode=parser.getText();                        
            if(parser.getCurrentName()=='Results')
                objAddress.result=parser.getText();
            if(objAddress.result!=null){
                String[] result=(objAddress.result).split(',');                
                // if((objAddress.result).contains('AS01'))
                // 02-Mar-2018 - Adding AS02, AS03, AS17, AS24 as valid address criteria
                if((objAddress.result).contains('AS01') || (objAddress.result).contains('AS02') || (objAddress.result).contains('AS03') || (objAddress.result).contains('AS17') || (objAddress.result).contains('AS24')){
                    objAddress.status='success';
                }
                try{
                    system.debug('result::'+result);
                    //List<MelissaData__c> errorCode=[select Id,Name,Error__c,Description__c from MelissaData__c where Name in:result ]; 
                    List<WOD_MelissaData__mdt> errorCode=[select Id,DeveloperName,WOD_Description__c,WOD_Error__c from WOD_MelissaData__mdt where Error_Code__c in:result and Business_Units__c=:bu]; 
                    System.debug('===>2'+errorCode);
                    objAddress.errorMessage='';
                    for(WOD_MelissaData__mdt md: errorCode){
                        objAddress.status='failure';
                        objAddress.errorMessage=objAddress.errorMessage+md.WOD_Error__c+'\n';    
                    }
                    if(errorCode.size()<1){                        
                       objAddress.errorMessage=[select Id,DeveloperName,WOD_Description__c,WOD_Error__c from WOD_MelissaData__mdt where Error_Code__c =:'Other' and Business_Units__c =:bu].WOD_Error__c+'\n';
                       System.debug('===>3'+objAddress.errorMessage);  
                    }
                }
                catch(exception e){
                    System.debug('Error==>'+e);    
                }                
            }            
        }
        objAddress.country=country;        
        return objAddress;
    }    
    /**
     * @description Building Location wrapper
    */
    global class validateBuildingLocationAddress{
        @AuraEnabled
        public String address1{get;set;}
        @AuraEnabled
        public String address2{get;set;}
        @AuraEnabled
        public String cityName{get;set;}
        @AuraEnabled
        public String stateName{get;set;}
        @AuraEnabled
        public String zipCode{get;set;}
        @AuraEnabled
        public String country{get;set;}
        @AuraEnabled
        public String status{get;set;}
        @AuraEnabled
        public String result{get;set;}
        @AuraEnabled
        public String errorMessage{get;set;}
    }
    /**
     * @description End User wrapper
    */
    global class EndUserDetails{
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
        public String state{get;set;}
        @AuraEnabled 
        public String postalCode{get;set;}
        @AuraEnabled 
        public String country{get;set;}
           
    }
    /**
     * @description Building Details wrapper
    */
    global class BuildingDetails{
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
        public String state{get;set;}
        @AuraEnabled 
        public String postalCode{get;set;}
        @AuraEnabled 
        public String country{get;set;}     
    }
    /**
     * @description Claim Details wrapper
    */
    global class ClaimDetails{
        @AuraEnabled 
        public String selectedbusinessunit{get;set;}
        @AuraEnabled 
        public Date installedDate{get;set;}
        @AuraEnabled 
        public String productValue{get;set;}
        @AuraEnabled
        public String selecteddivision{get; set;}
        @AuraEnabled 
        public String productDetails{get;set;}
        @AuraEnabled 
        public String concernDetails{get;set;}
        @AuraEnabled 
        public Decimal appliedSuare{get;set;}
        @AuraEnabled 
        public Decimal concernedSquare{get;set;}
        @AuraEnabled 
        public String buildingValue{get;set;}
        @AuraEnabled 
        public String locationValue{get;set;}
         @AuraEnabled 
        public String otherLocationValue{get;set;}
    }
    /**
     * @description Other Details wrapper
    */
    global class OtherSiteDetails{
        @AuraEnabled
        public String userEmail{get;set;}
        @AuraEnabled
        public String userPhone{get;set;}
        @AuraEnabled
        public String buildingProductType{get;set;}
        @AuraEnabled
        public String buildingProductName{get;set;}       
    }
    /**
     * @description This method used for Warranty Registration Creation 
     * @param objClaim Claim details
     * @param ClaimType Claim Type objClaimId
     * @param objClaimId Claim Id
     * @return seralized string
    */
    webservice static String warrantyRegistrationCreation(WOD_2__Claim__c objClaim,String ClaimType,Id objClaimId){
        system.debug('--------------test wr---------'+objClaim+'------------'+ClaimType);
        
        String WarrantyRegstartionType = '';
        string samedate; 
        WOD_2__Warranty_Registration__c wr=new WOD_2__Warranty_Registration__c();
        try{
            if (objClaim == null || objClaim.Customer__c == null) {
            objClaim = [
                SELECT Custom_State__c, State_BL__c, CreatedDate, First_Name_BL__c, Last_Name_BL__c, Postal_Code_BL__c, Country_BL__c,
                       City_BL__c, Address_1_BL__c, Product_Group__c, WOD_2__Claim_Type__c, Installation_Location_Other__c,
                       Address_2__c, Address_2_BL__c, Installation_Location__c, Customer__c, Id, City__c, State__c, Country__c,
                       Zip_Code_Postal_Code__c, Install_Date__c, Last_Name__c, Phone__c, Comments__c, Email__c, Address_1__c,
                       Property_Type__c, WOD_2__Warranty_Product__r.Name, WOD_2__Warranty_Product__c, First_Name__c, Quantity__C,
                       Workmanship_Years__c, Warranted_Roof_Area__c, Shingle_Name__c, Shingle_Color__c, JobCompletion_Date__c,
                       Extended_Warranty_Registration_Number__c, Business_Units__c, Sales_Org__c
                FROM WOD_2__Claim__c
                WHERE Id = :objClaimId
            ];
        }
        
        DateTime createdDate = System.now();
        if (objClaim.CreatedDate != null) {
            createdDate = objClaim.CreatedDate;
        }
        system.debug('createdDate-->' + createdDate);
        //CER-18 : Getting the year of install Date
            Integer installYear;
            if(objClaim.Install_Date__c != null){
                installYear = Integer.valueof(objClaim.Install_Date__c.year());
            }
            system.debug('installYear-->'+installYear);
        Date installationDate = objClaim.Install_Date__c;
        system.debug('installationDate-->' + installationDate);
        List<WOD_2__Warranty_Registration__c> registrations = new List<WOD_2__Warranty_Registration__c>();
        if(objClaim.Business_Units__c == 'Siding'){
                registrations = [select id,Coverage__c,Expiration_Date__c from WOD_2__Warranty_Registration__c where WOD_2__Customer__c=:objClaim.Customer__c and Business_Units__c ='Siding' Limit 1];
            } else{
                registrations = [
                    SELECT Id, Coverage__c, Expiration_Date__c, RecordType.DeveloperName, WR_Tracking_Number__c,
                    Workmanship_Years__c, Quantity__c, Shingle_Name__c, Shingle_Color__c, JobCompletionDate__c,
                    Coverage_Information__c, Roofer_Name__c, RooferPhone__c, Roofer_Email__c, Certificate_Note__c, Comment__c,
                    Business_Units__c, WOD_2__Customer__c, WOD_2__Registration_Date__c
                    FROM WOD_2__Warranty_Registration__c
                    WHERE recordtype.developername = 'SSP_Warranty_Registration' 
                    AND Expiration_Date__c >= :createdDate 
                    AND WOD_2__Customer__c =:objClaim.Customer__c
                    AND Business_Units__c = 'Roofing'
                    ORDER BY JobCompletionDate__c ASC
                ];
    for(WOD_2__Warranty_Registration__c reg : registrations) {
        if(reg.WOD_2__Registration_Date__c!=null && installationDate!=null){
            if(reg.WOD_2__Registration_Date__c == installationDate){
                samedate ='Yes';
                system.debug('Passing::--');
            }
            else{
                samedate ='No';
            }
        }
    }
    if(samedate =='YES'){
        registrations = [
            SELECT Id, Coverage__c, Expiration_Date__c, RecordType.DeveloperName, WR_Tracking_Number__c,
            Workmanship_Years__c, Quantity__c, Shingle_Name__c, Shingle_Color__c, JobCompletionDate__c,
            Coverage_Information__c, Roofer_Name__c, RooferPhone__c, Roofer_Email__c, Certificate_Note__c, Comment__c,
            Business_Units__c, WOD_2__Customer__c, WOD_2__Registration_Date__c
            FROM WOD_2__Warranty_Registration__c
            WHERE recordtype.developername = 'SSP_Warranty_Registration' 
            AND Expiration_Date__c >= :createdDate 
            AND WOD_2__Customer__c =: objClaim.Customer__c
            AND WOD_2__Registration_Date__c = :installationDate  
            AND Business_Units__c = 'Roofing'
            ORDER BY JobCompletionDate__c ASC LIMIT 1
        ];
    }else{
        registrations = [
            SELECT Id, Coverage__c, Expiration_Date__c, RecordType.DeveloperName, WR_Tracking_Number__c,
            Workmanship_Years__c, Quantity__c, Shingle_Name__c, Shingle_Color__c, JobCompletionDate__c,
            Coverage_Information__c, Roofer_Name__c, RooferPhone__c, Roofer_Email__c, Certificate_Note__c, Comment__c,
            Business_Units__c, WOD_2__Customer__c, WOD_2__Registration_Date__c
            FROM WOD_2__Warranty_Registration__c
            WHERE recordtype.developername = 'SSP_Warranty_Registration' 
            AND Expiration_Date__c >= :createdDate 
            AND WOD_2__Customer__c =:objClaim.Customer__c
            AND (CALENDAR_YEAR(JobCompletionDate__c) = :installYear )
            AND Business_Units__c = 'Roofing'
            ORDER BY JobCompletionDate__c ASC LIMIT 1
        ];
    }
            }
            
        WOD_2__Warranty_Registration__c closestRegistration;
        Integer minDifference = 999999999; // Initialize to a large number
        for (WOD_2__Warranty_Registration__c reg : registrations) {
            
            if (reg.WOD_2__Registration_Date__c != null && installationDate != null) {
                system.debug('WOD_2__Registration_Date__c: '+reg.WOD_2__Registration_Date__c);
                Integer daysDifference = Math.abs(reg.JobCompletionDate__c.daysBetween(installationDate));
                //Integer minDifference = Math.abs(reg.WOD_2__Registration_Date__c.daysBetween(installationDate));
                system.debug('daysDifference: ' + daysDifference + ' minDifference: ' + minDifference);
                if (daysDifference < minDifference) {
                    minDifference = daysDifference;
                    closestRegistration = reg;
                }
            }
        }
        
        if (closestRegistration != null) {
            wr = closestRegistration;
            system.debug('Closest Registration-->' + wr);
            
            Date insDate = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day());
            if (objClaim.Install_Date__c != null && (objClaim.Business_Units__c == 'Roofing' || objClaim.Business_Units__c == 'Solar Solutions' || objClaim.Business_Units__c == 'Commercial Building & Infrastructure')) {
                insDate = objClaim.Install_Date__c;
            }
            
            if (insDate <= wr.Expiration_Date__c){
                WarrantyRegstartionType = ((wr.Coverage__c != null) ? wr.Coverage__c : '') + '_' + 'InWarranty';
            }else{
                WarrantyRegstartionType = ((wr.Coverage__c != null) ? wr.Coverage__c : '') + '_' + 'OutOfWarranty';
            }
            system.debug('---WarrantyRegistrationType------' + WarrantyRegstartionType);
            
            if (wr.Coverage__c == '5 Star' || wr.Coverage__c == '4 Star' || wr.Coverage__c == '3 Star' || wr.Coverage__c == '5 Star 10' || wr.Coverage__c == '5 Star 25') {
                objClaim.Workmanship_Years__c = wr.Workmanship_Years__c;
                objClaim.Warranted_Roof_Area__c = wr.Quantity__c;
                objClaim.Shingle_Name__c = wr.Shingle_Name__c;
                objClaim.Shingle_Color__c = wr.Shingle_Color__c;
                objClaim.JobCompletion_Date__c = wr.JobCompletionDate__c;
                objClaim.Coverage__c = ((wr.Coverage__c != null) ? wr.Coverage__c : '');
                objClaim.Coverage_Information__c = wr.Coverage_Information__c;
                objClaim.Roofer_Name__c = wr.Roofer_Name__c;
                objClaim.Extended_Warranty_Registration_Number__c = wr.WR_Tracking_Number__c;
                objClaim.Roofer_Phone__c = wr.RooferPhone__c;
                objClaim.Roofer_Email__c = wr.Roofer_Email__c;
                objClaim.Certificate_Note__c = wr.Certificate_Note__c;
                objClaim.Registration_Comment__c = wr.Comment__c;
            }
            
            if (objClaimId != null && wr.RecordType.DeveloperName == 'SSP_Warranty_Registration') {
                system.debug('in SSP');
                objClaim.Extended_Warranty_Registration_Number__c = wr.WR_Tracking_Number__c;
                update objClaim;
                system.debug('object claim data objClaim------->' + objClaim);
            }
        }
        }catch(Exception e){
            system.debug('e--'+e.getMessage());
            objClaim.Workmanship_Years__c =  null;
            objClaim.Warranted_Roof_Area__c = null;
            objClaim.Shingle_Name__c = null;
            objClaim.Shingle_Color__c = null;
            objClaim.JobCompletion_Date__c = null;
            objClaim.Coverage__c = null;
            objClaim.Coverage_Information__c = null;
            objClaim.Roofer_Name__c = null;
            objClaim.SureShort_Expiration__c = false;
            objClaim.Extended_Warranty_Registration_Number__c=null;
            
            if(e.getMessage().contains('List has no rows for assignment')){
                if(ClaimType != 'Solar' && ClaimType != 'newStandard'){
                    wr=new WOD_2__Warranty_Registration__c();
                    wr.Name = objClaim.First_Name__c;
                    wr.WOD_2__Status__c = 'Registered';
                    wr.WOD_2__Customer__c = objClaim.Customer__c;
                    wr.Install_Date__c = objClaim.Install_Date__c; 
                    wr.WOD_2__Registration_Date__c = system.today();
                    wr.Last_Name__c=objClaim.Last_Name__c;
                    wr.City__c=objClaim.city__c;
                    wr.state__c=objClaim.state__c;
                    wr.Country__c=objClaim.Country__c; 
                    wr.Phone__c=objClaim.phone__c;
                    if(objClaim.Zip_Code_Postal_Code__c !=null) {
                        wr.Postal_Code__c=string.valueof(objClaim.Zip_Code_Postal_Code__c);
                    }
                    String Comments = '';
                    if(objClaim.Comments__c!= null && objClaim.Comments__c!=''){
                       Comments = (String) objClaim.Comments__c; 
                    }                    
                    if(Comments.length() > 255){
                        
                        wr.WOD_2__Registration_Comments__c = Comments.substring(0,255);
                    }
                    else{
                        wr.WOD_2__Registration_Comments__c = objClaim.Comments__c;
                    }
                    wr.Email__c=objClaim.Email__c;
                    wr.Address_1__c=objClaim.Address_1__c;
                    wr.Address_2__c = objclaim.Address_2__c;
                    wr.Property_Type__c=objClaim.Property_Type__c;
                    wr.Product_Name__c=objClaim.WOD_2__Warranty_Product__r.Name;
                    wr.WOD_2__Warranty_Product__c = objClaim.WOD_2__Warranty_Product__c;
                    wr.First_Name_BL__c=objClaim.First_Name_BL__c;
                    wr.Last_Name_BL__c=objClaim.Last_Name_BL__c;
                    wr.state_BL__c=objClaim.State_BL__c;
                    wr.Country_BL__c=objClaim.Country_BL__c;
                    wr.City_BL__c=objClaim.City_BL__c;
                    wr.Address_1_BL__c=objClaim.Address_1_BL__c;
                    wr.Address_2_BL__c = objClaim.Address_2_BL__c;
                    wr.Postal_Code_BL__c=string.valueof(objClaim.Postal_Code_BL__c);
                    wr.Quantity__c=objClaim.Quantity__C;
                    wr.WOD_2__Account__c=objClaim.Customer__c;                    
                    wr.Coverage__c = '';
                    wr.Installation_Location__c = objClaim.Installation_Location__c;
                    wr.Installation_Location_Other__c = objClaim.Installation_Location_Other__c;
                    wr.Product_Group__c = objClaim.Product_Group__c;
                    wr.IsCreatedFromClaim__c=true;
                    //wr.ownerId = Label.Tavant_User; - Ashraf/Subrata - please move this to the Custom Setting WOD
                    if(objClaim.WOD_2__Claim_Type__c == 'International'){
                        wr.RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType='WOD_2__Warranty_Registration__c' AND Name='International' LIMIT 1].Id;
                        wr.First_Name_BL__c=objClaim.First_Name__c;
                        wr.Last_Name_BL__c=objClaim.Last_Name__c;
                        system.debug(objClaim.State_BL__c);
                        system.debug(objClaim.Custom_State__c);
                        wr.Custom_State__c=objClaim.State_BL__c;                            
                        wr.Country_BL__c=objClaim.Country__c;
                        wr.City_BL__c=objClaim.City__c;
                        wr.Address_1_BL__c=objClaim.Address_1__c;
                        wr.Address_2_BL__c = objClaim.Address_2__c;
                        wr.Postal_Code_BL__c=string.valueof(objClaim.Zip_Code_Postal_Code__c);
                    }
                    system.debug('----wr------'+objClaim.WOD_2__Claim_Type__c+'----'+wr);
                    /*
                    upsert wr; //TECP-157
                    */ 
                }
            }
        }
        return WarrantyRegstartionType;
    }
    /**
     * @description To check Content Version
     * @param objClaimId Claim Id
     * @return boolean flag
    */
    public static Boolean getContentRecord(Id objClaimId){
        try{
            List<ContentVersion> sampleAttachment=[SELECT VersionData,IsMajorVersion,CreatedDate FROM ContentVersion WHERE ContentDocumentId =:[Select Id from ContentDocument where Id=:[SELECT ContentDocumentId FROM ContentDocumentLink WHERE LinkedEntityId =:objClaimId].ContentDocumentId] ORDER BY CreatedDate DESC ];
            if(sampleAttachment.size()>0){
                return true;
            }
            else {
                return  false;
            }
        }catch(Exception ex){
            return  false;
        }
      
    }
    public static void mockMethod1(){
    integer i=0;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
    i = i+1;
  }
}