public with sharing class DriverSafetyChecklist {
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
    
    public List<SelectOption> getAnswerOptions() {
        List<SelectOption> options = new List<SelectOption>(); 
        options.add(new SelectOption('1','')); 
        options.add(new SelectOption('2','')); 
        options.add(new SelectOption('3','')); 
        return options; 
    }    
    
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
                    
    public void setsecureSeatBelt(String secureSeatBelt) { this.secureSeatBelt = secureSeatBelt; }
    
    public DriverSafetyChecklist() {
        driverSafety = new Driver_Safety__c();
    }
    
    public Pagereference submitValues() {
        try {
            driverSafety.Secures_seat_belt__c = secureSeatBelt;
            driverSafety.Ensures_passenger_safety__c = ensurePassenger;
            driverSafety.Appears_alert__c = appearsAlert;
            driverSafety.Avoids_distractions__c = avoidDistraction;
            driverSafety.Avoids_tailgating__c = avoidTailgating;
            driverSafety.Uses_directional__c = userDirectional;
            driverSafety.Stops_completely__c = stopsCompletely;
            driverSafety.Yields_to_pedestrians__c = yieldsToPedestrians;
            driverSafety.Drives_with_front_vehicle__c = drivesWithFront;
            driverSafety.Obeys_all_posted__c = obeysAll;
            driverSafety.Adjusts_speed_according__c = adjustSpeed;
            driverSafety.Looks_well_ahead__c = looksWell;
            driverSafety.Safely_passes_other_vehicles__c = safelyPasses;
            driverSafety.Whenever_possible_keeps__c = wheneverPossible;
            driverSafety.Keeps_vehicle_within_designated__c = keepVehicle;
            driverSafety.Chooses_proper_lane__c = choosesProper;
            driverSafety.Parks_vehicle_properly__c = parksVehicle;
            insert driverSafety;
            sendMail(driverSafety.Driver__c, driverSafety.Id);
            Pagereference pr = new Pagereference('/'+driverSafety.Id);
            return pr;
        } catch(Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
            return null;
        }
    }
    
    public static void sendMail(String driverId, String redirectId) {
        try {
            User u = [Select Email from User where Id =: driverId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
            mail.setSubject('Driver Safety Audit');
           // mail.htmlBody = 'A new driver safety form has been entered for you. Click the link to view it.' + '<a href="'+URL.getSalesforceBaseUrl().toExternalForm()+ '/' + redirectId + '">' + URL.getSalesforceBaseUrl().toExternalForm() + '/' + redirectId + '</a>';
			 mail.htmlBody = 'A new driver safety form has been entered for you. Click the link to view it.' + '<a href="'+URL.getOrgDomainUrl().toExternalForm()+ '/' + redirectId + '">' + URL.getOrgDomainUrl().toExternalForm() + '/' + redirectId + '</a>';

            //mail.setToAddresses(new String[] {'arpit.vashishtha.developer@gmail.com'});
            mail.setToAddresses(new String[] {u.Email});
            Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});

        } catch(Exception e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
                ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
        }
    }
    
    public PageReference SwitchtoAnnual() {
         PageReference p = new PageReference('/apex/DriverSafetyChecklistAnnual');
         p.setRedirect(true);
         return p;
    }
}