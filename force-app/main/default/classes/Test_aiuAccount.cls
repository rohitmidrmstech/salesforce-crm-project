@isTest
private class Test_aiuAccount
{
    public static testmethod void DoTest()
    {
        // Create sample user for this test.
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/Los_Angeles';
        u1.LocaleSidKey = 'en_US';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.User_Type__c = 'SPG';
        u1.IsActive = TRUE;
        u1.User_Territory_Code__c = '7100';
        u1.Region__c = 'NE';
        insert u1;
        
        User u2 = new User();
        u2.Email = 'email12@email.com';
        u2.Alias = 'Alias22';
        u2.TimeZoneSidKey = 'America/Los_Angeles';
        u2.LocaleSidKey = 'en_US';
        u2.EmailEncodingKey = 'UTF-8';
        u2.ProfileId = p.id;
        u2.LanguageLocaleKey = 'en_US';
        u2.FirstName = 'firstname1';
        u2.LastName = 'lastname12';
        u2.username= 'username12@first.com';
        u2.User_Type__c = 'SPG';
        u2.IsActive = TRUE;
        u2.User_Territory_Code__c = '7100';
        u2.Region__c = 'NE';
        insert u2;
        
        System.runAs(u1){
            Id RecordTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Payer').getRecordTypeId();
        
            Territory__c territoryRec = new Territory__c();
            territoryRec.Name = 'Test';
            territoryRec.Sales_Rep__c = u1.Id;
            Insert territoryRec;
        
            // create grand parent
            Account aGP = new Account();
            aGP.Name = 'Test';
            aGP.WTU_Notes__c = 'This is Test WTU Notes';
            aGP.Status__c = 'Active';
            aGP.Territory__c = territoryRec.Id;
            aGP.RecordTypeId = RecordTypeIdAccount;
            insert aGP;
            
            // create parent
            Account aP = new Account();
            aP.Name = 'Test2';
            aP.ParentId = aGP.Id;
            //aP.RecordTypeId = RecordTypeIdAccount;
            insert aP;
            
            // create account
            Account a = new Account();
            a.Name = 'Test3';
            a.ParentId = aP.Id;
            //a.RecordTypeId = RecordTypeIdAccount;
            insert a;
            
            Weekly_Territory_Update__c wtuRecord = new Weekly_Territory_Update__c();
            wtuRecord.Week_Ends__c = system.today().addDays(7).toStartOfWeek();
            Insert wtuRecord;
            
            WTU_Note__c wtuNotesRecord = new WTU_Note__c();
            wtuNotesRecord.Account__c = aGP.Id;
            wtuNotesRecord.Name = 'Test';
            wtuNotesRecord.Special_Topic__c = 'This is the testing part';
            wtuNotesRecord.WTU__c = wtuRecord.Id;
            Insert wtuNotesRecord;
            
            
            for (User u : [Select Id From User Where IsActive = true and Id != : UserInfo.getUserId() Limit 1 ])
            {
                for(Account acc : [Select Id, OwnerId, Name From Account Where Id = : aP.Id Limit 1])
                {
                    acc.Name = 'Test4';
                    acc.OwnerId = u.Id ;
                    update acc;
                }
            }
        }
    }
    
    public static testmethod void DoTest1()
    {
        // Create sample user for this test.
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.User_Type__c = 'SPG';
        u1.IsActive = TRUE;
        u1.User_Territory_Code__c = '7100';
        u1.Region__c = 'NE';
        insert u1;

        // create grand parent
        Account aGP = new Account();
        aGP.Name = 'Test';
        insert aGP;
        
        // create parent
        Account aP = new Account();
        aP.Name = 'Test2';
        aP.ParentId = aGP.Id;
        insert aP;
        
        // create account
        Account a = new Account();
        a.Name = 'Test3';
        a.ParentId = aP.Id;
        insert a;
        
        for (User u : [Select Id From User Where IsActive = true and Id != : UserInfo.getUserId() Limit 1])
        {
            for(Account acc : [Select Id, OwnerId, Name From Account Where Id = : aGP.Id Limit 1])
            {
                acc.Name = 'Test4';
                acc.OwnerId = u.Id ;
                update acc;
            }
        }
    }
    
    public static testmethod void DoTest2()
    {
        // Create sample user for this test.
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.User_Type__c = 'SPG';
        u1.IsActive = TRUE;
        u1.User_Territory_Code__c = '7100';
        u1.Region__c = 'NE';
        insert u1;

        // create grand parent
        Account aGP = new Account();
        aGP.Name = 'Test';
        insert aGP;
        
        // create parent
        Account aP = new Account();
        aP.Name = 'Test2';
        aP.ParentId = aGP.Id;
        insert aP;
        
        // create account
        Account a = new Account();
        a.Name = 'Test3';
        a.ParentId = aP.Id;
        insert a;
        
        for(User u : [Select Id From User Where IsActive = true and Id != : UserInfo.getUserId() Limit 1 ])
        {
            for(Account acc : [Select Id, OwnerId, Name From Account Where Id = : a.Id Limit 1])
            {
                acc.Name = 'Test4';
                acc.OwnerId = u.Id ;
                update acc;
            }
        }
    }
    
    public static testmethod void DoTest3()
    {
        // Create sample user for this test.
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        User u1 = new User();
        u1.Email = 'email1@email.com';
        u1.Alias = 'Alias2';
        u1.TimeZoneSidKey = 'America/New_York';
        u1.LocaleSidKey = 'ca';
        u1.EmailEncodingKey = 'UTF-8';
        u1.ProfileId = p.id;
        u1.LanguageLocaleKey = 'en_US';
        u1.FirstName = 'firstname1';
        u1.LastName = 'lastname1';
        u1.username= 'username1@first.com';
        u1.User_Type__c = 'SPG';
        u1.IsActive = TRUE;
        u1.User_Territory_Code__c = '7100';
        u1.Region__c = 'NE';
        insert u1;

        // create grand parent
        Account aGP = new Account();
        aGP.Name = 'Test';
        insert aGP;
        
        // create parent
        Account aP = new Account();
        aP.Name = 'Test2';
        aP.ParentId = aGP.Id;
        insert aP;
        
        FIPS__c fips = new FIPS__c(Name='Manhattan - New York - USA', FIPS_Code__c='698751', Country__c='Canada', State__c='Vancouver', County__c='Vancouver');
        insert fips;
        
        //Trade_Area__c ta = New Trade_Area__c(Name='New York - Siding', Product_Line__c='Siding');
       // insert ta;
        
        //Trade_Area_FIPS__c tfips = new Trade_Area_FIPS__c(Trade_Area__c=ta.id, FIPS__c=fips.id);
        //insert tfips;
        
        // create account
        Account a = new Account();
        a.Name = 'Test3';
        a.ParentId = aP.Id;
        a.Product_Line__c = 'Fiber Cement';
        a.FIPS__c = '698751';
        insert a;
        
        
        for(User u : [Select Id From User Where IsActive = true and Id != : UserInfo.getUserId() Limit 1 ])
        {
            for(Account acc : [Select Id, OwnerId, Name From Account Where Id = : a.Id Limit 1])
            {
                acc.Name = 'Test4';
                acc.OwnerId = u.Id ;
                update acc;
            }
        }
    }
}