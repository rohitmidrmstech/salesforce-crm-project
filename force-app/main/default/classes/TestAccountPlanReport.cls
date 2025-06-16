// ==================================================================================
//   Object: TestAccountPlanReport
//  Company: CT-SPG
//   Author: Mohan Kumar (TCS)
// Comments: 
// ==================================================================================
//  Changes: 2014-09-25 Initial version.
// ==================================================================================

@isTest
private class TestAccountPlanReport {

    public static testMethod void accountPlanReportTest1()
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
        a.PRICE_GROUP__c = 'Test';
        
        insert a;
        
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.BillingCity = 'Test';
        a1.BillingState = 'CA';
        a1.Type = 'TYPE_2STEP';
        a1.Status__c = 'Active';
        a1.Currency__c = 'USD';
        a1.Product_Line__c = 'Siding';
        a1.Product_Line_Lookup__c = p.id;
        a1.OwnerId = u1.id;
        a1.Short_Name__c = 'ttt';  
        //a1.RecordType = 'BPCS Bill-To (Siding)';
        a1.SAP_ACCOUNT__c = '32323232';  
        a1.D_B__c = '3344334433';
        a1.Ext_Id__c = '20140912';
        a1.PRICE_GROUP__c = 'Test';
        insert a1;
        
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
        Inv.Order__c = o.id;
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
        AccountPlanReport apObj = new AccountPlanReport(new ApexPages.StandardController(AP));
        apObj.performSearch();
        apObj.customerDistrict = 'test';
        apObj.performSearch();
        
        try { Account badAccount = new Account(); insert badAccount;
        } catch (DMLException dex) { 
            apObj.handleDmlException(dex, 'Testing');
        }
        
        try { Account badAccount = new Account(); insert badAccount;
        } catch (Exception dex) { 
            apObj.showCustomError(dex);
        }
        try { Account badAccount = new Account(); insert badAccount;
        } catch (Exception dex) { 
            apObj.showError(dex, 'test');
            apObj.showError(dex);
        }
        
        apObj.showDebug('lbl', 'dbg');
        apObj.showConfirm('conf');
        apObj.showInfo('info');
        ID theID;
        AccountPlanReport.Wrapper apw = new AccountPlanReport.Wrapper('theName', theID, 1.0, 1.2, 2.2, 'marketSegment', 'brand', new Market_Family_Plan__c());
        test.stopTest();
    }
    
    public static testMethod void accountPlanReportTest2()
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
        a.PRICE_GROUP__c = 'Test';
        
        insert a;
        
        Account a1 = new Account();
        a1.Name = 'Test';
        a1.ParentId = a.Id;
        a1.BillingCity = 'Test';
        a1.BillingState = 'CA';
        a1.Type = 'Ship-To';
        a1.Status__c = 'Active';
        a1.Currency__c = 'USD';
        a1.Product_Line__c = 'Siding';
        a1.Product_Line_Lookup__c = p.id;
        a1.OwnerId = u1.id;
        a1.Short_Name__c = 'ttt';  
        //a1.RecordType = 'BPCS Bill-To (Siding)';
        a1.SAP_ACCOUNT__c = '32323232';  
        a1.D_B__c = '3344334433';
        a1.Ext_Id__c = '20140912';
        a1.PRICE_GROUP__c = 'Test';
        insert a1;
        
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
        Inv.order__c = o.id;
        Inv.Name = 'dsds33';
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
        ApexPages.currentPage().getParameters().put('pid',a.Id);     
        AccountPlanReportCorp apObj = new AccountPlanReportCorp(new ApexPages.StandardController(AP));
        apObj.performSearch();
        apObj.currentAccount.ParentId = a.id;
        apObj.performSearch();
        
        try { Account badAccount = new Account(); insert badAccount;
        } catch (DMLException dex) { 
            apObj.handleDmlException(dex, 'Testing');
        }
        
        try { Account badAccount = new Account(); insert badAccount;
        } catch (Exception dex) { 
            apObj.showCustomError(dex);
        }
        try { Account badAccount = new Account(); insert badAccount;
        } catch (Exception dex) { 
            apObj.showError(dex, 'test');
            apObj.showError(dex);
        }
        
        apObj.showDebug('lbl', 'dbg');
        apObj.showConfirm('conf');
        apObj.showInfo('info');
        ID theID;
        AccountPlanReport.Wrapper apw = new AccountPlanReport.Wrapper('theName', theID, 1.0, 1.2, 2.2, 'marketSegment', 'brand', new Market_Family_Plan__c());
        test.stopTest();
    }
    
}