/*********************************************************************************
* Test Class: {TestUpdateAccountsOnTMChange}
* Created by {Madan Vishwakarma}, Navivo, {DateCreated 07/08/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Testing of UpdateAccountsOnTMChange Trigger}
----------------------------------------------------------------------------------
* Utility Test Data: {}
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Madan 07/08/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
*********************************************************************************/

@isTest
private class TestUpdateAccountsOnTMChange {

    static testMethod void myUnitTest() {
        Profile profiles=[Select Id From Profile Where Name='System Administrator'];
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        //Create User Object
        User u1 = new User();
        u1.Username =  uniqueName + '@test' + orgId + '.org';
        u1.LastName = 'test';
        u1.Alias = 'test1';
        u1.Email =  uniqueName + '@test' + orgId + '.org';
        u1.CommunityNickname = 'test12';
        u1.TimeZoneSidKey = 'America/Los_Angeles';
        u1.localesidkey='en_US';
        u1.emailencodingkey='UTF-8';
        u1.profileid=profiles.Id;
        u1.languagelocalekey='en_US';
        u1.Country = 'Test';
        insert u1;
        
        //Create Territory__c Object
        Territory__c territoryObj1 = new Territory__c();
        territoryObj1.Territory_Code__c = 'Test MV1';
        territoryObj1.Sales_Rep__c = u1.Id;
        insert territoryObj1;
        
        //Create Account Object
        Account acc = new Account();
        acc.Name = 'Test MV2';
        acc.Territory__c = territoryObj1.Id;
        insert acc;
        
        //Update Territory Object
        Territory__c territoryObj2 = [Select Id, Sales_Rep__c from Territory__c where Id =: territoryObj1.Id Limit 1];
        territoryObj2.Sales_Rep__c = null;
        update territoryObj2;
        
        Account account = [select Id, LastModifiedDate from Account where Id =: acc.Id Limit 1];
        System.assertNotEquals(acc.LastModifiedDate, account.LastModifiedDate);
    }
    
}