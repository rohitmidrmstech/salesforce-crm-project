/**********************************************************************
Name: WOD_ClaimTriggerHandler
Copyright ? 2021  Tavant Technology Inc
==============================================================
===============================================================
Purpose: Trigger Handler Class for Claim.

-------                                                             
===============================================================
===============================================================
***********************************************************************/
public class WOD_OrderTriggerHandler extends WOD_TriggerHandler{
    
    Map<Id, Order> oldOrderMap;
    Map<Id, Order> newOrderMap;
    List<Order> newOrderList;
    /*
        Constructor
    */
    public WOD_OrderTriggerHandler (){
        oldOrderMap = (Map<Id, Order>)Trigger.oldMap;
        newOrderMap = (Map<Id, Order>)Trigger.newMap;
        newOrderList= ( List<Order>)Trigger.new;
    }
    
    public override void beforeInsert(){
        
    }
    public override void afterInsert(){
        onAfterInsert(newOrderList);
    }
    public override void beforeUpdate(){
        
    }
    
    public override void afterUpdate(){
        onAfterUpdate(newOrderMap, oldOrderMap);
    }
    
    public void onAfterInsert(List<Order> newList){
         set<id> OrderIds = new set<id>();
         for(Order Ord:newList){
                if(Ord.Sales_Org__c == '1502' || Ord.Sales_Org__c == '1018' || Ord.Sales_Org__c == '1019' || Ord.Sales_Org__c == '1020' || Ord.Sales_Org__c == '1102' || Ord.Sales_Org__c == '1501' /*|| ord.Sales_Org__c == '1111' || ord.Sales_Org__c == '1021'*/){ // CER-211
                    if( (Ord.Total_Cost__c != 0 && Ord.Total_Cost__c != null) 
                        || Ord.Planned_Ship_Date__c != null ){
                        OrderIds.add(Ord.id);
                        //system.debug(LoggingLevel.INFO,'**** Adding cost of ' + Ord.Total_Cost__c + ' to order id ' + Ord.id);
                    }
                }
         }
        //call Apex class to update total cost in Tavant Payment object. 
        if(OrderIds.size() > 0) {
           system.debug(LoggingLevel.INFO,'**** Calling TWOD_Payment_Cost_Update_Handler'); 
           WOD_Payment_Cost_Update_Handler.updatePaymentCost(OrderIds); 
        } 
    }
    
    public void onAfterUpdate(Map<Id, Order> newMap, Map<Id, Order> oldMap){
         set<id> OrderIds = new set<id>();
         for(Order Ord:newMap.values()){
                if(Ord.Sales_Org__c == '1502' || Ord.Sales_Org__c == '1018' || Ord.Sales_Org__c == '1019' || Ord.Sales_Org__c == '1020' || Ord.Sales_Org__c == '1102' || Ord.Sales_Org__c == '1501'/*|| ord.Sales_Org__c == '1111' || ord.Sales_Org__c == '1021'*/){ //CER-211
                    if( (Ord.Total_Cost__c != 0 && Ord.Total_Cost__c != null) 
                        || Ord.Planned_Ship_Date__c != null){
                        Order oldOrd = oldMap.get(Ord.Id);
                        if(Ord.Total_Cost__c != oldOrd.Total_Cost__c || Ord.Planned_Ship_Date__c != oldOrd.Planned_Ship_Date__c){
                            OrderIds.add(Ord.id);
                            //system.debug(LoggingLevel.INFO,'**** Updating cost from' + oldOrd.Total_Cost__c + ' to ' + Ord.Total_Cost__c + ' for order id ' + Ord.id);
                        } 
                     }   
                }    
            }
           //call Apex class to update total cost in Tavant Payment object. 
        if(OrderIds.size() > 0) {
           system.debug(LoggingLevel.INFO,'**** Calling TWOD_Payment_Cost_Update_Handler'); 
           WOD_Payment_Cost_Update_Handler.updatePaymentCost(OrderIds); 
        } 
    }
    
    
}