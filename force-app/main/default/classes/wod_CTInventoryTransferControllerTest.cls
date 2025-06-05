/**
 * @description Test class for wod_CTInventoryTransferController
*/
@isTest(SeeAllData = false)
public class wod_CTInventoryTransferControllerTest {
    /**
     * @description data set up and execution
    */
    public static testMethod void CTInventoryTransferControllerTest()
    {
        WOD_2__Warranty_Registration__c wr = WOD_TestDataFactory.createWarrantyRegistration('Residential','Roofing');
        insert wr;
        WOD_Warranty_Transfer__c wt = WOD_TestDataFactory.createWarrantyTransfer('Residential','Roofing');
        insert wt;
        PageReference pageRef = Page.wod_CTInventoryTransferDetails;
        Test.setCurrentPage(pageRef);
        WOD_2__Warranty_Registration__c w = [select id,WR_Tracking_Number__c from WOD_2__Warranty_Registration__c where id =:wr.id];
        ApexPages.currentPage().getParameters().put('trackingNumber',w.WR_Tracking_Number__c);
        ApexPages.currentPage().getParameters().put('printPdf','true');
        ApexPages.currentPage().getParameters().put('id',wr.Id);
        
        wod_CTInventoryTransferController ct=new wod_CTInventoryTransferController();
        
        ct.wrt=wr;
        
        ct.warrantyRegistration=wr;
        
        ct.wtt=wt;
        ct.print =false;
        ct.isSiding = false;
        ct.isRoofing = false;
        ct.download();
        ct.renderingAsHtml();
        ct.saveToPdf();
        ct.sanitizeFileName('aaa');
        attachment acc = new Attachment();
        ct.newAttachments = new list<Attachment>{acc};
        ct.newAttachmentsCopied = new list<Attachment>{acc};
        //Attachment att=ct.attachment;
        ct.Organization='organisation';
        ct.BL_email='aa@sd.com';
        ct.BL_phone='121213123';
        ct.errorMessage1='test';
        ct.recordType='transfer';
        ct.renderedFileName='test';
        ct.address2='fdgdfsdf';
        ct.address1='dsfgdsfa';
        ct.BL_address1 = 'qwerty';
        ct.BL_address2='dsfad';
        ct.acc = new account();
        ct.propertyType='Commercial';
        ct.firstName = 'Test1';
        ct.lastName = 'Test1';
        ct.email = 'Test1@gmail.com';
        ct.phone='1234567890';
        ct.city = 'Test1';
        ct.state = 'Test1';
        ct.country = 'US';
        ct.postalcode = '111111';
        ct.BL_firstName = 'Test1';
        ct.BL_lastName = 'Test1';
        ct.BL_email = 'Test1@gmail.com';
        ct.BL_phone='1234567890';
        ct.BL_city = 'Test1';
        ct.BL_state = 'Test1';
        ct.BL_country = 'US';
        ct.BL_postalcode = '111111';
        ct.BuildingType='organisation';
        ct.ProductName='organisation';
        ct.ProductGroup='organisation';
        ct.UnitsOfMeasure='organisation';
        ct.installedDate = System.today();
        ct.TransferedDate = System.today();
        ct.Quantity = 10;
        ct.ProductDetail='organisation';
        ct.InstallationLocation='organisation';
        ct.InstallationLocationOther='organisation';
        ct.errorMessage='organisation';
        ct.errorMessage1='organisation';
        ct.recordType='organisation';
        ct.url = 'https://gmail.com';
        ct.render=true;
        ct.attachmentRender=true;
    }
    /**
     * @description data set up and execution
    */
    public static testMethod void CTInventoryTransferControllerTest1()
    {
        WOD_Warranty_Transfer__c wt = WOD_TestDataFactory.createWarrantyTransfer('Residential','Roofing');
        insert wt;
        PageReference pageRef = Page.wod_CTInventoryTransferDetails;
        Test.setCurrentPage(pageRef);
        wt = [SELECT Id, name from WOD_Warranty_Transfer__c where Id = :wt.Id LIMIT 1];
        ApexPages.currentPage().getParameters().put('trackingNumber',wt.Name);
        ApexPages.currentPage().getParameters().put('printPdf','true');
        ApexPages.currentPage().getParameters().put('id',wt.Id);
        
        wod_CTInventoryTransferController ct=new wod_CTInventoryTransferController();
        ct.wtt=wt;
        ct.print =false;
        ct.isSiding = false;
        ct.isRoofing = false;
        ct.download();
        ct.renderingAsHtml();
        ct.saveToPdf();
        ct.sanitizeFileName('aaa');
    }
}