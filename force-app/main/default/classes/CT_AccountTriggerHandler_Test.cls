/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Account Trigger Handler Test class
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Deepak Regala (dregala@liquidhub.com) and Vincent Ip (vip@liquidhub.com)
* @version        1.0
* @created        2017-07-12
*/
@isTest
private class CT_AccountTriggerHandler_Test {
    
    static testMethod void test1(){
        Test.startTest();
        List<User> userList = new List<User>();
        List<Territory__c> terrList = new List<Territory__c>();

        //userList = [SELECT id, ManagerId,User_Territory_Code__c from User where isActive=true and ManagerId != null and Manager.isActive=true AND User_Territory_Code__c != null];
        createUser();
        
        userList = [SELECT id, ManagerId,User_Territory_Code__c from User where username IN('testuser@sometestorg.com','testuser2@sometestorg.com')];
        if (userList.size()>0){
            User currUser = userList.get(0);
            
            System.runAs(currUser){
            
            Weekly_Territory_Update__c wtuRecord = new Weekly_Territory_Update__c(TM__c = currUser.Id, Week_Ends__c = system.today().addDays(7).toStartOfWeek());
            Insert wtuRecord;

            Territory__c testTerr = new Territory__c();
            testTerr.Name = 'Territory Name';
            testTerr.Sales_Rep__c = currUser.Id;
            testTerr.OwnerId = currUser.Id;
            terrList.add(testTerr);
            
            testTerr = new Territory__c();
            testTerr.Name = 'Territory Name2';
            testTerr.Sales_Rep__c = userList.get(1).Id;
            //testTerr.OwnerId = currUser.Id;
            terrList.add(testTerr);
            
            insert terrList;
            
                                 
            Account testAcct = new Account();
            testAcct.Name = 'test Account';
            testAcct.Territory__c = terrList[0].Id;
            testAcct.Mechanical_Territory__c = terrList[0].Id;
            testAcct.Z3_Partner__c= terrList[1].Id;
            testAcct.Finishing_Territory__c = terrList[1].Id;
            testAcct.BillingCountry = 'Canada';
            testAcct.TM__c =currUser.Id;
            testAcct.RSM__c = currUser.ManagerId;
            testAcct.OwnerId = currUser.Id;
            testAcct.WTU_Notes__c = 'Testing Notes';
            testAcct.Status__c = 'Active';
            testAcct.LOB__c = '1300';
            insert testAcct;
            
            /*testAcct = new Account();
            testAcct.Name = 'test Account2';
            testAcct.Mechanical_Territory__c = terrList[0].Id;
            testAcct.BillingCountry = 'Canada';
            testAcct.TM__c =currUser.Id;
            testAcct.RSM__c = currUser.ManagerId;
            testAcct.OwnerId = currUser.Id;
            testAcct.WTU_Notes__c = 'Testing Notes2';
            testAcct.Status__c = 'Active';
            testAcct.LOB__c = '1300';
            insert testAcct;*/
            
            
            testAcct = [SELECT Id, Name, TM__c, RSM__c, Territory__c, OwnerId FROM Account WHERE Id = :testAcct.Id];
                 
            System.assertEquals(currUser.Id, testAcct.TM__c);
            System.assertEquals(currUser.ManagerId, testAcct.RSM__c);
        

            Account updTestAcct = new Account();
            updTestAcct.Name = 'test Account2';
            updTestAcct.BillingCountry = 'Canada';
            updTestAcct.TM__c =currUser.Id;
            updTestAcct.RSM__c = currUser.ManagerId;
            updTestAcct.Territory__c = terrList[1].Id;
            updTestAcct.OwnerId = userList.get(1).Id;
            updTestAcct.Key_Account__c = true;
            updTestAcct.ParentId = testAcct.Id;
            insert updTestAcct;

            updTestAcct.Territory__c = terrList[0].Id;
            updTestAcct.Key_Account__c = false;
            update updTestAcct;
            
            updTestAcct = [SELECT Id, Name, TM__c, RSM__c, Territory__c, OwnerId FROM Account WHERE Id = :updTestAcct.Id];
                         System.assertEquals(currUser.Id, updTestAcct.TM__c);
            System.assertEquals(currUser.ManagerId, updTestAcct.RSM__c);
            
            CT_AccountTriggerHandler handler = new  CT_AccountTriggerHandler();
            
            List<Account> accList = new List<Account>();
            Map<Id,Account> accMap = new Map<Id, Account>();
            accList.add(updTestAcct);
            accList.add(testAcct);
            
            for(Account acc : accList){
                accMap.put(acc.Id, acc);
            }
            accList[0].Name = 'Test22';
            Database.update(accList, false);
            
            handler.checkMapTmRsmFromTerritory(accList, accList, accMap);
            }
        }
        Test.stopTest();
    }
    
