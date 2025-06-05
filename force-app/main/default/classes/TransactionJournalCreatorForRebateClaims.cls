/* @Author       Rohit
* @Date         16/10/2024
* @Description   Class to creates Transaction Journals (TJs) for each
*                RebateClaim line item associated with the Rebate Claims.
*                It also updates the values on the Assigned Credential Account and Assigned
*                Credential records only when the lineItems Product Category is under promotion.
Change Log:
*****************************************************************************************/
public class TransactionJournalCreatorForRebateClaims {
    public static List<Rebate_Claim__c> newRebateClaim;
    public static Map<Id, Rebate_Claim__c> oldMapcred;
    public static Map<string, string> assignedCredentialWithContact= new Map<string, string>();
     /**
       * @param listrebateClaims - List of new rebate claims to be processed.
       * @param oldMap - A map of rebate claims with their previous states.
       * Processes a list of rebate claims by identifying if the status is 'QA Completed'
       * and determines whether to process them synchronously or asynchronously (processRebateClaimQueueable).
    */
    public static void processQAComplete( List<Rebate_Claim__c> listrebateClaims,Map<Id,Rebate_Claim__c> oldMap){
        newRebateClaim = listrebateClaims;
        oldMapcred = oldMap;
        try {
            List<Id> rebateClaimIdsToProcess = new List<Id>();
            for(Rebate_Claim__c rc :listrebateClaims){
                if ((oldMap.get(rc.Id).Status__c != rc.Status__c) && rc.Status__c == 'QA Completed') {
                    rebateClaimIdsToProcess.add(rc.Id);
                }
            }
            if (!rebateClaimIdsToProcess.isEmpty()) {
                List<AggregateResult> groupedResults = [Select COUNT(Id) countRecords From RebateClaim WHERE  Rebate_Claim__c IN :rebateClaimIdsToProcess];
                Integer lineItemSize = (Integer)groupedResults[0].get('countRecords');
                // Added code to call the Asynchronous process if rebateLineItem size is greater 40 else call in the Synchronous processing.
                if(lineItemSize > Integer.ValueOf(Label.rebateLineItemsize)){                    
                    String oldMapJson = JSON.serialize(oldMapcred);    
                    // event bus will publish the popup message to user if line item size is more than expected
                    EventBus.publish(new Exception_Event__e(User_Ids__c=userinfo.getUserId(),Request__c=+'we are processing your claim, please wait for a while',Type__c='Information'));
                    System.enqueueJob(new processRebateClaimQueueable(rebateClaimIdsToProcess,listrebateClaims,oldMapJson));   
                } else {
                    processQACompletedRebateClaim(rebateClaimIdsToProcess,listrebateClaims,oldMapcred);
                }
            }
        }
        catch(exception ex){
            // if exception is occur while processing the record, then the status will revert back to the original status.
            Rebate_Claim__c rebateClaim = new Rebate_Claim__c(Id = newRebateClaim[0].Id, Status__c = oldMapcred.get(newRebateClaim[0].Id).Status__c);
            update rebateClaim;
            
            integer lineNumber = ex.getLineNumber();
            string errorMessage = ex.getmessage();
            // passing the exception line number to class and it will fetch the error from Data dictionary and will popup error message on the screen in user friendly manner.
            String errorMessageToDisplay = ExceptionHandlingHandler.handleException(lineNumber , 'TransactionJournalCreatorForRebateClaims');
            EventBus.publish(new Exception_Event__e(User_Ids__c=userinfo.getUserId(),Request__c= + errorMessageToDisplay,Type__c='Error'));
        }
    }
    
