/*********************************************************************************
* Trigger : TestWarehouseSlotTriggerHandler
* {Created by },{dateCreated 07/08/2013}
----------------------------------------------------------------------------------
* Purpose/Methods:
* - 
----------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME        DATE            DETAIL FEATURES
    1.0                            07/08/2013      INITIAL DEVELOPMENT
*********************************************************************************/
@isTest
private class TestWarehouseSlotTriggerHandler_Siding{

    Static testMethod void testCreateSlots(){
    
        Plants__c objWarehouse = InsertWarehouse();
        
        List<Warehouse_Slot__c> lstWarehouseSlots = InsertWarehouseSlots(objWarehouse.Id);
        Insert lstWarehouseSlots;
        
        List<Warehouse_Time_Off__c> lstWarehouseTimeOff = InsertWarehouseTimeOff(objWarehouse.Id);
        insert lstWarehouseTimeOff;
        Integer intWeeksToCreateSlots = 2;
        
        lstWarehouseSlots[0].Slot_DOW__c = 'Friday';
        lstWarehouseSlots[0].No_Of_Slots__c = 3;
        Update lstWarehouseSlots;
                
        Account objAccount = InsertAccounts();
        
        List<Slot__c> lstSLot = [SELECT ID,Scheduled_Shipping_Date__c FROM Slot__c WHERE Warehouse_Slot__c =: lstWarehouseSlots[1].Id LIMIT 1];
        
        if (lstSlot != null && lstSlot.size() > 0) {
            lstSlot[0].Scheduled_Shipping_Date__c = lstSlot[0].Scheduled_Shipping_Date__c.AddDays(-10);
            Update lstSLot[0];
        }
        WarehouseSlotTriggerHandler_Siding.createNextSlots(lstWarehouseSlots);
        WarehouseSlotTriggerHandler_Siding.findComingDay('Tuesday');
        CreateNextSlots_Scheduler objScheduler = New CreateNextSlots_Scheduler();
        objScheduler.execute(null);
        
    }
    
    Static testMethod void testDeleteWarehouseSlot(){
        Plants__c objWarehouse = InsertWarehouse();
        
        List<Warehouse_Slot__c> lstWarehouseSlots = InsertWarehouseSlots(objWarehouse.Id);
        Insert lstWarehouseSlots;
        
        Delete lstWarehouseSlots;
    }
        
    
    public static List<Warehouse_Time_Off__c> InsertWarehouseTimeOff(Id objWarehouseId){
         List<Warehouse_Time_Off__c> lstWarehouseTimeoff = new List<Warehouse_Time_Off__c>();
        
         Warehouse_Time_Off__c objWarehouseTimeoff = new Warehouse_Time_Off__c();
         objWarehouseTimeoff.Time_Off_Date__c = date.newInstance(2014,11,11);
         objWarehouseTimeoff.Name = 'test';
         objWarehouseTimeoff.Plant__c = objWarehouseId;
         objWarehouseTimeoff.Description__c = 'test Data';
         
         lstWarehouseTimeoff.add(objWarehouseTimeoff);
        
         return lstWarehouseTimeoff;
    }    
    
    
    Public Static Plants__c InsertWarehouse()
    {
        Plants__c objWareHouse = New Plants__c();
        objWareHouse.Name = 'Test Warehouse';
        objWareHouse.Used_for_Slotting__c = true;
        objWareHouse.SAP_Plant__c = 'TW';
        objWareHouse.Maximum_Slots_Per_Day__c = 20;
        objWareHouse.Maximum_LTL_Orders_Per_day_Lead__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_day_Lead__c = 200;
        objWareHouse.Maximum_LTL_Orders_Per_Day_Rep__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_Day_Rep__c = 200;
        Insert objWareHouse;
        Return objWareHouse;
    }
    
    Public Static List<Warehouse_Slot__c> InsertWarehouseSlots(Id objWarehouseId)
    {
        List<Warehouse_Slot__c> lstWarehouseSlots = New List<Warehouse_Slot__c>();
        
        Warehouse_Slot__c objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.recordTypeId = Schema.SObjectType.Warehouse_Slot__c.getRecordTypeInfosByName().get('Fixed Warehouse Slot').getRecordTypeId();
        objWarehouseSlot.Plant__c = objWarehouseId;
        objWarehouseSlot.Slot_Type__c = 'TL';
        objWarehouseSlot.Slot_DOW__c = 'Monday';
        objWarehouseSlot.Delivers_DOW__c = 'Monday';
        objWareHouseSlot.Status__c = 'Active';
        objWareHouseSlot.No_Of_Slots__c = 2;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        String strFixedWHAccount = System.Label.Fixed_Warehouse_Slot;
        List<RecordType> lstRTFixedWHAccount = New List<RecordType>([SELECT ID FROM RecordType
                                            WHERE SobjectType = 'Warehouse_Slot__c' AND DeveloperName =: strFixedWHAccount LIMIT 1]);
        
        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouseId;
        objWarehouseSlot.Slot_Type__c = 'TL';
        objWarehouseSlot.Slot_DOW__c = 'Tuesday';
        objWarehouseSlot.Delivers_DOW__c = 'Tuesday';
        objWareHouseSlot.Status__c = 'Active';
        objWareHouseSlot.No_Of_Slots__c = 2;
        
        Account objAccount = InsertAccounts();
        
        objWareHouseSlot.Account__c = objAccount.Id;
        
        if (lstRTFixedWHAccount.size() > 0) {
            objWareHouseSlot.RecordTypeId = lstRTFixedWHAccount[0].Id;
        }
        
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        Return lstWarehouseSlots;
    }
    
    Public Static Account InsertAccounts()
    {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account1';
        
        List<RecordType> lstRT = [SELECT ID,DeveloperName FROM RecordType WHERE SobjectType = 'Account' And Name = 'Indirect Accounts' ];
        if (lstRT.size() > 0) {
            objAccount.RecordTypeId = lstRT[0].Id;
        }
        
        objAccount.Fixed_Account__c = True;

        Insert objAccount;
        Return objAccount;
    }

}