@isTest (seeAllData = false)
 public class TestshowTradeAreaMarketController
{
    public static testMethod void testmethod1()  
     {
       test.startTest();
       Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p2.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.User_Type__c = 'SPG';
        u1.IsActive = TRUE;
        u1.User_Territory_Code__c = '7100';
        u1.Region__c = 'NE';
        insert u1;
       
        
        FIPS__c f = new FIPS__c();
        f.Name = 'ttt';
        f.FIPS_Code__c = 'gere44';
        f.Country__c = 'USA';
        f.State__c = 'Alberta';
        f.County__c = 'USA';
        insert f;
        
       /* Trade_Area__c TA = new Trade_Area__c();
        TA.Name = 'ddddd';
        TA.Product_Line__c = 'FiberCement';
        TA.Trade_Area_Code__c = 'sdfwt3334';
        insert TA;*/
        
       /* Trade_Area_FIPS__c TAF = new Trade_Area_FIPS__c();
        //TAF.Name = 'fwse';
        TAF.Ext_Id__c = 'dwwww';
        TAF.FIPS__c = f.id;
        //TAF.Trade_Area__c = TA.id;
        insert TAF;*/
        
        Product_Line__c p = new Product_Line__c();
        p.name = 'FiberCement';
        p.UOM__c = 'Dollars';
        p.Is_Used_For_Planning__c = TRUE;
        p.Code__c = 'tte333';
        insert p;     
        
        
        //ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'BPCS Bill-To (Bufftech)'].ID;
        Account a = new Account();
        a.Name = 'Test1';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        a.Status__c = 'Active';
        a.Currency__c = 'USD';
        //a.RecordTypeID = RTID;
        a.Product_Line__c = 'FiberCement';
        a.Product_Line_Lookup__c = p.Id;
        a.OwnerId = u1.id;
        a.Short_Name__c = 'ttt';
        a.FIPS__c ='ghdfg';
        a.County__c = 'USA'; 
       // a.Trade_Area__c = TA.id;
               
        insert a;
       
        
       // Trade_Area_Demand__c TAD = new Trade_Area_Demand__c();
       // TAD.Demand_Volume__c = 443 ;
       // TAD.Trade_Area__c = TA.id;
       // TAD.Year__c = '2012';
       //insert TAD;
       //
       
        order oi = new order();
         //oi.Invoice__c =Inv.id;
         oi.AccountId =a.id;
         oi.EffectiveDate= system.today();
         oi.Status='CREDIT HOLD';
         oi.Name ='test';
         insert oi;
        
        Invoice__c Inv = new Invoice__c();
        Inv.Name = 'dsds33';
         Inv.Order__c = oi.id;
        //Inv.CurrencyIsoCode = 'USD';
        Inv.Ship_To_Lookup__c = a.id;
        Inv.Billing_Date__c =Date.Today();
        Inv.Invoice_Number__c = 'dsds33';
        insert Inv;
         
         
         
         
        
        Invoice_Line_Item__c ILI = new Invoice_Line_Item__c();
        ILI.Invoice__c = Inv.id;
        //ILI.Invoice_Date__c = system.today().year() - 1, 1, 2;
        insert ILI;
         
         DateTime dT = System.now();
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
		Integer sdate = myDate.year();
        
        Account_Plan__c ap = new Account_Plan__c();
        ap.Account__c = a.Id;
        //ap.Name = 'Test';
        ap.Plan_Year__c = string.valueof(sdate);
        insert ap;
        
       // ApexPages.currentPage().getParameters().put('Id',TA.Id);     
        showTradeAreaMarketController STA = new showTradeAreaMarketController();
 
        test.stopTest();
        
       } 
  
