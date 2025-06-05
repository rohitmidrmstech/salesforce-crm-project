/**
 * @description Class used for claim record creation.
*/
global without sharing class WOD_Claimhandler {
    public Account claimAcc;
    public WOD_2__Warranty_Registration__c wr; 
    /**
     * @description This method is used to Create/Update Claim record
     * @param objClaim Claim object
     * @param objDistributor Claim Interested Parties object
     * @param productList List of Shipping Products
     * @return Claim Id or Error message
    */
    public String createClaim(WOD_2__Claim__c objClaim,WOD_Claim_Interested_Parties__c objDistributor,List<WOD_Shipping_Products__c> productList  )
    {
        system.debug('objClaim-------'+objClaim.WOD_2__Claim_Type__c+'- ---'+objClaim);
        try{
            String address1Value;
            String address2Value;
            String cityValue;
            String stateValue;
            String countryValue;
            String zipCode;
            if(objClaim.WOD_2__Claim_Type__c == 'International'){
                address1Value=objClaim.Address_1__c;
                address2Value=objClaim.Address_2__c;
                cityValue=objClaim.City__c;
                stateValue= objClaim.Custom_State__c;
                countryValue=objClaim.Country__c;
                zipCode=objClaim.Zip_Code_Postal_Code__c;
            }else{
                address1Value=objClaim.Address_1_BL__c;
                address2Value=objClaim.Address_2_BL__c;
                cityValue=objClaim.City_BL__c;
                stateValue= objClaim.State_BL__c;
                countryValue=objClaim.Country_BL__c;
                zipCode=objClaim.Postal_Code_BL__c;
            }
            String WarrantyRegistrationType = '';
            Boolean SureShortExpired = false;
            system.debug('----acc creationdetails-------'+address1Value+'-----'+address2Value+'-----'+cityValue+'-----'+stateValue+'-----'+countryValue+'-----'+zipCode);      
            if(objClaim.Id == null){             
                Account objAccount =  WOD_CTUtil.accountCreation(address1Value,address2Value,cityValue,stateValue,countryValue,zipCode);
                if(objAccount != null){
                    objClaim.Customer__c = objAccount.Id;
                    claimAcc = objAccount;
                }
            }
            if(objClaim.WOD_2__Claim_Type__c == 'Solar' ){
                objClaim.Warranty_Status__c = '<b><span style="color:red;font-size: small;"> No Matching Warranties </span></b>';
                String WarrantyRegistrationResult = WOD_CTUtil.warrantyRegistrationCreation(objClaim,'Solar',objClaim.Id); 
                system.debug('------------WarrantyRegistrationResult---------'+WarrantyRegistrationResult);
                if(WarrantyRegistrationResult.contains('_'))
                    WarrantyRegistrationType = WarrantyRegistrationResult.split('_')[0];
                else
                    WarrantyRegistrationType = WarrantyRegistrationResult;
                //if(WarrantyRegistrationType == 'Solar Gold' || WarrantyRegistrationType == 'Solar Gold AC' || WarrantyRegistrationType == 'Solar Silver'){
                //CERP-27 : Setting Claim Warranty_Registration_Type__c from WarrantyRegistrationResult for Solar Claims
                if(String.isNotBlank(WarrantyRegistrationType) && WarrantyRegistrationType  != 'Standard'){ 
                    objClaim.Warranty_Registration_Type__c = WarrantyRegistrationType;
                    if(WarrantyRegistrationResult.contains('_')){
                        if(WarrantyRegistrationResult.split('_')[1] == 'InWarranty'){
                            objClaim.SureShort_Expiration__c = false;
                            objClaim.Warranty_Status__c = '<b><span style="color:green;font-size: small;">In Warranty </span></b>';
                        }
                        else if(WarrantyRegistrationResult.split('_')[1] == 'OutOfWarranty'){
                            objClaim.SureShort_Expiration__c = true;
                            objClaim.Warranty_Status__c = '<b><span style="color:red;font-size: small;">No Matching Warranties</span></b>';
                        }
                    }
                    
                }
            }
            if(objClaim.WOD_2__Claim_Type__c == 'Standard' && objClaim.Business_Units__c !='Commercial Building & Infrastructure'){
                String WarrantyRegistrationResult = WOD_CTUtil.warrantyRegistrationCreation(objClaim,'newStandard',objClaim.Id); 
                system.debug('------------WarrantyRegistrationResult---------'+WarrantyRegistrationResult);
                if(WarrantyRegistrationResult!=null && WarrantyRegistrationResult.contains('_')){
                    WarrantyRegistrationType = WarrantyRegistrationResult.split('_')[0];
                    objClaim.Warranty_Registration_Type__c = WarrantyRegistrationType;                    
                    if(WarrantyRegistrationResult.split('_')[1] == 'InWarranty')
                        objClaim.SureShort_Expiration__c = false;
                    else if(WarrantyRegistrationResult.split('_')[1] == 'OutOfWarranty')
                        objClaim.SureShort_Expiration__c = true;
                    
                    
                }
                else{
                    WarrantyRegistrationType = WarrantyRegistrationResult;
                    objClaim.Warranty_Registration_Type__c = 'Standard';
                }
                
                //CERP-27 : Claim coverage should be updated for all Star,Solar and Encore Registration coverages
                //if(WarrantyRegistrationType == '3 Star' || WarrantyRegistrationType == '4 Star' || WarrantyRegistrationType == '5 Star' || WarrantyRegistrationType == 'Encore 10' || WarrantyRegistrationType == 'Encore 15' ||  WarrantyRegistrationType == 'Solar Gold' || WarrantyRegistrationType == 'Solar Gold AC' || WarrantyRegistrationType == 'Solar Silver'){
                //if(WarrantyRegistrationType.contains('Star') || WarrantyRegistrationType.contains('Encore') || WarrantyRegistrationType.contains('Solar')){     
                //Warranty_Registration_Type__c is set to standard in the previous line. The below code should run only if the WR returned has a Extended warranty returned.
                /*if(objClaim.Warranty_Registration_Type__c != 'Standard' &&(objClaim.Warranty_Registration_Type__c != null || objClaim.Warranty_Registration_Type__c != '')){    
               
                objClaim.Warranty_Registration_Type__c = WarrantyRegistrationType;
                    if(WarrantyRegistrationResult.contains('_')){
                        if(WarrantyRegistrationResult.split('_')[1] == 'InWarranty')
                            objClaim.SureShort_Expiration__c = false;
                        else if(WarrantyRegistrationResult.split('_')[1] == 'OutOfWarranty')
                            objClaim.SureShort_Expiration__c = true;
                        
                    }
                }*/
            }
            if(objClaim !=null)
            {
                //objClaim = fillIntegrationFields(objClaim);
                
                if(objClaim.id ==null){
                    system.debug('qwerty');
                    objClaim.isDuplicate__c=false;
                    /*
                    //string recordType=string.valueof([select name from recordtype where id=:objClaim.RecordTypeId].name);
                    List<WOD_2__Claim__c> lstClaim=new List<WOD_2__Claim__c>();
                    lstClaim=[SELECT Id,name FROM WOD_2__Claim__c WHERE Customer__c =:objClaim.Customer__c ORDER BY CreatedDate];
                    system.debug('nyclaim '+lstClaim.size());
                    if(lstClaim.size()>0){
                    objClaim.isDuplicate__c=true;
                    for(WOD_2__Claim__c c:lstClaim){
                    c.isDuplicate__c=true;                            
                    }
                    update lstClaim;
                    //objClaim.Duplicate_Claim__c=lstClaim[0].Id;
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Duplicate Claim'));
                    }*/
                    system.debug('debit amount -->'+objClaim.Debit_Amount__c);
                    if(objClaim.Debit_Amount__c !=null && objClaim.Debit_Amount__c >0){
                        objClaim.Debit_Amount__c=0-objClaim.Debit_Amount__c;
                    }
                    System.debug('@objClaim'+objClaim);
                    insert objClaim;                    
                }
                else if(objClaim.id !=null){
                    system.debug('debit amount -->'+objClaim.Debit_Amount__c);
                    if(objClaim.Debit_Amount__c !=null && objClaim.Debit_Amount__c >0){
                        objClaim.Debit_Amount__c=0-objClaim.Debit_Amount__c;
                    }
                    upsert objClaim;
                }
            }
            
            if(objClaim.WOD_2__Claim_Type__c == 'Short Term'){
                List<WOD_Shipping_Products__c> insertList=new List<WOD_Shipping_Products__c>();
                List<WOD_Shipping_Products__c> updateList=new List<WOD_Shipping_Products__c>();
                if(productList!= NULL && productList.size()>0){
                    for(WOD_Shipping_Products__c prod:productList){
                        if(prod.Claim__c ==null){
                            prod.Claim__c=objClaim.Id;
                            insertList.add(prod);
                        }
                        else{
                            updateList.add(prod);
                        }
                    } 
                    
                    if(updateList.size() >0 ){
                        upsert updateList;
                    }
                    if(insertList.size() >0 ){
                        insert insertList;
                    }
                }
                
            }else if(objClaim.WOD_2__Claim_Type__c == 'International'){
                if(objDistributor != null){
                    objDistributor.RecordTypeId=[Select id from RecordType Where Name ='International'  AND sObjectType = 'WOD_Claim_Interested_Parties__c' LIMIT 1].Id;
                    objDistributor.Type__c = 'Distributor';
                    objDistributor.Name = objDistributor.Organization__c;
                    if(objDistributor.id ==null){
                        objDistributor.claim__c=objClaim.id;
                        insert objDistributor;
                    }
                    if(objDistributor.id !=null){
                        update objDistributor;
                    }
                    
                }
            }
        }
        catch(exception ex){
            system.debug('@@@@Exception'+ex.getMessage()+ex.getLineNumber());
            return ex.getMessage();
            /*
            if(!String.valueOf(URL.getCurrentRequestUrl()).toLowerCase().contains('services/soap')){
              //ApexPages.addMessages(ex);
           }
           */ 
        }
        return objClaim.id;
        
    }   
}