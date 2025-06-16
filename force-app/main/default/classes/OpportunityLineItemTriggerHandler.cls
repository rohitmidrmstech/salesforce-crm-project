public class OpportunityLineItemTriggerHandler {
    public static boolean isFirstRun = true;
    
    public static void createLineItemSchedule(set<string> oliIds) 
    {
        List<String> ipgProfiles = Label.IPG_Profiles.split(',');
        List<User> userList = [SELECT Id, Profile.Name FROM User WHERE Id =: UserInfo.getUserId()];
        
        if(userList.size() > 0) {
            if(ipgProfiles.contains(userList[0].Profile.Name)) {
                return;
            }
        }
        
        if(oliIds.size() > 0) 
        {
            List<OpportunityLineItem> oliList = new List<OpportunityLineItem>();
            Map<OpportunityLineItem,List<opportunityLineItemSchedule>> oliVsOliSchedulesList = new Map<OpportunityLineItem,List<opportunityLineItemSchedule>>();
            for(OpportunityLineItem oli : [select id,UnitPrice,discount, Created_Revenue_Schedules__c, Revenue_Per_Month__c, 
                                           Shipping_Start_Date__c,Shipping_End_Date__c , Total_Months_of_Shipping__c, 
                                           Quantity_Per_Month__c, Quantity, TotalPrice, Opportunity_Probability__c, 
                                           (select id, ScheduleDate, Revenue, Quantity, OpportunityLineItemId from opportunityLineItemSchedules) from OpportunityLineItem where id in :oliIds]) {
                oliList.add(oli);
                for(opportunityLineItemSchedule os : oli.opportunityLineItemSchedules) {
                    if(!oliVsOliSchedulesList.containskey(oli))
                        oliVsOliSchedulesList.put(oli, new list<opportunityLineItemSchedule>());
                    oliVsOliSchedulesList.get(oli).add(os);
                }
            }
            
            if(oliVsOliSchedulesList.size() > 0) 
            {
                List<opportunityLineItemSchedule> oliSchToDelete = new List<opportunityLineItemSchedule>();
                
                for(OpportunityLineItem ol : oliVsOliSchedulesList.keyset()) {
                    if(oliVsOliSchedulesList.containskey(ol) && oliVsOliSchedulesList.get(ol).size() > 0) {
                        for(opportunityLineItemSchedule ols : oliVsOliSchedulesList.get(ol)) 
                        {
                            oliSchToDelete.add(ols);
                        }
                    }
                }
                
                if(oliSchToDelete.size() > 0) {
                    delete oliSchToDelete;
                }
            }
            
            if(oliList.size() > 0) 
            {
                List<OpportunityLineItem> oliToUpdate = new List<OpportunityLineItem>();
                List<opportunityLineItemSchedule> oliSchToInsert = new List<opportunityLineItemSchedule>();
                
                for(OpportunityLineItem ol : oliList) {
                    Integer totalMonths = (Integer)ol.Total_Months_of_Shipping__c;
                    
                    for(integer i = 0; i < totalMonths - 1; i++) {
                        opportunityLineItemSchedule sch = new opportunityLineItemSchedule();
                        sch.OpportunityLineItemId = ol.id;
                        sch.Opportunity_Probability__c = ol.Opportunity_Probability__c;
                        sch.Revenue = ol.Revenue_Per_Month__c;
                        sch.Quantity = ol.Quantity_Per_Month__c;
                        sch.Type = 'Both';
                        sch.ScheduleDate = ol.Shipping_Start_Date__c.addMonths(i);
                        oliSchToInsert.add(sch);
                    }
                    
                    Decimal computedQunatity = ol.Quantity != null ? ol.Quantity_Per_Month__c * totalMonths : 0;
                    Decimal remainingPart = ol.Quantity != null ? (ol.Quantity - (computedQunatity).setScale(2)).abs() : 0;
                    Decimal lastQuantity = ol.Quantity > computedQunatity ? (ol.Quantity_Per_Month__c + remainingPart).setScale(2) : 
                    (ol.Quantity_Per_Month__c - remainingPart).setScale(2);
                                        
                    opportunityLineItemSchedule sch = new opportunityLineItemSchedule();
                    sch.OpportunityLineItemId = ol.id;
                    sch.Opportunity_Probability__c = ol.Opportunity_Probability__c;
                    
                    sch.Revenue = (ol.TotalPrice)  > (ol.Revenue_Per_Month__c * totalMonths) 
                                ? ol.Revenue_Per_Month__c + (ol.TotalPrice - (ol.Revenue_Per_Month__c * totalMonths))
                                : ol.Revenue_Per_Month__c - ((ol.Revenue_Per_Month__c * totalMonths ) - ol.TotalPrice);
                    
                    sch.Quantity = lastQuantity;
                    sch.Type = 'Both';
                    sch.ScheduleDate = ol.Shipping_End_Date__c;
                    oliSchToInsert.add(sch);
                    
                    OpportunityLineItem oliObj = new OpportunityLineItem();
                    oliObj.id = ol.id;
                    oliObj.Created_Revenue_Schedules__c = true;
                    oliToUpdate.add(oliObj);
                }
                
                if(oliSchToInsert.size() > 0) {
                    insert oliSchToInsert;
                }
                
                if(oliToUpdate.size() > 0) {
                    update oliToUpdate;
                }
            }
        }
    }
}