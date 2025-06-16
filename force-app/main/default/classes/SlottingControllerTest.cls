@isTest
Public Class SlottingControllerTest
{
    Public Static List<Account> lstAccounts = new List<Account>();
    Public Static Plants__c objWarehouse = new Plants__c();
    Public Static List<Warehouse_Slot__c> lstWarehouseSlots = new List<Warehouse_Slot__c>();
    Public Static List<Order> lstOrders = new List<Order>();

    Public Static TestMethod Void SlottingControllerTest1()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        SlottingController objSlottingController = new SlottingController();
        objSlottingController.getWarehouseList();
        objSlottingController.SelectWarehouse();
        objSlottingController.strWarehouse = objWareHouse.Id;

        List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            strSlotId = lstSlot[0].Id;

            Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
            Insert objSlotAccount;
            strSlotAccountId = objSlotAccount.Id;

            Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
            Insert objSlotOrder;
            strSlotOrderId = objSlotOrder.Id;

            objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            Insert objSlotOrder;
            
            ApexPages.currentPage().getParameters().Put('strSlotId', lstSlot[0].Id);
        }
        objSlottingController.SelectWarehouse();
        ApexPages.currentPage().getParameters().Put('strColor', '#EFEFEF');
        objSlottingController.SetSlotColor();

        lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strIPTSlotId', lstSlot[0].Id);
            ApexPages.currentPage().getParameters().Put('blnChecked', 'false');
            objSlottingController.AddSlotIdToSet();
            ApexPages.currentPage().getParameters().Put('blnChecked', 'true');
            objSlottingController.AddSlotIdToSet();
        }
        objSlottingController.NextDay();
        objSlottingController.PreviousDay();
    }
    Public Static TestMethod Void SlottingControllerTest2()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlottingMeansValidation();
        
        SlottingController objSlottingController = new SlottingController();
        objSlottingController.getWarehouseList();
        objSlottingController.strWarehouse = objWareHouse.Id;

        List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c,Slot_Type__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            strSlotId = lstSlot[0].Id;

            Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
            Insert objSlotAccount;
            strSlotAccountId = objSlotAccount.Id;

            Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
            Insert objSlotOrder;
            strSlotOrderId = objSlotOrder.Id;
            
            objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            Insert objSlotOrder;
        }
        objSlottingController.SelectWarehouse();
        objSlottingController.strSlotId = strSlotId;
        objSlottingController.strOrderId = lstOrders[0].Id;
        objSlottingController.strSourceSlotId = lstSlot[0].Id;
        objSlottingController.InsertSlotOrder();
        objSlottingController.strSlotId = strSlotId;
        objSlottingController.strOrderId = lstOrders[2].Id;
        objSlottingController.InsertSlotOrder();
        lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            objSlottingController.strSlotId = lstSlot[0].Id;
            objSlottingController.strOrderId = lstOrders[0].Id;
            objSlottingController.strSourceSlotId = lstSlot[0].Id;
            objSlottingController.InsertSlotOrder();
        }

        objSlottingController.InsertSlotAccount();
        objSlottingController.strAccountId = lstAccounts[0].Id;
        objSlottingController.strSlotId = strSlotId;
        objSlottingController.InsertSlotAccount();
        objSlottingController.strSlotId = strSlotId;
        objSlottingController.strAccountId = lstAccounts[1].Id;
        objSlottingController.InsertSlotAccount();
    }
    Public Static TestMethod Void SlottingControllerTest3()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        SlottingController objSlottingController = new SlottingController();
        objSlottingController.getWarehouseList();
        objSlottingController.strWarehouse = objWareHouse.Id;

        List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            strSlotId = lstSlot[0].Id;

            Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
            Insert objSlotAccount;
            strSlotAccountId = objSlotAccount.Id;

            Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
            Insert objSlotOrder;
            strSlotOrderId = objSlotOrder.Id;

            objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            Insert objSlotOrder;
        }
        objSlottingController.SelectWarehouse();
        objSlottingController.InsertSlotOrderInAccount();
        objSlottingController.strSlotAccountId = strSlotAccountId;
        objSlottingController.strOrderId = lstOrders[0].Id;
        objSlottingController.strSlotId = strSlotId;
        objSlottingController.InsertSlotOrderInAccount();
        objSlottingController.strSlotAccountId = strSlotAccountId;
        objSlottingController.strOrderId = lstOrders[2].Id;
        objSlottingController.strSlotId = strSlotId;
        objSlottingController.InsertSlotOrderInAccount();
        objSlottingController.strSlotAccountId = strSlotAccountId;
        objSlottingController.strOrderId = lstOrders[3].Id;
        objSlottingController.strSlotId = strSlotId;
        objSlottingController.InsertSlotOrderInAccount();
    }
    Public Static TestMethod Void SlottingControllerTest4()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        SlottingController objSlottingController = new SlottingController();
        objSlottingController.getWarehouseList();
        objSlottingController.strWarehouse = objWareHouse.Id;

        List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            strSlotId = lstSlot[0].Id;

            Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
            Insert objSlotAccount;
            strSlotAccountId = objSlotAccount.Id;

            Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
            Insert objSlotOrder;
            strSlotOrderId = objSlotOrder.Id;

            objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            Insert objSlotOrder;
            
            objSlottingController.SelectWarehouse();
            objSlottingController.DeleteSlotOrder();
            objSlottingController.strSlotOrderId = strSlotOrderId;
            objSlottingController.strSlotId = lstSlot[0].Id;
            objSlottingController.DeleteSlotOrder();

            objSlottingController.DeleteSlotAccount();
            objSlottingController.strSlotId = strSlotId;
            objSlottingController.strSlotAccountId = strSlotAccountId;
            objSlottingController.DeleteSlotAccount();
        }
    }
    Public Static TestMethod Void SlottingControllerTest5()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlottingMeansValidation();
        
        SlottingController objSlottingController = new SlottingController();
        objSlottingController.strOrderSearch = 'Test';
        objSlottingController.getWarehouseList();
        objSlottingController.strWarehouse = objWareHouse.Id;

        List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c,Slot_Type__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            strSlotId = lstSlot[0].Id;

            /*Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
            Insert objSlotAccount;
            strSlotAccountId = objSlotAccount.Id;*/

            /*Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
            Insert objSlotOrder;
            strSlotOrderId = objSlotOrder.Id;
            
            objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            Insert objSlotOrder;*/
        }
        objSlottingController.strSlotType = 'LTL';
        objSlottingController.SelectWarehouse();
        
        lstSlot = [Select Id, Warehouse_Slot__c, Slot_Type__c, Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
            ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
            objSlottingController.MoveSlot();
        }
        
        
        lstSlot = [Select Id, Warehouse_Slot__c,Slot_Type__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            strSlotId = lstSlot[0].Id;

            Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
            Insert objSlotAccount;
            strSlotAccountId = objSlotAccount.Id;

            Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
            Insert objSlotOrder;
            strSlotOrderId = objSlotOrder.Id;
            
            /*objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            Insert objSlotOrder;*/
        }
        objSlottingController.strSlotType = 'LTL';
        objSlottingController.SelectWarehouse();
        
        lstSlot = [Select Id, Warehouse_Slot__c, Slot_Type__c, Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
            ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
            objSlottingController.MoveSlot();
        }
    }
    
    Public Static TestMethod Void SlottingControllerTest6()
    {
        InsertWarehouse();
        SlottingQuickSearchController objSlottingQuickSearchController = new SlottingQuickSearchController();
        SlottingQuickSearchController.SearchOrders('Test',objWareHouse.Id);
        SlottingQuickSearchController.SearchAccount('Test',objWareHouse.Id);
    }
    
    /*Public Static TestMethod Void SlottingControllerTest5()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        SlottingController objSlottingController = new SlottingController();
        objSlottingController.strWarehouse = objWareHouse.Id;

        List<Profile> lstProfile = [Select Id from Profile where Name = 'Customer Service'];
        if (lstProfile != null && lstProfile.Size() > 0)
        {
            User uTesting = new User(Alias = 'test', Email = 'testing@testclass.com', EmailEncodingKey = 'UTF-8', 
                                LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', 
                                ProfileId = lstProfile[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                UserName = 'testing@testclass.com');
            System.runAs(uTesting)
            {
                objSlottingController.SelectWarehouse();
            }
        }

        lstProfile = [Select Id from Profile where Name = 'Customer Service Management'];
        if (lstProfile != null && lstProfile.Size() > 0)
        {
            User uTesting = new User(Alias = 'test', Email = 'testing@testclass.com', EmailEncodingKey = 'UTF-8', 
                                LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', 
                                ProfileId = lstProfile[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                UserName = 'testing@testclass.com');
            System.runAs(uTesting)
            {
                objSlottingController.SelectWarehouse();
            }
        }
    }*/
    Public Static Void InsertAccounts()
    {
        Account objAccount = new Account();
        objAccount.Name = 'Test Account1';
        lstAccounts.Add(objAccount);

        objAccount = new Account();
        objAccount.Name = 'Test Account2';
        lstAccounts.Add(objAccount);

        Insert lstAccounts;
    }
    Public Static Void InsertWarehouse()
    {
        objWareHouse.Name = 'Meridian';
        objWareHouse.Used_for_Slotting__c = true;
        objWareHouse.SAP_Plant__c = 'TW';
        objWareHouse.Maximum_Slots_Per_Day__c = 20;
        objWareHouse.Maximum_LTL_Orders_Per_day_Lead__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_day_Lead__c = 200;
        objWareHouse.Maximum_LTL_Orders_Per_Day_Rep__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_Day_Rep__c = 200;
        objWarehouse.sOrg__c = '1502';
        Insert objWareHouse;
    }
    Public Static Void InsertWarehouseSlots()
    {
        Warehouse_Slot__c objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';
        objWarehouseSlot.Slot_DOW__c = 'Monday';
        objWarehouseSlot.Delivers_DOW__c = 'Monday';
        objWareHouseSlot.Status__c = 'Active';
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);

        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'IPT';
        objWarehouseSlot.Slot_DOW__c = 'Tuesday';
        objWarehouseSlot.Delivers_DOW__c = 'Tuesday';
        objWareHouseSlot.Status__c = 'Active';
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';
        objWarehouseSlot.Slot_DOW__c = 'Wednesday';
        objWarehouseSlot.Delivers_DOW__c = 'Wednesday';
        objWareHouseSlot.Status__c = 'Active';
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'TL';
        objWarehouseSlot.Slot_DOW__c = 'Thursday';
        objWarehouseSlot.Delivers_DOW__c = 'Thursday';
        objWareHouseSlot.Status__c = 'Active';
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
    }
    Public Static Void InsertOrders()
    {
        Order objOrders = new Order();
        objOrders.Order_Num__c = '012346';
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Sold_To__c = lstAccounts[0].Id;
        objOrders.EffectiveDate = System.now().date();
        objOrders.Means__c = 'FSW';
        objOrders.Pallet_Count__c = 100;
        objOrders.Status = 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 123.45;
        objOrders.Ship_Condition__c = 'FSW';
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012347';
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Sold_To__c = lstAccounts[0].Id;
        objOrders.EffectiveDate = System.now().date();
        objOrders.Means__c = 'FSW';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.Ship_Condition__c = 'FSW';
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012348';
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Sold_To__c = lstAccounts[1].Id;
        objOrders.EffectiveDate = System.now().date();
        objOrders.Means__c = 'MCW';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012349';
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Sold_To__c = lstAccounts[1].Id;
        objOrders.EffectiveDate = System.now().date();
        objOrders.Means__c = 'RAIL - Rail';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        Insert lstOrders;
    }
    
    Public Static Void InsertSlottingMeansValidation()
    {
        Slotting_Means_Validation__c objSMV = new Slotting_Means_Validation__c();
        objSMV.Name = '01';
        objSMV.Means__c = lstOrders[0].Means__c;
        objSMV.SlotType__c = lstWarehouseSlots[0].Slot_Type__c;
        objSMV.WarehouseName__c = objWareHouse.Name;
        Insert objSMV;
        objSMV = new Slotting_Means_Validation__c();
        objSMV.Name = '01';
        objSMV.Means__c = lstOrders[2].Means__c;
        objSMV.SlotType__c = lstWarehouseSlots[0].Slot_Type__c;
        objSMV.WarehouseName__c = objWareHouse.Name;
        Insert objSMV;
    }
}