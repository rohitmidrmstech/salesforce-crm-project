/**
 * @description Test class for WOD_PassSelectedIdsToFlowVFController
*/
@isTest(SeeAllData = false)
public class WOD_PassSelectedFlowVFControllerTest {
    /**
     * @description data set up and execution
    */
    public static testMethod void CTInventoryTransferControllerTest(){
        List<WOD_Inspection__c> isnList = new List<WOD_Inspection__c>();
    	WOD_Inspection__c inspection = new WOD_Inspection__c();
        insert inspection;
        isnList.add(inspection);
        ApexPages.StandardSetController stdSetController = new ApexPages.StandardSetController(isnList);
        stdSetController.setSelected(isnList);
        WOD_PassSelectedIdsToFlowVFController ext = new WOD_PassSelectedIdsToFlowVFController(stdSetController);
    }
}