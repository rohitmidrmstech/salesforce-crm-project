/**
 * @description To pass selected Ids to Flow from Visual force page
*/
public class WOD_PassSelectedIdsToFlowVFController {
    public List<string> SelectedAccountIDs{get;set;}
    public list<WOD_Inspection__c> SelectedInspections{get;set;}
    public boolean recordsSelected{set;get;}
    /**
     * @description Contructor
    */
    public WOD_PassSelectedIdsToFlowVFController(ApexPages.StandardSetController listcontroller){
        SelectedAccountIDs = new List<string>();
            SelectedInspections = new list<WOD_Inspection__c>();
        
        for(WOD_Inspection__c ins : (WOD_Inspection__c[])listcontroller.getSelected()){
            SelectedAccountIDs.add(ins.Id);
        }
        if(SelectedAccountIDs.size() > 0){
            SelectedInspections = [Select id ,ownerId,Claim__c from WOD_Inspection__c where Id  IN:SelectedAccountIDs];
            recordsSelected = true;
        }
    }
}