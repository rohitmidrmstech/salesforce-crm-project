/*********************************************************************************
* Test Class: {TestUserMessages}
* Created by {Yogesh Kumar}, Navivo, {DateCreated 05/13/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Test UserMessages Class}
----------------------------------------------------------------------------------
* Utility Test Data: {}
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Yogesh Kumar 05/13/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
*********************************************************************************/
@isTest
private class TestUserMessages {

    static testMethod void myUnitTest() {
        Test.startTest();
        UserRole  usrRole = new UserRole ();
        usrRole.Name = 'test - test';
        insert usrRole;
        Profile profiles=[Select Id From Profile Where Name='System Administrator'];
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        User u = new User();
        u.Username =  uniqueName + '@test' + orgId + '.org';
        u.LastName = 'test';
        u.Alias = 'test1';
        u.Email =  uniqueName + '@test' + orgId + '.org';
        u.CommunityNickname = 'test12';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.localesidkey='en_US';
        u.emailencodingkey='UTF-8';
        u.profileid=profiles.Id;
        u.languagelocalekey='en_US';
        u.Country__c = 'USA';
        u.UserRoleId = usrRole.Id;
      
        
        
        insert u; 
        System.runAs(u) {
            User_Messages__c uMessage = new User_Messages__c();
            uMessage.Name = 'test';
            uMessage.Country__c = 'USA';
            uMessage.Region__c = 'test';
            uMessage.Role__c = 'test';
            insert uMessage;
            UserMessages uMsg = new UserMessages();
        }
        Test.stopTest(); 
    }
}