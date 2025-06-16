/**************************************************************************************************************
   Object: Warehouse_Time_Off__c
   Company: CertainTeed Siding
   Author: Mohan Kumar (Huron)
   Date: 8/15/2015
   Requirement: 
   @future method to overcome the non selective query error
***************************************************************************************************************/
public with sharing class AIUWarehouseTimeOffHandler {
    
    @future
    public static void warehouseTimeOff(Set<Id> whTimeOffIds) {
        // Variables
        List<Slot__c> lstSlots = new  List<Slot__c>(); 
        Set<Date> setTimeOffDates = new Set<Date>();
        Set<Id> setWarehouseIds = new Set<Id>();
        //Start added on 12/20/2013
        Map<Id, Set<Date>> mapWarehouseIdTimeOffDates = new Map<Id, Set<Date>>();
        //End added on 12/20/2013
    
        for (Warehouse_Time_Off__c objWarehouseTimeOff : [Select Id, Time_Off_Date__c, Plant__c From Warehouse_Time_Off__c Where Id IN :whTimeOffIds]) {
            if (objWarehouseTimeOff.Time_Off_Date__c != null) {
                setTimeOffDates.Add(objWarehouseTimeOff.Time_Off_Date__c);
                setWarehouseIds.Add(objWarehouseTimeOff.Plant__c);
                //Start added on 12/20/2013
                Set<Date> setTimeOff = new Set<Date>();
                if (mapWarehouseIdTimeOffDates.Get(objWarehouseTimeOff.Plant__c) != null) {
                    setTimeOff = mapWarehouseIdTimeOffDates.Get(objWarehouseTimeOff.Plant__c);
                    setTimeOff.Add(objWarehouseTimeOff.Time_Off_Date__c);
                    mapWarehouseIdTimeOffDates.Put(objWarehouseTimeOff.Plant__c, setTimeOff);
                } else {
                    setTimeOff.Add(objWarehouseTimeOff.Time_Off_Date__c);
                    mapWarehouseIdTimeOffDates.Put(objWarehouseTimeOff.Plant__c, setTimeOff);
                }
                //End added on 12/20/2013
            }
        }
    
        if (setTimeOffDates != null && setTimeOffDates.Size() > 0) {
            for (Slot__c objSlot : [Select Id, Name, Order_Count__c, Plant__c, Scheduled_Shipping_Date__c from Slot__c where Plant__c In : setWarehouseIds and 
                                            Scheduled_Shipping_Date__c In : setTimeOffDates]) {
                //Start added on 12/20/2013
                if (mapWarehouseIdTimeOffDates.Get(objSlot.Plant__c) != null) {
                    Set<Date> setTimeOff = new Set<Date>();
                    setTimeOff = mapWarehouseIdTimeOffDates.Get(objSlot.Plant__c);
                    if (setTimeOff.Contains(objSlot.Scheduled_Shipping_Date__c)) {
                        lstSlots.Add(objSlot);
                    }
                }
                //End added on 12/20/2013
            }
            if (lstSlots.Size() > 0) {
                Delete lstSlots;
            }
        }
    }
}