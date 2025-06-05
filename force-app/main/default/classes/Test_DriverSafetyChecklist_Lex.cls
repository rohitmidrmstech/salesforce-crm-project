/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class Test_DriverSafetyChecklist_Lex {
/**
 *	Purpose			:	This class is used to test functionality of class DriverSafetyChecklist_Lex.
 *
 *	Created By		:	Padmesh Soni (Appirio Offshore)
 *
 *	Created Date	:	11/7/2017
 *
 *	Current Version	:	V_1.0
 *
 *	Code Coverage	:	V_1.0 - 91%
 *
 *	Revision Log	:	V_1.0 - Created - S-523609
 **/
 
    static testMethod void myUnitTest() {
        
        Profile profiles=[Select Id From Profile Where Name='USA TM User'];
        
        User u = new User(Username =  'test' + Math.random() + '@test.org', ProfileId = profiles.Id, LastName = 'test', Alias = 'test1',
        					Email =  'test' + Math.random() + '@test.org', TimeZoneSidKey = 'America/Los_Angeles', localesidkey='en_US',
        					emailencodingkey='UTF-8', languagelocalekey='en_US');
        insert u;
        
        List<DriverSafetyChecklist__c> driverSafetyList = new List<DriverSafetyChecklist__c>();
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '1', Field_Name__c = 'Secures_seat_belt__c', Question__c	= '1. Secures seat belt.', 
        													Question_Type__c = 'Prior to the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '10', Field_Name__c = 'Obeys_all_posted__c', Question__c	= '10. Obeys all posted speed limits.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '11', Field_Name__c = 'Adjusts_speed_according__c', Question__c	= '11. Adjusts speed according to traffic flow, climate, and road conditions.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '12', Field_Name__c = 'Looks_well_ahead__c', Question__c	= '12. Looks well ahead and notices hazards.	', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '13', Field_Name__c = 'Safely_passes_other_vehicles__c', Question__c	= '13. Safely passes other vehicles, allowing plenty of room.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '14', Field_Name__c = 'Whenever_possible_keeps__c', Question__c	= '14. Whenever possible keeps two hands on the wheel.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '15', Field_Name__c = 'Keeps_vehicle_within_designated__c', Question__c	= '15. Keeps vehicle within designated driving lanes; does not swerve.	', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '16', Field_Name__c = 'Chooses_proper_lane__c', Question__c	= '16. Chooses proper lane when making right or left hand turns.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '17', Field_Name__c = 'Parks_vehicle_properly__c', Question__c	= '17. Parks vehicle properly within designated parking spaces, not blocking entrances, exits, fire zones, etc.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '2', Field_Name__c = 'Ensures_passenger_safety__c', Question__c	= '2. Ensures passenger safety and requires use of seat belts.', 
        													Question_Type__c = 'Prior to the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '3', Field_Name__c = 'Appears_alert__c', Question__c	= '3. Appears alert, focused, and not rushed, allowing plenty of time for the trip.', 
        													Question_Type__c = 'Prior to the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '4', Field_Name__c = 'Avoids_distractions__c', Question__c	= '4. Avoids distractions from audio and visual sources such as cell phones, maps, papers, or other passengers. When required wireless cell phone used	', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '5', Field_Name__c = 'Avoids_tailgating__c', Question__c	= '5. Avoids tailgating – allowing at least one car length for every 10 MPH.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '6', Field_Name__c = 'Uses_directional__c', Question__c	= '6. Uses directional signals prior to turns and lane changes (at least 100 feet on city streets and 300 feet on highways).', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '7', Field_Name__c = 'Stops_completely__c', Question__c	= '7. Stops completely and smoothly at all red lights and stop signs.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '8', Field_Name__c = 'Yields_to_pedestrians__c', Question__c	= '8. Yields to pedestrians at crosswalks, intersections, and school zones.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        driverSafetyList.add(new DriverSafetyChecklist__c(Name = '9', Field_Name__c = 'Drives_with_front_vehicle__c', Question__c	= '9. Drives with front vehicle lights on or with automatic running lights on.', 
        													Question_Type__c = 'During the trip, the Driver:'));
        
        insert driverSafetyList;
        							
        Test.startTest();
        			
        Driver_Safety__c driverSafety = DriverSafetyChecklist_Lex.getdriverSafety();
        List<DriverQuestionaireWrapper> questionaires = DriverSafetyChecklist_Lex.getDriverQuestionaires();
        
        for(DriverQuestionaireWrapper currentWrapper : questionaires) {
        	
        	currentWrapper.answer = '1';
        }
        
        String questionairesJSON = JSON.serialize(questionaires);
        driverSafety.Observer__c = 'Test';
        driverSafety.Date__c = Date.today().addDays(5);
        driverSafety.Driver__c = u.Id;
       
        
        try{
        DriverSafetyChecklist_Lex.submitValues(driverSafety, questionairesJSON);
        }
        catch(exception e){
            
        }
        List<Driver_Safety__c> driverSafeties = [SELECT Id FROM Driver_Safety__c];
        
        System.assert(driverSafeties.size() > 0);
        
        try {
        	
        	DriverSafetyChecklist_Lex.submitValues(driverSafety, null);
        } catch(Exception e) {
        	
        	System.assert(String.isNotBlank(e.getMessage()));
            system.debug('***Error Messgage****'+e.getCause());
        }
        
        Test.stopTest();
    }
}