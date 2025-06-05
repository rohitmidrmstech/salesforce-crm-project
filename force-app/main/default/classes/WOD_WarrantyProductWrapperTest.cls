@isTest
public class WOD_WarrantyProductWrapperTest {
    @isTest
    public static void methodTest(){
        Product_Type__c productType= WOD_TestDataFactory.createProductType();
        insert productType;
        
        WOD_2__Policy_Definition__c polDef = WOD_TestDataFactory.createPolicyDefination();
        insert polDef;
        Product_Line__c pl = new Product_Line__c();
        pl.Name = 'Siding';
        pl.Code__c = 'PL001';
        pl.Siding_Id__c = '09876789';
        insert pl;
        Market_Family__c mf = new Market_Family__c();
        mf.Product_Line__c = pl.id;
        insert mf;
        WOD_2__Warranty_Product__c product = WOD_TestDataFactory.createWarrantyProduct('test product','1',true,'Non-Serialized','Item','Machine','Hours');
        product.Product_Type__c =productType.Id;
        product.Product_Line__c = 'test';
        product.Market_Family__c = mf.id;
        insert product;
        //WOD_WarrantyProductWrapper wpw = new WOD_WarrantyProductWrapper();
        WOD_WarrantyProductWrapper.getProductDetails(product.id,false);
        WOD_WarrantyProductWrapper.getProductDetails(product.id,true);
    }
}