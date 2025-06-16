/**********************************************************************
Name:  WOD_PaymentHandlerClsTest
===============================================================
Purpose: Test data set up class                                                                                                               
===============================================================
===============================================================
History                                                            
-------                                                            
  AUTHOR        DATE            DETAIL                        
  Tavant     03/06/2021      INITIAL DEVELOPMENT            
***********************************************************************/
@isTest
public class WOD_warrantyRegDownloadTest {
  public static testmethod void warrantyRegMethod(){
        WOD_2__Warranty_Registration__c wr = WOD_TestDataFactory.createWarrantyRegistration('Residential','Roofing');
        //wr.Name ='WR-0606';
        insert wr;
        WOD_2__Warranty_Registration__c w =[Select id,WR_Tracking_Number__c from WOD_2__Warranty_Registration__c where id=:wr.id];
        WOD_warrantyRegDownload wrd = new WOD_warrantyRegDownload();
        WOD_warrantyRegDownload.renderingService ='ssss';
        WOD_warrantyRegDownload.renderedFileName ='sgg';
        WOD_warrantyRegDownload.renderedContentType ='aa';
        WOD_warrantyRegDownload.saveToPdf('aaa');
        WOD_warrantyRegDownload.sanitizeFileName('aaa');
        WOD_warrantyRegDownload.getEntireData(w.WR_Tracking_Number__c);
    }
    public static testmethod void warrantyRegMethod2(){
        WOD_Warranty_Transfer__c wt = WOD_TestDataFactory.createWarrantyTransfer('Residential','Roofing');
        insert wt;
         WOD_Warranty_Transfer__c  wrData = [SELECT First_Name_BL__c,Last_Name_BL__c,Address_1_BL__c,Address_2_BL__c,City_BL__c,Country_BL__c,State_BL__c,Postal_Code_BL__c,
                                                           Name,Last_Name__c,Quantity__c,Transfered_Date__c,Address_1__c,Address_2__c,Building_Type__c,Business_Units__c,City__c,Country__c,Install_Date__c,Installation_Location__c,Postal_Code__c,Product_Detail__c,Product_Group__c,State__c FROM WOD_Warranty_Transfer__c where id=:wt.id];
        
        System.debug(wt.Id+'=====>***'+wrData.Name);
        WOD_warrantyRegDownload wrd = new WOD_warrantyRegDownload();
        WOD_warrantyRegDownload.renderingService ='ssss';
        WOD_warrantyRegDownload.renderedFileName ='sgg';
        WOD_warrantyRegDownload.renderedContentType ='aa';
        WOD_warrantyRegDownload.saveToPdf('aaa');
        WOD_warrantyRegDownload.sanitizeFileName('aaa');
        WOD_warrantyRegDownload.getEntireData(wrData.Name);
    }
}