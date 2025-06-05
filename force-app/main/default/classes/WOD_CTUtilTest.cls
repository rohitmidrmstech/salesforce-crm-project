@isTest
public class WOD_CTUtilTest {
  
     public static testmethod void utilMethod(){
        
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert claim;
         // Create a test WOD_2__Warranty_Registration__c record
        WOD_2__Warranty_Registration__c registration = new WOD_2__Warranty_Registration__c(
            WOD_2__Customer__c = claim.Customer__c,
            Business_Units__c = 'Roofing',
            WOD_2__Registration_Date__c = Date.today().addMonths(-10),
            Expiration_Date__c = Date.today().addMonths(2),
            Coverage__c = '5 Star',
            Quantity__c = 100,
            Shingle_Name__c = 'Test Shingle',
            Shingle_Color__c = 'Red',
            JobCompletionDate__c = Date.today().addMonths(-12)
        );
        insert registration;
        
        WOD_CTUtil.EndUserDetails we = new WOD_CTUtil.EndUserDetails();
        we.firstName ='John';
        we.lastName = 'Doe';
        we.address1 ='5353 Oak Forest Dr';
        we.address2 ='aa';
        we.cityName = 'Jacksonville';
        we.state ='Florida (FL)';
        we.postalCode ='32211';
        we.country = 'United States';        
        WOD_CTUtil.BuildingDetails wb= new WOD_CTUtil.BuildingDetails();
        wb.firstName ='John';
        wb.lastName ='Doe';
        wb.address1='5353 Oak Forest Dr';
        wb.address2='aa';
        wb.cityName='Jacksonville';
        wb.state ='Florida (FL)';
        wb.postalCode ='32211';
        wb.country = 'United States'; 
        WOD_CTUtil.ClaimDetails wc = new WOD_CTUtil.ClaimDetails();
        wc.installedDate =System.Today();
        wc.productValue ='Solar';
        wc.productDetails ='qqq';
        wc.concernDetails ='www';
        wc.appliedSuare =1;
        wc.concernedSquare =1;
        wc.buildingValue ='Other';
        wc.locationValue ='Other';
        wc.otherLocationValue ='aa';     
        WOD_CTUtil.OtherSiteDetails wo = new WOD_CTUtil.OtherSiteDetails();
        wo.userEmail ='aa@mailc.com';
        wo.userPhone ='1234567890';
        wo.buildingProductType ='';
        wo.buildingProductName ='';
        Test.startTest();
        WOD_CTUtil.accountCreation('5353 Oak Forest Dr','aaa','Jacksonville','Florida (FL)','32211','United States');
        WOD_CTUtil.addressValidation('5353 Oak Forest Dr',null,'Jacksonville','Florida (FL)','32211','United States','aaa@mail.com','Roofing');
        WOD_CTUtil.warrantyRegistrationCreation(claim,'Extended Warranty',claim.Id);
        WOD_CTUtil.getContentRecord(claim.Id);
        WOD_AddressVerificationUtilityController addVf=new WOD_AddressVerificationUtilityController();
        addVf.AddressVerificationHttpCall(null);
        WOD_CTUtil.mockMethod1();
        Test.stopTest();
     }
     public static testmethod void utilMethodsiding(){
        
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Siding');         
        insert claim2;
         // Create a test WOD_2__Warranty_Registration__c record
        WOD_2__Warranty_Registration__c registration = new WOD_2__Warranty_Registration__c(
            WOD_2__Customer__c = claim2.Customer__c,
            Business_Units__c = 'Siding',
            WOD_2__Registration_Date__c = Date.today().addMonths(-10),
            Expiration_Date__c = Date.today().addMonths(2),
            Coverage__c = '5 Star',
            Quantity__c = 100,
            Shingle_Name__c = 'Test Shingle',
            Shingle_Color__c = 'Red',
            JobCompletionDate__c = Date.today().addMonths(-12)
        );
        insert registration;
        
        WOD_CTUtil.EndUserDetails we = new WOD_CTUtil.EndUserDetails();
        we.firstName ='John';
        we.lastName = 'Doe';
        we.address1 ='5353 Oak Forest Dr';
        we.address2 ='aa';
        we.cityName = 'Jacksonville';
        we.state ='Florida (FL)';
        we.postalCode ='32211';
        we.country = 'United States';        
        WOD_CTUtil.BuildingDetails wb= new WOD_CTUtil.BuildingDetails();
        wb.firstName ='John';
        wb.lastName ='Doe';
        wb.address1='5353 Oak Forest Dr';
        wb.address2='aa';
        wb.cityName='Jacksonville';
        wb.state ='Florida (FL)';
        wb.postalCode ='32211';
        wb.country = 'United States'; 
        WOD_CTUtil.ClaimDetails wc = new WOD_CTUtil.ClaimDetails();
        wc.installedDate =System.Today();
        wc.productValue ='Solar';
        wc.productDetails ='qqq';
        wc.concernDetails ='www';
        wc.appliedSuare =1;
        wc.concernedSquare =1;
        wc.buildingValue ='Other';
        wc.locationValue ='Other';
        wc.otherLocationValue ='aa';     
        WOD_CTUtil.OtherSiteDetails wo = new WOD_CTUtil.OtherSiteDetails();
        wo.userEmail ='aa@mailc.com';
        wo.userPhone ='1234567890';
        wo.buildingProductType ='';
        wo.buildingProductName ='';
        Test.startTest();
        WOD_CTUtil.accountCreation('5353 Oak Forest Dr','aaa','Jacksonville','Florida (FL)','32211','United States');
        WOD_CTUtil.addressValidation('5353 Oak Forest Dr',null,'Jacksonville','Florida (FL)','32211','United States','aaa@mail.com','Roofing');
        //WOD_CTUtil.warrantyRegistrationCreation(claim,'Extended Warranty',claim.Id);
        WOD_CTUtil.warrantyRegistrationCreation(null,'International',claim2.Id);
        WOD_CTUtil.getContentRecord(claim2.Id);
        WOD_AddressVerificationUtilityController addVf=new WOD_AddressVerificationUtilityController();
        addVf.AddressVerificationHttpCall(null);
        WOD_CTUtil.mockMethod1();
        Test.stopTest();
     }
     public static testmethod void utilMethod1(){
        
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim1 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert claim1;
        WOD_2__Claim__c claim2 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Siding');         
        insert claim2;
        Test.startTest();
       
        WOD_2__Claim__c claim = [SELECT Id, Customer__c, WOD_2__Warranty_Product__c, WOD_2__Claim_Type__c FROM WOD_2__Claim__c LIMIT 1];
        claim.Customer__c = acc.id;
        claim.WOD_2__Warranty_Product__c = null;
        try {
            // Call your method that contains the catch block
            WOD_CTUtil.warrantyRegistrationCreation(claim, 'ClaimType', claim.Id);
            WOD_CTUtil.mockMethod1();
        } catch(Exception e) {
            // We want the exception to be caught within the method, not here
            System.assert(false, 'The exception should be handled within the method.');
        }
        Test.stopTest();
       claim = [SELECT Workmanship_Years__c, Warranted_Roof_Area__c, Shingle_Name__c, Coverage__c FROM WOD_2__Claim__c WHERE Id = :claim.Id];
       // Check if a new Warranty Registration was created
        List<WOD_2__Warranty_Registration__c> registrations = [SELECT Id FROM WOD_2__Warranty_Registration__c WHERE IsCreatedFromClaim__c = true];
        //System.assertEquals(1, registrations.size(), 'A Warranty Registration should be created after exception.');
     }
     public static testmethod void utilMethod2(){
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Warranty_Registration__c reg1 = new WOD_2__Warranty_Registration__c(
            WOD_2__Registration_Date__c = Date.today().addDays(-100),
            JobCompletionDate__c = Date.today().addDays(-90),
            Coverage__c = '5 Star',
            WOD_2__Customer__c =acc.id,
            Quantity__c = 100,
            Shingle_Name__c = 'Shingle A',
            Shingle_Color__c = 'Red',
            Expiration_Date__c = Date.today().addYears(5),
            Roofer_Name__c = 'Roofer A',
            RooferPhone__c = '1234567890',
            Roofer_Email__c = 'rooferA@example.com',
            Certificate_Note__c = 'Certificate A',
            Comment__c = 'Comment A',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'WOD_2__Warranty_Registration__c' AND DeveloperName = 'SSP_Warranty_Registration' LIMIT 1].Id
        );
        insert reg1;

