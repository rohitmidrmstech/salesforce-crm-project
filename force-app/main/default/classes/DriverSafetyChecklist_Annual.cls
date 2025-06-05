public with sharing class DriverSafetyChecklist_Annual {
    public Driver_Safety__c driverSafety {get;set;}
    public String secureSeatBelt {get;set;}
    public String ensurePassenger {get;set;}
    public String appearsAlert {get;set;}
    public String avoidDistraction {get;set;}
    public String avoidTailgating {get;set;}
    public String userDirectional {get;set;}
    public String stopsCompletely {get;set;}
    public String yieldsToPedestrians {get;set;}
    public String drivesWithFront {get;set;}
    public String obeysAll {get;set;}
    public String adjustSpeed {get;set;}
    public String looksWell {get;set;}
    public String safelyPasses {get;set;}
    public String wheneverPossible {get;set;}
    public String keepVehicle {get;set;}
    public String choosesProper {get;set;}
    public String parksVehicle {get;set;}   
    public String auditduringyear {get; set;}
    
    public String cckitemexpired {get; set;}
    public String cckitemreplaced {get; set;}
    public String cckinVehicle {get; set;}
    public String cskitemreplaced {get; set;}
    public String cskitemexpired {get; set;}
    public String cskinVehicle {get; set;}
    public String needreplaced {get; set;} 
    public String donlenService {get; set;} 
    public String fakitemreplaced {get; set;} 
    public String fakitemexpired {get; set;} 
    public String fakinVehicle {get; set;} 
    public String gloves {get; set;} 
    public String hardhat {get; set;} 
    public String headlights {get; set;} 
    public String phoneinplace {get; set;} 
    public String safetyglasses {get; set;} 
    public String suspensionreplaced {get; set;} 
    public String steeltoeboots {get; set;} 
    public String tries {get; set;} 
    public String windshield {get; set;} 
    public String windshieldwipters {get; set;} 

    
    
    public List<SelectOption> getAnswerOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1','')); 
        options.add(new SelectOption('2','')); 
        //options.add(new SelectOption('3','')); 
        return options; 
    }
    
    public String getauditduringyear() {
        return auditduringyear;
    }
   
    public String getcckitemexpired() {
        return cckitemexpired;
    }
    
    public String getcckitemreplaced() {
        return cckitemreplaced;
    }
    
    public String getcckinVehicle() {
        return cckinVehicle;
    }
    
    public String getcskitemreplaced() {
        return cskitemreplaced;
    }
    
    public String getcskitemexpired () {
        return cskitemexpired;
    }
    
    public String getcskinVehicle() {
        return cskinVehicle;
    }
    
    public String getneedreplaced() {
        return needreplaced;
    }
    
    public String getdonlenService () {
        return donlenService;
    }
    
    public String getfakitemreplaced () {
        return fakitemreplaced;
    }
    
    public String getfakitemexpired () {
        return fakitemexpired;
    }
    
    public String getfakinVehicle () {
        return fakinVehicle;
    }
        
    public String getgloves () {
        return gloves;
    }
    
    public String gethardhat () {
        return hardhat;
    }
    
    public String getheadlights () {
        return headlights;
    }
    
    public String getphoneinplace () {
        return phoneinplace;
    }
    
    public String getsafetyglasses () {
        return safetyglasses;
    }
    
    public String getsuspensionreplaced () {
        return suspensionreplaced;
    }
    
    public String getsteeltoeboots () {
        return steeltoeboots;
    }
    
    public String gettries () {
        return tries;
    }
    
    public String getwindshield () {
        return windshield;
    }
    
    public String getwindshieldwipters () {
        return windshieldwipters;
    }
    
    //
    public String getsecureSeatBelt() {
        return secureSeatBelt;
    }
    
    public String getensurePassenger() {
        return ensurePassenger;
    }
    
    public String getappearsAlert() {
        return appearsAlert;
    }
    
    public String getavoidDistraction() {
        return avoidDistraction;
    }
    
    public String getavoidTailgating() {
        return avoidTailgating;
    }
    
    public String getuserDirectional() {
        return userDirectional;
    }
    
    public String getstopsCompletely() {
        return stopsCompletely;
    }
    
    public String getyieldsToPedestrians() {
        return yieldsToPedestrians;
    }
    
    public String getdrivesWithFront() {
        return drivesWithFront;
    }
    
    public String getobeysAll() {
        return obeysAll;
    }
    
    public String getadjustSpeed() {
        return adjustSpeed;
    }
    
    public String getlooksWell() {
        return looksWell;
    }
    
    public String getsafelyPasses() {
        return safelyPasses;
    }
    
    public String getwheneverPossible() {
        return wheneverPossible;
    }
    
    public String getkeepVehicle() {
        return keepVehicle;
    }
    
    public String getchoosesProper() {
        return choosesProper;
    }
    
    public String getparksVehicle() {
        return parksVehicle;
    }
    
    
                    
    //public void setsecureSeatBelt(String secureSeatBelt) { this.secureSeatBelt = secureSeatBelt; }
    
    public DriverSafetyChecklist_Annual() {
        driverSafety = new Driver_Safety__c();
        //driverSafety.Donlen_Service_Up_to_Date__c = FALSE;
    }
    
    public Pagereference submitValues() {
        //try {
            Id RecTypeId = Schema.SObjectType.Driver_Safety__c.getRecordTypeInfosByName().get('Annual Audit').getRecordTypeId();
            driverSafety.RecordTypeId = RecTypeId;
            System.debug('###Record TypeID: ' + RecTypeId);
            driverSafety.Audits_performed_during_year__c = auditduringyear == '1' ? TRUE : FALSE;
            driverSafety.CCK_Are_Items_expired__c = cckitemexpired == '1' ? TRUE : FALSE;
            driverSafety.CCK_Are_there_items_that_need_replaced__c = cckitemreplaced == '1' ? TRUE : FALSE;   
            driverSafety.CSK_Are_there_items_that_need_replaced__c = cskitemreplaced == '1' ? TRUE : FALSE;
            driverSafety.CSK_Are_Items_expired__c = cskitemexpired == '1' ? TRUE : FALSE; 
            driverSafety.CSK_in_vehicle__c = cskinVehicle == '1' ? TRUE : FALSE;
            driverSafety.CCK_in_vehicle__c = cckinVehicle == '1' ? TRUE : FALSE;
            driverSafety.Does_it_need_to_be_replaced__c = needreplaced == '1' ? TRUE : FALSE;
            driverSafety.Donlen_Service_Up_to_Date__c = donlenService == '1' ? TRUE : FALSE;
            driverSafety.FAK_Are_there_items_that_need_replaced__c = fakitemreplaced == '1' ? TRUE : FALSE;
            
            driverSafety.FAK_Are_Items_expired__c = fakitemexpired == '1' ? TRUE : FALSE;
            driverSafety.FAK_in_vehicle__c = fakinVehicle == '1' ? TRUE : FALSE;
            driverSafety.Gloves__c = gloves == '1' ? TRUE : FALSE;
            driverSafety.Hardhat__c = hardhat == '1' ? TRUE : FALSE;
            driverSafety.Headlights__c = headlights == '1' ? TRUE : FALSE;
            driverSafety.Phone_cradle_in_place__c = phoneinplace == '1' ? TRUE : FALSE;
            driverSafety.Safety_Glasses__c = safetyglasses == '1' ? TRUE : FALSE;
            driverSafety.Should_Suspension_be_replaced__c = suspensionreplaced == '1' ? TRUE : FALSE;
            driverSafety.Steel_Toes_Boots__c = steeltoeboots == '1' ? TRUE : FALSE;
            driverSafety.Tires__c = tries == '1' ? TRUE : FALSE;
            driverSafety.Windshield_cracks_chips_etc__c = windshield == '1' ? TRUE : FALSE;
            driverSafety.Windshield_Wipers__c = windshieldwipters == '1' ? TRUE : FALSE;
            
            if(Test.isRunningTest()){
                driverSafety.Driver__c = UserInfo.getUserId(); 
            }
            
            insert driverSafety;
            sendMail(driverSafety.Driver__c, driverSafety.Id);
            Pagereference pr = new Pagereference('/'+driverSafety.Id);
            return pr;
        //} catch(Exception e) {
        //    ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
        //    return null;
        //}
    }
    
    public static void sendMail(String driverId, String redirectId) {
        try {
            User u = [Select Email from User where Id =: driverId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            mail.setSubject('Annual Driver Safety Audit');
            mail.htmlBody = 'A new driver safety form has been entered for you. Click the link to view it.' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+ '/' + redirectId + '">' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + redirectId + '</a>';
            //mail.setToAddresses(new String[] {'arpit.vashishtha.developer@gmail.com'});
            mail.setToAddresses(new String[] {u.Email});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});

        } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        }
    }
    
    public PageReference SwitchtoRegular() {
         PageReference p = new PageReference('/apex/DriverSafetyChecklist');
         p.setRedirect(true);
         return p;
    }
}