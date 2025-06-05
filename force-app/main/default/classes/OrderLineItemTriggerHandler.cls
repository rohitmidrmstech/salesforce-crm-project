public class OrderLineItemTriggerHandler {       
    Static Set<String> set_ProductCodes = new Set<String>();                    //the set of Material__c values on the orderItems
    Static Map<String,Product2> map_Products  = new Map<String, Product2>();    //not used
    Static Set<Id> set_OrderIds = new Set<Id>();                                //orderIds is the set of orders referenced by   
    //Static Map<String,Order> map_Orders;                                      //map of Id to Name on the referenced orders
    public static void processItemConditions(List<OrderItem> newList){ 
        
            
        /*
        for(OrderItem  currOrderItem : newList){        
            if(currOrderItem.Material__c != null && currOrderItem.Material__c!= ''){
                set_ProductCodes.add(currOrderItem.Material__c);                
            }      
            set_OrderIds.add(currOrderItem.Order_Num__c);
        }
        */
        //for(Product2 prod : [SELECT ID,Name,ProductCode, Stocking_to_Selling_Conversion_Factor__c FROM Product2 Where ProductCode in: set_ProductCodes]){
           // map_Products.put(prod.Product_Type_Code__c + '-' + prod.Sales_Org__c, prod);
        //}
        for(OrderItem currOrderItem : newList){        
            calculateUnitPriceandExtendedAmount(currOrderItem);  
            calculateExtendedQuantity(currOrderItem);
        }
    }
    private static void calculateUnitPriceandExtendedAmount(OrderItem currOrderItem){
        Decimal tempExtendedAmount = 0.00;      
        Decimal tempUnitPrice = 0.00;   
        Decimal tempListPrice = 0.00;
        List<String> tempStringList = new List<String>();
        if(String.isNotEmpty(currOrderItem.Item_Condition_1__c))   tempStringList.add(currOrderItem.Item_Condition_1__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_2__c)) tempStringList.add(currOrderItem.Item_Condition_2__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_3__c)) tempStringList.add(currOrderItem.Item_Condition_3__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_4__c)) tempStringList.add(currOrderItem.Item_Condition_4__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_5__c)) tempStringList.add(currOrderItem.Item_Condition_5__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_6__c)) tempStringList.add(currOrderItem.Item_Condition_6__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_7__c)) tempStringList.add(currOrderItem.Item_Condition_7__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_8__c)) tempStringList.add(currOrderItem.Item_Condition_8__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_9__c)) tempStringList.add(currOrderItem.Item_Condition_9__c);
        if(String.isNotEmpty(currOrderItem.Item_Condition_10__c)) tempStringList.add(currOrderItem.Item_Condition_10__c );
        String valueString = '';   
        String strCode = '';
        Boolean isNegative = false;
        Boolean isPercent = false;
        String[] str;
        for(String s: tempStringList){
            // just find the last | and pull the data off of there      
            str = s.split('\\|');     
            isNegative = false;
            isPercent = false;
            if(str.size()>2){                
                valueString = str[2];
                valueString = valueString.trim();
                strCode = str[0];
                strCode = strCode.trim();
                if(str.size()>3){    
                    if(str[3].trim() == '%'){
                        isPercent = true;
                    }
                }
                if (valueString.contains('-')){
                    isNegative = true;
                    valueString = valueString.replace('-', '');
                }              
                //if(valueString != ''){    
                if(valueString != '' && strCode != 'ZFA1'){ //INC0807386 - Added by Sandip - 6/11/2020
                    Decimal tempValue = Decimal.ValueOf(valueString);
                    if(isPercent == true){
                        tempValue = tempUnitPrice * (tempValue/100);
                    }
                    if (isNegative) tempValue = -tempValue;
                    tempUnitPrice += tempValue;
                    //if(strCode == Constants.strZP00 || strCode == Constants.strZP01 ||  strCode == Constants.strZCON){
                        tempListPrice += tempValue;
                    //}                   
                }               
            }
            valueString = '';
            isNegative = false;
            if(str.size()>=6){  
                valueString = str[6];
                valueString = valueString.trim();
                if (valueString.contains('-')){
                    isNegative = true;
                    valueString = valueString.replace('-', '');
                }
                if(valueString != ''){
                    Decimal tempValue = Decimal.ValueOf(valueString);
                    if (isNegative) tempValue = -tempValue;
                    tempExtendedAmount += tempValue;
                }
                
            }
        }
        if(!tempStringList.IsEmpty()){
            currOrderItem.Extended_Amount__c = tempExtendedAmount;
            currOrderItem.UnitPrice = tempUnitPrice;
            currOrderItem.List_Price__c = tempListPrice;
        }
        if (currOrderItem.UnitPrice == null) currOrderItem.UnitPrice = 0;
        
    }   
    private static void calculateExtendedQuantity(OrderItem currOrderItem){
        if(currOrderItem.Material__c != null && currOrderItem.Material__c != ''){
            //order order = map_Orders.get(currOrderItem.Order_Num__c);
           // Product_Type__c prod = map_Products.get(currOrderItem.Item_Number__c + '-' + order.Sales_Org__c);
            Product2 prod = map_Products.get(currOrderItem.Material__c );
            if(prod != null && prod.Stocking_to_Selling_Conversion_Factor__c != null && currOrderItem.Qty_Ordered__c != null){
                currOrderItem.Extended_Quantity__c = currOrderItem.Qty_Ordered__c * prod.Stocking_to_Selling_Conversion_Factor__c;
            }
        }
    }
}