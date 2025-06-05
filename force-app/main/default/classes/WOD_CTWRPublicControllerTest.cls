/**
 * @description Test class for WOD_CTWRPublicController
*/
@isTest
public class WOD_CTWRPublicControllerTest {
  /**
   * @description data set up and execution
  */
    public static testmethod void publicControllerTestMethod(){
        WOD_2__Business_Category_Configuration__c bcc = WOD_TestDataFactory.createBusinessCategoryConfig('Roofing');
        insert bcc;
        WOD_2__Warranty_Registration__c wr = WOD_TestDataFactory.createWarrantyRegistration('Residential','Roofing');
        insert wr;
        WOD_Warranty_Transfer__c wt = WOD_TestDataFactory.createWarrantyTransfer('Residential','Roofing');
        insert wt;
        WOD_CTWRPublicController.mailingSectionWrapper wm = new WOD_CTWRPublicController.mailingSectionWrapper();
        wm.firstName ='Test';
        wm.lastName ='Test';
        wm.address1 ='sdde';
        wm.address2 ='sss';
        wm.cityName ='addd';
        wm.state='Florida (FL)';
        wm.postalCode ='201308';
        wm.country ='United States';
        wm.emailVal='aaa@mail.com';
        wm.phoneVal ='9999999999';
        WOD_CTWRPublicController.buildingSectionWrapper wb = new WOD_CTWRPublicController.buildingSectionWrapper();
        wb.selectedPropertyType ='Residential';
        wb.selectedBuildingType ='Other';
        wb.organization ='Tavant';
        wb.firstName ='ddd';
        wb.lastName ='jfkf';
        wb.address1 ='wrr';
        wb.address2 ='ww';
        wb.cityName ='sss';
        wb.state ='Florida (FL)';
        wb.postalCode ='201308';
        wb.country ='United States';
        WOD_CTWRPublicController.productInformationSectionWrapper wp = new WOD_CTWRPublicController.productInformationSectionWrapper();
        wp.selectedInstallDate =String.ValueOf(System.today());
        wp.selectedTransferDate=String.ValueOf(System.today());
        wp.selectedProductGroup ='Solar';
        wp.productDetailVal='details';
        wp.selectedInstallationLoc ='Other';
        wp.otherInstallationLocation='other';
        wp.selectedBusinessUnit=bcc.Id;
        WOD_CTWRPublicController.getUnitOfMeasure();
        WOD_CTWRPublicController.SaveRecord(wm,wb,wp,'','Roofing'); 
        WOD_CTWRPublicController.SaveRecord(wm,wb,wp,'transfer','Roofing'); 
    }
}