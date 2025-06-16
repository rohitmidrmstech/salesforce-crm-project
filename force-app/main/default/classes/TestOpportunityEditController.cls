@isTest
private class TestOpportunityEditController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
        List<RecordType > recordTypes = [SELECT Id, Name FROM RecordType where sobjectType = 'opportunity'];
        Profile p = [SELECT Id FROM Profile WHERE Name = 'System Administrator'];
        // Create a new System Administrator user.
        User u = new User();
        u.Email = 'email1@email.com';
        u.Alias = 'Alias2';
        u.TimeZoneSidKey = 'America/New_York';
        u.LocaleSidKey = 'ca';
        u.EmailEncodingKey = 'UTF-8';
        u.ProfileId = p.id;
        u.LanguageLocaleKey = 'en_US';
        u.FirstName = 'firstname1';
        u.LastName = 'lastname1';
        u.username= 'username1@first.com';
        insert u;
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test opty';
        opp.CloseDate = Date.today().addDays(20);
        opp.StageName = 'Prospective Project';
        opp.RecordTypeId = recordTypes[0].id;
        insert opp;
        system.debug('Opportunit----'+opp);     
       	
        PageReference pageRef = ApexPages.currentPage();// = Page.OpportunityEdit;
        pageRef.getParameters().put('id',opp.Id);
        pageRef.getParameters().put('RecordType',recordTypes[0].id);
        test.setCurrentPageReference(pageRef);
      
        
       /* Test.setCurrentPage(Page.OpportunityEdit);
		ApexPages.currentPage().getParameters().put('RecordType',recordTypes[0].id);
        ApexPages.currentPage().getParameters().put('id', o.Id); */
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);
       
        OpportunityEditController oe = new OpportunityEditController(sc);
        oe.checkUserRegion();
        oe.doSave();
    }
}