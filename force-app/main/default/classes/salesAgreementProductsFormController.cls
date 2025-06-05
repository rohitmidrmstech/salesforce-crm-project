public with sharing class salesAgreementProductsFormController {
    public static final string BSP_PROGRAM = 'BSP';
    public static final string BIR_PROGRAM = 'BIR';
    public static final string CCB_PROGRAM = 'CCB';
    // Added BP_PROGRAM for the BP Canada CCB.
    public static final string BP_PROGRAM = 'BP';
    public static final string CP_PROGRAM = 'CP';
    public static final string STATUS_ACTIVE = 'Active';
    public static final string BSP_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME = 'BSP';
    public static final string BSP_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME = 'BSP';

    public static final string REBATE_STATUS_DEAL = 'Deal';
    public static final string ELIGIBLE = 'Eligible';
    public static final string OFFER_TYPE_MARKETING = 'Marketing';
    public static final string OFFER_TYPE_NONTIER = 'Non-Tiered';
    public static final string OFFER_TYPE_TIER = 'Tier';
    public static final string BASIS_DOLLAR = '$ Per Unit';
    public static final string BASIS_PERCENT = '% Of Sales';
    public static final string BIR_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME = 'BIR';
    public static final string BIR_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME = 'BIR';

    
    @AuraEnabled(cacheable=true)
    public static List<String> getEligibility(String contactId) {
        System.debug('contactId==>'+contactId);
        Contact rebateContact =RebateUtility.getRebateContact(contactId);
         System.debug('rebateContact==>'+rebateContact);

        List<String> results = New List<String>();
        if(rebateContact.BIR_Eligibility__c == ELIGIBLE){
            List<SalesAgreement> sas = [Select Id From SalesAgreement 
                                        Where IndirectRebate_Status__c =: REBATE_STATUS_DEAL 
                                        And (Agreement_Year__c = :String.valueOf(Date.today().Year()) Or Agreement_Year__c = :String.valueOf(Date.today().Year()-1)) 
                                        And AccountId = :rebateContact.AccountId ];
            if(sas.size() > 0){
                results.add(BIR_PROGRAM);
            }
        }
        //BSP Eligibility
        if(rebateContact.BSP_Eligibility__c == ELIGIBLE ||  RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.BSP_Eligibility__c)){
            List<String> applicableYears = new List<String>{String.valueOf(Date.today().Year()-1)};
            if(rebateContact.BSP_Eligibility__c == ELIGIBLE){
                applicableYears.add(String.valueOf(Date.today().Year()));
            }

            List<RebateProgram> rps = [Select Id From RebateProgram Where Status =: STATUS_ACTIVE And Rebate_Program_Type__c =:BSP_PROGRAM 
                                       And (Program_Active_Year__c in: applicableYears) 
                                       And Id IN (Select RebateProgramId From RebateProgramMember Where AccountId = :rebateContact.AccountId and MemberStatus =:STATUS_ACTIVE)];
            if(rps.size() > 0){
                results.add(BSP_PROGRAM);
            }      
        }
        //CCB Eligibility
        if((rebateContact.CCB_Eligibility__c == ELIGIBLE || RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.CCB_Eligibility__c)) && rebateContact.Distributor__c != 'Yes'){
            List<String> applicableYears = new List<String>{String.valueOf(Date.today().Year()-1)};
            if(rebateContact.CCB_Eligibility__c == ELIGIBLE){
                applicableYears.add(String.valueOf(Date.today().Year()));
            }
            List<RebateProgram> rps = [Select Id From RebateProgram 
                                      Where Status =: STATUS_ACTIVE And Rebate_Program_Type__c =:CCB_PROGRAM 
                                      And (Program_Active_Year__c in:applicableYears) 
                                      And Id IN (Select RebateProgramId From RebateProgramMember Where Contact__c = :rebateContact.Id and MemberStatus =:STATUS_ACTIVE)];
            if(rps.size() > 0){
                results.add(CCB_PROGRAM);
            }
        }
        //CP Eligibility
        if(rebateContact.Change_Pay_Eligibility__c == ELIGIBLE || RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.Change_Pay_Eligibility__c)){
            List<String> applicableYears = new List<String>{String.valueOf(Date.today().Year()-1)};
            if(rebateContact.Change_Pay_Eligibility__c == ELIGIBLE){
                applicableYears.add(String.valueOf(Date.today().Year()));
            }
            List<RebateProgram> rps = [Select Id From RebateProgram Where Status =: STATUS_ACTIVE And Rebate_Program_Type__c =:CP_PROGRAM 
                                      And (Program_Active_Year__c in: applicableYears) 
                                      And Id IN (Select RebateProgramId From RebateProgramMember Where Contact__c = :rebateContact.ID and MemberStatus =:STATUS_ACTIVE)];
            if(rps.size() > 0){
                results.add(CP_PROGRAM);
            }
        }
        
        if(results.size() == 0){
            results.add('None');
        }
        
        return results;
    }
    
    @AuraEnabled(cacheable=true)
    public static List<String> getYears(String program, String contactId) {
        Contact rebateContact = RebateUtility.getRebateContact(contactId); 
        List<String> results = New List<String>();
        if(program == BIR_PROGRAM){
            List<SalesAgreement> sas = [Select Agreement_Year__c From SalesAgreement 
                                        Where IndirectRebate_Status__c =: REBATE_STATUS_DEAL And StartDate < TODAY and AccountId =: rebateContact.AccountId
                                        And (Agreement_Year__c = :String.valueOf(Date.today().Year()) Or Agreement_Year__c = :String.valueOf(Date.today().Year()-1))];
            for(SalesAgreement sa : sas){
                if(!results.contains(sa.Agreement_Year__c)){
                    results.add(sa.Agreement_Year__c);
                }        
            }
        } 
        else {
            if(program == BSP_PROGRAM ){    
                if(rebateContact.BSP_Eligibility__c == ELIGIBLE ) {           
                    List<RebateProgram> rps = [Select Program_Active_Year__c From RebateProgram 
                                               Where Status =: STATUS_ACTIVE And StartDate <= TODAY and Rebate_Program_Type__c =:program 
                                               and Id  In (Select RebateProgramId From RebateProgramMember Where AccountId = :rebateContact.AccountId and MemberStatus =:STATUS_ACTIVE)
                                               and (Program_Active_Year__c = :String.valueOf(Date.today().Year()-1) or Program_Active_Year__c = :String.valueOf(Date.today().Year()))];
                    for(RebateProgram rp : rps){
                        if(!results.contains(rp.Program_Active_Year__c)){
                            results.add(rp.Program_Active_Year__c);
                        }        
                    }
                }else if(RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.BSP_Eligibility__c)){
                    List<RebateProgram> rps = [Select Program_Active_Year__c From RebateProgram 
                                               Where  Program_Active_Year__c = :String.valueOf(Date.today().Year()-1) and  Status =: STATUS_ACTIVE 
                                               And StartDate <= TODAY and Rebate_Program_Type__c =:program 
                                               and Id  In (Select RebateProgramId From RebateProgramMember Where AccountId = :rebateContact.AccountId and MemberStatus =:STATUS_ACTIVE)];
                    for(RebateProgram rp : rps){
                        if(!results.contains(rp.Program_Active_Year__c)){
                            results.add(rp.Program_Active_Year__c);
                        }        
                    }    
                }
            }
            /**Added Country in the query to return logged in user Program Country for Canada BP and Canada CCB program.
              * Country is returning to show the bullets points on the UI, if logged in user Country is "Canada" 
              *  Handled Hard Close in the return part to not return if the currentDate is greater than HardCloseDate.
            */
            else if(program == CCB_PROGRAM || program == CP_PROGRAM){
                if((program == CCB_PROGRAM && rebateContact.CCB_Eligibility__c == ELIGIBLE) || (program == CP_PROGRAM && rebateContact.Change_Pay_Eligibility__c == ELIGIBLE)) { 
                    List<RebateProgram> rps = [Select Program_Active_Year__c,Country__c,Hard_Close_Date__c From RebateProgram 
                                            Where Status =: STATUS_ACTIVE And StartDate <= TODAY and Rebate_Program_Type__c =:program 
                                            and Id  In (Select RebateProgramId From RebateProgramMember Where Contact__c = :rebateContact.Id and MemberStatus =:STATUS_ACTIVE)
                                            and (Program_Active_Year__c = :String.valueOf(Date.today().Year()-1) or Program_Active_Year__c = :String.valueOf(Date.today().Year()))];
                    for(RebateProgram rp : rps){
                        // returning country as well to diffrentiate the logged in user Program country. 
                        if(rp.Country__c!=null){
                            if(!results.contains(rp.Country__c)){
                                results.add(rp.Country__c);
                            }    
                        }
                          if((!results.contains(rp.Program_Active_Year__c)) && (System.today() <= rp.Hard_Close_Date__c)){
                            results.add(rp.Program_Active_Year__c);
                        } 
                    }
                   
                }
                else if((program == CCB_PROGRAM && RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.CCB_Eligibility__c)) || (program == CP_PROGRAM && RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.Change_Pay_Eligibility__c) )) { 
                    List<RebateProgram> rps = [Select Program_Active_Year__c,Country__c,Hard_Close_Date__c From RebateProgram 
                                            Where Program_Active_Year__c = :String.valueOf(Date.today().Year()-1) and Status =: STATUS_ACTIVE And StartDate <= TODAY and Rebate_Program_Type__c =:program 
                                            and Id  In (Select RebateProgramId From RebateProgramMember Where Contact__c = :rebateContact.Id and MemberStatus =:STATUS_ACTIVE)];
                    for(RebateProgram rp : rps){
                        // returning country as well to diffrentiate the logged in user Program country. 
                        if(rp.Country__c!=null){
                            if(!results.contains(rp.Country__c)){
                                results.add(rp.Country__c);
                            }    
                        }
                         if((!results.contains(rp.Program_Active_Year__c)) && (System.today() <= rp.Hard_Close_Date__c)){
                            results.add(rp.Program_Active_Year__c);
                        }        
                    }
                }
            }
        }
        System.debug('results==>'+results);
        return results;
    }
    /**
     * getYearsBackendClaimSubmission - this method is wrote to show the Previous and Current year to the backend submission team.
     */
     @AuraEnabled(cacheable=true)
    public static List<String> getYearsBackendClaimSubmission(String program, String contactId) {
        Contact rebateContact = RebateUtility.getRebateContact(contactId); 
        List<String> results = New List<String>();
        if(program == BIR_PROGRAM){
            List<SalesAgreement> sas = [Select Agreement_Year__c From SalesAgreement 
                                        Where IndirectRebate_Status__c =: REBATE_STATUS_DEAL And StartDate < TODAY and AccountId =: rebateContact.AccountId
                                        And (Agreement_Year__c = :String.valueOf(Date.today().Year()) Or Agreement_Year__c = :String.valueOf(Date.today().Year()-1))];
            for(SalesAgreement sa : sas){
                if(!results.contains(sa.Agreement_Year__c)){
                    results.add(sa.Agreement_Year__c);
                }        
            }
        } 
        else {
            if(program == BSP_PROGRAM ){    
                if(rebateContact.BSP_Eligibility__c == ELIGIBLE ) {           
                    List<RebateProgram> rps = [Select Program_Active_Year__c From RebateProgram 
                                               Where Status =: STATUS_ACTIVE And StartDate <= TODAY and Rebate_Program_Type__c =:program 
                                               and Id  In (Select RebateProgramId From RebateProgramMember Where AccountId = :rebateContact.AccountId and MemberStatus =:STATUS_ACTIVE)
                                               and (Program_Active_Year__c = :String.valueOf(Date.today().Year()-1) or Program_Active_Year__c = :String.valueOf(Date.today().Year()))];
                    for(RebateProgram rp : rps){
                        if(!results.contains(rp.Program_Active_Year__c)){
                            results.add(rp.Program_Active_Year__c);
                        }        
                    }
                }else if(RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.BSP_Eligibility__c)){
                    List<RebateProgram> rps = [Select Program_Active_Year__c From RebateProgram 
                                               Where  Program_Active_Year__c = :String.valueOf(Date.today().Year()-1) and  Status =: STATUS_ACTIVE 
                                               And StartDate <= TODAY and Rebate_Program_Type__c =:program 
                                               and Id  In (Select RebateProgramId From RebateProgramMember Where AccountId = :rebateContact.AccountId and MemberStatus =:STATUS_ACTIVE)];
                    for(RebateProgram rp : rps){
                        if(!results.contains(rp.Program_Active_Year__c)){
                            results.add(rp.Program_Active_Year__c);
                        }        
                    }    
                }
            }
            /**Added Country in the query to return logged in user Program Country for Canada BP and Canada CCB program.
              * Country is returning to show the bullets points on the UI, if logged in user Country is "Canada" 
              *  Handled Hard Close in the return part to not return if the currentDate is greater than HardCloseDate.
            */
            else if(program == CCB_PROGRAM || program == CP_PROGRAM){
                if((program == CCB_PROGRAM && rebateContact.CCB_Eligibility__c == ELIGIBLE) || (program == CP_PROGRAM && rebateContact.Change_Pay_Eligibility__c == ELIGIBLE)) { 
                    List<RebateProgram> rps = [Select Program_Active_Year__c,Country__c,Hard_Close_Date__c From RebateProgram 
                                            Where Status =: STATUS_ACTIVE And StartDate <= TODAY and Rebate_Program_Type__c =:program 
                                            and Id  In (Select RebateProgramId From RebateProgramMember Where Contact__c = :rebateContact.Id and MemberStatus =:STATUS_ACTIVE)
                                            and (Program_Active_Year__c = :String.valueOf(Date.today().Year()-1) or Program_Active_Year__c = :String.valueOf(Date.today().Year()))];
                    for(RebateProgram rp : rps){
                        // returning country as well to diffrentiate the logged in user Program country. 
                        if(rp.Country__c!=null){
                            if(!results.contains(rp.Country__c)){
                                results.add(rp.Country__c);
                            }    
                        }
                          if((!results.contains(rp.Program_Active_Year__c))){
                            results.add(rp.Program_Active_Year__c);
                        } 
                    }
                   
                }
                else if((program == CCB_PROGRAM && RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.CCB_Eligibility__c)) || (program == CP_PROGRAM && RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.Change_Pay_Eligibility__c) )) { 
                    List<RebateProgram> rps = [Select Program_Active_Year__c,Country__c,Hard_Close_Date__c From RebateProgram 
                                            Where Program_Active_Year__c = :String.valueOf(Date.today().Year()-1) and Status =: STATUS_ACTIVE And StartDate <= TODAY and Rebate_Program_Type__c =:program 
                                            and Id  In (Select RebateProgramId From RebateProgramMember Where Contact__c = :rebateContact.Id and MemberStatus =:STATUS_ACTIVE)];
                    for(RebateProgram rp : rps){
                        // returning country as well to diffrentiate the logged in user Program country. 
                        if(rp.Country__c!=null){
                            if(!results.contains(rp.Country__c)){
                                results.add(rp.Country__c);
                            }    
                        }
                         if((!results.contains(rp.Program_Active_Year__c))){
                            results.add(rp.Program_Active_Year__c);
                        }        
                    }
                }
            }
        }
        System.debug('results==>'+results);
        return results;
    }
    // Added below method for the BP-CCB Canada to return the Program Active year for the contractor- it's specific for Canada Country only.
     /**
       * @param program -it will store the Program as "CCB"
       * @param selectedProgram -this parameter will accept the value as "BP"
       * @param contactId -contactId of Logged in user on experiance site.
       * Purpose: this method is used to return the the Active program year of contractor to display on the selection screen of the UI,in bullets point manner.
    */
    @AuraEnabled
    public static List<String> getBPProgramYears(String program,String selectedProgram, String contactId) {
        Contact rebateContact = RebateUtility.getRebateContact(contactId); 
        List<String> results = new List<String>();
        List<RebateProgram> rebatePrograms = new  List<RebateProgram>();
        String programSubTypeName='';
        if(selectedProgram == BP_PROGRAM){
            programSubTypeName=selectedProgram;
        }
        // if selected program is (BP or CCB) and contact is eligible then return the Active program year(previos, current) year.
        if(rebateContact.CCB_Eligibility__c == ELIGIBLE){
            rebatePrograms = [
                SELECT Program_Active_Year__c, Country__c,Hard_Close_Date__c
                FROM RebateProgram
                WHERE Status =: STATUS_ACTIVE
                AND StartDate <= TODAY
                AND Rebate_Program_Type__c =:program
                AND Rebate_Program_Sub_Type__c =:programSubTypeName
                AND Id IN (
                    SELECT RebateProgramId
                    FROM RebateProgramMember
                    WHERE Contact__c =:rebateContact.Id
                    AND MemberStatus =: STATUS_ACTIVE
                )
                AND (Program_Active_Year__c =:String.valueOf(Date.today().year() - 1) 
                     OR Program_Active_Year__c =:String.valueOf(Date.today().year()))]; 
        } 
        // if selected program is (BP or CCB) and contact is not eligible for the current year then return the previos Active program year.
        else if(program == CCB_PROGRAM && RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.CCB_Eligibility__c)){
            rebatePrograms = [
                SELECT Program_Active_Year__c, Country__c,Hard_Close_Date__c
                FROM RebateProgram
                WHERE Status =: STATUS_ACTIVE
                AND StartDate <= TODAY
                AND Rebate_Program_Type__c =:program
                AND Rebate_Program_Sub_Type__c =:programSubTypeName
                AND Id IN (
                    SELECT RebateProgramId
                    FROM RebateProgramMember
                    WHERE Contact__c =:rebateContact.Id
                    AND MemberStatus =: STATUS_ACTIVE
                )
                AND (Program_Active_Year__c =:String.valueOf(Date.today().year() - 1))
            ];
        }
        for (RebateProgram rp : rebatePrograms) {
            if((!results.contains(rp.Program_Active_Year__c)) && (System.today() <= rp.Hard_Close_Date__c)){
                results.add(rp.Program_Active_Year__c);
            }
        }
        System.debug('results==>'+results);
        return results;
    }
    /**
     * getBPProgramYearsForBackendSubmission - this method is wrote to show the Previous and Current year to the backend submission team.
     */     
    @AuraEnabled
    public static List<String> getBPProgramYearsForBackendSubmission(String program,String selectedProgram, String contactId) {
        System.debug('program==>'+program +'selectedProgram==>' +selectedProgram +'contactId==>'+contactId);
        Contact rebateContact = RebateUtility.getRebateContact(contactId); 
        List<String> results = new List<String>();
        List<RebateProgram> rebatePrograms = new  List<RebateProgram>();
        String programSubTypeName='';
        if(selectedProgram == BP_PROGRAM){
            programSubTypeName=selectedProgram;
        }
        // if selected program is (BP or CCB) and contact is eligible then return the Active program year(previos, current) year.
        if(rebateContact.CCB_Eligibility__c == ELIGIBLE){
            System.debug('programSubTypeName==>'+programSubTypeName);
            rebatePrograms = [
                SELECT Program_Active_Year__c, Country__c,Hard_Close_Date__c
                FROM RebateProgram
                WHERE Status =: STATUS_ACTIVE
                AND StartDate <= TODAY
                AND Rebate_Program_Type__c =:program
                AND Rebate_Program_Sub_Type__c =:programSubTypeName
                AND Id IN (
                    SELECT RebateProgramId
                    FROM RebateProgramMember
                    WHERE Contact__c =:rebateContact.Id
                    AND MemberStatus =: STATUS_ACTIVE
                )
                AND (Program_Active_Year__c =:String.valueOf(Date.today().year() - 1) 
                     OR Program_Active_Year__c =:String.valueOf(Date.today().year()))]; 
            System.debug('rebatePrograms==>'+rebatePrograms);
        } 
        // if selected program is (BP or CCB) and contact is not eligible for the current year then return the previos Active program year.
        else if(program == CCB_PROGRAM && RebateUtility.NOT_ELIGIBLE_CURRENT_YEAR.equalsIgnoreCase(rebateContact.CCB_Eligibility__c)){
            System.debug('selectedProgram==>'+selectedProgram);
            rebatePrograms = [
                SELECT Program_Active_Year__c, Country__c,Hard_Close_Date__c
                FROM RebateProgram
                WHERE Status =: STATUS_ACTIVE
                AND StartDate <= TODAY
                AND Rebate_Program_Type__c =:program
                AND Rebate_Program_Sub_Type__c =:programSubTypeName
                AND Id IN (
                    SELECT RebateProgramId
                    FROM RebateProgramMember
                    WHERE Contact__c =:rebateContact.Id
                    AND MemberStatus =: STATUS_ACTIVE
                )
                AND (Program_Active_Year__c =:String.valueOf(Date.today().year() - 1))
            ];
        }
        System.debug('rebatePrograms==>'+rebatePrograms);
        for (RebateProgram rp : rebatePrograms) {
            if((!results.contains(rp.Program_Active_Year__c))){
                results.add(rp.Program_Active_Year__c);
            }
        }
        System.debug('results==>'+results);
        return results;
    }
    
    
    @AuraEnabled
    public static String getException(String program,String  year, String contactId) {
        Contact rebateContact = RebateUtility.getRebateContact(contactId);
        String returnVal = 'N';
        if(program == BIR_PROGRAM){
            List<SalesAgreement> sas = [Select id From SalesAgreement 
                                        Where IndirectRebate_Status__c =: REBATE_STATUS_DEAL and Agreement_Year__c = :year 
                                        and AccountId =:rebateContact.AccountId and Hard_Close_Date__c  < TODAY];
            if (sas.size() > 0){
                returnVal ='Y';
            }
        }else  if(program == BSP_PROGRAM ){
            
            List<RebateProgram> pgm = [Select Id From RebateProgram Where Status =: STATUS_ACTIVE And Program_Active_Year__c = :year And  Hard_Close_Date__c  < TODAY 
            and Rebate_Program_Type__c =:program and Id  In (Select RebateProgramId From RebateProgramMember Where AccountId = :rebateContact.AccountId and  MemberStatus =:STATUS_ACTIVE)];
            if (pgm.size() > 0){
                returnVal ='Y';
            }
        }
        else if (program == CCB_PROGRAM || program == CP_PROGRAM){
            List<RebateProgram> pgm = [Select Id From RebateProgram 
                                      Where Status =: STATUS_ACTIVE And Program_Active_Year__c = :year 
                                      And  Hard_Close_Date__c  < TODAY and Rebate_Program_Type__c =:program 
                                      and Id  In (Select RebateProgramId From RebateProgramMember Where Contact__c = :rebateContact.Id and  MemberStatus =:STATUS_ACTIVE)];
            if (pgm.size() > 0){
                returnVal ='Y';
            }
        }
        return returnVal;
    }
    
    /*@AuraEnabled
    public static String getRebateClaimName(String  rebateId) {
        String returnVal = '';
        List<Rebate_claim__C> sas = [Select Name From Rebate_claim__C Where Id = :rebateId];
        if (sas.size() > 0){
            returnVal =sas[0].Name;
        }
        return returnVal; 
    }*/

    @AuraEnabled(cacheable=true)
    public static Map<String,List<SalesAgreementProduct>> getSalesAgreementProducts(NewClaimWrapper wrapper, String contactId) {
        Contact rebateContact = RebateUtility.getRebateContact(contactId); 
        Map<String, Set<String>> mapUOM = new Map<String, Set<String>>();
        Map<String, List<SalesAgreementProduct>> sapMap = New Map<String, List<SalesAgreementProduct>>();

        List<SalesAgreement> salesAgreements =  [SELECT Agreement_Year__c, Id, Sales_Agreement_Description__c , Name 
                                                From SalesAgreement 
                                                Where IndirectRebate_Status__c =: REBATE_STATUS_DEAL and Agreement_Year__c = :wrapper.year and AccountId = :rebateContact.AccountId];
        Map<Id, List<SalesAgreementProduct>> agreementIdProductMap = new Map<Id, List<SalesAgreementProduct>>();
        if(!salesAgreements.isEmpty()){   
            Boolean hasMarketingOrTierPercentBasis = false; //Marketing or Tier + % of Sales will use UOM of $
            List<String> offerTypes = new List<String>();    
            List<String> salesOrgs = new List<String>();       
            for(SalesAgreementProduct sap : [SELECT Product_Code__c, Id, Name, UOM__c, Offer_Type__c, Rate__c, Basis__c, SalesAgreement.RM_TM__c, SalesAgreement.StartDate, 
                                            SalesAgreement.EndDate, SalesAgreement.Accountid,SalesAgreement.Sales_Org__c,SalesAgreementId 
                                            FROM SalesAgreementProduct Where InActive__c = false and SalesAgreementId in :salesAgreements order by Offer_Type__c, Name ]){
                //add product to map
                if(agreementIdProductMap.containsKey(sap.SalesAgreementId)){
                    agreementIdProductMap.get(sap.SalesAgreementId).add(sap);
                }
                else{
                    agreementIdProductMap.put(sap.SalesAgreementId, new List<SalesAgreementProduct>{sap});
                }
                //check offer type
                if(sap.Offer_Type__c == OFFER_TYPE_MARKETING || (sap.Offer_Type__c == OFFER_TYPE_TIER &&  sap.Basis__c == BASIS_PERCENT)){
                    hasMarketingOrTierPercentBasis = true;
                }
                else if(sap.Offer_Type__c != null && sap.SalesAgreement.Sales_Org__c != null){
                    offerTypes.add(sap.Offer_Type__c);
                    salesOrgs.add(sap.SalesAgreement.Sales_Org__c);
                }
            }

            //get $ uom if applicable
            if(hasMarketingOrTierPercentBasis){
                List<UnitOfMeasure> uomDollar = [Select Id, Name from UnitOfMeasure where name ='$' limit 1];
                if(!uomDollar.isEmpty()){
                    mapUOM.put('UOM_$', new Set<String>{'{"label":"' + uomDollar[0].Name+ '","value":"'+ uomDollar[0].Id + '"}'});
                }
            }

            //get offer type based uoms if applicable
            if(!offerTypes.isEmpty()){
                String key,value;
                for(Product_UOM__c objProdUOM  : [SELECT Id, Product__c, Name, Offer_Type__c, Basis__c, Sales_Org__c, Applicable_Program__c, Unit_of_Measure__c, Unit_of_Measure__r.Name 
                                                    FROM Product_UOM__c where Applicable_Program__c =:BIR_PROGRAM and Unit_of_Measure__c != null and Offer_Type__c in: offerTypes 
                                                    and Sales_Org__c in: salesOrgs order by Unit_of_Measure__r.Name]){
                    key = null;
                    if(objProdUOM.Offer_Type__c == OFFER_TYPE_NONTIER){
                        key= objProdUOM.Offer_Type__c+'-'+objProdUOM.Sales_Org__c;
                    }
                    else if(objProdUOM.Offer_Type__c == OFFER_TYPE_TIER && objProdUOM.Basis__c == BASIS_DOLLAR && objProdUOM.Sales_Org__c != null){
                        key= objProdUOM.Offer_Type__c+'-'+objProdUOM.Basis__c+'-'+objProdUOM.Sales_Org__c;
                    }
                    if(key != null){
                        value = '{"label":"'+objProdUOM.Unit_of_Measure__r.Name+'","value":"'+objProdUOM.Unit_of_Measure__c+'"}';
                        if(mapUOM.get(key) == null){
                            mapUOM.put(key,new Set<String>{value});
                        }else{
                            mapUOM.get(key).add(value) ;
                        }
                    }
                }
            }
            //loop through sales agreement products and update uom
            for(SalesAgreement sa :  salesAgreements){
                if(agreementIdProductMap.containskey(sa.Id)){
                    List<SalesAgreementProduct> saps = agreementIdProductMap.get(sa.Id);
                    String key;
                    for(SalesAgreementProduct sap : saps){
                        key=null;
                        if(sap.Offer_Type__c == OFFER_TYPE_MARKETING || (sap.Offer_Type__c == OFFER_TYPE_TIER &&  sap.Basis__c == BASIS_PERCENT)){
                            key = 'UOM_$';
                        }else if(sap.Offer_Type__c == OFFER_TYPE_NONTIER){
                            key= sap.Offer_Type__c+'-'+sap.SalesAgreement.Sales_Org__c;
                        }else if(sap.Offer_Type__c == OFFER_TYPE_TIER && sap.Basis__c == BASIS_DOLLAR){
                            key= sap.Offer_Type__c+'-'+sap.Basis__c+'-'+sap.SalesAgreement.Sales_Org__c;
                        }
                        if(mapUOM.containsKey(key)){
                            sap.UOM__c = String.join(new List<String>(mapUOM.get(key)), ',');
                        }
                    }
                    sapMap.put(sa.Name + ' || ' + sa.Sales_Agreement_Description__c  + ' || ' + sa.Agreement_Year__c, saps);
                }
            }
        }        
        return sapMap;
    }
    
  @AuraEnabled(cacheable=true)
    public static Map<String,List<ProgramRebateTypeBenefit>> getProgramRebateTypes(NewClaimWrapper wrapper, string contactId) {
        if(String.isBlank(wrapper.program) || String.isBlank(wrapper.year)){
            return null;
        }
        Contact rebateContact = RebateUtility.getRebateContact(contactId);
        System.debug('rebateContact==>'+rebateContact);
        Map<String, List<ProgramRebateTypeBenefit>> prtMap = New Map<String, List<ProgramRebateTypeBenefit>>();
        Map<String, String> mapUOM = new Map<String, String>();

        List<ProgramRebateType> prts;
       
        if(CCB_PROGRAM.equalsIgnoreCase( wrapper.program) || CP_PROGRAM.equalsIgnoreCase( wrapper.program)){
           // Added below IF condition for the BP canada, if selectedProgram is "BP" then it will return the rebateType specific to that program only, else it will return "CCB" program rebate types.
            String programSubTypeName='';
            if(wrapper.selectedProgram == BP_PROGRAM){
                programSubTypeName=wrapper.selectedProgram;
            }
              prts = [Select Id, Name, Business_Units__c, Business_Units__r.Name 
                        From ProgramRebateType 
                        Where RebateProgramId In (Select RebateProgramId From RebateProgramMember 
                                                  Where Contact__c = :rebateContact.Id And RebateProgram.Program_Active_Year__c = :wrapper.year
                                                  and RebateProgram.Rebate_Program_Type__c =:wrapper.program and RebateProgram.Rebate_Program_Sub_Type__c =:programSubTypeName) 
                        and Business_Units__c != null
                        and Status = 'Active'];
            
        }
        else{
            
            prts = [Select Id, Name, Business_Units__c, Business_Units__r.Name 
                    From ProgramRebateType 
                    Where RebateProgramId In (Select RebateProgramId From RebateProgramMember 
                    Where AccountId = :rebateContact.AccountId And RebateProgram.Program_Active_Year__c = :wrapper.year 
                    and RebateProgram.Rebate_Program_Type__c =:wrapper.program) 
                    and Business_Units__c != null
                    and Status = 'Active'];
        }
        if(prts.size() > 0){
            Set<Id> ProgramRebateTypeIds = new Set<Id>();
            Set<Id> productIds = new Set<Id>();

            for(ProgramRebateType prt : prts){                
                ProgramRebateTypeIds.add(prt.Id);
            }    
            
            for(ProgramRebateTypeBenefit prtBenifit : [SELECT Id,UOM__c, Unit_of_Measure__c, ProductId,Product.Name, ProgramRebateTypeId, ProgramRebateType.Name,
                                                      ProgramRebateType.Business_Units__c, ProgramRebateType.Business_Units__r.Name, Product_Category__c
                                                       FROM ProgramRebateTypeBenefit 
                                                       Where ProgramRebateTypeId in :ProgramRebateTypeIds  and Status =:STATUS_ACTIVE and  Product_Category__c != null
                                                       Order By ProgramRebateType.Business_Units__r.Name DESC, Product_Category__c, Product.Name]){
                if(!prtMap.containsKey(prtBenifit.ProgramRebateType.Business_Units__r.Name)){
                    prtMap.put(prtBenifit.ProgramRebateType.Business_Units__r.Name, new List<ProgramRebateTypeBenefit>());
                }
                prtMap.get(prtBenifit.ProgramRebateType.Business_Units__r.Name).add(prtBenifit);
                if(prtBenifit.ProductId != null){
                    productIds.add(prtBenifit.ProductId);
                }
            }
            
            List<Product_UOM__c> listProdUOM = new List<Product_UOM__c>();

            if(!productIds.isEmpty()){
                if(wrapper.year == '2024'){                
                 listProdUOM = [SELECT Id, Product__c, Name, Product__r.Name, Offer_Type__c, Basis__c, Sales_Org__c, Applicable_Program__c, 
                                                    Unit_of_Measure__c, Unit_of_Measure__r.Name 
                                                    FROM Product_UOM__c 
                                                    WHERE Applicable_Program__c INCLUDES (:wrapper.program) 
                                                    AND Product__c IN :productIds
                                                    AND  (
                                                    NOT  (Product__r.Name = 'Ridge Vents - Stick' 
                                                        AND Unit_of_Measure__r.Name = 'Box')
                                                    )
                                                    AND (
                                                        Product__r.Name != 'Ridge Vents - Stick' 
                                                        OR Unit_of_Measure__r.Name != 'Box'
                                                    )
                                                    
                                                    order by Unit_of_Measure__r.Name];
                } else{
                     listProdUOM = [SELECT Id, Product__c, Name, Offer_Type__c, Basis__c, Sales_Org__c, Applicable_Program__c, 
                Unit_of_Measure__c, Unit_of_Measure__r.Name FROM Product_UOM__c where Applicable_Program__c INCLUDES (:wrapper.program) and Product__c in: productIds
                order by Unit_of_Measure__r.Name];
                }
                
                String key,value;
                
                for(Product_UOM__c objProdUOM :listProdUOM ) {
                    key=objProdUOM.Product__c;
                    value = '{"label":"'+objProdUOM.Unit_of_Measure__r.Name+'","value":"'+objProdUOM.Unit_of_Measure__c+'"}';
                  //  if(objProdUOM.Product__r.Name != 'Ridge Vents - Stick' && objProdUOM.Unit_of_Measure__r.Name != 'Box' && wrapper.year == '2024'){
                    if(mapUOM.get(key) == null){
                        mapUOM.put(key,value);
                    }else{
                        String val = mapUOM.get(key) ;
                        val=val+','+value;
                        mapUOM.put(key,val);
                    }
                 //   }
                }
            }

            //update product uom
            for(List<ProgramRebateTypeBenefit> benfitsList : prtMap.values()){
                for(ProgramRebateTypeBenefit prtBenefit: benfitsList){
                    if(prtBenefit.ProductId != null && mapUOM.containskey(prtBenefit.ProductId)){
                        prtBenefit.UOM__c   = mapUOM.get(prtBenefit.ProductId);
                    }
                }
            }
        }
        return prtMap;
    }

    /*@AuraEnabled( cacheable=true )  
    public static List < Product_UOM__c > fetchLoyaltyUOMS() 
    {
        try 
        {
             return [SELECT Id, Product__c, Name, Offer_Type__c, Basis__c, Sales_Org__c, Applicable_Program__c, Unit_of_Measure__r.Name FROM Product_UOM__c];             
        } 
        catch (Exception e) 
        {
            return null;
        }        
    }*/

    @AuraEnabled
    public static boolean isUserEligibileToSubmitBSPRebateOnBehalfOfCustomer(String contactId){
        try {
            Contact rebateContact = RebateUtility.getRebateContact(contactId);
            List<String> acceptedBSPTeamMemberRoles = new List<String>();
            Map<string, Account_Team_Role_To_Initiate_BSP_Claim__mdt> teamRolesMap = Account_Team_Role_To_Initiate_BSP_Claim__mdt.getAll();
            for(Account_Team_Role_To_Initiate_BSP_Claim__mdt teamRole: teamRolesMap.values()){
                acceptedBSPTeamMemberRoles.add(teamRole.label);
            }

            return RebateUtility.isUserMemberOfAccountTeam(rebateContact.AccountId, acceptedBSPTeamMemberRoles, Userinfo.getUserId());
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Rebate_claim__C  upsertBSPRebate(Rebate_claim__C rebateClaim, List<RebateClaim> claimItems, string year, string filesJSON, string contactId, boolean exceptionYear, boolean requiresBuilderReview,boolean saveOnly) {
        try{
            //create Rebate claim
            Contact rebateContact = RebateUtility.getRebateContact(contactId);
            Boolean newRebateClaim = rebateClaim.Id == null;
            if(newRebateClaim){
                rebateClaim.RecordTypeId = Schema.SObjectType.Rebate_claim__C.getRecordTypeInfosByDeveloperName().get(BSP_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
                rebateClaim.Submitted_By__c = rebateContact.Id;
                system.debug('rebateClaim.Submitted_By__c:: '+rebateClaim.Submitted_By__c);
                system.debug('rebateContact.AccountId:: '+rebateContact.AccountId);
                system.debug('BSP_PROGRAM:: '+BSP_PROGRAM);
                system.debug('year:: '+year);
                system.debug('STATUS_ACTIVE:: '+STATUS_ACTIVE);

                Id rpmId  = [Select id From RebateProgramMember 
                             Where AccountId = :rebateContact.AccountId 
                             and RebateProgram.Status =: STATUS_ACTIVE 
                             //and MemberStatus =: STATUS_ACTIVE And RebateProgram.Rebate_Program_Type__c =: BSP_PROGRAM 
                             and RebateProgram.Program_Active_Year__c = :year
                             order by Createddate Desc limit 1].Id;   
                System.debug('rpmId==>'+rpmId);
                rebateClaim.Rebate_Program_Member__c = rpmId;    
                rebateClaim.Submitted_For__c = rebateContact.AccountId;    
                
                //update source for rebates submitted by CT employees
                if(string.isNotBlank(contactId)){
                    if(requiresBuilderReview != null && requiresBuilderReview == true){
                        rebateClaim.Submission_Source__c =RebateUtility.REBATE_CLAIM_SOURCE_INITIATED_BY_BACK_OFFICE;
                    }
                    else{
                        rebateClaim.Submission_Source__c = RebateUtility.REBATE_CLAIM_SOURCE_SUBMITTED_BY_BACK_OFFICE;
                    }
                }
                if(exceptionYear != null && exceptionYear == true){
                    rebateClaim.Claim_Exception__c = true;                    
                } 
                if(saveOnly){
                    rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_DRAFT;
                }
            }                
            upsert rebateClaim;

            //create rebate claim items
            for(RebateClaim claimItem: claimItems){
                claimItem.ClaimAmount = 0;
                claimItem.RecordTypeId =  Schema.SObjectType.RebateClaim.getRecordTypeInfosByDeveloperName().get(BSP_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
                claimItem.Rebate_Claim__c = rebateClaim.Id;
                
            }
            upsert claimItems;

            if(!newRebateClaim){
                //delete removed Claim Items
                delete [Select Id from RebateClaim where Id not in: claimItems and Rebate_Claim__c =: rebateClaim.Id];
            }

            //associate files to rebate claim
            if(String.isNotBlank(filesJSON)){
                List<RebateUtility.FileWrapper> files = (List<RebateUtility.FileWrapper>)JSON.deserialize(filesJSON, List<RebateUtility.FileWrapper>.Class);
                RebateUtility.asscoaiteFilesToRecord(rebateClaim.Id , files);
            }     
            //submitted
            if(!saveOnly){
                rebateClaim.Submit_Date__c = Date.today();  
                if(exceptionYear != null && exceptionYear == true){
                    rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_EXCEPTION_SUBMITTED;
                }
                else{
                    rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_SUBMITTED;
                } 
                //Builder review submissions are saved as Draft
                if(requiresBuilderReview != null && requiresBuilderReview == true){
                    rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_DRAFT;
                }
                upsert rebateClaim;
            }              

            return [Select Id,name from Rebate_claim__C where Id =:rebateClaim.Id][0];
        }
        catch(Exception ex){
            System.debug('Ex LineNumber=='+ex.getLineNumber());
            System.debug('Ex LineNumber=='+ex.getStackTraceString());

            throw new AuraHandledException('Error Creating Building Solutions Rebate: '+ ex.getMessage());
        }
    }

    @AuraEnabled
    public static List<Rebate_claim__C>  upsertBIRRebate(List<Rebate_claim__c> rebateClaims, List<RebateClaim> claimItems, string filesJSON, string contactId, boolean exceptionYear, boolean saveOnly) {
        try{
            //create Rebate claim
            Contact rebateContact = RebateUtility.getRebateContact(contactId);
            for(Rebate_claim__c rebateClaim: rebateClaims){
                Boolean newRebateClaim = rebateClaim.Id == null;
                if(newRebateClaim){
                    rebateClaim.RecordTypeId = Schema.SObjectType.Rebate_claim__c.getRecordTypeInfosByDeveloperName().get(BIR_REBATE_CLAIM_HEADER_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
                    rebateClaim.Submitted_By__c = rebateContact.Id;                    
                    rebateClaim.Submitted_For__c = rebateContact.AccountId;    
                    
                    //update source for rebates submitted by CT employees
                    if(string.isNotBlank(contactId)){
                        rebateClaim.Submission_Source__c = RebateUtility.REBATE_CLAIM_SOURCE_SUBMITTED_BY_BACK_OFFICE;
                    }
                    if(exceptionYear != null && exceptionYear == true){
                        rebateClaim.Claim_Exception__c = true;                    
                    } 
                    if(saveOnly){
                        rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_DRAFT;
                    }
                }     
            }             
            upsert rebateClaims;

            Map<Id,Id> salesAgreementIdToRebateClaimsMap = new Map<Id,Id>();
            for(Rebate_claim__c rebateClaim: rebateClaims){
                salesAgreementIdToRebateClaimsMap.put(rebateClaim.Sales_Agreement__c, rebateClaim.Id);
            }


            //create rebate claim items
            Set<Id> salesagrrementProductIds = new Set<Id>();
            Map<Id,Id> salesAgreementProductToSalesAgreementId = new Map<Id,Id>();
            for(RebateClaim claimItem: claimItems){
                claimItem.ClaimAmount = 0;
                claimItem.RecordTypeId =  Schema.SObjectType.RebateClaim.getRecordTypeInfosByDeveloperName().get(BIR_REBATE_CLAIM_ITEM_RECORD_TYPE_DEVELOPER_NAME).getRecordTypeId(); 
                salesagrrementProductIds.add(claimItem.Sales_Agreement_Product__c);                
            }
            for(SalesAgreementProduct saProd: [Select Id, SalesAgreementId from SalesAgreementProduct where Id in: salesagrrementProductIds]){
                salesAgreementProductToSalesAgreementId.put(saProd.Id, saProd.SalesAgreementId);
            }
            for(RebateClaim claimItem: claimItems){
                claimItem.Rebate_Claim__c = salesAgreementIdToRebateClaimsMap.get(salesAgreementProductToSalesAgreementId.get(claimItem.Sales_Agreement_Product__c));
            }
            upsert claimItems;
            
            //delete removed Claim Items
            delete [Select Id from RebateClaim where Id not in: claimItems and Rebate_Claim__c in: rebateClaims];            

            //associate files to rebate claim
            if(String.isNotBlank(filesJSON)){
                List<RebateUtility.FileWrapper> files = (List<RebateUtility.FileWrapper>)JSON.deserialize(filesJSON, List<RebateUtility.FileWrapper>.Class);
                for(Rebate_claim__c rebateClaim: rebateClaims){
                    RebateUtility.asscoaiteFilesToRecord(rebateClaim.Id , files);
                }
            }     

            //submitted
            if(!saveOnly){
                for(Rebate_claim__c rebateClaim: rebateClaims){
                    rebateClaim.Submit_Date__c = Date.today();  
                    if(exceptionYear != null && exceptionYear == true){
                        rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_EXCEPTION_SUBMITTED;
                    }
                    else{
                        rebateClaim.Status__c = RebateUtility.REBATE_CLAIM_HEADER_STSTUS_SUBMITTED;
                    }
                }
                upsert  rebateClaims;
            }          

            return [Select Id,Name from Rebate_claim__C where Id in:rebateClaims];
        }
        catch(Exception ex){
            throw new AuraHandledException('Error Creating Business Indirect Rebate: '+ ex.getMessage());
        }
    }

    @AuraEnabled(cacheable=true)
    public static Map<String,Integer> getProductCategoryGroupMap(){
        try {
            Map<String,Integer> categoryGroupMap = new Map<String,Integer>();
            for(Product_Category_Group__mdt categoryGroup: Product_Category_Group__mdt.getAll().values()){
                categoryGroupMap.put(categoryGroup.MasterLabel, Integer.valueOf(categoryGroup.Group_Number__c));
            }
            return categoryGroupMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string getBSPInitializationData(String rebateClaimId) {

        try {

            Rebate_claim__C rebateClaim = [Select Id, Claim_From__c, Claim_To__c, Submitted_By__c from Rebate_claim__c	where Id =:	rebateClaimId];

            //initialize wrapper
            BSPInitilizationDataWrapper initializationData = new BSPInitilizationDataWrapper();
            initializationData.rebateClaimId = rebateClaim.Id;
            initializationData.submittedByContactId = rebateClaim.Submitted_By__c;
            initializationData.claimFrom = rebateClaim.Claim_From__c;
            initializationData.claimTo = rebateClaim.Claim_To__c;            
            initializationData.businessUnits = new List<BusinessUnitWrapper>();

            //initializete business unit wrapper
            BusinessUnitWrapper businessUnitWrapper = new BusinessUnitWrapper();
            businessUnitWrapper.activeProducts = new List<ProductWrapper>();

            //create rebate claim items
            for (RebateClaim claimItem: [Select Id, Rebate_Claim__c, Invoice_Number__c, ClaimDate, ProductId,Quantity, Unit_Of_Measure_Selected__c, 
                                        Product.Product_Category__c , Business_Units__r.Name
                                        from RebateClaim
                                        where Rebate_Claim__c =: rebateClaim.Id
                                        and Business_Units__c != null
                                        order by Business_Units__c]) {

                if (businessUnitWrapper.selectedBusinessUnit != claimItem.Business_Units__r.Name) {

                    if (businessUnitWrapper.selectedBusinessUnit !=	null) {
                        //add current business unit to list
                        initializationData.businessUnits.add(businessUnitWrapper);

                        //initilize new Invoice wrapper
                        businessUnitWrapper = new BusinessUnitWrapper();

                        businessUnitWrapper.activeProducts = new List<ProductWrapper>();
                    }

                }

                businessUnitWrapper.selectedBusinessUnit = claimItem.Business_Units__r.Name;
                
                ProductWrapper pWrapper = new ProductWrapper();
                pWrapper.rebateClaimItemId = claimItem.Id;
                pWrapper.selectedCategory = claimItem.Product.Product_Category__c;
                pWrapper.selectedProduct = claimItem.ProductId;
                pWrapper.quantity = ClaimItem.Quantity;
                pWrapper.selectedUOM = claimItem.Unit_Of_Measure_Selected__c;
                businessUnitWrapper.activeProducts.add(pWrapper);
            }

            //add last business unit wrapper
            initializationData.businessUnits.add(businessUnitWrapper);

            //add files to wrapper
            initializationData.files = RebateUtility.getFilesList(rebateClaimId);
            
            return JSON.serialize(initializationData);
        } catch (Exception ex) {
            throw new AuraHandledException('Error Generating BSP Rebate Initialization data: ' + ex.getMessage());
        }
    }

    @AuraEnabled
    public static string getBIRInitializationData(String rebateClaimId) {
        try {

            Rebate_claim__C rebateClaim = [Select Id, Claim_From__c, Claim_To__c, Submitted_By__c, Sales_Agreement__c from Rebate_claim__c	where Id =:	rebateClaimId];

            //initialize wrapper
            BIRInitilizationDataWrapper initializationData = new BIRInitilizationDataWrapper();
            initializationData.rebateClaimId = rebateClaim.Id;
            initializationData.submittedByContactId = rebateClaim.Submitted_By__c;
            initializationData.salesAgreementId = rebateClaim.Sales_Agreement__c;                    
            initializationData.products = new List<ProductWrapper>();

            //create rebate claim items
            for (RebateClaim claimItem: [Select Id, Rebate_Claim__c, Invoice_Number__c, ClaimDate, Sales_Agreement_Product__c, Customer_Material__c, Customer_No__c,
                                        Expected_Rate__c, Expected_Payout__c, Supplier_Purchased_From__c, ProductId,Quantity, Unit_Of_Measure_Selected__c
                                        from RebateClaim
                                        where Rebate_Claim__c =: rebateClaim.Id
                                        and Sales_Agreement_Product__c != null
                                        order by Sales_Agreement_Product__c]) {   
                
                ProductWrapper pWrapper = new ProductWrapper();
                pWrapper.rebateClaimItemId = claimItem.Id;                
                pWrapper.selectedProduct = claimItem.Sales_Agreement_Product__c;
                pWrapper.quantity = ClaimItem.Quantity;
                pWrapper.selectedUOM = claimItem.Unit_Of_Measure_Selected__c;
                pWrapper.invoiceDate = claimItem.ClaimDate.date();
                pWrapper.customerMaterial = claimItem.Customer_Material__c;
                pWrapper.invoiceNumber = claimItem.Invoice_Number__c;
                pWrapper.customerNo = claimItem.Customer_No__c;
                pWrapper.expectedRate = claimItem.Expected_Rate__c;
                pWrapper.expectedPayout = claimItem.Expected_Payout__c;
                pWrapper.supplierPurchasedFrom = claimItem.Supplier_Purchased_From__c;
                initializationData.products.add(pWrapper);
            }

            //add files to wrapper
            initializationData.files = RebateUtility.getFilesList(rebateClaimId);
            
            return JSON.serialize(initializationData);
        } catch (Exception ex) {
            throw new AuraHandledException('Error Generating BIR Rebate Initialization data: ' + ex.getMessage());
        }
    }

    public class BSPInitilizationDataWrapper {
        public String 	rebateClaimId;
        public String 	submittedByContactId;
        public Date claimFrom;
        public Date claimTo;
        public List<BusinessUnitWrapper> businessUnits;
        public List<RebateUtility.FileWrapper> files;
    }

    public class BusinessUnitWrapper {
        public String selectedBusinessUnit;        
        public List<ProductWrapper> activeProducts;
    }

    public class ProductWrapper {
        public String selectedCategory;
        public String selectedProduct;
        public Decimal quantity;
        public String selectedUOM;
        public String rebateClaimItemId;
        public Date invoiceDate;
        public String customerMaterial;
        public String invoiceNumber;
        public String customerNo;
        public String expectedRate;
        public Decimal expectedPayout;
        public String supplierPurchasedFrom;
    }

    public class BIRInitilizationDataWrapper {
        public String 	rebateClaimId;
        public String 	salesAgreementId;
        public String 	submittedByContactId;      
        public List<ProductWrapper> products;
        public List<RebateUtility.FileWrapper> files;
    }
  
}