/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Trigger on OrderItem object. 
* 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author       Vincent Ip (vip@liquidhub.com)
* @version      1.0
* @created      2017-08-08
* 
* NOTE : the Trigger REQUIRES that a Standard Price Book exists. 
* (i.e. any price book marked with the "Is Standard Price Book" check box on)
*/
public with sharing class CT_OrderItemTriggerHandler {

    public CT_OrderItemTriggerHandler() {
    
    }

    // template methods ---------------------------------------------------------------------------
    public void beforeInsertHandler(List<OrderItem> newList){
        getStandardPriceBookEntry(newList);
        processItemConditions(newList);
        checkQuantity(newList);
    }
    
    public void beforeUpdateHandler(List<OrderItem> newList){
        processItemConditions(newList);
        checkQuantity(newList);
    }
    
    // business logic methods ---------------------------------------------------------------------
    public void getStandardPriceBookEntry(List<OrderItem> newList){

        // get the parent records so we know the SalesOrg info for each orderItem
        List<OrderItem> workingList = new List<OrderItem>();
        Set<Id> orderIdSet = new Set<Id>();
        Map<Id,Double> orderIdAndNetPriceAdjustmentMap = new Map<Id,Double>();
        
        for (OrderItem currOrderItem : newList){
            System.debug(currOrderItem);
            System.debug(currOrderItem.Material__c );
            if (currOrderItem.PriceBookEntryId==null){
                orderIdSet.add(currOrderItem.OrderId);
                workingList.add(currOrderItem);
            }
        }
        System.Debug('+++++orderIdSet:'+orderIdSet);

        Map<Id, Order> parentOrdersMap = new Map<Id, Order>(
            [SELECT id, Sales_Org__c from Order where Id in :orderIdSet]
        );
        System.Debug('+++++parentOrdersMap:'+parentOrdersMap);

        // pull the PriceBook entries
        Map<String, OrderItem> sapMaterialIdToOrderItemMap = new Map<String, OrderItem>();
        System.debug('workingList'+ workingList);
        for (OrderItem currOrderItem : workingList){
            Order parentOrder = parentOrdersMap.get(currOrderItem.OrderId);

            String sapMaterialId = currOrderItem.Material__c + '-' + parentOrder.Sales_Org__c;
            System.Debug('+++++sapMaterialId:'+sapMaterialId);
            sapMaterialIdToOrderItemMap.put(sapMaterialId, currOrderItem);
        }

        Set<String> sapMaterialIdSet = sapMaterialIdToOrderItemMap.keySet();
        system.debug(sapMaterialIdSet);
        Map<String, PriceBookEntry> materialIdToStdPbeMap = new Map<String, PriceBookEntry>();
        List<PriceBookEntry> standardPbeList = [SELECT Id, Product2Id, PriceBook2Id, Product2.SAP_Material__c
                                                FROM PriceBookEntry 
                                                WHERE Product2.SAP_Material__c in :sapMaterialIdSet AND PriceBook2.isStandard = true
                                                ];
        System.debug(standardPbeList);
        for (PriceBookEntry currPbe : standardPbeList){
            materialIdToStdPbeMap.put(currPbe.Product2.SAP_Material__c, currPbe);
        }
        System.Debug('materialIdToStdPbeMap:'+materialIdToStdPbeMap);

        // finally prefill the PBE field
        for (OrderItem currOrderItem : workingList){
            Order parentOrder = parentOrdersMap.get(currOrderItem.OrderId);

            String sapMaterialId = currOrderItem.Material__c + '-' + parentOrder.Sales_Org__c;
            PriceBookEntry currPbe = materialIdToStdPbeMap.get(sapMaterialId);
            if (currOrderItem!=null && currPbe!=null) currOrderItem.PriceBookEntryId = currPbe.Id;
            //Adding Test.isRunnig as PriceBook2.isStandard is always returned to false when using test.getStandardPriceBook
            if( !Test.isRunningTest() ){
                if (currPbe==null) currOrderItem.addError('Cannot find Salesforce product for SAP matererial Id:'+sapMaterialId);
            }
            
        }
    }
    
    public void processItemConditions(List<OrderItem> newList){
        for(OrderItem currOrderItem : newList){
            Decimal tempDecimal = calculateNetPriceAdjustment(currOrderItem);
            currOrderItem.Net_Value__c = tempDecimal;
            system.debug('G*G order net value'+currOrderItem.Net_Value__c);
        }
    }
    
    public Decimal calculateNetPriceAdjustment(OrderItem currOrderItem){
        Decimal retValue = 0.00;
        
        List<String> tempStringList = new List<String>();
        if(String.isNotEmpty(currOrderItem.Item_Condition_1__c)) tempStringList.add(currOrderItem.Item_Condition_1__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_2__c)) tempStringList.add(currOrderItem.Item_Condition_2__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_3__c)) tempStringList.add(currOrderItem.Item_Condition_3__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_4__c)) tempStringList.add(currOrderItem.Item_Condition_4__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_5__c)) tempStringList.add(currOrderItem.Item_Condition_5__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_6__c)) tempStringList.add(currOrderItem.Item_Condition_6__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_7__c)) tempStringList.add(currOrderItem.Item_Condition_7__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_8__c)) tempStringList.add(currOrderItem.Item_Condition_8__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_9__c)) tempStringList.add(currOrderItem.Item_Condition_9__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_10__c)) tempStringList.add(currOrderItem.Item_Condition_10__c);
        
        for(String s: tempStringList){
            // just find the last | and pull the data off of there
            Integer pipeIndex = s.lastIndexOf('|');
            System.debug('==================pipeIndex========='+pipeIndex);
            String valueString = s.substring(pipeIndex+1);
            System.debug('==================valueString========='+valueString);
            Boolean isNegative = false;
            if (valueString.contains('-')){
                isNegative = true;
                valueString = valueString.replace('-', '');
            }
            
            if(valueString.length()>0)
                {
            Decimal tempValue = Decimal.ValueOf(valueString);
                        
            if (isNegative) tempValue = -tempValue;

            retValue += tempValue;
            }
        }
        
        return retValue;
    }

    public void checkQuantity(LIst<OrderItem> newList){
        for (OrderItem currOrderItem : newList){
            if (currOrderItem.Quantity==null || currOrderItem.Quantity ==0 ) currOrderItem.Quantity = 1;
        }
    }
    
    @future
    public static void insertIssues(String issueListStr)
    {
        List<Issues__c> issueList = (List<Issues__c>)JSON.deserialize(issueListStr, List<Issues__c>.class);
        insert issueList;
    }
}