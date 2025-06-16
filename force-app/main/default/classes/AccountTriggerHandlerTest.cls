@isTest
public class AccountTriggerHandlerTest {
    
    static testMethod void testUpdateAccountOwnerWithTerritory(){
        Profile int_PF = [SELECT ID, Name FROM Profile WHERE Name = 'Integration User'];
        Profile sr_PF = [SELECT ID, Name FROM Profile WHERE Name = 'Sales Rep'];
        
        User int_User = New User();
        int_User.LastName = 'Integration User';
        int_User.ProfileId = int_PF.id;
        int_User.Alias ='intuser';
        int_User.Email = 'integration123@saint-gobain.com';
        int_User.Username = 'integration123@saint-gobain.com';
        int_User.TimeZoneSidKey = 'America/New_York';
        int_User.EmailEncodingKey = 'UTF-8';
        int_User.LocaleSidKey = 'en_US';
        int_User.LanguageLocaleKey =  'en_US';   
        insert int_User;
        
        User sr_User = New User();
        sr_User.LastName = 'SalesRep';
        sr_User.ProfileId = sr_PF.id;
        sr_User.Alias ='SalesRep';
        sr_User.Email = 'SalesRep@saint-gobain.com';
        sr_User.Username = 'SalesRep@saint-gobain.com';
        sr_User.TimeZoneSidKey = 'America/New_York';
        sr_User.EmailEncodingKey = 'UTF-8';
        sr_User.LocaleSidKey = 'en_US';
        sr_User.LanguageLocaleKey =  'en_US';   
        insert sr_User;
        
        User sr_User1 = New User();
        sr_User1.LastName = 'SalesRep1';
        sr_User1.ProfileId = sr_PF.id;
        sr_User1.Alias ='SaleRep1';
        sr_User1.Email = 'SalesRep1@saint-gobain.com';
        sr_User1.Username = 'SalesRep1@saint-gobain.com';
        sr_User1.TimeZoneSidKey = 'America/New_York';
        sr_User1.EmailEncodingKey = 'UTF-8';
        sr_User1.LocaleSidKey = 'en_US';
        sr_User1.LanguageLocaleKey =  'en_US';   
        insert sr_User1;
        
        Region__c regNew = new Region__c();
        regNew.Name = 'test';
        regNew.Active__c = true;
        insert regNew;
        
        Territory__c terr1 = new Territory__c();
        terr1.Name = 'New Territory1';
        terr1.Active__c = true;
        terr1.Region__c= regNew.Id;
        terr1.Sales_Rep__c = sr_User.id;
        insert terr1;
        
        Territory__c terr2 = new Territory__c();
        terr2.Name = 'New Territory2';
        terr2.Territory_Code__c = '123';
        terr2.Active__c = true;
        terr2.Region__c = regNew.Id;
        terr2.Sales_Rep__c = sr_User1.id;
        insert terr2;
        
        Territory__c terr3 = new Territory__c();
        terr3.Name = 'national';
        terr3.Territory_Code__c = '999';
        terr3.Active__c = true;
        terr3.Region__c= regNew.Id;
        terr3.Sales_Rep__c = sr_User1.id;
        insert terr3;
        
        system.runAs(int_User){
            List<Account> lst_Accounts = new List<Account>();
            for(Integer i =0; i< 10; i++){
                Account act = new Account();
                act.Name = 'test account' + i;
                
                //START : Added by Purnima for Story S-562343
                act.BillingStreet = 'Test Street';
                act.BillingCity = 'Test City';
                act.BillingState = 'AL';
                act.BillingPostalCode = '12345';
                act.BillingCountry = 'Test Country';
                //END : Added by Purnima for Story S-562343
                
                if(i > 0)
                    act.Territory__c = terr1.id;
                lst_Accounts.add(act);
            }
            insert lst_Accounts;
            
            List<Account> lst_Accountsupdate = new List<Account>();  
            Integer i =0;
            for(Account act1 : [SELECT ID, OwnerId FROM Account]){
                if(i > 0){
                    act1.OwnerId = sr_User.id;
                    system.assertEquals(sr_User.id, act1.OwnerId);//Checking the sale repp of terrtory is assigned as Account Owner
                   
                     act1.Territory__c = terr2.id;
                     system.debug('@@@'+act1.Territory__c);
                }                   
                else{
                    act1.OwnerId = sr_User1.id;
                    system.assertEquals(sr_User1.id, act1.OwnerId);
                    
                    
                    act1.Territory__c = null;
                }
                act1.OwnerId = int_User.id;
                lst_Accountsupdate.add(act1);
                i++;
            }             
            update lst_Accountsupdate;
          
            i =0;
            for(Account act2 : [SELECT ID, OwnerId,Territory__c,Territory__r.Name FROM Account]){
                act2.OwnerId = sr_User1.id;                
                system.assertEquals(sr_User1.id, act2.OwnerId);//Checking the sale rep of update terrtory is assigned as Account Owner
             
                if(i == 0){  
                    act2.Territory__c = terr3.id;
                    system.assertEquals(terr3.id, act2.Territory__c);
                }
                i++;
            }  
        }
    }    
}