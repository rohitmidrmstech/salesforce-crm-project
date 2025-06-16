/*********************************************************************************
* Test Class: {TestConvertedLeadTypeSync}
* Created by {Madan Vishwakarma}, Navivo, {DateCreated 05/13/2014}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - {Test ConvertedLeadTypeSync.Trigger}
----------------------------------------------------------------------------------
* Utility Test Data: {}
----------------------------------------------------------------------------------
* History:
* - VERSION DEVELOPER NAME DATE DETAIL FEATURES
1.0 Madan 05/13/2014 INITIAL DEVELOPMENT
2.0 Name MM/DD/YYYY UDAC WIRE FRAME CHANGES
3.0 Christian Belko 06/23/2017 UPDATED TEST DATA AS NEEDED FOR LEAD OBJECT.
*********************************************************************************/

@isTest(seeAllData=false) //Case 00199793 - NP [27 June 2017] SeeAllData true not required for the class
private class TestConvertedLeadTypeSync {

    static testMethod void myUnitTest() {
        Profile profiles=[Select Id From Profile Where Name='System Administrator'];
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        //Create User Object
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
        u.Country = 'Test';
        insert u;
        
        Account accountObject = new Account();
        accountObject.Name = 'TestAccount';
        //accountObject.Type = ' TestType';
        //accountObject.accountSource = 'TestSource';
        Insert accountObject ;
        
        RecordType rt = [select Id from RecordType where sObjectType = 'Lead' Limit 1];
            //create Lead Object
            Lead lObj = new Lead();
            lObj.LastName = 'test';
            lObj.FirstName = 'test';
            lObj.Company = 'test';
        	
        //START S-493803 [Hemant 9/8/2017] - Fix Test Failures
        lObj.Status = 'New';
        lObj.Phone = '6108374149';
            lObj.Type__c = 'Architect';
            lObj.RecordTypeId = rt.Id;
            lObj.City = 'test';
            lObj.State = 'test';
            lObj.Street = 'test';
        lObj.PostalCode = '01234';
        lObj.Country='US';
        //END S-493803 [Hemant 9/8/2017] - Fix Test Failures
            lObj.LeadSource = 'Dodge';
            insert lObj;
    
      System.runAs(u){
        //convert Lead 
        Database.LeadConvert lc = new database.LeadConvert();
            lc.setLeadId(lObj.id);
            lc.setDoNotCreateOpportunity(false);
            lc.setOwnerId(u.id);
            lc.setConvertedStatus('Qualified');
            
            Database.LeadConvertResult lcr = Database.convertLead(lc);
            System.assert(lcr.isSuccess());
        }
    }
}