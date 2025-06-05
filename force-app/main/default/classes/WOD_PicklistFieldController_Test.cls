/**
 * @description Test class for WOD_PicklistFieldController
*/
@isTest
public class WOD_PicklistFieldController_Test {
    /**
     * @description data set up and execution
    */
    public static testMethod void testPicklistValues(){
        Map<String,List<String>> FieldValMap = WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c',  'Country_BL__c', 'State_BL__c', true);
        System.assert(FieldValMap.containsKey('United States')==true, 'United States not found');
        System.assert(FieldValMap.get('United States').size()>0, 'United States\' states not found');
        
        FieldValMap = WOD_PicklistFieldController.getDependentOptions('WOD_2__Claim__c', 'WOD_2__Claim_Type__c', 'Country_BL__c', false);
        System.assert(FieldValMap.containsKey('Short Term')==true, 'Short Term not found');            
        System.assert(FieldValMap.get('Short Term').size()==2, 'US and Canada not found for Short Term');            
    }
    /**
     * @description data set up and execution
    */
    public static testMethod void testPicklistValues2(){
        WOD_PicklistEntryWrapper pw = new WOD_PicklistEntryWrapper();
        pw.active = 'Active';
        pw.defaultValue ='abc';
        pw.value ='xyz';
    }
}