/**************************************************************************************************
* Controller Class: VOCSearchController
* Created by Madan Vishwakarma, Navivo Technology Solution, DateCreated: 24/02/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* Page is used to search according to different parameters.
---------------------------------------------------------------------------------------------------
* Unit Test: TestVOCSearchController
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME             DATE            DETAIL  FEATURES
    1.0      Madan Vishwakarma (LRT)    24/02/2014      INITIAL DEVELOPMENT
    2.0      Hithesh Ravuri             15/05/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
**************************************************************************************************/
@isTest
private class TestVOCSearchController {
/*
    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        VOCSearchController vocObj = new VOCSearchController();
        vocObj.advanceSearch();
        vocObj.simpleSearch();
        vocObj.exportToExcel();
        vocObj.cancelCustom();
        vocObj.getFieldToQueryOptions();
        vocObj.getLogicalOperatorOptions();
        vocObj.getOperatorOptions();
        vocObj.getDateOperatorOptions();
        vocObj.getCategoryOptions();
        vocObj.c.Product_Line__c = 'Fiber Cement';
        vocObj.getProductFamilyOptions();
        vocObj.c.Product_Family__c = 'Panel';
        vocObj.getBrandOptions();
        vocObj.c.Brand__c = 'Vytec brand - Vinyl Panel';
        vocObj.getMarketFamilyOptions();
        vocObj.c.Market_Family__c = 'Eminence';
        vocObj.getMarketSegmentOptions();
        vocObj.c.Category__c = 'Products';
        vocObj.getTopicOptions();
        vocObj.c.Category__c = 'Miscellaneous';
        vocObj.getTopicOptions();
        vocObj.c.Category__c = 'Marketing Supports';
        vocObj.getTopicOptions();
        vocObj.c.Category__c = 'Marketing Programs';
        vocObj.getTopicOptions();
        
        vocObj = new VOCSearchController();
        vocObj.c.Product_Line__c = 'Fiber Cement';
        vocObj.c.Product_Family__c = 'Panel';
        vocObj.c.Brand__c = 'Vytec brand - Vinyl Panel';
        vocObj.c.Market_Family__c = 'Eminence';
        System.currentPageReference().getParameters().put('pType', 'ProductLine');
        vocObj.adjustDependentValues();
        System.currentPageReference().getParameters().put('pType', 'ProductFamily');
        vocObj.adjustDependentValues();
        vocObj.c.Product_Family__c = 'Accessory';
        System.currentPageReference().getParameters().put('pType', 'ProductFamily');
        vocObj.adjustDependentValues();
        System.currentPageReference().getParameters().put('pType', 'Brand');
        vocObj.adjustDependentValues();
        vocObj.c.Brand__c = 'Norandex brand - Vinyl Accessory';
        System.currentPageReference().getParameters().put('pType', 'Brand');
        vocObj.adjustDependentValues();
        System.currentPageReference().getParameters().put('pType', 'MarketFamily');
        vocObj.adjustDependentValues();
        vocObj.c.Market_Family__c = 'Cove Trim';
        System.currentPageReference().getParameters().put('pType', 'MarketFamily');
        vocObj.adjustDependentValues();
        
        vocObj.doSort();
        
        vocObj.getSortDirection();
        vocObj.sortDirection = 'DESC';
        vocObj.getSortDirection();
        
    }
    
    static testMethod void myUnitTest2() {
        // TO DO: implement unit test
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity = 'Test';
        insert acc;
        
        
        
        VOC_Data_Entry__c c = new VOC_Data_Entry__c();
        c.Category__c = 'Products';
        c.Product_Line__c = 'Fiber Cement';
        c.Product_Family__c = 'Panel';
        c.Brand__c = 'Vytec brand - Vinyl Panel';
        c.Market_Family__c = 'Eminence';
        c.Account__c = acc.Id;
        c.Note__c = 'test Note';
        c.What__c = 'test';
        c.Topic__c = 'Topic';
        c.Product_Family__c = 'test';
        c.Priority__c = 'test';
        c.Market_Segment__c = 'test';
        c.Market_Family__c = 'test';
        c.Category__c = 'test';
        c.Brand__c = 'test';
        insert c;
        
        VOCSearchController vocObj = new VOCSearchController();
        vocObj.wrapperQueryList.get(0).searchValue = 't';
        vocObj.doSearch();
        
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
        vocObj.doSearch();
        
        vocObj = new VOCSearchController();
        vocObj.advanceSearch();
        
        //---------------------------------------------------------------------------------
        vocObj = new VOCSearchController();
        vocObj.advanceSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Product Line';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Product Line';
        vocObj.c.Product_Line__c = 'Fiber';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.c.Product_Line__c = 'test';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        vocObj.getSegmentTypeOptions();
        vocObj.getTopicOption();
        vocObj.saveAll();
        vocObj.addFilter();
        vocObj.removeFilter();
        vocObj.selectAll();
        vocObj.deleteRecords1();
    }
    
    static testMethod void myUnitTest3() {
        // TO DO: implement unit test
        Account acc = new Account();
        acc.Name = 'test';
        acc.BillingCity = 'Test';
        insert acc;
        
        
        
        VOC_Data_Entry__c c = new VOC_Data_Entry__c();
        c.Category__c = 'Products';
        c.Product_Line__c = 'Fiber Cement';
        c.Product_Family__c = 'Panel';
        c.Brand__c = 'Vytec brand - Vinyl Panel';
        c.Market_Family__c = 'Eminence';
        c.Account__c = acc.Id;
        c.Note__c = 'test Note';
        c.What__c = 'test';
        c.Topic__c = 'Topic';
        c.Product_Family__c = 'test';
        c.Priority__c = 'test';
        c.Market_Segment__c = 'test';
        c.Market_Family__c = 'test';
        c.Category__c = 'test';
        c.Brand__c = 'test';
        insert c;
        
        VOCSearchController vocObj = new VOCSearchController();
        vocObj.wrapperQueryList.get(0).searchValue = 't';
        vocObj.doSearch();
        
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
        vocObj.doSearch();
        
        vocObj = new VOCSearchController();
        vocObj.advanceSearch();
        
        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Brand';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Brand';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();

        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Category';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Category';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        
        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Market Segment';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Market Segment';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        
        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'City/State';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'City/State';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        
         //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Role';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Role';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();

        
        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Market Segment';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Market Segment';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
        vocObj.c.Market_Segment__c = 'Test';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'begins with';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not begin with';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'ends with';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not end with';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'contains';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not contain';
        vocObj.doSearch();
        
        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Insight';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Insight';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
        vocObj.c.Insight__c = 'Test';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'begins with';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not begin with';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'ends with';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not end with';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'contains';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not contain';
        vocObj.doSearch();
        
        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Meeting Date';
        vocObj.doSearch();
        vocObj.c.Created_Date__c = Date.today();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'is greater than';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'is greater than or equal to';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'is less than';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'is less than or equal to';
        vocObj.doSearch();
    } */
}