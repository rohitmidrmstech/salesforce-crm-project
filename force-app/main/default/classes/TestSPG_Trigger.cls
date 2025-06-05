@isTest (seeAllData = true)
private class TestSPG_Trigger
{
    public static testmethod void DoTest1()
    {
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
        
        test.startTest();
        Product_Line__c p = new Product_Line__c();
        p.Name = 'FiberCement';
        p.OwnerId = u1.Id;
        p.Code__c = 'MILLW1';
        p.UOM__c= 'Dollars';
        p.Is_Used_For_Planning__c = True;
        p.Distribution_Email__c = 'testMe@im.com';
        insert p;
        test.stopTest();
    }
    public static testMethod void Test2()
    {
        Account aGP = new Account();
        aGP.Name = 'Test';
        insert aGP;
        
        // create account
        Account a = new Account();
        a.Name = 'Test3';
        a.ParentId = aGP.Id;
        insert a;
        
        Account a1 = new Account();
        a1.Name = 'Test31';
        a1.ParentId = aGP.Id;
        insert a1;
        
        Account a2 = new Account();
        a2.Name = 'Test311';
        a2.ParentId = aGP.Id;
        insert a2;
        
        DateTime dT = System.now();
		Date myDate = date.newinstance(dT.year(), dT.month(), dT.day());
		Integer sdate = myDate.year();
        
        Account_Plan__c ap = new Account_Plan__c();
        ap.Account__c = a.Id;
        //ap.Name = 'Test';
        ap.Plan_Year__c = string.valueof(sdate);
        insert ap;
        
        Account_Plan__c ap1 = new Account_Plan__c();
        ap1.Account__c = a1.Id;
       
        ap1.Plan_Year__c = string.valueof(sdate);
        insert ap1;
        
        Account_Plan__c ap2 = new Account_Plan__c();
       ap2.Account__c = a2.Id;
       
       ap2.Plan_Year__c = string.valueof(sdate);
        insert ap2;
       
        ap.Plan_Year__c = string.valueof(sdate+2);
        update ap;
        
        ap1.Plan_Year__c = string.valueof(sdate+20);
        update ap1;
        
        ap2.Plan_Year__c = string.valueof(sdate+25);
        update ap2; 
        
    }
   
    public static testMethod void testmethod5()
    {
        test.startTest();
        
        Product_Line__c p = new Product_Line__c();
        p.name = 'FiberCement';
        p.UOM__c = 'Squares';
        p.Is_Used_For_Planning__c = TRUE;
        p.Code__c = 'tte333';
        insert p;
        
        p.Is_Used_For_Planning__c = False;
        update p;
        
        p.Is_Used_For_Planning__c = True;
        update p;
       
        Market_Family__c mf = new Market_Family__c();
        mf.Product_Line__c = p.id;
        mf.Name = 'fffd';
        mf.Is_Used_For_Planning__c = True;
        mf.Product_Market_Family__c = 'Classic';
        insert mf;
        
        //mf.Is_Used_For_Planning__c = FALSE;
        //update mf;
        
        p.Is_Used_For_Planning__c = False;
        update p;
        
        test.stopTest();
    }
   
    public static testMethod void testmethod6()  
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
        
        Product_Line__c p = new Product_Line__c();
        p.name = 'FiberCement';
        p.UOM__c = 'Squares';
        p.Is_Used_For_Planning__c = TRUE;
        p.Code__c = 'tte333';
        insert p;
        
        Account aGP = new Account();
        aGP.Name = 'Test';
        insert aGP;
        
        //ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'BPCS Bill-To (Bufftech)'].ID;
        Account a = new Account();
        a.Name = 'Test';
        a.ParentId = aGP.Id;
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
        a.FIPS__c ='ghdfg';
        insert a;
        
        update a;
        
        AccountTeamMember atm = new AccountTeamMember();
        atm.AccountId = a.Id;
        atm.UserId = u1.Id;
        //atm.AccountAccessLevel = 'Edit';
        insert atm;
        
        /*AccountShare ash = new AccountShare();
                        
        ash.AccountId = a.Id;
        ash.AccountAccessLevel = 'Read';
        ash.CaseAccessLevel = 'Read'; 
        ash.OpportunityAccessLevel = 'Read';
        ash.UserOrGroupId = u1.Id;
        insert ash;*/
        
