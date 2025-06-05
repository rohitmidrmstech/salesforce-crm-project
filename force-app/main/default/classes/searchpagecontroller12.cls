//June 02, 2012: Initial Version
//Author: Mukesh Bhardwaj (Sales Optimizer)
//Search Page controller

public class searchpagecontroller12
{

// 23, 51, 105, 205 (whole method), 943, 1018

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
    public ProDialogue_Input__c c {get; set;}
    
    public Integer rIndexQuery{get;set;}
    
    public List<resultContent> resultContentList{get;set;}
    
    public List<KonaRecord> SearchResults { get; set; }
    public String SearchJSON { get; set; }
    
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
        public ProDialogue_Input__c voc {get; set;}
        public Boolean isSelected {get; set;}
        public Integer rowIndexResult {get; set;}
    }    
    String fieldName {get;set;}
    public String parentId{get;set;}
    public String parentObjectName{get;set;}
    public String parentName{get;set;}
    
    public searchpagecontroller12()
    {
        parentId = ApexPages.currentPage().getParameters().get('pid');
        parentName = ApexPages.currentPage().getParameters().get('pName');
        docSearch = true;
        resultContentList = new List<resultContent>();
        SearchResults = new List<KonaRecord>();
        SearchJSON = 'N/A';
        
        if(parentId!=null && parentId != '')
        {
            fieldName = '';
            if(parentId.startsWith('001'))
            {
                fieldName = 'Account__c';
                parentObject = 'Account';                
                parentObjectName = 'Account';
            }
            else if(parentId.startsWith('003'))
            {
                fieldName = 'Contact__c';
                parentObject = 'Contact';
                parentObjectName = 'Contact';
            }
            else if(parentId.startsWith('a0g'))
            {
                fieldName = 'Event__c';
                parentObject = 'Event__c';
                parentObjectName = 'Event';
            }
            else if(parentId.startsWith('00Q'))
            {
                fieldName = 'Lead__c';
                parentObject = 'Lead';  
                parentObjectName = 'Lead';
            }
        }
        resultList = new List<WrapperResult>();
        //Set the default Search as simple with one keyword
        isAdvanceSearch = false;
        isAdvSrc = true;
        wrapperQueryList = new List<WrapperQuery>();
        WrapperQuery wq = new WrapperQuery();
        wq.rowIndexQuery = wrapperQueryList.size();
        wrapperQueryList.add(wq);
        c = new ProDialogue_Input__c();
    }
    public void advanceSearch()
    {
        isAdvanceSearch = true;
        docSearch=false;
        wrapperQueryList = new List<WrapperQuery>();
        WrapperQuery wq = new WrapperQuery();
        wq.fieldToQuery = 'Account';
        wq.rowIndexQuery = wrapperQueryList.size();
        wrapperQueryList.add(wq);
        isAdvSrc = false;
    }
    
    public PageReference exportToExcel()
    {
        return(new PageReference('/apex/SearchResultsInExcel'));
    }
    
    public PageReference cancelCustom()
    {
        return(new PageReference('/a0l/o'));
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
        options.add(new SelectOption('Account','Account'));
        options.add(new SelectOption('Audience','Audience'));
        options.add(new SelectOption('Category','Category'));
        options.add(new SelectOption('City','City'));
        options.add(new SelectOption('Contact','Contact'));
        options.add(new SelectOption('Event','Event'));
        options.add(new SelectOption('Geo','Country'));
        options.add(new SelectOption('Lead','Lead'));
        //options.add(new SelectOption('Notes','Notes'));
        options.add(new SelectOption('Priority','Priority'));
        options.add(new SelectOption('Source','Source'));
        options.add(new SelectOption('State','State'));
        options.add(new SelectOption('SubCategory','Sub-Category'));
        //options.add(new SelectOption('Subject','Subject'));
        //options.add(new SelectOption('Summary','Summary'));
        options.add(new SelectOption('Created Date','VOC Date'));
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
            
    
    public PageReference doSearch()
    { 
     
        resultList = new List<WrapperResult>();
        resultContentVersionList = new List<ContentVersion>();
        resultContentList = new List<resultContent>();
        List<String> vocSearch = new List<String>();
        System.debug('wrapperQueryList:::'+wrapperQueryList);
        String keywordStr;
        searchExpression = 'select Id, Name, Account__c, Account__r.name, Summary__c, Contact__r.Name, Lead__c, Lead__r.Name, Event__c, Event__r.Name, Audience__c, Category__c, Priority__c, City__c, Contact__c, Meeting_Date__c, Country__c, Information_Source__c, State__c, Sub_Category__c, Notes__c from ProDialogue_Input__c ';
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
                srchValue1 = srchValue1 + '*';
                System.debug('srchValue1:::'+srchValue1);
                List<List<SObject>> searchResultList = [FIND :srchValue1 IN ALL FIELDS RETURNING ProDialogue_Input__c (Id, Account__c, Priority__c, Summary__c, Name,Account__r.name, Contact__r.Name, Lead__c, Lead__r.Name, Event__c, Event__r.Name, Audience__c, Category__c, City__c, Contact__c, Meeting_Date__c, Country__c, Information_Source__c, State__c, Sub_Category__c, Notes__c, Source_Calc__c)];
                List<ProDialogue_Input__c> vocList = searchResultList.get(0);
                 System.debug('vocList :::'+vocList.size());
                String leadId;
                String acId;
                String conId;
                String evId;
                
                for(ProDialogue_Input__c v : vocList)
                {
                    if(parentId != '' && parentId != null)
                    {
                        if(v.Lead__c != null)
                        {
                            if(String.valueOf(v.Lead__c).length() > 15)
                                leadId = String.valueOf(v.Lead__c).substring(0,15);
                            else
                                leadId = String.valueOf(v.Lead__c);
                        }
                            
                        if(v.Account__c != null)
                        {
                            if(String.valueOf(v.Account__c).length() > 15)
                                acId = String.valueOf(v.Account__c).substring(0,15);
                            else
                                acId = String.valueOf(v.Account__c);
                        }
                        
                        if(v.Contact__c != null)
                        {
                            if(String.valueOf(v.Contact__c).length() > 15)
                                conId = String.valueOf(v.Contact__c).substring(0,15);
                            else
                                conId = String.valueOf(v.Contact__c);
                        }
                        
                        if(v.Event__c != null)
                        {
                            if(String.valueOf(v.Event__c).length() > 15)
                                evId = String.valueOf(v.Event__c).substring(0,15);
                            else
                                evId = String.valueOf(v.Event__c);     
                        }
                        System.debug(acId+':::'+parentId);
                        System.debug(':::'+fieldName);
                        //if((fieldName == 'Lead' && v.Lead__c == parentId) || (fieldName == 'Account' && v.Account__c == parentId) || (fieldName == 'Contact' && v.Contact__c == parentId) || (fieldName == 'Event__c' && v.Event__c == parentId))
                        if((fieldName == 'Lead__c' && leadId == parentId) || (fieldName == 'Account__c' && acId == parentId) || (fieldName == 'Contact__c' && conId == parentId) || (fieldName == 'Event__c' && evid == parentId))
                        {
                            WrapperResult w = new WrapperResult();
                            w.voc = v;
                            w.isSelected = false;
                            w.rowIndexResult = resultList.size();
                            resultList.add(w);
                        }
                    }
                    else
                    {
                        WrapperResult w = new WrapperResult();
                        w.voc = v;
                        w.isSelected = false;
                        w.rowIndexResult = resultList.size();
                        resultList.add(w);
                    }
                }
            }
        }
        else
        {
            String temp;
            Integer counter = 0;
            for(WrapperQuery w: wrapperQueryList)
            {
                System.debug('w.fieldToQuery:::'+w.fieldToQuery);
                if(w.fieldToQuery != 'Created Date')
                {
                    
                    if(w.fieldToQuery == 'Source')
                    {  
                       if((c.Information_Source__c == null))
                       {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Source is required.'));
                            return null;
                       }
                        System.debug('In here:::'+w.fieldToQuery);
                        if(w.selectedOperator == 'equals')
                        {
                            //temp = w.searchValue;
                              temp = c.Information_Source__c;
                            vocSearch.add('Information_Source__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            //temp = w.searchValue;
                              temp = c.Information_Source__c;
                            vocSearch.add('Information_Source__c != \''+ temp +'\'');
                        }
                        
                        counter++;
                    }
                    else if(w.fieldToQuery == 'Audience')
                    {  
                        if((c.Audience__c == null))
                       {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Audience is required.'));
                            return null;
                       }
                        if(w.selectedOperator == 'equals')
                        {
                            //temp = w.searchValue;
                              temp = c.Audience__c;
                            vocSearch.add('Audience__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            //temp = w.searchValue;
                              temp = c.Audience__c;                     
                            vocSearch.add('Audience__c != \''+ temp +'\'');
                        }
                        
                        counter++;
                    }                   
                    else if(w.fieldToQuery == 'Category')
                    {
                    if((c.Category__c == null))
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Category is required.'));
                        return null;
                    }                              
                        if(w.selectedOperator == 'equals')
                        {
                            temp = c.Category__c;
                            vocSearch.add('Category__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            temp = c.Category__c;  
                            vocSearch.add('Category__c != \''+ temp +'\'');
                        }
                        
                        counter++;
                    }
                    else if(w.fieldToQuery == 'SubCategory')
                    {
                       if((c.Sub_Category__c == null))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Sub-Category is required.'));
                            return null;
                        }                 
                        if(w.selectedOperator == 'equals')
                        {
                            temp = c.Sub_Category__c;
                            vocSearch.add('Sub_Category__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            temp = c.Sub_Category__c;  
                            vocSearch.add('Sub_Category__c != \''+ temp +'\'');
                        }
                       
                        counter++;
                    }
                    
                    else if(w.fieldToQuery == 'Geo')
                    {   
                        if((c.Country__c == null))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Geography is required.'));
                            return null;
                        } 
                        if(w.selectedOperator == 'equals')
                        {
                            //temp = w.searchValue;
                              temp = c.Country__c;
                            vocSearch.add('Country__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            //temp = w.searchValue;
                              temp = c.Country__c;
                            vocSearch.add('Country__c != \''+ temp +'\'');
                        }
                        
                        counter++;
                    }
                    else if(w.fieldToQuery == 'City')
                    {   
                        if((w.searchValue == null || w.searchValue == ''))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the search string.'));
                            return null;
                        }
                        if(w.selectedOperator == 'equals')
                        {
                              temp = w.searchValue;                         
                            vocSearch.add('City__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                              temp = w.searchValue;                          
                            vocSearch.add('City__c != \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'begins with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('City__c like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not begin with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('NOT(City__c like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'ends with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('City__c like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not end with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('NOT(City__c like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'contains')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('City__c like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not contain')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('NOT(City__c like \''+ temp +'\')');
                        }
                        counter++;
                    }
                    else if(w.fieldToQuery == 'State')
                    {   
                        if((c.State__c == null))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'State is required.'));
                            return null;
                        }
                        if(w.selectedOperator == 'equals')
                        {
                            //temp = w.searchValue;
                              temp = c.State__c;
                            vocSearch.add('State__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            //temp = w.searchValue;
                              temp = c.State__c;                            
                            vocSearch.add('State__c != \''+ temp +'\'');
                        }
                        
                        counter++;
                    }
                    else if(w.fieldToQuery == 'Account')
                    {   
                       if((w.searchValue == null || w.searchValue == ''))
                       {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the search string.'));
                            return null;
                       }
                        if(w.selectedOperator == 'equals')
                        {
                            temp = w.searchValue;
                            vocSearch.add('Account__r.Name = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            temp = w.searchValue;  
                            vocSearch.add('Account__r.Name != \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'begins with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('Account__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not begin with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('NOT(Account__r.Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'ends with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('Account__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not end with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('NOT(Account__r.Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'contains')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('Account__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not contain')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('NOT(Account__r.Name like \''+ temp +'\')');
                        }
                        counter++;
                    }
                    else if(w.fieldToQuery == 'Contact')
                    {    
                        if((w.searchValue == null || w.searchValue == ''))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the search string.'));
                            return null;
                        }
                        if(w.selectedOperator == 'equals')
                        {
                            temp = w.searchValue;
                            vocSearch.add('Contact__r.Name = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            temp = w.searchValue;  
                            vocSearch.add('Contact__r.Name != \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'begins with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('Contact__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not begin with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('NOT(Contact__r.Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'ends with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('Contact__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not end with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('NOT(Contact__r.Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'contains')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('Contact__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not contain')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('NOT(Contact__r.Name like \''+ temp +'\')');
                        }
                        counter++;
                    }
                    else if(w.fieldToQuery == 'Lead')
                    {   
                        if((w.searchValue == null || w.searchValue == ''))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the search string.'));
                            return null;
                        }
                        if(w.selectedOperator == 'equals')
                        {
                            temp = w.searchValue;
                            vocSearch.add('Lead__r.Name = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            temp = w.searchValue;  
                            vocSearch.add('Lead__r.Name != \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'begins with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('Lead__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not begin with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('NOT(Lead__r.Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'ends with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('Lead__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not end with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('NOT(Lead__r.Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'contains')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('Lead__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not contain')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('NOT(Lead__r.Name like \''+ temp +'\')');
                        }
                        counter++;
                    }
                    else if(w.fieldToQuery == 'Event')
                    {   
                        if((w.searchValue == null || w.searchValue == ''))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the search string.'));
                            return null;
                        }
                        if(w.selectedOperator == 'equals')
                        {
                            temp = w.searchValue;
                            vocSearch.add('Event__r.Name = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            temp = w.searchValue;  
                            vocSearch.add('Event__r.Name != \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'begins with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('Event__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not begin with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('NOT(Event__r.Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'ends with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('Event__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not end with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('NOT(Event__r.Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'contains')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('Event__r.Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not contain')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('NOT(Event__r.Name like \''+ temp +'\')');
                        }
                        counter++;
                    }
                    else if(w.fieldToQuery == 'Subject')
                    {   
                        if((w.searchValue == null || w.searchValue == ''))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the search string.'));
                            return null;
                        }
                        if(w.selectedOperator == 'equals')
                        {
                            temp = w.searchValue;
                            vocSearch.add('Name = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            temp = w.searchValue;  
                            vocSearch.add('Name != \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'begins with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not begin with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('NOT(Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'ends with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not end with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('NOT(Name like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'contains')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('Name like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not contain')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('NOT(Name like \''+ temp +'\')');
                        }
                        counter++;
                    }
                    else if(w.fieldToQuery == 'Summary')
                    {   
                        if((w.searchValue == null || w.searchValue == ''))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter the search string.'));
                            return null;
                        }
                        if(w.selectedOperator == 'equals')
                        {
                            temp = w.searchValue;
                            vocSearch.add('Summary__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            temp = w.searchValue;  
                            vocSearch.add('Summary__c != \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'begins with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('Summary__c like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not begin with')
                        {
                            temp = w.searchValue + '%';  
                            vocSearch.add('NOT(Summary__c like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'ends with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('Summary__c like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not end with')
                        {
                            temp = '%' + w.searchValue;  
                            vocSearch.add('NOT(Summary__c like \''+ temp +'\')');
                        }
                        else if(w.selectedOperator == 'contains')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('Summary__c like \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not contain')
                        {
                            temp = '%' + w.searchValue + '%';  
                            vocSearch.add('NOT(Summary__c like \''+ temp +'\')');
                        }
                        counter++;
                    }
                    else if(w.fieldToQuery == 'Priority')
                    {   
                        if((c.Priority__c == null))
                        {
                            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Priority is required.'));
                            return null;
                        }
                        if(w.selectedOperator == 'equals')
                        {
                            //temp = w.searchValue;
                              temp = c.Priority__c;
                            vocSearch.add('Priority__c = \''+ temp +'\'');
                        }
                        else if(w.selectedOperator == 'does not equal')
                        {
                            //temp = w.searchValue;
                              temp = c.Priority__c;
                            vocSearch.add('Priority__c != \''+ temp +'\'');
                        }
                        
                        counter++;
                    }
                }
                else
                {
                    if((c.Meeting_Date__c == null))
                    {
                        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Date is required.'));
                        return null;
                    }
                    //Date tempDate = c.Meeting_Date__c;
                    String tempDate = String.valueof(c.Meeting_Date__c).replace('00:00:00','');
                    
                    System.debug('tempDate:::'+tempDate);
                    if(w.selectedOperator == 'equals')
                    {
                        //tempDate = w.searchValue;
                        vocSearch.add('Meeting_Date__c = '+ tempDate);
                    }
                    else if(w.selectedOperator == 'does not equal')
                    {
                        //tempDate = w.searchValue;  
                        vocSearch.add('Meeting_Date__c != '+ tempDate);
                    }
                    else if(w.selectedOperator == 'is greater than')
                    {
                        //tempDate = w.searchValue ;  
                        vocSearch.add('Meeting_Date__c > '+ tempDate);
                    }
                    else if(w.selectedOperator == 'is greater than or equal to')
                    {
                        //tempDate = w.searchValue ;  
                        vocSearch.add('Meeting_Date__c >= '+ tempDate);
                    }
                    else if(w.selectedOperator == 'is less than')
                    {
                        //tempDate = w.searchValue;  
                        vocSearch.add('Meeting_Date__c < '+ tempDate);
                    }
                    else if(w.selectedOperator == 'is less than or equal to')
                    {
                        //tempDate = w.searchValue;  
                        vocSearch.add('Meeting_Date__c <= '+ tempDate);
                    }
                    counter++;
                }
            }
            System.debug('counter:::'+counter);
            for(integer i=0;i<counter;i++)
            {
                if(i==0)
                    searchExpression = searchExpression +  ' where (' + vocSearch.get(i) +')';
                else if(i > 0 && wrapperQueryList.get(i).selectedLogicalOperator == 'AND')
                    searchExpression = searchExpression +' AND ('+ vocSearch.get(i) +')';
                else if(i > 0 && wrapperQueryList.get(i).selectedLogicalOperator == 'OR')
                    searchExpression = searchExpression +' AND ('+ vocSearch.get(i) +')';
            } 
            if(parentId != '' && parentId != null)
            {
                String temp1 = ' AND '+fieldName + ' = \''+ parentId + '\'';
                searchExpression = searchExpression + temp1;
            }
            List<ProDialogue_Input__c> tempList = new List<ProDialogue_Input__c>();
            string tmp = searchExpression ;
            System.debug('searchExpression:::'+searchExpression);
           // searchExpression = searchExpression + ' LIMIT 1000';
           searchExpression = searchExpression;
            tempList = Database.query(searchExpression);
            //resultList = new List<WrapperResult>();
            for(ProDialogue_Input__c v: tempList)
            {
                WrapperResult r = new WrapperResult();
                r.voc = v;
                r.rowIndexResult = resultList.size();
                r.isSelected = false;
                resultList.add(r);
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
                    
                    //Mohan - Adding Try Catch to avoid invalid UTF
                    try {
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
                    } catch (Exception ex) {}
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
    
        List<ProDialogue_Input__c> vocListToUpdate = new List<ProDialogue_Input__c>();
        for(WrapperResult ws : resultList)
        {   
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
    
        List<ProDialogue_Input__c> vocListToDelete = new List<ProDialogue_Input__c>();
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
    
    public void KONASearch(string SearchQuery) {
          try{
            if(SearchQuery != null && SearchQuery != ''){
                
                
                PageReference pageRef = new PageReference('/apex/konads__Search?q=' + SearchQuery + '&hits=1000&highlight=1&offset=0&konaAPI=json');
                
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

}