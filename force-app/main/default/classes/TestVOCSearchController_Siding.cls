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
**************************************************************************************************/
@isTest
private class TestVOCSearchController_Siding {

    static testMethod void myUnitTest1() {
        // TO DO: implement unit test
        VOCSearchController_Siding vocObj = new VOCSearchController_Siding();
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
        vocObj.c.Brand_siding__c = 'Vytec brand - Vinyl Panel';
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
        
        vocObj = new VOCSearchController_Siding();
        vocObj.c.Product_Line__c = 'Fiber Cement';
        vocObj.c.Product_Family__c = 'Panel';
        vocObj.c.Brand_siding__c = 'Vytec brand - Vinyl Panel';
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
        vocObj.c.Brand_siding__c = 'Norandex brand - Vinyl Accessory';
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
        insert acc;
        
        
        
        VOC_Data_Entry__c c = new VOC_Data_Entry__c();
        c.Category__c = 'Products';
        c.Product_Line__c = 'Fiber Cement';
        c.Product_Family__c = 'Panel';
        c.Brand_siding__c = 'Vytec brand - Vinyl Panel';
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
        c.Brand_siding__c = 'test';
        insert c;
        
        VOCSearchController_Siding vocObj = new VOCSearchController_Siding();
        vocObj.wrapperQueryList.get(0).searchValue = 't';
        vocObj.doSearch();
        
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
        vocObj.doSearch();
        
        vocObj = new VOCSearchController_Siding();
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
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Market Family';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Market Family';
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
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Priority';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Priority';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        
        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Product Family';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Product Family';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();

         //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Topic';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Topic';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();

        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'What';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.c = c;
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'What';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
        vocObj.wrapperQueryList.get(0).selectedOperator = 'equals';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).selectedOperator = 'does not equal';
        vocObj.doSearch();
        
        //----------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Online VOC Form';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Online VOC Form';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
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
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'VOC Input Form';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'VOC Input Form';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
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
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'WTU Note';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'WTU Note';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
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
        
        //------------------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Account';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Account';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
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
        
        //------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Case Number';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Case Number';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
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
        //---------------------------------------------------------------------------------
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Subject';
        vocObj.wrapperQueryList.get(0).searchValue = '';
        vocObj.doSearch();
        vocObj.wrapperQueryList.get(0).fieldToQuery = 'Subject';
        vocObj.wrapperQueryList.get(0).searchValue = 'test';
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
        //---------------------------------------------------------------------------------
        vocObj = new VOCSearchController_Siding();
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
        //START Added by Kritika Bhati for S-490567 on 26/6/2017
        vocObj.saveAll();
        vocObj.addFilter();
        vocObj.removeFilter();
        vocObj.deleteRecords1();
        vocObj.selectAll();
        //END S-490567   
    }

}