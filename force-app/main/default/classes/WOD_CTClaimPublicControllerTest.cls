/**
 * @description Test class for WOD_CTClaimPublicController
*/
@isTest
public class WOD_CTClaimPublicControllerTest {
    /**
     * @description data set up and execution
    */
    public static testmethod void publiccontroller(){
        WOD_2__Business_Category_Configuration__c bcc = WOD_TestDataFactory.createBusinessCategoryConfig('Roofing');
        insert bcc;
        Account acc = WOD_TestDataFactory.createAccount('Tavant','','Customer');
        insert acc;
        WOD_2__Claim__c claim = WOD_TestDataFactory.CreateClaim('Standard','Standard',acc.id,'Roofing');
        insert claim;
        WOD_ZipFile__c zp =WOD_TestDataFactory.createZipFile('Roofing','Roofing');
        insert zp;
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
        wc.selectedBusinessUnit=bcc.Id;      
        WOD_CTUtil.OtherSiteDetails wo = new WOD_CTUtil.OtherSiteDetails();
        wo.userEmail ='aa@mailc.com';
        wo.userPhone ='1234567890';
        wo.buildingProductType ='';
        wo.buildingProductName ='';
        List<WOD_2__Business_Category_Configuration__c> lstBCC = new List<WOD_2__Business_Category_Configuration__c>();        
        WOD_2__Business_Category_Configuration__c bcc1 = new WOD_2__Business_Category_Configuration__c();
        bcc1.Name = 'Siding';        
        WOD_2__Business_Category_Configuration__c bcc2 = new WOD_2__Business_Category_Configuration__c();
        bcc2.Name = 'Roofing';
        WOD_2__Business_Category_Configuration__c bcc3 = new WOD_2__Business_Category_Configuration__c();
        bcc3.Name = 'Commercial Building & Infrastructure';
        WOD_2__Business_Category_Configuration__c bcc4 = new WOD_2__Business_Category_Configuration__c();
        bcc4.Name = 'Solar Solutions';        
        lstBCC.add(bcc1);
        lstBCC.add(bcc2);
        lstBCC.add(bcc3);
        lstBCC.add(bcc4);
        insert lstBCC;
        WOD_CTClaimPublicController.getPaymentRecordTypes('Account');   
        WOD_2__Claim__c clm = WOD_CTClaimPublicController.submit(we, wb, wc, wo, false);
        WOD_CTClaimPublicController.serachClaim(claim.Id,claim.Name,'','');
        WOD_CTClaimPublicController.getAllPicklistValues(true);
        WOD_CTClaimPublicController.getAllPicklistValues(false);
        WOD_CTClaimPublicController.getInstallLocationPicklistValues('Siding');
        WOD_CTClaimPublicController.getInstallLocationPicklistValues('Roofing');
        WOD_CTClaimPublicController.getInstallLocationPicklistValues('Commercial Building & Infrastructure');
        WOD_CTClaimPublicController.getInstallLocationPicklistValues('Solar Solutions');
        WOD_CTClaimPublicController.getCurrentUser();
        WOD_CTClaimPublicController.getZipFileRecords('Roofing');
        WOD_CTClaimPublicController.verifyBuildingLocation('5353 Oak Forest Dr',null,'Jacksonville','Florida (FL)','32211','United States','aaa@mail.com','Roofing');
        Attachment attach=new Attachment();     
        attach.Name='Roofing.docx';
        Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
        attach.body=bodyBlob;
        attach.parentId=clm.id;
        insert attach;
        WOD_CTClaimPublicController.downLoadWrapper dw = WOD_CTClaimPublicController.downloadFile(clm.Id,'Roofing','Roofing');
        
        
        WOD_CTClaimPublicController.actionPoller(dw);    
                
    }
}