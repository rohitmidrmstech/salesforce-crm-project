@isTest
Public Class FixedSlotsTest
{
    Public Static List<Account> lstAccounts = new List<Account>();
    Public Static Plants__c objWarehouse = new Plants__c();
    Public Static List<Warehouse_Slot__c> lstWarehouseSlots = new List<Warehouse_Slot__c>();
    Public Static List<Order> lstOrders = new List<Order>();
    Public Static List<Slot__c> lstSlot = new List<Slot__c>();
    

    Public Static TestMethod Void doSlottingControllerTest1()
    {
        
        InsertWarehouse();
        InsertAccounts();
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlot();
        //insertplant();
        
        //FixedSlots objFixedSlots = new FixedSlots();
        ApexPages.StandardController stdFixedSlots  = new ApexPages.StandardController(lstWarehouseSlots[0]);
        FixedSlots objFixedSlots = new FixedSlots(stdFixedSlots);
        objFixedSlots.strLeftSearch = 'Test';
        objFixedSlots.strRightSearch = 'Test';
        
        
        objFixedSlots.getDayOfWeek();
        objFixedSlots.getarrDayOfWeek();
        objFixedSlots.setarrDayOfWeek(objFixedSlots.getarrDayOfWeek());
        
        objFixedSlots.getAccountList();
        objFixedSlots.getFixedAccountList();
        
        objFixedSlots.strLeftSearch = '';
        objFixedSlots.strRightSearch = '';
        
        objFixedSlots.getAccountList();
        objFixedSlots.getFixedAccountList();
        
        objFixedSlots.FillWarehouseAccount();
        
        objFixedSlots.strWarehouse = objWareHouse.Id;
        objFixedSlots.getSelectAccountList();
        
        objFixedSlots.goLeftSearch();
        objFixedSlots.goRightSearch();
        
        objFixedSlots.getWarehouseList();
        
        objFixedSlots.strAccount = lstAccounts[0].id;
        objFixedSlots.AddFixedAccount();
        
        objFixedSlots.strSelectAccount = lstAccounts[0].id;
        objFixedSlots.objOrder.EffectiveDate= System.today();
        //objFixedSlots.objOrder.Ship_Date__c = System.today().addDays(5);
        objFixedSlots.objOrder.Planned_Ship_Date__c=System.today().addDays(5);
        objFixedSlots.strWarehouse = objWareHouse.Id;  
        String[] arrDayOfWeek = new String[]{};
        arrDayOfWeek.add('Sunday');
        arrDayOfWeek.add('Monday');
        objFixedSlots.setarrDayOfWeek(arrDayOfWeek);      
        objFixedSlots.CreateSlots();
                
        objFixedSlots.strSelectAccount = '';
        objFixedSlots.objOrder.EffectiveDate= System.today();
        //objFixedSlots.objOrder.Ship_Date__c = System.today().addDays(5);
         objFixedSlots.objOrder.Planned_Ship_Date__c=System.today().addDays(5);
        objFixedSlots.strWarehouse = objWareHouse.Id;        
        objFixedSlots.CreateSlots();
        
        objFixedSlots.strSelectAccount = lstAccounts[0].id;
        objFixedSlots.objOrder.EffectiveDate= null;
        //objFixedSlots.objOrder.Ship_Date__c = System.today().addDays(5);
         objFixedSlots.objOrder.Planned_Ship_Date__c=System.today().addDays(5);
        objFixedSlots.strWarehouse = objWareHouse.Id;        
        objFixedSlots.CreateSlots();
        
        objFixedSlots.strSelectAccount = lstAccounts[0].id;
        objFixedSlots.objOrder.EffectiveDate= System.today();
        //objFixedSlots.objOrder.Ship_Date__c = null;
        objFixedSlots.objOrder.Planned_Ship_Date__c=null;
        objFixedSlots.strWarehouse = objWareHouse.Id;        
        objFixedSlots.CreateSlots();
        
        objFixedSlots.strSelectAccount = lstAccounts[0].id;
        objFixedSlots.objOrder.EffectiveDate= System.today();
        //objFixedSlots.objOrder.Ship_Date__c = System.today().addDays(5);
         objFixedSlots.objOrder.Planned_Ship_Date__c=System.today().addDays(5);
        objFixedSlots.strWarehouse = '';        
        objFixedSlots.CreateSlots();
        
        objFixedSlots.strSelectAccount = lstAccounts[0].Id;
        objFixedSlots.objOrder.EffectiveDate= System.today();
        //objFixedSlots.objOrder.Ship_Date__c = System.today().addDays(5);
         objFixedSlots.objOrder.Planned_Ship_Date__c=System.today().addDays(5);
        objFixedSlots.strWarehouse = objWareHouse.Id;
        String[] arrDayOfWeekBlank = new String[]{};       
        objFixedSlots.setarrDayOfWeek(arrDayOfWeekBlank);   
        objFixedSlots.CreateSlots();
        
        objFixedSlots.strFixedAccount = lstAccounts[0].id;
        objFixedSlots.RemoveFixedAccount();
        
        FixedSlots.DateToString(System.today());
    }
    
    Public Static Void InsertAccounts()
    {
        
        Plants__c objplant= new Plants__c();
         objplant.Name='testing';
         objplant.SAP_Plant__c = 'SAP';
         insert objplant;
        
        Account objAccount = new Account();
        objAccount.Name = 'Test Account1';
        //objAccount.Status__c = 'Active';
        objAccount.Status__c= 'Active';
        objAccount.Fixed_Account__c = true;
        objAccount.Default_Plant__c = objWareHouse.Id;
        objAccount.Default_Plant__c=objplant.id;
        
        List<RecordType> lstRT = [SELECT ID,DeveloperName FROM RecordType WHERE SobjectType = 'Account' And DeveloperName = 'ReadOnlyBPCSRecord'];    //Commented by Purnima for Story S-562343
        //List<RecordType> lstRT = [SELECT ID,DeveloperName FROM RecordType WHERE SobjectType = 'Account' And DeveloperName = 'Customer'];        //Added by Purnima for Story S-562343
        if (lstRT.size() > 0) {
            objAccount.RecordTypeId = lstRT[0].Id;
        }
        
        lstAccounts.Add(objAccount);
        
        objAccount = new Account();
        //objAccount.Status__c = 'Active';
        objAccount.Status__c= 'Active';
        objAccount.Fixed_Account__c = false;
        objAccount.Name = 'Test Account2';
        
        if (lstRT.size() > 0) {
            objAccount.RecordTypeId = lstRT[0].Id;
        }
        
        lstAccounts.Add(objAccount);

        Insert lstAccounts;
    }
    
    Public Static Void InsertWarehouse()
    {
        objWareHouse.Name = 'Test Warehouse';
        objWareHouse.SAP_Plant__c = 'TW';
        objWareHouse.Maximum_Slots_Per_Day__c = 20;
        objWareHouse.Maximum_LTL_Orders_Per_day_Lead__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_day_Lead__c = 200;
        objWareHouse.Maximum_LTL_Orders_Per_Day_Rep__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_Day_Rep__c = 200;
        objWareHouse.Used_for_Slotting__c = true;
        Insert objWareHouse;
    }
    
    
    Public Static Void InsertWarehouseSlots()
    {
        
         Plants__c objplant= new Plants__c();
         objplant.Name='testing';
         objplant.SAP_Plant__c = 'SAP';
        objplant.Maximum_Slots_Per_Day__c = 10;
         insert objplant;
        system.debug('@@@@'+objplant);
        
        Warehouse_Slot__c objWarehouseSlot = new Warehouse_Slot__c();
        //objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Plant__c = objplant.Id;
        objWarehouseSlot.Slot_Type__c = 'TL';
        objWarehouseSlot.Slot_DOW__c = 'Monday';
        objWarehouseSlot.Delivers_DOW__c = 'Monday';
        objWareHouseSlot.Status__c = 'Active'; 
       // objWareHouseSlot.Plant__c=objplant.id; 
        system.debug('@@@@'+objWareHouseSlot.Plant__c);     
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);

        objWarehouseSlot = new Warehouse_Slot__c(); 
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'Flatbed';
        objWarehouseSlot.Slot_DOW__c = 'Tuesday';
        objWarehouseSlot.Delivers_DOW__c = 'Tuesday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Plant__c = objplant.Id;
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c(); 
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';
        objWarehouseSlot.Slot_DOW__c = 'Wednesday';
        objWarehouseSlot.Delivers_DOW__c = 'Wednesday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Plant__c = objplant.Id;
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
    }
    
    Public Static Void InsertOrders()
    {
        
        
         Plants__c objplant= new Plants__c();
         objplant.Name='testing';
         objplant.SAP_Plant__c = 'SAP';
         insert objplant;
        
        Order objOrders = new Order();
        objOrders.Order_Num__c = '012346';
        objOrders.Accountid= lstAccounts[0].Id;
        objOrders.Ship_Condition__c = 'LTL';
        objOrders.Pallet_Count__c = 100;
        objOrders.Status= 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c= objplant.Id;
        objOrders.Gross_Weight__c = 123.45;
        objOrders.EffectiveDate =date.today()+5;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c= '012347';
        objOrders.Accountid= lstAccounts[0].Id;
        objOrders.Ship_Condition__c = 'LTL';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status= 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c= objplant.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.EffectiveDate =date.today()+5;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c= '012348';
        objOrders.Accountid= lstAccounts[1].Id;
        objOrders.Ship_Condition__c = 'LTL';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status= 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c= objplant.Id;
        objOrders.EffectiveDate =date.today()+5;
        objOrders.Gross_Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c= '012349';
        objOrders.Accountid= lstAccounts[1].Id;
        objOrders.Ship_Condition__c = 'LTL';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status= 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c= objplant.Id;
        objOrders.EffectiveDate =date.today()+5;
        objOrders.Gross_Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        Insert lstOrders;
    }
    Public Static Void InsertSlot()
    {
        
        Plants__c objplant= new Plants__c();
         objplant.Name='testing';
         objplant.SAP_Plant__c = 'SAP';
         insert objplant;
        system.debug('@@@@'+objplant);
 
        
        Slot__c objSlot = new Slot__c();
        objSlot.Warehouse_Slot__c = lstWarehouseSlots[0].id;
        objSlot.Scheduled_Shipping_Date__c = System.today().addDays(2);
        objSlot.Plant__c = objplant.Id;
        lstSlot.add(objSlot);
        
        objSlot = new Slot__c();
        objSlot.Warehouse_Slot__c = lstWarehouseSlots[1].id;
        objSlot.Scheduled_Shipping_Date__c = System.today().addDays(3);
        objSlot.Plant__c= objplant.Id;
        lstSlot.add(objSlot);
        
        insert lstSlot;
    }
    
    
}