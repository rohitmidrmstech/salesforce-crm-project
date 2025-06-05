public class OppLineItemScheduleTriggerHandler {
    public static boolean isFirstRun = true;
    
    public static void updateOpportunityProducts(List<OpportunityLineItemSchedule> newList
                                                 //,Map<Id,OpportunityLineItemSchedule> oldMap
                                                ) {
        
        
        if(newList != null && newList.size() > 0) {
            set<string> oliIds = new set<string>();
            for(OpportunityLineItemSchedule oli : newList) {
                if(oli.OpportunityLineItemId != null && oli.ScheduleDate != null) {
                    oliIds.add(oli.OpportunityLineItemId);
                }
            }
            system.debug('--oliIds-->'+oliIds.size());
            
            if(oliIds.size() > 0) {
                Map<string,List<OpportunityLineItemSchedule>> oppProductVsOppScheduleMap = new Map<String,List<OpportunityLineItemSchedule>>();
                Map<string,date> oppProductVsDateMap = new Map<string,date>();
                
                for(AggregateResult agr : [select OpportunityLineItemId oli, MAX(ScheduleDate) schDate from OpportunityLineItemSchedule where OpportunityLineItemId in :oliIds GROUP BY OpportunityLineItemId]) {
                    oppProductVsDateMap.put((string)agr.get('oli'), (Date)agr.get('schDate'));
                }
                system.debug('--oppProductVsDateMap-->'+oppProductVsDateMap);
                
                if(oppProductVsDateMap.size() > 0) {
                    List<OpportunityLineItem> oliList = new list<OpportunityLineItem>();
                    for(string op : oppProductVsDateMap.keyset()) {
                        OpportunityLineItem oli = new OpportunityLineItem();
                        oli.id = op;
                        oli.Shipping_End_Date__c = oppProductVsDateMap.get(op);
                        oliList.add(oli);
                    }
                    system.debug('--oliList-->'+oliList.size());
                    
                    if(oliList.size() > 0) {
                        update oliList;
                    }
                }
                
                /*for(OpportunityLineItem o : [SELECT id, Shipping_End_Date__c, (select id, ScheduleDate, OpportunityLineItemId from OpportunityLineItemSchedules) from OpportunityLineItem where id in :oliIds]) {
for(OpportunityLineItemSchedule os : o.OpportunityLineItemSchedules) {
if(!oppProductVsOppScheduleMap.containskey(o.id))
oppProductVsOppScheduleMap.put(o.id, new list<OpportunityLineItemSchedule>());
oppProductVsOppScheduleMap.get(o.id).add(os);
}
}
system.debug('--oppProductVsOppScheduleMap-->'+oppProductVsOppScheduleMap.size());
if(oppProductVsOppScheduleMap.size() > 0) {
for(string i : oppProductVsOppScheduleMap.keyset()) {
if(oppProductVsOppScheduleMap.containskey(i) && oppProductVsOppScheduleMap.get(i).size() > 0) {
for(OpportunityLineItemSchedule o : oppProductVsOppScheduleMap.get(i)) {

} 
}
}
}*/
            }
            
        }
    }
}