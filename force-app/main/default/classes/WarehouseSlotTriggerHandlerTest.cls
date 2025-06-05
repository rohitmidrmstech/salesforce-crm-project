@isTest
public class WarehouseSlotTriggerHandlerTest{
    
    Public Static List<Account> lstAccounts = new List<Account>();
    Public Static Plants__c objWarehouse = new Plants__c();
    Public Static Plants__c objPlants = new Plants__c();
    Public Static List<Warehouse_Slot__c> lstWarehouseSlots = new List<Warehouse_Slot__c>();
    Public Static List<SLot__c> lstSlot = new List<SLot__c>();
    
    Public Static TestMethod void createTestData1(){
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account1';
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();    //Added by Purnima for Story S-562343
        
        lstAccounts.Add(objAccount);         

        objAccount = new Account();
        objAccount.Name = 'Test Account2';
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();    //Added by Purnima for Story S-562343
        
        lstAccounts.Add(objAccount);

        INSERT lstAccounts;
        
        objWareHouse.Name = 'Test Warehouse';
        objWareHouse.Used_for_Slotting__c = true;
        objWareHouse.SAP_Plant__c = 'TW';
        objWareHouse.Maximum_Slots_Per_Day__c = 20;
        objWareHouse.Maximum_LTL_Orders_Per_day_Lead__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_day_Lead__c = 200;
        objWareHouse.Maximum_LTL_Orders_Per_Day_Rep__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_Day_Rep__c = 200;
        objWareHouse.Eliminate_Weekend__c = true;    //Added by Purnima for Story S-488382
        INSERT objWareHouse;
        
        //DateTime datet = DateTime.newInstance(2017,2,3,13,20,30);
        Plants__c plant2 = new Plants__c();
        plant2.City__c ='New York';
        plant2.Country__c ='USA';
        plant2.Warehouse_Status__c ='Active';
        plant2.Name ='Plant Test2';
        plant2.SAP_Plant__c = 'This is SAP Plant';
        plant2.Maximum_Slots_Per_Day__c = 5;
        insert plant2;
        
        Warehouse_Slot__c objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';         //Modified by Purnima for Story S-488382
        objWarehouseSlot.Slot_DOW__c = 'Monday';
        objWarehouseSlot.Delivers_DOW__c = 'Monday';
        objWareHouseSlot.Status__c = 'Active';
        objWareHouseSlot.Plant__c = '01I0V000002ZfnJ';
        objWareHouseSlot.Start_Date__c = Date.TODAY().addDays(1);
        objWarehouseSlot.Plant__c =plant2.Id;
        objWarehouseSlot.No_Of_Slots__c = 5;
        INSERT objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);

        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';
        objWarehouseSlot.Slot_DOW__c = 'Tuesday';
        objWarehouseSlot.Delivers_DOW__c = 'Tuesday';
        objWareHouseSlot.Status__c = 'Active';
        objWareHouseSlot.Start_Date__c = Date.TODAY().addDays(2);
        objWarehouseSlot.Plant__c =plant2.Id;
        INSERT objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';
        objWarehouseSlot.Slot_DOW__c = 'Wednesday';
        objWarehouseSlot.Delivers_DOW__c = 'Wednesday';
        objWareHouseSlot.Status__c = 'Active';
        objWareHouseSlot.Start_Date__c = Date.TODAY().addDays(3);
        objWarehouseSlot.Plant__c =plant2.Id;
        INSERT objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'TL';
        objWarehouseSlot.Slot_DOW__c = 'Thursday';
        objWarehouseSlot.Delivers_DOW__c = 'Thursday';
        objWareHouseSlot.Status__c = 'Active';
        objWareHouseSlot.Start_Date__c = Date.TODAY().addDays(4);
        objWarehouseSlot.Plant__c =plant2.Id;
        objWarehouseSlot.No_Of_Slots__c = 5;
        INSERT objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        //INSERT lstWarehouseSlots;
        SLot__c slot = new SLot__c();
        slot.Warehouse_Slot__c = objWarehouseSlot.Id;
        slot.Plant__c= plant2.Id;
        slot.Scheduled_Shipping_Date__c = Date.TODAY().addDays(2);
        insert slot;
        lstSlot.add(slot);
        
        slot = new SLot__c();
        slot.Warehouse_Slot__c = objWarehouseSlot.Id;
        slot.Plant__c= plant2.Id;
        slot.Scheduled_Shipping_Date__c = Date.TODAY().addDays(3);
        insert slot;
        lstSlot.add(slot);
        
        //INSERT lstSlot;
        
        Warehouse_Time_Off__c timeOff = new Warehouse_Time_Off__c(Name='test');
        timeOff.Repeats__c = true;
        timeOff.Time_Off_Date__c = Date.TODAY().addDays(2);
        timeOff.Time_Off_Type__c = 'Holiday';
        timeOff.Plant__c = plant2.Id;
        insert timeOff;
        
        Slot_Account__c objSlotAccount = new Slot_Account__c ();
        objSlotAccount.Slot__c = slot.Id; 
        objSlotAccount.Account__c = objAccount.Id;
        UPSERT objSlotAccount;
        

        WarehouseSlotTriggerHandler.createSlotsForWarehouseSlots(lstWarehouseSlots);
        WarehouseSlotTriggerHandler.createNextSlots(lstWarehouseSlots);
        //WarehouseSlotTriggerHandler.findComingDay('EEEE');
        //Date stDate = WarehouseSlotTriggerHandler.findComingDay('EE',objWareHouseSlot.Start_Date__c);
        WarehouseSlotTriggerHandler.createSlotForActiveWHSlots(lstWarehouseSlots);
    }
}