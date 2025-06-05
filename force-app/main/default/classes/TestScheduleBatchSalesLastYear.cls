@isTest
private class TestScheduleBatchSalesLastYear {

    static testMethod void myUnitTest() {
        
       // User u1 = TestCaseUtil.sampleUser();
        
        //Account a1;
        //System.runAs(u1) {
           // a1 = TestCaseUtil.sampleAccount('Test Account1');
        //}
         Account a1 = new account();
        a1.Name ='Test';
        a1.Email__c ='test@cap.com';
        insert a1;
        
        Case c = new Case();
        c.AccountId = a1.Id;
        insert c;
         
         Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
         
         User usr = new User();
        usr.Alias = 'standt';
        usr.Email='teststandarduser2@testorg.com';
        usr.EmailEncodingKey='UTF-8';
        usr.LastName='Testing';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.ProfileId = p.Id;
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.UserName='teststandarduser2@testorg.com'; 
        //usr.Current_Campaign__c='MECH';
        insert usr;
        
                            
        Region__c region = new Region__c ();
        region.Name = 'Test Region';
        region.Regional_Sales_Manager__c = usr.Id;
        insert region;
        
        //Generate Territory
        Territory__c terr = new Territory__c();
        terr.Name = 'Test Territory';
        terr.Region__c= region.Id;
        insert terr;
         
         Order order = new Order();
        order.TM__c = usr.Id;
        order.Territory_ref__c= terr.Id;
        order.Sales_Org__c = '1003';
        //order.Manufacturing_Plant__c= pl.id;
        order.AccountId = a1.id;
        order.EffectiveDate = date.today();
        order.EndDate =date.today()+5;
        order.Status ='ORDER CREATED';
         insert order ;
         
         Invoice__c inv= new Invoice__c();
         inv.Order__c=order.id;
         insert inv;
        
       // c.Invoice_Number__c = inv.Invoice_Number__c;
        //c.Campaign__c ='';
       // update c;
        
 
        Test.StartTest();
        
        ScheduleBatchSalesLastYear cls = new ScheduleBatchSalesLastYear();
        
        SchedulableContext context;
        
        cls.execute(context);
    
        Test.StopTest();
    }
}