    static testMethod void test2(){
        
        Territory__c testTerr = new Territory__c();
        testTerr.Name = 'Territory Name';
        //testTerr.Sales_Rep__c = currUser.Id;
        //testTerr.OwnerId = currUser.Id;
        Insert testTerr;
    
        /* Start Insert 2 Accounts Records */
        List<Account> accountList = new List<Account>();
        Account testAcct = new Account();
        testAcct.Name = 'test Account';
        testAcct.Territory__c = testTerr.Id;
        testAcct.BillingCountry = 'Canada';
        //testAcct.TM__c =currUser.Id;
        //testAcct.RSM__c = currUser.ManagerId;
        //testAcct.OwnerId = currUser.Id;
        testAcct.WTU_Notes__c = 'Testing Notes';
        testAcct.Status__c = 'Active';
        testAcct.Key_Account__c = true;
        //testAcct.LOB__c = '1300';
        Insert testAcct;
        
        Account testAcct3 = new Account();
        testAcct3.Name = 'test Account3';
        testAcct3.Territory__c = testTerr.Id;
        testAcct3.BillingCountry = 'Canada';
        //testAcct.TM__c =currUser.Id;
        //testAcct.RSM__c = currUser.ManagerId;
        //testAcct.OwnerId = currUser.Id;
        testAcct3.WTU_Notes__c = 'Testing Notes';
        testAcct3.Status__c = 'Active';
        testAcct3.Key_Account__c = false;
        Insert testAcct3;
        /* End Insert 2 Accounts Records */
        
        /* Start Insert 2 Child Account Records*/
        Account testAcct2 = new Account();
        testAcct2.Name = 'test Account2';
        testAcct2.Territory__c = testTerr.Id;
        testAcct2.BillingCountry = 'Canada';
        //testAcct2.TM__c =currUser.Id;
        //testAcct2.RSM__c = currUser.ManagerId;
        //testAcct2.OwnerId = currUser.Id;
        testAcct2.WTU_Notes__c = 'Testing Notes';
        testAcct2.Status__c = 'Active';
        testAcct2.ParentId = testAcct.Id;
        testAcct2.Key_Account__c = true;
        accountList.add(testAcct2);
        
        testAcct2 = new Account();
        testAcct2.Name = 'test Account4';
        testAcct2.Territory__c = testTerr.Id;
        testAcct2.BillingCountry = 'Canada';
        //testAcct2.TM__c =currUser.Id;
        //testAcct2.RSM__c = currUser.ManagerId;
        //testAcct2.OwnerId = currUser.Id;
        testAcct2.WTU_Notes__c = 'Testing Notes';
        testAcct2.Status__c = 'Active';
        testAcct2.ParentId = testAcct3.Id;
        testAcct2.Key_Account__c = false;
        accountList.add(testAcct2);
        insert accountList;
        /* End Insert 2 Child Account Records*/
        
        Test.startTest();
            List<Account> accountUpdtList = new List<Account>();
            Account updtAccount = accountList[0];
            updtAccount.Key_Account__c = false;
            accountUpdtList.add(updtAccount);
            
            updtAccount = accountList[1];
            updtAccount.Key_Account__c = false;
            accountUpdtList.add(updtAccount);
            
            testAcct.Key_Account__c = false;
            accountUpdtList.add(testAcct);
            
            testAcct3.Key_Account__c = true;
            accountUpdtList.add(testAcct3);
            Update accountUpdtList;
        Test.stopTest();
    }
    
