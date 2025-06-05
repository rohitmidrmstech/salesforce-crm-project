/* **********************************************************************************************************************************
* Class Name   : RebateClaimItemTriggerHandler
* Description  : Class modifed to call auto enrollment
* Author       : Dipen
* Modified On  : Aug 08,2023
* Test Class   : RebateClaimTriggerHandlerTest
* Modification Log:  
* --------------------------------------------------------------------------------------------------------------------------------------
* Developer                 Date             Modification ID      Description 
* ---------------------------------------------------------------------------------------------------------------------------------------
* Dipen			         30-01-2023          1000              Modified Development
* Dipen                  12-02-2024          1001              Modified for LURP-9
* Dipen                  08-08-2024          1002              Modified for Cedar Impressions Promotion
* Hithesh				 10-11-2024			 1003			   Modified based on credentail
**************************************************************************************************************************************/

public class RebateClaimItemTriggerHandler {
    
    
    
    public static void createExperienceUserShares(Map<RebateClaim,Id> rebateClaimItemToContactMap){
        Map<Id,Id> contactToUserIdMap = new Map<Id,Id>();
        List<RebateClaimShare> sharesToCreate = new List<RebateClaimShare>();
        
        for(User u: [Select Id,ContactId from User where ContactId in: rebateClaimItemToContactMap.values()]){
            contactToUserIdMap.put(u.ContactId, u.Id);
        }
        
        for(RebateClaim rebateClaim: rebateClaimItemToContactMap.keySet()){
            if(contactToUserIdMap.containsKey(rebateClaimItemToContactMap.get(rebateClaim)) && rebateClaim.OwnerId != contactToUserIdMap.get(rebateClaimItemToContactMap.get(rebateClaim))){
                RebateClaimShare share = new RebateClaimShare();
                share.ParentId = rebateClaim.Id;
                share.UserOrGroupId = contactToUserIdMap.get(rebateClaimItemToContactMap.get(rebateClaim));
                share.AccessLevel = RebateUtility.SHARING_ACCESS_LEVEL_EDIT;
                sharesToCreate.add(share);
            }
        }
        
        if(!sharesToCreate.isEmpty()){
            Database.insert (sharesToCreate, false);
        }
    }
    
    public static void deleteExperienceUserShares(Map<Id,Id> rebateClaimItemToContactMap){
        Map<Id,Id> contactToUserIdMap = new Map<Id,Id>();
        List<RebateClaimShare> sharesToDelete = new List<RebateClaimShare>();
        
        for(User u: [Select Id,ContactId from User where ContactId in: rebateClaimItemToContactMap.values()]){
            contactToUserIdMap.put(u.ContactId, u.Id);
        }
        
        for(RebateClaimShare share: [Select Id,ParentId, UserOrGroupId 
                                     from RebateClaimShare 
                                     where ParentId in: rebateClaimItemToContactMap.keySet()
                                     AND UserOrGroupId in: contactToUserIdMap.values()
                                     AND RowCause =:  'Manual']){
                                         if(share.UserOrGroupId == contactToUserIdMap.get(rebateClaimItemToContactMap.get(share.ParentId))){
                                             sharesToDelete.add(share);
                                         }
                                     }
        
        if(!sharesToDelete.isEmpty()){
            delete sharesToDelete;
        }
    }
    
    public static void updateClaimHeaderStatusOnLineItemPriceFXprocessed(Set<Id> rebateClaimHeaderIds){
        List<Rebate_Claim__c> claimHeadersToUpdate = new List<Rebate_Claim__c>();
        Set<Id> claimHeadersWithUnprocessedClaims = new Set<Id>();
        for(RebateClaim claimItem: [Select Id,Rebate_Claim__c from RebateClaim 
                                    where Rebate_Claim__c in:rebateClaimHeaderIds and PriceFX_Processed__c = false]){
                                        claimHeadersWithUnprocessedClaims.add(claimItem.Rebate_Claim__c);
                                        
                                    }
        for(Id claimHeaderId: rebateClaimHeaderIds){
            if(!claimHeadersWithUnprocessedClaims.contains(claimHeaderId)){
                claimHeadersToUpdate.add(new Rebate_Claim__c (Id = claimHeaderId, Status__c = 'Processing'));
            }
        }
        if(!claimHeadersToUpdate.isEmpty()){
            update claimHeadersToUpdate;
        }
    }
    
