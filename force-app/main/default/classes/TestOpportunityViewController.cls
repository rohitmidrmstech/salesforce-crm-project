@isTest
private class TestOpportunityViewController {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
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
       
        Opportunity o = new Opportunity();
        o.Name = 'test opty';
        o.CloseDate = Date.today().addDays(20);
        o.StageName = 'Prospective Project';
        insert o;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(o);
        ApexPages.currentPage().getParameters().put('id', o.Id);
        OpportunityViewController oe = new OpportunityViewController(sc);
        oe.redirect();
    }
}