   public static testMethod void testmethod2()  
     {
       test.startTest();
       Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p2.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.User_Type__c = 'SPG';
        u1.IsActive = TRUE;
        u1.User_Territory_Code__c = '7100';
        u1.Region__c = 'NE';
        insert u1;
       
        
        FIPS__c f = new FIPS__c();
        f.Name = 'ttt';
        f.FIPS_Code__c = 'gere44';
        f.Country__c = 'USA';
        f.State__c = 'Alberta';
        f.County__c = 'USA';
        insert f;
        
     //   Trade_Area__c TA = new Trade_Area__c();
      //  TA.Name = 'ddddd';
      //  TA.Product_Line__c = 'FiberCement';
      //  TA.Trade_Area_Code__c = 'sdfwt3334';
      //  insert TA;
        
        /*Trade_Area_FIPS__c TAF = new Trade_Area_FIPS__c();
        //TAF.Name = 'fwse';
        TAF.Ext_Id__c = 'dwwww';
        TAF.FIPS__c = f.id;
    //    TAF.Trade_Area__c = TA.id;
        insert TAF;*/
        
        Product_Line__c p = new Product_Line__c();
        p.name = 'FiberCement';
        p.UOM__c = null;
        p.Is_Used_For_Planning__c = TRUE;
        p.Code__c = 'tte333';
        insert p;     
        
        
        //ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'BPCS Bill-To (Bufftech)'].ID;
        Account a = new Account();
        a.Name = 'Test1';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        a.Status__c = 'Active';
        a.Currency__c = 'USD';
        //a.RecordTypeID = RTID;
        a.Product_Line__c = 'FiberCement';
        a.Product_Line_Lookup__c = p.Id;
        a.OwnerId = u1.id;
        a.Short_Name__c = 'ttt';
        a.FIPS__c ='ghdfg';
        a.County__c = 'USA'; 
       // a.Trade_Area__c = TA.id;
               
        insert a;
       
        
     //   Trade_Area_Demand__c TAD = new Trade_Area_Demand__c();
      //  TAD.Demand_Volume__c = 443 ;
        //TAD.Trade_Area__c = TA.id;
       // TAD.Year__c = '2012';
        //insert TAD;
        //
        order oi = new order();
         //oi.Invoice__c =Inv.id;
         oi.AccountId =a.id;
         oi.EffectiveDate= system.today();
         oi.Status='CREDIT HOLD';
         oi.Name ='test';
         insert oi;

        
        Invoice__c Inv = new Invoice__c();
        Inv.Name = 'dsds33';
        Inv.Order__c =oi.id;
        //Inv.CurrencyIsoCode = 'USD';
        Inv.Ship_To_Lookup__c = a.id;
        Inv.Billing_Date__c =Date.Today();
        Inv.Invoice_Number__c = 'dsds33';
        insert Inv;
        
        Invoice_Line_Item__c ILI = new Invoice_Line_Item__c();
        ILI.Invoice__c = Inv.id;
        //ILI.Invoice_Date__c = system.today().year() - 1, 1, 2;
        insert ILI;
        
          DateTime dT = System.now();
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
		Integer sdate = myDate.year();
         
        Account_Plan__c ap = new Account_Plan__c();
        ap.Account__c = a.Id;
        //ap.Name = 'Test';
        ap.Plan_Year__c =  string.valueof(sdate);
        insert ap;
        
      //  ApexPages.currentPage().getParameters().put('Id',TA.Id);     
        showTradeAreaMarketController STA = new showTradeAreaMarketController();
         sta.doCancel();
         showTradeAreaMarketController.accountWrapper aw = new showTradeAreaMarketController.accountWrapper(null, null, null, null, null);
         try {
             integer i = 8/0;
         } catch(Exception e) {
             sta.showCustomError(e);
             sta.showError(e);
         }
 
        test.stopTest();
        
       }
   
   public static testMethod void testmethod3()  
      {
       test.startTest();
       Profile p2 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p2.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.User_Type__c = 'SPG';
        u1.IsActive = TRUE;
        u1.User_Territory_Code__c = '7100';
        u1.Region__c = 'NE';
        insert u1;
       
        
        FIPS__c f = new FIPS__c();
        f.Name = 'ttt';
        f.FIPS_Code__c = 'gere44';
        f.Country__c = 'USA';
        f.State__c = 'Alberta';
        f.County__c = 'USA';
        insert f;
        
        //Trade_Area__c TA = new Trade_Area__c();
       // TA.Name = 'ddddd';
      //  TA.Product_Line__c = 'FiberCement';
      //  TA.Trade_Area_Code__c = 'sdfwt3334';
        //insert TA;
        
       // Trade_Area_FIPS__c TAF = new Trade_Area_FIPS__c();
        //TAF.Name = 'fwse';
       // TAF.Ext_Id__c = 'dwwww';
        //TAF.FIPS__c = f.id;
        //TAF.Trade_Area__c = TA.id;
       // insert TAF;
        
        Product_Line__c p = new Product_Line__c();
        p.name = 'FiberCement';
        p.UOM__c = 'Squares';
        p.Is_Used_For_Planning__c = TRUE;
        p.Code__c = 'tte333';
        insert p;     
        
        
        //ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'BPCS Bill-To (Bufftech)'].ID;
        Account a = new Account();
        a.Name = 'Test1';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        a.Status__c = 'Active';
        a.Currency__c = 'USD';
        //a.RecordTypeID = RTID;
        a.Product_Line__c = 'FiberCement'; 
        a.Product_Line_Lookup__c = p.Id;
        a.OwnerId = u1.id;
        a.Short_Name__c = 'ttt';
        a.FIPS__c ='ghdfg';
        a.County__c = 'USA'; 
        //a.Trade_Area__c = TA.id;
               
        insert a;
       
        
        //Trade_Area_Demand__c TAD = new Trade_Area_Demand__c();
        //TAD.Demand_Volume__c = 443 ;
        //TAD.Trade_Area__c = TA.id;
        //TAD.Plan_Year__c = '2012';
        //insert TAD;
        //
         order oi = new order();
         //oi.Invoice__c =Inv.id;
         oi.AccountId =a.id;
         oi.EffectiveDate= system.today();
         oi.Status='CREDIT HOLD';
         oi.Name ='test';
         insert oi;
        
        Invoice__c Inv = new Invoice__c();
        Inv.Name = 'dsds33';
        Inv.Order__c =oi.id;
        //Inv.CurrencyIsoCode = 'USD';
        Inv.Ship_To_Lookup__c = a.id;
        Inv.Billing_Date__c =Date.Today();
        Inv.Invoice_Number__c = 'dsds33';
        insert Inv;
          
         
			
          
        
        Invoice_Line_Item__c ILI = new Invoice_Line_Item__c();
        ILI.Invoice__c = Inv.id;
        //ILI.Invoice_Date__c = system.today().year() - 1, 1, 2;
        insert ILI;
          
           DateTime dT = System.now();
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
		Integer sdate = myDate.year();
        
        Account_Plan__c ap = new Account_Plan__c();
        ap.Account__c = a.Id;
        //ap.Name = 'Test';
        ap.Plan_Year__c = string.valueof(sdate);
        insert ap;
        
        //ApexPages.currentPage().getParameters().put('Id',TA.Id);     
       // showTradeAreaMarketController STA = new showTradeAreaMarketController(new ApexPages.StandardController(TA));
 
        test.stopTest();
        
       }            
}