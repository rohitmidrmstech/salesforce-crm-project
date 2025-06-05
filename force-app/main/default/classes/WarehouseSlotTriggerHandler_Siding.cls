/*********************************************************************************
* Utility Class: WarehouseSlotTriggerHandler
* {Created by: Nupur Modi}, {Created date: 07/05/2013}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - Contains functions to handle the trigger and the batch for creating slots
----------------------------------------------------------------------------------
* Unit Test: TestWarehouseSlotTriggerHandler
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME        DATE            DETAIL FEATURES
    1.0      Nupur Modi            07/05/2013      INITIAL DEVELOPMENT
    2.0      Arpit(Navivo)         12/09/2014      Added a logic to check that slot created date exist in Warehouse_Time_Off__c or not. if not then create the slot else not
*********************************************************************************/
public Class WarehouseSlotTriggerHandler_Siding { 
    public Static Void createSlotsForWarehouseSlots(List<Warehouse_Slot__c> lstWarehouseSlot) {
        List<Slot__c> lstInsertSlots = New List<Slot__c>(); 
        List<Slot_Account__c> lstSlotAccounts = new List<Slot_Account__c>();
        
        Integer intNoOfWeeks;
        String strNoOfWeeks = System.Label.Number_of_Weeks;
        Map<String, Integer> mapWarehouseNameNoOfSlots = new Map<String, Integer>();
        if (strNoOfWeeks != '' && strNoOfWeeks.Contains(';')) {
            String[] arrNoOfSlots = strNoOfWeeks.Split(';');
            for (String strNumberOfSlots : arrNoOfSlots) {
                String[] arrNoOfSlot = strNumberOfSlots.Split(':');
                if (!mapWarehouseNameNoOfSlots.ContainsKey(arrNoOfSlot[0].Trim())) {
                    mapWarehouseNameNoOfSlots.Put(arrNoOfSlot[0].Trim(), Integer.ValueOf(arrNoOfSlot[1].Trim()));
                }
            }
        }
        List<Warehouse_Slot__c> lstWarehouseSlots = [Select Id, Plant__c, Plant__r.Name from Warehouse_Slot__c where Id in : lstWarehouseSlot];
        System.debug('lstWarehouseSlots========================================================'+lstWarehouseSlots.size());
        System.debug('lstWarehouseSlot========================================================'+lstWarehouseSlot.size());
        Map<Id, Integer> mapWarehouseIdNoOfSlots = new Map<Id, Integer>();
        for (Warehouse_Slot__c objWarehouseSlot : lstWarehouseSlots) {
            System.debug(mapWarehouseNameNoOfSlots.Get(objWarehouseSlot.Plant__r.Name)+'testest=================================');
            System.debug(mapWarehouseNameNoOfSlots.Get('Other')+'other===============================================================');
           
            if (mapWarehouseNameNoOfSlots.ContainsKey(objWarehouseSlot.Plant__r.Name)) {
                mapWarehouseIdNoOfSlots.Put(objWarehouseSlot.Plant__c, mapWarehouseNameNoOfSlots.Get(objWarehouseSlot.Plant__r.Name));
            } else {
                mapWarehouseIdNoOfSlots.Put(objWarehouseSlot.Plant__c, mapWarehouseNameNoOfSlots.Get('Other'));
            }
        }
        //mapWarehouseIdNoOfSlots contains the warehouse id and the number of rolling weeks for that warehouse

        Date dtCurrentDate = System.Today();
        for (Warehouse_Slot__c objWarehouseSlot : lstWarehouseSlot) {
            if (mapWarehouseIdNoOfSlots.ContainsKey(objWarehouseSlot.Plant__c)) {
                intNoOfWeeks = mapWarehouseIdNoOfSlots.Get(objWarehouseSlot.Plant__c);
                System.debug('intNoOfWeeks'+intNoOfWeeks);
            }
            Integer intNoSlotsForWHS = Integer.ValueOf(objWarehouseSlot.No_Of_Slots__c);
            Date whsStartDate = objWarehouseSlot.Start_Date__c;
            if(whsStartDate == null) whsStartDate = Date.today();
            Date dtComingDay = findComingDay(objWarehouseSlot.Slot_DOW__c, objWarehouseSlot.Start_Date__c);
            for (Integer intI = 0; intI < intNoOfWeeks; intI++) {
                for (Integer intCount = 1; intCount <= intNoSlotsForWHS; intCount++) {
                    Slot__c objSlot = New Slot__c();
                    objSlot.Plant__c = objWarehouseSlot.Plant__c;
                    objSlot.Warehouse_Slot__c = objWarehouseSlot.Id;
                    objSlot.Scheduled_Shipping_Date__c = dtComingDay;
                    lstInsertSlots.Add(objSlot);
                    if (math.mod(intCount, intNoSlotsForWHS) == 0) {
                        dtComingDay = dtComingDay.AddDays(7);
                    }
                }
            }
        }
        //List<Warehouse_Slot__c> lstWarehouseSlots = [Select Id  from Slot__c where Id in : lstInsertSlots];
        String strFixedWHAccount = System.Label.Fixed_Warehouse_Slot;
        List<RecordType> lstRTFixedWHAccount = New List<RecordType>([Select Id from RecordType
                                            where SobjectType = 'Warehouse_Slot__c' and DeveloperName =: strFixedWHAccount limit 1]);
        System.debug('This is Gopi Test (lstInsertSlots)'+lstInsertSlots.size());
        if (lstInsertSlots.Size() > 0) {
            //insert lstInsertSlots;
            upsert lstInsertSlots;
            
            List<Slot__c> lstInsertedSlots = New List<Slot__c>([Select Id, Warehouse_Slot__r.RecordTypeId, Warehouse_Slot__r.Account__c
                                                                    from Slot__c where Id in : lstInsertSlots]);                                                                    
            if (lstRTFixedWHAccount.Size() > 0) {
                for (Slot__c objSlot : lstInsertedSlots) {
                    if (objSlot.Warehouse_Slot__r.RecordTypeId == lstRTFixedWHAccount[0].Id && objSlot.Warehouse_Slot__r.Account__c != null) {
                        lstSlotAccounts.Add(new Slot_Account__c (Slot__c = objSlot.Id, Account__c = objSlot.Warehouse_Slot__r.Account__c));
                    }
                }
            }   
        }
        if (lstSlotAccounts.Size() > 0) {
            System.debug('================ lstSlotAccounts Inserted');
            //Insert lstSlotAccounts;
            upsert lstSlotAccounts;
        }
    }

    public Static Void createNextSlots(List<Warehouse_Slot__c> lstWarehouseSlots) {
        List<Slot__c> lstInsertSlots = New List<Slot__c>();
        List<Slot_Account__c> lstSlotAccounts = new List<Slot_Account__c>();

        

        Integer intNoOfWeeks;
        String strNoOfWeeks = System.Label.Number_of_Weeks;
        Map<String, Integer> mapWarehouseNameNoOfSlots = new Map<String, Integer>();
        if (strNoOfWeeks != '' && strNoOfWeeks.Contains(';')) {
            String[] arrNoOfSlots = strNoOfWeeks.Split(';');
            for (String strNumberOfSlots : arrNoOfSlots) {
                String[] arrNoOfSlot = strNumberOfSlots.Split(':');
                if (!mapWarehouseNameNoOfSlots.ContainsKey(arrNoOfSlot[0].Trim())) {
                    mapWarehouseNameNoOfSlots.Put(arrNoOfSlot[0].Trim(), Integer.ValueOf(arrNoOfSlot[1].Trim()));
                }
            }
        }
        Map<Id, Integer> mapWarehouseIdNoOfSlots = new Map<Id, Integer>();
        for (Warehouse_Slot__c objWarehouseSlot : lstWarehouseSlots) {
            if (mapWarehouseNameNoOfSlots.ContainsKey(objWarehouseSlot.Plant__r.Name)) {
                mapWarehouseIdNoOfSlots.Put(objWarehouseSlot.Plant__c, mapWarehouseNameNoOfSlots.Get(objWarehouseSlot.Plant__r.Name));
            } else {
                mapWarehouseIdNoOfSlots.Put(objWarehouseSlot.Plant__c, mapWarehouseNameNoOfSlots.Get('Other'));
            }
        }
        //mapWarehouseIdNoOfSlots contains the warehouse id and the number of rolling weeks for that warehouse
        
        List<Warehouse_Time_Off__c> lstWarehouseTimeOff = [Select Id,Time_Off_Date__c,Plant__c From Warehouse_Time_Off__c where Plant__c IN :mapWarehouseIdNoOfSlots.keyset()];
        Map<Id, List<Date>> mapWarehouseTimeOff = new Map<Id, List<Date>>();
        System.debug('lstWarehouseTimeOff---'+lstWarehouseTimeOff);
        
        for(Warehouse_Time_Off__c warehouseTimeOff : lstWarehouseTimeOff){
            if(warehouseTimeOff.Time_Off_Date__c != null) {
                List<Date> timeOffDates = mapWarehouseTimeOff.get(warehouseTimeOff.Plant__c);
                if(timeOffDates == null) timeOffDates = new List<Date>();
                timeOffDates.add(warehouseTimeOff.Time_Off_Date__c);
                mapWarehouseTimeOff.put(warehouseTimeOff.Plant__c, timeOffDates);
            }
            //mapWarehouseTimeOff.put(warehouseTimeOff.Id, new List<Warehouse_Time_Off__c>());
        }
        for (Warehouse_Slot__c objWarehouseSlot : lstWarehouseSlots) {
            if (mapWarehouseIdNoOfSlots.ContainsKey(objWarehouseSlot.Plant__c)) {
                intNoOfWeeks = mapWarehouseIdNoOfSlots.Get(objWarehouseSlot.Plant__c);
            }
            Integer intNoSlotsForWHS = Integer.ValueOf(objWarehouseSlot.No_Of_Slots__c);
            System.debug('==============intNoSlotsForWHS::::'+intNoSlotsForWHS+'------'+mapWarehouseTimeOff.get(objWarehouseSlot.Plant__c));

            Date dtComingDay;
            if (objWarehouseSlot.Slots__r.size() > 0){
                dtComingDay = objWarehouseSlot.Slots__r[0].Scheduled_Shipping_Date__c.AddDays(7);               
            } else{
                //Mohan 11/13/2014: commented the line that is adding 7 days and consider the current date as date coming day
                //dtComingDay = Date.today().AddDays(7);
                dtComingDay = Date.today();
            }
            Date dtToday = System.Today();
            Integer intDifferenceinDays = dtToday.daysBetween(dtComingDay);
            Integer intDifferenceinWeeks;
            if (intDifferenceinDays != 0) {
                intDifferenceinWeeks = intDifferenceinDays / 7;
            } else {
                intDifferenceinWeeks = 0;
            }
            Integer intWeeksToCreateSlots = intNoOfWeeks - intDifferenceinWeeks;
            System.debug('==============::::::'+intWeeksToCreateSlots+'::::::'+intNoOfWeeks+'::::::'+intDifferenceinWeeks);
            for (Integer intWeeks = 0; intWeeks < intWeeksToCreateSlots; intWeeks++) {
                for (Integer intSlots = 0; intSlots < intNoSlotsForWHS; intSlots++) {
                        // Arpit 12/09/2014: Added a logic to check that slot created date exist in Warehouse_Time_Off__c or not. if not then create the slot else not
                        List<Date> timeOffDates = mapWarehouseTimeOff.get(objWarehouseSlot.Plant__c);
                        Boolean timeOffFound = false;
                        for(Date timeOffDate : timeOffDates){
                            if(dtComingDay == timeOffDate){
                                timeOffFound = true; 
                                break;
                            }
                        }
                        if(timeOffFound) break;
                        Slot__c objSlot = New Slot__c();
                        objSlot.Plant__c = objWarehouseSlot.Plant__c;
                        objSlot.Warehouse_Slot__c = objWarehouseSlot.Id;
                        objSlot.Scheduled_Shipping_Date__c = dtComingDay;
    
                        lstInsertSlots.Add(objSlot);
                        System.debug('lstInsertSlots'+lstInsertSlots.size());
                }
                dtComingDay = dtComingDay.AddDays(7);
            }

        }
        String strFixedWHAccount = System.Label.Fixed_Warehouse_Slot;
        List<RecordType> lstRTFixedWHAccount = New List<RecordType>([Select Id from RecordType
                                            where SobjectType = 'Warehouse_Slot__c' and DeveloperName =: strFixedWHAccount limit 1]);
        if (lstInsertSlots.Size() > 0) {
             System.debug('lstInsertSlots'+lstInsertSlots.size());
            //Insert lstInsertSlots;
            //upsert lstInsertSlots;
            Database.UpsertResult[] sr = Database.upsert(lstInsertSlots,false);
            List<Slot__c> lstInsertedSlots = New List<Slot__c>([Select Id, Warehouse_Slot__r.RecordTypeId, Warehouse_Slot__r.Account__c
                                                                    from Slot__c where Id in : lstInsertSlots]);
            if (lstRTFixedWHAccount.Size() > 0) {
                for (Slot__c objSlot : lstInsertedSlots) {
                    if (objSlot.Warehouse_Slot__r.RecordTypeId == lstRTFixedWHAccount[0].Id && objSlot.Warehouse_Slot__r.Account__c != null) {
                        lstSlotAccounts.Add(new Slot_Account__c (Slot__c = objSlot.Id, Account__c = objSlot.Warehouse_Slot__r.Account__c));
                    }
                }
            }
        }
        if (lstSlotAccounts.Size() > 0) {
            System.debug('================ lstSlotAccounts');
            Insert lstSlotAccounts;
            //upsert lstSlotAccounts;
        }
    }

    public Static Date findComingDay(String strDay) {
        DateTime currentDate = System.Now();
        if (currentDate.format('EEEE') == strDay) {
            return currentDate.date();
        } else {
            while (currentDate.format('EEEE') != strDay) {
                currentDate = currentDate.addDays(+1);
            }
            return currentDate.date();
        }
    }
    
    //Mohan 08/22/2014: consider the Start Date instead of current date
    public Static Date findComingDay(String strDay, Date sDate) {
        DateTime currentDate;
        if(sDate != null) currentDate = Datetime.newInstance(sDate, Time.newInstance(0, 0, 0, 0));
        else currentDate = System.Now();
        if (currentDate.format('EEEE') == strDay) {
            return currentDate.date();
        } else {
            while (currentDate.format('EEEE') != strDay) {
                currentDate = currentDate.addDays(+1);
            }
            return currentDate.date();
        }
    } 
}