Public With Sharing Class doSlottingController
{
    //------------------------------Start: Drag and Drop Code--------------------------------------
    //Properties associated with the records/element after drag and drop action
    //---------------------------------------------------------------------------------------------
    Public String strSlotId {get; set;}
    Public String strSourceSlotId {get; set;}
    Public String strAccountId {get; set;}
    Public String strOrderId {get; set;}
    Public String strSlotOrderId {get; set;}
    Public String strSlotAccountId {get; set;}
    Public String strErrorMessage {get; set;}

    Private Decimal decMaxOrderLimit;
    Private Decimal decMaxWeightLimit;
    Public Map<String, String> mapWarehouseIdName;

    Set<Date> setDisplayDates;
    Boolean blnEliminateWeekend;
    
    Private Void QuickSearchRefill()
    {
        FillOrderList();
        FillFixedAccountList();
    }
    //---------------------------------------------------------------------------------------------
    //Call this function to refill all data including Ids on page after Drag and Drop
    //---------------------------------------------------------------------------------------------
    Private Void ReFillData()
    {
        QuickSearchRefill();
        FillSlotTypes();
        strSlotId = null;
        strAccountId = null;
        strOrderId = null;
        strSlotOrderId = null;
        strSlotAccountId = null;
        strErrorMessage = null;
    }
    //---------------------------------------------------------------------------------------------
    //Delete SlotOrder if its dragged from slot to right-hand side orders list
    //In drop event strSlotOrderId is set based on the Drag-&-Drop action type 
    //---------------------------------------------------------------------------------------------
    Public Void DeleteSlotOrder()
    {
        strErrorMessage = null;
        if (strSlotOrderId != null) {
            //Slot_Order__c objSlotOrder = new Slot_Order__c(Id = strSlotOrderId);
            List<Slot_Order__c> lstSlotOrderToDelete = [Select Id, Order1__r.Sold_To__c from Slot_Order__c where 
                                                Id =: strSlotOrderId limit 1];
            if (lstSlotOrderToDelete != null && lstSlotOrderToDelete.Size() > 0) {
                Delete lstSlotOrderToDelete[0];
                if (strSlotId != null) {
                    List<Slot_Account__c> lstSlotAccount = [Select Account__c from Slot_Account__c where Slot__c =: strSlotId
                                                            and Account__c =: lstSlotOrderToDelete[0].Order1__r.Sold_To__c limit 1];
                    if (lstSlotAccount != null && lstSlotAccount.Size() > 0) {
                        List<Slot_Order__c> lstSlotOrderAccount = [Select Id from Slot_Order__c where 
                                                Slot__c =: strSlotId and Order1__r.Sold_To__c =: lstSlotAccount[0].Account__c];
                        if (lstSlotOrderAccount == null || lstSlotOrderAccount.Size() == 0) {
                            Delete lstSlotAccount[0];
                        }
                    }
                    //Set<Id> lstAccountId = new Set<Id>();
                    //Map<Id, Slot_Account__c> mapAccountIdSlotAccount = new Map<Id, Slot_Account__c>();
                    //if (lstSlotAccount != null && lstSlotAccount.Size() > 0) {
                      //  for (Slot_Account__c objSlotAccount : lstSlotAccount) {
                        //    lstAccountId.Add(objSlotAccount.Account__c);
                         //   mapAccountIdSlotAccount.Put(objSlotAccount.Account__c, objSlotAccount);
                        //}
                    //}
                    //Slot__c objSlot = [Select Warehouse_Slot__c from Slot__c where Id =: strSlotId limit 1];
                    //List<Slot__c> lstSlot = [Select Id from Slot__c where Warehouse_Slot__c =: objSlot.Warehouse_Slot__c];
                    //List<Slot_Order__c> lstSlotOrder = [Select Id, Order1__r.Account__c from Slot_Order__c where 
                    //                        Slot__c =: strSlotId and Order1__r.Account__c =: lstAccountId];
                    //Map<Id, Id> mapAccountIdSlotOrderId = new Map<Id, Id>();
                    //String strOrderAccountId;
                    //if (lstSlotOrder != null && lstSlotOrder.Size() > 0) {
                      //  for (Slot_Order__c objSlotOrders : lstSlotOrder) {
                        //    mapAccountIdSlotOrderId.Put(objSlotOrders.Order1__r.Account__c, objSlotOrders.Id);
                        //}
                        //strOrderAccountId = lstSlotOrder[0].Order1__r.Account__c;
                    //}
                    //List<Slot_Account__c> lstSlotAccountToDelete = new List<Slot_Account__c>();
                    //for (Id idAccount : lstAccountId) {
                      //  if (idAccount == strOrderAccountId)
                        //    lstSlotAccountToDelete.Add(mapAccountIdSlotAccount.Get(idAccount));
                    //}
                    //Delete lstSlotAccountToDelete;                    
                }
                ReFillData();
                Return;
            }
        }
        QuickSearchRefill();
    }
    //---------------------------------------------------------------------------------------------
    //Delete SlotAccount if its dragged from slot to left-hand side Account list
    //In drop event strSlotAccountId is set based on the Drag-&-Drop action type
    //---------------------------------------------------------------------------------------------
    Public Void DeleteSlotAccount()
    {
        strErrorMessage = null;
        if (strSlotAccountId != null && strSlotId != null) {
            List<Slot_Account__c> lstSlotAccount = [Select Id, Name, Account__c from Slot_Account__c 
                                                        where Id =: strSlotAccountId];
            if (lstSlotAccount != null && lstSlotAccount.Size() > 0) {
                List<Slot_Order__c> lstSlotOrder = [Select Id, Name from Slot_Order__c where 
                                                    Slot__c =: strSlotId 
                                                    and Order1__r.Sold_To__c =: lstSlotAccount[0].Account__c];
                if (lstSlotOrder != null && lstSlotOrder.Size() > 0) {
                    Delete lstSlotOrder;
                }
                Delete lstSlotAccount[0];
                ReFillData();
                Return;
            }
        }
        QuickSearchRefill();
    }
    //---------------------------------------------------------------------------------------------
    //Insert new Slot-Order if an Order is dragged from right-hand side Orders list to 
    //'Drag new slot Order here' area
    //In drop event strSlotId and strOrderId are set based on the Drag-&-Drop action type
    //---------------------------------------------------------------------------------------------
    Public Void InsertSlotOrder()
    {
        strErrorMessage = null;
        Boolean blnInsertSlotAccount = false;
        if (strOrderId != null && strSlotId != null) {
            List<Order> lstOrder = [Select Id, Name, Sold_To__c, Means__c, Gross_Weight__c from Order where Id =: strOrderId];
            List<Slot__c> lstSlot = [Select Id, Name, Slot_Type__c, Warehouse_Slot__c from Slot__c where Id =: strSlotId];
            if (lstOrder != null && lstOrder.Size() > 0 && lstSlot != null && lstSlot.Size() > 0) {
                Boolean blnValidateMeans = ValidateOrderMeans(lstOrder, lstSlot);
                Boolean blnValidateLTL = ValidateLTLOrder(lstOrder, lstSlot);
                if (blnValidateMeans == true && blnValidateLTL == true) {
                    List<Slot_Account__c> lstSlotAccount = [Select Id, Name, Account__c from Slot_Account__c where 
                                                            Slot__c =: lstSlot[0].Id];
                    List<Slot_Order__c> lstSlotOrder = New List<Slot_Order__c>([Select Id, Means__c, Order1__r.Sold_To__c from Slot_Order__c 
                                                                                where Slot__c =: strSlotId]);

                    if (lstSlotAccount == null || lstSlotAccount.Size() == 0) {
                        Slot_Account__c objSlotAccount = new Slot_account__c(Slot__c = lstSlot[0].Id, Account__c = lstOrder[0].Sold_To__c);
                        Insert objSlotAccount;
                    } else {
                        //if (lstSlotOrder != null && lstSlotOrder.Size() == 0){
                         //   strErrorMessage = 'Order cannot be added to slot with fixed account.';
                        //}
                        blnInsertSlotAccount = true;
                        for (Slot_Account__c objSlotAccount : lstSlotAccount) {
                            if (objSlotAccount.Account__c == lstOrder[0].Sold_To__c) {
                                blnInsertSlotAccount = false;
                                break;
                            }
                        }
                        for (Slot_Order__c objSlotOrder : lstSlotOrder) {
                            if (objSlotOrder.Order1__r.Sold_To__c == lstOrder[0].Sold_To__c) {
                                blnInsertSlotAccount = false;
                                break;
                            }
                        }
                    }
                    if (lstSlotOrder != null && lstSlotOrder.Size() != 0) {
                        for (Slot_Order__c objSlotOrder : lstSlotOrder) {
                            if (lstOrder[0].Means__c != objSlotOrder.Means__c)
                                strErrorMessage = 'All orders for each slot must share the same means.';
                        }
                    }
                    if (strErrorMessage == null) {
                        if (blnInsertSlotAccount) {
                            Slot_Account__c objSlotAccount = new Slot_account__c(Slot__c = lstSlot[0].Id, Account__c = lstOrder[0].Sold_To__c);
                            Insert objSlotAccount;
                        }
                        
                        Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrder[0].Id);
                        Insert objSlotOrder;
                        //If an order is moved from one slot to another slot delete the order from the source slot
                        if (strSourceSlotId != null && strSourceSlotId != '') {
                            List<Slot_Order__c> lstSourceSlotOrder = [Select Id, Order1__r.Sold_To__c from Slot_Order__c where Slot__c =: strSourceSlotId
                                    and Order1__c =: strOrderId];
                            if (lstSourceSlotOrder != null && lstSourceSlotOrder.Size() > 0) {
                                Id idAccount = lstSourceSlotOrder[0].Order1__r.Sold_To__c;
                                Slot_Order__c objSlotOrderToDelete = lstSourceSlotOrder[0];
                                Delete objSlotOrderToDelete;
                                //After deleting the moved order, check if there are any other orders in the source slot with the same account
                                //If yes, then do not delete current slot account, else delete it
                                if (idAccount != null) {
                                    List<Slot_Order__c> lstSourceSlotOtherOrder = [Select Id from Slot_Order__c where Slot__c =: strSourceSlotId
                                            and Order1__r.Sold_To__c =: idAccount];
                                    if (lstSourceSlotOtherOrder == null || lstSourceSlotOtherOrder.Size() == 0) {
                                        List<Slot_Account__c> lstSourceSlotAccount = [Select Id from Slot_Account__c where Slot__c =: strSourceSlotId
                                                                                and Account__r.Id =: idAccount];
                                        if (lstSourceSlotAccount != null && lstSourceSlotAccount.Size() > 0) {
                                            Slot_Account__c objSlotAccountToDelete = lstSourceSlotAccount[0];
                                            Delete objSlotAccountToDelete;
                                        }
                                    }
                                }
                            }
                        }
                        ReFillData();
                        Return;
                    }
                }
            }
            QuickSearchRefill();
        }
    }
    
    //---------------------------------------------------------------------------------------------
    //Check validation for means of dropped order
    //---------------------------------------------------------------------------------------------
    Public Boolean ValidateOrderMeans(List<Order> lstOrder, List<Slot__c> lstSlot)
    {
        Boolean blnValidOrder = true;
        String strMean = lstOrder[0].Means__c;
        String strSlotType = lstSlot[0].Slot_Type__c;
        String strWareHouseName = '';

        if (mapWarehouseIdName != null)
            if (mapWarehouseIdName.Get(strWarehouse) != null)
                strWareHouseName = mapWarehouseIdName.Get(strWarehouse);

        if (strMean != null && strMean != '' && strSlotType != null && strSlotType != '') {
            List<Slotting_Means_Validation__c> lstMeansValidation = New List<Slotting_Means_Validation__c>([Select Id,
                                                                    Name, Means__c, SlotType__c, WarehouseName__c 
                                                                    from Slotting_Means_Validation__c where WarehouseName__c = null]);

            Set<String> setWareHouseName = New Set<String>();
            if (lstMeansValidation.Size() > 0) {
                for (Slotting_Means_Validation__c objMeanValidation : lstMeansValidation) {
                    if (!setWareHouseName.Contains(objMeanValidation.Means__c))
                        setWareHouseName.Add(objMeanValidation.Means__c);
                }
            }

            List<Slotting_Means_Validation__c> lstMeansValidation1 = New List<Slotting_Means_Validation__c>([Select Id,
                                                                    Name, Means__c, SlotType__c, WarehouseName__c 
                                                                    from Slotting_Means_Validation__c 
                                                                    where WarehouseName__c = null and Means__c =: strMean 
                                                                    and SlotType__c =: strSlotType]);

            if (lstMeansValidation1.Size() > 0) {
                Return blnValidOrder;
            } else {
                List<Slotting_Means_Validation__c> lstMeansValidation2 = New List<Slotting_Means_Validation__c>([Select Id,
                                                                    Name, Means__c, SlotType__c, WarehouseName__c 
                                                                    from Slotting_Means_Validation__c 
                                                                    where WarehouseName__c =: strWareHouseName and Means__c =: strMean 
                                                                    and SlotType__c =: strSlotType]);

                if (lstMeansValidation2.Size() > 0) {
                    Return blnValidOrder;
                } else {
                    blnValidOrder = false;
                    if (setWareHouseName.Size() > 0 && !setWareHouseName.Contains(strMean)) {
                        strErrorMessage = 'The order with means ' + strMean + ' is not allowed on a slot of type ' + strSlotType + ' for ' + strWareHouseName + ' warehouse.';
                    } else {
                        strErrorMessage = 'The order with means ' + strMean + ' is not allowed on a slot of type ' + strSlotType + '.';
                    }
                    Return blnValidOrder;
                }
            }
        }
        Return blnValidOrder;
    }

    //---------------------------------------------------------------------------------------------
    //Insert new SlotAccount if an Account sidragged from left-hand side Account list to 
    //'Drag new slot account here' area
    //In drop event strSlotId and strAccountId are set based on the Drag-&-Drop action type
    //---------------------------------------------------------------------------------------------
    Public Void InsertSlotAccount()
    {
        strErrorMessage = null;
        if (strAccountId != null && strSlotId != null)
        {
            List<Slot__c> lstSlot = [Select Id, Name, Warehouse_Slot__c from Slot__c where Id =: strSlotId];
            if (lstSlot != null && lstSlot.Size() > 0 && lstSlot[0].Warehouse_Slot__c != null) {
                List<Slot_Account__c> lstSlotAccount = [Select Id, Name from Slot_Account__c where 
                                                        Slot__c =: lstSlot[0].Id
                                                        and Account__c =: strAccountId];
                List<Slot_Account__c> lstExistingSlotAccount = New List<Slot_Account__c>([Select Id, Name from Slot_Account__c where 
                                                                                        Slot__c =: lstSlot[0].Id]);

                if (lstSlotAccount != null && lstSlotAccount.Size() > 0) {
                    strErrorMessage = 'This account already exists for this slot.';
                } else if (lstExistingSlotAccount.Size() == 0) {                
                    Slot_Account__c objSlotAccount = new Slot_Account__c (Slot__c = lstSlot[0].Id, Account__c = strAccountId);
                    Insert objSlotAccount;
                    ReFillData();
                    Return;
                } else {
                    strErrorMessage = 'An account already exists for this slot.';
                }
            }
        }
        QuickSearchRefill();
    }
    //---------------------------------------------------------------------------------------------
    //Insert new SlotOrder if an Order is dragged from right-hand side Orders list to 
    //Specific Slot Account 'New Order' Area
    //In drop event strSlotAccountId, strSlotId and strOrderId are set based on the 
    //Drag-&-Drop action type
    //---------------------------------------------------------------------------------------------
    Public Void InsertSlotOrderInAccount()
    {
        strErrorMessage = null;
        if (strSlotAccountId != null && strOrderId != null && strSlotId != null) {
            List<Order> lstOrder = [Select Id, Name, Sold_To__c, Means__c, Gross_Weight__c from Order where Id =: strOrderId];
            List<Slot__c> lstSlot = [Select Id, slot_type__c from Slot__c where id =: strSlotId];
            List<Slot_Order__c> lstSlotOrder =  [Select Id, Means__c from Slot_Order__c where Slot__c =: strSlotId];
            if (lstSlotOrder != null && lstSlotOrder.Size() != 0) {
                for (Slot_Order__c objSlotOrder : lstSlotOrder) {
                    if (lstOrder[0].Means__c != objSlotOrder.Means__c)
                        strErrorMessage = 'All orders for each slot must share the same means.';
                }
            }
            if (strErrorMessage == null) {
                List<Slot_Account__c> lstSlotAccountForOrder = [Select Id, Name, Account__c from Slot_Account__c where Id =: strSlotAccountId];               
                if (lstOrder != null && lstOrder.Size() > 0 && lstSlotAccountForOrder != null && lstSlotAccountForOrder.Size() > 0) {
                    if (lstSlotAccountForOrder[0].Account__c == lstOrder[0].Sold_To__c) {
                        Slot_Order__c objSlotOrder = new Slot_Order__c(Slot__c = strSlotId, Order1__c = lstOrder[0].Id);
                        Insert objSlotOrder;
                        ReFillData();
                        Return;
                    } else {
                        strErrorMessage = 'This order does not belong to the specified account.';
                    }
                }
            }
        }
        QuickSearchRefill();
    }
    //---------------------------------------------------------------------------------------------
    //Retrieve the maximum order and weight limit for each slot based on user profile
    //---------------------------------------------------------------------------------------------
    Public Boolean ValidateLTLOrder(List<Order> lstOrder, List<Slot__c> lstSlot)
    { 
        Boolean blnValidLTL = true;
        //String strMean = lstOrder[0].Means__c;
        String strSlotType = lstSlot[0].Slot_Type__c;
        String strSlotId = lstSlot[0].Id;
        String strLTLValidation = System.Label.Slotting_LTL_Validation;
        String strWareHouseName = '';
        if (mapWarehouseIdName != null && mapWarehouseIdName.Get(strWarehouse) != null)
            strWareHouseName = mapWarehouseIdName.Get(strWarehouse);

        System.debug('** '+ strSlotType + '** strWareHouseName= '+ strWareHouseName + ' ** contains '+ (strLTLValidation.Contains(strWareHouseName)));
        if (strSlotType == 'LTL' && strWareHouseName != '' && strLTLValidation.Contains(strWareHouseName)) {
            Map<String,List<String>> mapValidationValues = New Map<String,List<String>>();
            if (strLTLValidation != '' && strLTLValidation.contains(';')) {
                String[] strArrayValidationValues = strLTLValidation.Split(';');
                for (String strValidation:strArrayValidationValues) {
                    String[] strArray = strValidation.Split(':');
                    if (!mapValidationValues.containsKey(strArray[0].Trim())) {
                        List<String> lstValues = new List<String>();
                        lstValues.Add(strArray[1].Trim());
                        lstValues.Add(strArray[2].Trim());
                        mapValidationValues.Put(strArray[0].Trim(), lstValues);
                    }
                }
            } else {
                String[] strArray = strLTLValidation.Split(':');
                List<String> lstValues = new List<String>();
                lstValues.Add(strArray[1].Trim());
                lstValues.Add(strArray[2].Trim());
                mapValidationValues.Put(strArray[0].Trim(), lstValues);
            }

            List<String> lstValues = New List<String>();
            if (mapValidationValues.Get(strWareHouseName.Trim()) != null && mapValidationValues.Get(strWareHouseName.Trim()).Size() > 0) {
                lstValues = mapValidationValues.Get(strWareHouseName.Trim());
                Integer intOrderCount = 0;
                if (lstValues[0] != null)
                    intOrderCount = Integer.valueOf(lstValues[0]);
                Integer intTotalWeight = 0;
                if (lstValues[1] != null)
                    intTotalWeight = Integer.valueOf(lstValues[1]);

                Integer intExistCount = 0;
                Decimal dcExistWeight = 0.0;
                List<Slot__c> lstSlots = [Select Id from Slot__c where Scheduled_Shipping_Date__c =: dtCurrentDate and Slot_Type__c = 'LTL'];
                //AggregateResult[] arrSlotOrder = [Select Count(Id) CountId, Sum(Weight__c) TotalWeight from Slot_Order__c where Slot__c =: strSlotId];
                AggregateResult[] arrSlotOrder;
                if (lstSlots != null && lstSlots.Size() > 0)
                    arrSlotOrder = [Select Count(Id) CountId, Sum(Weight__c) TotalWeight from Slot_Order__c where Slot__c in : lstSlots];
                if (arrSlotOrder != null && arrSlotOrder.Size() > 0) {
                    intExistCount = Integer.ValueOf(arrSlotOrder[0].Get('CountId'));
                    dcExistWeight = Integer.ValueOf(arrSlotOrder[0].Get('TotalWeight'));
                }
                if (dcExistWeight == null)
                    dcExistWeight = 0.0;
                if (lstOrder != null && lstOrder.Size() > 0 && lstOrder[0].Gross_Weight__c != null)
                    dcExistWeight += lstOrder[0].Gross_Weight__c;

                if (intExistCount >= intOrderCount) {
                    strErrorMessage = 'Maximum ' + intOrderCount + ' orders can be added to an LTL slot for ' + strWareHouseName.trim() + ' Warehouse';
                    blnValidLTL = false;
                } else if (dcExistWeight >= intTotalWeight) {
                    strErrorMessage = 'Total weight of orders in LTL slot for ' + strWareHouseName.trim() + ' Warehouse can be ' + intTotalWeight + ' pounds';
                    blnValidLTL = false;
                }
            }
        }
        Return blnValidLTL;
    }
    //------------------------------End: Drag and Drop Code----------------------------------------

    Public String strWarehouse {get; set;}
    Public Date dtCurrentDate {get; set;}
    Public String strSelectedDate {get; set;}
    Public List<Account> lstAccounts {get; set;}
    Public List<Order> lstOrders {get; set;}
    Public List<Account> lstFixedAccount {get; set;}
    Public List<clsSlotType> lstSlotType {get; set;}
    //Set contains the Ids of the IPT slots which have been unchecked by the user and made droppable true
    //Public Set<Id> setSlotIdIPTCheckedStatus {get; set;}
    Public String strAccountSearch {get; set;} // Account quick search text
    Public String strOrderSearch {get; set;} // Order quick search text
    Public Slot__c objSlot {get; set;}

    //---------------------------------------------------------------------------------------------
    //Constructor Method
    //- Initialize variables used by this page
    //- Call the list fill methods used on the page
    //---------------------------------------------------------------------------------------------
    Public doSlottingController()
    {
        strAccountSearch = '';
        strOrderSearch = '';
        CalculateCurrentDay();
    }
    //---------------------------------------------------------------------------------------------
    // Wrapper class to display the accounts and orders associated with slots on the page
    //---------------------------------------------------------------------------------------------
    Public Class clsSlotAccountOrder
    {
        Public Slot_Account__c objSlotAccount {get; set;}
        Public List<Slot_Order__c> lstSlotOrder {get; set;}
    }
    //---------------------------------------------------------------------------------------------
    // Wrapper class to display the slots associated with days on the page
    //---------------------------------------------------------------------------------------------
    Public Class clsSlotList
    {
        Public Slot__c objSlot {get; set;}
        Public List<clsSlotAccountOrder> lstSlotAccountOrder {get; set;}
        //Public Integer intOrderCount {get; set;}
        //Public Integer intOrderPalletTotal {get; set;}
        //Public Decimal dcOrderWeightTotal {get; set;}
        Public String strSlotColor {get; set;}
        //Public Boolean blnIsIPTChecked {get; set;}
    }
    //---------------------------------------------------------------------------------------------
    // Wrapper class to display the days and the associated slots on the page
    //---------------------------------------------------------------------------------------------
    Public Class clsDays
    {
        Public String strDay {get; set;}
        Public Boolean blnIsCurrentDay {get; set;}
        Public List<clsSlotList> lstSlotList {get; set;}
        Public Integer intTotalSlots {get; set;}
        Public Integer intAvailableSlots {get; set;}
    }
    //---------------------------------------------------------------------------------------------
    // Wrapper class to display the various slot types on the page
    //---------------------------------------------------------------------------------------------
    Public Class clsSlotType
    {
        Public String strSlotTypeName {get; set;}
        Public List<clsDays> lstDays {get; set;}
    }
    //---------------------------------------------------------------------------------------------
    //CalculateCurrentDay Function
    //- Called on page load to set the current day
    //- Calculates the current day on basis of today's day and provided business logic
    //---------------------------------------------------------------------------------------------
    Public Void CalculateCurrentDay()
    {
        Date dtToday = System.Today();
        String strDayName;
        for (Integer intI = 0; intI < 3; intI++)
        {
            dtToday = dtToday.AddDays(1);
            strDayName = DateTime.newInstance(dtToday, Time.newInstance(0, 0, 0, 0)).format('E');
            if (strDayName == 'Sat')
            {
                dtToday = dtToday.AddDays(2);
            }
            if (strDayName == 'Sun')
                dtToday = dtToday.AddDays(1);
        }
        dtCurrentDate = dtToday;
        strSelectedDate = String.valueOf(dtCurrentDate.Month()) + '/' + String.valueOf(dtCurrentDate.Day()) + '/' + String.valueOf(dtCurrentDate.Year());
    }
    //---------------------------------------------------------------------------------------------
    //Calculate 5 days of week based on Eliminate Weekend
    //---------------------------------------------------------------------------------------------
    Public void CalculateDaysOfWeek()
    {
        setDisplayDates = New Set<Date>();
        if (blnEliminateWeekend == true) {
            for (Integer intI = -2; intI < 3; intI++) {
                if (intI == 0) {
                    setDisplayDates.Add(dtCurrentDate);
                } else {
                    Date dtNewDate = dtCurrentDate.AddDays(intI);
                    String strCurrentDay = DateTime.newInstance(dtNewDate, Time.newInstance(0, 0, 0, 0)).format('E');
                    if (intI < 0) {
                        if (strCurrentDay == 'Sat') {
                            dtNewDate = dtNewDate.AddDays(-1);
                            //arrDisplayDates.Add(dtNewDate.AddDays(-1));
                        } else if (strCurrentDay == 'Sun') {
                            dtNewDate = dtNewDate.AddDays(-2);
                            //arrDisplayDates.Add(dtNewDate.AddDays(-2));
                        } else {
                            dtNewDate = dtNewDate;
                            //arrDisplayDates.Add(dtNewDate);
                        }
                    }
                    if (intI > 0) {
                        if (strCurrentDay == 'Sat') {
                            dtNewDate = dtNewDate.AddDays(2);
                            //arrDisplayDates.Add(dtNewDate.AddDays(2));
                        } else if (strCurrentDay == 'Sun') {
                            dtNewDate = dtNewDate.AddDays(1);
                            //arrDisplayDates.Add(dtNewDate.AddDays(1));
                        }  else {
                            dtNewDate = dtNewDate;
                            //arrDisplayDates.Add(dtNewDate);
                        }
                    }

                    if (!setDisplayDates.contains(dtNewDate)) { 
                        setDisplayDates.Add(dtNewDate);
                    } else {
                        if (intI < 0) {
                            setDisplayDates.Add(dtNewDate.AddDays(-1));
                        } else {
                            setDisplayDates.Add(dtNewDate.AddDays(1));
                        }    
                    }
                }
            } 
        } else {
            for (Integer intI = -2; intI < 3; intI++) {
                setDisplayDates.Add(dtCurrentDate.AddDays(intI));
            }
        }
    }
    //---------------------------------------------------------------------------------------------------
    //getWarehouseList Function
    //- Called on page load to bind the warehouse picklist
    //- Retrieves the list of all warehouses to be displayed in the warehouse picklist
    // --------------------------------------------------------------------------------------------------
    Public List<selectOption> getWarehouseList()
    {
        List<selectOption> lstWarehouseOptions = new List<selectOption>();
        List<Plants__c> lstWarehouse = new List<Plants__c>();
        lstWarehouse = [Select Id, Name from Plants__c where Used_for_Slotting__c = true order by Name asc];
        lstWarehouseOptions.Add(new SelectOption('', 'Select Warehouse'));
        mapWarehouseIdName = new  Map<String,String>();
        for (Plants__c objWarehouse : lstWarehouse) {
            lstWarehouseOptions.Add(new SelectOption(objWarehouse.Id, objWarehouse.Name));
            //Fill Id and Name of Warehouse in mapWarehouseIdName
            mapWarehouseIdName.Put(objWarehouse.Id, objWarehouse.Name);
        }
        Return lstWarehouseOptions;
    }
    //---------------------------------------------------------------------------------------------------
    //FillFixedAccountList Function
    //- Called on page load to fill in the fixed account values to be dragged onto the slots
    //- Retrieves a list of all fixed accounts associated with the selected warehouse
    // --------------------------------------------------------------------------------------------------
    Public Void FillFixedAccountList()
    {
        lstFixedAccount = new List<Account>();
        if (strWarehouse != '' && strWarehouse != null) {
            lstFixedAccount = doSlottingQuickSearchController.SearchAccount(strAccountSearch, strWarehouse);
        }
    }
    //---------------------------------------------------------------------------------------------------
    //FillOrderList Function
    //- Called on page load to fill in the order values to be dragged onto the slots
    //- Retrieves a list of all orders associated with the selected warehouse
    // --------------------------------------------------------------------------------------------------
    Public Void FillOrderList()
    {
        lstOrders = new List<Order>();
        if (strWarehouse != '' && strWarehouse != null) {
            lstOrders = doSlottingQuickSearchController.SearchOrders(strOrderSearch, strWarehouse);
        }
    }
    Public Void FillSlotTypes()
    {
        //strErrorMessage = null;
        lstSlotType = new List<clsSlotType>();
        String[] arrstrSlotTypes = new String[]{'TL', 'Pooling', 'LTL', 'Rail', 'CSPU'};
        Integer intSlotTypeCount = 5;
        //For all the 5 days to be displayed, retrive the available slots
        List<Warehouse_Slot__c> lstWarehouseSlot = [Select Id, Name from Warehouse_Slot__c 
                        where Plant__c =: strWarehouse
                        and Status__c =: 'Active'];

        List<Slot__c> lstSlot = [Select Id, Name, Scheduled_Shipping_Date__c, Slot_Type__c, Warehouse_Slot__c, Color__c, 
                        (Select Id, Name, Account__c, Account__r.Name,Account__r.Fixed_Account__c, Slot__c from Slot_Accounts__r), 
                        (Select Id, Name, Account__c, Slot__c, Order1__r.Order_Num__c, 
                        Order1__r.Pallet_Count__c, Order1__r.Gross_Weight__c, Order1__r.Means__c, Order1__r.Sold_To__c
                        from Slot_Orders__r)
                        from Slot__c 
                        where Scheduled_Shipping_Date__c in : setDisplayDates
                        and (Warehouse_Slot__c =: lstWarehouseSlot) order by Priority__c];

        List<Date> lstDisplayDates = New List<Date>();

        for (Date dtDisplay:setDisplayDates) {
            lstDisplayDates.Add(dtDisplay);
        }

        lstDisplayDates.Sort();

        //Add the 5 slot types to display the 5 sections on the page
        for (Integer intI = 0; intI < intSlotTypeCount; intI++) {
            clsSlotType objSlotType = new clsSlotType();
            objSlotType.strSlotTypeName = arrstrSlotTypes[intI];
            //For each section add the 5 days to be displayed
            List<clsDays> lstDays = new List<clsDays>();
            for (Integer intJ = 0; intJ < 5; intJ++) {
                clsDays objDays = new clsDays();
                Date dtDateToAdd = lstDisplayDates[intJ];
                String strDayName = DateTime.newInstance(dtDateToAdd, Time.newInstance(0, 0, 0, 0)).format('E');
                String strDate = String.valueOf(dtDateToAdd.Day());
                String strMonth = String.valueOf(dtDateToAdd.Month());
                String strYear = String.valueOf(dtDateToAdd.Year());
                objDays.strDay = strDayName + ' ' + strMonth + '/' + strDate;// + '/' + strYear;
                if (dtDateToAdd == dtCurrentDate)
                    objDays.blnIsCurrentDay = true;
                else
                    objDays.blnIsCurrentDay = false;

                List<clsSlotList> lstSlotList = new List<clsSlotList>();
                //For each day, retrive the available slots of a particular slot type
                for (Slot__c objSlot : lstSlot) {
                    clsSlotList objSlotList = new clsSlotList();
                    List<clsSlotAccountOrder> lstSlotAccountOrder = new List<clsSlotAccountOrder>();
                    objSlotList.strSlotColor = objSlot.Color__c;

                    if (objSlot.Scheduled_Shipping_Date__c == dtDateToAdd && objSlot.Slot_Type__c == objSlotType.strSlotTypeName) {
                        objSlotList.objSlot = objSlot;

                        //Set for avoid duplicate orders
                        //Set<Id> setSlotOrderId = new Set<Id>();
                        
                        //For each Slot, retrieve the associated account name
                        for (Slot_Account__c objSlotAccount : objSlot.Slot_Accounts__r) {
                            if (objSlotAccount.Slot__c == objSlot.Id) {
                                clsSlotAccountOrder objSlotAccountOrder = new clsSlotAccountOrder();
                                objSlotAccountOrder.objSlotAccount = objSlotAccount;

                                //For each SlotAccount, retrieve the associated order details
                                List<Slot_Order__c> lstSlotOrderForAccount = new List<Slot_Order__c>();
                                for (Slot_Order__c objSlotOrder : objSlot.Slot_Orders__r) {
                                    if (objSlotOrder.Slot__c == objSlot.Id && objSlotOrder.Order1__r.Sold_To__c == objSlotAccountOrder.objSlotAccount.Account__c) {
                                        //if (!setSlotOrderId.Contains(objSlotOrder.Id)) {
                                            lstSlotOrderForAccount.Add(objSlotOrder);
                                            //setSlotOrderId.Add(objSlotOrder.Id);
                                        //}
                                    }
                                }

                                if (lstSlotOrderForAccount != null && lstSlotOrderForAccount.Size() > 0) {
                                    objSlotAccountOrder.lstSlotOrder = lstSlotOrderForAccount;
                                    lstSlotAccountOrder.Add(objSlotAccountOrder);
                                }
                                else if(objSlot.Slot_Type__c == 'TL')
                                {
                                    List<Slot_Order__c> lstSlotOrderFixedAccount = new List<Slot_Order__c>();
                                    objSlotAccountOrder.lstSlotOrder = lstSlotOrderFixedAccount;
                                    lstSlotAccountOrder.Add(objSlotAccountOrder);
                                }
                            }
                        }
                        //Add a new empty account and order space to drag a new account/order to a slot only for current day
                        if (objDays.blnIsCurrentDay) {
                            clsSlotAccountOrder objSlotAccountOrder = new clsSlotAccountOrder();
                            objSlotAccountOrder.objSlotAccount = new Slot_Account__c();
                            Slot_Order__c objSlotOrder = new Slot_Order__c();
                            if (objSlotAccountOrder.lstSlotOrder == null)
                                objSlotAccountOrder.lstSlotOrder = new List<Slot_Order__c>();
                            objSlotAccountOrder.lstSlotOrder.Add(objSlotOrder);
                            lstSlotAccountOrder.Add(objSlotAccountOrder);
                        }
                    }
                    objSlotList.lstSlotAccountOrder = lstSlotAccountOrder;
                    if (objSlotList.objSlot != null)
                        lstSlotList.Add(objSlotList);
                }
                objDays.lstSlotList = lstSlotList;
                //Calculate the total slots and the available slots for each day to display it in tooltip
                if (objDays.blnIsCurrentDay) {
                    objDays.intTotalSlots = lstSlotList.Size();
                    objDays.intAvailableSlots = lstSlotList.Size();
                    for (Integer intZ = 0; intZ < lstSlotList.Size(); intZ++) {
                        Boolean blnDecrementAvailableSlot = false;
                        for (Integer intY = 0; intY < lstSlotList[intZ].lstSlotAccountOrder.Size() - 1; intY++) {
                            //Change to uncommented line if enabling "New Order/New Account" condition
                            if (lstSlotList[intZ].lstSlotAccountOrder[intY].lstSlotOrder != null &&
                                    lstSlotList[intZ].lstSlotAccountOrder[intY].lstSlotOrder.Size() > 0)
                                blnDecrementAvailableSlot = true;
                        }
                        if (blnDecrementAvailableSlot)
                            objDays.intAvailableSlots -= 1;
                    }
                }
                lstDays.Add(objDays);
            }
            objSlotType.lstDays = lstDays;
            Boolean blnAddSlotType = false;
            for (Integer intJ = 0; intJ < 5; intJ++) {
                if (objSlotType.lstDays[intJ].lstSlotList.Size() > 0)
                    blnAddSlotType = true;
            }
            if (blnAddSlotType)
                lstSlotType.Add(objSlotType);
        }
    }
    Public PageReference AddSlotIdToSet()
    {
        //strErrorMessage = null;
        //String strSlotId = ApexPages.currentPage().getParameters().Get('strIPTSlotId');
        //Boolean blnChecked = Boolean.valueOf(ApexPages.currentPage().getParameters().Get('blnChecked'));
        //if (blnChecked) {
          //  setSlotIdIPTCheckedStatus.Remove(strSlotId);
        //} else {
          ///  setSlotIdIPTCheckedStatus.Add(strSlotId);
       // }
        //FillSlotTypes();
        //QuickSearchRefill();
        return null;
    }
    Public PageReference NextDay()
    {
        dtCurrentDate = dtCurrentDate.AddDays(1);
        if (blnEliminateWeekend == true) {
            String strCurrentDay = DateTime.newInstance(dtCurrentDate, Time.newInstance(0, 0, 0, 0)).format('E');
            if (strCurrentDay == 'Sat') {
                dtCurrentDate = dtCurrentDate.AddDays(2);
            } else if (strCurrentDay == 'Sun') {
                dtCurrentDate = dtCurrentDate.AddDays(1);
            }
        } 
        strSelectedDate = String.valueOf(dtCurrentDate.Month()) + '/' + String.valueOf(dtCurrentDate.Day()) + '/' + String.valueOf(dtCurrentDate.Year());
        CalculateDaysOfWeek();
        FillSlotTypes();
        QuickSearchRefill();
        return null;
    }
    Public PageReference PreviousDay()
    {
        dtCurrentDate = dtCurrentDate.AddDays(-1);
        if (blnEliminateWeekend == true) {
            String strCurrentDay = DateTime.newInstance(dtCurrentDate, Time.newInstance(0, 0, 0, 0)).format('E');
            if (strCurrentDay == 'Sat') {
                dtCurrentDate = dtCurrentDate.AddDays(-1);
            } else if (strCurrentDay == 'Sun') {
                dtCurrentDate = dtCurrentDate.AddDays(-2);
            }
        }
        strSelectedDate = String.valueOf(dtCurrentDate.Month()) + '/' + String.valueOf(dtCurrentDate.Day()) + '/' + String.valueOf(dtCurrentDate.Year());
        CalculateDaysOfWeek();
        FillSlotTypes();
        QuickSearchRefill();
        return null;
    }
    Public PageReference SelectWarehouse()
    {
        strErrorMessage = null;
        strAccountSearch = '';
        strOrderSearch = '';
        //setSlotIdIPTCheckedStatus = new Set<Id>();
        
        //Set the selected date in the dtCurrentDate variable.
        String[] arrSelectedDate = new String[]{};
        arrSelectedDate = strSelectedDate.Split('/');
        Date dtSelectedDate;
        if (arrSelectedDate != null && arrSelectedDate.Size() == 3) {
            dtSelectedDate = Date.newInstance(Integer.valueOf(arrSelectedDate[2]), Integer.valueOf(arrSelectedDate[0]), Integer.valueOf(arrSelectedDate[1]));
            dtCurrentDate = dtSelectedDate;
        }

        if (strWarehouse != '' && strWarehouse != null) {
            //Function call moved to constructor to set the selected date on page load itself
            //CalculateCurrentDay();
            FillOrderList();
            FillFixedAccountList();

            List<Plants__c> lstWarehouse = New List<Plants__c>([Select Id, Eliminate_Weekend__c from Plants__c
                                                where Id =: strWarehouse limit 1]);
            if (lstWarehouse.Size() > 0) {
                blnEliminateWeekend = lstWarehouse[0].Eliminate_Weekend__c;
            }
            Boolean blnValidDate = true;
            if (blnEliminateWeekend) {
                String strDayName = DateTime.newInstance(dtCurrentDate, Time.newInstance(0, 0, 0, 0)).format('E');
                if (strDayName == 'Sat' || strDayName == 'Sun') {
                    blnValidDate = false;
                    strErrorMessage = 'You cannot select weekend dates for this warehouse';
                }
            }
            if (blnValidDate) {
                CalculateDaysOfWeek();
                FillSlotTypes();
            }
            //ValidateOrderCount();
            //ValidateLTLOrder();
        } else {
            lstSlotType = new List<clsSlotType>();
        }
        return null;
    }
    Public PageReference MoveSlot()
    {
        strErrorMessage = null;
        String strSlotId = ApexPages.currentPage().getParameters().Get('strSlotIdMoveSlot');
        String strSlotDate = ApexPages.currentPage().getParameters().Get('dtSlotDate');
        Date dtSlotDate;
        if (strSlotDate != null && strSlotDate != '')
            dtSlotDate = Date.valueOf(strSlotDate);
        
        String strDayName = DateTime.newInstance(dtSlotDate, Time.newInstance(0, 0, 0, 0)).format('E');
        if (blnEliminateWeekend == true && (strDayName == 'Sat' || strDayName == 'Sun')) {
            strErrorMessage = 'Slots cannot be moved to weekend dates for the selected warehouse since "Eliminate Weekend For Slotting" is true.';
        } else {        
            Id idNewSlotId;
            Id idWareHouseSlotId;
            List<Slot__c> lstSlot = [Select Name, Slot_Type__c, Plant__c from Slot__c where Id =: strSlotId order by Priority__c];
            if (lstSlot != null && lstSlot.Size() > 0) {
                List<Slot__c> lstSlotFuture = New List<Slot__c>([Select Id, Warehouse_Slot__c, (Select Id from Slot_Orders__r), 
                                    (Select Id from Slot_Accounts__r)
                                    from Slot__c where Scheduled_Shipping_Date__c =: dtSlotDate 
                                    and Slot_Type__c =: lstSlot[0].Slot_Type__c
                                    and Plant__c =: lstSlot[0].Plant__c order by Priority__c]);
    
                if (lstSlotFuture != null && lstSlotFuture.Size() > 0) {
                    for (Slot__c objSlotFuture : lstSlotFuture) {
                        if (objSlotFuture.Slot_Orders__r.Size() == 0 && objSlotFuture.Slot_Accounts__r.Size() == 0) {
                            idNewSlotId = objSlotFuture.Id;
                            idWareHouseSlotId = objSlotFuture.Warehouse_Slot__c;
                            break;
                        }
                    }
                    if (idNewSlotId != null) {
                        List<Slot_Order__c> lstSlotOrder = [Select Id, Account__c, Order1__r.Sold_To__c, Order1__c, Weight_Pound__c, Weight__c/*, CurrencyIsoCode*/ from Slot_Order__c where Slot__c =: lstSlot];
                        List<Slot_Order__c> lstNewSlotOrder = new List<Slot_Order__c>();
                        List<Slot_Account__c> lstSlotAccount = [Select Id, Account__c from Slot_Account__c where Slot__c =: lstSlot];
                        List<Slot_Account__c> lstNewSlotAccount = new List<Slot_Account__c>();
                        Boolean blnValidateLTL = true;
                        blnValidateLTL = ValidateLTLOrderMoveSlot(dtSlotDate, lstSlotOrder);
                        if (blnValidateLTL) {
                            if (lstSlotAccount != null && lstSlotAccount.Size() > 0) {
                                for (Slot_Order__c objSlotOrder : lstSlotOrder) {
                                    Slot_Order__c objNewSlotOrder = new Slot_Order__c();
                                    //objNewSlotOrder.CurrencyIsoCode = objSlotOrder.CurrencyIsoCode;
                                    objNewSlotOrder.Order1__c = objSlotOrder.Order1__c;
                                    objNewSlotOrder.Slot__c = idNewSlotId;
                                    objNewSlotOrder.Weight_Pound__c = objSlotOrder.Weight_Pound__c;
                                    lstNewSlotOrder.Add(objNewSlotOrder);
                                }
    
                                for (Slot_Account__c objSlotAccount : lstSlotAccount) {
                                    //Boolean blnAccountToAdd = true;
                                    //for(Slot_Account__c objSlotAccount : lstSlotAccount) {
                                      //  if (objSlotAccount.Account__c == objSlotOrder.Order__r.Account__c)
                                        //    blnAccountToAdd = false;
                                   // }
                                    //if (blnAccountToAdd)
                                    //{
                                        Slot_Account__c objNewSlotAccount = new Slot_Account__c();
                                        objNewSlotAccount.Slot__c = idNewSlotId;
                                        objNewSlotAccount.Account__c = objSlotAccount.Account__c;
                                        lstNewSlotAccount.Add(objNewSlotAccount);
                                    //}
                                }
                                if (lstNewSlotAccount != null && lstNewSlotAccount.Size() > 0) 
                                    Insert lstNewSlotAccount;
                                if (lstNewSlotOrder != null && lstNewSlotOrder.Size() > 0) 
                                    Insert lstNewSlotOrder;
                                if (lstSlotOrder != null && lstSlotOrder.Size() > 0) 
                                    Delete lstSlotOrder;
                                if (lstSlotAccount != null && lstSlotAccount.Size() > 0) 
                                    Delete lstSlotAccount;
                            }
                            else
                                strErrorMessage = 'There are no account/orders on the selected slot.';
                        }
                    }
                    else
                        strErrorMessage = 'There are no available slots for selected slot type and selected date.';
                }
                else
                    strErrorMessage = 'There are no available slots for the selected slot type and the selected date.';
            }
        }
        FillSlotTypes();
        QuickSearchRefill();
        return null;
    }
    Public Boolean ValidateLTLOrderMoveSlot(Date dtSlotDate, List<Slot_Order__c> lstSlotOrder)
    { 
        Boolean blnValidLTL = true;
        String strLTLValidation = System.Label.Slotting_LTL_Validation;
        String strWareHouseName = '';
        if (mapWarehouseIdName != null && mapWarehouseIdName.Get(strWarehouse) != null)
            strWareHouseName = mapWarehouseIdName.Get(strWarehouse);

        if (strWareHouseName != '' && strLTLValidation.Contains(strWareHouseName)) {
            Map<String,List<String>> mapValidationValues = New Map<String,List<String>>();
            if (strLTLValidation != '' && strLTLValidation.contains(';')) {
                String[] strArrayValidationValues = strLTLValidation.Split(';');
                for (String strValidation:strArrayValidationValues) {
                    String[] strArray = strValidation.Split(':');
                    if (!mapValidationValues.containsKey(strArray[0].Trim())) {
                        List<String> lstValues = new List<String>();
                        lstValues.Add(strArray[1].Trim());
                        lstValues.Add(strArray[2].Trim());
                        mapValidationValues.Put(strArray[0].Trim(), lstValues);
                    }
                }
            } else {
                String[] strArray = strLTLValidation.Split(':');
                List<String> lstValues = new List<String>();
                lstValues.Add(strArray[1].Trim());
                lstValues.Add(strArray[2].Trim());
                mapValidationValues.Put(strArray[0].Trim(), lstValues);
            }

            List<String> lstValues = New List<String>();
            if (mapValidationValues.Get(strWareHouseName.Trim()) != null && mapValidationValues.Get(strWareHouseName.Trim()).Size() > 0) {
                lstValues = mapValidationValues.Get(strWareHouseName.Trim());
                Integer intOrderCount = 0;
                if (lstValues[0] != null)
                    intOrderCount = Integer.valueOf(lstValues[0]);
                Integer intTotalWeight = 0;
                if (lstValues[1] != null)
                    intTotalWeight = Integer.valueOf(lstValues[1]);

                Integer intExistCount = 0;
                Decimal dcExistWeight = 0.0;
                List<Slot__c> lstSlots = [Select Id from Slot__c where Scheduled_Shipping_Date__c =: dtSlotDate and Slot_Type__c = 'LTL'];
                //AggregateResult[] arrSlotOrder = [Select Count(Id) CountId, Sum(Weight__c) TotalWeight from Slot_Order__c where Slot__c =: strSlotId];
                AggregateResult[] arrSlotOrder;
                if (lstSlots != null && lstSlots.Size() > 0)
                    arrSlotOrder = [Select Count(Id) CountId, Sum(Weight__c) TotalWeight from Slot_Order__c where Slot__c in : lstSlots];
                if (arrSlotOrder != null && arrSlotOrder.Size() > 0) {
                    intExistCount = Integer.ValueOf(arrSlotOrder[0].Get('CountId'));
                    dcExistWeight = Integer.ValueOf(arrSlotOrder[0].Get('TotalWeight'));
                }
                if (dcExistWeight == null)
                    dcExistWeight = 0.0;
                if (lstSlotOrder != null && lstSlotOrder.Size() > 0) {
                    for (Slot_Order__c objSlotOrder : lstSlotOrder) {
                        if (objSlotOrder.Weight__c != null) {
                            dcExistWeight += objSlotOrder.Weight__c;
                            intExistCount++;
                        }
                    }
                }

                if (intExistCount > intOrderCount) {
                    strErrorMessage = 'Maximum ' + intOrderCount + ' orders can be added to an LTL slot for ' + strWareHouseName.trim() + ' Warehouse';
                    blnValidLTL = false;
                } else if (dcExistWeight >= intTotalWeight) {
                    strErrorMessage = 'Total weight of orders in LTL slot for ' + strWareHouseName.trim() + ' Warehouse can be ' + intTotalWeight + ' pounds';
                    blnValidLTL = false;
                }
            }
        }
        Return blnValidLTL;
    }
    Public PageReference SetSlotColor()
    {
        strErrorMessage = null;
        String strColor = ApexPages.currentPage().getParameters().Get('strColor');
        String strSlotId = ApexPages.currentPage().getParameters().Get('strSlotId');
        //Slot__c objSlot = [Select Id, Color__c from Slot__c where Id =: strSlotId];
        List<Slot__c> lstSlot = New List<Slot__c>([Select Id, Color__c from Slot__c where Id =: strSlotId LIMIT 1]);
        if (lstSlot.Size() > 0 && lstSlot[0] != null) {
            lstSlot[0].Color__c = strColor;
            Update lstSlot[0];
        }
        FillSlotTypes();
        QuickSearchRefill();
        return null;
    } 
}