@istest
//@istest(seeAllData = true)
class testSearchPageController
{

    static testmethod void test1()
    {   //START Commneted by Kritika Bhati on 31/7/2017 for S-490568
      
        //End S-490568
        Account a = new Account();
        a.Name = 'insulation';
        a.BillingCity = 'insulation';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        Lead l = new Lead();
        l.FirstName = 'insulation';
        l.LastName = 'class';
        l.Email = 'insulation.class@gmail.com';
        l.Company = 'testCompany';
        insert l;
        
        Contact c = new Contact();
       // c.AccountId = a.Id;
        c.Email = 'insulation.class@testuser.com';
        c.FirstName = 'testContact';
        c.LastName = 'classContact';
        c.MailingCountry='ggg';
        c.MailingStreet = 'Test1';
        c.MailingCity = 'Newyork';
        c.MailingState = 'rajasthan';
        c.otherphone='12345';
        c.Phone = '1234567890';
        c.MailingPostalCode = '987654321a';
        insert c;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Audience__c = 'insulation Audience';
        voc.Information_Source__c = 'insulation Source';
        voc.Audience__c = 'insulation Audience';
        voc.Category__c = 'insulation Category';
        voc.Country__c = 'insulation Geo';
        voc.Sub_Category__c= 'insulation Category';
        voc.City__c = 'insulation City';
        voc.State__c = 'insulation State';
        voc.City_State__c = 'insulatoin city state';
        voc.Account__c = a.Id;
        voc.Lead__c = l.Id;
        voc.Contact__c = c.Id;
        //voc.Event__c = e.Id; // Commneted by Kritika Bhati on 31/7/2017 for S-490568
        voc.Lead__c = l.Id;
        //voc.Priority__c = 'High';
        //voc.Created_Date__c = System.today();
        insert voc;
        
        string aid = String.valueOf(a.id).substring(0,15);
        ApexPages.currentPage().getParameters().put('pId',aid);
        ApexPages.currentPage().getParameters().put('pName','insulation');
        searchpagecontroller12 spc1 = new searchpagecontroller12(); 
        spc1.getFieldToQueryOptions();
        spc1.getLogicalOperatorOptions();
        spc1.getOperatorOptions();
        spc1.getDateOperatorOptions();  
        spc1.getCategoryOptions();      
        spc1.advanceSearch();
        spc1.exportToExcel();
        spc1.cancelCustom();
        spc1.simpleSearch();
        spc1.docSearch = true;
        spc1.c = voc;
        spc1.wrapperQueryList.get(0).searchValue = 'insulation';
        Id [] fixedSearchResults = new Id[]{};
        fixedSearchResults.add(voc.Id);
        Test.setFixedSearchResults(fixedSearchResults);             
        spc1.doSearch();
        
        spc1.docSearch = false;
        spc1.wrapperQueryList.get(0).fieldToQuery = 'Source';
        spc1.wrapperQueryList.get(0).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(0).selectedOperator = 'equals';
        spc1.addFilter();
        spc1.wrapperQueryList.get(1).fieldToQuery = 'Audience'; 
        spc1.wrapperQueryList.get(1).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(1).selectedOperator = 'equals';       
        spc1.addFilter();
        spc1.wrapperQueryList.get(2).fieldToQuery = 'Category'; 
        spc1.wrapperQueryList.get(2).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(2).selectedOperator = 'equals';       
        spc1.addFilter();
        spc1.wrapperQueryList.get(3).fieldToQuery = 'SubCategory';  
        spc1.wrapperQueryList.get(3).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(3).selectedOperator = 'equals';       
        spc1.addFilter();
        spc1.wrapperQueryList.get(4).fieldToQuery = 'Geo';  
        spc1.wrapperQueryList.get(4).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(4).selectedOperator = 'equals';
        spc1.addFilter();
        spc1.wrapperQueryList.get(5).fieldToQuery = 'City'; 
        spc1.wrapperQueryList.get(5).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(5).selectedOperator = 'equals';   
        spc1.addFilter();
        spc1.wrapperQueryList.get(6).fieldToQuery = 'State';    
        spc1.wrapperQueryList.get(6).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(6).selectedOperator = 'equals';
        spc1.addFilter();
        spc1.wrapperQueryList.get(7).fieldToQuery = 'Account';  
        spc1.wrapperQueryList.get(7).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(7).selectedOperator = 'equals';   
        spc1.addFilter();
        spc1.wrapperQueryList.get(8).fieldToQuery = 'Contact';  
        spc1.wrapperQueryList.get(8).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(8).selectedOperator = 'equals';           
        spc1.addFilter();
        spc1.wrapperQueryList.get(9).fieldToQuery = 'Event';    
        spc1.wrapperQueryList.get(9).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(9).selectedOperator = 'equals';           
        spc1.addFilter();
        spc1.wrapperQueryList.get(10).fieldToQuery = 'Subject';  
        spc1.wrapperQueryList.get(10).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(10).selectedOperator = 'equals';   
        spc1.addFilter();
        spc1.wrapperQueryList.get(11).fieldToQuery = 'Summary'; 
        spc1.wrapperQueryList.get(11).searchValue = 'insulation';     
        spc1.wrapperQueryList.get(11).selectedOperator = 'equals';          
        spc1.addFilter();
        spc1.wrapperQueryList.get(12).fieldToQuery = 'Lead';    
        spc1.wrapperQueryList.get(12).searchValue = 'insulation';     
        spc1.wrapperQueryList.get(12).selectedOperator = 'equals';
        spc1.addFilter();
        spc1.wrapperQueryList.get(13).fieldToQuery = 'Priority';    
        spc1.wrapperQueryList.get(13).searchValue = 'High';     
        spc1.wrapperQueryList.get(13).selectedOperator = 'equals';                                  
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(0).selectedOperator = 'does not equal';        
        spc1.wrapperQueryList.get(1).selectedOperator = 'does not equal';       
        spc1.wrapperQueryList.get(2).selectedOperator = 'does not equal';       
        spc1.wrapperQueryList.get(3).selectedOperator = 'does not equal'; 
        spc1.wrapperQueryList.get(4).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(5).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(6).selectedOperator = 'does not equal';           
        spc1.wrapperQueryList.get(7).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(8).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(9).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(10).selectedOperator = 'does not equal';                  
        spc1.wrapperQueryList.get(11).selectedOperator = 'does not equal';          
        spc1.wrapperQueryList.get(12).selectedOperator = 'does not equal';                  
        spc1.wrapperQueryList.get(13).selectedOperator = 'does not equal';                  
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(6).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(7).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(8).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(9).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(10).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(11).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(12).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(13).selectedOperator = 'begins with';
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'does not begin with';          
        spc1.wrapperQueryList.get(7).selectedOperator = 'does not begin with';          
        spc1.wrapperQueryList.get(8).selectedOperator = 'does not begin with';          
        spc1.wrapperQueryList.get(9).selectedOperator = 'does not begin with';          
        spc1.wrapperQueryList.get(10).selectedOperator = 'does not begin with';         
        spc1.wrapperQueryList.get(11).selectedOperator = 'does not begin with';         
        spc1.wrapperQueryList.get(12).selectedOperator = 'does not begin with';         
        spc1.wrapperQueryList.get(13).selectedOperator = 'does not begin with';         
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'ends with';
        spc1.wrapperQueryList.get(7).selectedOperator = 'ends with';
        spc1.wrapperQueryList.get(8).selectedOperator = 'ends with';
        spc1.wrapperQueryList.get(9).selectedOperator = 'ends with';
        spc1.wrapperQueryList.get(10).selectedOperator ='ends with';
        spc1.wrapperQueryList.get(11).selectedOperator ='ends with';
        spc1.wrapperQueryList.get(12).selectedOperator ='ends with';
        spc1.wrapperQueryList.get(13).selectedOperator ='ends with';
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'does not end with';
        spc1.wrapperQueryList.get(7).selectedOperator = 'does not end with';
        spc1.wrapperQueryList.get(8).selectedOperator = 'does not end with';
        spc1.wrapperQueryList.get(9).selectedOperator = 'does not end with';
        spc1.wrapperQueryList.get(10).selectedOperator ='does not end with';
        spc1.wrapperQueryList.get(11).selectedOperator ='does not end with';
        spc1.wrapperQueryList.get(12).selectedOperator ='does not end with';
        spc1.wrapperQueryList.get(13).selectedOperator ='does not end with';
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'contains';
        spc1.wrapperQueryList.get(7).selectedOperator = 'contains';
        spc1.wrapperQueryList.get(8).selectedOperator = 'contains';
        spc1.wrapperQueryList.get(9).selectedOperator = 'contains';
        spc1.wrapperQueryList.get(10).selectedOperator ='contains';
        spc1.wrapperQueryList.get(11).selectedOperator ='contains';
        spc1.wrapperQueryList.get(12).selectedOperator ='contains';
        spc1.wrapperQueryList.get(13).selectedOperator ='contains';
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'does not contain';
        spc1.wrapperQueryList.get(7).selectedOperator = 'does not contain';
        spc1.wrapperQueryList.get(8).selectedOperator = 'does not contain';
        spc1.wrapperQueryList.get(9).selectedOperator = 'does not contain';
        spc1.wrapperQueryList.get(10).selectedOperator ='does not contain';
        spc1.wrapperQueryList.get(11).selectedOperator ='does not contain';
        spc1.wrapperQueryList.get(12).selectedOperator ='does not contain';
        spc1.wrapperQueryList.get(13).selectedOperator ='does not contain';
        spc1.doSearch();
        
        spc1.saveAll();
        spc1.selectAll();
        spc1.removeFilter();
        spc1.deleteRecords1();
                
        ApexPages.currentPage().getParameters().put('pId',l.id);
        ApexPages.currentPage().getParameters().put('pName','insulation');
        searchpagecontroller12 spc2 = new searchpagecontroller12();      
        
        ApexPages.currentPage().getParameters().put('pId',c.id);
        ApexPages.currentPage().getParameters().put('pName','insulation');
        searchpagecontroller12 spc3 = new searchpagecontroller12();      

        //ApexPages.currentPage().getParameters().put('pId',e.id);// Commneted by Kritika Bhati on 31/7/2017 for S-490568
        ApexPages.currentPage().getParameters().put('pName','insulation');
        searchpagecontroller12 spc4 = new searchpagecontroller12();
        //START : Added by Kritika Bhati for S-510717
        ApexPages.currentPage().getParameters().put('pId','a0gjsjs'); //kb
        ApexPages.currentPage().getParameters().put('pName','insulation');//kb
        searchpagecontroller12 spc5 = new searchpagecontroller12();//kb
    }
     static testmethod void test2()
    {
        Event__c e = new Event__c();
        e.City__c = 'tesCity';
        e.Country__c = 'testCountry';
        insert e;
        
        Account a = new Account();
        a.Name = 'insulation';
        a.BillingCity = 'insulation';
        a.BillingState = 'CA';
        a.Type = 'Other';
        insert a;
        
        Lead l = new Lead();
        l.FirstName = 'insulation';
        l.LastName = 'class';
        l.Email = 'insulation.class@gmail.com';
        l.Company = 'testCompany';
        insert l;
        
        Contact c = new Contact();
       // c.AccountId = a.Id;
        c.Email = 'insulation.class@testuser.com';
        c.FirstName = 'testContact';
        c.LastName = 'classContact';
        c.MailingCountry='ggg';
        c.MailingStreet = 'Test1';
        c.MailingCity = 'Newyork';
        c.MailingState = 'rajasthan';
        c.otherphone='12345';
        c.Phone = '1234567890';
        c.MailingPostalCode = '987654321a';
        insert c;
        
        ProDialogue_Input__c voc = new ProDialogue_Input__c();
        voc.Audience__c = 'insulation Audience';
        voc.Information_Source__c = 'insulation Source';
        voc.Audience__c = 'insulation Audience';
        voc.Category__c = 'insulation Category';
        voc.Country__c = 'insulation Geo';
        voc.Sub_Category__c= 'insulation Category';
        voc.City__c = 'insulation City';
        voc.State__c = 'insulation State';
        voc.City_State__c = 'insulatoin city state';
        voc.Account__c = a.Id;
        voc.Lead__c = l.Id;
        voc.Contact__c = c.Id;
        voc.Event__c = e.Id;
        voc.Lead__c = l.Id;
        //voc.Priority__c = 'High';
        //voc.Created_Date__c = System.today();
        insert voc;
        
        string aid = String.valueOf(a.id).substring(0,15);
        ApexPages.currentPage().getParameters().put('pId',aid);
        ApexPages.currentPage().getParameters().put('pName','insulation');
        searchpagecontroller12 spc1 = new searchpagecontroller12(); 
        spc1.getFieldToQueryOptions();
        spc1.getLogicalOperatorOptions();
        spc1.getOperatorOptions();
        spc1.getDateOperatorOptions();  
        spc1.getCategoryOptions();      
        spc1.advanceSearch();
        spc1.exportToExcel();
        spc1.cancelCustom();
        spc1.simpleSearch();
        spc1.docSearch = true;
        spc1.c = voc;
        //spc1.wrapperQueryList.get(0).searchValue = 'insulation';
        Id [] fixedSearchResults = new Id[]{};
        fixedSearchResults.add(voc.Id);
        Test.setFixedSearchResults(fixedSearchResults);             
        spc1.doSearch();
        
        spc1.docSearch = false;
        spc1.wrapperQueryList.get(0).fieldToQuery = 'Source';
        spc1.wrapperQueryList.get(0).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(0).selectedOperator = 'equals';
        spc1.addFilter();
        spc1.wrapperQueryList.get(1).fieldToQuery = 'Audience'; 
        spc1.wrapperQueryList.get(1).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(1).selectedOperator = 'equals';       
        spc1.addFilter();
        spc1.wrapperQueryList.get(2).fieldToQuery = 'Category'; 
        spc1.wrapperQueryList.get(2).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(2).selectedOperator = 'equals';       
        spc1.addFilter();
        spc1.wrapperQueryList.get(3).fieldToQuery = 'SubCategory';  
        spc1.wrapperQueryList.get(3).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(3).selectedOperator = 'equals';       
        spc1.addFilter();
        spc1.wrapperQueryList.get(4).fieldToQuery = 'Geo';  
        spc1.wrapperQueryList.get(4).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(4).selectedOperator = 'equals';
        spc1.addFilter();
        spc1.wrapperQueryList.get(5).fieldToQuery = 'City'; 
        spc1.wrapperQueryList.get(5).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(5).selectedOperator = 'equals';   
        spc1.addFilter();
        spc1.wrapperQueryList.get(6).fieldToQuery = 'State';    
        spc1.wrapperQueryList.get(6).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(6).selectedOperator = 'equals';
        spc1.addFilter();
        spc1.wrapperQueryList.get(7).fieldToQuery = 'Account';  
        spc1.wrapperQueryList.get(7).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(7).selectedOperator = 'equals';   
        spc1.addFilter();
        spc1.wrapperQueryList.get(8).fieldToQuery = 'Contact';  
        spc1.wrapperQueryList.get(8).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(8).selectedOperator = 'equals';           
        spc1.addFilter();
        spc1.wrapperQueryList.get(9).fieldToQuery = 'Event';    
        spc1.wrapperQueryList.get(9).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(9).selectedOperator = 'equals';           
        spc1.addFilter();
        spc1.wrapperQueryList.get(10).fieldToQuery = 'Subject';  
        spc1.wrapperQueryList.get(10).searchValue = 'insulation';      
        spc1.wrapperQueryList.get(10).selectedOperator = 'equals';   
        spc1.addFilter();
        spc1.wrapperQueryList.get(11).fieldToQuery = 'Summary'; 
        spc1.wrapperQueryList.get(11).searchValue = 'insulation';     
        spc1.wrapperQueryList.get(11).selectedOperator = 'equals';          
        spc1.addFilter();
        spc1.wrapperQueryList.get(12).fieldToQuery = 'Lead';    
        spc1.wrapperQueryList.get(12).searchValue = 'insulation';     
        spc1.wrapperQueryList.get(12).selectedOperator = 'equals';
        spc1.addFilter();
        spc1.wrapperQueryList.get(13).fieldToQuery = 'Priority';    
        spc1.wrapperQueryList.get(13).searchValue = 'High';     
        spc1.wrapperQueryList.get(13).selectedOperator = 'equals';                                  
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(0).selectedOperator = 'does not equal';        
        spc1.wrapperQueryList.get(1).selectedOperator = 'does not equal';       
        spc1.wrapperQueryList.get(2).selectedOperator = 'does not equal';       
        spc1.wrapperQueryList.get(3).selectedOperator = 'does not equal'; 
        spc1.wrapperQueryList.get(4).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(5).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(6).selectedOperator = 'does not equal';           
        spc1.wrapperQueryList.get(7).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(8).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(9).selectedOperator = 'does not equal';
        spc1.wrapperQueryList.get(10).selectedOperator = 'does not equal';                  
        spc1.wrapperQueryList.get(11).selectedOperator = 'does not equal';          
        spc1.wrapperQueryList.get(12).selectedOperator = 'does not equal';                  
        spc1.wrapperQueryList.get(13).selectedOperator = 'does not equal';                  
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(6).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(7).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(8).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(9).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(10).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(11).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(12).selectedOperator = 'begins with';
        spc1.wrapperQueryList.get(13).selectedOperator = 'begins with';
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'does not begin with';          
        spc1.wrapperQueryList.get(7).selectedOperator = 'does not begin with';          
        spc1.wrapperQueryList.get(8).selectedOperator = 'does not begin with';          
        spc1.wrapperQueryList.get(9).selectedOperator = 'does not begin with';          
        spc1.wrapperQueryList.get(10).selectedOperator = 'does not begin with';         
        spc1.wrapperQueryList.get(11).selectedOperator = 'does not begin with';         
        spc1.wrapperQueryList.get(12).selectedOperator = 'does not begin with';         
        spc1.wrapperQueryList.get(13).selectedOperator = 'does not begin with';         
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'ends with';
        spc1.wrapperQueryList.get(7).selectedOperator = 'ends with';
        spc1.wrapperQueryList.get(8).selectedOperator = 'ends with';
        spc1.wrapperQueryList.get(9).selectedOperator = 'ends with';
        spc1.wrapperQueryList.get(10).selectedOperator ='ends with';
        spc1.wrapperQueryList.get(11).selectedOperator ='ends with';
        spc1.wrapperQueryList.get(12).selectedOperator ='ends with';
        spc1.wrapperQueryList.get(13).selectedOperator ='ends with';
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'does not end with';
        spc1.wrapperQueryList.get(7).selectedOperator = 'does not end with';
        spc1.wrapperQueryList.get(8).selectedOperator = 'does not end with';
        spc1.wrapperQueryList.get(9).selectedOperator = 'does not end with';
        spc1.wrapperQueryList.get(10).selectedOperator ='does not end with';
        spc1.wrapperQueryList.get(11).selectedOperator ='does not end with';
        spc1.wrapperQueryList.get(12).selectedOperator ='does not end with';
        spc1.wrapperQueryList.get(13).selectedOperator ='does not end with';
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'contains';
        spc1.wrapperQueryList.get(7).selectedOperator = 'contains';
        spc1.wrapperQueryList.get(8).selectedOperator = 'contains';
        spc1.wrapperQueryList.get(9).selectedOperator = 'contains';
        spc1.wrapperQueryList.get(10).selectedOperator ='contains';
        spc1.wrapperQueryList.get(11).selectedOperator ='contains';
        spc1.wrapperQueryList.get(12).selectedOperator ='contains';
        spc1.wrapperQueryList.get(13).selectedOperator ='contains';
        spc1.doSearch();
        
        spc1.wrapperQueryList.get(5).selectedOperator = 'does not contain';
        spc1.wrapperQueryList.get(7).selectedOperator = 'does not contain';
        spc1.wrapperQueryList.get(8).selectedOperator = 'does not contain';
        spc1.wrapperQueryList.get(9).selectedOperator = 'does not contain';
        spc1.wrapperQueryList.get(10).selectedOperator ='does not contain';
        spc1.wrapperQueryList.get(11).selectedOperator ='does not contain';
        spc1.wrapperQueryList.get(12).selectedOperator ='does not contain';
        spc1.wrapperQueryList.get(13).selectedOperator ='does not contain';
        spc1.doSearch();
        
        spc1.saveAll();
        spc1.selectAll();
        spc1.removeFilter();
        spc1.deleteRecords1();
                
        ApexPages.currentPage().getParameters().put('pId',l.id);
        ApexPages.currentPage().getParameters().put('pName','insulation');
        searchpagecontroller12 spc2 = new searchpagecontroller12();      
        
        ApexPages.currentPage().getParameters().put('pId',c.id);
        ApexPages.currentPage().getParameters().put('pName','insulation');
        searchpagecontroller12 spc3 = new searchpagecontroller12();      

        ApexPages.currentPage().getParameters().put('pId',e.id);
        ApexPages.currentPage().getParameters().put('pName','insulation');
        searchpagecontroller12 spc4 = new searchpagecontroller12();
        ApexPages.currentPage().getParameters().put('pId','a0gjsjs'); //kb
        ApexPages.currentPage().getParameters().put('pName','insulation');//kb
        searchpagecontroller12 spc5 = new searchpagecontroller12();//kb
        searchpagecontroller12.KonaRecord obj1 = new searchpagecontroller12.KonaRecord();
        obj1.RecordId = 'Test1';
        obj1.SFId = 'Test1';
        obj1.Num = 'Test1';
        obj1.Table = 'Test1';
        obj1.Title = 'Test1';
        obj1.Teaser = 'Test1';
       // searchpagecontroller12.resultContent obj2 = new searchpagecontroller12.resultContent();
        
        
    }
    //END S-510717


}