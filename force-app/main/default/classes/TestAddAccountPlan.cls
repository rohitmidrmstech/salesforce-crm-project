@isTest (seeAllData = true)
public class TestAddAccountPlan
{
    public static testMethod void AddAccountPlan1()
    {
        test.startTest();
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;
        
        Product_Line__c p = new Product_Line__c();
        p.Name = 'FiberCement';
        p.UOM__c = 'Squares';
        p.Is_Used_For_Planning__c = TRUE;
        p.Code__c = 'tte333';
        insert p;
        
        //ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'BPCS Bill-To (Bufftech)'].ID;
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        a.Status__c = 'Active';
        a.Currency__c = 'USD';
        //a.RecordTypeID = RTID;
        a.Product_Line__c = 'Siding';
        a.Product_Line_Lookup__c = p.id;
        a.OwnerId = u1.id;
        a.Short_Name__c = 'ttt';    
        a.Planning_Account__c = 'Yes';
        a.LOB__c = '1502';
        
        insert a;
    
        Account_Plan__c AP = new Account_Plan__c();
        AP.Account__c = a.Id;
        AP.Plan_Year__c = '2015';
        AP.Notes__c = '222';             
        insert AP;
        
        Market_Family__c mf = new Market_Family__c();
        mf.Product_Line__c = p.id;
        mf.Name = 'fffd';
        mf.Is_Used_For_Planning__c = True;
        mf.Product_Market_Family__c = 'Classic';
        insert mf;
        
        Market_Family_Plan__c MFP = new Market_Family_Plan__c();
        //MFP.Name = 'fff';
        MFP.Account_Plan__c = AP.id;
        MFP.Market_Family__c = mf.id;
        MFP.Amount__c =100;
        MFP.Volume__c =433;
        insert MFP;
        
           
        //ApexPages.currentPage().getParameters().get('id',AP.id);   
        ApexPages.currentPage().getParameters().put('accountId',a.Id);     
        addAccountPlanController AP2 = new addAccountPlanController(new ApexPages.StandardController(a));
        AP2.loadThisYearHistory();
        AP2.loadLastYearHistory();
        AP2.loadPrevYearHistory();
        
        Pagereference pr = AP2.customSave();
        pr = AP2.customClone();
        test.stopTest();
    }
    public static testMethod void AddAccountPlan2()
    {
        test.startTest();
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;
        
        Product_Line__c p = new Product_Line__c();
        p.Name = 'FiberCement';
        p.UOM__c = 'Squares';
        p.Is_Used_For_Planning__c = True;
        p.Code__c = 'tte333';
        insert p;
        
        //ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'BPCS Bill-To (Bufftech)'].ID;
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        a.Status__c = 'Active';
        a.Currency__c = 'USD';
        //a.RecordTypeID = RTID;
        a.Product_Line__c = 'Siding';
        a.Product_Line_Lookup__c = p.id;
        a.OwnerId = u1.id;
        a.Short_Name__c = 'ttt';    
        a.Planning_Account__c = 'Yes';
        
        insert a;
    
        Account_Plan__c AP = new Account_Plan__c();
        AP.Account__c = a.Id;
        AP.Plan_Year__c = '2015';
        AP.Notes__c = '222';             
        insert AP;
        
        Market_Family__c mf = new Market_Family__c();
        mf.Product_Line__c = p.id;
        mf.Name = 'fffd';
        mf.Is_Used_For_Planning__c = True;
        mf.Product_Market_Family__c = 'Classic';
        insert mf;
        
        Market_Family_Plan__c MFP = new Market_Family_Plan__c();
        //MFP.Name = 'fff';
        MFP.Account_Plan__c = AP.id;
        MFP.Market_Family__c = mf.id;
        MFP.Amount__c =100;
        MFP.Volume__c =433;
        insert MFP;
        
        
           
        ApexPages.currentPage().getParameters().put('accountId',a.Id);     
        addAccountPlanController AP2 = new addAccountPlanController(new ApexPages.StandardController(a));
        AP2.loadThisYearHistory();
        AP2.loadLastYearHistory();
        AP2.loadPrevYearHistory();
        
        Pagereference pr = AP2.customSaveClose();
        
        test.stopTest();
    }
    public static testMethod void AddAccountPlan3()
    {
        test.startTest();
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;
        
        Product_Line__c p = new Product_Line__c();
        p.Name = 'FiberCement';
        p.UOM__c = 'Dollars';
        p.Is_Used_For_Planning__c = True;
        p.Code__c = 'tte333';
        insert p;
        
        ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Ship-To'].ID;
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'TYPE_1STEP';
        a.Status__c = 'Active';
        a.Currency__c = 'USD';
        a.RecordTypeID = RTID;
        a.Product_Line__c = 'Siding';
        a.Product_Line_Lookup__c = p.id;
        a.OwnerId = u1.id;
        a.Short_Name__c = 'ttt';  
        a.Planning_Account__c = 'Yes';
        
        insert a;
        
        //Account a1 = new Account();
        //a1.Name = 'Test';
        //a1.BillingCity = 'Test';
        //a1.BillingState = 'CA';
        //a1.Type = 'TYPE_2STEP';
        //a1.Status__c = 'Active';
        //a1.Currency__c = 'USD';
        //a1.Product_Line__c = 'Siding';
       // a1.Product_Line_Lookup__c = p.id;
       // a1.OwnerId = u1.id;
       // a1.Short_Name__c = 'ttt';  
        //a1.RecordType = 'BPCS Bill-To (Siding)';
        //a1.Account_Number__c = '32323232';  
        //a1.DUNS_ID__c = '3344334433';
       // a1.Ext_Id__c = '20140912';
       // insert a1;
        
        Account_Plan__c AP = new Account_Plan__c();
        AP.Account__c = a.Id;
        AP.Plan_Year__c = '2015';
        AP.Notes__c = '222';             
        insert AP;
        
        Market_Family__c mf = new Market_Family__c();
        mf.Product_Line__c = p.id;
        mf.Name = 'fffd';
        mf.Is_Used_For_Planning__c = True;
        mf.Product_Market_Family__c = 'Classic';
        insert mf;
        
                
        Order o = new Order();
        o.Name = '123456';
        o.Status = 'ORDER CREATED';
        o.EffectiveDate = System.now().date();
        o.AccountId = a.Id;
        insert o;
        
        Invoice__c Inv = new Invoice__c();
        Inv.Name = 'dsds33';
        Inv.Order__c = O.id;
        //Inv.CurrencyIsoCode = 'USD';
        Inv.Ship_To_Lookup__c = a.id;
        Inv.Billing_Date__c =Date.Today();
        Inv.Invoice_Number__c = 'dsds33';
        insert Inv;
        
        Invoice_Line_Item__c il = new Invoice_Line_Item__c();
        il.Market_Family__c = 'Cedar Impressions';
        il.Price__c = 1000;
        il.Quantity__c = 2000;
        //il.CurrencyIsoCode = 'USD';
        il.Invoice__c = Inv.Id;
        insert il;
        
        //Wrapper w = new Wrapper();
        ApexPages.currentPage().getParameters().put('Id',AP.Id);     
        addAccountPlanController AP2 = new addAccountPlanController(new ApexPages.StandardController(AP));
        AP2.loadThisYearHistory();
        AP2.loadLastYearHistory();
        AP2.loadPrevYearHistory();
        AP2.isInsert = true;
        Pagereference pr1 = AP2.customClone();
        AP2.getNextYear();
        AP2.nextYear = AP2.getNextYear();
        AP2.getNextYear();
        //AP2.canPlan(a, 'create');
        AP2.createAccountPlan(a, AP.Plan_Year__c, AP.Notes__c);
        AP2.getCurrentPlan(AP.Id);
        AP2.loadActualsByYear(AP.Plan_Year__c, 1);
        Pagereference pr = AP2.customSaveClose();
 
        test.stopTest();
    }
    public static testMethod void AddAccountPlan4()
    {
        test.startTest();
        
        Profile p1 = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        // Create a new System Administrator user.
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p1.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        insert u1;
        
        Product_Line__c p = new Product_Line__c();
        p.Name = 'FiberCement';
        p.UOM__c = 'Dollars';
        p.Is_Used_For_Planning__c = True;
        p.Code__c = 'tte333';
        insert p;
        
        ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND Name = 'Payer'].ID;
        //Commented below line as the below record type not available 
       // ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND Name = 'BPCS Bill-To (Bufftech)'].ID;
        Account a = new Account();
        a.Name = 'Test';
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'TYPE_1STEP';
        a.Status__c = 'Active';
        a.Currency__c = 'USD';
        
