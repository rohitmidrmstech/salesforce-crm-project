/**************************************************************************************************
* Controller Class: BusinessPlanUtil
* Created by Arpit Vashishtha(Navivo), DateCreated: 12/04/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - Util Class for BusinessPlan
---------------------------------------------------------------------------------------------------
* Unit Test: BusinessPlanUtil
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME                 DATE            DETAIL FEATURES
    1.0      Arpit Vashishtha (Navivo)      12/04/2014      INITIAL DEVELOPMENT
**************************************************************************************************/

public without sharing class BusinessPlanUtil {
    
    public static Boolean processCalculation = true;
    public static Boolean hierarchyVariable = false;
    public static String userSelectedOnSendEmail = null;
    public static String mailComment = null;
    public static Integer year{get;set;}
    
    //---------------------method to set total value when page loads-----------------------------------------
     public static Decimal calculateTotals(Decimal q1, Decimal q2, Decimal q3, Decimal q4) {
        Decimal ttl = 0;
        if(q1 != null) ttl += q1;
        if(q2 != null) ttl += q2;
        if(q3 != null) ttl += q3;
        if(q4 != null) ttl += q4;
        return ttl;
    }
    
    //---------------------method to set % age value when page loads-----------------------------------------
    public static Decimal calculatePercent(Decimal d1, Decimal d2){
        Decimal percent = 0;
        System.debug('colNameincalper:::'+d1+'--'+d2);
        if(d1 != null && d2 != null && d2 != 0 && d1 != 0){
            percent = Math.floor((d1/d2)*100);
            return percent;
        }else{
            percent = 0;
            return percent;
        }
    }
    
    //-------------------method to upsert BP object-----------------------------------------------------------
    public static void saveBpUtil(List<Business_Plan__c> bplst){
        try{
            upsert bplst;
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Update failed'+e.getMessage())); 
        }
    }
    
    //-----------------------method to delete from BP---------------------------------------------------------
    public static void deleteBpUtil(Set<Id> delBpLst){
        try{
            delete [Select Id From Business_Plan__c Where Id IN :delBpLst];
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Delete failed'+e.getMessage())); 
        }
    }
    

}