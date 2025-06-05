@isTest
Public Class Slotting2ControllerTest_Siding 
{
    Public Static List<Account> lstAccounts = new List<Account>();
    Public Static Plants__c objWarehouse = new Plants__c();
    Public Static List<Warehouse_Slot__c> lstWarehouseSlots = new List<Warehouse_Slot__c>();
    Public Static List<Order> lstOrders = new List<Order>();
   
    Public Static TestMethod Void Slotting2ControllerTest1()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        Test.startTest();
        Slotting2Controller_Siding objSlotting2Controller = new Slotting2Controller_Siding();
        objSlotting2Controller.getWarehouseList();
        objSlotting2Controller.SelectWarehouse();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;

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
        objSlotting2Controller.SelectWarehouse();
        ApexPages.currentPage().getParameters().Put('strColor', '#EFEFEF');
        objSlotting2Controller.SetSlotColor();
     //START Added by Kritika Bhati for S-490567 on 26/6/2017
        ApexPages.currentPage().getParameters().put('prmSaveCommentIndex', '1');
        objSlotting2Controller.saveComment();
       
    //END S-490567
        lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strIPTSlotId', lstSlot[0].Id);
            ApexPages.currentPage().getParameters().Put('blnChecked', 'false');
            objSlotting2Controller.AddSlotIdToSet();
            ApexPages.currentPage().getParameters().Put('blnChecked', 'true');
            objSlotting2Controller.AddSlotIdToSet();
        }
        objSlotting2Controller.NextDay();
        objSlotting2Controller.PreviousDay();
        Test.stopTest();
    }
    
    Public Static TestMethod Void Slotting2ControllerTest2()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse(); 
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlottingMeansValidation();
        
        Test.startTest();
        Slotting2Controller_Siding objSlotting2Controller = new Slotting2Controller_Siding();
        objSlotting2Controller.getWarehouseList();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;

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
        objSlotting2Controller.SelectWarehouse();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strOrderId = lstOrders[0].Id;
        objSlotting2Controller.InsertSlotOrder();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strOrderId = lstOrders[2].Id;
        objSlotting2Controller.InsertSlotOrder();
        lstSlot = [Select Id, Warehouse_Slot__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            objSlotting2Controller.strSlotId = lstSlot[0].Id;
            objSlotting2Controller.strOrderId = lstOrders[0].Id;
            objSlotting2Controller.strSourceSlotId = strSlotId;
            objSlotting2Controller.InsertSlotOrder();
        }

        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.strAccountId = lstAccounts[0].Id;
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strAccountId = lstAccounts[1].Id;
        //objSlotting2Controller.strSourceSlotId = lstSlot[0].Id;
        objSlotting2Controller.InsertSlotAccount();
        Test.stopTest();
    }
    Public Static TestMethod Void Slotting2ControllerTest3()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        Test.startTest();
        Slotting2Controller_Siding objSlotting2Controller = new Slotting2Controller_Siding();
        objSlotting2Controller.getWarehouseList();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;

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
        objSlotting2Controller.SelectWarehouse();
        objSlotting2Controller.InsertSlotOrderInAccount();
        objSlotting2Controller.strSlotAccountId = strSlotAccountId;
        objSlotting2Controller.strOrderId = lstOrders[0].Id;
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.InsertSlotOrderInAccount();
        objSlotting2Controller.strSlotAccountId = strSlotAccountId;
        objSlotting2Controller.strOrderId = lstOrders[2].Id;
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.InsertSlotOrderInAccount();
        objSlotting2Controller.strSlotAccountId = strSlotAccountId;
        objSlotting2Controller.strOrderId = lstOrders[3].Id;
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.InsertSlotOrderInAccount();
        Test.stopTest();
    }
    
    Public Static TestMethod Void Slotting2ControllerTest4()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';
		InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        Test.startTest();
        Slotting2Controller_Siding objSlotting2Controller = new Slotting2Controller_Siding();
        objSlotting2Controller.getWarehouseList();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;

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
            
            objSlotting2Controller.SelectWarehouse();
            objSlotting2Controller.DeleteSlotOrder();
            objSlotting2Controller.strSlotOrderId = strSlotOrderId;
            objSlotting2Controller.strSlotId = lstSlot[0].Id;
            objSlotting2Controller.DeleteSlotOrder();

            objSlotting2Controller.DeleteSlotAccount();
            objSlotting2Controller.strSlotId = strSlotId;
            objSlotting2Controller.strSlotAccountId = strSlotAccountId;
            objSlotting2Controller.DeleteSlotAccount();
        }
        Test.stopTest();
    }
    
    Public Static TestMethod Void Slotting2ControllerTest5()
    {
        User u2 = getUser();
        System.runAs(u2)
        {
            String strSlotId = '';
            String strSlotAccountId = '';
            String strSlotOrderId = '';
            
            InsertAccounts();
            InsertWarehouse();
            InsertWarehouseSlots();
            InsertOrders();
            InsertSlottingMeansValidation();
            
            Test.startTest();
            
            Slotting2Controller_Siding objSlotting2Controller = new Slotting2Controller_Siding();
            objSlotting2Controller.strOrderSearch = 'Test';
            objSlotting2Controller.getWarehouseList();
            objSlotting2Controller.strWarehouse = objWareHouse.Id;
    
            List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c,Slot_Type__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
            if (lstSlot != null && lstSlot.Size() > 1)
            {
                strSlotId = lstSlot[0].Id;
    
                Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
                Insert objSlotAccount;
                strSlotAccountId = objSlotAccount.Id;
    
                /*Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
                Insert objSlotOrder;
                strSlotOrderId = objSlotOrder.Id;
                
                objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
                Insert objSlotOrder;*/
            }
            objSlotting2Controller.SelectWarehouse();
            
            lstSlot = [Select Id, Warehouse_Slot__c, Slot_Type__c, Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
            if (lstSlot != null && lstSlot.Size() > 1)
            {
                System.debug('**##**String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c) '+ String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
                ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
                ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
                objSlotting2Controller.MoveSlot();
            }
            Test.stopTest();
        }
    }
    
    Public Static TestMethod Void Slotting2ControllerTest6()
    {
        InsertWarehouse();
        Test.startTest();
        
        SlottingQuickSearchController objSlottingQuickSearchController = new SlottingQuickSearchController();
        SlottingQuickSearchController.SearchOrders('Test',objWareHouse.Id);
        SlottingQuickSearchController.SearchAccount('Test',objWareHouse.Id);
        Test.stopTest();
    }
    
    /*Public Static TestMethod Void Slotting2ControllerTest5()
    {
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;

        List<Profile> lstProfile = [Select Id from Profile where Name = 'Customer Service'];
        if (lstProfile != null && lstProfile.Size() > 0)
        {
            User uTesting = new User(Alias = 'test', Email = 'testing@testclass.com', EmailEncodingKey = 'UTF-8', 
                                LastName = 'Testing', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', 
                                ProfileId = lstProfile[0].Id, TimeZoneSidKey = 'America/Los_Angeles', 
                                UserName = 'testing@testclass.com');
            System.runAs(uTesting)
            {
                objSlotting2Controller.SelectWarehouse();
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
                objSlotting2Controller.SelectWarehouse();
            }
        }
    }*/
    Public Static Void InsertAccounts()
    {
        Account objAccount = new Account();
        objAccount.Name = 'Open';
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
        objWareHouse.Eliminate_Weekend__c = true; // Added by Kritika Bhati for S-490567 on 26/6/2017
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
        objWarehouseSlot.Slot_Type__c = 'LTL';
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
        objOrders.Means__c = 'FSW';
        objOrders.EffectiveDate = System.now().date();
        objOrders.Pallet_Count__c = 100;
        objOrders.Status = 'CREDIT HOLD';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 123.45;
        objOrders.Sales_Org__c = '1502';
        objOrders.Ship_Condition__c = 'FSW';
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012347';
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Sold_To__c = lstAccounts[0].Id;
        objOrders.Means__c = 'FSW';
        objOrders.EffectiveDate = System.now().date();
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'CREDIT HOLD';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.Sales_Org__c = '1502';
        objOrders.Ship_Condition__c = 'FSW';
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012348';
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Sold_To__c = lstAccounts[1].Id;
        objOrders.Means__c = 'MCW';
        objOrders.EffectiveDate = System.now().date();
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'CREDIT HOLD';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c = '012349';
        objOrders.AccountId = lstAccounts[0].Id;
        objOrders.Sold_To__c = lstAccounts[1].Id;
        objOrders.Means__c = 'RAIL - Rail';
        objOrders.EffectiveDate = System.now().date();
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status = 'CREDIT HOLD';
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
    
    private static User getUser(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = p.Id,
         TimeZoneSidKey='America/Los_Angeles', UserName='TestNewUser85858@testorg.com', Sales_Org__c = '1502');
         return u2;
    }
}