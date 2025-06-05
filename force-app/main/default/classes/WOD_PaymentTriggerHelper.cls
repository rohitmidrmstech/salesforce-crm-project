/**
 * @description Trigger helper class for payment
*/
public class WOD_PaymentTriggerHelper{
    /**
     * @description handle delete operation
     * @param paymentList List of payment records
    */
    public static void HandleDelete(list <WOD_Payment__c>paymentList){
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
        for(WOD_Payment__c p: paymentList){
            if(p.Released_To_SAP__c==true && (profileName != 'Integration User' && profileName != 'System Administrator')){ //Exclude Sys Admin and Integration User
                p.adderror('Can\'t Delete the Payment which is already Released to SAP');
            }
            else if(p.Void_WOD_Payment__c==true && (profileName != 'Integration User' && profileName != 'System Administrator')){ //Exclude Sys Admin and Integration User
                p.adderror('Can\'t Delete the Payment which is a voided payment');
            }
           else if(p.Approval_Status__c=='Approved'  && p.Sales_Org__c != '1502' && p.Sales_Org__c != '1018' && p.Sales_Org__c != '1019' && p.Sales_Org__c != '1020'){//TECP-688 // CER-230
                //p.adderror('Approved Payments cannot be deleted'); //TECP-737
            }
        }        
    }
    /**
     * @description To update sold to 
     * @param paymentList List of payment records
    */
    public static void updateSoldTo(List <WOD_Payment__c> paymentList){
        
        List<Id> soldToHirrIdList=new List<Id>();
        List<Id> shipToIdList=new List<Id>();
        List<Id> recordTypeIdList=new List<Id>();
        for(WOD_Payment__c p: paymentList){       
            soldToHirrIdList.add(p.Sold_To_Hierarchy__c);
            shipToIdList.add(p.Ship_To__c);
            recordTypeIdList.add(p.RecordTypeId);
        }
        String acctype;
        String recordPay;
        Map<Id,Hierarchy_Ship_To_Sold_To__c> HierMap=new Map<Id,Hierarchy_Ship_To_Sold_To__c>([Select Id,Sold_To__c,Sold_To__r.Id 
        from Hierarchy_Ship_To_Sold_To__c where Id IN:soldToHirrIdList]);
        Map<Id,Account> shipToMap=new Map<Id,Account>([Select Id,Type,RecordType.name from Account where Id IN:shipToIdList]);
        Map<Id,RecordType> RecordTypeMap=new Map<Id,RecordType>([Select Id,Name from RecordType where Id IN:recordTypeIdList]);

        for(WOD_Payment__c p: paymentList){
            if(p.Ship_To__c!= null){
                acctype=shipToMap.get(p.Ship_To__c).RecordType.name ;
                recordPay=RecordTypeMap.get(p.RecordTypeId).Name;            
                //CERP-48 : Allow users to update Sold-To for Approved Package via UI.
                if(shipToMap.get(p.Ship_To__c) !=null && /* p.Approved__c == false && */(p.Sales_Org__c =='1502' || p.Sales_Org__c =='1018' || p.Sales_Org__c =='1019' || p.Sales_Org__c =='1020')){// for Siding CER-230
                    acctype=shipToMap.get(p.Ship_To__c).RecordType.name ;
                    if(acctype=='Sold-To'){
                        p.Sold_To__c=p.Ship_To__c;                    
                    }else{
                        if(RecordTypeMap.get(p.RecordTypeId)!=null)
                        {
                            recordPay=RecordTypeMap.get(p.RecordTypeId).Name;
                        }                    
                        if(recordPay == 'Credit/Debit' || recordPay=='Free Material'  || recordPay == 'Check' ){                
                            if(HierMap.get(p.Sold_To_Hierarchy__c)!=null){
                                p.Sold_To__c = HierMap.get(p.Sold_To_Hierarchy__c).Sold_To__r.Id;
                            }else{
                                p.Sold_To_Hierarchy__c.addError('Please Select Sold To Hierarchy');                              
                                /*
                                if(p.Sold_To_Hierarchy__c== null ){
                                    p.Sold_To__c=p.Ship_To__c;
                                }
                                else{
                                    p.Sold_To_Hierarchy__c.addError('Please Select Sold To Hierarchy');                              
                                } 
                                */             
                            }
                        }
                    }
                }
                System.debug(p+'++++++++++++'+recordPay);
                System.debug(acctype+'++++++++++++'+recordPay);
                 if(p.Sales_Org__c != '1502' && p.Sales_Org__c != '1018' && p.Sales_Org__c != '1019' && p.Sales_Org__c != '1020' && (recordPay == 'Credit/Debit' || recordPay=='Free Material')){ // CER-230
                    if(acctype=='Sold-To'){
                        p.Sold_To__c=p.Ship_To__c;                    
                    }
                    else {
                        if(p.Sold_To_Hierarchy__c!= null && null != HierMap.get(p.Sold_To_Hierarchy__c)){
                            p.Sold_To__c = HierMap.get(p.Sold_To_Hierarchy__c).Sold_To__r.Id;    
                        }
                        else if(p.Sold_To_Hierarchy__c== null){
                            p.Sold_To_Hierarchy__c.addError('Please Select Sold To Hierarchy');  
                            //p.Sold_To__c=p.Ship_To__c;
                        } 
                    }
                }
            }
        }
    }
    /**
     * @description handle before update operation
     * @param newPaymentMap Map of New Payment Records
     * @param oldPaymentMap Map of Old Payment Records
    */
    public static void hadlebeforeUpdate(Map<Id,WOD_Payment__c> newPaymentMap,Map<Id,WOD_Payment__c> oldPaymentMap ){
        Set<Id> clmIds = new Set<Id>();
        Set<Id> paymentIdSet = new Set<Id>();
        Map<Id,WOD_Payment_Line__c> paymentLineMap = new Map<Id,WOD_Payment_Line__c>();
        Id profileId = userinfo.getProfileId();
        String profileName = [select Name from profile where id = :profileId].Name;
        
        for(Id pmtId : newPaymentMap.KeySet()){
            WOD_Payment__c p = newPaymentMap.get(pmtId);
            if(newPaymentMap.get(pmtId).Settlement_Type__c != oldPaymentMap.get(pmtId).Settlement_Type__c && p.Sales_Org__c != '1502' && p.Sales_Org__c != '1018' && p.Sales_Org__c != '1019' && p.Sales_Org__c != '1020'){ // CER-230
                paymentIdSet.add(pmtId);
            }
            if(p.Approved__c ){p.Approval_Status__c = 'Approved';} //Divya
            if(p.Approval_Status__c == 'Approved'){p.Approved__c = true;} //Divya
            clmIds.add(p.Claim__c);
            
            if(p.Payment_Type__c == 'Gelco'){
                p.Check_Date__c = string.valueof(p.Gelco_Check_Date__c);
            }
        }
        if(paymentIdSet.Size() >0){
            for(WOD_Payment_Line__c pl : [Select Id,Payment__c from WOD_Payment_Line__c where Payment__c =: paymentIdSet]){
                paymentLineMap.put(pl.Payment__c,pl);
                
            }           
        }
        if(paymentLineMap.Size() >0 && (profileName != 'Integration User' && profileName != 'System Administrator')){ //Exclude Sys Admin and Integration User
            for(Id paymentId : paymentLineMap.KeySet()){
                newPaymentMap.get(paymentId).adderror('Settlement Type can\'t be changed for this payment' );
            }
        }
        Map<Id, WOD_2__Claim__c> clmMap =new Map<Id,WOD_2__Claim__c>( [Select WOD_2__Claim_Status__c, ClaimType__c, First_Name__c,Last_Name__c,State__c,Country__c,City__c,Address_2__c,Address_1__c,ZIP_Code_Postal_Code__c, Custom_State__c, Plant__r.SAP_Plant__c,   
        WOD_2__Warranty_Product__r.Product_Line__c,Organization__c from WOD_2__Claim__c Where Id IN : clmIds]);
        
        for(WOD_Payment__c p: newPaymentMap.values()){
            WOD_Payment__c oldPay = oldPaymentMap.get(p.Id);
            WOD_2__Claim__c clm =clmMap.get(p.Claim__c); 
            
            
            if(profileName != 'Integration User' && profileName != 'System Administrator' && profileName !='Warranty Admin Roofing' && (clm.WOD_2__Claim_Status__c  =='Need more Information' ||clm.WOD_2__Claim_Status__c  =='Rejected' ||clm.WOD_2__Claim_Status__c  =='Closed'||
               clm.WOD_2__Claim_Status__c  =='Pre-Claim')){
                   p.adderror('Can\'t edit the Payment Package When Claim Status is '+clm.WOD_2__Claim_Status__c);
            }
            
            
            String recordPay = p.Payment_Type__c;
            if(recordPay == 'Check'){
                String setChar = '';
                if(String.IsNotBlank(p.Settlement_Type__c)){
                    setChar = p.Settlement_Type__c.substring(0, 3);
                }
                String plantName = clm.Plant__r.SAP_Plant__c;
                String divCode = clm.WOD_2__Warranty_Product__r.Product_Line__c;
                //if(oldPay.Settlement_Type__c!=p.Settlement_Type__c || oldPay.Claim__r.Plant__r.Code__c!=clm.Plant__r.Code__c||oldPay.Claim__r.WOD_2__Warranty_Product__r.Product_Line__c!=clm.WOD_2__Warranty_Product__r.Product_Line__c)
                if(oldPay.Settlement_Type__c!=p.Settlement_Type__c || oldPay.Claim__r.Plant__r.SAP_Plant__c!=clm.Plant__r.SAP_Plant__c||oldPay.Claim__r.WOD_2__Warranty_Product__r.Product_Line__c!=clm.WOD_2__Warranty_Product__r.Product_Line__c|| p.SAP_Accounts__c == null){
                    SetSAPAccounts(p, plantName, setChar, clm.WOD_2__Warranty_Product__r.Product_Line__c);
                }
                 
            }
            
            if(recordPay=='Log'){
                p.Check_Date__c = string.valueof(p.Log_Check_Date__c);
                p.Total_Amount_Converted__c=p.Total_Amount__c;
            }
            
            if(recordPay == 'Check' ||recordPay=='Gelco'){
                
                if(p.Remit_To__c == 'Home Owner'){
                    //CERP-48 : Update RemitTo Organization for HomeOwner
                    if(clm.ClaimType__c != 'International'){
                        SetRemitToAddress(p, clm.First_Name__c, clm.Last_Name__c, clm.Address_1__c,clm.Address_2__c,clm.ZIP_Code_Postal_Code__c,clm.City__c,clm.State__c,clm.Organization__c, clm.Country__c,false);
                    }    
                    else{
                        SetRemitToAddress(p, clm.First_Name__c, clm.Last_Name__c, clm.Address_1__c,clm.Address_2__c,clm.ZIP_Code_Postal_Code__c,clm.City__c,clm.Custom_State__c,clm.Organization__c, clm.Country__c,false);
                     }
                }else if(p.Remit_To__c == 'Lumberyard' || p.Remit_To__c == 'Builder' || p.Remit_To__c == 'Attorney' || p.Remit_To__c == 'Community Association' || p.Remit_To__c == 'Relative' || p.Remit_To__c == 'Other' ||  p.Remit_To__c == 'Contractor' || p.Remit_To__c =='Restoration Company'/*CER-240*/){
                    List<WOD_Claim_Interested_Parties__c> interestedParties;
                    interestedParties =[Select First_Name__c,Last_Name__c,Address_1__c,Address_2__c,City__c,State__c,Zip_Code__c,Type__c, Name, Country__c from WOD_Claim_Interested_Parties__c where Claim__c =:clm.Id And Type__c =:p.Remit_To__c ORDER BY LastModifiedDate DESC LIMIT 1];
                    if(interestedParties.size()>0){
                        SetRemitToAddress(p,interestedParties[0].First_Name__c,interestedParties[0].Last_Name__c,interestedParties[0].Address_1__c,interestedParties[0].Address_2__c,interestedParties[0].Zip_Code__c,interestedParties[0].City__c,interestedParties[0].State__c, interestedParties[0].Name, interestedParties[0].Country__c, false);
                    }else{
                        p.addError('Claim Interested Party not defined on the claim for ' + p.Remit_To__c);
                    }
                }
                else{
                    SetRemitToAddress(p, '','', '','', '','', '','', '', true);
                }
                
            }
            
            system.debug(recordPay);
            
            
        }
        updateSoldTo(newPaymentMap.Values());
        
        
        
    }
    /**
     * @description To handle before insert operation
     * @param paymentList List of payment record
    */
    public static void HandleBeforeInsert(List <WOD_Payment__c> paymentList){
        List<Id> shipToIdList=new List<Id>();
        List<Id> recordTypeIdList=new List<Id>();
        List<String> listClaimCurrecny = new List<String>();
        List<String> remitStringLIst = new List<String>();
        Integer count =0; 
        Map<String,Exchange_Rate__c> currencyMap = new Map<String,Exchange_Rate__c>();
        Set<Id> claimIdSet = new Set<Id>();
        Map<Id,WOD_Claim_Interested_Parties__c> interestedPartyMap = new Map<Id,WOD_Claim_Interested_Parties__c>();
        for(WOD_Payment__c p: paymentList){       
            shipToIdList.add(p.Ship_To__c);
            recordTypeIdList.add(p.RecordTypeId);
            claimIdSet.add(p.Claim__c);
            remitStringLIst.add(p.Remit_To__c);
        }
        Map<Id,Account> shipToMap=new Map<Id,Account>([Select Id,Type from Account where Id IN:shipToIdList]);
        Map<Id,RecordType> recordTypeMap=new Map<Id,RecordType>([Select Id,Name from RecordType where Id IN:recordTypeIdList]);
        Map<Id,WOD_2__Claim__c> clmMap = new Map<Id,WOD_2__Claim__c>([Select Sales_org__c, Currency__c, Country_BL__c,  WOD_2__Claim_Status__c, ClaimType__c,Organization__c, Organization_BL__c, 
        Custom_State__c, Country__c, WOD_2__Warranty_Product__r.Product_Line__c,CreatedBy.Email, //CER-74
        First_Name__c,Last_Name__c,State__c,City__c,Address_2__c,Address_1__c,ZIP_Code_Postal_Code__c,Plant__r.Name, plant__r.SAP_Plant__c from WOD_2__Claim__c Where Id =:claimIdSet]);
        
        for(WOD_2__Claim__c eachClaim : clmMap.Values()){
            listClaimCurrecny.add(eachClaim.Currency__c);
        }
        for(Exchange_Rate__c eachExchange : [SELECT Currency__c,Exchange_Rate__c FROM Exchange_Rate__c WHERE Currency__c = :listClaimCurrecny and Currency__c!='' ORDER BY Date__c DESC ]){
            currencyMap.put(eachExchange.Currency__c,eachExchange);
        }
        for(WOD_Claim_Interested_Parties__c eachParty:[Select Claim__c,First_Name__c,Last_Name__c,Address_1__c,Address_2__c,City__c,State__c,Zip_Code__c,Type__c, Name, Country__c from WOD_Claim_Interested_Parties__c where Claim__c =:claimIdSet And Type__c =:remitStringLIst]){
            interestedPartyMap.put(eachParty.Claim__c,eachParty);
        }
        
        list<aggregateResult> aggResults = [SELECT MAX(Sequence_Number__c)mxCnt FROM WOD_Payment__c where claim__c =: claimIdSet ];
        if(Integer.valueOf(aggResults[0].get('mxCnt'))>0){
            system.debug('test1'+Integer.valueOf(aggResults[0].get('mxCnt')));
            count = Integer.valueOf(aggResults[0].get('mxCnt'));
        }
        else{
            count = 0;
        }
        
        for(WOD_Payment__c p: paymentList){
            p.Claim_Creator_Email__c = clmMap.get(p.Claim__c).CreatedBy.Email ; //CER-74
            if(p.Approved__c ){p.Approval_Status__c = 'Approved';} //Divya
            if(p.Approval_Status__c == 'Approved'){p.Approved__c = true;} //Divya
            // need to restrict for roofing
            p.Payment_Type__c = recordTypeMap.get(p.RecordTypeId).Name;
            //CT Multi currency changes
            Decimal exchangeRate = 1.00000000;
            if(recordTypeMap.get(p.RecordTypeId).Name == 'Gelco'){
                p.Exchange_Rate__c = exchangeRate;
                p.Currency__c = 'USD';
                //Added sales org value directly from claim 11/10/2023
                p.Sales_org__c =clmMap.get(p.Claim__c).Sales_org__c;
               // p.Sales_org__c = '1501';        
            }
             else {

                if(clmMap.get(p.Claim__c).Currency__c == 'CAD' && clmMap.get(p.Claim__c).Sales_Org__c == '1102'){
                    if(currencyMap.containsKey(clmMap.get(p.Claim__c).Currency__c)){
                        exchangeRate = currencyMap.get(clmMap.get(p.Claim__c).Currency__c).Exchange_Rate__c;
                    }else{
                        p.addError('No Exchange rate defined for ' +clmMap.get(p.Claim__c).Country_BL__c);
                    }                    
                }
                p.Exchange_Rate__c = exchangeRate;
                p.Currency__c = clmMap.get(p.Claim__c).Currency__c;
                p.Sales_org__c = clmMap.get(p.Claim__c).Sales_org__c;
            }
            
            if(recordTypeMap.get(p.RecordTypeId).Name == 'Check'){                
                if(p.Sequence_Number__c ==null){
                    p.Sequence_Number__c = Decimal.valueOf(count + 1);
                }
                if(p.SAP_Accounts__c == null){
                    String setChar = '';
                    if(String.IsNotBlank(p.Settlement_Type__c)){
                        setChar = p.Settlement_Type__c.substring(0, 3);
                    }
                    String plantName = clmMap.get(p.Claim__c).Plant__r.SAP_Plant__c;
                  
                    SetSAPAccounts(p, plantName, setChar, clmMap.get(p.Claim__c).WOD_2__Warranty_Product__r.Product_Line__c);
                }
             }
             if(recordTypeMap.get(p.RecordTypeId).Name =='Gelco'){
               p.Check_Date__c = string.valueof(p.Gelco_Check_Date__c);
               //Making Gelco as Approved and Released to SAP on creation.
               p.Released_To_SAP__c = true;
               p.Approved__c = true;
               p.Approval_Status__c = 'Approved';
               p.Approval_Date_Time__c = datetime.now();
               p.Total_Amount__c = p.Total_Amount_Converted__c / p.Exchange_Rate__c;
               //Commented per CERP-25 - No need to check Gelco limits              
            }
            if(recordTypeMap.get(p.RecordTypeId).Name == 'Check' ||recordTypeMap.get(p.RecordTypeId).Name =='Gelco'){
                if(p.Remit_To__c == 'Home Owner'){
                    if(clmMap.get(p.Claim__c).ClaimType__c != 'International')
                            SetRemitToAddress(p, clmMap.get(p.Claim__c).First_Name__c, clmMap.get(p.Claim__c).Last_Name__c, clmMap.get(p.Claim__c).Address_1__c,clmMap.get(p.Claim__c).Address_2__c,clmMap.get(p.Claim__c).ZIP_Code_Postal_Code__c,clmMap.get(p.Claim__c).City__c,clmMap.get(p.Claim__c).State__c, clmMap.get(p.Claim__c).Organization__c , clmMap.get(p.Claim__c).Country__c,false);
                        else
                            SetRemitToAddress(p, clmMap.get(p.Claim__c).First_Name__c, clmMap.get(p.Claim__c).Last_Name__c, clmMap.get(p.Claim__c).Address_1__c,clmMap.get(p.Claim__c).Address_2__c,clmMap.get(p.Claim__c).ZIP_Code_Postal_Code__c,clmMap.get(p.Claim__c).City__c,clmMap.get(p.Claim__c).Custom_State__c, clmMap.get(p.Claim__c).Organization__c , clmMap.get(p.Claim__c).Country__c,false);
                    }else if(p.Remit_To__c == 'Distributor' || p.Remit_To__c == 'Lumberyard'  || p.Remit_To__c == 'Contractor' || p.Remit_To__c == 'Contractor2' || p.Remit_To__c == 'JobSite' || p.Remit_To__c == 'Inspector' || p.Remit_To__c == 'Inspector2' || p.Remit_To__c == 'Restoration Company'){
                        if(interestedPartyMap.containsKey(p.Claim__c) && interestedPartyMap.get(p.Claim__c).Type__c == p.Remit_To__c){
                            SetRemitToAddress(p,interestedPartyMap.get(p.Claim__c).First_Name__c,interestedPartyMap.get(p.Claim__c).Last_Name__c,interestedPartyMap.get(p.Claim__c).Address_1__c,interestedPartyMap.get(p.Claim__c).Address_2__c,interestedPartyMap.get(p.Claim__c).Zip_Code__c,interestedPartyMap.get(p.Claim__c).City__c,interestedPartyMap.get(p.Claim__c).State__c, interestedPartyMap.get(p.Claim__c).Name,interestedPartyMap.get(p.Claim__c).Country__c,false);
                        }else{
                            p.addError('Claim Interested Party not defined on the claim for ' + p.Remit_To__c);
                        }
                    }
                    else{
                        SetRemitToAddress(p, '','', '','', '','', '', '','',true);
                    }               
             }                   
             
            // need to restrict for siding
             if(recordTypeMap.get(p.RecordTypeId).Name == 'Log'){
                p.Total_Amount_Converted__c=p.Total_Amount__c;
            }
        }
        updateSoldTo(paymentList);
    }
    //Payment Changes - start
    /**
     * @description To handle after insert operation
     * @param paymentList List of payment record
    */
    public static void HandleAfterInsert(List <WOD_Payment__c> paymentList){
        WOD_PaymentTriggerHelper.setPaymentDateOnClaim(paymentList,new map<Id,WOD_Payment__c>());
    }
    