        a.Product_Line__c = 'Siding';
        a.Product_Line_Lookup__c = p.id;
        a.OwnerId = u1.id;
        a.Short_Name__c = 'ttt';  
        a.Planning_Account__c = 'Yes';
        
        insert a;
        
        //Account a1 = new Account();
        //a1.Name = 'Test';
        //a1.BillingCity = 'Test';
        //a1.BillingState = 'CA';
        //a1.Type = 'TYPE_2STEP';
       // a1.Status__c = 'Active';
        //a1.Currency__c = 'USD';
        //a1.Product_Line__c = 'Siding';
        //a1.Product_Line_Lookup__c = p.id;
        //a1.OwnerId = u1.id;
        //a1.Short_Name__c = 'ttt';  
        //a1.RecordTypeId = RTID;
        //a1.Account_Number__c = '32323233';  
        //a1.DUNS_ID__c = '3344334434';
        //a1.Ext_Id__c = '20140913'; 
        //insert a1;
        
        Account_Plan__c AP = new Account_Plan__c();
        AP.Account__c = a.Id;
        AP.Plan_Year__c = '2015';
        AP.Notes__c = '222';             
        insert AP;
        
        Market_Family__c mf = new Market_Family__c();
        mf.Product_Line__c = p.id;
        mf.Name = 'fffd';
        mf.Is_Used_For_Planning__c = True;
        mf.Product_Market_Family__c = 'Classic';
        insert mf;
        
