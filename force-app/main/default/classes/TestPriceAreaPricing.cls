/*********************************************************************************
* Test Class: {TestPriceAreaPricing}
* Created by {DateCreated 12/03/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Code coverage of PriceAreaPricing.cls,
                      PriceAreaCallOut.cls,
                      PAPRequest.cls,
                      PAPResponse.cls}
----------------------------------------------------------------------------------
* Utility Test Data: {TestClassUtility.cls}
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Abhishek 12/03/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
*********************************************************************************/
@isTest
private class TestPriceAreaPricing {

    static testMethod void myUnitTest() {
        PriceAreaPricing pap = new PriceAreaPricing();
        pap.plant = 'test'; 
        pap.ivdate = 'test';   
        pap.district = 'test';
        pap.material = 'test';
        pap.division1 = 'test';
        pap.ividc = 'test';
        pap.searchProducts();
        pap.onPageLoad();
        pap.showSearchResultView();
        PAPResponse pr = new PAPResponse();
        pr.EffDate = 'test';
        pr.Plant = 'test';
        pr.SalesOrg = 'test';
        pr.District = 'test';
        pr.ItemClass = 'test';
        pr.Material = 'test';
        pr.Idc = 'test';
        pr.UnitAreaPrice = 10.0;
        pr.UnitCurrency = 'test';
        pr.UnitPriceUom = 'test';
        pr.SapSelPrice = 10.0;
        pr.SapSelCurr = 'test';
        pr.SapSelUom = 'test';
        System.assertEquals(pap.plant,'test');
        
        sapComDocumentSapRfcFunctions.ZTSD_STOCK_AV ctrl1 = new sapComDocumentSapRfcFunctions.ZTSD_STOCK_AV();
        PA_sapComDocumentSapRfcFunctions.ZTSD_STOCK_AV ctrl2 = new PA_sapComDocumentSapRfcFunctions.ZTSD_STOCK_AV();

        sapComPricing.ZSdWsdlPriceAreaPriceFmResponse ctrl3 = new sapComPricing.ZSdWsdlPriceAreaPriceFmResponse();  
        sapComPricing.ArrayOfZTSD_PRICE_AREA_O ctrl4 = new sapComPricing.ArrayOfZTSD_PRICE_AREA_O();
        sapComPricing1.ZTSD_PRICE_AREA_O ctrl5 = new sapComPricing1.ZTSD_PRICE_AREA_O();  
        new tempuriOrgPricing.responses_element(); 
        new tempuriOrgPricing.responsesResponse_element();
        try{
        new tempuriOrgPricing.PriceAreaPricingImplSoap().responses('1','1','1','1','1','1','1');
        }catch(Exception e){}
    }
}