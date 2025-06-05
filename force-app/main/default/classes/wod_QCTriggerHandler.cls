/*
ClassName    : WOD_QCTriggerHandler
CreatedOn    : 11/15/2021
Author		 : K Vishal
Description  : This is handler for WOD_QCTrigger
*/
public class wod_QCTriggerHandler {
    Public Static Void BeforeUpdate(list<WOD_QC__c> Updatedqc,map<id,WOD_QC__c>oldmap){
        for(WOD_QC__c qc: Updatedqc){
            WOD_QC__c oldvalue = oldmap.get(qc.Id);
            if(qc.Ownership_Type__c == 'First' && oldvalue.Ownership_Type__c == 'Second'){
                qc.Date_of_Transfer__c = null;
            }
        }   
    }
    Public Static Void AfterDelete(list<WOD_QC__c> deletedqc){
        set<id> claimid=new set<id> ();
        List<WOD_QC__c> qcList=new List<WOD_QC__c>();
        map<id,WOD_QC__c>qcmap=new map<id,WOD_QC__c>();
        list<WOD_2__Claim__c> updateclaim =new list<WOD_2__Claim__c>();
        for(WOD_QC__c qc: deletedqc){
            if(qc.Active__c){
             claimid.add(qc.Claim__c) ;
                qcmap.put(qc.Claim__c,qc);
            }
            
        }
        list<WOD_2__Claim__c> claimlist= [select id,WOD_2__Claim_Status__c,Country_BL__c,Install_Date__c,Transferred_Date__c,Defect_Details__c,WOD_2__Warranty_Product__c,OwnershipType__c,Plant__c,Plant_Code__c,Product_Group__c,Tape_Code_A__c,Tape_Code_B__c,Tape_Code_C__c,Quantity__c,material_quantity__c,Primary_Defect_Code__c,Secondary_Defect_Code__c,Status_of_third_party_appeal__c,Lab_Status__c,Reject_Reason__c,Other_Reason__c,Lab_Comments__c,Photo_Comments__c,IsShortTermClmUpd__c,WOD_2__Claim_Type__c from WOD_2__Claim__c where id in :claimid ];
        for(WOD_2__Claim__c clist: claimlist){
            
            if(qcmap.containskey(clist.Id)){
                
                if(clist.WOD_2__Claim_Status__c=='Claim' || clist.WOD_2__Claim_Status__c=='Closed'){	
                    system.debug('inside if claim status::' + clist.WOD_2__Claim_Status__c);
                    	WOD_QC__c qcObj = qcmap.get(clist.Id);
                    	qcObj.addError('Can not delete QC if the claim status is Claim or Closed');                   	
                	
           		}
                else {
                
                if(clist.WOD_2__Claim_Type__c !='Short Term'){
                    clist.Install_Date__c=null;
                clist.Transferred_Date__c=null;
                clist.Defect_Details__c=null;
                clist.WOD_2__Warranty_Product__c=null;
                clist.OwnershipType__c=null;
                clist.Plant__c=null;
                    clist.Plant_Code__c=null;
                clist.Product_Group__c=null;
                clist.Tape_Code_A__c=null;
                clist.Tape_Code_B__c=null;
                clist.Tape_Code_C__c=null;
                clist.Quantity__c=null;
                clist.material_quantity__c=null;
                clist.Primary_Defect_Code__c=null;
                clist.Secondary_Defect_Code__c=null;
                clist.Status_of_third_party_appeal__c=null;
                clist.Lab_Status__c=null;
                clist.Reject_Reason__c = null;
                clist.Other_Reason__c = null;
                clist.Lab_Comments__c = null;
                clist.Photo_Comments__c = null;
                }
               // updateclaim.add(clist);
            
            if(clist.WOD_2__Claim_Type__c =='Short Term'){
                clist.Primary_Defect_Code__c=null;
                clist.Secondary_Defect_Code__c=null;
                clist.Lab_Status__c=null;
               
                clist.Reject_Reason__c = null;
                clist.Other_Reason__c = null;
                clist.Lab_Comments__c = null;
                clist.Photo_Comments__c = null;               
                clist.IsShortTermClmUpd__c = false;
            }
               updateclaim.add(clist);
                }
            }
        }
        if(updateclaim!=null && updateclaim.size()>0){
        update updateclaim;
        }
        
    }

}