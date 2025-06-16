/**
* -------------------------------------------------------------------------------------------------
* Order Trigger Handler class
* -------------------------------------------------------------------------------------------------
* @author         Gautam Kumar (gkumar@liquidhub.com) & Vincent Ip (vip@liquidhub.com)
* @verstion       1.0
* @created        2017-08-18
*/
public class CT_OrderTriggerHandler {
    
    public void afterInsertHandler(List<Order> newList){
        processOrderHeaderValues(newList);
    }


    // business logic
    public void processOrderHeaderValues(List<Order> insertedOrderList){
        
        List<OrderItem> upsertOrderItemList = new List<OrderItem>();
        Map<String, OrderItem> conditionMaterials = new Map<String, OrderItem>();
        List<Product2> upsertProductList = new List<Product2>();
        
        for(Order currOrder: insertedOrderList){
            
            //Check the header conditions field, if they have a value
            List<String> headerFields =  new List<String>{'Header_Condition_1__c','Header_Condition_2__c','Header_Condition_3__c',
                                                            'Header_Condition_4__c','Header_Condition_5__c','Header_Condition_6__c',
                                                            'Header_Condition_7__c','Header_Condition_8__c','Header_Condition_9__c',
                                                            'Header_Condition_10__c'};
            Integer i=0;
            for (String currFieldName : headerFields){
                i++;
                String headerValue = (String) currOrder.get(currFieldName);
                if (String.isNotEmpty(headerValue)){
                    OrderItem currOrderItem = processHeaderString(headerValue, currOrder,i);
                SYSTEM.DEBUG('+++++ currOrderItem: ' + currOrderItem);
                    upsertOrderItemList.add(currOrderItem);

                    // post process order
                    conditionMaterials.put(currOrderItem.Material__c+'-'+currOrder.Sales_Org__c, currOrderItem);
                }
            }
        }
        
        // check if the Products exist, otherwise create
        if (conditionMaterials.size()>0){
            List<Product2> existingProducts = [SELECT Id, SAP_Material__c, Sales_Org__c, ProductCode 
                                                FROM Product2
                                                WHERE SAP_Material__c in :conditionMaterials.keySet()];
            for (Product2 currProduct : existingProducts){
                conditionMaterials.remove(currProduct.SAP_Material__c);
            }
        }

        // if there are any remaining values
        if (conditionMaterials.size()>0){
            Map<Id, Order> orderMap = (Map<Id,Order>) Trigger.newMap;

            for (OrderItem currOrderItem : conditionMaterials.values()){
                Order currOrder = orderMap.get(currOrderItem.OrderId);

                Product2 newProduct = new Product2(
                    Name = currOrderItem.Material_Desc__c
                    ,ProductCode = currOrderItem.Material__c
                    ,Sales_Org__c = currOrder.Sales_Org__c
                    ,SAP_Material__c = (currOrderItem.Material__c+'-'+currOrder.Sales_Org__c)
                    ,isActive = true
                );
                upsertProductList.add(newProduct);
            }
        }

        if (upsertProductList.size()>0) upsert upsertProductList SAP_Material__c;
        if (upsertOrderItemList.size()>0){
            upsert upsertOrderItemList Line_External_ID__c;
        }
    }

    // use regex to split string for a bit more efficeincy (as opposed to split)
    // Header String format - [code] | [description] | [unit price]
    public OrderItem processHeaderString(String headerString, Order currOrder, Integer orderHeaderNum){
        Pattern headerCond = Pattern.compile('(.+)\\|(.+)\\|(.+)');
        
        OrderItem retOrderItem = null;
        Matcher headerMatcher = headerCond.matcher(headerString);
        if (headerMatcher.matches()){
            
            retOrderItem = new OrderItem();

            retOrderItem.Description = headerMatcher.group(2);
            retOrderItem.Material_Desc__c = retOrderItem.Description;
            retOrderItem.Material__c = headerMatcher.group(1);

            String unitPriceString = headerMatcher.group(3);
            if (unitPriceString.endsWith('-')) unitPriceString = '-'+unitPriceString.left(unitPriceString.length()-1);
            if (String.isNotEmpty(unitPriceString)){
                retOrderItem.UnitPrice = Decimal.ValueOf(unitPriceString);
                retOrderItem.Product_Price__c = Decimal.ValueOf(unitPriceString);
            } 

            retOrderItem.OrderId = currOrder.Id;
system.debug('+++++ currOrder.Order_Num__c + retOrderItem.Material__c+orderHeaderNum: ' + currOrder.Order_Num__c + '-' + retOrderItem.Material__c+'-'+orderHeaderNum);
            retOrderItem.Line_External_ID__c = currOrder.Order_Num__c + '-' + retOrderItem.Material__c+'-'+orderHeaderNum;
        }
        return retOrderItem;
    }

}