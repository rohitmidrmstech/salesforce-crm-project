@isTest
public class TestbiuWtu {
    
     static testMethod void createWeeklyTerritoryUpdate() {
         Weekly_Territory_Update__c obj_WTU = new Weekly_Territory_Update__c();
         obj_WTU.Notes__c = 'Test Notes';
         insert obj_WTU;
     }

}