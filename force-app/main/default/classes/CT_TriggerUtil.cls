/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* This is a utitlity class wherein code block which is long and repetitive is kept here
* and called in other apex classes.
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Gautam Kumar (gkumar@liquidhub.com)
* @verstion       1.0
* @created        2017-05-24
*/
public class CT_TriggerUtil {
    
    /*@return - map with key having unique combination of category and problem
     * value as the name of the custom setting record instance.
     * @description - create a unique combination string of category and problem
     * and create a map record with the unique string and the corresponding name as value.
     */
    public static Map<String, String> getIssuesCustomSettings(){
       //Variables Initialization & declaration. 
        Map<String, String> problemCodeMap = new Map<String, String>();
        
        for(CT_Issues_Problem_Code__c issueInfo : (CT_Issues_Problem_Code__c.getAll()).values()){
            string tempString = null;
            tempString = issueInfo.Category__c+'_'+issueInfo.Problem__c+'_'+issueInfo.Business_Unit__c; 
            problemCodeMap.put(tempString,issueInfo.name);
        }
        return problemCodeMap;
    } 
    
}