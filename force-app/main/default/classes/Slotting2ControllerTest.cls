@isTest
Public Class Slotting2ControllerTest
{
 Public Static List<Account> lstAccounts = new List<Account>();
    Public Static Plants__c objWarehouse = new Plants__c();
    Public Static List<Warehouse_Slot__c> lstWarehouseSlots = new List<Warehouse_Slot__c>();
    Public Static List<Order> lstOrders = new List<Order>();

    @testSetup
    
    public static void fillData(){
         Account  objAccount1 = new Account();
        objAccount1.Name = 'OPEN';
        objAccount1.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
        insert objAccount1;
        
        //clsSlotAccountOrder testObject = new clsSlotAccountOrder();
        
        
    }
    Public Static TestMethod Void Slotting2ControllerTest1()
    {
        User u2 = getUser();
        System.runAs(u2){
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
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
            
           // Slot_Order__c objSlotOrder1 = new Slot_Order__C ()

            objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            Insert objSlotOrder;
            
            ApexPages.currentPage().getParameters().Put('strSlotId', lstSlot[0].Id);
        }
        objSlotting2Controller.SelectWarehouse();
        ApexPages.currentPage().getParameters().Put('strColor', '#EFEFEF');
        objSlotting2Controller.SetSlotColor();

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
        Test.StartTest();
        objSlotting2Controller.PreviousDay();
        objSlotting2Controller.getSalesOrgList();
        Test.StopTest();
        }
    }
    Public Static TestMethod Void Slotting2ControllerTest2()
    {
        User u2 = getUser();
        System.runAs(u2){
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlottingMeansValidation();
        
        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
        objSlotting2Controller.getWarehouseList();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;

        List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c,Slot_Type__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            strSlotId = lstSlot[0].Id;

            Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
            Insert objSlotAccount;
            strSlotAccountId = objSlotAccount.Id;
            
            //Slot_Account__c objSlotAccount1 = new Slot_Account__c(Slot__c = lstSlot[1].Id,Account__c = lstAccounts[0].Id );
            //Insert objSlotAccount1;

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
        Test.StartTest();
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
        objSlotting2Controller.InsertSlotAccount();
        Test.StopTest();
        }
    }
    Public Static TestMethod Void Slotting2ControllerTest3()
    {
        User u2 = getUser();
        System.runAs(u2){
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
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

            //Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            //Insert objSlotOrder;
        }
        objSlotting2Controller.SelectWarehouse();
        objSlotting2Controller.getSearchSalesOrgList();
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
        }
    }
    Public Static TestMethod Void Slotting2ControllerTest4()
    {
        User u2 = getUser();
        System.runAs(u2){
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
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
            objSlotting2Controller.salesOrg = '1003';
            objSlotting2Controller.DeleteSlotOrder();
            objSlotting2Controller.strSlotOrderId = strSlotOrderId;
            objSlotting2Controller.strSlotId = lstSlot[0].Id;
            objSlotting2Controller.DeleteSlotOrder();

            objSlotting2Controller.DeleteSlotAccount();
            objSlotting2Controller.strSlotId = strSlotId;
            objSlotting2Controller.strSlotAccountId = strSlotAccountId;
            Test.StartTest();
            objSlotting2Controller.DeleteSlotAccount();
            Test.StopTest();
        }
        }
    }
    Public Static TestMethod Void Slotting2ControllerTest5()
    {
        User u2 = getUser();
        System.runAs(u2){
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';
        Date dtCurrentDate;
        dtCurrentDate = System.today().addDays(3);
                                                                    
        Plants__c plant = new Plants__c(Name = 'Bradenton',Used_for_Slotting__c =true, SAP_Plant__c = '1234567891', Maximum_Slots_Per_Day__c = 10);
        Insert plant;
        system.debug('@@@plant@@@'+plant);
        
        Warehouse_Slot__c objWarehouse1 = new Warehouse_Slot__c();
        objWarehouse1.Slot_DOW__c ='Monday';
        objWarehouse1.Comment__c = 'Test Cooments';
        objWarehouse1.Plant__c = plant.id;
        objWarehouse1.Slot_Type__c = 'LTL';
        INSERT objWarehouse1 ;
        
       
        
        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlottingMeansValidation();
        
        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
        objSlotting2Controller.strOrderSearch = 'Test';
        objSlotting2Controller.getWarehouseList();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;
        objSlotting2Controller.getarrSlotType();        //Added by Purnima for Story S-488382
        objSlotting2Controller.strWarehouse = plant.id;
        
         Warehouse_Time_Off__c objWarehouse = new Warehouse_Time_Off__c(Description__c = 'Dallas Warehouse', Time_Off_Type__c  = 'Holiday',Time_Off_Date__c = system.today().addDays(2), Plant__c = plant.id);
        system.debug('@@objWarehouse'+objWarehouse);
        INSERT objWarehouse;
        
        Warehouse_Time_Off__c objWarehouse2 = new Warehouse_Time_Off__c(Time_Off_Type__c  = 'Holiday',Time_Off_Date__c = system.today().addDays(2), Plant__c = plant.id);
        system.debug('@@objWarehouse2'+objWarehouse2);
        INSERT objWarehouse2;
        
        WarehouseComment__c objectWComment = new WarehouseComment__c();
        objectWComment.date__c = System.today().addDays(2);
        objectWComment.Slot_Type__c = 'LTL';
        objectWComment.Plant__c = plant.id;
        objectWComment.Comment__c = '7 Pallet MAX';
        INSERT objectWComment;
        system.debug('@@@objectWComment@@@'+objectWComment);
       
        

        List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c,Scheduled_Shipping_Date__c,Slot_Type__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        System.debug('@@** '+ lstSlot);
       
        system.debug('@@@lstSlot@@@@'+lstSlot);
        system.debug('@@@lstSlot@@@@'+lstSlot.size());
        system.debug('@@@lstAccounts[0].Id@@@'+lstAccounts[0].Id);
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
        
        lstSlot = [Select Id, Warehouse_Slot__c, Slot_Type__c,Plant__c, Scheduled_Shipping_Date__c from Slot__c];// where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        for(Slot__c slObj : lstSlot){
           // slObj.Slot_Type__c = 'LTL';
            slObj.Warehouse_Slot__c = objWarehouse1.id;
            slObj.Scheduled_Shipping_Date__c = dtCurrentDate;
        }
        UPDATE lstSlot;
       // Select Id from Slot__c where Scheduled_Shipping_Date__c =: dtSlotDate and Slot_Type__c = 'LTL' and Plant__c =: strWarehouse
       /* Slot__c objectSlot =  new Slot__c();
        objectSlot.Scheduled_Shipping_Date__c = system.today();
       // objectSlot.Slot_Type__c = 'LTL';
        objectSlot.Plant__c = plant.id;
        INSERT objectSlot;*/
        
        
        system.debug('@@@lstSlot@@@'+lstSlot);
        system.debug('@@@Query@@@'+[Select Id, Warehouse_Slot__c, Slot_Type__c,Plant__c, Scheduled_Shipping_Date__c from Slot__c]);
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
            system.debug('@@@strSlotId@@@'+strSlotId);
            ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
            system.debug('@@@dtSlotDate@@@'+String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
            ApexPages.currentPage().getParameters().Put('prmSaveCommentIndex', '0');    
          
            objSlotting2Controller.MoveSlot();
            List<Slot_Order__c> lst_SlotOrders = [SELECT Id, Slot__c,Order1__c,weight__c  FROM Slot_Order__c];
            System.debug('@@@lstSlot[0].Scheduled_Shipping_Date__c@@@@'+lstSlot[0].Scheduled_Shipping_Date__c);
            System.debug('@@@lst_SlotOrders@@@'+lst_SlotOrders);
            Test.StartTest();
            objSlotting2Controller.ValidateLTLOrderMoveSlot(lstSlot[0].Scheduled_Shipping_Date__c,lst_SlotOrders);
            objSlotting2Controller.ValidateLTLOrder(lstOrders, lstSlot);
            objSlotting2Controller.ValidateOrderMeans(lstOrders, lstSlot);
            Test.StopTest();
        }
        }
    }
    
   Public Static TestMethod Void Slotting2ControllerTest6()
    {
        User u2 = getUser();
        System.runAs(u2){
       String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlottingMeansValidation();
        
         Plants__c plant = new Plants__c(Name = 'Bradenton',Used_for_Slotting__c =true, SAP_Plant__c = '1234567890', Maximum_Slots_Per_Day__c = 10);
        Insert plant;
        system.debug('@@@plant@@@'+plant);
        
        Warehouse_Slot__c objWarehouse1 = new Warehouse_Slot__c();
        objWarehouse1.Slot_DOW__c ='Monday';
        objWarehouse1.Comment__c = 'Test Cooments';
        objWarehouse1.Plant__c = plant.id;
        INSERT objWarehouse1 ;
        
        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
        objSlotting2Controller.strOrderSearch = 'Test';
        objSlotting2Controller.getWarehouseList();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;
        objSlotting2Controller.getarrSlotType();    //Added by Purnima for Story S-488382

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
        
        lstSlot = [Select Id, Warehouse_Slot__c, Slot_Type__c, Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[3].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
            ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
            ApexPages.currentPage().getParameters().Put('prmSaveCommentIndex', '0');            
            objSlotting2Controller.MoveSlot();
            objSlotting2Controller.saveComment();
        }
        }
    }
     Public Static TestMethod Void Slotting2ControllerTest7()
    {
        User u2 = getUser();
        System.runAs(u2){
       String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouseMeridian();
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlottingMeansValidation();
        
        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
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
       // objSlotting2Controller.InsertSlotOrder();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strOrderId = lstOrders[2].Id;
       // objSlotting2Controller.InsertSlotOrder();
       
        lstSlot = [Select Id, Warehouse_Slot__c,Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
        System.debug('lstSlot1==>' + lstSlot);
        Test.StartTest();
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
            ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
            ApexPages.currentPage().getParameters().Put('prmSaveCommentIndex', '0');            
            objSlotting2Controller.MoveSlot();    
            objSlotting2Controller.strSlotId = lstSlot[0].Id;
            objSlotting2Controller.strOrderId = lstOrders[0].Id;
            objSlotting2Controller.strSourceSlotId = strSlotId;
            objSlotting2Controller.InsertSlotOrder();
            objSlotting2Controller.saveComment();
        }

        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.strAccountId = lstAccounts[0].Id;
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strAccountId = lstAccounts[1].Id;
        objSlotting2Controller.InsertSlotAccount();
        Test.StopTest();
        objSlotting2Controller.searchOrders();
        }
    }
      Public Static TestMethod Void Slotting2ControllerTest8()
    {
        User u2 = getUser();
        System.runAs(u2){
       String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouseMeridian();
        InsertWarehouseSlots1();
        InsertOrders1();
       // InsertSlottingMeansValidation();
        
        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
        objSlotting2Controller.getWarehouseList();
        objSlotting2Controller.strWarehouse = objWareHouse.Id;

        List<Slot__c> lstSlot = [Select Id, Warehouse_Slot__c,Slot_Type__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[0].Id];
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            strSlotId = lstSlot[0].Id;

            Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = lstAccounts[0].Id);
            Insert objSlotAccount;
            strSlotAccountId = objSlotAccount.Id;

          /*  Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[0].Id);
            Insert objSlotOrder;
            strSlotOrderId = objSlotOrder.Id;
            
            objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrders[1].Id);
            Insert objSlotOrder;*/
        }
        objSlotting2Controller.SelectWarehouse();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strOrderId = lstOrders[0].Id;
       // objSlotting2Controller.InsertSlotOrder();
        objSlotting2Controller.strSlotId = strSlotId;
       // objSlotting2Controller.strOrderId = lstOrders[2].Id;
       // objSlotting2Controller.InsertSlotOrder();
       
        lstSlot = [Select Id, Warehouse_Slot__c,Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
        System.debug('lstSlot1==>' + lstSlot);
        Test.StartTest();
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
            ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
            ApexPages.currentPage().getParameters().Put('prmSaveCommentIndex', '0');            
            objSlotting2Controller.MoveSlot();    
            objSlotting2Controller.strSlotId = lstSlot[0].Id;
            objSlotting2Controller.strOrderId = lstOrders[0].Id;
            objSlotting2Controller.strSourceSlotId = strSlotId;
            objSlotting2Controller.InsertSlotOrder();
            objSlotting2Controller.saveComment();
        }

        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.strAccountId = lstAccounts[0].Id;
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strAccountId = lstAccounts[1].Id;
        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.searchOrders();
        Test.StopTest();
        }
    }
    
    Public Static TestMethod Void Slotting2ControllerTest9(){
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      User u2 = new User(Alias = 'newUser', Email='newuser@testorg.com',
         EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
         LocaleSidKey='en_US', ProfileId = p.Id,
         TimeZoneSidKey='America/Los_Angeles', UserName='TestNewUser85858@testorg.com', Sales_Org__c = '1101');
        
        System.runAs(u2){
            String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouseMeridian();
        InsertWarehouseSlots();
        InsertOrders();
        InsertSlottingMeansValidation();
        
        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
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
       // objSlotting2Controller.InsertSlotOrder();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strOrderId = lstOrders[2].Id;
       // objSlotting2Controller.InsertSlotOrder();
       
        lstSlot = [Select Id, Warehouse_Slot__c,Scheduled_Shipping_Date__c from Slot__c where Warehouse_Slot__c =: lstWarehouseSlots[1].Id];
        System.debug('lstSlot1==>' + lstSlot);
        Test.StartTest();
        if (lstSlot != null && lstSlot.Size() > 1)
        {
            ApexPages.currentPage().getParameters().Put('strSlotIdMoveSlot', strSlotId);
            ApexPages.currentPage().getParameters().Put('dtSlotDate', String.valueOf(lstSlot[0].Scheduled_Shipping_Date__c));
            ApexPages.currentPage().getParameters().Put('prmSaveCommentIndex', '0');            
            objSlotting2Controller.MoveSlot();    
            objSlotting2Controller.strSlotId = lstSlot[0].Id;
            objSlotting2Controller.strOrderId = lstOrders[0].Id;
            objSlotting2Controller.strSourceSlotId = strSlotId;
            objSlotting2Controller.InsertSlotOrder();
            objSlotting2Controller.saveComment();
        }

        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.strAccountId = lstAccounts[0].Id;
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.InsertSlotAccount();
        objSlotting2Controller.strSlotId = strSlotId;
        objSlotting2Controller.strAccountId = lstAccounts[1].Id;
        objSlotting2Controller.InsertSlotAccount();
        Test.StopTest();
        objSlotting2Controller.searchOrders();
        }
    }
    
    Public Static TestMethod Void Slotting2ControllerTest14()
    {
        User u2 = getUser();
        System.runAs(u2){
        String strSlotId = '';
        String strSlotAccountId = '';
        String strSlotOrderId = '';

        InsertAccounts();
        InsertWarehouse();
        InsertWarehouseSlots();
        InsertOrders();

        Slotting2Controller objSlotting2Controller = new Slotting2Controller();
        objSlotting2Controller.testMethod1();
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
            objSlotting2Controller.salesOrg = '1003';
            objSlotting2Controller.DeleteSlotOrder();
            objSlotting2Controller.strSlotOrderId = strSlotOrderId;
            objSlotting2Controller.strSlotId = lstSlot[0].Id;
            objSlotting2Controller.DeleteSlotOrder();

            objSlotting2Controller.DeleteSlotAccount();
            objSlotting2Controller.strSlotId = strSlotId;
            objSlotting2Controller.strSlotAccountId = strSlotAccountId;
            Test.StartTest();
            objSlotting2Controller.DeleteSlotAccount();
            Test.StopTest();
        }
        }
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
        //List<Account> lstAccounts = new List<Account>();
        Account objAccount = new Account();
        objAccount.Name = 'Test Account1';
        objAccount.Fixed_Account__c = true;
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();    //Added by Purnima for Story S-562343
        lstAccounts.Add(objAccount);

        objAccount = new Account();
        objAccount.Name = 'Test Account2';
        objAccount.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();    //Added by Purnima for Story S-562343
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
        objWareHouse.Eliminate_Weekend__c = true;    //Added by Purnima for Story S-488382
        Insert objWareHouse;
    }
    Public Static Void InsertWarehouseMeridian()
    {
        objWareHouse.Name = 'Meridian';
        objWareHouse.Used_for_Slotting__c = true;
        objWareHouse.SAP_Plant__c = 'TW';
        objWareHouse.Maximum_Slots_Per_Day__c = 20;
        objWareHouse.Maximum_LTL_Orders_Per_day_Lead__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_day_Lead__c = 200;
        objWareHouse.Maximum_LTL_Orders_Per_Day_Rep__c = 2;
        objWareHouse.Maximum_LTL_Weight_Per_Day_Rep__c = 200;
        objWareHouse.Eliminate_Weekend__c = true;    //Added by Purnima for Story S-488382
        Insert objWareHouse;
    }
    Public Static Void InsertWarehouseSlots()
    {
        Plants__c plant1 = new Plants__c();
        plant1.City__c ='New York';
        plant1.Country__c ='USA';
        plant1.Warehouse_Status__c ='Active';
        plant1.Name ='Plant Test1';
        plant1.SAP_Plant__c = '123456789';
        plant1.Maximum_Slots_Per_Day__c = 10;
        insert plant1;
        
        
        Warehouse_Slot__c objWarehouseSlot = new Warehouse_Slot__c();
       // objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';         //Modified by Purnima for Story S-488382
        objWarehouseSlot.Slot_DOW__c = 'Monday';
        objWarehouseSlot.Delivers_DOW__c = 'Monday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Plant__c =plant1.Id;
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);

        objWarehouseSlot = new Warehouse_Slot__c();
       // objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';
        objWarehouseSlot.Slot_DOW__c = 'Tuesday';
        objWarehouseSlot.Delivers_DOW__c = 'Tuesday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Plant__c =plant1.Id;
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c();
       // objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';
        objWarehouseSlot.Slot_DOW__c = 'Wednesday';
        objWarehouseSlot.Delivers_DOW__c = 'Wednesday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Plant__c =plant1.Id;
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
        
        objWarehouseSlot = new Warehouse_Slot__c();
       // objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'TL';
        objWarehouseSlot.Slot_DOW__c = 'Thursday';
        objWarehouseSlot.Delivers_DOW__c = 'Thursday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Plant__c =plant1.Id;
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
    }
     Public Static Void InsertWarehouseSlots1()
    {
        
        Plants__c plant2 = new Plants__c();
        plant2.City__c ='New York';
        plant2.Country__c ='USA';
        plant2.Warehouse_Status__c ='Active';
        plant2.Name ='Plant Test2';
        plant2.SAP_Plant__c = '1234567892';
        plant2.Maximum_Slots_Per_Day__c = 10;
        insert plant2;
        
        Warehouse_Slot__c objWarehouseSlot = new Warehouse_Slot__c();
        //objWarehouseSlot.Plant__c = objWarehouse.Id;
        objWarehouseSlot.Slot_Type__c = 'LTL';         //Modified by Purnima for Story S-488382
        objWarehouseSlot.Slot_DOW__c = 'Monday';
        objWarehouseSlot.Delivers_DOW__c = 'Monday';
        objWareHouseSlot.Status__c = 'Active';
        objWarehouseSlot.Plant__c =plant2.Id;
        Insert objWarehouseSlot;
        lstWarehouseSlots.Add(objWarehouseSlot);
      
        lstWarehouseSlots.Add(objWarehouseSlot);
    }
    Public Static Void InsertOrders()
    {
        Order objOrders = new Order();
        objOrders.Order_Num__c = '012346';
        objOrders.Accountid = lstAccounts[0].Id;
        objOrders.Ship_To__c = lstAccounts[0].Id;
        objOrders.Ship_Condition__c = 'CPU';
        objOrders.Pallet_Count__c = 100;
        objOrders.Status= 'ORDER CREATED';
        objOrders.EffectiveDate =date.today();
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 123.45;
        objOrders.Sales_Org__c = '1502';
        objOrders.Sold_To__c = lstAccounts[0].Id;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c= '012347';
        objOrders.Accountid = lstAccounts[0].Id;
        objOrders.Ship_To__c = lstAccounts[0].Id;
        objOrders.Ship_Condition__c = 'CPU';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status= 'ORDER CREATED';
        objOrders.EffectiveDate =date.today();
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.Sales_Org__c = '1502';
        objOrders.Sold_To__c = lstAccounts[0].Id;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c= '012348';
        objOrders.Accountid = lstAccounts[1].Id;
        objOrders.Ship_To__c = lstAccounts[1].Id;
        objOrders.Ship_Condition__c = 'TL';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Status= 'ORDER CREATED';
        objOrders.EffectiveDate =date.today();
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.Sales_Org__c = '1502';
        objOrders.Sold_To__c = lstAccounts[0].Id;
        lstOrders.Add(objOrders);

        objOrders = new Order();
        objOrders.Order_Num__c= '012349';
        objOrders.Accountid = lstAccounts[1].Id;
        objOrders.Ship_To__c = lstAccounts[1].Id;
        objOrders.Ship_Condition__c = 'TLV';
        objOrders.Pallet_Count__c = 1000;
        objOrders.EffectiveDate =date.today();
        objOrders.Status= 'ORDER CREATED';
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 1234.56;
        objOrders.Sales_Org__c = '1502';
        objOrders.Sold_To__c = lstAccounts[0].Id;
        lstOrders.Add(objOrders);

        Insert lstOrders;        
    } Public Static Void InsertOrders1()
    {
        Order objOrders = new Order();
        objOrders.Order_Num__c= '012346';
        objOrders.Accountid = lstAccounts[0].Id;
        objOrders.Ship_To__c = lstAccounts[0].Id;
        objOrders.Ship_Condition__c = 'CPU';
        objOrders.Pallet_Count__c = 100;
        objOrders.Status= 'ORDER CREATED';
        objOrders.EffectiveDate =date.today();
        objOrders.Manufacturing_Plant__c = objWarehouse.Id;
        objOrders.Gross_Weight__c = 123.45;
        objOrders.Sales_Org__c = '1502';
        objOrders.Sold_To__c = lstAccounts[0].Id;
        lstOrders.Add(objOrders);

       /* objOrders = new JDE_Order__c();
        objOrders.JDE_Order_Number__c = '012347';
        objOrders.Account__c = lstAccounts[0].Id;
        objOrders.Ship_To__c = lstAccounts[0].Id;
        objOrders.Means__c = 'CPU';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Order_Status__c = '540';
        objOrders.Warehouse1__c = objWarehouse.Id;
        objOrders.Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        objOrders = new JDE_Order__c();
        objOrders.JDE_Order_Number__c = '012348';
        objOrders.Account__c = lstAccounts[1].Id;
        objOrders.Ship_To__c = lstAccounts[1].Id;
        objOrders.Means__c = 'TL';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Order_Status__c = '521';
        objOrders.Warehouse1__c = objWarehouse.Id;
        objOrders.Weight__c = 1234.56;
        lstOrders.Add(objOrders);

        objOrders = new JDE_Order__c();
        objOrders.JDE_Order_Number__c = '012349';
        objOrders.Account__c = lstAccounts[1].Id;
        objOrders.Ship_To__c = lstAccounts[1].Id;
        objOrders.Means__c = 'TLV';
        objOrders.Pallet_Count__c = 1000;
        objOrders.Order_Status__c = '520';
        objOrders.Warehouse1__c = objWarehouse.Id;
        objOrders.Weight__c = 1234.56;
        lstOrders.Add(objOrders);*/

        Insert lstOrders;        
    }
    
    Public Static Void InsertSlottingMeansValidation()
    {
        Slotting_Means_Validation__c objSMV = new Slotting_Means_Validation__c();
        objSMV.Name = '01';
        objSMV.Means__c = lstOrders[0].Ship_Condition__c;
        objSMV.SlotType__c = lstWarehouseSlots[0].Slot_Type__c;
        objSMV.WarehouseName__c = objWareHouse.Name;
        Insert objSMV;
        objSMV = new Slotting_Means_Validation__c();
        objSMV.Name = '01';
        objSMV.Means__c = lstOrders[2].Ship_Condition__c;
        objSMV.SlotType__c = lstWarehouseSlots[0].Slot_Type__c;
        objSMV.WarehouseName__c = objWareHouse.Name;
        Insert objSMV;
        objSMV = new Slotting_Means_Validation__c();
        objSMV.Name = '01';
        objSMV.Means__c = lstOrders[2].Ship_Condition__c;
        objSMV.SlotType__c = lstWarehouseSlots[0].Slot_Type__c;
        objSMV.WarehouseName__c = '' ;
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