    public static void segregateThePromoRebateClaims(List<RebateClaim> rebateClaim){
        Set<String> accountlevelcategoryname = new Set<String>();
        set<string> contactLevelCategoryName = new set<string>();
        set<string> promoCategorys = new set<string>();
        list<rebateClaim> promoRebateClaims = new list<rebateClaim>();
        for (DefineProductLevel__mdt dpd : [SELECT ID, No_Limit__c, Product_Category__c, Assigned_Credential_Level__c FROM DefineProductLevel__mdt]) {
            if (dpd.Assigned_Credential_Level__c == 'Account') {
                accountlevelcategoryname.add(dpd.Product_Category__c);
            }
            if (dpd.Assigned_Credential_Level__c == 'Contact') {
                contactLevelCategoryName.add(dpd.Product_Category__c);
            }
            promoCategorys.add(dpd.Product_Category__c);
        }
        for(rebateClaim rc:rebateClaim){
            if(promoCategorys.contains(rc.Product_Category1__c)){
                promoRebateClaims.add(rc);
            }
            
        }
        if(promoRebateClaims.size() > 0){
           methodforAutoEnrollAssignedCredential(promoRebateClaims,accountlevelcategoryname,contactLevelCategoryName); 
        }       
    }
    
    public static void methodforAutoEnrollAssignedCredential(List<RebateClaim> rebateClaim,set<string>accountlevelcategoryname,set<string>contactLevelCategoryName) { 
        
        
        List<id> RebateClaimItemids = new List<id>();
        List<id> Rebate_ClaimIds = new List<id>();
        Map<id, string> productcatMap = new map<id, string>();
        Map<string, Credential__c> CredentialMap = new map<string, Credential__c>();
        map<string, id> credentialMapForContact = new map<string, id>();
        set<id> assignedCredentailConAcc = new set<id>();
        set<id> assignedCredentailConLevel = new set<id>();
        Map<id, string> mapcontact = new map<id, string>();
        Map<string, string> mapAccount = new map<string, string>();
        List<Assigned_Credential__c> insertAssignedCredential = new list<Assigned_Credential__c>();
        List<Assigned_Credential_Account__c> insertAccountAssignedCredential = new list<Assigned_Credential_Account__c>();
        List<Assigned_Credential_Account__c> AssignedCredentialAccountId = new List<Assigned_Credential_Account__c>();
        list<Assigned_Credential__c> AssignedCredentialContactId= new list<Assigned_Credential__c>();
        List<id> AssignedCredentialId=new List<id>();						//List of Assigned Credential Id
        Map<string, Assigned_Credential_Account__c> AssignedCredentialMap = new map<string, Assigned_Credential_Account__c>();
        map<string, Assigned_Credential__c> AssignedCredentialConMap = new map<string, Assigned_Credential__c>();
        Map<string, Assigned_Credential_Account__c> assignedcredentailswithexternal = new map<string, Assigned_Credential_Account__c>();
        map<string, Assigned_Credential__c> assignedCredContactWithExternal = new map<string, Assigned_Credential__c>();
        Map<string, Credential__c> promotionDurationMap = new Map<string, Credential__c>();
        List<Contact> contactListRecordUpdate = new List<Contact>();
        Set<Id> contactid = new Set<Id>();
        set<Date> claimDateOnly = new set<date>();
        string statusForAllAutoEnrollment = 'Active';
        string assignedCredentialDurationContactLevel;
        
        try {
            System.debug('Starting method: methodforAutoEnrollAssignedCredential');
            
            // Step 1: Collect Rebate Claim Items
            for (RebateClaim itemrecord : rebateClaim) {
                if (itemrecord.Is_Member__c) {
                    productcatMap.put(itemrecord.id, itemrecord.Product_Category1__c);
                    Rebate_ClaimIds.add(itemrecord.Rebate_Claim__c);
                    RebateClaimItemids.add(itemrecord.id);
                    mapcontact.put(itemrecord.id, itemrecord.Contact_Id__c);
                    mapAccount.put(itemrecord.Account_Id__c + '' + itemrecord.Product_Category1__c, itemrecord.Account_Id__c);
                    claimDateOnly.add(Date.valueof(itemrecord.ClaimDate));
                }
            }
            // Step 2: Fetch DefineProductLevel__mdt for Assigned_Credential_Level__c both account and contact
            // If the Assigned_Credential_Level__c is for account Assigned credential account and assigned credential will create
            // If the Assigned_Credential_Level__c is for contact then only assigned credential will get created.
            for (DefineProductLevel__mdt dpd : [SELECT ID, No_Limit__c, Product_Category__c, Assigned_Credential_Level__c FROM DefineProductLevel__mdt]) {
                if (dpd.Assigned_Credential_Level__c == 'Account') {
                    accountlevelcategoryname.add(dpd.Product_Category__c);
                }
                if (dpd.Assigned_Credential_Level__c == 'Contact') {
                    contactLevelCategoryName.add(dpd.Product_Category__c);
                }
            }
            // Date claimDateOnly = Date.valueof(RebateClaimItem.ClaimDate);
            string credDate;
            set<id> credIds = new set<id>();
            map<string, Credential__c> credDateId = new map<string, Credential__c>();
            List<Credential__c> existingPromotions = [SELECT Id,Name,Start_Date__c,End_Date__c,Product_Category__c,Status__c FROM Credential__c 
                                                      WHERE Product_Category__c IN :productcatMap.values() AND Status__c = 'Active' AND Product_Category__c IN:accountlevelcategoryname
                                                      AND Start_Date__c <= :claimDateOnly 
                                                      AND End_Date__c >= :claimDateOnly
                                                      AND Status__c = 'Active'];
            // Map to store date to date mapping for quick lookup
            Map<Date, Date> claimDateMap = new Map<Date, Date>();
            for (Date claimDate : claimDateOnly) {
                claimDateMap.put(claimDate, claimDate);
            }
            string promoCategory;
            set<id> credentialsetid = new set<id>();
            for(Credential__c pc:existingPromotions){
                if (pc.Start_Date__c != null && pc.End_Date__c != null ) {
                    // Iterate over the claimDateOnly within the promotion date range
                    for (Date d = pc.Start_Date__c; d <= pc.End_Date__c; d = d.addDays(1)) {
                        if (claimDateMap.containsKey(d)) {
                            promoCategory = pc.Product_Category__c;
                            credIds.add(pc.id);
                            CredentialMap.put(promoCategory , pc);
                            credDate = d + pc.Product_Category__c;
                            credDateId.put(credDate, pc);
                        }
                    }
                }
                
            }
            // Step 3: Collect active credentials for account level

            //collect active credentials for the contact level
            for (Credential__c CredentialDataForContact : [SELECT id, Product_Category__c, Status__c, Start_Date__c, End_Date__c FROM Credential__c 
                                                           WHERE Product_Category__c IN :productcatMap.values() AND Status__c = 'Active' AND Product_Category__c IN:contactLevelCategoryName
                                                           AND Start_Date__c <= :claimDateOnly 
                                                           AND End_Date__c >= :claimDateOnly
                                                           AND Status__c = 'Active']) {
                                                               credentialMapForContact.put(CredentialDataForContact.Product_Category__c, CredentialDataForContact.id);
                                                           }
            
            Id RecordId = Schema.SObjectType.Assigned_Credential__c.getRecordTypeInfosByName().get('General Promotion').getRecordTypeId();
            ID RecordIdAca = Schema.SObjectType.Assigned_Credential_Account__c.getRecordTypeInfosByName().get('General Promotion').getRecordTypeId();
            
            // Step 4: Fetch Assigned_Credential_Account__c and Assigned_Credential__c for account level
            String accountwithcreds;
            map<string,Assigned_Credential_Account__c> mapoflastassignedcredentialaccount = new map<string,Assigned_Credential_Account__c>();
            RebateClaimItemUtility.getAcccategoryset().add('Test');
            RebateClaimItemUtility.getConcategoryset().add('test');
            RebateClaimItemUtility.getContactLevelCategorySet().add('test');
            
            for (Assigned_Credential_Account__c asscredaccount : [SELECT id, Credential_Category__c, Account__c, Status__c, Credential__c FROM Assigned_Credential_Account__c WHERE Account__c IN :mapAccount.values() AND Credential__c IN :credIds]) {
                if(!credentialsetid.contains(asscredaccount.Credential__c)){
                    accountwithcreds = asscredaccount.Account__c + '-' + asscredaccount.Credential__c;
                    RebateClaimItemUtility.acccategoryset.add(accountwithcreds);
                    AssignedCredentialAccountId.add(asscredaccount);
                    assignedCredentailConAcc.add(asscredaccount.id);
                    AssignedCredentialMap.put(accountwithcreds, asscredaccount);
                }
            }
            
            String contactwithcredentials;
            for (Assigned_Credential__c assCredContact : [SELECT id,Credential__c, Credential_Category__c, Contact__c, Status__c FROM Assigned_Credential__c WHERE Contact__c IN :mapcontact.values() AND Credential__c IN :credIds]) {
                contactwithcredentials = assCredContact.Contact__c + '-' + assCredContact.Credential__c;
                RebateClaimItemUtility.concategoryset.add(contactwithcredentials);
                AssignedCredentialContactId.add(assCredContact);
                assignedCredentailConAcc.add(assCredContact.id);
                AssignedCredentialConMap.put(contactwithcredentials, assCredContact);
            }
            
            //fetch the assigned credential for the contact level
            string contactLevelcredentials;
            for (Assigned_Credential__c AssignedCredentialRecords : [SELECT id,Credential__c,Credential__r.id, Credential_Category__c, Contact__c, Status__c FROM Assigned_Credential__c WHERE Contact__c IN :mapcontact.values() AND Credential__c IN :credentialMapForContact.values()] ){
                contactLevelcredentials = AssignedCredentialRecords.Contact__c + '-' + AssignedCredentialRecords.Credential_Category__c;
                AssignedCredentialConMap.put(contactLevelcredentials, AssignedCredentialRecords);
                RebateClaimItemUtility.contactLevelCategorySet.add(contactLevelcredentials);
                assignedCredentailConLevel.add(AssignedCredentialRecords.id);
            }
            
            
            
            // Step 5: Loop through Rebate Claims and create missing records
            Boolean nolimitflag = false;
            for (RebateClaim RebateClaimItem : rebateClaim) { 
                accountwithcreds = '';
                contactwithcredentials = '';
                assignedCredentialDurationContactLevel = '';
                if ((CredentialMap.containsKey(RebateClaimItem.Product_Category1__c) || (credentialMapForContact.containsKey(RebateClaimItem.Product_Category1__c))) && RebateClaimItem.ClaimDate != null) { 
                    promoCategory = date.valueof(RebateClaimItem.ClaimDate) + RebateClaimItem.Product_Category1__c;
                    credDate = Date.valueof(RebateClaimItem.ClaimDate) + RebateClaimItem.Product_Category1__c;
                    if(credDateId.containsKey(credDate)){
                        accountwithcreds = RebateClaimItem.Account_Id__c + '-' + credDateId.get(credDate).id;
                        contactwithcredentials = RebateClaimItem.Contact_Id__c+'-'+credDateId.get(credDate).id;
                    }
                    if(credentialMapForContact.containsKey(RebateClaimItem.Product_Category1__c)){
                        assignedCredentialDurationContactLevel = RebateClaimItem.Contact_Id__c + '-' + RebateClaimItem.Product_Category1__c;
                    }
               
                    
                    // Create Assigned_Credential_Account__c & Assigned_Credential__c if not found along with Assigned_duration__c & Assigned_credential_duration__c
                    if((!RebateClaimItemUtility.acccategoryset.contains(accountwithcreds)) && (!RebateClaimItemUtility.concategoryset.contains(contactwithcredentials)) && (CredentialMap.containsKey(RebateClaimItem.Product_Category1__c))){ 
                        
                        //External Id used for parent and child relationship.
                        Assigned_Credential_Account__c assignedcredewithexternalid = new Assigned_Credential_Account__c(ExternalID__c=accountwithcreds);
                        assignedcredentailswithexternal.put(accountwithcreds,assignedcredewithexternalid); 
                        
                        Assigned_Credential_Account__c AccountAssignCred = new Assigned_Credential_Account__c();                           
                        AccountAssignCred.Account__c = RebateClaimItem.Account_Id__c;
                        AccountAssignCred.Credential__c = credDateId.get(credDate).id;
                        AccountAssignCred.Status__c = statusForAllAutoEnrollment;
                        AccountAssignCred.Max_Payout_Quantity_Claimed__c = 0;
                        AccountAssignCred.RecordTypeId = RecordIdAca;
                        AccountAssignCred.ExternalID__c = accountwithcreds;
                        insertAccountAssignedCredential.add(AccountAssignCred);                        
                        RebateClaimItemUtility.acccategoryset.add(accountwithcreds);
                        AssignedCredentialAccountId.add(AccountAssignCred);
                        
                        Assigned_Credential__c assignedCredConwithExternalid = new Assigned_Credential__c(ExternalID__c=contactwithcredentials);
                        assignedCredContactWithExternal.put(contactwithcredentials,assignedCredConwithExternalid);
                        
                        Assigned_Credential__c assignclaimedcred 		 = new Assigned_Credential__c();                        
                        assignclaimedcred.Contact__c 					 = RebateClaimItem.Contact_Id__c;
                        assignclaimedcred.Account__c 					= RebateClaimItem.Account_Id__c;
                        assignclaimedcred.RecordTypeId 					 = RecordId;
                        assignclaimedcred.Credential__c                  = credDateId.get(credDate).id;
                        assignclaimedcred.Status__c                      = statusForAllAutoEnrollment;
                        assignclaimedcred.Max_Payout_Quantity_Claimed__c = 0;
                        assignclaimedcred.ExternalID__c					 = contactwithcredentials;
                        if(assignedcredentailswithexternal.containskey(accountwithcreds)){
                            assignclaimedcred.Assigned_Credential_Account__r = assignedcredentailswithexternal.get(accountwithcreds);
                        }
                        
                        if(AssignedCredentialMap.containskey(accountwithcreds)){
                            assignclaimedcred.Assigned_Credential_Account__c = AssignedCredentialMap.get(accountwithcreds).id;
                            //  assignclaimedcred.Status__c 					 = AssignedCredentialMap.get(accountwithcreds).Status__c; // For LURP-9  //Commented for 2025 rollover handled now from flow
                        }                            
                        RebateClaimItemUtility.concategoryset.add(contactwithcredentials);
                        AssignedCredentialContactId.add(assignclaimedcred);
                        insertAssignedCredential.add(assignclaimedcred); 
                        
                        if(!contactid.contains(RebateClaimItem.Contact_Id__c)){ 
                            contactid.add(RebateClaimItem.Contact_Id__c);//Fix Duplicate error issue.
                            contact contactupdate = new contact();
                            contactupdate.id = RebateClaimItem.Contact_Id__c;
                            contactupdate.Enable_for_Promotion__c = True;
                            contactListRecordUpdate.add(contactupdate);
                        }
                    }
                    
                    
                    //create assigned credential account if not found.
                    
                    if(!RebateClaimItemUtility.acccategoryset.contains(accountwithcreds) && (RebateClaimItemUtility.concategoryset.contains(contactwithcredentials)) && accountlevelcategoryname.contains(RebateClaimItem.Product_Category1__c) ){
                        //External Id used for parent and child relationship.
                        Assigned_Credential_Account__c assignedcredewithexternalid = new Assigned_Credential_Account__c(ExternalID__c=accountwithcreds);
                        assignedcredentailswithexternal.put(accountwithcreds,assignedcredewithexternalid);  
                        
                        Assigned_Credential_Account__c AccountAssignCred = new Assigned_Credential_Account__c();                           
                        AccountAssignCred.Account__c = RebateClaimItem.Account_Id__c;
                        AccountAssignCred.Credential__c = credDateId.get(credDate).id;
                        AccountAssignCred.Status__c = statusForAllAutoEnrollment;
                        AccountAssignCred.Max_Payout_Quantity_Claimed__c = 0;
                        AccountAssignCred.RecordTypeId = RecordIdAca;
                        AccountAssignCred.ExternalID__c = accountwithcreds;
                        insertAccountAssignedCredential.add(AccountAssignCred);                        
                        RebateClaimItemUtility.acccategoryset.add(accountwithcreds);
                        AssignedCredentialAccountId.add(AccountAssignCred);
                    } 
                    
                    
                    //creation of the assigned credential 
                    //This scenario is added because if any new contact is added to exsisting account then that contact also should have these.
                    
                    if(RebateClaimItemUtility.acccategoryset.contains(accountwithcreds) && (!RebateClaimItemUtility.concategoryset.contains(contactwithcredentials)) && accountlevelcategoryname.contains(RebateClaimItem.Product_Category1__c)){
                        if(!RebateClaimItemUtility.concategoryset.contains(contactwithcredentials)){ 
                            Assigned_Credential__c assignedCredConwithExternalid = new Assigned_Credential__c(ExternalID__c=contactwithcredentials);
                            assignedCredContactWithExternal.put(contactwithcredentials,assignedCredConwithExternalid);
                            
                            Assigned_Credential__c assignclaimedcred 		 = new Assigned_Credential__c();                        
                            assignclaimedcred.Contact__c 					 = RebateClaimItem.Contact_Id__c;
                            assignclaimedcred.Account__c 					= RebateClaimItem.Account_Id__c;
                            assignclaimedcred.RecordTypeId 					 = RecordId;
                            assignclaimedcred.Credential__c                  = credDateId.get(credDate).id;
                            assignclaimedcred.Max_Payout_Quantity_Claimed__c = 0;
                            assignclaimedcred.ExternalID__c					 = contactwithcredentials;
                            
                            if(AssignedCredentialMap.containskey(accountwithcreds)){
                                assignclaimedcred.Assigned_Credential_Account__c = AssignedCredentialMap.get(accountwithcreds).id;
                                assignclaimedcred.Status__c  = AssignedCredentialMap.get(accountwithcreds).Status__c;
                                //  assignclaimedcred.Status__c 					 = AssignedCredentialMap.get(accountwithcreds).Status__c; // For LURP-9 //Commented for 2025 rollover handled now from flow
                            }                            
                            RebateClaimItemUtility.concategoryset.add(contactwithcredentials);
                            AssignedCredentialContactId.add(assignclaimedcred);
                            insertAssignedCredential.add(assignclaimedcred); 
                        }
                    }
                    
                    //  if((!concategoryset.contains(contactwithcredentials)) &&  (!contactLevelCategorySet.contains(assignedCredentialDurationContactLevel))){
                    if((!RebateClaimItemUtility.contactLevelCategorySet.contains(assignedCredentialDurationContactLevel))  && contactLevelCategoryName.contains(RebateClaimItem.Product_Category1__c)){
                        Assigned_Credential__c assignclaimedcred 		 = new Assigned_Credential__c();                        
                        assignclaimedcred.Contact__c 					 = RebateClaimItem.Contact_Id__c;
                        assignclaimedcred.Account__c 					= RebateClaimItem.Account_Id__c;
                        assignclaimedcred.RecordTypeId 					 = RecordId;
                        assignclaimedcred.Credential__c                  = credentialMapForContact.get(RebateClaimItem.Product_Category1__c);
                        assignclaimedcred.Status__c                      = statusForAllAutoEnrollment;
                        assignclaimedcred.Max_Payout_Quantity_Claimed__c = 0;
                        assignclaimedcred.ExternalID__c					 = contactwithcredentials;
                        RebateClaimItemUtility.contactLevelCategorySet.add(assignedCredentialDurationContactLevel);
                        AssignedCredentialContactId.add(assignclaimedcred);
                        insertAssignedCredential.add(assignclaimedcred); 
                        //    }
                    }
                }
            }
            // Insert records into the database
            if (!insertAccountAssignedCredential.isEmpty()) {
                insert insertAccountAssignedCredential;
                
                // Map to store Account-Credential combination to the newly created Assigned_Credential_Account__c record
                Map<String, Id> newlyCreatedAssignedCredentialAccountMap = new Map<String, Id>();
                set<string> insertedCredSet = new set<string>();
                for (Assigned_Credential_Account__c accCred : insertAccountAssignedCredential) {
                    String accountWithCredsKey = accCred.Account__c + '-' + accCred.Credential__c;
                    newlyCreatedAssignedCredentialAccountMap.put(accountWithCredsKey, accCred.Id);
                    insertedCredSet.add(accCred.Credential__c);
                }
                
                // Find the Assigned_Credential__c records that need to be updated
                List<Assigned_Credential__c> assignedCredentialsToUpdate = [SELECT Id, Assigned_Credential_Account__c, Credential_Category__c, Contact__c,Credential__c,Account__c
                                                                            FROM Assigned_Credential__c
                                                                            WHERE Contact__c IN :mapcontact.values()
                                                                            AND Credential__c IN : insertedCredSet];
                
                list<Assigned_Credential__c> listToUpdateAssignedCredentials = new list<Assigned_Credential__c>();
                // Update Assigned_Credential__c records with the newly created Assigned_Credential_Account__c
                for (Assigned_Credential__c assCred : assignedCredentialsToUpdate) {
                    String accountWithCredsKey = assCred.Account__c + '-' + assCred.Credential__c;
                    if (newlyCreatedAssignedCredentialAccountMap.containsKey(accountWithCredsKey)) {
                        assCred.Assigned_Credential_Account__c = newlyCreatedAssignedCredentialAccountMap.get(accountWithCredsKey);
                        listToUpdateAssignedCredentials.add(assCred);
                    }
                }
                
                if (!listToUpdateAssignedCredentials.isEmpty()) {
                    upsert listToUpdateAssignedCredentials;
                }
            }
            
            if(insertAssignedCredential.size()>0){
                Database.SaveResult[] AssignedCredentialList=Database.insert(insertAssignedCredential);
                for (Database.SaveResult srContact : AssignedCredentialList)
                {
                    AssignedCredentialId.add(srContact.getId());
                } 
            } 
        }
        catch (Exception e) {
            //get 	Line number and pass to ExceptionHandlingHandler class
            integer lineNumber = e.getLineNumber();
            System.debug('Exception in methodforAutoEnrollAssignedCredential: ' + e.getMessage()+'The error line number ===' +lineNumber);
            HandleCustomLogsException.LogExceptionMethod(e); 
        }
    }
}