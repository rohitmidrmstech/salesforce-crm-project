@isTest
Public Class doSlottingControllerTest
{
    Public Static List<Account> lstAccounts = new List<Account>();
    Public Static Plants__c objWarehouse = new Plants__c();
    Public Static List<Warehouse_Slot__c> lstWarehouseSlots = new List<Warehouse_Slot__c>();
    Public Static List<Order> lstOrders = new List<Order>();

    Public Static TestMethod Void doSlottingControllerTest1()
    {
        User userRecord = initTestUser('Testing1');
        System.runAs(userRecord){
            String strSlotId = '';
            String strSlotAccountId = '';
            String strSlotOrderId = '';
    
            InsertAccounts();
            InsertWarehouse();
            InsertWarehouseSlots();
            InsertOrders();
    
            doSlottingController objdoSlottingController = new doSlottingController();
            objdoSlottingController.getWarehouseList();
            objdoSlottingController.SelectWarehouse();
            objdoSlottingController.strWarehouse = objWareHouse.Id;
    
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
            objdoSlottingController.SelectWarehouse();
            ApexPages.currentPage().getParameters().Put('strColor', '#EFEFEF');
            objdoSlottingController.SetSlotColor();
    
            lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
            if (lstSlot != null && lstSlot.Size() > 1)
            {
                ApexPages.currentPage().getParameters().Put('strIPTSlotId', lstSlot[0].Id);
                ApexPages.currentPage().getParameters().Put('blnChecked', 'false');
                objdoSlottingController.AddSlotIdToSet();
                ApexPages.currentPage().getParameters().Put('blnChecked', 'true');
                objdoSlottingController.AddSlotIdToSet();
            }
            objdoSlottingController.NextDay();
            objdoSlottingController.PreviousDay();
        }
    }
    Public Static TestMethod Void doSlottingControllerTest2()
    {
        User userRecord = initTestUser('Testing2');
        System.runAs(userRecord){
            String strSlotId = '';
            String strSlotAccountId = '';
            String strSlotOrderId = '';
    
            InsertAccounts();
            InsertWarehouse();
            InsertWarehouseSlots();
            InsertOrders();
            InsertSlottingMeansValidation();
            
            doSlottingController objdoSlottingController = new doSlottingController();
            objdoSlottingController.getWarehouseList();
            objdoSlottingController.strWarehouse = objWareHouse.Id;
    
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
            objdoSlottingController.SelectWarehouse();
            objdoSlottingController.strSlotId = strSlotId;
            objdoSlottingController.strOrderId = lstOrders[0].Id;
            objdoSlottingController.InsertSlotOrder();
            objdoSlottingController.strSlotId = strSlotId;
            objdoSlottingController.strOrderId = lstOrders[2].Id;
            objdoSlottingController.InsertSlotOrder();
            lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
            if (lstSlot != null && lstSlot.Size() > 1)
            {
                objdoSlottingController.strSlotId = lstSlot[0].Id;
                objdoSlottingController.strOrderId = lstOrders[0].Id;
                objdoSlottingController.strSourceSlotId = strSlotId;
                objdoSlottingController.InsertSlotOrder();
            }
    
            objdoSlottingController.InsertSlotAccount();
            objdoSlottingController.strAccountId = lstAccounts[0].Id;
            objdoSlottingController.strSlotId = strSlotId;
            objdoSlottingController.InsertSlotAccount();
            objdoSlottingController.strSlotId = strSlotId;
            objdoSlottingController.strAccountId = lstAccounts[1].Id;
            objdoSlottingController.InsertSlotAccount();
        }
    }
    Public Static TestMethod Void doSlottingControllerTest3()
    {
        User userRecord = initTestUser('Testing3');
        System.runAs(userRecord){
            String strSlotId = '';
            String strSlotAccountId = '';
            String strSlotOrderId = '';
    
            InsertAccounts();
            InsertWarehouse();
            InsertWarehouseSlots();
            InsertOrders();
    
            doSlottingController objdoSlottingController = new doSlottingController();
            objdoSlottingController.getWarehouseList();
            objdoSlottingController.strWarehouse = objWareHouse.Id;
    
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
            objdoSlottingController.SelectWarehouse();
            objdoSlottingController.InsertSlotOrderInAccount();
            objdoSlottingController.strSlotAccountId = strSlotAccountId;
            objdoSlottingController.strOrderId = lstOrders[0].Id;
            objdoSlottingController.strSlotId = strSlotId;
            objdoSlottingController.InsertSlotOrderInAccount();
            objdoSlottingController.strSlotAccountId = strSlotAccountId;
            objdoSlottingController.strOrderId = lstOrders[2].Id;
            objdoSlottingController.strSlotId = strSlotId;
            objdoSlottingController.InsertSlotOrderInAccount();
            objdoSlottingController.strSlotAccountId = strSlotAccountId;
            objdoSlottingController.strOrderId = lstOrders[3].Id;
            objdoSlottingController.strSlotId = strSlotId;
            objdoSlottingController.InsertSlotOrderInAccount();
        }
    }
    Public Static TestMethod Void doSlottingControllerTest4()
    {
        User userRecord = initTestUser('Testing4');
        System.runAs(userRecord){
            String strSlotId = '';
            String strSlotAccountId = '';
            String strSlotOrderId = '';
    
            InsertAccounts();
            InsertWarehouse();
            InsertWarehouseSlots();
            InsertOrders();
    
            doSlottingController objdoSlottingController = new doSlottingController();
            objdoSlottingController.getWarehouseList();
            objdoSlottingController.strWarehouse = objWareHouse.Id;
    
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
                
                objdoSlottingController.SelectWarehouse();
                objdoSlottingController.DeleteSlotOrder();
                objdoSlottingController.strSlotOrderId = strSlotOrderId;
                objdoSlottingController.strSlotId = lstSlot[0].Id;
                objdoSlottingController.DeleteSlotOrder();
        
                objdoSlottingController.DeleteSlotAccount();
                objdoSlottingController.strSlotId = strSlotId;
                objdoSlottingController.strSlotAccountId = strSlotAccountId;
                objdoSlottingController.DeleteSlotAccount();
            }
        }
    }
    Public Static TestMethod Void doSlottingControllerTest5()
    {
        User userRecord = initTestUser('Testing5');
        System.runAs(userRecord){
            String strSlotId = '';
            String strSlotAccountId = '';
            String strSlotOrderId = '';
    
            InsertAccounts();
            InsertWarehouse();
            InsertWarehouseSlots();
            InsertOrders();
            InsertSlottingMeansValidation();
            
            doSlottingController objdoSlottingController = new doSlottingController();
            objdoSlottingController.strOrderSearch = 'Test';
            objdoSlottingController.getWarehouseList();
            objdoSlottingController.strWarehouse = objWareHouse.Id;
    
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
            objdoSlottingController.SelectWarehouse();
            
            lstSlot = [Select Id, Warehouse_Slot__c, Slot_Type__c, Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
            if (lstSlot != null && lstSlot.Size() > 1)
            {
                ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
                ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
                objdoSlottingController.MoveSlot();
            }
        }
    }
    
    Public Static TestMethod Void doSlottingControllerTest6()
    {
        User userRecord = initTestUser('Testing6');
        System.runAs(userRecord){
            InsertWarehouse();
            doSlottingQuickSearchController objdoSlottingQuickSearchController = new doSlottingQuickSearchController();
            doSlottingQuickSearchController.SearchOrders('Test',objWareHouse.Id);
            doSlottingQuickSearchController.SearchAccount('Test',objWareHouse.Id);
        }
    }
    
    /*Public Static TestMethod Void doSlottingControllerTest5()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        doSlottingController objdoSlottingController = new doSlottingController();
        objdoSlottingController.strWarehouse = objWareHouse.Id;

        List<Profile> lstProfile = [Select Id from Profile where Name = 'Customer Service'];
        if (lstProfile != null && lstProfile.Size() > 0)
        {
            User uTesting = new User(Alias = 'test', Email = 'testing@testclass.com', EmailEncodingKey = 'UTF-8', 
                                LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', 
                                ProfileId = lstProfile[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                UserName = 'testing@testclass.com');
            System.runAs(uTesting)
            {
                objdoSlottingController.SelectWarehouse();
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
                objdoSlottingController.SelectWarehouse();
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
        objOrders.Sold_To__c = lstAccounts[0].Id;
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Means__c = 'FSW';
        objOrders.Pallet_Count__c = 100;
        objOrders.Status = 'CREDIT HOLD';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 123.45;
        objOrders.EffectiveDate = System.today();
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012347';
        objOrders.Sold_To__c = lstAccounts[0].Id;
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Means__c = 'FSW';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'CREDIT HOLD';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.EffectiveDate = System.today();
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012348';
        objOrders.Sold_To__c = lstAccounts[1].Id;
        objOrders.AccountId = lstAccounts[1].Id;
        objOrders.Means__c = 'MCW';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'CREDIT HOLD';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.EffectiveDate = System.today();
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012349';
        objOrders.Sold_To__c = lstAccounts[1].Id;
        objOrders.AccountId = lstAccounts[1].Id;
        objOrders.Means__c = 'RAIL - Rail';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'CREDIT HOLD';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.EffectiveDate = System.today();
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
        objSMV.SlotType__c = lstWarehouseSlots[1].Slot_Type__c;
        objSMV.WarehouseName__c = objWareHouse.Name;
        Insert objSMV;
    }
    
    private static user initTestUser(String userName){
        Profile userPrf = [select id from profile where name='System Administrator'];
        User userRecord = new User(emailencodingkey     = 'UTF-8',
                                    languagelocalekey   = 'en_US',
                                    localesidkey        = 'en_US',
                                    timezonesidkey      = 'America/Los_Angeles',
                                    alias               = 'Tstr', 
                                    lastname            = userName,
                                    email               = userName + '@testorg.com',
                                    profileid           = userPrf.Id, 
                                    username            = userName + UserInfo.getOrganizationId() + '@testorg.com',
                                    sales_org__c        = '1502');
        Insert userRecord;
        return userRecord;
    }
}