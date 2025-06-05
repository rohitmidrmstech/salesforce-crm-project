@isTest
Public Class SlottingReadOnlyControllerTest
{

    Public Static List<Account> lstAccounts = new List<Account>();
    Public Static Plants__c objWarehouse = new Plants__c();
    Public Static List<Warehouse_Slot__c> lstWarehouseSlots = new List<Warehouse_Slot__c>();
    Public Static List<Order> lstOrders = new List<Order>();

    Public Static TestMethod Void SlottingReadOnlyControllerTest1()
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
    
            Test.StartTest();
            SlottingReadOnlyController objSlottingReadOnlyController = new SlottingReadOnlyController();
            objSlottingReadOnlyController.getWarehouseList();
            objSlottingReadOnlyController.SelectWarehouse();
            objSlottingReadOnlyController.strWarehouse = objWareHouse.Id;
    
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
            objSlottingReadOnlyController.SelectWarehouse();
            ApexPages.currentPage().getParameters().Put('strColor', '#EFEFEF');
            objSlottingReadOnlyController.SetSlotColor();
    
            lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
            if (lstSlot != null && lstSlot.Size() > 1)
            {
                ApexPages.currentPage().getParameters().Put('strIPTSlotId', lstSlot[0].Id);
                ApexPages.currentPage().getParameters().Put('blnChecked', 'false');
                objSlottingReadOnlyController.AddSlotIdToSet();
                ApexPages.currentPage().getParameters().Put('blnChecked', 'true');
                objSlottingReadOnlyController.AddSlotIdToSet();
            }
            objSlottingReadOnlyController.NextDay();
            objSlottingReadOnlyController.PreviousDay();
            
             ApexPages.currentPage().getParameters().Put('prmSaveCommentIndex', '10');
            objSlottingReadOnlyController.saveComment();
            Test.StopTest();
        }
    }
    Public Static TestMethod Void SlottingReadOnlyControllerTest2()
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
            
            Test.StartTest();
            SlottingReadOnlyController objSlottingReadOnlyController = new SlottingReadOnlyController();
            objSlottingReadOnlyController.getWarehouseList();
            objSlottingReadOnlyController.strWarehouse = objWareHouse.Id;
    
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
            objSlottingReadOnlyController.SelectWarehouse();
            objSlottingReadOnlyController.strSlotId = strSlotId;
            objSlottingReadOnlyController.strOrderId = lstOrders[0].Id;
            objSlottingReadOnlyController.InsertSlotOrder();
            objSlottingReadOnlyController.strSlotId = strSlotId;
            objSlottingReadOnlyController.strOrderId = lstOrders[2].Id;
            objSlottingReadOnlyController.InsertSlotOrder();
            lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
            if (lstSlot != null && lstSlot.Size() > 1)
            {
                objSlottingReadOnlyController.strSlotId = lstSlot[0].Id;
                objSlottingReadOnlyController.strOrderId = lstOrders[0].Id;
                objSlottingReadOnlyController.strSourceSlotId = strSlotId;
                objSlottingReadOnlyController.InsertSlotOrder();
            }
    
            objSlottingReadOnlyController.InsertSlotAccount();
            objSlottingReadOnlyController.strAccountId = lstAccounts[0].Id;
            objSlottingReadOnlyController.strSlotId = strSlotId;
            objSlottingReadOnlyController.InsertSlotAccount();
            objSlottingReadOnlyController.strSlotId = strSlotId;
            objSlottingReadOnlyController.strAccountId = lstAccounts[1].Id;
            //objSlottingReadOnlyController.InsertSlotAccount();
            Test.StopTest();
        }
    }
    Public Static TestMethod Void SlottingReadOnlyControllerTest3()
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
    
            Test.StartTest();
            SlottingReadOnlyController objSlottingReadOnlyController = new SlottingReadOnlyController();
            objSlottingReadOnlyController.getWarehouseList();
            objSlottingReadOnlyController.strWarehouse = objWareHouse.Id;
    
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
            objSlottingReadOnlyController.SelectWarehouse();
            objSlottingReadOnlyController.InsertSlotOrderInAccount();
            objSlottingReadOnlyController.strSlotAccountId = strSlotAccountId;
            objSlottingReadOnlyController.strOrderId = lstOrders[0].Id;
            objSlottingReadOnlyController.strSlotId = strSlotId;
            objSlottingReadOnlyController.InsertSlotOrderInAccount();
            objSlottingReadOnlyController.strSlotAccountId = strSlotAccountId;
            objSlottingReadOnlyController.strOrderId = lstOrders[2].Id;
            objSlottingReadOnlyController.strSlotId = strSlotId;
            objSlottingReadOnlyController.InsertSlotOrderInAccount();
            objSlottingReadOnlyController.strSlotAccountId = strSlotAccountId;
            objSlottingReadOnlyController.strOrderId = lstOrders[3].Id;
            objSlottingReadOnlyController.strSlotId = strSlotId;
            objSlottingReadOnlyController.InsertSlotOrderInAccount();
            Test.StopTest();
        }
    }
    Public Static TestMethod Void SlottingReadOnlyControllerTest4()
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
    
            Test.StartTest();
            SlottingReadOnlyController objSlottingReadOnlyController = new SlottingReadOnlyController();
            objSlottingReadOnlyController.getWarehouseList();
            objSlottingReadOnlyController.strWarehouse = objWareHouse.Id;
    
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
                
                objSlottingReadOnlyController.SelectWarehouse();
                objSlottingReadOnlyController.DeleteSlotOrder();
                objSlottingReadOnlyController.strSlotOrderId = strSlotOrderId;
                objSlottingReadOnlyController.strSlotId = lstSlot[0].Id;
                objSlottingReadOnlyController.DeleteSlotOrder();
    
                objSlottingReadOnlyController.DeleteSlotAccount();
                objSlottingReadOnlyController.strSlotId = strSlotId;
                objSlottingReadOnlyController.strSlotAccountId = strSlotAccountId;
                objSlottingReadOnlyController.DeleteSlotAccount();
            }
            Test.StopTest();
        }
    }
    Public Static TestMethod Void SlottingReadOnlyControllerTest5()
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
            
            Test.StartTest();
            SlottingReadOnlyController objSlottingReadOnlyController = new SlottingReadOnlyController();
            objSlottingReadOnlyController.strOrderSearch = 'Test';
            objSlottingReadOnlyController.getWarehouseList();
            objSlottingReadOnlyController.strWarehouse = objWareHouse.Id;
    
            List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c,Slot_Type__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id and Slot_Type__c = 'LTL'];
           
                strSlotId = lstSlot[0].Id;
    
                Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
                Insert objSlotAccount;
                strSlotAccountId = objSlotAccount.Id;
    
                /*Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
                //Insert objSlotOrder;
                List<Slot_Order__c> SlList = new List<Slot_Order__c>();
                SlList.add(objSlotOrder);
                Insert SlList;
                strSlotOrderId = objSlotOrder.Id;
                
                objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
                Insert objSlotOrder;
                date dt =  Date.today();
                objSlottingReadOnlyController.ValidateLTLOrderMoveSlot(dt ,SlList );*/
            
            objSlottingReadOnlyController.SelectWarehouse();
            
            lstSlot = [Select Id, Warehouse_Slot__c, Slot_Type__c, Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
            if (lstSlot != null && lstSlot.Size() > 1)
            {
                ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
                ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
                objSlottingReadOnlyController.MoveSlot();
                
            }
            Test.StopTest();
        }
    }
    
    Public Static TestMethod Void SlottingReadOnlyControllerTest6()
    {
        User userRecord = initTestUser('Testing6');
        System.runAs(userRecord){
            InsertWarehouse();
            SlottingQuickSearchController objSlottingQuickSearchController = new SlottingQuickSearchController();
            SlottingQuickSearchController.SearchOrders('Test',objWareHouse.Id);
            SlottingQuickSearchController.SearchAccount('Test',objWareHouse.Id);
            
            SlottingReadOnlyController readOnlyController = new SlottingReadOnlyController();
            readOnlyController.searchOrders();
        }
    }
    
    /*Public Static TestMethod Void SlottingReadOnlyControllerTest5()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        SlottingReadOnlyController objSlottingReadOnlyController = new SlottingReadOnlyController();
        objSlottingReadOnlyController.strWarehouse = objWareHouse.Id;

        List<Profile> lstProfile = [Select Id from Profile where Name = 'Customer Service'];
        if (lstProfile != null && lstProfile.Size() > 0)
        {
            User uTesting = new User(Alias = 'test', Email = 'testing@testclass.com', EmailEncodingKey = 'UTF-8', 
                                LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', 
                                ProfileId = lstProfile[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                UserName = 'testing@testclass.com');
            System.runAs(uTesting)
            {
                objSlottingReadOnlyController.SelectWarehouse();
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
                objSlottingReadOnlyController.SelectWarehouse();
            }
        }
    }*/
    Public Static Void InsertAccounts()
    {
        Account objAccount = new Account();
        objAccount.Name = 'OPEN';
        objAccount.LOB__c = '1502' ;
        lstAccounts.Add(objAccount);

        objAccount = new Account();
        objAccount.Name = 'Test Account2';
         objAccount.LOB__c = '1502' ;
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
        objWarehouseSlot.Comment__c = 'Testing1';
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);

        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'IPT';
        objWarehouseSlot.Slot_DOW__c = 'Tuesday';
        objWarehouseSlot.Delivers_DOW__c = 'Tuesday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Comment__c = 'Testing1';
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';
        objWarehouseSlot.Slot_DOW__c = 'Wednesday';
        objWarehouseSlot.Delivers_DOW__c = 'Wednesday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Comment__c = 'Testing1';
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c();
        objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'TL';
        objWarehouseSlot.Slot_DOW__c = 'Thursday';
        objWarehouseSlot.Delivers_DOW__c = 'Thursday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Comment__c = 'Testing1';
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
    }
    Public Static Void InsertOrders()
    {
        Order objOrders = new Order();
        objOrders.Order_Num__c = '012346';
        objOrders.Sold_To__c = lstAccounts[0].Id;
        objOrders.Means__c = 'FSW';
        objOrders.Pallet_Count__c = 100;
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Status = 'ORDER CREATED';
        objOrders.EffectiveDate = System.now().date();
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 123.45;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012347';
        objOrders.Sold_To__c = lstAccounts[0].Id;
        objOrders.Means__c = 'FSW';
        objOrders.Pallet_Count__c = 1000;
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Status = 'ORDER CREATED';
        objOrders.EffectiveDate = System.now().date();
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012348';
        objOrders.Sold_To__c = lstAccounts[1].Id;
        objOrders.Means__c = 'MCW';
        objOrders.Pallet_Count__c = 1000;
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Status = 'ORDER CREATED';
        objOrders.EffectiveDate = System.now().date();
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012349';
        objOrders.Sold_To__c = lstAccounts[1].Id;
        objOrders.Means__c = 'RAIL - Rail';
        objOrders.Pallet_Count__c = 1000;
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Status = 'ORDER CREATED';
        objOrders.EffectiveDate = System.now().date();
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