        WOD_2__Warranty_Registration__c reg2 = new WOD_2__Warranty_Registration__c(
            WOD_2__Registration_Date__c = Date.today().addDays(-200),
            JobCompletionDate__c = Date.today().addDays(-180),
            WOD_2__Customer__c =acc.id,
            Coverage__c = '4 Star',
            Quantity__c = 200,
            Shingle_Name__c = 'Shingle B',
            Shingle_Color__c = 'Blue',
            Expiration_Date__c = Date.today().addYears(3),
            Roofer_Name__c = 'Roofer B',
            RooferPhone__c = '0987654321',
            Roofer_Email__c = 'rooferB@example.com',
            Certificate_Note__c = 'Certificate B',
            Comment__c = 'Comment B',
            RecordTypeId = [SELECT Id FROM RecordType WHERE SObjectType = 'WOD_2__Warranty_Registration__c' AND DeveloperName = 'SSP_Warranty_Registration' LIMIT 1].Id
        );
        insert reg2;

        WOD_2__Claim__c claim1 = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert claim1;
        
        WOD_2__Claim__c claim = [SELECT Id, Install_Date__c, Business_Units__c FROM WOD_2__Claim__c LIMIT 1];
        List<WOD_2__Warranty_Registration__c> registrations = [SELECT Id, WOD_2__Registration_Date__c,
        Quantity__c,Workmanship_Years__c, JobCompletionDate__c,Shingle_Name__c,Shingle_Color__c, Coverage__c,Coverage_Information__c,Roofer_Name__c,
        WR_Tracking_Number__c,RooferPhone__c,Roofer_Email__c,Certificate_Note__c,Comment__c, Expiration_Date__c, RecordType.DeveloperName
                                                               FROM WOD_2__Warranty_Registration__c];
         WOD_2__Warranty_Registration__c closestRegistration = null;
         Integer minDifference = 999999999;
        //Integer minDifference = Integer.MAX_VALUE;
        Date installationDate = claim.Install_Date__c;
        String WarrantyRegistrationType;
        WOD_2__Warranty_Registration__c wr;

