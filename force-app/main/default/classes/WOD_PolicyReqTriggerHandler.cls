public class WOD_PolicyReqTriggerHandler extends WOD_TriggerHandler{
    Map<Id, Policy_Request__c> oldPlyReqMap;
    Map<Id, Policy_Request__c> newPlyReqMap;
    List<Policy_Request__c> newPlyReqList;
    
     public WOD_PolicyReqTriggerHandler(){
        oldPlyReqMap = (Map<Id, Policy_Request__c>)Trigger.oldMap;
        newPlyReqMap= (Map<Id, Policy_Request__c>)Trigger.newMap;
        newPlyReqList= ( List<Policy_Request__c>)Trigger.new;
    }
    //Added for CER-169.
    public override void afterInsert(){
        set<Id> plyreqIds = new set<Id>();
        if(newPlyReqList.size()>0){
            for(Policy_Request__c pr : newPlyReqList){
                if(pr.Claim__c !=null){
                    plyreqIds.add(pr.Id);
                }
            }
        }
        if(plyreqIds.size()>0){
            updateclminfoonplyreq(plyreqIds);
        }
    }
    /*public override void afterUpdate(){
        set<Id> plyreqIds = new set<Id>();
        if(newPlyReqList.size()>0){
            for(Policy_Request__c pr : newPlyReqList){
                if(pr.Claim__c !=null){
                    plyreqIds.add(pr.Id);
                }
            }
        }
        if(plyreqIds.size()>0){
            updateclminfoonplyreq(plyreqIds);
        }
    }*/
    //Added for CER-169.
    public static void updateclminfoonplyreq(set<Id> newPlyReqId){
        list<Policy_Request__c> udateply = new list<Policy_Request__c>();
        if(newPlyReqId.size()>0){
            list<Policy_Request__c> lstply =[SELECT Id,Claim__c,Claim__r.Phone__c,Date_of_Installation__c,Claim__r.Install_Date__c,
            Material_Description__c,Claim__r.Product_s_description__c,Total_Quantity_of_Complaint_Material__c,Claim__r.Total_Complaint_Quantity__c,
            Primary_Claim_Category_Description__c,Claim__r.Id,Claim__r.Primary_Defect_Code_Description__c,Lab_Recommendation__c,Claim__r.Lab_Status__c,
            Reject_Reason__c,Claim__r.Reject_Reason__c,Other_Reason__c,Claim__r.Other_Reason__c,Lab_Comments__c,Claim__r.Lab_Comments__c,
            Payee_Name__c , Claim__r.Check_Payable_to__c,Street_Address__c , Claim__r.Check_Address__c,City__c , Claim__r.Check_City__c,Check_State__c , 
            Claim__r.Check_State__c,Country__c , Claim__r.Check_Country__c,Zip_Code__c , Claim__r.Check_Zip_Code_Postal_Code__c,Check_Amount__c , 
            Claim__r.Check_Amount__c,Sold_To__c , Claim__r.Credit_Sold_To__c,Ship_To__c , Claim__r.Credit_Ship_To__c,Credit_Amount__c , 
            Claim__r.Credit_Amount__c,Sold_To_Party__c , Claim__r.Sold_To_Party__c,Ship_To_Party__c , Claim__r.Ship_To_Party__c,Shipping_Option__c,
            Claim__r.Shipping_Options__c,Contact_Name__c , Claim__r.Contact_Name__c,Contact_Phone__c , Claim__r.Contact_Phone__c,Contact_Email__c ,
             Claim__r.Contact_Email__c, Claim__r.Sales_Org__c,Claim__r.First_Name__c,Claim__r.Last_Name__c,Claim__r.ClaimType__c,Claim__r.Requested_Claim_Amount__c,
             Territory_Manager__c FROM Policy_Request__c WHERE  Claim__c !=null AND Id IN : newPlyReqId];
             Id currentuserId = UserInfo.getUserId();
             if(lstply.size()>0){
                 for(Policy_Request__c resp : lstply){
                    //resp.Claim__c = resp.Claim__r.Id;
                    if(currentuserId !=null){
                        resp.Territory_Manager__c = currentuserId;
                    }
                    resp.Owner_Name__c = resp.Claim__r.First_Name__c + ' ' + resp.Claim__r.Last_Name__c;
                    resp.Policy_Request_Type__c = resp.Claim__r.ClaimType__c;
                    resp.Original_Amount_Offered__c = resp.Claim__r.Requested_Claim_Amount__c;
                    resp.Date_of_Installation__c = resp.Claim__r.Install_Date__c;
                    resp.Material_Description__c = resp.Claim__r.Product_s_description__c;
                    resp.Total_Quantity_of_Complaint_Material__c = resp.Claim__r.Total_Complaint_Quantity__c;
                    resp.Primary_Claim_Category_Description__c = resp.Claim__r.Primary_Defect_Code_Description__c;
                    resp.Lab_Recommendation__c = resp.Claim__r.Lab_Status__c;
                    resp.Reject_Reason__c = resp.Claim__r.Reject_Reason__c;
                    resp.Other_Reason__c = resp.Claim__r.Other_Reason__c;
                    resp.Lab_Comments__c = resp.Claim__r.Lab_Comments__c;
                    resp.Payee_Name__c = resp.Claim__r.Check_Payable_to__c;
                    resp.Street_Address__c = resp.Claim__r.Check_Address__c;
                    resp.City__c = resp.Claim__r.Check_City__c;
                    resp.Check_State__c = resp.Claim__r.Check_State__c;
                    resp.Country__c = resp.Claim__r.Check_Country__c;
                    resp.Zip_Code__c = resp.Claim__r.Check_Zip_Code_Postal_Code__c;
                    resp.Check_Amount__c = resp.Claim__r.Check_Amount__c;
                    resp.Sold_To__c = resp.Claim__r.Credit_Sold_To__c;
                    resp.Ship_To__c = resp.Claim__r.Credit_Ship_To__c;
                    resp.Credit_Amount__c = resp.Claim__r.Credit_Amount__c;
                    resp.Sold_To_Party__c = resp.Claim__r.Sold_To_Party__c;
                    resp.Ship_To_Party__c = resp.Claim__r.Ship_To_Party__c;
                    resp.Shipping_Option__c = resp.Claim__r.Shipping_Options__c;
                    resp.Contact_Name__c = resp.Claim__r.Contact_Name__c;
                    resp.Contact_Phone__c = resp.Claim__r.Contact_Phone__c;
                    resp.Contact_Email__c = resp.Claim__r.Contact_Email__c;
                    udateply.add(resp);
                }
             }
        }
        system.debug('udateply: '+udateply);
        if(udateply.size()>0){
            update udateply;
        }
    }
}