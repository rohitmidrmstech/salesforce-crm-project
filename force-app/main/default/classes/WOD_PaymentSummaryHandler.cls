/**
 * @description This Class has been used to handle payment record and invoked from lwc component
*/
public without sharing class WOD_PaymentSummaryHandler {
    public WOD_PaymentSummaryHandler() {
    }
    /**
     * @description This method user to get list of payment  details.
     * @param claimid Claim Id
     * @return list of WOD_Payment__c object
    */
    @AuraEnabled(cacheable=false)
    public static List<WOD_Payment__c> getPaymentList(String claimid){
        List<WOD_Payment__c> lisPayment = new List<WOD_Payment__c>();
        for(WOD_Payment__c c: [SELECT Sent_To_SAP__c, Approval_Status__c, Approved__c, Order_Type__c, Check_Date__c,Check_Number__c,Claim__c,Division_Code__c,Id,Name,Order_Number__c,Order_Reason__c,Paid_Y_N__c,Payment_Type__c,Plant_Code__c,
                           RecordTypeId,Released_To_SAP__c,SAP_Accounts__c,Sequence_Number__c,Settlement_Type__c,Shipping_Condition__c,Ship_Credit_Debit_Date__c,Ship_To__c,Order_Check_Number__c,
                           Sold_To__c,Total_Cost__c,Total_Amount__C,Total_Amount_Converted__c,Void_WOD_Payment__c,Sales_Org__c,Currency__c FROM WOD_Payment__c Where Claim__c =: claimid ORDER BY CreatedDate DESC]) {
            lisPayment.add(c);                    
        }
        return lisPayment;
    }
    /**
     * @description This method user to update of payment  list.
     * @param queueApprovalIds list of payment Ids
     * @return list of WOD_Payment__c object
    */
    @AuraEnabled(cacheable=false)
    public static String updatePayment(List<String> listOfPaymentIds){
        List<WOD_Payment__c> lisPayment = new List<WOD_Payment__c>();
        try{
            for(String str:listOfPaymentIds){
                WOD_Payment__c pay = new WOD_Payment__c();
                pay.Id = str;
                pay.Approved__c = true;  
                pay.Approval_Status__c ='Approved';
                lisPayment.add(pay);
            }   
            if(lisPayment.Size() >0){
                update lisPayment;
            }  
            return 'success';
        }
        catch(DmlException e) {
            System.debug('The following exception has occurred: ' + e.getMessage()+e.getLineNumber());
            return e.getMessage()+e.getLineNumber();
        }
    }

    /**
     * @description This method user to get list of payment  details.
     * @param claimid Claim ID
     * @param queueApprovalIds list of payment Ids
     * @return message
    */
    @AuraEnabled(cacheable=false)
    public static String queueForApprovalSelected(Id claimId,List<String> queueApprovalIds){    
        String retMsg ='';
        List<WOD_2__Claim__c> tempListClaim = new List<WOD_2__Claim__c>();
        List<WOD_Payment__c> toUpdatePayment = new List<WOD_Payment__c>();
        Map<String,WOD_Payment_Line__c> plMap = new Map<String,WOD_Payment_Line__c>();
        tempListClaim = [SELECT Id,Approval_Status__c FROM WOD_2__Claim__c Where Id =: claimId AND Approval_Status__c = 'Initiated']; 
        for(WOD_Payment_Line__c pl : [select Id,name,Payment__c from WOD_Payment_Line__c where Payment__c =:queueApprovalIds]){
            plMap.put(pl.Payment__c, pl);
        }
        if(tempListClaim.size()==0){
            for(WOD_Payment__c pay:[Select name,Id,Approval_Status__c,Payment_Type__c FROM WOD_Payment__c where Id =:queueApprovalIds]){
                if(pay.Approval_Status__c!='Approved' && plMap.ContainsKey(pay.Id) && pay.Payment_Type__c !='Gelco'){
                    pay.Approval_Status__c ='Queued For Approval';
                    toUpdatePayment.add(pay);
                }
                else{
                    if(pay.Approval_Status__c!='Approved' && pay.Payment_Type__c !='Gelco'){
                        retMsg +=pay.name+'\n';
                    }
                }
                if(pay.Payment_Type__c =='Gelco'){
                    pay.Approval_Status__c ='Queued For Approval';
                    toUpdatePayment.add(pay);
                }
            }
        }
        else{
            retMsg ='Initiated'; // Pending for approval
        }   
        try{
            if(retMsg =='' || retMsg==null){
                update toUpdatePayment;
                retMsg ='Success';
            } 
        }
        catch(DMLException  ex){
            retMsg = ex.getDmlMessage(0);
        }
            
        return retMsg;
    }

    /**
     * @description This method user to SAP realeased.
     * @param realeaseToSapIds list of payment Ids
     * @param buName Business unit 
     * @return message
    */
    @AuraEnabled(cacheable=false)
    public static String processSelected(List<String> realeaseToSapIds,String buName){
        User usr=[select id,profile.name from user where id=:userinfo.getuserid()];
        if(usr.profile.name =='Warranty Processor Siding'){
            return 'You are not allowed to perform this step.';
        }
        String returnMsg ='';

        List<WOD_Payment__c> PaymentSapList = new List<WOD_Payment__c>();
        Map<Id,WOD_Payment__c> selectedonHold = new map<Id,WOD_Payment__c>();
        List<WOD_SAP_Log__c> logs = new List<WOD_SAP_Log__c>();
        for(WOD_Payment__c c: [SELECT Sent_To_SAP__c,  Approved__c,Check_Date__c,Check_Number__c,Claim__c,Claim__r.Business_Units__c,Division_Code__c,Id,Name,Order_Number__c,Order_Reason__c,Paid_Y_N__c,Payment_Type__c,Plant_Code__c,
                  RecordTypeId,Released_To_SAP__c,SAP_Accounts__c,Sequence_Number__c,Settlement_Type__c,Shipping_Condition__c,Ship_Credit_Debit_Date__c,Ship_To__c,
                  Sold_To__c,Total_Cost__c,Total_Amount__C,Void_WOD_Payment__c, Claim__r.isClassAction__c, Claim__r.Country_BL__c, Currency__c, Sales_Org__c, Total_Amount_Converted__c
                           FROM WOD_Payment__c Where Id =: realeaseToSapIds AND Released_To_SAP__c = false  AND Payment_Type__c != 'Gelco' AND  Payment_Type__c !='Log']) {
                  
            PaymentSapList.add(c);
       }
        if(PaymentSapList.size() == 0){
           // if(buName == 'Roofing'){
            if(buName=='Roofing' || buName=='Commercial Building & Infrastructure' || buName=='Solar Solutions'){//CER-211
                return 'Either already released to SAP or Payment type is Gelco.';
            }
            else{
                return 'Either already released to SAP or Payment type is Log.';
            }
           
        } 
 
        for(WOD_Payment__c pPay :PaymentSapList){
           system.debug('@@@pPay'+pPay);
            if(pPay.Approved__c == true) {
                //Added check to ensure that if Country = CA and currency!= CAD, then dont process further
                if(pPay.Claim__r.Country_BL__c == 'Canada' && pPay.Currency__c != 'CAD' && pPay.Claim__r.isClassAction__c == false && (pPay.Sales_Org__c == '1501')/*TECP-705*/){
                    return 'Currency for all Canadian payment needs to be CAD to be released to SAP';
                }
                if( (pPay.Payment_Type__c == 'Free Material' || pPay.Payment_Type__c == 'Credit/Debit') && pPay.Released_To_SAP__c == false){
                    if(pPay.Payment_Type__c == 'Credit/Debit' && (pPay.Sales_Org__c == '1501' || pPay.Sales_Org__c =='1102' || pPay.Sales_Org__c =='1111' || pPay.Sales_Org__c =='1021')){ //CER-211
                        String isValidCredDebitRelDays = ValidateCreditDebitReleaseDays();
                        if( isValidCredDebitRelDays == 'Credit and Debit business days not defined. Please contact Warranty Admin team'){
                            return 'Credit and Debit business days not defined. Please contact Warranty Admin team';
                        }
                        else if(pPay.Payment_Type__c == 'Credit/Debit' && isValidCredDebitRelDays == 'true'){
                            return 'Credit and Debit payments cannot be released to SAP during the first 2 business days of the month';
                        }
                    }
                    try{
                        WOD_SAP_Log__c log = WOD_PaymentManager.SendOrderToSAP(pPay.Id);
                            if(!log.Has_Error__c){
                                pPay.Released_To_SAP__c = true;
                                pPay.Order_Number__c = log.Response__c;
                                pPay.Ship_Credit_Debit_Date__c = string.valueof(date.today().format());
                                pPay.Sent_To_SAP__C = 'Success';                            
                            }else{
                                pPay.Sent_To_SAP__C = 'Failed ';
                            }
                            logs.add(log);
                            returnMsg = 'Processed';
                        }
                        catch(Exception e){
                            system.debug('Error'+e.getStackTraceString());
                            pPay.Sent_To_SAP__c = 'Failed ';
                    }
                    selectedonHold.put(pPay.Id, pPay);
                }
                else if(pPay.Released_To_SAP__c == false && pPay.Payment_Type__c != 'Gelco'){
                    if(pPay.Payment_Type__c == 'Check' && pPay.SAP_Accounts__c == null){
                        return 'Ensure that all check payments have associated GL Account/Profit Center details';
                    }
                    //Added condition to ensure all check payments have currency, sales org, total amount(USD/CAD) populated
                    else if(pPay.Payment_Type__c == 'Check' && 
                            (pPay.Currency__c == null || pPay.Sales_Org__c == null || pPay.Total_Amount_Converted__c == null)){
                                return 'Ensure that all check payments have Currency, Sales Org and Total Amount (USD/CAD) populated';
                            }
                    else{
                        pPay.Released_To_SAP__c = true;
                        pPay.Sent_To_SAP__C = 'Success';
                        selectedonHold.put(pPay.Id, pPay);
                        returnMsg = 'Processed';
                    }
                }
                
            }
            else{
                return 'Only Approved Payment can be processed.';
            }
        }
        try{
            insert logs;
        }   
        catch(DMLException  ex){
            returnMsg = ex.getDmlMessage(0);
        }
       
        for(WOD_SAP_Log__c log: logs){
            WOD_Payment__c wrapper = selectedonHold.get(log.payment_id__c);
            if(wrapper != null){
                system.debug('PPP'+wrapper.Sent_To_SAP__c + log.Id);
                wrapper.Sent_To_SAP__c =wrapper.Sent_To_SAP__c + log.Id;
            }
        }
        try{
            update selectedonHold.values();
            PaymentSapList = null;
        }
        catch(DMLException  ex){
            returnMsg = ex.getDmlMessage(0);
        }
        return returnMsg;
    }
    /**
     * @description Credit Debit Release Days Validation
     * @return message
    */
    public static String ValidateCreditDebitReleaseDays(){  
        String inValidReleaseDate = 'false';
        string todaysmonth = String.valueof(System.today().month());
        if(todaysmonth.length() == 1){
            todaysmonth = '0' + todaysmonth;
        }
        string todaysyear = String.valueof(System.today().year());
        Integer firstdate;
        List<CreditDebit_Release_Day__c> alldates = [select Id,Date__c from CreditDebit_Release_Day__c where Year__c= :todaysyear and Month__c =:todaysmonth ORDER by Date__c desc];
        system.debug('@@@alldates'+alldates);
        if(alldates.size() > 0){
            firstdate = Integer.valueOf(alldates[0].Date__c);
        }
        else{
           return 'Credit and Debit business days not defined. Please contact Warranty Admin team';
        }
        if((System.today().day()) < firstdate){
            inValidReleaseDate = 'true';
        }
        return inValidReleaseDate;
    }

    @AuraEnabled
    public static Map<String,String> getUserInfo(String paymentId){
        String perSet='';
        Map<String,String> details=new Map<String,String>();
        WOD_Payment__c payment = new WOD_Payment__c();
        User usr=[Select id,Name,ProfileId,Profile.Name from User where id =: Userinfo.getUserId()];
        List<PermissionSetAssignment> pset = [SELECT Id,Assignee.Name,PermissionSet.Name, PermissionSet.Label 
                                                     FROM PermissionSetAssignment WHERE AssigneeId =: UserInfo.getUserId() ];
        
        if(pset != null){
            for(PermissionSetAssignment p :pset){
                perSet=perSet+','+p.PermissionSet.Name;
            }
        }
        details.put('PermissionSet',perSet);
        details.put('Profile',usr.Profile.Name);
        payment =[Select id,Approval_Status__c,RecordTypeId,Sales_Org__c,Approved__c,
                  Released_To_SAP__c,Void_WOD_Payment__c from WOD_Payment__c where Id =: paymentId];
        details.put('Payment',JSON.serialize(payment));
        System.debug('@details :: '+details);
        return details;
    }
   
}