      /** 
     * Line Number(65-334)
     * @param rebateClaimHeaderIds - rebate claim Ids to get the related rebate Line Items .
     * @param listrebateClaims - List of new rebate claims to be processed.
     * @param oldMap - A map of rebate claims with their previous states.
     * this method will process the rebate claim and it's line item, and it will create the TJ record 
     * for each line item, as well it will update ACA and AC if product category is under promotion, once all tj got created
     * it will set the rebate claim status to processing.
     */
    public static void processQACompletedRebateClaim(List<Id> rebateClaimHeaderIds,
                                                     List<Rebate_Claim__c> listrebateClaims,
                                                     Map<Id,Rebate_Claim__c>oldMap
                                                    ) 
    {
        newRebateClaim = listrebateClaims;
        oldMapcred=oldMap;
        try{
            map<Id,decimal> conversionfactorvaluemap = new map<Id,decimal>();
             /**
            * Line Number(80-106)
            * Retrieves a list of RebateClaim Items records with related to rebate claims, 
            * This query filters records based on the provided rebate claim header IDs 
            * and ensures only records with the 'CCB' Record_Type__c value are selected.
             */
            List<RebateClaim> lstRebateClaimItems = [SELECT id, 
                                                     Record_Type__c,
                                                     Rejected__c,
                                                     ProductId,
                                                     Quantity,
                                                     Product_Id__c,
                                                     Account_Id__c,
                                                     Rebate_Claim__r.Submitted_By__c,
                                                     Rebate_Claim__r.Submitted_By__r.AccountId,
                                                     Unit_Of_Measure_Selected__c,
                                                     ClaimDate,
                                                     ClaimAmount,
                                                     Product_Category__c,
                                                     Product_Category__r.RebateProgram.Program_Active_Year__c,
                                                     Product_Category__r.RebateProgram.StartDate,
                                                     Product_Category__r.RebateProgram.EndDate,
                                                     Product_Category__r.RebateProgramId,
                                                     Rebate_Claim__c,
                                                     Product_Category1__c,
                                                     Rebate_Claim__r.Rebate_Program_Member__c, 
                                                     Rebate_Claim__r.Submit_Date__c,
                                                     Rebate_Claim__r.Status__c,
                                                     Rebate_Claim__r.Program_Active_Year__c,
                                                     Rebate_Claim__r.Program__c,
                                                     Business_Units__r.Company_Code__c
                                                     FROM RebateClaim
                                                     WHERE Rebate_Claim__c IN :rebateClaimHeaderIds AND Record_Type__c='CCB' AND Rejected__c!=true];
            if(lstRebateClaimItems.size() > 0){ 
                Set<Id> rebateClaimItemAccountId = new Set<Id>();
                Set<String> setproductcategory = new Set<String>();
                Set<Id> setprogramrebatetypeid = new Set<Id>();
                Set<Id> setproducts = new Set<Id>();   
                set<date> setofdates = new set<date>();
                set<id> contanctset = new set<id>();
                 /**
                * Line Number(121-130)
                * Processes rebate claim items by collecting unique identifiers and attributes for further operations.
                * Specifically, it gathers:
                * - Product categories,program rebate type IDs, Product IDs,Invoice date,
                * - Account and contact IDs associated with rebate claim line items.
                */
                for (RebateClaim rc : lstRebateClaimItems) {
                    if (rc.Product_Category__c != null) {
                        setproductcategory.add(rc.Product_Category1__c);
                        setprogramrebatetypeid.add(rc.Product_Category__c);
                        setproducts.add(rc.ProductId);
                        setofdates.add(rc.ClaimDate.date());
                        rebateClaimItemAccountId.add(rc.Rebate_Claim__r.Submitted_By__r.AccountId);
                        contanctset.add(rc.Rebate_Claim__r.Submitted_By__c);
                    }
                }
                Map<Id, Set<Id>> assignedcontactidmap = new Map<Id, Set<Id>>();
                /**
                 * Line Number(137-144)
                 * Queries Assigned_Credential__c records for contacts where the record type is 'Contractor_Credential'.
                 * it will fetch Credentials records like Siding 5 star,silver star and Gold bitumen etc...
                */
                for(Assigned_Credential__c acobj:[Select id,Contact__c,Credential__c,Status__c,Credential__r.Status__c from Assigned_Credential__c where Contact__c In:contanctset AND RecordType.DeveloperName = 'Contractor_Credential' AND Status__c='Active' AND Credential__r.Status__c='Active' ]){
                    if (acobj.Credential__c != null) {
                        if (!assignedcontactidmap.containsKey(acobj.Contact__c)) {
                            assignedcontactidmap.put(acobj.Contact__c, new Set<Id>());
                        }
                        assignedcontactidmap.get(acobj.Contact__c).add(acobj.Credential__c);
                    }
                }
                System.debug('assignedcontactidmap==>'+assignedcontactidmap);
               /** bucketsizecheck - method return Assigned credentials Account and Assigned Credentials records for rebate claims.
                 * it Queries for active Assigned_Credential_Account__c and Assigned_Credential__c records based on:
                 * - Product category, active status, start/end dates, and specified contact or account criteria.
                */
                
                Map<string,object> bucketsizecheckmap= bucketsizecheck(setproductcategory,setprogramrebatetypeid,setproducts,
                                                                       setofdates,rebateClaimItemAccountId,lstRebateClaimItems,contanctset);
                
                /**
                 * below Maps we have used to store objects specific data and it's all keys
                 * which we have returened from bucketsizecheck method.
                 */
                Map<string,Assigned_Credential_Account__c> assignedCredAccountmapwithobject =  (Map<string,Assigned_Credential_Account__c>)bucketsizecheckmap.get('assignedCredAccount');
                Map<string,Assigned_Credential__c> assignedcredentialmapwithobject =  (Map<string,Assigned_Credential__c>)bucketsizecheckmap.get('assignedcredential');
                Map<string,string> assignedCredAccountmap =  (Map<string,string>)bucketsizecheckmap.get('datewithid');
                //rebatebeniftmap will store the key as (RebateTypeId,Product Category,productId and benefit type) with this
                // diffrent parameters from benefit record and value as a ProgramRebateTypeBenefit.
                Map<string,ProgramRebateTypeBenefit> rebatebeniftmap = new Map<string,ProgramRebateTypeBenefit>();
                //mapUOM will store the key as (ProductId,FromUnitOfMeasureId,Program_Year__c and program year,Applicable program) with this
                // diffrent parameters from UOMC record and value as a UnitOfMeasureConversion.
                Map<String,UnitOfMeasureConversion> mapUOM = new Map<String,UnitOfMeasureConversion>();
                List<TransactionJournal> lstTj = new List<TransactionJournal>();
                String benefitkey ;
                 /**
                 * ProgramRebateTypeBenefit for loop queries all the benefit records based on product Id, Product Category,
                 * EffectiveStartDate, End Date and ProgramRebateTypeId where benefit record status is Active.
                 */
                for(ProgramRebateTypeBenefit prtb : [Select ProgramRebateTypeId,ProductId,EffectiveStartDate,EffectiveEndDate, 
                                                     BenefitValue,Stone_Facade_Benefit__c,Additional_Dollar_Benefit__c,
                                                     Additional_Percentage_Benefit__c,Benefit_Type__c,Credentialled_Benefit__c,
                                                     Credentialled_Benefit__r.Rebate_Benefits__c,Status,Product_Category__c,Unit_of_Measure__c
                                                     FROM ProgramRebateTypeBenefit 
                                                     Where (Status = 'Active') 
                                                     AND ProgramRebateTypeId IN :setprogramrebatetypeid 
                                                     AND ProductId IN :setproducts 
                                                     AND (EffectiveStartDate <= :setofdates
                                                          AND  EffectiveEndDate >= :setofdates) 
                                                     AND Product_Category__c IN:setproductcategory])
                {
                    benefitkey = '';
                    // created benefitkey to check the type of benefit record(Regular,promo) and use it for further processing.
                    benefitkey=prtb.ProgramRebateTypeId+prtb.Product_Category__c+prtb.ProductId+prtb.Benefit_Type__c;
                    if(prtb.Benefit_Type__c == 'Credentialled'){
                        //benefitkey-  store the key if the benefit type is Credentialled
                        benefitkey = benefitkey + prtb.Credentialled_Benefit__c;
                    }
                    rebatebeniftmap.put(Benefitkey,prtb); 
                }
                String unitKey;
                 /**
                 * Querying UnitOfMeasureConversion records that belong to specific programs ('CCB' or 'BSP;CCB')
                 * and have a Product__c field value matching any value in the setproducts( this products Id from rebate line Items) collection.
                 */
                for(UnitOfMeasureConversion uom : [SELECT Product__c,FromUnitOfMeasureId,ToUnitOfMeasureId,ConversionFactor,Applicable_Program__c,Program_Year__c 
                                                   FROM UnitOfMeasureConversion
                                                   WHERE (Applicable_Program__c = 'CCB' OR Applicable_Program__c = 'BSP;CCB') 
                                                   AND Product__c IN :setproducts])
                {
                    unitKey= '';
                    if (String.isNotBlank(uom.Applicable_Program__c)) {
                        unitKey= '#'+uom.Product__c+ uom.FromUnitOfMeasureId+ uom.Program_Year__c;
                        if(uom.Applicable_Program__c.contains(';')){
                            for(String str: uom.Applicable_Program__c.split(';')){                           
                                mapUOM.put(unitKey+str,uom);                    
                            }
                        }else{
                            mapUOM.put(unitKey+uom.Applicable_Program__c,uom); 
                        }
                    }
                }             
                string benefitrebatekey;           
                string benifittype='';
                string keytogetAssignedCredAccount;
                string keytogetAssignedCredential;
                string assignedcredAccountId;
                string assignedcredentialId;
                //productLevelCategory- map will store the key as product category and object level as (Account or contact) for calculating the promotion. 
                Map<string,String>productLevelCategory= new  Map<string,String>();
                //productcategorywithNoLimit- map will store the key as product category and  value is no limit(if the product category is having no limit).
                Map<string,Boolean>productcategorywithNoLimit= new  Map<string,Boolean>();
                
                /**
                 * (Line Number 228-234)
                 * defineLevelofProductCategory- will fetch all the records from metadata which are under promotions.
                 */
                List<DefineProductLevel__mdt> defineLevelofProductCategory = [SELECT Id,Assigned_Credential_Level__c,No_Limit__c,Product_Category__c FROM DefineProductLevel__mdt];
                for(DefineProductLevel__mdt data :defineLevelofProductCategory){
                    if(data.Assigned_Credential_Level__c != null && data.Product_Category__c!= null){
                        productLevelCategory.put(data.Product_Category__c,data.Assigned_Credential_Level__c);
                        productcategorywithNoLimit.put(data.Product_Category__c,data.No_Limit__c);
                    }
                }
                // created transactionjournalmap to insert the records for each rebateLineItems.
                map<Id,TransactionJournal> transactionjournalmap = new map<id,TransactionJournal>();
                
                 /**looping over the RebateClaim line item record to calculate tj records for each line items
                 * (Calculate all the benefit Amount regular,promo and Credentialled for each line Item.)
                 */
                for(RebateClaim rc : lstRebateClaimItems){
                    //benefitrebatekey - created to calculate the regular benefit for each line item.
                    benefitrebatekey=rc.Product_Category__c +rc.Product_Category1__c+rc.ProductId+'Regular';
                    //keytogetAssignedCredAccount - created this key to check if the current line item product category is under promotion on Account level.
                    keytogetAssignedCredAccount = ''+rc.Rebate_Claim__r.Submitted_By__r.AccountId+rc.Product_Category1__c+rc.ClaimDate.date();
                    //keytogetAssignedCredential - created this key to check if the current line item product category is under promotion on contact level.
                    keytogetAssignedCredential = ''+rc.Rebate_Claim__r.Submitted_By__c+rc.Product_Category1__c+rc.ClaimDate.date();
                    if(assignedCredAccountmap.containskey(keytogetAssignedCredAccount)){
                        assignedcredAccountId = assignedCredAccountmap.get(keytogetAssignedCredAccount);
                    }
                    if(assignedCredAccountmap.containskey(keytogetAssignedCredential)){
                        assignedcredentialId=assignedCredAccountmap.get(keytogetAssignedCredential);
                    }
                     // using below method we are calculating how much regular benefit will get on each line item.
                    calculateTJRecordForRegular(rebatebeniftmap,mapUOM,rc,benefitrebatekey,transactionjournalmap,
                                                assignedcredAccountId,assignedCredAccountmapwithobject,assignedcredentialId,
                                                assignedcredentialmapwithobject,productcategorywithNoLimit,productLevelCategory);
                    
                    /**
                    * (Line Number 264-278)
                    * if the product is under promotion and calculation is on Account level, then the below if condition will
                    * get checked and it will process for calcualting promo Amount for each line item.
                    */
                    if(productLevelCategory.get(rc.Product_Category1__c)=='Account'){
                        if(assignedCredAccountmap.containskey(keytogetAssignedCredAccount)){
                            assignedcredAccountId = assignedCredAccountmap.get(keytogetAssignedCredAccount);
                            assignedcredentialId=assignedCredAccountmap.get(keytogetAssignedCredential);
                            benefitrebatekey=rc.Product_Category__c +rc.Product_Category1__c+rc.ProductId+'Promo';
                            
                            //below method gets called if the product category is under promotion and the calculation is on Account level
                            calculateTJRecordForAssignedrecord(rebatebeniftmap,mapUOM,rc,benefitrebatekey,transactionjournalmap,
                                                               assignedcredAccountId, assignedCredAccountmapwithobject,
                                                               assignedcredentialId,assignedcredentialmapwithobject,
                                                               productcategorywithNoLimit);                   
                        }
                        
                    }
                    /**
                    * (Line Number 283-291)
                    * if the product is under promotion and calculation is on contact level, then the below else if condition will
                    * get checked and it will process for calcualting promo Amount for each line item (RISE).
                    */
                    else if(productLevelCategory.get(rc.Product_Category1__c)=='Contact'){
                        keytogetAssignedCredential = ''+rc.Rebate_Claim__r.Submitted_By__c+rc.Product_Category1__c+rc.ClaimDate.date();
                        if(assignedCredAccountmap.containsKey(keytogetAssignedCredential)) {
                            assignedcredentialId = assignedCredAccountmap.get(keytogetAssignedCredential);
                            benefitrebatekey = rc.Product_Category__c + rc.Product_Category1__c + rc.ProductId + 'Promo';
                            calculateTJRecordForContactAssigned(rebatebeniftmap, mapUOM, rc, benefitrebatekey, 
                                                                transactionjournalmap, assignedcredentialId, assignedcredentialmapwithobject,productcategorywithNoLimit);
                        }
                    }
                    /**
                     * Line Number(297-306)
                     * below peace of code is wrote to calculate the credentialled benefit for each line Item.
                     * assignedcontactidmap contains the contact Id and it's all related contractor-Credentials like (SSM, Siding 5 star).
                     */
                    if(assignedcontactidmap.containskey(rc.Rebate_Claim__r.Submitted_By__c)){
                        Set<Id> credentials = assignedcontactidmap.get(rc.Rebate_Claim__r.Submitted_By__c);
                        //getMaxBenefitRecord Method - will return the credentialled  benefit record which is having more benefit either dollar Amount or percentage Amount
                        ProgramRebateTypeBenefit maxBenefitRecord = getMaxBenefitRecord(credentials, rebatebeniftmap, rc);
                        if (maxBenefitRecord != null) {
                            benefitrebatekey = rc.Product_Category__c + rc.Product_Category1__c + rc.ProductId + 'Credentialled' + maxBenefitRecord.Credentialled_Benefit__c;
                            //calculateTJRecord method - below method is used for calculating Credentialled benefit for each rebate line item
                            calculateTJRecord(rebatebeniftmap, mapUOM, rc, benefitrebatekey, transactionjournalmap);
                        }
                    }
                    
                }  
                // it will insert all the TJ record for each rebate claim line item.
                Insert transactionjournalmap.values();
                system.debug('transactionjournalmap==='+transactionjournalmap);
                map<id,decimal> transactionjournalvalues = new map<id,decimal>();
                list<RebateClaim> listofrebateclaimitemstoupdate = new list<RebateClaim>();
                for(TransactionJournal tj:transactionjournalmap.values()){
                    transactionjournalvalues.put(tj.Rebate_Claim_Item__c,tj.TransactionAmount);
                }
                for(RebateClaim rc : lstRebateClaimItems){
                    rc.ClaimAmount = transactionjournalvalues.get(rc.Id);
                    listofrebateclaimitemstoupdate.add(rc);
                }
                // updating rebate line item with claimAmount from TJ.
                update listofrebateclaimitemstoupdate;
                
                    // below we are updating the Assigned credential records that how much quantity  it's claimed till now on AC Level(Line number 337- 347). 
                if(assignedcredentialmapwithobject != null){
                    list<Assigned_Credential__c> listofassignedcredential = new list<Assigned_Credential__c>();
                    for(Assigned_Credential__c acobject:assignedcredentialmapwithobject.values()){
                        Assigned_Credential__c assignedcredntial = new Assigned_Credential__c();
                        assignedcredntial.id 					 = acobject.id;
                        assignedcredntial.Max_Payout_Quantity_Claimed__c = acobject.Max_Payout_Quantity_Claimed__c;
                        listofassignedcredential.add(assignedcredntial);
                    }
                    // it will update the Max payout claimed quantity on Assigned Credential.
                    update listofassignedcredential;
                }
                
                // below we are updating the Assigned credential Account records that how much quantity it's claimed till now on ACA level (Line Number 324-334)
                if(assignedCredAccountmapwithobject != null){
                    list<Assigned_Credential_Account__c> listofassignedcredntialaccount = new list<Assigned_Credential_Account__c>();
                    for(Assigned_Credential_Account__c accobject: assignedCredAccountmapwithobject.values()){
                        Assigned_Credential_Account__c assignedcredntialaccount = new Assigned_Credential_Account__c();
                        assignedcredntialaccount.id = accobject.id;
                        assignedcredntialaccount.Max_Payout_Quantity_Claimed__c = accobject.Max_Payout_Quantity_Claimed__c;
                        listofassignedcredntialaccount.add(assignedcredntialaccount);
                        
                    }
                    // it will update the Max payout claimed quantity on Assigned Credential Account
                    update listofassignedcredntialaccount;
                }
            
                //Below line of code is added by Hithesh so that the rebate claim is set to processing (Line number 210-218)
                list<Rebate_Claim__c> updateRebateClaim = new list<Rebate_Claim__c>();
                List<Rebate_Claim__c> rebateClaimWithTj = [SELECT Id,Status__c FROM Rebate_Claim__c WHERE Id IN : newRebateClaim];
                for(Rebate_Claim__c rc:rebateClaimWithTj){
                    rc.Status__c = 'Processing';
                    updateRebateClaim.add(rc);
                }
                // updating rebateClaim status to processing, once all tj get created.
                update updateRebateClaim;
            }  
        }  catch(exception ex){
            //Rollback feature to make status to set back to old status.
            Rebate_Claim__c rebateClaim = new Rebate_Claim__c(Id = newRebateClaim[0].Id, Status__c = oldMapcred.get(newRebateClaim[0].Id).Status__c);
            
            update rebateClaim;
            integer lineNumber = ex.getLineNumber();
            string errorMessage = ex.getmessage();
            system.debug('errorMessage==='+errorMessage + 'Line number==='+lineNumber);
            String errorMessageToDisplay = ExceptionHandlingHandler.handleException(lineNumber , 'TransactionJournalCreatorForRebateClaims');
            // after occuring error the message will get publish and user will see the user friendly message on the UI.
            EventBus.publish(new Exception_Event__e(User_Ids__c=userinfo.getUserId(),Request__c= + errorMessageToDisplay,Type__c='Error'));
        }
    }
    /**
     * This method calculates and processes the transaction journal records for regular benefit type  and as well other method will
     * call for 2024 data if the product is under promotion and Stone facade rebate Amount is not null from benefit record.
     * @param rebatebeniftmap              Map containing key from rebateBenefit and value as a record
     * @param mapUOM                       Map of UnitOfMeasureConversion objects key by a unique combination 
     *                                     Product__c, FromUnitOfMeasureId, and Program_Year__c fields and value as UOMC records.
     * @param benefitrebatekey             The key used to fetch rebate benefit details from rebatebeniftmap.
     * Also accepting other required parameter as rc,TJ,AssignedCredentialAccount,AssignedCredential and ProductCategory and it's
     * promotion level(Account,contact) from Metadata.
     */
    public static void calculateTJRecordForRegular(Map<string,ProgramRebateTypeBenefit> rebatebeniftmap,
                                                   Map<String,UnitOfMeasureConversion> mapUOM,
                                                   RebateClaim rc,string benefitrebatekey,
                                                   map<Id,TransactionJournal> transactionjournalmap,
                                                   string assignedCredAccountId, Map<string,Assigned_Credential_Account__c> assignedCredAccountmapwithobject, String assignedcredentialId,
                                                   Map<string,Assigned_Credential__c> assignedcredentialmapwithobject,Map<string,
                                                   Boolean>productcategorywithnolimit, Map<string,String>productLevelCategory)
    {
        String uomKey;
        Decimal appliedbenefit;
        // rebatebeniftmap will check if the regular benefit key is there in Map,and it will process further for calculation of regular benefit.
        if(rebatebeniftmap.containsKey(benefitrebatekey)){ 
            ProgramRebateTypeBenefit benefittypeprogram=rebatebeniftmap.get(benefitrebatekey);
            appliedbenefit                             =benefittypeprogram.BenefitValue;
            uomKey ='#'+rc.ProductId + rc.Unit_Of_Measure_Selected__c+rc.ClaimDate.date().year()+rc.Record_Type__c;
            // mapUOM will check the uomKey is there in the map or not if it's there it will process further for calculation of regular benefit.
            if(mapUOM.containsKey(uomKey)){ 
                UnitOfMeasureConversion conversionobj = mapUOM.get(uomKey);
                //instantiateTheTJRecord - method will instantiate the TJ record and it will map the required data from rebateClaim to TJ. 
                TransactionJournal tj =  instantiateTheTJRecord(rc); 
                tj.UOMConversionFactor__c = conversionobj.ConversionFactor;
                tj.Applied_Benefit_Value__c = appliedbenefit;
                tj.Regular_Applied_Benefit_Amount__c=appliedbenefit;
                tj.TransactionAmount = tj.TransactionAmount;
                tj.Quantity_Converted__c = rc.Quantity*conversionobj.ConversionFactor;
                tj.TransactionAmount =appliedbenefit *  tj.Quantity_Converted__c;
                transactionjournalmap.put(rc.id,tj);
                /**
                 *calculatePromoBenefits- method is used to calculate the promo benefit.
                 * if the stone Facade benefit fields is not null and >0 on the benefit record where benefit type is Regular.
                */
                if (benefittypeprogram.Stone_Facade_Benefit__c != null && benefittypeprogram.Stone_Facade_Benefit__c > 0 
                    && rc.ClaimDate.date() <= benefittypeprogram.EffectiveEndDate && assignedCredAccountId!=null && assignedcredentialId != null && productLevelCategory.get(rc.Product_Category1__c)=='Account'&& 
                    assignedCredAccountmapwithobject.get(assignedCredAccountId).Credential_Category__c==rc.Product_Category1__c) {
                        calculatePromoBenefits(benefittypeprogram, rc, transactionjournalmap, mapUOM, 
                                               assignedCredAccountId,
                                               assignedCredAccountmapwithobject, 
                                               assignedcredentialId, 
                                               assignedcredentialmapwithobject, 
                                               productcategorywithNoLimit);
                          System.debug('calculatePromoBenefits called==>'+ assignedCredAccountmapwithobject + 'productCategory==>'+rc.Product_Category1__c);
                         System.debug('calculatePromoBenefits called==>'+ assignedcredentialmapwithobject + 'productCategory==>'+rc.Product_Category1__c);
                /**
                 *calculateTJRecordForContactAssigned- method is used to calculate the promo benefit on contact level.
                 * if the stone Facade benefit fields is not null and >0 on the benefit record where benefit type is Regular.
                */
                    } else if(benefittypeprogram.Stone_Facade_Benefit__c != null && benefittypeprogram.Stone_Facade_Benefit__c > 0 
                              && rc.ClaimDate.date() <= benefittypeprogram.EffectiveEndDate && assignedcredentialId!=null && productLevelCategory.get(rc.Product_Category1__c)=='Contact' && 
                              assignedcredentialmapwithobject.get(assignedcredentialId).Credential_Category__c==rc.Product_Category1__c){
                                  calculateTJRecordForContactAssigned(rebatebeniftmap,mapUOM,rc,benefitrebatekey,transactionjournalmap,assignedcredentialId, assignedcredentialmapwithobject,productcategorywithnolimit);
                                  
                                  
                              }
            }
            else{
                Map<String, String> testMap = new Map<String, String>();
                // Added by Hitesh to see the error messgae when UOM  record is not there for selected product.
                testMap.put('TestKey', null);
                // Attempting to get the length of a null value, which will throw a NullPointerException
                Integer length = testMap.get('TestKey').length();
            } 
            
        } else{
            // Added by Rohit to see the error messgae when Regular benefit  record is not there for selected product.
            Map<String, String> testMap = new Map<String, String>();
            testMap.put('TestKey', null);
            Integer length = testMap.get('TestKey').length();
        }
    }
    /**
    * calculateTJRecordForAssignedrecord- method is used to calculate the promo benefit where (Benefit type is promo).
    * if the product category is under promotion and the calculation is on Account level
    */
    public static void calculateTJRecordForAssignedrecord(Map<string,ProgramRebateTypeBenefit> rebatebeniftmap,
                                                          Map<String,UnitOfMeasureConversion> mapUOM,
                                                          RebateClaim rc,string benefitrebatekey,
                                                          map<Id,TransactionJournal> transactionjournalmap,
                                                          string assignedCredAccountId, 
                                                          Map<string,Assigned_Credential_Account__c> assignedCredAccountmapwithobject, 
                                                          String assignedcredentialId,
                                                          Map<string,Assigned_Credential__c> assignedcredentialmapwithobject,
                                                          Map<string,Boolean>productcategorywithnolimit)
    {
        if(rebatebeniftmap.containsKey(benefitrebatekey)){
            ProgramRebateTypeBenefit benefittypeprogram=rebatebeniftmap.get(benefitrebatekey);
            calculatePromoBenefits(benefittypeprogram, rc,transactionjournalmap ,mapUOM,
                                   assignedCredAccountId,assignedCredAccountmapwithobject,
                                   assignedcredentialId,assignedcredentialmapwithobject,
                                   productcategorywithnolimit);
        }
    }
    /**
     *  calculateTJRecordForContactAssigned- used to calculate the promo benefit on contact level (RISE)
     */
    public static void calculateTJRecordForContactAssigned(Map<string, ProgramRebateTypeBenefit> rebatebeniftmap,
                                                           Map<String, UnitOfMeasureConversion> mapUOM,
                                                           RebateClaim rc, string benefitrebatekey,
                                                           map<Id, TransactionJournal> transactionjournalmap,
                                                           string assignedcredid ,
                                                           Map<string, Assigned_Credential__c> assignedcredentialmapwithobject,Map<string,
                                                           Boolean>productcategorywithnolimit) 
    {
        String uomKey;
        Decimal appliedbenefit;
        Decimal actualquantity;
        Decimal promovalue;
        Assigned_Credential__c assignedcredential = assignedcredentialmapwithobject.get(assignedcredid);
        Decimal totalvalue = assignedcredential.Credential__r.Max_Payout_Quantity__c;
        Decimal remainingvalue = assignedcredential.Max_Payout_Quantity_Claimed__c;
        // rebatebeniftmap will check if the promo benefit key is there in Map if it's there,
        if(rebatebeniftmap.containsKey(benefitrebatekey)) {                    
            ProgramRebateTypeBenefit benefittypeprogram = rebatebeniftmap.get(benefitrebatekey); 
            appliedbenefit = benefittypeprogram.BenefitValue;
            promovalue =benefittypeprogram.Stone_Facade_Benefit__c;
            uomKey = '#' + rc.ProductId + rc.Unit_Of_Measure_Selected__c + rc.ClaimDate.date().year() + rc.Record_Type__c;
            if(mapUOM.containsKey(uomKey)) {
                UnitOfMeasureConversion conversionobj = mapUOM.get(uomKey);
                remainingvalue += rc.Quantity * conversionobj.ConversionFactor;
                TransactionJournal tj = transactionjournalmap.get(rc.id); 
                  /*When user have full bucket*/
                if ((totalvalue >= remainingvalue) && (productcategorywithnolimit.get(rc.Product_Category1__c)!=true)) {
                    tj.Quantity_Converted__c = rc.Quantity * conversionobj.ConversionFactor;
                    if(promovalue != null && promovalue >0){
                        tj.Promo_Quantity__c=rc.Quantity * conversionobj.ConversionFactor;
                        tj.General_Promotion_Amount__c=promovalue;
                        tj.Stone_Facade_Rebate_Amount__c= tj.Promo_Quantity__c *  tj.General_Promotion_Amount__c;
                        tj.TransactionAmount = tj.TransactionAmount +tj.Stone_Facade_Rebate_Amount__c;
                    }
                     //adding value to assigned credentail to see how much Quantity claimed.
                    assignedcredential.Max_Payout_Quantity_Claimed__c = remainingvalue;
                    assignedcredentialmapwithobject.put(assignedcredid, assignedcredential);
                     /*When user don't have full bucket*/
                } else if(productcategorywithnolimit.get(rc.Product_Category1__c)!=true) {
                    remainingvalue = assignedcredential.Max_Payout_Quantity_Claimed__c;
                    actualquantity =  (totalvalue - remainingvalue);
                    tj.Quantity_Converted__c = rc.Quantity * conversionobj.ConversionFactor;
                    if(promovalue != null && promovalue >0 && actualquantity >0){
                         tj.Promo_Quantity__c=conversionobj.ConversionFactor*actualquantity/conversionobj.ConversionFactor;
                        tj.General_Promotion_Amount__c=promovalue;
                        tj.Stone_Facade_Rebate_Amount__c= tj.Promo_Quantity__c *  tj.General_Promotion_Amount__c ;
                        tj.TransactionAmount = tj.TransactionAmount +tj.Stone_Facade_Rebate_Amount__c;
                    }
                     assignedcredential.Max_Payout_Quantity_Claimed__c = actualquantity + remainingvalue;
                    assignedcredentialmapwithobject.put(assignedcredid, assignedcredential);
                    
                  /*when product category is having no limit for promotion quantity */
                }else if(productcategorywithnolimit.get(rc.Product_Category1__c)==true){
                    tj.Quantity_Converted__c = rc.Quantity * conversionobj.ConversionFactor;
                    if(promovalue != null && promovalue >0){
                       tj.Promo_Quantity__c=rc.Quantity * conversionobj.ConversionFactor;
                        tj.General_Promotion_Amount__c=promovalue;
                        tj.Stone_Facade_Rebate_Amount__c= tj.Promo_Quantity__c *  tj.General_Promotion_Amount__c;
                        tj.TransactionAmount = tj.TransactionAmount +tj.Stone_Facade_Rebate_Amount__c;
                    }
                    //adding value to assigned credentail to see how much Quantity they claimed
                    assignedcredential.Max_Payout_Quantity_Claimed__c = remainingvalue;
                    assignedcredentialmapwithobject.put(assignedcredid, assignedcredential);
                }
                transactionjournalmap.put(rc.id, tj);
            }
        }
    }
      /**
     * calculateTJRecord method -is used for calculating Credentialled benefit for the rebate claim based on additional dollar or percentage benefits.
     * this method will get call when the contact is having credentialled like (Siding 5 star, gold star, silver star etc).
     *  @param rebatebeniftmap        A map of benefit keys to ProgramRebateTypeBenefit records. Used to fetch the benefit details based on the rebate key.
     * @param mapUOM                 A map of UOM (Unit of Measure) keys to UnitOfMeasureConversion records. Used to fetch conversion factors for calculations.
     * @param rc                     The RebateClaim line item for which the calculation is being performed.
     * also accepts other required parameter (benefitrebatekey,transactionjournalmap) for calculation purpose.
     */
    public static void calculateTJRecord(Map<string,ProgramRebateTypeBenefit> rebatebeniftmap,
                                         Map<String,UnitOfMeasureConversion> mapUOM,
                                         RebateClaim rc,string benefitrebatekey,
                                         map<Id,TransactionJournal> transactionjournalmap)
    {
        String uomKey;
        Decimal additionaldollarbenefit;
        Decimal additionalpercentbenefit;
        Decimal baseTjAmount;  
        Decimal tjamount;
        if(rebatebeniftmap.containsKey(benefitrebatekey)){
            ProgramRebateTypeBenefit benefittypeprogram=rebatebeniftmap.get(benefitrebatekey);
            additionaldollarbenefit                    =benefittypeprogram.Additional_Dollar_Benefit__c;
            additionalpercentbenefit                   =benefittypeprogram.Additional_Percentage_Benefit__c;
            uomKey ='#'+rc.ProductId + rc.Unit_Of_Measure_Selected__c+rc.ClaimDate.date().year()+rc.Record_Type__c;
            if(mapUOM.containsKey(uomKey)){ 
                UnitOfMeasureConversion conversionobj = mapUOM.get(uomKey); 
                TransactionJournal tj =  transactionjournalmap.get(rc.id);
                baseTjAmount=tj.TransactionAmount;
                // Calculate transaction amount based on promo and regular quantities (Line Number - 569)
                if(tj.Promo_Quantity__c>0){
                    tjamount= ((tj.Promo_Quantity__c *tj.General_Promotion_Amount__c) + (tj.UOMConversionFactor__c *tj.Quantity *tj.Regular_Applied_Benefit_Amount__c));
                }
                // Calculate transaction amount based on regular benefit and Quantity (Line Number - 570)
                else if(tj.Quantity >0){
                    tjamount=  (tj.UOMConversionFactor__c *tj.Quantity *tj.Regular_Applied_Benefit_Amount__c); 
                }
                // Apply additional dollar or percentage benefits to the transaction journal
                if(additionaldollarbenefit != null && additionaldollarbenefit > 0){
                    tj.DollarBenefit__c = additionaldollarbenefit;
                    Decimal totalDollarBenefit=rc.Quantity * conversionobj.ConversionFactor * additionaldollarbenefit;
                    tj.TransactionAmount = baseTjAmount+totalDollarBenefit;
                }else if(additionalpercentbenefit != null && additionalpercentbenefit >0){
                    tj.PercentageBenefit__c = additionalpercentbenefit;
                    tj.TransactionAmount = baseTjAmount +(tjamount *additionalpercentbenefit)/100;
                }				               
                transactionjournalmap.put(rc.id,tj);
            }
        }
    }
      /**
        * Instantiates and returns a new TransactionJournal record based on the provided RebateClaim details.
        * @param rc  The RebateClaim object containing data used to populate the TransactionJournal record.
        * @return    A new TransactionJournal object populated with the relevant data from the RebateClaim.
      */
    public static TransactionJournal instantiateTheTJRecord(RebateClaim rc){
        System.debug('rc==>' +rc);
        TransactionJournal tj = new TransactionJournal();
        tj.Rebate_Claim_Item__c = rc.id;
        tj.QuantityUnitOfMeasureId = rc.Unit_Of_Measure_Selected__c;
        tj.Rebate_Program_Id__c = rc.Product_Category__r.RebateProgramId;
       // tj.ActivityDate =  rc.Claimdate;
        tj.ActivityDate =  rc.Rebate_Claim__r.Submit_Date__c;
        tj.Rebate_Claim_Item_RecordType__c = rc.Record_Type__c;
        tj.Company_Code__c = rc.Business_Units__r.Company_Code__c;
        tj.Rebate_Program_Start_Date__c = rc.Product_Category__r.RebateProgram.StartDate;
        tj.Rebate_Program_End_Date__c = rc.Product_Category__r.RebateProgram.EndDate;
        tj.Rebate_Claim__c = rc.Rebate_Claim__c;
        tj.Program_Rebate_Type__c = rc.Product_Category__c;
        tj.Quantity = rc.Quantity;
        tj.MemberId = rc.Rebate_Claim__r.Rebate_Program_Member__c;
        tj.ProductId = rc.ProductId;
        tj.TransactionAmount = rc.ClaimAmount;
        return tj;
    }
       /**
        * bucketsizecheck method- is wrote to return the Assigned credential Account and Assigned Credential
        * it will return the (ACA and AC) records if the product category is  under promotion.
       */
    public static Map<string,object> bucketsizecheck(set<string> setproductcategory,
                                                     set<id> setprogramrebatetypeid,
                                                     set<Id> setproducts,
                                                     set<date> setofdates,
                                                     set<Id> rebateClaimItemAccountId,
                                                     list<RebateClaim> lstRebateClaimItems,set<Id>contactsetId )
    {
        Map<String,List<Assigned_Credential_Account__c>> durationmapwithac = new Map<string,List<Assigned_Credential_Account__c>>();
        Map<String,List<Assigned_Credential__c>> durationmapwithcon = new Map<string,List<Assigned_Credential__c>>();
        // Query to retrieve active assigned credential accounts.
        // Filters based on product category, date range, accountId, and active credential status.
        List<Assigned_Credential_Account__c> assignedCredAccount = [SELECT Id, Name,Max_Payout_Quantity_Claimed__c, Max_Payout_Quantity_Remaining__c, 
                                                                    Account__c, Status__c,
                                                                    Credential__r.Status__c,
                                                                    Credential__r.Product_Category__c,
                                                                    Credential__r.Max_Payout_Quantity__c,
                                                                    Credential__r.Start_Date__c,
                                                                    Credential__r.End_Date__c, 
                                                                    Credential_Category__c
                                                                    FROM Assigned_Credential_Account__c 
                                                                    WHERE Status__c = 'Active'  
                                                                    AND ( Credential__r.Start_Date__c <= :setofdates
                                                                         AND  Credential__r.End_Date__c >= :setofdates) 
                                                                    AND (Credential__r.Product_Category__c IN :SetProductCategory)
                                                                    AND (Account__r.Id IN :rebateClaimItemAccountId) 
                                                                    AND( Credential__r.Status__c='Active')
                                                                   AND Credential__c != null];
         // Query to retrieve active assigned credentials for contacts.
        // Filters based on product category, date range, contact, and active credential status.
        List<Assigned_Credential__c> assignedcredential = [SELECT Id, Name,Max_Payout_Quantity_Claimed__c, Max_Payout_Quantity_Remaining__c, 
                                                           Status__c, Credential__c, 
                                                           Credential__r.Status__c,
                                                           Credential__r.Product_Category__c,
                                                           Credential__r.Max_Payout_Quantity__c,
                                                           Credential__r.Start_Date__c,
                                                           Credential__r.End_Date__c, 
                                                           Contact__c
                                                           FROM Assigned_Credential__c 
                                                           WHERE Status__c = 'Active'  
                                                           AND ( Credential__r.Start_Date__c <= :setofdates
                                                                AND  Credential__r.End_Date__c >= :setofdates) 
                                                           AND (Credential__r.Product_Category__c IN :SetProductCategory)
                                                           AND (Contact__c IN :contactsetId) 
                                                           AND(Credential__r.Status__c='Active')
                                                          AND Credential__c != null];
         // Populate a map to group assigned credential accounts by their Product category.
        if(assignedCredAccount.size()> 0 && assignedCredAccount !=null){
            for(Assigned_Credential_Account__c assignedobj:assignedCredAccount){
                if(durationmapwithac.containskey(assignedobj.Credential_Category__c)){
                    durationmapwithac.get(assignedobj.Credential_Category__c).add(assignedobj);
                }else{
                    durationmapwithac.put(assignedobj.Credential_Category__c, new list<Assigned_Credential_Account__c>{assignedobj});
                }
            }
        }
        String contactdurationkey;
        // Populate a map to group assigned credentials by a contact-based key (product category + contact ID).
        if(assignedcredential.size()> 0 && assignedcredential !=null){
            for(Assigned_Credential__c assigndobjcred:assignedcredential){
                contactdurationkey= assigndobjcred.Credential__r.Product_Category__c +assigndobjcred.Contact__c;
                if(durationmapwithcon.containskey(contactdurationkey)){
                    durationmapwithcon.get(contactdurationkey).add(assigndobjcred);
                }else{
                    durationmapwithcon.put(contactdurationkey, new list<Assigned_Credential__c>{assigndobjcred});
                }
            }
        }
        Map<string,object> mapofobject = new Map<string,object>();
        Map<string,Assigned_Credential_Account__c> assignedCredAccountmapwithobject = new Map<string,Assigned_Credential_Account__c>();
        Map<string,Assigned_Credential__c> assignedcredentialmapwithobject = new Map<string,Assigned_Credential__c>();
        Map<string,string> assignedCredAccountmap = new Map<string,string>();
        string accountkey;
        for(RebateClaim rc : lstRebateClaimItems) {
            accountkey = '';
             // Match rebate claims with assigned credential accounts(based on product category and claimed date from rebate claim)
            if(durationmapwithac.containskey(rc.Product_Category1__c)){                
                for(Assigned_Credential_Account__c acobj:durationmapwithac.get(rc.Product_Category1__c)){
                    if(acobj.Credential__r.Start_Date__c<= rc.ClaimDate.date() &&
                       acobj.Credential__r.End_Date__c >= rc.ClaimDate.date()){                          
                           accountkey = ''+acobj.Account__c+rc.Product_Category1__c+rc.ClaimDate.date(); 
                           assignedCredAccountmap.put(accountkey,acobj.id);
                           assignedCredAccountmapwithobject.put(acobj.id,acobj);
                       }
                }
            }
             // Match rebate claims with assigned credentials at the contact level(based on product category, contactId and claimed date from rebate claim).
            if (durationmapwithcon.containsKey(rc.Product_Category1__c + rc.Rebate_Claim__r.Submitted_By__c)) {
                for (Assigned_Credential__c acdObj : durationmapwithcon.get(rc.Product_Category1__c + rc.Rebate_Claim__r.Submitted_By__c)) {
                    if (acdObj.Credential__r.Start_Date__c <= rc.ClaimDate.date() &&
                        acdObj.Credential__r.End_Date__c >= rc.ClaimDate.date()) {
                            String contactkey = ''+ acdObj.Contact__c + rc.Product_Category1__c + rc.ClaimDate.date(); 
                            assignedCredAccountmap.put(contactkey,acdObj.id);
                            assignedcredentialmapwithobject.put(acdObj.Id, acdObj);
                        }
                }
            }
        } 
        // Prepared the final map to return the Assigned Credential Account and Assigned Credential 
        // with some Account and contact level keys into the map.
        mapofobject.put('datewithid',assignedCredAccountmap);
        mapofobject.put('assignedCredAccount',assignedCredAccountmapwithobject);
        mapofobject.put('assignedcredential',assignedcredentialmapwithobject);
        return mapofobject;
    }
    /**
     * calculatePromoBenefits- method calculates promotional benefits for a rebate claim based on assigned credentials, Assigned Credential Account and benefit programs.
     * It captures the maximum payout quantities claimed on (ACA and AC).
    */
    public static void calculatePromoBenefits(ProgramRebateTypeBenefit benefittypeprogram, 
                                              RebateClaim rc, 
                                              map<Id,TransactionJournal> transactionjournalmap, 
                                              Map<String,UnitOfMeasureConversion> mapUOM, 
                                              string assignedCredAccountId, 
                                              Map<string,Assigned_Credential_Account__c> assignedCredAccountmapwithobject,
                                              String assignedcredentialId,
                                              Map<string,Assigned_Credential__c> assignedcredentialmapwithobject,
                                              Map<string, Boolean>productcategorywithnolimit 
                                             ) 
    {
        String uomKey;
        Decimal promovalue;
        Decimal appliedbenefit;
        Decimal actualquantity;
        Assigned_Credential_Account__c assignedCredAccount = assignedCredAccountmapwithobject.get(assignedCredAccountId);
        Decimal totalvalue = assignedCredAccount.Credential__r.Max_Payout_Quantity__c;
        String contactkey;
        Decimal remainingvalue = assignedCredAccount.Max_Payout_Quantity_Claimed__c;
        appliedbenefit                             =benefittypeprogram.BenefitValue;
        promovalue                                 =benefittypeprogram.Stone_Facade_Benefit__c;
        uomKey ='#'+rc.ProductId + rc.Unit_Of_Measure_Selected__c+rc.ClaimDate.date().year()+rc.Record_Type__c;
        if(mapUOM.containsKey(uomKey)){
            UnitOfMeasureConversion conversionobj = mapUOM.get(uomKey);
            remainingvalue =remainingvalue + rc.Quantity*conversionobj.ConversionFactor;
            TransactionJournal tj =  transactionjournalmap.get(rc.id); 
            /*When user have full bucket*/
            if((totalvalue >= remainingvalue) && (productcategorywithnolimit.get(rc.Product_Category1__c)!=true)){
                Assigned_Credential__c assignedcredential = assignedcredentialmapwithobject.get(assignedcredentialId);
                tj.Quantity_Converted__c = rc.Quantity*conversionobj.ConversionFactor;
                if(promovalue != null && promovalue >0){
                      tj.Promo_Quantity__c= rc.Quantity*conversionobj.ConversionFactor;
                    tj.General_Promotion_Amount__c=promovalue;
                    tj.Stone_Facade_Rebate_Amount__c= tj.Promo_Quantity__c *  tj.General_Promotion_Amount__c;
                    tj.TransactionAmount = tj.TransactionAmount +tj.Stone_Facade_Rebate_Amount__c;
                }
                //adding value to assigned credentail Account and Assigned credential.
                assignedCredAccount.Max_Payout_Quantity_Claimed__c = remainingvalue;
                assignedcredential.Max_Payout_Quantity_Claimed__c+=rc.Quantity*conversionobj.ConversionFactor;
                assignedCredentialWithContact.put(assignedCredAccount.Id,rc.Rebate_Claim__r.Submitted_By__c);
                assignedCredAccountmapwithobject.put(assignedCredAccountId,assignedCredAccount);
                assignedcredentialmapwithobject.put(assignedcredentialId,assignedcredential);
            }else if(productcategorywithnolimit.get(rc.Product_Category1__c)!=true){
                Assigned_Credential__c assignedcredential = assignedcredentialmapwithobject.get(assignedcredentialId);
                /*When user don't have full bucket*/
                remainingvalue = assignedCredAccount.Max_Payout_Quantity_Claimed__c;
                actualquantity =  (totalvalue - remainingvalue);
                tj.Quantity_Converted__c = rc.Quantity*conversionobj.ConversionFactor;
                if(promovalue != null && promovalue >0 && actualquantity >0){
                     tj.Promo_Quantity__c=actualquantity;
                    tj.General_Promotion_Amount__c=promovalue;
                    tj.Stone_Facade_Rebate_Amount__c= tj.Promo_Quantity__c *  tj.General_Promotion_Amount__c;
                    tj.TransactionAmount = tj.TransactionAmount +tj.Stone_Facade_Rebate_Amount__c;
                }
                  assignedCredAccount.Max_Payout_Quantity_Claimed__c = actualquantity + remainingvalue;
                 assignedcredential.Max_Payout_Quantity_Claimed__c+=actualquantity;
                assignedCredentialWithContact.put(assignedCredAccount.Id,rc.Rebate_Claim__r.Submitted_By__c);
                assignedCredAccountmapwithobject.put(assignedCredAccountId,assignedCredAccount);
                assignedcredentialmapwithobject.put(assignedcredentialId,assignedcredential);
            } else if(productcategorywithnolimit.get(rc.Product_Category1__c)==true){
                Assigned_Credential__c assignedcredential = assignedcredentialmapwithobject.get(assignedcredentialId);
                tj.Quantity_Converted__c = rc.Quantity*conversionobj.ConversionFactor;
                if(promovalue != null && promovalue >0){
                    tj.Promo_Quantity__c=rc.Quantity * conversionobj.ConversionFactor;
                    tj.General_Promotion_Amount__c=promovalue;
                    tj.Stone_Facade_Rebate_Amount__c= tj.Promo_Quantity__c *  tj.General_Promotion_Amount__c;
                    tj.TransactionAmount = tj.TransactionAmount +tj.Stone_Facade_Rebate_Amount__c;
                }
                //adding value to assigned credentail Account and Assigned credential.
                assignedCredAccount.Max_Payout_Quantity_Claimed__c = remainingvalue;
                assignedcredential.Max_Payout_Quantity_Claimed__c+=rc.Quantity*conversionobj.ConversionFactor;
                assignedCredAccountmapwithobject.put(assignedCredAccountId,assignedCredAccount);
                assignedcredentialmapwithobject.put(assignedcredentialId,assignedcredential);
            }
            transactionjournalmap.put(rc.id,tj);
        }
    }
     /** 
     * getMaxBenefitRecord method - is used to return the only one Max Benefit Amount record (Dollar,Percentage.)
     * returning only the maximum benefit Amount (dollarbenefit, percentagebenefit) 
    */
    public static ProgramRebateTypeBenefit getMaxBenefitRecord(Set<Id> credentialIds, 
                                                               Map<String, ProgramRebateTypeBenefit> rebateBenefitMap, 
                                                               RebateClaim rc) 
    {
        
        ProgramRebateTypeBenefit maxBenefitRecord = null;
        Decimal maxDollarBenefit=0;
        Decimal maxPercentBenefit=0;
        for (Id credentialId : credentialIds) {
            String benefitKey = rc.Product_Category__c + rc.Product_Category1__c + rc.ProductId + 'Credentialled' + credentialId;
            if (rebateBenefitMap.containsKey(benefitKey)) {
                ProgramRebateTypeBenefit benefitRecord = rebateBenefitMap.get(benefitKey);
                // Check and prioritize dollar benefit if it's there then return only the highest Dollar benefit credentialled record.
                if (benefitRecord.Additional_Dollar_Benefit__c != null && benefitRecord.Additional_Dollar_Benefit__c > maxDollarBenefit) {
                    maxDollarBenefit = benefitRecord.Additional_Dollar_Benefit__c;
                    maxBenefitRecord = benefitRecord;
                } 
                // If no dollar benefit, check percentage benefit and return only the highest percentage benefit credentialled record.
                else if (benefitRecord.Additional_Percentage_Benefit__c != null && benefitRecord.Additional_Percentage_Benefit__c > maxPercentBenefit && maxDollarBenefit==0) {
                    maxPercentBenefit = benefitRecord.Additional_Percentage_Benefit__c;
                    maxBenefitRecord = benefitRecord;
                }
            }
        }
        return maxBenefitRecord;
    }
}