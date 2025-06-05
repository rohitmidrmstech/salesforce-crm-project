public with sharing class VOCSearchController {
    /*
     * History:
* - VERSION  DEVELOPER NAME                  DATE            DETAIL FEATURES/CSR/TTP
    1.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
    //True if advanced Search is clicked
    public Boolean isAdvanceSearch{get;set;}
    public String searchExpression = '';
    public Boolean isAdvSrc {get; set;}
    public String parentObject {get;set;}
    public WrapperQuery tm{get; set;}
    public Boolean docSearch{get; set;}
    //Wrappers for the Search
    public List<WrapperQuery> wrapperQueryList {get; set;}
    public List<WrapperQuery> wrapperQueryListToDelete = new List<WrapperQuery>();
    public List<ContentVersion> resultContentVersionList{get; set;}
    //Wrappers for the result
    public List<WrapperResult> resultList {get;set;}
    public List<WrapperResult> resultListToDelete = new List<WrapperResult>();
    public integer rIndexResult{get;set;}
    //To Display the Created Date field for query
    public VOC_Data_Entry__c c {get; set;}
    
    public Integer rIndexQuery{get;set;}
    
    public List<resultContent> resultContentList{get;set;}
    
    public VOC_Data_Entry__c tempC {get;set;}
    
    public ProDialogue_Input__c prodialogueinput {get;set;}
    
    //SORTING
    private String sortExp = '';
    public String sortDirection = 'ASC';
    private Boolean isSorting = false;
    
    public String SearchQuery { get; set; }
    public String SearchJSON { get; set; }
    public String SearchParse { get; set; }

    public List<KonaRecord> SearchResults { get; set; }
    
    private String oldProductLineValue;
    private String oldProductFamilyValue;
    private String oldBrandValue;
    private String oldMarketFamilyValue;
    
    public class WrapperQuery
    {
        public String fieldToQuery{ get; set;}
        public String selectedLogicalOperator{ get; set;}
        public String selectedOperator{ get; set;}
        public String searchValue{get; set;}
        public Integer rowIndexQuery{ get; set;}
        public String fieldDataType{ get; set;}
        public WrapperQuery()
        {
            fieldToQuery = 'All';
            selectedLogicalOperator = 'AND';
            selectedOperator = '=';
            searchValue = '';
        }
    }
    public class WrapperResult
    {
        public VOC_Data_Entry__c voc {get; set;}
        public Boolean isSelected {get; set;}
        public Integer rowIndexResult {get; set;}
        public string attachmentURL{get;set;}
        public string attendLink{get;set;}
    }    
    String fieldName {get;set;}
    public String parentObjectName{get;set;}
    
    public VOCSearchController()
    {
        SearchJSON = 'N/A';
        SearchParse = 'N/A';
        SearchResults = new List<KonaRecord>();
        
        docSearch = true;
        resultContentList = new List<resultContent>();
        
        sortExpression = 'Name';
        sortDirection = 'ASC';
        resultList = new List<WrapperResult>();
        //Set the default Search as simple with one keyword
        isAdvanceSearch = false;
        isAdvSrc = true;
        wrapperQueryList = new List<WrapperQuery>();
        WrapperQuery wq = new WrapperQuery();
        wq.rowIndexQuery = wrapperQueryList.size();
        wrapperQueryList.add(wq);
        c = new VOC_Data_Entry__c();
        tempC = new VOC_Data_Entry__c();
        prodialogueinput = new ProDialogue_Input__c();
    }
    public void advanceSearch()
    {
        isAdvanceSearch = true;
        docSearch=false;
        wrapperQueryList = new List<WrapperQuery>();
        WrapperQuery wq = new WrapperQuery();
        wq.fieldToQuery = 'Meeting Date';
        wq.rowIndexQuery = wrapperQueryList.size();
        wrapperQueryList.add(wq);
        isAdvSrc = false;
    }
    
    public PageReference exportToExcel()
    {
        return(new PageReference('/apex/VOCSearchResultsInExcel'));
    }
    
    public PageReference cancelCustom()
    {
        //return(new PageReference('/a0l/o'));
        return(new PageReference('/home/home.jsp'));
    }
    public void simpleSearch()
    {
        isAdvanceSearch = false;
        wrapperQueryList = new List<WrapperQuery>();
        WrapperQuery w = new WrapperQuery();
        w.fieldToQuery = 'All';
        wrapperQueryList.add(w);
        isAdvSrc = true;
    }
    public List<SelectOption> getFieldToQueryOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        if(isAdvSrc)
            options.add(new SelectOption('All','All'));
        options.add(new SelectOption('Meeting Date','Meeting Date'));
        options.add(new SelectOption('City/State','City/State'));
        options.add(new SelectOption('Role','Role'));
        options.add(new SelectOption('Region','Region'));
        //options.add(new SelectOption('Info Source','Info Source'));
        options.add(new SelectOption('Market Segment','Market Segment'));
        options.add(new SelectOption('Segment Type','Segment Type'));
        //options.add(new SelectOption('Additional Source Info','Additional Source Info'));
        options.add(new SelectOption('Category','Category'));
        //options.add(new SelectOption('Product','Product'));
        options.add(new SelectOption('Topic','Topic'));
        options.add(new SelectOption('Brand','Brand'));
        options.add(new SelectOption('Insight','Insight'));
        options.add(new SelectOption('Competitor','Competitor'));
        return options;
    }
    public List<SelectOption> getLogicalOperatorOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        //options.add(new SelectOption('WHERE','WHERE'));
        options.add(new SelectOption('AND','AND'));
        options.add(new SelectOption('OR','OR'));
        //options.add(new SelectOption('NOT','NOT'));
        return options;
    }
            
    public List<SelectOption> getOperatorOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('equals','equals'));
        options.add(new SelectOption('does not equal','does not equal'));
        options.add(new SelectOption('begins with','begins with'));
        options.add(new SelectOption('does not begin with','does not begin with'));
        options.add(new SelectOption('contains','contains'));
        options.add(new SelectOption('does not contain','does not contain'));
        return options;
    }
    
    public List<SelectOption> getDateOperatorOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('equals','equals'));
        options.add(new SelectOption('does not equal','does not equal'));
        options.add(new SelectOption('is greater than','is greater than'));
        options.add(new SelectOption('is greater than or equal to','is greater than or equal to'));
        options.add(new SelectOption('is less than','is less than'));
        options.add(new SelectOption('is less than or equal to','is less than or equal to'));
        return options;
    }
    
    public List<SelectOption> getCategoryOptions()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('equals','equals'));
        options.add(new SelectOption('does not equal','does not equal'));
        return options;
    }
    
    public List<SelectOption> getProductFamilyOptions() {
        String pLineValue = '';
        if((c.Product_Line__c != null && c.Product_Line__c != '')) pLineValue = c.Product_Line__c;
        List<SelectOption> options = VOCUtil.prepareProductFamily(pLineValue);
        return options;
    }
    
    public List<SelectOption> getBrandOptions() {
        String pFamilyValue = '';
        if((c.Product_Family__c != null && c.Product_Family__c != '')) pFamilyValue = c.Product_Family__c;
        //List<SelectOption> options = VOCUtil.prepareBrand(pFamilyValue);
        List<Selectoption> options = new List<Selectoption>();
        options.add(new SelectOption('', '--None--'));
        Schema.DescribeFieldResult fieldResult = VOC_Data_Entry__c.Brand__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options;
    }
    
    public List<SelectOption> getMarketFamilyOptions() {
        String pBrandValue = '';
        if((c.Brand__c != null && c.Brand__c != '')) pBrandValue = c.Brand__c;
        List<SelectOption> options = VOCUtil.prepareMarketFamily(pBrandValue);
        return options;
    }
    
    public List<SelectOption> getMarketSegmentOptions() {
        //String pMFamilyValue = '';
        //if((c.Market_Family__c != null && c.Market_Family__c != '')) pMFamilyValue = c.Market_Family__c;
        //List<SelectOption> options = VOCUtil.prepareMarketSegment(pMFamilyValue);
        List<Selectoption> options = new List<Selectoption>();
        options.add(new Selectoption('', '--None--'));
        options.add(new Selectoption('Residential', 'Residential'));
        options.add(new Selectoption('Commercial', 'Commercial'));
        options.add(new Selectoption('Both', 'Both'));
        return options;
    }
    
    /*
    @Name   :getSegmentTypeOptions
    @Description :To get Segment Type picklist values
    
    public List<SelectOption> getSegmentTypeOptions(){
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('', '--None--'));
        Schema.DescribeFieldResult fieldResult = ProDialogue_Input__c.Segment_Type__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for(Schema.PicklistEntry p : ple){
            options.add(new SelectOption(p.getValue(), p.getValue()));
        }
        return options;
    }
    
    public void adjustDependentValues() {
        String pType = System.currentPageReference().getParameters().get('pType');
        if(pType == 'ProductLine') {
            if(oldProductLineValue != c.Product_Line__c) {
                c.Product_Family__c = null;
                c.Brand__c = null;
                c.Market_Family__c = null;
                c.Market_Segment__c = null;
            }
            oldProductLineValue = c.Product_Line__c;
        } else if(pType == 'ProductFamily') {
            if(oldProductFamilyValue != c.Product_Family__c) {
                c.Brand__c = null;
                c.Market_Family__c = null;
                c.Market_Segment__c = null;
            }
            oldProductFamilyValue = c.Product_Family__c;
        } else if(pType == 'Brand') {
            if(oldBrandValue != c.Brand__c) {
                c.Market_Family__c = null;
                c.Market_Segment__c = null;
            }
            oldBrandValue = c.Brand__c;
        } else if(pType == 'MarketFamily') {
            if(oldMarketFamilyValue != c.Market_Family__c) {
                c.Market_Segment__c = null;
            }
            oldMarketFamilyValue = c.Market_Family__c;
        }
    }
   public List<SelectOption> getTopicOption() {
            List<Selectoption> options = new List<Selectoption>();
                options.add(new Selectoption('', '--None--'));
                options.add(new Selectoption('Board', 'Board'));
                options.add(new Selectoption('Finishing', 'Finishing'));
                options.add(new Selectoption('Both', 'Both'));
                options.add(new Selectoption('Systems', 'Systems'));
            return options;
    }           
    public List<SelectOption> getTopicOptions() {
        String topicValue = '';
        if((c.Category__c != null && c.Category__c != '')) topicValue = c.Category__c;
        List<Selectoption> options = new List<Selectoption>();
        options.add(new Selectoption('', '--None--'));
        if(topicValue == 'Products') {
            options.add(new Selectoption('Color', 'Color'));
            options.add(new Selectoption('Cost', 'Cost'));
            options.add(new Selectoption('Installation - Lap', 'Installation - Lap'));
            options.add(new Selectoption('Installation - Lock', 'Installation - Lock'));
            options.add(new Selectoption('Installation - Nail Hem', 'Installation - Nail Hem'));
            options.add(new Selectoption('Length/Thickness', 'Length/Thickness'));
            options.add(new Selectoption('Marketing', 'Marketing'));
            options.add(new Selectoption('New Product Idea', 'New Product Idea'));
            options.add(new Selectoption('Next Gen Siding', 'Next Gen Siding'));
            options.add(new Selectoption('Packaging', 'Packaging'));
            options.add(new Selectoption('Paint', 'Paint'));
            options.add(new Selectoption('Pricing', 'Pricing'));
            options.add(new Selectoption('Profile', 'Profile'));
            options.add(new Selectoption('Quality/Warranty', 'Quality/Warranty'));
            options.add(new Selectoption('Service', 'Service'));
            options.add(new Selectoption('SKU rationalization', 'SKU rationalization'));
            options.add(new Selectoption('Surface Texture - Finish', 'Surface Texture - Finish'));
            options.add(new Selectoption('Other', 'Other'));
        } else if(topicValue == 'Miscellaneous') {
            options.add(new Selectoption('Claims', 'Claims'));
            options.add(new Selectoption('Pricing', 'Pricing'));
            options.add(new Selectoption('Service', 'Service'));
            options.add(new Selectoption('Warranty', 'Warranty'));
            options.add(new Selectoption('Other', 'Other'));
        } else if(topicValue == 'Marketing Supports') {
            options.add(new Selectoption('5-Star Support', '5-Star Support'));
            options.add(new Selectoption('Advertising (CT)', 'Advertising (CT)'));
            options.add(new Selectoption('Building Solutions', 'Building Solutions'));
            options.add(new Selectoption('Canvassing', 'Canvassing'));
            options.add(new Selectoption('Color / Design', 'Color / Design'));
            options.add(new Selectoption('Customizable Literature', 'Customizable Literature'));
            options.add(new Selectoption('Customizable Sample Case', 'Customizable Sample Case'));
            options.add(new Selectoption('Displays', 'Displays'));
            options.add(new Selectoption('Fan decks', 'Fan decks'));
            options.add(new Selectoption('Glamour brochure', 'Glamour brochure'));
            options.add(new Selectoption('Green Support', 'Green Support'));
            options.add(new Selectoption('Homeowner Literature', 'Homeowner Literature'));
            options.add(new Selectoption('Homeshow Literature', 'Homeshow Literature'));
            options.add(new Selectoption('Incentives', 'Incentives'));
            options.add(new Selectoption('Installation Support', 'Installation Support'));
            options.add(new Selectoption('Job Signs', 'Job Signs'));
            options.add(new Selectoption('Pictures', 'Pictures'));
            options.add(new Selectoption('Pitch Book', 'Pitch Book'));
            options.add(new Selectoption('Sample', 'Sample'));
            options.add(new Selectoption('Tote Bags', 'Tote Bags'));
            options.add(new Selectoption('Visualization', 'Visualization'));
            options.add(new Selectoption('Warranty', 'Warranty'));
            options.add(new Selectoption('Website', 'Website'));
        } else if(topicValue == 'Marketing Programs') {
            options.add(new Selectoption('5 Star', '5 Star'));
            options.add(new Selectoption('Advanced Training', 'Advanced Training'));
            options.add(new Selectoption('Advertising Support', 'Advertising Support'));
            options.add(new Selectoption('Apps-General', 'Apps-General'));
            options.add(new Selectoption('Architect Training', 'Architect Training'));
            options.add(new Selectoption('Award of Excellence', 'Award of Excellence'));
            options.add(new Selectoption('Building Solutions', 'Building Solutions'));
            options.add(new Selectoption('Build-It Tour', 'Build-It Tour'));
            options.add(new Selectoption('BusinessConnections', 'BusinessConnections'));
            options.add(new Selectoption('BusinessDividends', 'BusinessDividends'));
            options.add(new Selectoption('ColorCoaach', 'ColorCoaach'));
            options.add(new Selectoption('ColorView', 'ColorView'));
            options.add(new Selectoption('Contractor Locator', 'Contractor Locator'));
            options.add(new Selectoption('Cost', 'Cost'));
            options.add(new Selectoption('CurbAppeal', 'CurbAppeal'));
            options.add(new Selectoption('Direct Mail', 'Direct Mail'));
            options.add(new Selectoption('Distributor issues', 'Distributor issues'));
            options.add(new Selectoption('Green / Sustainability', 'Green / Sustainability'));
            options.add(new Selectoption('Lead Generation', 'Lead Generation'));
            options.add(new Selectoption('Mailing / Newsletters', 'Mailing / Newsletters'));
            options.add(new Selectoption('Marketing Training', 'Marketing Training'));
            options.add(new Selectoption('MasterCraftsman', 'MasterCraftsman'));
            options.add(new Selectoption('proDialogs', 'proDialogs'));
            options.add(new Selectoption('Promotions', 'Promotions'));
            options.add(new Selectoption('Rewards & Differentiation', 'Rewards & Differentiation'));
            options.add(new Selectoption('Sales Training', 'Sales Training'));
            options.add(new Selectoption('Show Me The Money', 'Show Me The Money'));
            options.add(new Selectoption('TradeTalk', 'TradeTalk'));
            options.add(new Selectoption('Training', 'Training'));
            options.add(new Selectoption('VSI', 'VSI'));
            options.add(new Selectoption('Website', 'Website'));
        }
        return options;
    }
    
    public void doSort() {
        isSorting = true;
        doSearch();
        isSorting = false;
    }
    
    public PageReference doSearch()
    {
        String sortFullExp = sortExpression  + ' ' + sortDirection;
        resultList = new List<WrapperResult>();
        resultContentVersionList = new List<ContentVersion>();
        resultContentList = new List<resultContent>();
        List<String> vocSearch = new List<String>();
        System.debug('wrapperQueryList:::'+wrapperQueryList);
        String keywordStr;
        searchExpression = 'Select v.What__c, v.Topic__c, v.Insight__c, v.Competitor_Topic__c, v.Product_Line__c, v.Product_Family__c, v.Priority__c, v.OwnerId, v.Note__c, v.Name, v.Market_Segment__c, v.Market_Family__c, v.Line_of_Business__c, v.Id, v.Category__c, v.Brand__c, v.CreatedDate, v.WTU_Note__c, v.ProDialogue_Input__c, v.Online_Form__c, v.WTU_Note__r.Name, v.ProDialogue_Input__r.Name,v.ProDialogue_Input__r.Market_Segment__c,v.ProDialogue_Input__r.Segment_Type__c,v.ProDialogue_Input__r.Additional_Info_Source__c,v.ProDialogue_Input__r.Information_Source__c,v.ProDialogue_Input__r.Sales_Role__c,v.ProDialogue_Input__r.Region__c,v.ProDialogue_Input__r.Country__c,v.ProDialogue_Input__r.City_State__c, v.Online_Form__r.Name, v.Created_Date__c, v.Account__c, v.Account__r.Name, v.Case_Number__c, v.Subject__c From VOC_Data_Entry__c v';
        if(wrapperQueryList.get(0).fieldToQuery == 'All') 
        {
            if(wrapperQueryList.get(0).searchValue == '' || wrapperQueryList.get(0).searchValue == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the search string.'));
                return null;
            }
            if(wrapperQueryList.get(0).searchValue.length() <= 1)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Search term must be longer than one character.'));
                return null;
            }
            else
            {
                String srchValue1 = (wrapperQueryList.get(0).searchValue).trim();
                keywordStr = srchValue1;
                //srchValue1 = srchValue1 + '*';
                System.debug('srchValue1:::'+srchValue1);
                //List<List<SObject>> searchResultList = [FIND :srchValue1 IN ALL FIELDS RETURNING VOC_Data_Entry__c (What__c, Topic__c, Product_Line__c, Product_Family__c, Priority__c, OwnerId, Note__c, Name, Market_Segment__c, Market_Family__c, Line_of_Business__c, Id, Category__c, Brand__c, CreatedDate, WTU_Note__c, ProDialogue_Input__c, Online_Form__c, WTU_Note__r.Name, ProDialogue_Input__r.Name, Online_Form__r.Name, Created_Date__c  order by Name)];
                //System.debug('search query: '+'FIND :srchValue1 IN ALL FIELDS RETURNING VOC_Data_Entry__c (What__c, Topic__c, Product_Line__c, Product_Family__c, Priority__c, OwnerId, Note__c, Name, Market_Segment__c, Market_Family__c, Line_of_Business__c, Id, Category__c, Brand__c, CreatedDate, WTU_Note__c, ProDialogue_Input__c, Online_Form__c, WTU_Note__r.Name, ProDialogue_Input__r.Name, Online_Form__r.Name, Created_Date__c order by ' + sortFullExp + ')');
                /*List<List<SObject>> searchResultList;
                if(isSorting) {
                    searchResultList = Search.query('FIND :srchValue1 IN ALL FIELDS RETURNING VOC_Data_Entry__c (ProDialogue_Input__r.Sales_Role__c,ProDialogue_Input__r.Information_Source__c,ProDialogue_Input__r.Additional_Info_Source__c,ProDialogue_Input__r.Region__c,ProDialogue_Input__r.City_State__c,ProDialogue_Input__r.Segment_Type__c,ProDialogue_Input__r.Market_Segment__c,ProDialogue_Input__r.Country__c,What__c, Insight__c, Competitor_Topic__c, Topic__c, Product_Line__c, Product_Family__c, Priority__c, OwnerId, Note__c, Name, Market_Segment__c, Market_Family__c, Line_of_Business__c, Id, Category__c, Brand__c, CreatedDate, WTU_Note__c, ProDialogue_Input__c, Online_Form__c, WTU_Note__r.Name, ProDialogue_Input__r.Name, Online_Form__r.Name, Created_Date__c, Account__c, Account__r.Name, Case_Number__c, Subject__c order by ' + sortFullExp + ' NULLS LAST)');
                } else {
                    searchResultList = Search.query('FIND :srchValue1 IN ALL FIELDS RETURNING VOC_Data_Entry__c (ProDialogue_Input__r.Sales_Role__c,ProDialogue_Input__r.Information_Source__c,ProDialogue_Input__r.Additional_Info_Source__c,ProDialogue_Input__r.Region__c,ProDialogue_Input__r.City_State__c,ProDialogue_Input__r.Segment_Type__c,ProDialogue_Input__r.Market_Segment__c,ProDialogue_Input__r.Country__c,What__c, Insight__c, Competitor_Topic__c, Topic__c, Product_Line__c, Product_Family__c, Priority__c, OwnerId, Note__c, Name, Market_Segment__c, Market_Family__c, Line_of_Business__c, Id, Category__c, Brand__c, CreatedDate, WTU_Note__c, ProDialogue_Input__c, Online_Form__c, WTU_Note__r.Name, ProDialogue_Input__r.Name, Online_Form__r.Name, Created_Date__c, Account__c, Account__r.Name, Case_Number__c, Subject__c order by ' + sortFullExp + ')');
                }
                List<VOC_Data_Entry__c> vocList = searchResultList.get(0);
                System.debug('vocList :::'+vocList.size());
                String leadId;
                String acId;
                String conId;
                String evId;
                
                vocSearch.add('Name like \'%'+ srchValue1 +'%\'');
                vocSearch.add('Topic__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('Brand__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('Sub_Brand__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('Insight__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('Category__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('proDialogue_Input__r.City_State__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('proDialogue_Input__r.Information_Source__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('proDialogue_Input__r.Additional_Info_Source__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('proDialogue_Input__r.Sales_Role__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('proDialogue_Input__r.Region__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('Market_Segment__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('proDialogue_Input__r.Segment_Type__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('Insight__c like \'%'+ srchValue1 +'%\'');
                vocSearch.add('Account__r.Name like \'%'+ srchValue1 +'%\'');
                
                for(integer i=0;i<vocSearch.size();i++)
                {
                    if(i==0)
                        searchExpression = searchExpression +  ' where (' + vocSearch.get(i) +')';
                    else if(i > 0)
                        searchExpression = searchExpression +' OR ('+ vocSearch.get(i) +')';
                }
                if(isSorting) {
                    searchExpression = searchExpression + ' order by ' + sortFullExp + ' NULLS LAST';
                } else {
                    searchExpression = searchExpression + ' order by ' + sortFullExp;
                }
                system.debug('>>>>vocSearch>>>>'+vocSearch);
                system.debug('>>>>searchExpression>>>>'+searchExpression);
                List<VOC_Data_Entry__c> vocList = Database.query(searchExpression);
                
                Set<ID> vocIDs = new Set<ID>();
                for(VOC_Data_Entry__c v : vocList){
                    WrapperResult w = new WrapperResult();
                    w.voc = v;
                    w.isSelected = false;
                    w.rowIndexResult = resultList.size();
                    vocIDs.add(v.proDialogue_Input__c);
                    resultList.add(w);
                }
                if(vocIDs.size()>0){
                    Map<ID,ProDialogue_Input__c> vocInputMap = new Map<ID,ProDialogue_Input__c>([SELECT ID,City_State__c,(SELECT Account__c,Account__r.Name,Contact__c,Contact__r.name,Lead__c,Lead__r.Name from ProDialogue_Input_Attendees__r),(SELECT ID From attachments) FROM ProDialogue_Input__c WHERE ID IN :vocIDs]);
                    for(WrapperResult v : resultList){
                        if(vocInputMap.size()>0 && vocInputMap.containsKey(v.voc.proDialogue_Input__c) && vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.size()>0){
                            if(vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Account__r.Name!=null){
                                v.attendLink = vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Account__r.Name;
                            } else if(vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Contact__r.Name!=null){
                                v.attendLink = vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Contact__r.Name;
                            } else if(vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Lead__r.Name!=null){
                                v.attendLink = vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Lead__r.Name;
                            }
                        }
                        if(vocInputMap.size()>0 && vocInputMap.containsKey(v.voc.proDialogue_Input__c) && vocInputMap.get(v.voc.proDialogue_Input__c).attachments.size()>0){
                            v.attachmentURL = System.URL.getSalesforceBaseURL().toExternalForm()+'/'+vocInputMap.get(v.voc.proDialogue_Input__c).attachments.get(0).Id;
                        }
                    }
                }
            }
        }
        else
        {
            Map<String,String> searchFieldAPINameMap = new Map<String,String>();
            searchFieldAPINameMap.put('Brand','Brand__c');
            searchFieldAPINameMap.put('Category','Category__c');
            searchFieldAPINameMap.put('City/State','proDialogue_Input__r.City_State__c');
            searchFieldAPINameMap.put('Role','proDialogue_Input__r.Sales_Role__c');
            searchFieldAPINameMap.put('Region','proDialogue_Input__r.Region__c');
            searchFieldAPINameMap.put('Market Segment','Market_Segment__c');
            searchFieldAPINameMap.put('Insight','Insight__c');
            searchFieldAPINameMap.put('Competitor','Competitor_Topic__c');
            searchFieldAPINameMap.put('Segment Type','proDialogue_Input__r.Segment_Type__c');
            
            
            Map<String,String> searchFieldValMap = new Map<String,String>();
            searchFieldValMap.put('Brand',c.Brand__c);
            searchFieldValMap.put('Category',c.Category__c);
            searchFieldValMap.put('City/State',prodialogueinput.City_State__c);
            searchFieldValMap.put('Role',prodialogueinput.Sales_Role__c);
            searchFieldValMap.put('Region',prodialogueinput.Region__c);
            searchFieldValMap.put('Market Segment',c.Market_Segment__c);
            searchFieldValMap.put('Insight',c.Insight__c);
            searchFieldValMap.put('Competitor',c.Competitor_Topic__c);
            
            
            for(WrapperQuery w: wrapperQueryList){
                if(w.fieldToQuery != 'Meeting Date') {
                    String strVal;
                    Boolean addSearch = false;
                    if(w.fieldToQuery == 'Brand' || w.fieldToQuery == 'Category' || w.fieldToQuery == 'City/State' || w.fieldToQuery == 'Role' || w.fieldToQuery == 'Region' 
                        || w.fieldToQuery == 'Market Segment' || w.fieldToQuery == 'Insight' || w.fieldToQuery == 'Competitor'){
                        strVal = searchFieldValMap.get(w.fieldToQuery);
                        addSearch = true;
                    }else if(w.fieldToQuery == 'Segment Type'){
                        addSearch = true;
                        strVal = w.searchValue;
                    }
                    if(addSearch){
                        addSearch = addErrorFlag(strVal);
                        if(addSearch){
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,w.fieldToQuery +' is required.'));
                            return null;
                        }else{
                            vocSearch = vocSearchList(searchFieldAPINameMap.get(w.fieldToQuery), strVal, w.selectedOperator, vocSearch, false);
                        }
                    }
                }else{
                    if((c.Created_Date__c == null)){
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Date is required.'));
                        return null;
                    }
                    String tempDate = String.valueof(c.Created_Date__c).replace('00:00:00','');
                    vocSearch = vocSearchList('proDialogue_Input__r.Meeting_Date__c', tempDate, w.selectedOperator, vocSearch, true);
                }
            }
            for(integer i=0;i<vocSearch.size();i++) {
                if(i==0)
                    searchExpression = searchExpression +  ' where (' + vocSearch.get(i) +')';
                else if(i > 0 && wrapperQueryList.get(i).selectedLogicalOperator == 'AND')
                    searchExpression = searchExpression +' AND ('+ vocSearch.get(i) +')';
                else if(i > 0 && wrapperQueryList.get(i).selectedLogicalOperator == 'OR')
                    searchExpression = searchExpression +' AND ('+ vocSearch.get(i) +')';
            } 
            List<VOC_Data_Entry__c> tempList = new List<VOC_Data_Entry__c>();
            if(isSorting) {
                searchExpression = searchExpression + ' order by ' + sortFullExp + ' NULLS LAST';
            } else {
                searchExpression = searchExpression + ' order by ' + sortFullExp;
            }
            System.debug('searchExpression:::'+searchExpression);
            tempList = Database.query(searchExpression);
            Set<ID> vocIDs = new Set<ID>();
            for(VOC_Data_Entry__c v: tempList){
                WrapperResult r = new WrapperResult();
                r.voc = v;
                vocIDs.add(v.ProDialogue_Input__c);
                r.rowIndexResult = resultList.size();
                r.isSelected = false;
                resultList.add(r);
            }
            if(vocIDs.size()>0){
                Map<ID,ProDialogue_Input__c> vocInputMap = new Map<ID,ProDialogue_Input__c>([SELECT ID,City_State__c,(SELECT Account__c,Account__r.Name,Contact__c,Contact__r.name,Lead__c,Lead__r.Name from ProDialogue_Input_Attendees__r),(SELECT ID From attachments) FROM ProDialogue_Input__c WHERE ID IN :vocIDs]);
                for(WrapperResult v : resultList){
                    if(vocInputMap.size()>0 && vocInputMap.containsKey(v.voc.proDialogue_Input__c) && vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.size()>0){
                        if(vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Account__r.Name!=null){
                            v.attendLink = vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Account__r.Name;
                        } else if(vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Contact__r.Name!=null){
                            v.attendLink = vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Contact__r.Name;
                        } else if(vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Lead__r.Name!=null){
                            v.attendLink = vocInputMap.get(v.voc.proDialogue_Input__c).ProDialogue_Input_Attendees__r.get(0).Lead__r.Name;
                        }
                    }
                    if(vocInputMap.size()>0 && vocInputMap.containsKey(v.voc.proDialogue_Input__c) && vocInputMap.get(v.voc.proDialogue_Input__c).attachments.size()>0){
                        v.attachmentURL = System.URL.getSalesforceBaseURL().toExternalForm()+'/'+vocInputMap.get(v.voc.proDialogue_Input__c).attachments.get(0).Id;
                    }
                }
            }
        }
        //wrapperQueryList = new List<WrapperQuery>();
        //Search Documents
        
        if(docSearch)             
        {
            Map<String, String> mapDocURL = new Map<String, String>();
            Set<String> matchingDocNameSet = new Set<String>();
            Transient String contentVersionQuery = 'Select c.Id, c.Title, c.VersionData, c.Description, c.VersionNumber From ContentVersion c Where IsLatest = true AND c.FileType = \'TEXT\'';
            contentVersionQuery = contentVersionQuery + 'ORDER BY LastModifiedDate DESC' + ' ' + 'LIMIT 50'; //Limit                      
            Transient List<ContentVersion> contentVersionList = Database.query(contentVersionQuery);
            Transient String sText = keywordStr;
            sText = sText.toUpperCase();
            for(ContentVersion cv : contentVersionList) {
                matchingDocNameSet.add(cv.Title);
            }
            Transient List<ContentVersion> contentVersionList2 = Database.query('Select c.Id, c.Title, c.Description, c.VersionData, c.VersionNumber From ContentVersion c Where c.Title in :matchingDocNameSet AND c.FileType != \'TEXT\'');
            for(ContentVersion cv : contentVersionList2) {
                mapDocURL.put(cv.Title, cv.Id);
            }
            
            for(ContentVersion cv : contentVersionList){
                if(cv.VersionData != null) {
                
                   Transient String contentData = cv.VersionData.toString();
                   Transient String matchingSentence;
                   Transient String matchingSentenceItalic = keywordStr;
                    contentData = contentData.toUpperCase();
                    
               
                    if(contentData.indexOf(sText) > -1) {
                        
                        resultContent rc = new resultContent();
                        rc.cnt = cv;
                        matchingSentence =  contentdata.substring(contentData.indexOf(sText), contentData.indexOf(sText)+25+sText.length());
                        matchingSentence = matchingSentence.replace(sText, matchingSentenceItalic);
                        rc.matchingSent = matchingSentence;
                        if(mapDocURL.containsKey(cv.Title))
                            rc.contentURL = mapDocURL.get(cv.Title);
                        else
                            rc.contentURL = cv.Id;
                        resultContentList.add(rc);
                    }
                }             
            }            
        }   
         
        //End Search Doc uments
        
        KONASearch(keywordStr);
        
        return null;
        
    }  
      
    public class resultContent
    {
        public Transient ContentVersion cnt {get;set;}
        public Transient String matchingSent {get;set;}
        public Transient String contentURL {get;set;}
    }
    
    public PageReference saveAll()
    {
        List<VOC_Data_Entry__c> vocListToUpdate = new List<VOC_Data_Entry__c>();
        for(WrapperResult ws : resultList)
        {   
            /*if(ws.voc.Source__c == '' || ws.voc.Source__c == null)
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Required Field Missing: Source.'));
                return null;
            }
            vocListToUpdate.add(ws.voc);
        }
        try
        {
            if(vocListToUpdate.size() > 0)
            {
                update vocListToUpdate;
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Saved.'));
                system.debug('vocListToUpdate:::::'+vocListToUpdate);
            }
            else
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Info,'No records to Save.'));
                return null;
            }
        }
        catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
            return null;
        }
        //ApexPages.addMessage(new ApexPages.message(ApexPages.severity.CONFIRM,'Saved!'));
        return null;
    }
    
    public void addFilter()
    { 
        try
        {
            System.debug('wrapperQueryList.size:::'+wrapperQueryList.size());
            WrapperQuery uw = new WrapperQuery();
            uw.rowIndexQuery = wrapperQueryList.size();
            uw.fieldToQuery = 'Account';
            wrapperQueryList.add(uw);   
        }
        catch(System.Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void removeFilter()
    {
        for(integer i = 0; i < wrapperQueryList.size(); i++)
        {
            WrapperQuery uw = wrapperQueryList.get(i);
            System.debug('index::>>'+rIndexQuery);
            if(uw.rowIndexQuery == rIndexQuery)
            {
                wrapperQueryListToDelete.add(wrapperQueryList.get(i));
                wrapperQueryList.remove(i);
                break;
            }
        }
    }
    
    public void selectAll()
    {
        if(resultList != null)
        {
            for(WrapperResult w : resultList)
            {
                w.isSelected = true;
            }
        }
    }
    
    public PageReference deleteRecords1()
    {
        List<VOC_Data_Entry__c> vocListToDelete = new List<VOC_Data_Entry__c>();
        for(Integer i=0; i<resultList.size() ; i++)
        {
            WrapperResult w = resultList.get(i);
            if(w.isSelected)
            {
                resultList.remove(i);
                vocListToDelete.add(w.voc);
            }
        }
        if(vocListToDelete.size() > 0)
        {
            try{
                delete vocListToDelete;
            }catch(Exception e){
                ApexPages.addMessage(new ApexPages.message(ApexPages.severity.Error,e.getMessage()));
                return null;
            }
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Select at least one record to delete.'));
            return null;
        }
        return null;
    }
    
    //SETS THE SORT DIRECTION FOR THE SORTING COLUMN
    public String sortExpression{
        get {
            return sortExp;
        }
        set {
            //if the column is clicked on then switch between Ascending and Descending modes
            if (value == sortExp)
                sortDirection = (sortDirection == 'DESC')? 'ASC' : 'DESC';
            else
                sortDirection = 'ASC';
                sortExp = value;
        }
    }
    
    //method returning sort direction value i.e ASC
    public String getSortDirection(){
        //if not column is selected 
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }
    
    public void KONASearch(string SearchQuery) {
          try{
            if(SearchQuery != null && SearchQuery != ''){
                
                
                PageReference pageRef = new PageReference('/apex/konads__Search?q=' + SearchQuery + '&hits=20&highlight=1&offset=0&konaAPI=json');
                
                SearchJSON = pageRef.getContent().toString();
                
                //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,SearchJSON ));  
                
                Map<String, Object> o = (Map<String, Object>)JSON.deserializeUntyped(SearchJSON);
        
                SearchResults = new List<KonaRecord>();
        
                for (Object mpo : (List<Object>)o.get('documents')) {
                
                    Map<String, Object> mp = (Map<String, Object>)mpo;
                    KonaRecord kr = new KonaRecord();
                    kr.RecordId = (String)mp.get('id');
                    
                    if(kr.RecordId != null){
                        List<string> lst = string.valueof(kr.RecordId).split('_');
                        kr.SFId = lst.get(lst.size() - 1 );
                    }
                    
                    kr.Num = String.valueOf((Integer)mp.get('hit_num'));
        
                    Map<String, Object> mo2 = (Map<String, Object>)mp.get('fields');
        
                    kr.Table = (String)mo2.get('table');
                    kr.Title = (String)mo2.get('title_sort');
                    
                    string strTeaser = (String)mo2.get('text');
                 
                    if(SearchQuery != null && SearchQuery != '' && strTeaser != null && strTeaser != ''){
                        string replaceToken = '(?i)'+SearchQuery ; 
                           
                       strTeaser  = strTeaser.replaceAll(replaceToken , '<label style="background-color:yellow">' + SearchQuery + '</label>');
                       //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR , '================')); return null;
                    }
                    
                    kr.Teaser = strTeaser ;
                    
                    SearchResults.add(kr);
                    
                    if(SearchResults.size() >= 1000){
                        break;
                    }
                }
            } 
        }
        catch(Exception ex){
            //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()));  
        }
         
    }
    
    public class KonaRecord {
        public String RecordId { get; set; }
        public String SFId { get; set; }
        public String Num { get; set; }
        public String Table { get; set; }
        public String Title { get; set; }
        public String Teaser{ get; set; }
    }
    
    public Boolean addErrorFlag(String strVal){
        Boolean errorFlag = false;
        if(strVal==null || strVal==''){
            errorFlag = true;
        }
        return errorFlag;
    }
    
    public List<String> vocSearchList(String compField, String strVal, String selectedOperator, List<String> vocSearch, Boolean dateType){
        if(selectedOperator == 'equals'){
            if(!dateType){
                vocSearch.add(compField+' = \''+ strVal +'\'');
            }else{
                vocSearch.add(compField+' = '+ strVal);
            }
        }else if(selectedOperator == 'does not equal'){
            if(!dateType){
                vocSearch.add(compField+' != \''+ strVal +'\'');
            }else{
                vocSearch.add(compField+' != '+ strVal);
            }
        }else if(selectedOperator == 'begins with'){
            strVal = strVal + '%';  
            vocSearch.add(compField+' != \''+ strVal +'\'');
        }else if(selectedOperator == 'does not begin with'){
            strVal = strVal + '%';
            vocSearch.add('NOT('+compField+' like \''+ strVal +'\')');
        }else if(selectedOperator == 'contains'){
            strVal = '%' + strVal + '%';
            vocSearch.add(compField+' like \''+ strVal +'\'');
        }else if(selectedOperator == 'does not contain'){
            strVal = '%' + strVal + '%';
            vocSearch.add('NOT('+compField+' like \''+ strVal +'\')');
        }else if(selectedOperator == 'is greater than'){  
            vocSearch.add(compField + ' > '+ strVal);
        }else if(selectedOperator == 'is greater than or equal to'){
            vocSearch.add(compField + ' >= '+ strVal);
        }else if(selectedOperator == 'is less than'){
            vocSearch.add(compField + ' < '+ strVal);
        }else if(selectedOperator == 'is less than or equal to'){
            vocSearch.add(compField + ' <= '+ strVal);
        }
        return vocSearch;
    }
    */
}