/**
 * @description Class to get Claim information
*/
public class NewPolicyRequestController {
    
    /**
     * @description to get Claim record
     * @param claimId Claim Id
     * @return Wrapper with Claim record
    */
    @AuraEnabled
    public static WOD_2__Claim__c getClaim(Id claimId){
          System.debug('Claim Id in getClaim5: ' + claimId); // Debug Statement 5
        return  [select id,Phone__c,First_Name__c,Last_Name__c,Product_Color__c,Install_Date__c,ClaimType__c,WOD_2__Claim_Type__c,Number_of_sqs_Affected__c,
                 Requested_Claim_Amount__c,Approved_Claim_Amount__c,Product_s_description__c,Total_Complaint_Quantity__c,Primary_Defect_Code_Description__c,
                 Lab_Status__c,Lab_Comments__c,Reject_Reason__c,Check_Payable_to__c,Check_Address__c,Check_City__c,Check_Country__c,
                 Check_State__c,Check_Zip_Code_Postal_Code__c,Check_Amount__c,Credit_Sold_To__c,Credit_Ship_To__c,Credit_Amount__c,
                 Sold_To_Party__c,Ship_To_Party__c,Shipping_Options__c,Contact_Name__c,Contact_Email__c,Contact_Phone__c,Sales_Org__c       
                 FROM WOD_2__Claim__c where Id =:claimId];
    }
    
    /**
     * @description Check whether Policy Request is available
     * @param claimId Claim Id
     * @return Wrapper with Claim record
    */
    @AuraEnabled
    public static Boolean validatePolicyRequest(Id claimId){
         System.debug('Claim Id in validatePolicyRequest6: ' + claimId); // Debug Statement 6
        Boolean isValid = true;
        for(Policy_Request__c pr : [Select Id from Policy_Request__c where Claim__c =: claimId]){
            isValid = true; // changed for CER-169 from false to true.
        }
        return  isValid;
    }

}