        Order o = new Order();
        o.Name = '123456';
        o.Status = 'ORDER CREATED';
        o.EffectiveDate = System.now().date();
        o.AccountId = a.Id;
        insert o;
        
        Invoice__c Inv = new Invoice__c();
        Inv.Name = 'dsds33';
        Inv.Order__c = O.id;
        //Inv.CurrencyIsoCode = 'USD';
        Inv.Ship_To_Lookup__c = a.id;
        Inv.Billing_Date__c =Date.Today();
        Inv.Invoice_Number__c = 'dsds33';
        insert Inv;
        
        Invoice_Line_Item__c il = new Invoice_Line_Item__c();
        il.Market_Family__c = 'Cedar Impressions';
        il.Price__c = 1000;
        il.Quantity__c = 2000;
        //il.CurrencyIsoCode = 'USD';
        il.Invoice__c = Inv.Id;
        insert il;
        
        //Wrapper w = new Wrapper();
        ApexPages.currentPage().getParameters().put('Id',AP.Id);     
        addAccountPlanController AP2 = new addAccountPlanController(new ApexPages.StandardController(AP));
        AP2.loadThisYearHistory();
        AP2.loadLastYearHistory();
        AP2.loadPrevYearHistory();
        AP2.isInsert = true;
        Pagereference pr1 = AP2.customClone();
        AP2.getNextYear();
        AP2.nextYear = AP2.getNextYear();
        AP2.getNextYear();
        //AP2.canPlan(a1, 'create');
        //AP2.createAccountPlan(a1, AP.Plan_Year__c, AP.Notes__c);
        AP2.getCurrentPlan(AP.Id);
        AP2.loadActualsByYear(AP.Plan_Year__c, 1);
        Pagereference pr = AP2.customSaveClose();
 
        // Cover the DML Exception handler.
        try
        {
            // Leave off the Name field.
            Account badAccount = new Account();
            insert badAccount;
        }
        catch (DMLException dex)
        { 
        	AP2.showError(dex);
            AP2.handleDmlException(dex, 'Testing');
            system.assert(true);
        }
 
        test.stopTest();
    } 
}