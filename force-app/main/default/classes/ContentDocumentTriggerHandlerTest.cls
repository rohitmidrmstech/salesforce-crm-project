@isTest
private class ContentDocumentTriggerHandlerTest {
    @TestSetup
    static void setupTestData(){
        try{
            Automation_Controller__c control = Automation_Controller__c.getInstance();
            control.All_Triggers_enabled__c = true;
            upsert control;       
            
            RebateProgram ccbProgram = new RebateProgram(Name = 'Contractor Cash Back',
                                                         StartDate =Date.newInstance(Date.today().year(), 1, 1),  
                                                         EndDate =Date.newInstance(Date.today().year(), 12, 31),
                                                         Frequency='Annually',
                                                         Status='Active',
                                                         Rebate_Program_Type__c='CCB',
                                                         No_of_Grace_Days_for_Claim__c=60,
                                                         Country__c='CAN');
            // Insert Rebate program for current year CCB
            insert ccbProgram;
            
            id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Indirect Accounts').getRecordTypeId();
            Account testAccount = new Account(Name = 'Test Account',Status__c='Active',RecordTypeId=RecordTypeId);
            
            // Insert test Account
            insert testAccount;
            
            Contact testContact = new Contact(FirstName = 'John', LastName = 'Doe',
                                              AccountId = testAccount.Id,
                                              Enable_for_Promotion__c=true,
                                              Status__c='Active',
                                              CCB_Eligibility__c='Eligible',
                                              MailingCountry = 'Canada');
            // Insert testContact
            insert testContact;
            RebateProgramMember ccbProgramMember = new RebateProgramMember(
                Name = 'Contractor Cash Back -'+ Date.today().Year() +'-test contact',
                RebateProgramId = ccbProgram.Id, // Linking the Program
                AccountId = testAccount.Id, // Linking the Account
                Contact__c = testContact.Id, // Linking the Contact
                MemberStatus = 'Active'
            );
            insert ccbProgramMember;
            Business_Units__c roofingbusinessUnit= new Business_Units__c(Name='Roofing',Company_Code__c='1000',Sales_Org__c='1501');
            // Insert businessUnit                                               
            Insert roofingbusinessUnit;
            
            UnitOfMeasure unitMeasure= new UnitOfMeasure(Name='SQ',UnitCode='SQFT',
                                                         Description='SQ',Type='Area');
            // Insert unitMeasure
            Insert unitMeasure;
            ProgramRebateType  roofingCCBRebatetType= new ProgramRebateType(Name='Roofing-Contractor Cash Back - 2024',
                                                                            RebateProgramId=ccbProgram.Id,
                                                                            Business_Units__c=roofingbusinessUnit.Id,
                                                                            Status='Active',
                                                                            CalculationType='AggregateBased',
                                                                            RebateMeasureType='AmountperUnit',
                                                                            CalcObjectId='9N13w000000000ACAQ',
                                                                            AggregateObjectName='RebateMemberProductAggregate',
                                                                            MeasureField='TotalQuantity',
                                                                            BenefitQualifierField='TotalQuantity'
                                                                           ); 
            // Insert ProgramRebateType for CCB Roofing.  
            Insert roofingCCBRebatetType;
            Id bspccbRecordTypeId =  Schema.SObjectType.Product2.getRecordTypeInfosByName().get('BSP CCB Product').getRecordTypeId();
            
            Product2 ventProd= new Product2(Name='Rolled Ridge Vents',IsActive=true,
                                            Description='Rolled Ridge Vents',
                                            ProductCode='Rolled Ridge Vents',
                                            Base_Unit_Of_Measure__c=unitMeasure.Id,
                                            Line_Of_Business__c=roofingbusinessUnit.Id,
                                            Product_Category__c='Ventilation',
                                            recordTypeId=bspccbRecordTypeId
                                           );
            // Insert product for Ventilation Product category.
            Insert ventProd;
            
            // Insert Product UOM for Ventilation Product.
            Product_UOM__c ventProdUom= new Product_UOM__c(Name='Rolled Ridge Vents',Product__c=ventProd.Id,
                                                           Unit_of_Measure__c=unitMeasure.Id,
                                                           Applicable_Program__c='CCB;BSP');
            
            // Insert Product UOM for Ventilation Product Category.
            Insert ventProdUom;
            
            ProgramRebateTypeBenefit ventprodRebateBenefit= new ProgramRebateTypeBenefit(Name='Rolled Ridge Vents - $5',
                                                                                         Status='Active',
                                                                                         Benefit_Type__c='Regular',
                                                                                         Promo_Name__c='Ventilation Promo',
                                                                                         Product_Category__c='Ventilation',
                                                                                         ProgramRebateTypeId=roofingCCBRebatetType.Id,
                                                                                         MinimumQualifyingValue=1401,
                                                                                         MaximumQualifyingValue=1403,
                                                                                         ProductId=ventProd.Id,
                                                                                         Unit_of_Measure__c=unitMeasure.Id,
                                                                                         BenefitValue=10,
                                                                                         EffectiveStartDate=Date.newInstance(Date.today().year(), 1, 1),
                                                                                         EffectiveEndDate=Date.newInstance(Date.today().year(), 12, 31)
                                                                                        );
            // Insert  Regular benefit record for Ventilation  Product.
            insert ventprodRebateBenefit;
            
            UnitOfMeasureConversion ventUomConversion = new UnitOfMeasureConversion(Name='Rolled Ridge Vents- SQ to SQ',Product__c=ventProd.Id,
                                                                                    FromUnitOfMeasureId=unitMeasure.Id,
                                                                                    ToUnitOfMeasureId=unitMeasure.Id,
                                                                                    Applicable_Program__c='CCB;BSP',
                                                                                    ConversionFactor=1,
                                                                                    Program_Year__c= String.ValueOf(Date.today().year())
                                                                                   );
            // Insert uom conversation for certa Plank product
            insert ventUomConversion;
        }
        catch(Exception ex){
            System.debug('Exception in ContentDocumentTrigger' + ex.getMessage()) ;
        }
    }
    
