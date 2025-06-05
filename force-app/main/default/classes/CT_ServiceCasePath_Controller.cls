public class CT_ServiceCasePath_Controller {   
    
    @AuraEnabled    
    public static Case getCaseData(String caseId){  
        Case c = [SELECT Id,RecordTypeId, RecordType.Name, Status, TM__c, RSM__c, Country__c, IsClosed, Supplier_Approver_Id__c,ZRE_Order_Number__c,Return_Date__c,   
                  Plant_Quality_Manager_Id__c, Plant_Manager_Id__c, Supplier__c, Manufacturing_Plant__c, Sales_Rep__c,Issue_Problem__c,Investigator__c,Logistics_Agree_Disagree__c,    
                  Settlement_Recommendation__c,Total_Case_Value__c, Settle_Action__c,Total_Credits__c,Total_Rebills__c,Warehouse__c,Pre_Approver_1b_Pricing__c,Comments_Plant_Manager__c,
                   Pre_Approver_1b_Agree_Disagree__c,Confidential__c, Comments_Logistics__c,VP__c, Corrective_Action__c, Owner.name,Planner__c,Plant_Manager__c,Plant_Manager_Agree_Disagree__c ,Secondary_Issue_Category__c,Third_Issue_Category__c,
                  CreatedBy.name, VP_Approved_Via_Email__c, Order_Type_Picklist__c,OwnerId,createdbyid FROM Case WHERE Id=:caseId]; 
                 
                   
        return c;   
    }   
    
    @AuraEnabled   
    public static List<CaseApprovalPath_Config__c> getApprovalPathData(String recordTypeId, String country,string OwnerId,string CreatedById,string caseId,string SecondaryIssueCategory){  
        List<CaseApprovalPath_Config__c> retList = new List<CaseApprovalPath_Config__c>();  
        List<CaseApprovalPath_Config__c> rList = new List<CaseApprovalPath_Config__c>();    
        string recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(recordTypeId).getname();   
        //add for MWB   
        Case c = [SELECT Id,RecordTypeId, RecordType.Name, Status, TM__c, RSM__c, Country__c, IsClosed, Supplier_Approver_Id__c,ZRE_Order_Number__c,Return_Date__c,Logistics_Agree_Disagree__c,    
                  Plant_Quality_Manager_Id__c, Plant_Manager_Id__c, Supplier__c,Comments_Logistics__c, Manufacturing_Plant__c, Sales_Rep__c,Issue_Problem__c,Investigator__c,Comments_Plant_Manager__c,  
                  Settlement_Recommendation__c, Planner__c,Plant_Manager__c,Secondary_Issue_Category__c,Third_Issue_Category__c,Total_Credits__c,Total_Rebills__c,  
                  Confidential__c, VP__c,Plant_Manager_Agree_Disagree__c, Corrective_Action__c,Warehouse__c,Pre_Approver_1b_Pricing__c,
                  Pre_Approver_1b_Agree_Disagree__c,VP_Approved_Via_Email__c, Order_Type_Picklist__c,OwnerId,(Select Category__c,Reporting_Index_Type__c, Problem__c FROM Issues__r), createdbyid 
                  FROM Case WHERE Id=:caseId];  
                     
        if(String.isNotEmpty(recordTypeId) && String.isNotEmpty(country)){     
            retList = [SELECT Id, AssigneeType__c, Field__c, Next_Status__c, Status__c, Status_Label__c, Value__c       
                       FROM CaseApprovalPath_Config__c WHERE RecordTypeId__c = 'Standard' AND Country__c = 'USA' ORDER BY Sort_Order__c ASC];  
        }   
            
        Map<string,List<CaseApprovalPath_Config__c>> issueMap= new Map<string,List<CaseApprovalPath_Config__c>>();  
        for(CaseApprovalPath_Config__c cc:[SELECT Id,Sort_Order__c , AssigneeType__c, Field__c, Next_Status__c,Status__c, Status_Label__c, Value__c 
                                           FROM CaseApprovalPath_Config__c WHERE RecordTypeId__c = 'Standard' AND Country__c = :country ORDER BY Sort_Order__c ASC])   
        {   
            if(!issueMap.containsKey(country)){ 
                issueMap.put(country, new List<CaseApprovalPath_Config__c>{cc});    
            }else{  
                issueMap.get(country).add(cc);  
            }   
        }   
            
        List<Issues__c> issueList = [select id,Problem__c from Issues__c where Case__c =:caseId limit 5];   
        if(issueList.size() > 0){   
            system.debug('caseid '+caseId); 
            for(Issues__c issue: issueList) 
            {   
                if( String.isNotEmpty(issue.Problem__c) && issue.Problem__c =='Service Charter Product Failure' &&  
                   String.isNotEmpty(recordTypeId) && String.isNotEmpty(country) && country =='Canada') 
                {   
                    retList= issueMap.get(country); 
                }   
            }         
        }   
        return retList;       
    }
}