        FIPS__c f = new FIPS__c();
        f.Name = 'ttt';
        f.FIPS_Code__c = 'gere44';
        f.Country__c = 'USA';
        f.State__c = 'Alberta';
        f.County__c = 'USA';
        insert f;
        
   //     Trade_Area__c TA = new Trade_Area__c();
     //   TA.Name = 'ddddd';
      //  TA.Product_Line__c = 'Millwork';
       // insert TA;
    
       /* Trade_Area_FIPS__c TAF = new Trade_Area_FIPS__c();
        //TAF.Name = 'fwse';
        TAF.Ext_Id__c = 'dwwww';
        TAF.FIPS__c = f.id;
      //  TAF.Trade_Area__c = TA.id;
        insert TAF;*/
        test.stopTest();
        
       } 
      public static testMethod void testmethod7()  
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
        
        Account a2 = new Account();
        a2.Name = 'Test311';
        insert a2;
        
        FIPS__c f = new FIPS__c();
        f.Name = 'ttt';
        f.FIPS_Code__c = 'gere44';
        f.Country__c = 'USA';
        f.State__c = 'Alberta';
        f.County__c = 'USA';
        insert f;
        
      //  Trade_Area__c TA = new Trade_Area__c();
      //  TA.Name = 'ddddd';
       // TA.Product_Line__c = 'Millwork';
       // insert TA;
    
        /*Trade_Area_FIPS__c TAF = new Trade_Area_FIPS__c();
        //TAF.Name = 'fwse';
        TAF.Ext_Id__c = 'dwwww';
        TAF.FIPS__c = f.id;
     //   TAF.Trade_Area__c = TA.id;
        insert TAF;*/
        
        Product_Line__c p = new Product_Line__c();
        p.name = 'FiberCement';
        p.UOM__c = 'Squares';
        p.Is_Used_For_Planning__c = TRUE;
        p.Code__c = 'tte333';
        insert p;
        
        Account aGP = new Account();
        aGP.Name = 'Test';
        aGP.ParentId = a2.Id;
        aGP.BillingCity = 'Test';
        aGP.BillingState = 'CA';
        aGP.Type = 'Other';
        aGP.Status__c = 'Active';
        aGP.Currency__c = 'USD';
        //aGP.RecordTypeID = RTID;
        aGP.Product_Line__c = 'Siding';
        aGP.Product_Line_Lookup__c = p.id;
        aGP.OwnerId = u1.id;
        aGP.Short_Name__c = 'ttt';
        aGP.FIPS__c ='ghdfg';
        insert aGP;
        
        update aGP;
        
        //ID RTID = [SELECT ID FROM RecordType WHERE SObjectType = 'Account' AND DeveloperName = 'BPCS Bill-To (Bufftech)'].ID;
        Account a = new Account();
        a.Name = 'Test1';
        a.ParentId = aGP.Id;
        a.BillingCity = 'Test';
        a.BillingState = 'CA';
        a.Type = 'Other';
        a.Status__c = 'Active';
        a.Currency__c = 'USD';
        //a.RecordTypeID = RTID;
        a.Product_Line__c = 'Siding';
        a.Product_Line_Lookup__c = p.Id;
        a.OwnerId = u1.id;
        a.Short_Name__c = 'ttt';
        a.FIPS__c ='ghdfg';
       // a.Trade_Area__c = TA.id;
        a.County__c = 'USA';
        a.SAP_ACCOUNT__c = '32323234';  
        a.D_B__c = '3344334435';
        a.Ext_Id__c = '20140914';        
        insert a;
        
        a.ParentId = aGP.Id;
        update a;
        
        AccountTeamMember atm = new AccountTeamMember();
        atm.AccountId = a.Id;
        atm.UserId = u1.Id;
        //atm.AccountAccessLevel = 'Edit';
        insert atm;
        
        /*AccountShare ash = new AccountShare();
                        
        ash.AccountId = a.Id;
        ash.AccountAccessLevel = 'Read';
        ash.CaseAccessLevel = 'Read'; 
        ash.OpportunityAccessLevel = 'Read';
        ash.UserOrGroupId = u1.Id;
        insert ash;*/
        
        
        
        a.FIPS__c ='ghttteg';
        update a;
        test.stopTest();
        
       }                       
}