    /*static testMethod void test3(){
        
        Territory__c testTerr = new Territory__c();
        testTerr.Name = 'Territory Name';
        //testTerr.Sales_Rep__c = currUser.Id;
        //testTerr.OwnerId = currUser.Id;
        Insert testTerr;
    
        // Start Insert 2 Accounts Records 
        List<Account> accountList = new List<Account>();
        Account testAcct = new Account();
        testAcct.Name = 'test Account';
        testAcct.Territory__c = testTerr.Id;
        testAcct.BillingCountry = 'Canada';
        //testAcct.TM__c =currUser.Id;
        //testAcct.RSM__c = currUser.ManagerId;
        //testAcct.OwnerId = currUser.Id;
        testAcct.WTU_Notes__c = 'Testing Notes';
        testAcct.Status__c = 'Active';
        testAcct.On_Contract__c = true;
        Insert testAcct;
        
        Account testAcct3 = new Account();
        testAcct3.Name = 'test Account';
        testAcct3.Territory__c = testTerr.Id;
        testAcct3.BillingCountry = 'Canada';
        //testAcct.TM__c =currUser.Id;
        //testAcct.RSM__c = currUser.ManagerId;
        //testAcct.OwnerId = currUser.Id;
        testAcct3.WTU_Notes__c = 'Testing Notes';
        testAcct3.Status__c = 'Active';
        testAcct3.On_Contract__c = false;
        Insert testAcct3;
        // End Insert 2 Accounts Records 
        
        // Start Insert 2 Child Account Records
        Account testAcct2 = new Account();
        testAcct2.Name = 'test Account';
        testAcct2.Territory__c = testTerr.Id;
        testAcct2.BillingCountry = 'Canada';
        //testAcct2.TM__c =currUser.Id;
        //testAcct2.RSM__c = currUser.ManagerId;
        //testAcct2.OwnerId = currUser.Id;
        testAcct2.WTU_Notes__c = 'Testing Notes';
        testAcct2.Status__c = 'Active';
        testAcct2.ParentId = testAcct.Id;
        testAcct2.On_Contract__c = true;
        accountList.add(testAcct2);
        
        testAcct2 = new Account();
        testAcct2.Name = 'test Account';
        testAcct2.Territory__c = testTerr.Id;
        testAcct2.BillingCountry = 'Canada';
        //testAcct2.TM__c =currUser.Id;
        //testAcct2.RSM__c = currUser.ManagerId;
        //testAcct2.OwnerId = currUser.Id;
        testAcct2.WTU_Notes__c = 'Testing Notes';
        testAcct2.Status__c = 'Active';
        testAcct2.ParentId = testAcct3.Id;
        testAcct2.On_Contract__c = false;
        accountList.add(testAcct2);
        insert accountList;
        // End Insert 2 Child Account Records
        
        Test.startTest();
            List<Account> accountUpdtList = new List<Account>();
            Account updtAccount = accountList[0];
            updtAccount.On_Contract__c = false;
            accountUpdtList.add(updtAccount);
            
            updtAccount = accountList[1];
            updtAccount.On_Contract__c = false;
            accountUpdtList.add(updtAccount);
            
            testAcct.On_Contract__c = false;
            accountUpdtList.add(testAcct);
            
            testAcct3.On_Contract__c = true;
            accountUpdtList.add(testAcct3);
            Update accountUpdtList;
        Test.stopTest();
    }*/
    
    
    private static void createUser(){
        Profile tProfile = [SELECT Id  FROM   Profile  WHERE  Name = 'System Administrator'];
        List<User> userList = [SELECT id, ManagerId,User_Territory_Code__c from User where isActive=true and ManagerId != null and Manager.isActive=true AND User_Territory_Code__c != null];
            
        User tUser1 = new User(
            Alias = 'standt', 
            Email = 'standarduser@testorg.com', 
            EmailEncodingKey = 'UTF-8', 
            LastName = 'Testing', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = tProfile.Id, 
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'testuser@sometestorg.com',
            ManagerId = userList[0].ManagerId,
            User_Territory_Code__c = userList[0].User_Territory_Code__c
        );
        INSERT tUser1;
        
        User tUser2 = new User(
            Alias = 'test2', 
            Email = 'standarduser@test.com', 
            EmailEncodingKey = 'UTF-8', 
            LastName = 'Testing2', 
            LanguageLocaleKey = 'en_US', 
            LocaleSidKey = 'en_US', 
            ProfileId = tProfile.Id, 
            TimeZoneSidKey = 'America/Los_Angeles', 
            UserName = 'testuser2@sometestorg.com',
            ManagerId = userList[0].ManagerId,
            User_Territory_Code__c = userList[0].User_Territory_Code__c
        );
        
        INSERT tUser2;
    }
}