    @isTest 
    static void testRebateFileUpdatesAndDeletions(){
        Id rebateProgramMemberId = [Select Id from RebateProgramMember][0].Id;
        Id programRebateTypeId = [Select Id from ProgramRebateType][0].Id;
        id contactId = [select id from contact][0].Id;
        id unitofmeasureId = [SELECT id FROM unitofmeasure][0].id;
        id productId = [Select Id,Name from Product2][0].id;
        id pcid = [select Id FROM ProgramRebateType][0].id;
        id buid = [select id from Business_Units__c][0].id;
        //Create Document
        ContentVersion contentVersion = new ContentVersion();
        contentVersion.Title = 'Test';
        contentVersion.PathOnClient = 'test.pdf';
        contentVersion.VersionData = Blob.valueOf('Test Content');
        contentVersion.IsMajorVersion = true;
        insert contentVersion;
        
        ContentVersion contentVersion2 = new ContentVersion();
        contentVersion2.Title = 'Test';
        contentVersion2.PathOnClient = 'test.pdf';
        contentVersion2.VersionData = Blob.valueOf('Test Content');
        contentVersion2.IsMajorVersion = true;
        insert contentVersion2;
        
        //Get Content Documents
        Id conDocId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion.Id].ContentDocumentId;
        
        RebateUtility.FileWrapper fileWrapper = new RebateUtility.FileWrapper();
        fileWrapper.name = 'Test';
        fileWrapper.contentVersionId = contentVersion.Id;
        fileWrapper.documentId = conDocId;
        
        List<RebateUtility.FileWrapper> files = new List<RebateUtility.FileWrapper>{fileWrapper};
        Id ccbRebateTypeId = Schema.SObjectType.RebateClaim.getRecordTypeInfosByName().get('CCB').getRecordTypeId();
        
        List<RebateClaim> claimItems = new List<RebateClaim>();
        RebateClaim ventLineItem= new RebateClaim(    ProductId=productId,
                                                  Invoice_Number__c='03438',
                                                  Quantity=10,
                                                  Unit_Of_Measure_Selected__c=unitofmeasureId,
                                                  Business_Units__c=buid,
                                                  Product_Category__c=pcid,
                                                  ClaimDate=System.Today(),
                                                  ClaimAmount=0,
                                                  RecordTypeId=ccbRebateTypeId
                                                 );
        claimItems.add(ventLineItem);
        Rebate_claim__C  rebateClaim = CCBClaimFormController.upsertCCBRebate(claimItems, String.Valueof(Date.today().year()), JSON.serialize(files), contactId, true, null, false, CCBClaimFormController.CCB_PROGRAM_IDENTIFIER,null);
        
        //Upddate document
        boolean exceptionDuringUpdate = false;
        try{
            update new ContentDocument(Id = conDocId, Description = 'test');            
        }
        catch(Exception ex){
            exceptionDuringUpdate = true;
        }
        System.assert(exceptionDuringUpdate);
        
        //delete document
        boolean exceptionDuringDelete = false;
        try{
            delete new ContentDocument(Id = conDocId);            
        }
        catch(Exception ex){
            exceptionDuringDelete = true;
        }
        System.assert(exceptionDuringDelete);
        
        //insert a new version
        boolean exceptionDuringNewVersion = false;
        try{
            ContentVersion contentVersionNew = new ContentVersion();
            contentVersionNew.Title = 'Test';
            contentVersionNew.PathOnClient = 'test.pdf';
            contentVersionNew.VersionData = Blob.valueOf('Test Content updated');
            contentVersionNew.contentDocumentId = conDocId;
            insert contentVersionNew;
        }
        catch(Exception ex){
            exceptionDuringNewVersion = true;
        }
        System.assert(exceptionDuringNewVersion);
        
        //associate an existing content document to rebate
        boolean exceptionDuringExistingDocAssociation = false;
        try{
            ContentDocumentLink cdl = new ContentDocumentLink();
            cdl.LinkedEntityId = rebateClaim.Id;
            cdl.ContentDocumentId = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:contentVersion2.Id].ContentDocumentId;
            cdl.ShareType = 'V';
            insert cdl;
            
        }
        catch(Exception ex){
            exceptionDuringExistingDocAssociation = true;
        }
        System.assert(exceptionDuringExistingDocAssociation);        
    }
}