// ==================================================================================
//   Object: batchOrderNumbers
//  Company: CertainTeed Siding
//   Author: Mohan Kumar (Threshold)
// Comments: Find the associated Orders matching the Order Number and set the Order 
//           field on a Case record.
// ==================================================================================
//  Changes: 2013-04-29 Initial version.
// ==================================================================================

global class batchOrderNumbers_Siding implements Database.Batchable<SObject>, Database.AllowsCallouts {
    
    global database.Querylocator start(Database.BatchableContext BC) {
        
        if(Test.isRunningTest()) {
            
            return Database.getQueryLocator([Select c.Order__c, c.Order_Number__c, c.Id From Case c Where Order_Number__c != null AND
                                            Order__c = null Limit 100 ]);
        }
         
        return Database.getQueryLocator([Select c.Order__c, c.Order_Number__c, c.Id From Case c Where Order_Number__c != null AND
                                            Order__c = null]);
    }
    
    global void execute(Database.BatchableContext BC,Sobject[] scope) {
        try { 
            Set<String> orderNumbers = new Set<String>();
            //group all the Order Numbers from the Case records
            for(sobject s : scope) {
                Case c = (Case)s;
                orderNumbers.add(c.Order_Number__c);
            }
            
            //fetch the Orders matching to the case Order Number and prepare a map out of it.
            List<Order> orderList = [Select o.Name, o.Id, o.Order_Num__c From Order o Where Order_Num__c IN :orderNumbers and Order_Num__c != null];
            Map<String, Id> orderNumberMap = new Map<String, Id>();
            for(Order o : orderList) {
                orderNumberMap.put(o.Order_Num__c, o.Id);
            }
            //populate the Order field on the Case if there was match found based on Order Number 
            List<Case> updateList = new List<Case>();
            for(sobject s : scope) {
                Case c = (Case)s;
                c.Order__c = orderNumberMap.get(c.Order_Number__c);
                updateList.add(c);
            }
            update updateList;
        } catch(Exception ex) {}
    }
    
    global void finish(Database.BatchableContext BC) {
 
    }
}