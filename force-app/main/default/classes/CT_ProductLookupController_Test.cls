@isTest
private class CT_ProductLookupController_Test {

    static testMethod void test1(){
        
        
 Plants__c Testingplant1 = new Plants__c();
        Testingplant1.Name ='Testing1232324';
        Testingplant1.Plant_Manager__c = UserInfo.getUserId();
        Testingplant1.SAP_Plant__c='0600';
        insert Testingplant1;
        
        List<Product2> productList = new List<Product2>();
        List<Product_Search_Fields__c> psfList = new List<Product_Search_Fields__c>();
        product2 p = new product2();
        p.name='Test Product';
        p.productCode = 'labor3456';
        p.Plants__c ='Apex Plant';
        p.ApprovingPlant__c =Testingplant1.id;
        insert p; 
        productList.add(p);
        
        Account a = new Account();
        a.Name = 'test Account';
        insert a;
        
        Case c = new Case();
        c.AccountId = a.Id;
        c.status = 'New';
        c.Origin = 'Email';
        insert c;
        
        case_order_items__c coi = new case_order_items__c();
        coi.case__c = c.id;
        coi.currency__c = 'USD';
        coi.product__c = p.id;
        insert coi;
        Product_Search_Fields__c psf = new Product_Search_Fields__c();
        psf.Name = '1';
        psf.FieldApiName__c ='name';
        psfList.add(psf);
        Product_Search_Fields__c psf1 = new Product_Search_Fields__c();
        psf1.Name = '2';
        psf1.FieldApiName__c ='plants__c';
        psfList.add(psf1);
        insert psfList;
        
        String jsonString = '[{"operatorValue":"Contains","fieldName":"plants__c","filterValue":"Apex Plant","fieldType":"STRING"}]';
        CT_ProductLookupController.typeAhead(p.Name);
        CT_ProductLookupController.fetchCase(c.Id);
        CT_ProductLookupController.getProductName(p.Id);
        CT_ProductLookupController.fetchProductWrapper(c.Id);
        CT_ProductLookupController.applyFilter(jsonString);
        CT_ProductLookupController.fieldWrapper fw = new CT_ProductLookupController.fieldWrapper();
        CT_ProductLookupController.operatorWrapper ow = new CT_ProductLookupController.operatorWrapper();
        CT_ProductLookupController.filterWrapper filterWrapper = new CT_ProductLookupController.filterWrapper();
        CT_ProductLookupController.insertCaseItemRecord(coi, p.Id);
        CT_ProductLookupController.fetchProductList('');
        CT_ProductLookupController.fetchOperators();
    }
}