@isTest
private class TestDriverSafetyChecklist {

    static testMethod void myUnitTest() {
        Profile profiles=[Select Id From Profile Where Name='USA TM User'];
        
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000));
        String uniqueName = orgId + dateString + randomInt;
        
        User u = new User();
        u.Username =  uniqueName + '@test' + orgId + '.org';
        u.ProfileId = profiles.Id;
        u.LastName = 'test';
        u.Alias = 'test1';
        u.Email =  uniqueName + '@test' + orgId + '.org';
        u.TimeZoneSidKey = 'America/Los_Angeles';
        u.localesidkey='en_US';
        u.emailencodingkey='UTF-8';
        u.languagelocalekey='en_US';
        insert u;
        
        Driver_Safety__c ds = new Driver_Safety__c();
        ds.Date__c = System.today();
        ds.Driver__c = u.Id;
        insert ds;
        
        DriverSafetyChecklist dsc = new DriverSafetyChecklist();
        
        dsc.getAnswerOptions();
        dsc.getadjustSpeed();
        dsc.getappearsAlert();
        dsc.getavoidDistraction();
        dsc.getavoidTailgating();
        dsc.getchoosesProper();
        dsc.getdrivesWithFront();
        dsc.getensurePassenger();
        dsc.getkeepVehicle();
        dsc.getlooksWell();
        dsc.getobeysAll();
        dsc.getparksVehicle();
        dsc.getsafelyPasses();
        dsc.getsecureSeatBelt();
        dsc.getstopsCompletely();
        dsc.getuserDirectional();
        dsc.getwheneverPossible();
        dsc.getyieldsToPedestrians();
        dsc.submitValues();
        dsc.setsecureSeatBelt(null);
        dsc.submitValues();
        DriverSafetyChecklist.sendMail(u.ID,ds.Id);
    }
}