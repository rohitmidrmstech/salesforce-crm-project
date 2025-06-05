/* **********************************************************************************************************************************
* Class Name   : RevalidateRebateQuickActionControllerV1
* Description  : Class to handle Revalidation on Assigned Credential
* Author       : Dipen
* Modified On   : Aug 08,2024
* Test Class   : RevalidateRebateQuickActionControlerTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Dipen			         30-01-2024          1000              Modified Development
* Dipen                  08-08-2024          1002              Modified for Cedar Impressions Promotion
* Hithesh				 15-11-2024			 				   Modified for the new data model with apex
**************************************************************************************************************************************/

public without sharing class RevalidateRebateQuickActionControllerV1 {
    @AuraEnabled
    public static void reValidateRebateClaim(String rebateClaimId){
        try{
            date lastDateFor2024 = date.valueof(system.label.RevalidateRebateQuickActionControllersubmitteddate); //resetclaimdate
            system.debug('lastDateFor2024==='+lastDateFor2024);
            list<Rebate_Claim__c> rebateClaim = new list<Rebate_Claim__c>();
            rebateClaim = [SELECT id,Submit_Date__c FROM Rebate_Claim__c WHERE id =:rebateClaimId];
            system.debug('rebateClaim==='+rebateClaim);
            date createdDate;
            for(Rebate_Claim__c rc: rebateClaim){
                createdDate = date.valueof(rc.Submit_Date__c);
            }
            system.debug('createdDate==='+createdDate);
            if(createdDate <= lastDateFor2024){
                system.debug('2024 and before Method is getting called');
                dpeProcessedClaims(rebateClaimId);
            }
            else{
                system.debug('2025 and later method is getting called');
                apexProcessedClaims(rebateClaimId);
            }
        } catch(Exception ex){ 
            system.debug('error-->'+ex.getMessage());
            system.debug('Line number ==='+ex.getLineNumber());
            system.debug('Stack trace==='+ ex.getStackTraceString());
            System.debug('Cause: ' + ex.getCause());
            System.debug('Exception type caught: ' + ex.getTypeName()); 
            throw new AuraHandledException('Unable to delete Payout Records and reset Rebate Status: ' + ex.getMessage());
        }
    }
    
    
    public static void dpeProcessedClaims(String rebateClaimId){
        
        //If the rebate claim is submitted on or before 31st dec 2024 below if condition should run
        System.debug('The code for 2024 is running');
        //delete ProgramRebateTypePayout (this will also delete child ProgramRebateTypPayoutSrc records)
        Delete [Select Id from ProgramRebateTypePayout where Rebate_Claims__c =: rebateClaimId];
        
        //delete RebateMemberAggregateItem
        delete [Select Id from RebateMemberAggregateItem where Rebate_Claim__c =: rebateClaimId];
        
        //delete RebateMemberProductAggregate
        delete [Select Id from RebateMemberProductAggregate where Rebate_Claim__c =: rebateClaimId];
        
        //delete Transaction Journals 
        Delete [Select Id from TransactionJournal where Rebate_Claim__c =: rebateClaimId];
        
        //delete Rebate claim aggregate
        Delete [Select Id from Rebate_Claim_Aggregate__c where Rebate_Claim__c =: rebateClaimId];
        
        
        //disable validation rules through custom setting
        Automation_Controller__c automationController = Automation_Controller__c.getValues(UserInfo.getUserId());    
        Boolean customSettingCreated = false;     
        Boolean customSettingUpdated = false; 
        if(automationController == null){
            automationController = new Automation_Controller__c(SetupOwnerId = UserInfo.getUserId(), AllValidationRulesEnabled__c = false);
            insert automationController;
            customSettingCreated = true;
        }
        else if(automationController.AllValidationRulesEnabled__c){
            automationController.AllValidationRulesEnabled__c = false;
            update automationController;
            customSettingUpdated = true;
        }
        
        
        //update rebate status and reset values
        Rebate_Claim__c rebateClaimToUpdate = [select id,Claim_Currency__c,Total_Rebate_Amount__c,Total_rebate_amt_USD_before_conv__c,Applied_Exchange_Rate__c,Review__c,Status__c,RecordType.name,Rebate_Program_Member__r.RebateProgram.Country__c from Rebate_Claim__c where id =:rebateClaimId];
        if(rebateClaimToUpdate.Rebate_Program_Member__r.RebateProgram.Country__c == RebateUtility.REBATE_PROGRAM_US){
            rebateClaimToUpdate.Claim_Currency__c = RebateUtility.USD_CURRENCY;
        }else if(rebateClaimToUpdate.Rebate_Program_Member__r.RebateProgram.Country__c == RebateUtility.REBATE_PROGRAM_CANADA){
            rebateClaimToUpdate.Claim_Currency__c = RebateUtility.CAD_CURRENCY;
        }
        rebateClaimToUpdate.Total_Rebate_Amount__c = null; 
        rebateClaimToUpdate.Total_rebate_amt_USD_before_conv__c = Null;
        rebateClaimToUpdate.Applied_Exchange_Rate__c = null;
        rebateClaimToUpdate.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STATUS_QA_IN_PROGRESS;
        if(rebateClaimToUpdate.recordtype.name == 'BSP' && rebateClaimToUpdate.Review__c == RebateUtility.CLAIM_REVIEW_NEEDED){
            rebateClaimToUpdate.Review__c = RebateUtility.CLAIM_REVIEW_DONE;
        }else{
            rebateClaimToUpdate.Review__c = Null;
        }
        update rebateClaimToUpdate;            
        /****** Logic start from here to correct assigned credentails value as well ******/
        Id contactid; Id Accountid;
        set<String> productcategoryname = new set<String>();
        for(RebateClaim rebateclaimitemobj:[Select Id,Product_Category1__c,Rebate_Claim__r.Submitted_By__r.AccountId,Rebate_Claim__r.Submitted_By__c from RebateClaim where Rebate_Claim__c=: rebateClaimId]){
            productcategoryname.add(rebateclaimitemobj.Product_Category1__c);
            contactid = rebateclaimitemobj.Rebate_Claim__r.Submitted_By__c;
            Accountid = rebateclaimitemobj.Rebate_Claim__r.Submitted_By__r.AccountId;
        }
        List<Assigned_Credential__c> assignedrecordlist = [Select id,Status__c,Credential_Category__c,Max_Payout_Quantity_Claimed__c from Assigned_Credential__c 
                                                           where Contact__c=: contactid AND Credential_Category__c In:productcategoryname];
        system.debug('assignedrecordlist==='+assignedrecordlist);
        
        list<Assigned_Credential_Account__c> assignedcredentailsaccount = [Select Id,Status__c,Credential_Category__c,Max_Payout_Quantity_Claimed__c from Assigned_Credential_Account__c 
                                                                           where Account__c=: Accountid AND Credential_Category__c In:productcategoryname];
        system.debug('assignedcredentailsaccount' + assignedcredentailsaccount);
        Decimal totalquantitysumforstonefacad;
        Decimal totalquantitysumforcerta;
        decimal totalquantitySumForUrbanReserve;
        decimal totalquantitySumForCedarImpressions;
        //Aggregate query to get all 
        for(AggregateResult ar:[Select Rebate_Claim_Item__r.Product.Product_Category__c category, sum(Quantity_Converted__c) sumquantityconverted from DPE_Base_Calculation__c 
                                where Rebate_Claim_Item__r.Rebate_Claim__c =: rebateClaimId  
                                GROUP BY Rebate_Claim_Item__r.Rebate_Claim__c,Rebate_Claim_Item__r.Product.Product_Category__c])
        { 
            if(ar.get('category') == 'STONEfacade'){
                totalquantitysumforstonefacad = (Decimal)ar.get('sumquantityconverted');
                system.debug('totalquantitysumforstonefacad==='+totalquantitysumforstonefacad);
                system.debug('(Decimal)ar.get(sumquantityconverted)'+(Decimal)ar.get('sumquantityconverted'));
            }else if(ar.get('category') == 'CERTAplank Reinforced Siding'){
                totalquantitysumforcerta = (Decimal)ar.get('sumquantityconverted');
            }else if(ar.get('category') == 'Urban Reserve')
            {
                totalquantitySumForUrbanReserve = (Decimal)ar.get('sumquantityconverted');
            }else if(ar.get('category') == 'Cedar Impressions')
            {
                totalquantitySumForCedarImpressions = (Decimal)ar.get('sumquantityconverted');
            }
            
        }
        List<Assigned_Credential__c> dmlassignedcredentaillist = new List<Assigned_Credential__c>();
        List<Assigned_Credential_Account__c> dmlaccountassignedcredentaillist = new List<Assigned_Credential_Account__c>();
        if(assignedrecordlist.size() > 0){
            for(Assigned_Credential__c assignedcredobj: assignedrecordlist){
                if(assignedcredobj.Credential_Category__c == 'STONEfacade' && totalquantitysumforstonefacad != null && assignedcredobj.Max_Payout_Quantity_Claimed__c >0.0){
                    assignedcredobj.Max_Payout_Quantity_Claimed__c = (assignedcredobj.Max_Payout_Quantity_Claimed__c - totalquantitysumforstonefacad);
                    assignedcredobj.Status__c='Active';
                }else if(assignedcredobj.Credential_Category__c == 'CERTAplank Reinforced Siding' && totalquantitysumforcerta != null && assignedcredobj.Max_Payout_Quantity_Claimed__c > 0.0){
                    assignedcredobj.Max_Payout_Quantity_Claimed__c = (assignedcredobj.Max_Payout_Quantity_Claimed__c - totalquantitysumforcerta);
                    assignedcredobj.Status__c='Active';
                }else if(assignedcredobj.Credential_Category__c == 'Urban Reserve' && totalquantitySumForUrbanReserve != null && assignedcredobj.Max_Payout_Quantity_Claimed__c > 0.0){
                    assignedcredobj.Max_Payout_Quantity_Claimed__c = (assignedcredobj.Max_Payout_Quantity_Claimed__c - totalquantitySumForUrbanReserve);
                    assignedcredobj.Status__c='Active';
                }else if(assignedcredobj.Credential_Category__c == 'Cedar Impressions' && totalquantitySumForCedarImpressions != null && assignedcredobj.Max_Payout_Quantity_Claimed__c > 0.0){
                    assignedcredobj.Max_Payout_Quantity_Claimed__c = (assignedcredobj.Max_Payout_Quantity_Claimed__c - totalquantitySumForCedarImpressions);
                    assignedcredobj.Status__c='Active';
                }
                dmlassignedcredentaillist.add(assignedcredobj);
            } 
        }
        
        if(assignedcredentailsaccount.size()>0){
            for(Assigned_Credential_Account__c assignedcredentialaccounobj:assignedcredentailsaccount){
                if(assignedcredentialaccounobj.Credential_Category__c == 'STONEfacade' && totalquantitysumforstonefacad != null && assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c >0.0){
                    assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c = (assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c - totalquantitysumforstonefacad);
                    assignedcredentialaccounobj.Status__c='Active';
                }else if(assignedcredentialaccounobj.Credential_Category__c == 'CERTAplank Reinforced Siding' && totalquantitysumforcerta != null && assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c >0.0){
                    assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c = (assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c - totalquantitysumforcerta);
                    assignedcredentialaccounobj.Status__c='Active';
                }else if(assignedcredentialaccounobj.Credential_Category__c == 'Urban Reserve' && totalquantitySumForUrbanReserve != null && assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c >0.0){
                    assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c = (assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c - totalquantitySumForUrbanReserve);
                    assignedcredentialaccounobj.Status__c='Active';
                }else if(assignedcredentialaccounobj.Credential_Category__c == 'Cedar Impressions' && totalquantitySumForCedarImpressions != null && assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c >0.0){
                    assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c = (assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c - totalquantitySumForCedarImpressions);
                    assignedcredentialaccounobj.Status__c='Active';
                }                
                
                dmlaccountassignedcredentaillist.add(assignedcredentialaccounobj);
            } 
        }
        
        //updating the assigned credentials max payout quantity value.
        if(dmlassignedcredentaillist.size() > 0){
            update dmlassignedcredentaillist; 
        }
        if(dmlaccountassignedcredentaillist.size() > 0){
            update dmlaccountassignedcredentaillist;
        }
        
        
        //enable validation rules back
        if(customSettingCreated){
            Delete automationController;
        }
        if(customSettingUpdated){
            automationController.AllValidationRulesEnabled__c = true;
            update automationController;
        }
    }
    
    
    public static void apexProcessedClaims(String rebateClaimId){
        //Below if condition is written so that if the rebate claim is submitted after the Dec. 31st 2024 below code should run.
        system.debug('The code for 2025 is running');
        //delete ProgramRebateTypePayout (this will also delete child ProgramRebateTypPayoutSrc records)
        Delete [Select Id from ProgramRebateTypePayout where Rebate_Claims__c =: rebateClaimId];
        
        //delete RebateMemberAggregateItem
        delete [Select Id from RebateMemberAggregateItem where Rebate_Claim__c =: rebateClaimId];
        
        //delete RebateMemberProductAggregate
        delete [Select Id from RebateMemberProductAggregate where Rebate_Claim__c =: rebateClaimId];
        
        //delete Rebate claim aggregate
        Delete [Select Id from Rebate_Claim_Aggregate__c where Rebate_Claim__c =: rebateClaimId];
        
        
        //disable validation rules through custom setting
        Automation_Controller__c automationController = Automation_Controller__c.getValues(UserInfo.getUserId());    
        Boolean customSettingCreated = false;     
        Boolean customSettingUpdated = false; 
        if(automationController == null){
            automationController = new Automation_Controller__c(SetupOwnerId = UserInfo.getUserId(), AllValidationRulesEnabled__c = false);
            insert automationController;
            customSettingCreated = true;
        }
        else if(automationController.AllValidationRulesEnabled__c){
            automationController.AllValidationRulesEnabled__c = false;
            update automationController;
            customSettingUpdated = true;
        }
        set<string> carryForwardCategories = new set<string>();
        for (DefineProductLevel__mdt dpd : [SELECT ID, No_Limit__c, Product_Category__c, Assigned_Credential_Level__c,Carry_Forward__c	 FROM DefineProductLevel__mdt WHERE Carry_Forward__c = True]) {
            carryForwardCategories.add(dpd.Product_Category__c);
            system.debug('carryForwardCategories==='+carryForwardCategories);
        }
        
        //update rebate status and reset values
        Rebate_Claim__c rebateClaimToUpdate = [select id,Claim_Currency__c,Total_Rebate_Amount__c,Total_rebate_amt_USD_before_conv__c,Applied_Exchange_Rate__c,Review__c,Status__c,RecordType.name,Rebate_Program_Member__r.RebateProgram.Country__c from Rebate_Claim__c where id =:rebateClaimId];
        if(rebateClaimToUpdate.Rebate_Program_Member__r.RebateProgram.Country__c == RebateUtility.REBATE_PROGRAM_US){
            rebateClaimToUpdate.Claim_Currency__c = RebateUtility.USD_CURRENCY;
        }else if(rebateClaimToUpdate.Rebate_Program_Member__r.RebateProgram.Country__c == RebateUtility.REBATE_PROGRAM_CANADA){
            rebateClaimToUpdate.Claim_Currency__c = RebateUtility.CAD_CURRENCY;
        }
        rebateClaimToUpdate.Total_Rebate_Amount__c = null; 
        rebateClaimToUpdate.Total_rebate_amt_USD_before_conv__c = Null;
        rebateClaimToUpdate.Applied_Exchange_Rate__c = null;
        rebateClaimToUpdate.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STATUS_QA_IN_PROGRESS;
        if(rebateClaimToUpdate.recordtype.name == 'BSP' && rebateClaimToUpdate.Review__c == RebateUtility.CLAIM_REVIEW_NEEDED){
            rebateClaimToUpdate.Review__c = RebateUtility.CLAIM_REVIEW_DONE;
        }else{
            rebateClaimToUpdate.Review__c = Null;
        }
        update rebateClaimToUpdate;            
        /****** Logic start from here to correct assigned credentails value as well ******/
        Id contactid; Id Accountid;
        set<String> productcategoryname = new set<String>();
        set<Date> claimDateOnly = new set<date>();
        Map<string, Credential__c> CredentialMap = new map<string, Credential__c>();
        set<string> exsistingCredentialsCategory = new set<string>();
        map<string,string> categoryCredentials = new map<string,string>();
        
        for(RebateClaim rebateclaimitemobj:[Select Id,Product_Category1__c,Rebate_Claim__r.Submitted_By__r.AccountId,Rebate_Claim__r.Submitted_By__c,ClaimDate from RebateClaim where Rebate_Claim__c=: rebateClaimId]){
            productcategoryname.add(rebateclaimitemobj.Product_Category1__c);
            contactid = rebateclaimitemobj.Rebate_Claim__r.Submitted_By__c;
            Accountid = rebateclaimitemobj.Rebate_Claim__r.Submitted_By__r.AccountId;
            claimDateOnly.add(Date.valueof(rebateclaimitemobj.ClaimDate));
            system.debug('claimDateOnly ==='+ claimDateOnly);
        }
        //fetch the credentials
        //    string credDate;
        //    map<string, string> credDateId = new map<string, string>();
        
        List<Credential__c> existingPromotions = [SELECT Id,Name,Start_Date__c,End_Date__c,Product_Category__c,Status__c FROM Credential__c 
                                                  WHERE Product_Category__c IN :productcategoryname AND Status__c = 'Active'
                                                  AND Start_Date__c <= :claimDateOnly 
                                                  AND End_Date__c >= :claimDateOnly
                                                  AND Status__c = 'Active'];
        system.debug('Promotion_Credential__c already exists for' +existingPromotions);
        // Map to store date to date mapping for quick lookup
        Map<Date, Date> claimDateMap = new Map<Date, Date>();
        for (Date claimDate : claimDateOnly) {
            claimDateMap.put(claimDate, claimDate);
        }
        string promoCategory;
        list<id> credIds = new list<id>();
        for(Credential__c pc:existingPromotions){
            if (pc.Start_Date__c != null && pc.End_Date__c != null) {
                // Iterate over the claimDateOnly within the promotion date range
                //   for (Date claimDate = pc.Start_Date__c; claimDate <= pc.End_Date__c; claimDate = claimDate.addDays(1)) {
                //      if (claimDateMap.containsKey(claimDate)) {
                promoCategory = pc.Product_Category__c;
                credIds.add(pc.id);
                system.debug('Id of credentials ===' +credIds);
                exsistingCredentialsCategory.add(promoCategory);
                categoryCredentials.put(promoCategory,promoCategory);
                system.debug('promoCategory157==='+promoCategory);
                CredentialMap.put(promoCategory , pc);
                system.debug('CredentialMap==='+CredentialMap);
                //       System.debug('Matching claimDate added to promotionDurationMap: ' + claimDate);
                //       credDate = claimDate + pc.Product_Category__c;
                //      system.debug('credDate==='+credDate);
                //      credDateId.put(credDate,pc.id);
                //     system.debug('credDateId==='+credDateId);
            }
            //    }
            //  }
        }
        
        map<string,Assigned_Credential__c> exsistingAssignedCred = new map<string,Assigned_Credential__c>();
        list<Assigned_Credential__c> assignedrecordlist = new list<Assigned_Credential__c>();
        for(Assigned_Credential__c Ac:[Select id,Status__c,Credential__c,Credential_Category__c,Max_Payout_Quantity_Claimed__c from Assigned_Credential__c where Contact__c=: contactid AND Credential__c IN : credIds] ){
            assignedrecordlist.add(Ac);
            exsistingAssignedCred.put(Ac.Credential_Category__c , Ac);
            system.debug('The exsistingAssignedCred map ==='+ exsistingAssignedCred);
            system.debug('Assigned record list ==='+assignedrecordlist);
        }
        
        map<string, Assigned_Credential_Account__c> exsistingAssignedCredAccount = new map<string, Assigned_Credential_Account__c>();
        list<Assigned_Credential_Account__c> assignedcredentailsaccount = new list<Assigned_Credential_Account__c>();
        for(Assigned_Credential_Account__c Acc: [Select Id,Status__c,Credential__c,Credential_Category__c,Max_Payout_Quantity_Claimed__c from Assigned_Credential_Account__c where Account__c=: Accountid AND Credential__c IN : credIds]){
            assignedcredentailsaccount.add(Acc);
            exsistingAssignedCredAccount.put(Acc.Credential_Category__c, Acc); 
            system.debug('Assigned credential account ==='+assignedcredentailsaccount);
            system.debug('The exsistingAssignedCredAccount==='+exsistingAssignedCredAccount);
        }
        
        Decimal QuanityToMinus;
        List<Assigned_Credential__c> dmlassignedcredentaillist = new List<Assigned_Credential__c>();
        List<Assigned_Credential_Account__c> dmlaccountassignedcredentaillist = new List<Assigned_Credential_Account__c>();
        
         list<TransactionJournal> tjList =  [Select Id,name,Promo_Quantity__c from TransactionJournal where Rebate_Claim__c =: rebateClaimId];
        for(TransactionJournal Tj : [Select Id,Promo_Quantity__c,UOMConversionFactor__c,Rebate_Claim_Item__r.ClaimDate, ProductId, Product.Product_Category__c from TransactionJournal where Rebate_Claim__c =: rebateClaimId AND Product.Product_Category__c IN: exsistingCredentialsCategory]){
            if(Tj.Promo_Quantity__c > 0){
                QuanityToMinus = Tj.Promo_Quantity__c * Tj.UOMConversionFactor__c;
                system.debug('Quanity to minus ===' + QuanityToMinus);
            }
            
            //  credDate = date.valueof(Tj.Rebate_Claim_Item__r.ClaimDate) + Tj.Product.Product_Category__c; 
            //  system.debug('credDate==='+credDate);
            //  system.debug('CredDateId ==='+credDateId.get(credDate));
            if(assignedrecordlist.size() > 0){
                Assigned_Credential__c assignedcredobj = exsistingAssignedCred.get(Tj.Product.Product_Category__c);
                //   if(assignedcredobj.Credential__c == credDateId.get(credDate)){
                if(CredentialMap.get(Tj.Product.Product_Category__c).id == assignedcredobj.Credential__c) {
                    if(QuanityToMinus > 0){
                        system.debug('The assigned credential is passed');
                        
                        assignedcredobj.Max_Payout_Quantity_Claimed__c = (assignedcredobj.Max_Payout_Quantity_Claimed__c - QuanityToMinus);
                        system.debug('assignedcredobj==='+assignedcredobj);
                        dmlassignedcredentaillist.add(assignedcredobj);
                    }
                }
                
                
                // }
            }
            if(assignedcredentailsaccount.size()>0){
                Assigned_Credential_Account__c assignedcredentialaccounobj = exsistingAssignedCredAccount.get(Tj.Product.Product_Category__c);
                //    if(assignedcredentialaccounobj.Credential__c == credDateId.get(credDate)){
                if(CredentialMap.get(Tj.Product.Product_Category__c).id == assignedcredentialaccounobj.Credential__c){
                    if(QuanityToMinus > 0){
                        system.debug('Assigned credential account is passed');
                        assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c = (assignedcredentialaccounobj.Max_Payout_Quantity_Claimed__c - QuanityToMinus);
                        system.debug('assignedcredentialaccounobj===' + assignedcredentialaccounobj);
                        dmlaccountassignedcredentaillist.add(assignedcredentialaccounobj);
                    }
                }
                //    }
            } 
        }
        //updating the assigned credentials max payout quantity value.
        if(dmlassignedcredentaillist.size() > 0){
            system.debug('dmlassignedcredentaillist==='+dmlassignedcredentaillist);
            update dmlassignedcredentaillist; 
        }
        if(dmlaccountassignedcredentaillist.size() > 0){
            system.debug('dmlaccountassignedcredentaillist==='+dmlaccountassignedcredentaillist);
            update dmlaccountassignedcredentaillist;
        }
        
        
        //enable validation rules back
        if(customSettingCreated){
            Delete automationController;
        }
        if(customSettingUpdated){
            automationController.AllValidationRulesEnabled__c = true;
            update automationController;
        }  
        
        //delete Transaction Journals 
        Delete [Select Id from TransactionJournal where Rebate_Claim__c =: rebateClaimId];
    }
}