    //Payment Changes - start
    /**
     * @description To handle after update operation
     * @param paymentList List of payment record
     * @param paymentList Old Map of payment record
    */
    public static void HandleAfterUpdate(List <WOD_Payment__c> paymentList,map<Id,WOD_Payment__c> oldPaymentsmap){
        WOD_PaymentTriggerHelper.setPaymentDateOnClaim(paymentList,oldPaymentsmap);
    }
    
    /**
     * @description Update Payment Date on Claim
     * @param paymentList List of payment record
    */
    public static void setPaymentDateOnClaim(List <WOD_Payment__c> paymentList,map<Id,WOD_Payment__c> oldPaymentsmap){
        set<Id> claimIdSet = new set<Id>();
        List<WOD_2__Claim__c> updateClaimlst = new List<WOD_2__Claim__c>();
        
        for(WOD_Payment__c payment : paymentList){
            if(payment.Payment_Date__c != null && (oldPaymentsmap.isEmpty() || (!oldPaymentsmap.isEmpty() && payment.Payment_Date__c != oldPaymentsmap.get(payment.Id).Payment_Date__c)) ){
                claimIdSet.add(payment.Claim__c);
            }
            
        }
        
        if(!claimIdSet.isEmpty()){
            WOD_2__Claim__c updateClaim = null;
            for(WOD_2__Claim__c claim : [Select Id,(Select Id,Payment_Date__c from Payments__r where Payment_Date__c != null Order by CreatedDate ASC Limit 2) from WOD_2__Claim__c where Id In :claimIdSet ]){
                updateClaim = new WOD_2__Claim__c();
                updateClaim.Id = claim.Id;
                updateClaim.Payment_Date__c = claim.Payments__r[0].Payment_Date__c;
                updateClaim.Payment_Date_2__c = claim.Payments__r.Size() >= 2 ? claim.Payments__r[1].Payment_Date__c : null;
                updateClaimlst.add(updateClaim);
            }
        }
        
        if(!updateClaimlst.isEmpty()){
            Database.update(updateClaimlst,false);
        }
    }
    //Payment Changes - End
    /**
     * @description Set Remit To Address
     * @param payment  Payment Object
     * @param firstName First Name
     * @param lastName Last Name
     * @param address1 Address1
     * @param address2 Address2 
     * @param zip Zip Code
     * @param city City Name
     * @param state State
     * @param organization Organization name
     * @param country Country
     * @param isManualEntry Flag for Manual entry
    */
    private static void SetRemitToAddress(WOD_Payment__c payment,string firstName, string lastName, string address1, string address2, string zip, string city, string state, string organization, string country,boolean isManualEntry){
        
        if(!isManualEntry){
            payment.RemitTo_Country__c = country;
            Integer strLen = 0;
            if (!String.isBlank(organization)) {
              strLen = organization.length();
              }
            if (strLen > 50) {
                payment.addError('Organization is more than 50 characters. You must modify the Organization on the Claim before proceeding.');
                }   
            else {   
                payment.Organization__c = organization;
                }
            payment.RemitTo_FirstName__c = firstName;
            payment.RemitTo_LastName__c = lastName;
            payment.RemitTo_State__c = state;
            payment.RemitTo_ZipCode__c = zip;
            payment.RemitTo_City__c = city;
            payment.RemitTo_Address1__c= address1;
            payment.RemitTo_Address2__c = address2;         
        }
        boolean isOrgEmpty =String.isBlank(payment.Organization__c);
        boolean isFirstNameEmpty =String.isBlank(payment.RemitTo_FirstName__c);
        boolean isLastNameEmpty=String.isBlank(payment.RemitTo_LastName__c);
        boolean isCityEmpty=String.isBlank(payment.RemitTo_City__c);
        boolean isStateEmpty=String.isBlank(payment.RemitTo_State__c);
        boolean isAddress1Empty=String.isBlank(payment.RemitTo_Address1__c);
        boolean isZipCodeEmpty=String.isBlank(payment.RemitTo_ZipCode__c);
        boolean isCountryEmpty=String.isBlank(payment.RemitTo_Country__c);
        
        if(isOrgEmpty){
            if(isFirstNameEmpty || isLastNameEmpty || isCityEmpty || isStateEmpty || isZipCodeEmpty || isAddress1Empty || isCountryEmpty){
                payment.adderror('RemitTo (Organization or FirstName, LastName) and Address1, City, State, ZIPCode and Country  are mandatory');
            }
        }else if(isCityEmpty || isStateEmpty || isZipCodeEmpty || isAddress1Empty || isCountryEmpty){
            payment.adderror('RemitTo (Organization or FirstName, LastName) and Address1, City, State, ZIPCode and Country are mandatory');
        }
    }
    /**
     * @description Set Remit To Address
     * @param payment  Payment Object
     * @param plantCode Plant Code
     * @param settelemtType Warranty Settelemt Type
     * @param divCode Divison Code
    */
    private static void SetSAPAccounts(WOD_Payment__c payment, string plantCode, string settelemtType, String divCode){ //Divya
        if(string.isEmpty(plantCode))
            payment.addError('Plant is not specified for the claim');
        //??????????????
        List<WOD_Manufacturing_Plant__c> manuPlant;
        if(payment.Sales_Org__c == '1501' || payment.Sales_Org__c == '1102' || payment.Sales_Org__c == '1111' || payment.Sales_Org__c == '1021'){
            //CT Multi currency changes 
            //removed not condition in if condition if(payment.Sales_org__c != '1102' ) 
            if(payment.Sales_org__c == '1501'){
                system.debug('*****1');
                if(settelemtType!=null && settelemtType!='' && (settelemtType=='RCW' || settelemtType=='RSS')){
                    manuPlant =[Select Id From WOD_Manufacturing_Plant__c Where Warranty_Settelemt_Type__c =: settelemtType And Plant_Code__c  =: plantCode AND Company_Code__c IN ('2000')];
                }
                else{
                    manuPlant =[Select Id From WOD_Manufacturing_Plant__c Where Warranty_Settelemt_Type__c =: settelemtType And Plant_Code__c  =: plantCode AND Company_Code__c IN ('1000')];
                }
            } 
            else if(payment.Sales_org__c == '1102'){
                system.debug('*****2');
                manuPlant =[Select Id From WOD_Manufacturing_Plant__c Where Warranty_Settelemt_Type__c =: settelemtType And Plant_Code__c  =: plantCode AND Company_Code__c IN ('1102')];
            }
            else if(payment.Sales_org__c == '1021'){
                system.debug('*****3');
                manuPlant =[Select Id From WOD_Manufacturing_Plant__c Where Warranty_Settelemt_Type__c =: settelemtType And Plant_Code__c  =: plantCode AND Company_Code__c IN ('1021')];
            }
            else if(payment.Sales_org__c == '1111'){
                system.debug('*****4');
                manuPlant =[Select Id From WOD_Manufacturing_Plant__c Where Warranty_Settelemt_Type__c =: settelemtType And Plant_Code__c  =: plantCode AND Company_Code__c IN ('1111')];
            }
        }
        //Divya
        else{
            manuPlant =[Select Id From WOD_Manufacturing_Plant__c  Where Warranty_Settelemt_Type__c =: settelemtType And Plant_Code__c  =: plantCode And Divison_Code__c=:divCode];
        }
        if(manuPlant.size()>0){
            payment.SAP_Accounts__c =manuPlant[0].Id;
        }else{
            payment.addError('For the combination of Plant Code '+plantCode+' ,Settlement Type '+settelemtType+' and Claim region, SAP account is not specified');
        }
    }
}