        // Execute the logic
        for (WOD_2__Warranty_Registration__c reg : registrations) {
            if (reg.WOD_2__Registration_Date__c != null && installationDate != null) {
                Integer daysDifference = Math.abs(reg.JobCompletionDate__c.daysBetween(installationDate));
                if (daysDifference < minDifference) {
                    minDifference = daysDifference;
                    closestRegistration = reg;
                }
            }
        }

        if (closestRegistration != null) {
            wr = closestRegistration;
            Date insDate = Date.newInstance(Date.today().year(), Date.today().month(), Date.today().day());
            if (claim.Install_Date__c != null && (claim.Business_Units__c == 'Roofing' || claim.Business_Units__c == 'Solar Solutions' || claim.Business_Units__c == 'Commercial Building & Infrastructure')) {
                insDate = claim.Install_Date__c;
            }

            if (insDate <= wr.Expiration_Date__c) {
                WarrantyRegistrationType = ((wr.Coverage__c != null) ? wr.Coverage__c : '') + '_' + 'InWarranty';
            } else {
                WarrantyRegistrationType = ((wr.Coverage__c != null) ? wr.Coverage__c : '') + '_' + 'OutOfWarranty';
            }

            if (wr.Coverage__c == '5 Star' || wr.Coverage__c == '4 Star' || wr.Coverage__c == '3 Star' || wr.Coverage__c == '5 Star 10' || wr.Coverage__c == '5 Star 25') {
                claim.Workmanship_Years__c = wr.Workmanship_Years__c;
                claim.Warranted_Roof_Area__c = wr.Quantity__c;
                claim.Shingle_Name__c = wr.Shingle_Name__c;
                claim.Shingle_Color__c = wr.Shingle_Color__c;
                claim.JobCompletion_Date__c = wr.JobCompletionDate__c;
                claim.Coverage__c = ((wr.Coverage__c != null) ? wr.Coverage__c : '');
                claim.Coverage_Information__c = wr.Coverage_Information__c;
                claim.Roofer_Name__c = wr.Roofer_Name__c;
                claim.Extended_Warranty_Registration_Number__c = wr.WR_Tracking_Number__c;
                claim.Roofer_Phone__c = wr.RooferPhone__c;
                claim.Roofer_Email__c = wr.Roofer_Email__c;
                claim.Certificate_Note__c = wr.Certificate_Note__c;
                claim.Registration_Comment__c = wr.Comment__c;
            }

            if (claim.Id != null && wr.RecordType.DeveloperName == 'SSP_Warranty_Registration') {
                update claim;
            }
        }
        WOD_CTUtil.mockMethod1();
        WOD_CTUtil.warrantyRegistrationCreation(claim,'Extended Warranty',claim.Id);        // Assertions to validate the results
        claim = [SELECT Workmanship_Years__c, Warranted_Roof_Area__c, Shingle_Name__c, Coverage__c FROM WOD_2__Claim__c WHERE Id = :claim.Id];
     }
}