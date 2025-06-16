@isTest
public class CT_PricingWebService_Test {
    
    public static testMethod void testCallout(){
        CT_Common_Settings__c config = CT_Common_Settings__c.getOrgDefaults();
        config.Pricing_Endpoint__c = 'http://sap-wddev.certainteed.com/saper/EQX100/SFDCPricingRequest';
        config.Pricing_Username__c = 'timrl';
        config.Pricing_Password__c = 'P@ido!';
        upsert config;
        
        CT_PricingWebService obj = new CT_PricingWebService();
        obj.requestMaterialPrice();
        obj.requestPriceInfo();
       
    }
}