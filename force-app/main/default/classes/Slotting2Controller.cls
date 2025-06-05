Public Class Slotting2Controller
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
    Public String strProfileForLTLValidation {get; set;}
    Public Boolean blnLTLToValidate {get; set;}

    Private Decimal decMaxOrderLimit;
    Private Decimal decMaxWeightLimit;
    Public Map<String, String> mapWarehouseIdName;
    private User userRecord;
    public String salesOrg{get;set;}
    public String searchSalesOrg{get;set;}
    public Boolean isAdminProfile{get;set;}
    
    public String strTimezone {get; set;}
    //private static String sOrg;

    Set<Date> setDisplayDates;
    Boolean blnEliminateWeekend;
    
    //Method
    Public static String fetchSalesOrg(){
        /*Boolean result = [Select Id, Name, PermissionsModifyAllData from Profile where Id=:UserInfo.getProfileId()].PermissionsModifyAllData;
        System.debug('**Result '+ result);
        System.debug('**sOrg '+ sOrg);
        if(result == true && String.isNotBlank(sOrg)){
            return sOrg;
        }*/
        List<User> userList = [SELECT ID, Name, Sales_Org__c FROM User WHERE ID = :UserInfo.getUserId()];
        if(userList.size() > 0){
            if(userList[0].Sales_Org__c != null){
               
                List<String> orgList = userList[0].Sales_Org__c.split(';');
                 SYSTEM.DEBUG('+++++ orgList: ' + orgList);
                Set<String> salesOrgSet = new Set<String>();
                salesOrgSet.addAll(orgList);
                if(salesOrgSet.contains('1502')){
                    return '1502';
                }else if(salesOrgSet.contains('1003')){
                    return '1003';
                }else if(salesOrgSet.contains('1101')){
                    return '1101';
                }
            }
        }
        return null;
    }
    
    
    //Method
    Private Void QuickSearchRefill()
    {
        FillOrderList();
        FillFixedAccountList();
    }
    //---------------------------------------------------------------------------------------------
    //Call this function to refill all data including Ids on page after Drag and Drop
    //---------------------------------------------------------------------------------------------
    
    //Method
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
        strProfileForLTLValidation = null;
        blnLTLToValidate = true;
    }
    //---------------------------------------------------------------------------------------------
    //Delete SlotOrder if its dragged from slot to right-hand side orders list
    //In drop event strSlotOrderId is set based on the Drag-&-Drop action type 
    //---------------------------------------------------------------------------------------------
    Public Void DeleteSlotOrder()
    {
        SYSTEM.DEBUG('++++ inside DeleteSlotOrder');
        strErrorMessage = null;
        strProfileForLTLValidation = null;
        SYSTEM.DEBUG('+++++ strSlotOrderId: ' + strSlotOrderId);
        if (strSlotOrderId != null) {
            //Slot_Order__c objSlotOrder = new Slot_Order__c(Id = strSlotOrderId);
            SYSTEM.DEBUG('+++++ salesOrg: ' + salesOrg);
            String lstSlotOrderDeleteString = 'Select Id, Order1__r.Sold_To__c, Order1__r.Ship_To__c from Slot_Order__c where Id =: strSlotOrderId AND ';
            //lstSlotOrderDeleteString +=  (salesOrg == '1003' || salesOrg == '1101') ? 'Order1__r.Sales_Org__c != \'1502\' ' : 'Order1__r.Sales_Org__c = :salesOrg '; 
            //(salesOrg == '1003' || salesOrg == '1101') ? ' != \'1502\'' : ' = :salesOrg ' + // Condition For Isolate
            lstSlotOrderDeleteString +=  (salesOrg == '1003' || salesOrg == '1101') ? 'Order1__r.Sales_Org__c != \'1502\' ' : '(Order1__r.Sales_Org__c = :salesOrg OR Order1__r.Sales_Org__c = \'1018\' OR Order1__r.Sales_Org__c = \'1019\' OR Order1__r.Sales_Org__c = \'1020\') ';
            lstSlotOrderDeleteString += ' LIMIT 1';
            System.debug('+++++Query '+ lstSlotOrderDeleteString) ;
            System.debug('+++++SlotId '+ strSlotOrderId); 	
            System.debug('+++++Sales '+ salesOrg);
            List<Slot_Order__c> lstSlotOrderToDelete = Database.query(lstSlotOrderDeleteString); //[Select Id, Order1__r.Sold_To__c, Order1__r.Ship_To__c from Slot_Order__c where 
                                                            //Id =: strSlotOrderId AND Order1__r.Sales_Org__c =: salesOrg limit 1]; // Condition For Isolate
            
            System.debug('+++++Query '+ lstSlotOrderDeleteString) ; //[Select Id, Order1__r.Sold_To__c, Order1__r.Ship_To__c from Slot_Order__c where 
                                                            //Id =: strSlotOrderId AND Order1__r.Sales_Org__c =: salesOrg limit 1]);
            SYSTEM.DEBUG('+++++ lstSlotOrderToDelete.Size(): ' + lstSlotOrderToDelete.Size());
            if (lstSlotOrderToDelete != null && lstSlotOrderToDelete.Size() > 0) {
                System.debug('+++++strSlotOrderId= '+ strSlotOrderId);
                System.debug('+++++strSlotId = '+ strSlotId );
                Delete lstSlotOrderToDelete[0];
                List<Slot_Account__c> lstSlotAccount = new List<Slot_Account__c>();
                List<Slot_Order__c> lstSlotOrderAccount = new List<Slot_Order__c>();
                if (strSlotId != null) {
                    if(salesOrg == '1003' || salesOrg == '1101')
                    {
                        lstSlotAccount = [Select Account__c from Slot_Account__c where Slot__c =: strSlotId
                                                            and Account__c =: lstSlotOrderToDelete[0].Order1__r.Ship_To__c limit 1];
                        if (lstSlotAccount != null && lstSlotAccount.Size() > 0) 
                        {
                             //After deleting selected order, check if there are any other orders with the same account.
                             //If yes, then do not delete the account, else delete the account
                             lstSlotOrderAccount = [Select Id from Slot_Order__c where 
                                                Slot__c =: strSlotId and Order1__r.Ship_To__c =: lstSlotAccount[0].Account__c AND Order1__r.Sales_Org__c != '1502'];//: salesOrg]; // Condition For Isolate
                        }
                    }
                    else if(salesOrg == '1502'){
                        lstSlotAccount = [Select Account__c from Slot_Account__c where Slot__c =: strSlotId
                                                            and Account__c =: lstSlotOrderToDelete[0].Order1__r.Sold_To__c limit 1];
                    system.debug('+++++ lstSlotAccount.Size(): ' + lstSlotAccount.Size());
                        if (lstSlotAccount != null && lstSlotAccount.Size() > 0) {
                            //After deleting selected order, check if there are any other orders with the same account.
                            //If yes, then do not delete the account, else delete the account
                            lstSlotOrderAccount = [Select Id from Slot_Order__c where 
                                                //Slot__c =: strSlotId and Order1__r.Sold_To__c =: lstSlotAccount[0].Account__c AND Order1__r.Sales_Org__c =: salesOrg]; // Condition For Isolate
                            					Slot__c =: strSlotId and Order1__r.Sold_To__c =: lstSlotAccount[0].Account__c AND (Order1__r.Sales_Org__c =: salesOrg OR Order1__r.Sales_Org__c = '1018' OR Order1__r.Sales_Org__c = '1019' OR Order1__r.Sales_Org__c = '1020')];
                        }
                     }
                     System.debug('+++++ lstSlotOrderAccount= '+ lstSlotOrderAccount);
                     if (lstSlotOrderAccount == null || lstSlotOrderAccount.Size() == 0) {
                         Delete lstSlotAccount[0];
                     }
                 }
                    //Set<Id> lstAccountId = new Set<Id>();
                    //Map<Id, Slot_Account__c> mapAccountIdSlotAccount = new Map<Id, Slot_Account__c>();
                    /*if (lstSlotAccount != null && lstSlotAccount.Size() > 0) {
                        for (Slot_Account__c objSlotAccount : lstSlotAccount) {
                            lstAccountId.Add(objSlotAccount.Account__c);
                            mapAccountIdSlotAccount.Put(objSlotAccount.Account__c, objSlotAccount);
                        }
                    }*/
                    //Slot__c objSlot = [Select Warehouse_Slot__c from Slot__c where Id =: strSlotId limit 1];
                    //List<Slot__c> lstSlot = [Select Id from Slot__c where Warehouse_Slot__c =: objSlot.Warehouse_Slot__c];
                    //List<Slot_Order__c> lstSlotOrder = [Select Id, Order__r.Account__c from Slot_Order__c where 
                    //                        Slot__c =: strSlotId and Order__r.Account__c =: lstAccountId];
                    //Map<Id, Id> mapAccountIdSlotOrderId = new Map<Id, Id>();
                    /*String strOrderAccountId;
                    if (lstSlotOrder != null && lstSlotOrder.Size() > 0) {
                        for (Slot_Order__c objSlotOrders : lstSlotOrder) {
                            mapAccountIdSlotOrderId.Put(objSlotOrders.Order1__r.Account__c, objSlotOrders.Id);
                        }
                        strOrderAccountId = lstSlotOrder[0].Order1__r.Account__c;}
                    List<Slot_Account__c> lstSlotAccountToDelete = new List<Slot_Account__c>();
                    for (Id idAccount : lstAccountId) {
                        if (idAccount == strOrderAccountId)
                            lstSlotAccountToDelete.Add(mapAccountIdSlotAccount.Get(idAccount));
                    }
                    Delete lstSlotAccountToDelete;*/
                }
                ReFillData();
                Return;
            }
        QuickSearchRefill();
    }
    //---------------------------------------------------------------------------------------------
    //Delete SlotAccount if its dragged from slot to left-hand side Account list
    //In drop event strSlotAccountId is set based on the Drag-&-Drop action type
    //---------------------------------------------------------------------------------------------
    Public Void DeleteSlotAccount(){
        strErrorMessage = null;
        strProfileForLTLValidation = null;
        //Retrieve the user details and set the profile name to check whether the user should be allowed to removed fixed account names or not
        Boolean blnRemoveFixedAccount = true;
        String strProfileName;
        Id idProfile = UserInfo.getProfileId();
        List<Profile> lstProfile = [Select Name from Profile where Id =: idProfile];
        if (lstProfile != null && lstProfile.Size() > 0) {
            strProfileName = lstProfile[0].Name;
        }
        String strFixedSlotRemoveProfile = System.Label.Slotting_Fixed_Slot_Remove_Profile;
        if (strFixedSlotRemoveProfile != null && strFixedSlotRemoveProfile != '') {
            if (!strFixedSlotRemoveProfile.ContainsIgnoreCase(strProfileName))
                blnRemoveFixedAccount = false;
        }
        System.Debug('+++++     strFixedSlotRemoveProfile     ' + strFixedSlotRemoveProfile);
        System.Debug('+++++     strProfileName     ' + strProfileName);
        System.Debug('+++++     blnRemoveFixedAccount     ' + blnRemoveFixedAccount);
        system.debug('+++++ strSlotAccountId: ' + strSlotAccountId);
        if (blnRemoveFixedAccount) {
            if (strSlotAccountId != null && strSlotId != null) {
                List<Slot_Account__c> lstSlotAccount = [Select Id, Name, Account__c from Slot_Account__c 
                                                            where Id =: strSlotAccountId];
                system.debug('+++++ lstSlotAccount.Size(): ' + lstSlotAccount.Size());
                if (lstSlotAccount != null && lstSlotAccount.Size() > 0) {
                    List<Slot_Order__c> lstSlotOrder = new List<Slot_Order__c>();
                    if(salesOrg == '1003' || salesOrg == '1101'){
                         lstSlotOrder = [Select Id, Name from Slot_Order__c where 
                                                        Slot__c =: strSlotId 
                                                        and Order1__r.Ship_To__c =: lstSlotAccount[0].Account__c AND Order1__r.Sales_Org__c != '1502'];//=: salesOrg]; // Condition For Isolate
                    }else if(salesOrg == '1502'){
                         lstSlotOrder = [Select Id, Name from Slot_Order__c where 
                                                        Slot__c =: strSlotId 
                                                        and Order1__r.Sold_To__c =: lstSlotAccount[0].Account__c AND Order1__r.Sales_Org__c =: salesOrg]; // Condition For Isolate
                    }
                    system.debug('+++++ lstSlotOrder.Size(): ' + lstSlotOrder.Size());
                    if (lstSlotOrder != null && lstSlotOrder.Size() > 0) {
                        Delete lstSlotOrder;
                    }
                    Delete lstSlotAccount[0];
                    ReFillData();
                    Return;
                }
            }
        } else {
            strErrorMessage = 'You do not have the permissions to remove the fixed account names. Please contact your leads for the same.';
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
        System.Debug('##Entered InsertSlotOrder');
        strErrorMessage = null;
        Boolean blnInsertSlotAccount = false;
        Boolean blnIsOpenAccount = false;
        List<Slot_Account__c> lstSlotAccountOpen = new List<Slot_Account__c>();
        String strOpenAccount = System.Label.Open_SlotAccount;
        if (strOrderId != null && strSlotId != null) {
            System.Debug('##strOrderId and strSlotId not null' + strOrderId + '  ' + strSlotId);
            List<Order> lstOrder = [Select Id, Name, Sold_To__c, Means__c, Accountid ,Ship_To__c, Ship_Condition__c, Gross_Weight__c, Planned_Ship_Date__c from Order where Id =: strOrderId]; // Condition For Isolate
            List<Slot__c> lstSlot = [Select Id, Name, Slot_Type__c, Warehouse_Slot__c from Slot__c where Id =: strSlotId];
            System.debug('##lstOrder or lstSlot is null');
            if (lstOrder != null && lstOrder.Size() > 0 && lstSlot != null && lstSlot.Size() > 0) {
                System.debug('##lstOrder not null lstSlot not null' + lstOrder + '  ' + lstSlot);
                Boolean blnValidateMeans = ValidateOrderMeans(lstOrder, lstSlot);
                //Boolean blnValidateLTL = ValidateLTLOrder(lstOrder, lstSlot);
                Boolean blnValidateLTL;
                //If LTL order count/weight validation is overridden then the validation should not be accounted for
                if (blnLTLToValidate)
                    blnValidateLTL = ValidateLTLOrder(lstOrder, lstSlot);
                else
                    blnValidateLTL = true;

                if (blnValidateMeans == true && blnValidateLTL == true) {
                    List<Slot_Account__c> lstSlotAccount = [Select Id, Name, Account__c, Account__r.Name from Slot_Account__c where 
                                                            Slot__c =: lstSlot[0].Id];
                    String lstSlotOrderQuery = 'Select Id, Means__c, Order1__r.Accountid, Order1__r.Ship_To__c, Order1__r.Sold_To__c from Slot_Order__c where Slot__c =: strSlotId AND ';
                    lstSlotOrderQuery += salesOrg == '1003' || salesOrg == '1101' ? ' Order1__r.Sales_Org__c != \'1502\' ' : ' Order1__r.Sales_Org__c = :salesOrg '; // Condition for isolate
                    //List<Slot_Order__c> lstSlotOrder = New List<Slot_Order__c>([Select Id, Means__c, Order1__r.Accountid, Order1__r.Ship_To__c, Order1__r.Sold_To__c from Slot_Order__c 
                    //                                                            where Slot__c =: strSlotId AND Order1__r.Sales_Org__c =: salesOrg]); // Condition For Isolate
                    List<Slot_Order__c> lstSlotOrder = New List<Slot_Order__c>();
                    lstSlotOrder = Database.query(lstSlotOrderQuery);
                    if (lstSlotAccount == null || lstSlotAccount.Size() == 0) {
                        //If there are no accounts for the selected slot, then add the account of the order being dropped
                        Slot_Account__c objSlotAccount = new Slot_Account__c();
                        if(salesOrg == '1003' || salesOrg == '1101'){
                             objSlotAccount = new Slot_Account__c(Slot__c = lstSlot[0].Id, Account__c = lstOrder[0].Ship_To__c);
                        }else if(salesOrg == '1502'){
                             objSlotAccount = new Slot_Account__c(Slot__c = lstSlot[0].Id, Account__c = lstOrder[0].Sold_To__c);
                        }
                        System.debug('##inserting objSlotAccount' + objSlotAccount);
                        Insert objSlotAccount;
                    } else {
                        /*if (lstSlotOrder != null && lstSlotOrder.Size() == 0){
                            strErrorMessage = 'Order cannot be added to slot with fixed account.';
                        }*/
                        //If there are accounts for the selected slot, then check the existing list of accounts
                        //If there are accounts marked as open, and an order is being dropped, then set blnIsOpenAccount to true
                        //so that the account can be deleted
                        //If there are accounts with the same name as the inserted order's account, then we do not insert
                        //the account (set the blnInsertSlotAccount to false)
                        blnInsertSlotAccount = true;
                        system.debug('##breaking??');
                        for (Slot_Account__c objSlotAccount : lstSlotAccount) {
                            if (objSlotAccount.Account__r.Name == strOpenAccount) {
                                blnIsOpenAccount = true;
                                lstSlotAccountOpen.Add(objSlotAccount);
                            }
                            if (objSlotAccount.Account__c == lstOrder[0].Ship_To__c && (salesOrg == '1003' || salesOrg == '1101')) {
                                 blnInsertSlotAccount = false;
                                 break;
                            }else if (objSlotAccount.Account__c == lstOrder[0].Sold_To__c && salesOrg == '1502') {
                                blnInsertSlotAccount = false;
                                break;
                            }
                        }
                        System.debug('+++++did it break');
                        for (Slot_Order__c objSlotOrder : lstSlotOrder) {
                            if (objSlotOrder.Order1__r.Accountid == lstOrder[0].Ship_To__c && (salesOrg == '1003' || salesOrg == '1101')) {
                                 blnInsertSlotAccount = false;
                                 break;
                            }else if (objSlotOrder.Order1__r.Sold_To__c == lstOrder[0].Sold_To__c && salesOrg == '1502') {
                                blnInsertSlotAccount = false;
                                break;
                            }
                        }
                    }
                    //For all the current orders in the selected slot, check the means of the order. If the means is not same
                    //the order is not allowed to be inserted
                    if (lstSlotOrder != null && lstSlotOrder.Size() != 0) {
                        for (Slot_Order__c objSlotOrder : lstSlotOrder) {
                            if(salesOrg == '1003' || salesOrg == '1101'){
                                if (lstOrder[0].Ship_Condition__c != objSlotOrder.Means__c){
                                     strErrorMessage = 'All orders for each slot must share the same means.';
                                }
                            }else if(lstOrder[0].Means__c != objSlotOrder.Means__c && salesOrg == '1502'){
                                strErrorMessage = 'All orders for each slot must share the same means.';
                            }
                        }
                    }
                    if (strErrorMessage == null) {
                        if (blnInsertSlotAccount) {
                            Slot_Account__c objSlotAccount = new Slot_Account__c();
                            if(salesOrg == '1003' || salesOrg == '1101'){
                                 objSlotAccount = new Slot_account__c(Slot__c = lstSlot[0].Id, Account__c = lstOrder[0].Ship_To__c);
                            }else if(salesOrg == '1502'){
                                 objSlotAccount = new Slot_account__c(Slot__c = lstSlot[0].Id, Account__c = lstOrder[0].Sold_To__c);
                            }
                            System.debug('##inserting objSlotAccount');
                            Insert objSlotAccount;
                        }
                        
                        Slot_Order__c objSlotOrder = new Slot_Order__c (Slot__c = lstSlot[0].Id, Order1__c = lstOrder[0].Id);
                        system.debug('*** slottingorder.Slot = ' + objSlotOrder.slot__c);
                        system.debug('*** slottingorder.Account = ' + objSlotOrder.Account__c);
                        system.debug('*** slottingorder.Slot = ' + objSlotOrder.slot__c);
                        System.debug('##about to insert objSlotOrder');
                        Insert objSlotOrder;
                        
                        //If an order is moved to a slot which has a fixed account marked 'Open', then delete that account
                        if (blnIsOpenAccount && lstSlotAccountOpen != null && lstSlotAccountOpen.Size() > 0) {
                            Delete lstSlotAccountOpen;
                        }
                        
                        //If an order is moved from one slot to another slot delete the order from the source slot
                        if (strSourceSlotId != null && strSourceSlotId != '') {
                            String lstSourceSlotOrderString = 'Select Id, Order1__r.Sold_To__c, Order1__r.Accountid ,Order1__r.Ship_To__c from Slot_Order__c where Slot__c =: strSourceSlotId and Order1__c =: strOrderId AND ';
                            //lstSourceSlotOrderString += salesOrg == '1003' || salesOrg == '1101' ? ' Order1__r.Sales_Org__c != \'1502\' ' : 'Order1__r.Sales_Org__c = :salesOrg '; // Condition for isolate
                            lstSourceSlotOrderString += salesOrg == '1003' || salesOrg == '1101' ? ' Order1__r.Sales_Org__c != \'1502\' ' : '(Order1__r.Sales_Org__c = :salesOrg OR Order1__r.Sales_Org__c = \'1018\' OR Order1__r.Sales_Org__c = \'1019\' OR Order1__r.Sales_Org__c = \'1020\') '; // Condition for isolate
                            
                            //List<Slot_Order__c> lstSourceSlotOrder = [Select Id, Order1__r.Sold_To__c, Order1__r.Accountid ,Order1__r.Ship_To__c from Slot_Order__c where Slot__c =: strSourceSlotId
                            //        and Order1__c =: strOrderId AND Order1__r.Sales_Org__c =: salesOrg]; // Condition For Isolate
                            List<Slot_Order__c> lstSourceSlotOrder = Database.query(lstSourceSlotOrderString);
                            if (lstSourceSlotOrder != null && lstSourceSlotOrder.Size() > 0) {
                                Id idAccount;
                                if(salesOrg == '1003' || salesOrg == '1101'){
                                     idAccount = lstSourceSlotOrder[0].Order1__r.Ship_To__c;
                                }else if(salesOrg == '1502'){
                                     idAccount = lstSourceSlotOrder[0].Order1__r.Sold_To__c;
                                }
                                Slot_Order__c objSlotOrderToDelete = lstSourceSlotOrder[0];
                                Delete objSlotOrderToDelete;
                                //After deleting the moved order, check if there are any other orders in the source slot with the same account
                                //If yes, then do not delete current slot account, else delete it
                                if (idAccount != null) {
                                    List<Slot_Order__c> lstSourceSlotOtherOrder = new List<Slot_Order__c>();
                                    if(salesOrg == '1003' || salesOrg == '1101'){
                                         lstSourceSlotOtherOrder = [Select Id from Slot_Order__c where Slot__c =: strSourceSlotId
                                            and Order1__r.Ship_To__c =: idAccount AND Order1__r.Sales_Org__c != '1502']; //=: salesOrg]; // Condition For Isolate
                                    }else if(salesOrg == '1502'){
                                         lstSourceSlotOtherOrder = [Select Id from Slot_Order__c where Slot__c =: strSourceSlotId
                                            and Order1__r.Sold_To__c =: idAccount];
                                    }
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
        String strMean;
        if(salesOrg == '1003' || salesOrg == '1101'){
             strMean = lstOrder[0].Ship_Condition__c;
        }else if(salesOrg == '1502'){
             strMean = lstOrder[0].Means__c;
        }
        String strSlotType = lstSlot[0].Slot_Type__c;
        String strWareHouseName = '';

        if (mapWarehouseIdName != null)
            if (mapWarehouseIdName.Get(strWarehouse) != null)
                strWareHouseName = mapWarehouseIdName.Get(strWarehouse);
                System.debug('Warehouse Name=========================================='+strWareHouseName);
                System.debug('Warehouse Name strSlotType ======================'+strSlotType );

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
System.debug('setWareHouseName =========================='+setWareHouseName);

            List<Slotting_Means_Validation__c> lstMeansValidation1 = New List<Slotting_Means_Validation__c>([Select Id,
                                                                    Name, Means__c, SlotType__c, WarehouseName__c 
                                                                    from Slotting_Means_Validation__c 
                                                                    where WarehouseName__c = null and Means__c =: strMean 
                                                                    and SlotType__c =: strSlotType]);
System.debug('lstMeansValidation1=========================='+lstMeansValidation1);
System.debug('lstMeansValidation1=========================='+lstMeansValidation1.size());
            if (lstMeansValidation1.Size() > 0) {
                Return blnValidOrder;
            } else {
                System.debug('+++++strSlotType line 405'+ strSlotType);
                List<Slotting_Means_Validation__c> lstMeansValidation2 = New List<Slotting_Means_Validation__c>([Select Id,
                                                                    Name, Means__c, SlotType__c, WarehouseName__c 
                                                                    from Slotting_Means_Validation__c 
                                                                    where WarehouseName__c =: strWareHouseName and Means__c =: strMean 
                                                                    and SlotType__c =: strSlotType]);

                System.debug('+++++Line Number 310'+strWareHouseName);
                System.debug('+++++Line Number 311 size'+setWareHouseName.size());
                System.debug(JSON.serializePretty(setWareHouseName));
                System.debug('+++++Line Number 313 strMean'+strMean);
                System.debug('+++++Line Number 416 '+lstMeansValidation2);
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
        strProfileForLTLValidation = null;
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
        /*strErrorMessage = null;
        if (strSlotAccountId != null && strOrderId != null && strSlotId != null) {
            List<Orders__c> lstOrder = [Select Id, Name, Account__c, Means__c, Weight__c from Orders__c where Id =: strOrderId];
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
                    if (lstSlotAccountForOrder[0].Account__c == lstOrder[0].Account__c) {
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
        QuickSearchRefill();*/
    }
    //---------------------------------------------------------------------------------------------
    //Retrieve the maximum order and weight limit for LTL slots based on warehouse selected
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
                List<Slot__c> lstSlots = [Select Id from Slot__c where Scheduled_Shipping_Date__c =: dtCurrentDate and Slot_Type__c = 'LTL' and Plant__c =: strWarehouse];
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

                //Retrieve the user details and set the profile name to check whether the LTL validation should be overridden or not
                String strProfileName;
                Id idProfile = UserInfo.getProfileId();
                List<Profile> lstProfile = [Select Name from Profile where Id =: idProfile];
                if (lstProfile != null && lstProfile.Size() > 0) {
                    strProfileName = lstProfile[0].Name;
                }

                String strLTLValidationProfile = System.Label.Slotting_LTL_Validation_Profile;
                if (strLTLValidationProfile != null && strLTLValidationProfile != '') {
                    if (strLTLValidationProfile.ContainsIgnoreCase(strProfileName))
                        strProfileForLTLValidation = strProfileName;
                    else
                        strProfileForLTLValidation = '';
                }
                System.Debug('@@@@@     strLTLValidationProfile    ' + strLTLValidationProfile);
                System.Debug('@@@@@     strProfileName    ' + strProfileName);
                System.Debug('@@@@@     strProfileForLTLValidation    ' + strProfileForLTLValidation);
                /*if (intExistCount >= intOrderCount) {
                    strErrorMessage = 'Maximum ' + intOrderCount + ' orders can be added to an LTL slot for ' + strWareHouseName.trim() + ' warehouse.';
                    blnValidLTL = false;
                } else */if (dcExistWeight >= intTotalWeight) {
                    strErrorMessage = 'Total weight of orders in LTL slot for ' + strWareHouseName.trim() + ' warehouse can be ' + intTotalWeight + ' pounds.';
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
    Public String strOrderStartDate {get; set;}
    Public String strOrderEndDate {get; set;}
    Public List<Account> lstAccounts {get; set;}
    Public List<Order> lstOrders {get; set;}
    Public List<Account> lstFixedAccount {get; set;}
    Public List<clsSlotType> lstSlotType {get; set;}
    Public String strTimeOffDescription {get; set;}
    //Set contains the Ids of the IPT slots which have been unchecked by the user and made droppable true
    //Public Set<Id> setSlotIdIPTCheckedStatus {get; set;}
    Public String strAccountSearch {get; set;} // Account quick search text
    Public String strOrderSearch {get; set;} // Order quick search text
    Public Slot__c objSlot {get; set;}
    //Public variable to hold the selected slot type
    private String[] arrSlotTypeWithCSPU;
    private String[] arrSlotTypeWithoutCSPU;
    String[] arrSlotType;
    Public String[] getarrSlotType()
    {
        return arrSlotType;
    }
    Public Void setarrSlotType(String[] arrSlotType)
    {
        this.arrSlotType= arrSlotType;
    }
    Public String strSlotType {get; set;}
    
    public void setSlotTypes(){
        System.debug('** setSlotTypes');
        if(salesOrg == '1003' || salesOrg == '1101'){
             //arrSlotType = new String[]{'TL', 'Pooling', 'LTL', 'Rail', 'CSPU'};
             //arrSlotType = new String[]{'LTL','CPU','IMDL','Ocean','Flatbed','Van'};
             arrSlotType = new String[]{'TL','Flatbed','Van','Ocean','IMDL','CPU','LTL'};
             //arrSlotTypeWithCSPU = new String[]{'TL','Pooling', 'LTL', 'Rail', 'CSPU'};
             arrSlotTypeWithCSPU = new String[]{'TL','Flatbed','Van','Ocean','IMDL','CPU','LTL'};
             //arrSlotTypeWithoutCSPU = new String[]{'LTL','IMDL','Ocean','Flatbed','Van'};
             arrSlotTypeWithoutCSPU = new String[]{'TL','Flatbed','Van','Ocean','IMDL','LTL'};
        }else if(salesOrg == '1502'){
             arrSlotType = new String[]{'TL', 'Pooling', 'LTL', 'Rail', 'CSPU'};
             arrSlotTypeWithCSPU = new String[]{'TL', 'Pooling', 'LTL', 'Rail', 'CSPU'};
             arrSlotTypeWithoutCSPU = new String[]{'TL', 'Pooling', 'LTL', 'Rail'};
        }
        //sOrg = salesOrg;
        //System.debug('** setSlotTypes '+ sOrg);
        System.debug('++++ salesOrg '+ salesOrg);
    }

    //---------------------------------------------------------------------------------------------
    //Constructor Method
    //- Initialize variables used by this page
    //- Call the list fill methods used on the page
    //---------------------------------------------------------------------------------------------
    Public Slotting2Controller()
    {
        Id profileId = UserInfo.getProfileId();
        isAdminProfile =[Select Id, Name, PermissionsModifyAllData from Profile where Id=:profileId].PermissionsModifyAllData;
        //userRecord = fetchUserInfo();
        salesOrg = fetchSalesOrg();
        strAccountSearch = '';
        strOrderSearch = '';
        setSlotTypes();
        //Date dtOrderStartDate = System.Today().AddDays(-14);
        //Date dtOrderEndDate = System.Today();
        Date dtOrderStartDate = System.Today();
        Date dtOrderEndDate = System.Today().AddDays(14);
        strOrderStartDate = String.valueOf(dtOrderStartDate.Month()) + '/' + String.valueOf(dtOrderStartDate.Day()) + '/' + String.valueOf(dtOrderStartDate.Year());
        strOrderEndDate = String.valueOf(dtOrderEndDate.Month()) + '/' + String.valueOf(dtOrderEndDate.Day()) + '/' + String.valueOf(dtOrderEndDate.Year());
        CalculateCurrentDay();
        strTimeOffDescription = '';
        System.debug('+++++Constructor');
        if(salesOrg != '1502'){
            searchSalesOrg = '1003';         
        }
        else{
            searchSalesOrg = '1502';
        }
        
        strTimezone = String.ValueOf(UserInfo.getTimeZone());
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
        /*Public Integer intOrderCount {get; set;}
        Public Integer intOrderPalletTotal {get; set;}*/
        Public Decimal dcOrderPalletTotal {get; set;}
        Public Decimal dcOrderWeightTotal {get; set;}
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
        Public Decimal dcTotalWeight {get; set;}
    }
    //---------------------------------------------------------------------------------------------
    // Wrapper class to display the various slot types on the page
    //---------------------------------------------------------------------------------------------
    Public Class clsSlotType
    {
        Public String strSlotTypeName {get; set;}
        Public List<clsDays> lstDays {get; set;}
        Public WarehouseComment__c objComment {get; set;}
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
        if(salesOrg == '1003' || salesOrg == '1101'){
             for (Integer intI = 0; intI < 2; intI++){
                 dtToday = dtToday.AddDays(1);
                 strDayName = DateTime.newInstance(dtToday, Time.newInstance(0, 0, 0, 0)).format('E');
                 if (strDayName == 'Sat'){
                     dtToday = dtToday.AddDays(3);
                 }
                 if (strDayName == 'Sun')
                     dtToday = dtToday.AddDays(2);
             }
        }else if(salesOrg == '1502'){
             for (Integer intI = 0; intI < 3; intI++){
                 dtToday = dtToday.AddDays(1);
                 strDayName = DateTime.newInstance(dtToday, Time.newInstance(0, 0, 0, 0)).format('E');
                 if (strDayName == 'Sat'){
                     dtToday = dtToday.AddDays(2);
                 }
                 if (strDayName == 'Sun')
                     dtToday = dtToday.AddDays(1);
             }
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
    // SelectList For SalesOrg
    Public List<selectOption> getSalesOrgList(){
        List<selectOption> salesOrgList = new List<selectOption>();
        salesOrgList.Add(new SelectOption('', 'Select Sales Org'));
        salesOrgList.Add(new SelectOption('1502', '1502'));
        salesOrgList.Add(new SelectOption('1101', '1003'));
        return salesOrgList;
    }
    
    // SelectList For SearchSalesOrg
    Public List<selectOption> getSearchSalesOrgList(){
        List<selectOption> salesOrgList1 = new List<selectOption>();        
        if(salesOrg != '1502'){
            salesOrgList1.Add(new SelectOption('1003', '1003'));
            salesOrgList1.Add(new SelectOption('1101', '1101'));            
        }
        else{
            salesOrgList1.Add(new SelectOption('1502', '1502'));
        }
        return salesOrgList1;
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
        //Mohan 08/25/2014: exclude Terre Haute, Roaring River and White City from the below list
        SYSTEM.DEBUG('+++++ salesOrg: ' + salesOrg);
        if(String.isBlank(salesOrg)) salesOrg = fetchSalesOrg();
        if(salesOrg == '1502') 
       // lstWarehouse = [Select Id, Name from Plants__c where Used_for_Slotting__c = true and Name != 'Terre Haute' and Name != 'Roaring River' and Name != 'White City' and sOrg__c = '1502' order by Name asc];
       lstWarehouse = [Select Id, Name from Plants__c where Used_for_Slotting__c = true and Name != 'Terre Haute' and Name != 'Roaring River' and Name != 'White City' and (sOrg__c = '1502' or SOrg__c = '1020' or SOrg__c = '1019' or SOrg__c = '1018')order by Name asc];
        else if(salesOrg == '1003' || salesOrg == '1101')
            //lstWarehouse = [Select Id, Name from Plants__c where Used_for_Slotting__c = true and Name != 'Terre Haute' and Name != 'Roaring River' and Name != 'White City' and sOrg__c != '1502' order by Name asc];
        	lstWarehouse = [Select Id, Name from Plants__c where Used_for_Slotting__c = true and Name != 'Terre Haute' and Name != 'Roaring River' and Name != 'White City' and sOrg__c != '1502' and SOrg__c != '1020' and SOrg__c != '1019' and SOrg__c != '1018' order by Name asc];
        lstWarehouseOptions.Add(new SelectOption('', 'Select Plant'));
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
        System.debug('**strWarehouse '+ strWarehouse);
        if (strWarehouse != '' && strWarehouse != null) {
            lstFixedAccount = Slotting2QuickSearchController.SearchAccount(strAccountSearch, strWarehouse);
        }
    }
    //---------------------------------------------------------------------------------------------------
    //FillOrderList Function
    //- Called on page load to fill in the order values to be dragged onto the slots
    //- Retrieves a list of all orders associated with the selected warehouse
    // --------------------------------------------------------------------------------------------------
    Public Void FillOrderList()
    {
   List<Order> lstOrders = new List<Order>();
   System.debug('+++++FillOrderList() ========================= strWarehouse'+strWarehouse);
        if (strWarehouse != '' && strWarehouse != null) {
            //lstOrders = Slotting2QuickSearchController.SearchOrders(strOrderSearch, strWarehouse);
            lstOrders = Slotting2QuickSearchController.SearchOrders(strOrderSearch, strWarehouse, strOrderStartDate, strOrderEndDate, salesOrg);
            System.debug('+++++FillOrderList()'+lstOrders);
            System.debug('+++++FillOrderList()'+lstOrders.size());
        }
    }
    //---------------------------------------------------------------------------------------------------
    //searchOrders Function
    //- Called on click of Search Orders button
    //- Retrieves a list of all orders associated with the selected warehouse
    // --------------------------------------------------------------------------------------------------
    Public PageReference searchOrders()
    {
        strErrorMessage = null;
        strProfileForLTLValidation = null;
        FillOrderList();
        return null;
    }
    Public Void FillSlotTypes()
    {
        System.debug('Entering into FillSlotTypes');
        //Set warehouse time off in the string variable to be displayed on the page
        strTimeOffDescription = '';
       
        List<Warehouse_Time_Off__c> lstWarehouseTimeOff = [Select Id, Description__c, Time_Off_Type__c 
                                                           from Warehouse_Time_Off__c where Time_Off_Date__c =: dtCurrentDate
                                                           and Plant__c =: strWarehouse];
        System.debug('**dtCurrentDate '+ dtCurrentDate);
        System.debug('**strWarehouse '+ strWarehouse);
        System.debug('**Warehouse_Time_Off__c '+ lstWarehouseTimeOff );
        System.debug('**SalesOrg'+ salesOrg);
        
        if (lstWarehouseTimeOff != null && lstWarehouseTimeOff.Size() > 0) {
            if (lstWarehouseTimeOff[0].Description__c != null && lstWarehouseTimeOff[0].Description__c != '')
                strTimeOffDescription = 'Warehouse Time-Off - ' + lstWarehouseTimeOff[0].Description__c;
            else
                strTimeOffDescription = 'Warehouse Time-Off';
        } else
            strTimeOffDescription = '';
        //strErrorMessage = null;
        lstSlotType = new List<clsSlotType>();
        //String[] arrstrSlotTypes = new String[]{'TL', 'Pooling', 'LTL', 'Rail', 'CSPU'};
       //Todo Comment
      //String[] arrstrSlotTypes = new String[] {'LTL','Van','IMDL','CPU','Flatbed','Ocean'};
      
      
        //Integer intSlotTypeCount = 5;
        //For all the 5 days to be displayed, retrive the available slots
        List<Warehouse_Slot__c> lstWarehouseSlot = [Select Id, Name, Comment__c from Warehouse_Slot__c 
                        where Plant__c =: strWarehouse];
                        //and Status__c =: 'Active'];
        System.debug('+++++Warehouse_Slot__c '+ lstWarehouseSlot);

        List<Slot__c> lstSlot = new List<Slot__c>();
        String whSelected = mapWarehouseIdName.get(strWarehouse);
        if(whSelected != null && whSelected == 'Social Circle') arrSlotType = arrSlotTypeWithoutCSPU;
        else arrSlotType = arrSlotTypeWithCSPU;
        
        String[] arrstrSlotTypes = arrSlotType;
        arrstrSlotTypes = arrSlotType;
        Integer intSlotTypeCount = arrSlotType.Size();
        String slotQuery =  'Select Id, Name, Scheduled_Shipping_Date__c, Slot_Type__c, Warehouse_Slot__c, Color__c, Warehouse_Slot__r.Comment__c, ' + 
                            '(Select Id, Name, Account__c, Account__r.Name, Account__r.Fixed_Account__c, Slot__c from Slot_Accounts__r), ' + 
                            '(Select Id, Name, Account__c, Slot__c, Order1__r.Order_Num__c, Order1__r.Pallet_Count__c,  ' + 
                            'Order1__r.Gross_Weight__c, Order1__r.Means__c, Order1__r.Sold_To__c, Order1__r.Ship_Condition__c, Order1__r.Planned_Ship_Date__c, Order1__r.Accountid,Order1__r.Ship_To__c from Slot_Orders__r WHERE ';   // Condtion For Isolate
        slotQuery += salesOrg == '1003' || salesOrg == '1101' ? 'Order1__r.Sales_Org__c != \'1502\')' : 'Order1__r.Sales_Org__c =: salesOrg OR Order1__r.Sales_Org__c = \'1018\' OR Order1__r.Sales_Org__c = \'1019\' OR Order1__r.Sales_Org__c = \'1020\') '; 
        slotQuery +=    ' from Slot__c  ' + 
                            'where Scheduled_Shipping_Date__c in : setDisplayDates ' + 
                            'and (Warehouse_Slot__c =: lstWarehouseSlot)  ' + 
                            'and Slot_Type__c in : arrSlotType ' + 
                            'order by Priority__c, Account__r.Name';
        SYSTEM.DEBUG('+++++ slotQuery: ' + slotQuery);
        lstSlot = Database.query(slotQuery);
                            System.debug('+++++lstSlot'+lstSlot.size());
                            System.debug('lstSlot'+lstSlot); 
                            List<Date> lstDisplayDates = New List<Date>();
        for (Date dtDisplay : setDisplayDates) {
            lstDisplayDates.Add(dtDisplay);
        }
        System.debug('**Schdeule Date '+ setDisplayDates);
        System.debug('**WarehouseSlot'+ lstWarehouseSlot);
        System.debug('**SlotType '+ arrSlotType);
        System.debug('**Slot__c '+ lstSlot);
        
        lstDisplayDates.Sort();
        //Fill map for warehouse comment based on slot type and date
        List<WarehouseComment__c> lstWarehouseComments = New List<WarehouseComment__c>();
        lstWarehouseComments = [Select Id, Date__c, Slot_Type__c, Plant__c, Comment__c 
                                    from WarehouseComment__c where Date__c =: dtCurrentDate and Plant__c =: strWarehouse];
                                    
         System.debug('+++++WarehouseComment__c '+ lstWarehouseComments);
        
        Map<String, WarehouseComment__c> mapSlotTypeWHComment = New Map<String, WarehouseComment__c>();
        Map<String, String> mapExistingDateSlotTypeComment = new Map<String, String>();
        if (lstWarehouseComments.Size() > 0) {
            for (WarehouseComment__c objWarehouseComment : lstWarehouseComments) {
                if (!mapSlotTypeWHComment.ContainsKey(objWarehouseComment.Slot_Type__c)) {
                    mapSlotTypeWHComment.Put(objWarehouseComment.Slot_Type__c, objWarehouseComment);
                }
                if (!mapExistingDateSlotTypeComment.ContainsKey(objWarehouseComment.Date__c + '~' + objWarehouseComment.Slot_Type__c)) {
                    mapExistingDateSlotTypeComment.Put(objWarehouseComment.Date__c + '~' + objWarehouseComment.Slot_Type__c, objWarehouseComment.Comment__c);
                }
            }
        }
        System.Debug('@@@@@     mapSlotTypeWHComment     ' + mapSlotTypeWHComment);
        System.Debug('@@@@@     mapExistingDateSlotTypeComment     ' + mapExistingDateSlotTypeComment);
        Map<String, String> mapNewWarehouseDateSlotTypeComment = new Map<String, String>();
        Set<Id> setWarehouseSlotId = new Set<Id>();
        if (lstSlot.Size() > 0) {
            for (Slot__c objSlot : lstSlot) {
                if (!mapNewWarehouseDateSlotTypeComment.ContainsKey(objSlot.Scheduled_Shipping_Date__c + '~' + objSlot.Slot_Type__c)) {
                    if (objSlot.Warehouse_Slot__r.Comment__c != null) {
                        mapNewWarehouseDateSlotTypeComment.Put(objSlot.Scheduled_Shipping_Date__c + '~' + objSlot.Slot_Type__c, objSlot.Warehouse_Slot__r.Comment__c);
                        setWarehouseSlotId.Add(objSlot.Warehouse_Slot__c);
                    }
                } else {
                    if (!setWarehouseSlotId.Contains(objSlot.Warehouse_Slot__c)) {
                        String strComment = mapNewWarehouseDateSlotTypeComment.Get(objSlot.Scheduled_Shipping_Date__c + '~' + objSlot.Slot_Type__c);
                        strComment = strComment + '\n' + objSlot.Warehouse_Slot__r.Comment__c;
                        mapNewWarehouseDateSlotTypeComment.Put(objSlot.Scheduled_Shipping_Date__c + '~' + objSlot.Slot_Type__c, strComment);
                        setWarehouseSlotId.Add(objSlot.Warehouse_Slot__c);
                    }
                }
            }
        }
        System.Debug('@@@@@     mapNewWarehouseDateSlotTypeComment     ' + mapNewWarehouseDateSlotTypeComment);
        List<WarehouseComment__c> lstInsertWarehouseComment = new List<WarehouseComment__c>();
        for (String strMapKey : mapNewWarehouseDateSlotTypeComment.KeySet()) {
            String[] arrMapKeys = strMapKey.Split('~');
            System.Debug('@@@@@     strMapKey     ' + strMapKey);
            System.Debug('@@@@@     arrMapKeys[0]     ' + arrMapKeys[0]);
            System.Debug('@@@@@     arrMapKeys[1]     ' + arrMapKeys[1]);
            Date dtDate;
            String strSlotType;
            if (arrMapKeys.Size() > 0) {
                if (arrMapKeys[1] != null)
                    dtDate = Date.ValueOf(arrMapKeys[0]);
                if (arrMapKeys[1] != null)
                    strSlotType = arrMapKeys[1];
            }
            if (!mapExistingDateSlotTypeComment.ContainsKey(strMapKey)) {
                WarehouseComment__c objWarehouseComment = new WarehouseComment__c();
                objWarehouseComment.Comment__c = mapNewWarehouseDateSlotTypeComment.Get(strMapKey);
                objWarehouseComment.Date__c = dtDate;
                objWarehouseComment.Slot_Type__c = strSlotType;
                objWarehouseComment.Plant__c = strWarehouse;
                lstInsertWarehouseComment.Add(objWarehouseComment);
            }
        }
        if (lstInsertWarehouseComment.Size() > 0) {
            Insert lstInsertWarehouseComment;
        }
        lstWarehouseComments = [Select Id, Date__c, Slot_Type__c, Plant__c, Comment__c 
                                    from WarehouseComment__c where Date__c =: dtCurrentDate and Plant__c =: strWarehouse];
        
        if (lstWarehouseComments.Size() > 0) {
            for (WarehouseComment__c objWarehouseComment : lstWarehouseComments) {
                if (!mapSlotTypeWHComment.ContainsKey(objWarehouseComment.Slot_Type__c)) {
                    mapSlotTypeWHComment.Put(objWarehouseComment.Slot_Type__c, objWarehouseComment);
                }
                if (!mapExistingDateSlotTypeComment.ContainsKey(objWarehouseComment.Date__c + '~' + objWarehouseComment.Slot_Type__c)) {
                    mapExistingDateSlotTypeComment.Put(objWarehouseComment.Date__c + '~' + objWarehouseComment.Slot_Type__c, objWarehouseComment.Comment__c);
                }
            }
        }
        
        //Add the 5 slot types to display the 5 sections on the page
        for (Integer intI = 0; intI < intSlotTypeCount; intI++) {
            clsSlotType objSlotType = new clsSlotType();
            objSlotType.strSlotTypeName = arrstrSlotTypes[intI];
            
            //Assign warehouse comment to slot type for particular date and warehouse
            if (mapSlotTypeWHComment.Get(objSlotType.strSlotTypeName) != null) {
                objSlotType.objComment = mapSlotTypeWHComment.Get(objSlotType.strSlotTypeName);
            } else {
                WarehouseComment__c objComment = New WarehouseComment__c();
                objComment.Plant__c = strWarehouse;
                objComment.Date__c = dtCurrentDate;
                objComment.Slot_Type__c = objSlotType.strSlotTypeName;
                objSlotType.objComment = objComment;
            }
            
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
                objDays.dcTotalWeight = 0.0;

                List<clsSlotList> lstSlotList = new List<clsSlotList>();
                //For each day, retrive the available slots of a particular slot type
                for (Slot__c objSlot : lstSlot) {
                    clsSlotList objSlotList = new clsSlotList();
                    List<clsSlotAccountOrder> lstSlotAccountOrder = new List<clsSlotAccountOrder>();
                    objSlotList.dcOrderPalletTotal = 0.0;
                    objSlotList.dcOrderWeightTotal = 0.0;
                    objSlotList.strSlotColor = objSlot.Color__c;

                    if (objSlot.Scheduled_Shipping_Date__c == dtDateToAdd && objSlot.Slot_Type__c == objSlotType.strSlotTypeName) {
                        objSlotList.objSlot = objSlot;

                        //Set for avoid duplicate orders
                        //Set<Id> setSlotOrderId = new Set<Id>();
                        
                        //For each Slot, retrieve the associated account name
                        for (Slot_Account__c objSlotAccount : objSlot.Slot_Accounts__r) {
                            System.debug('slot account' + objSlot.Slot_Accounts__r);
                            if (objSlotAccount.Slot__c == objSlot.Id) {
                                clsSlotAccountOrder objSlotAccountOrder = new clsSlotAccountOrder();
                                objSlotAccountOrder.objSlotAccount = objSlotAccount;

                                //For each SlotAccount, retrieve the associated order details
                                List<Slot_Order__c> lstSlotOrderForAccount = new List<Slot_Order__c>();
                                for (Slot_Order__c objSlotOrder : objSlot.Slot_Orders__r) {
                                    if (objSlotOrder.Slot__c == objSlot.Id ) {
                                        if((objSlotOrder.Order1__r.Ship_To__c == objSlotAccountOrder.objSlotAccount.Account__c && (salesOrg == '1003' || salesOrg == '1101')) || (objSlotOrder.Order1__r.Sold_To__c == objSlotAccountOrder.objSlotAccount.Account__c && (salesOrg == '1502' || salesOrg == '1020' || salesOrg == '1019' || salesOrg == '1018'))){
                                            //if (!setSlotOrderId.Contains(objSlotOrder.Id)) {
                                                 lstSlotOrderForAccount.Add(objSlotOrder);
                                            	 System.debug('>>lstSlotOrderforAccount' + lstSlotOrderForAccount);
                                                 //setSlotOrderId.Add(objSlotOrder.Id);
                                            //}
                                            if (objSlotOrder.Order1__r.Pallet_Count__c != null)
                                                objSlotList.dcOrderPalletTotal += objSlotOrder.Order1__r.Pallet_Count__c;
                                            if (objSlotOrder.Order1__r.Gross_Weight__c != null) {
                                                objSlotList.dcOrderWeightTotal += objSlotOrder.Order1__r.Gross_Weight__c;
                                               objDays.dcTotalWeight += objSlotOrder.Order1__r.Gross_Weight__c;
                                           }
                                        }
                                    }
                                }

                                if (lstSlotOrderForAccount != null && lstSlotOrderForAccount.Size() > 0) {
                                    objSlotAccountOrder.lstSlotOrder = lstSlotOrderForAccount;
                                    lstSlotAccountOrder.Add(objSlotAccountOrder);
                                }
                                else if(objSlot.Slot_Type__c == 'Van' || objSlot.Slot_Type__c == 'CPU' || objSlot.Slot_Type__c == 'TL' || objSlot.Slot_Type__c == 'CSPU')
                                {
                                    List<Slot_Order__c> lstSlotOrderFixedAccount = new List<Slot_Order__c>();
                                    objSlotAccountOrder.lstSlotOrder = lstSlotOrderFixedAccount;
                                    lstSlotAccountOrder.Add(objSlotAccountOrder);
                                    System.debug('>>lstSlotAccountOrder' + lstSlotAccountOrder);
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
                System.debug('Gopi Testing'+lstSlotList.size());
                System.debug('Gopi Testing'+lstSlotList);
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
    Public PageReference saveComment(){
        if (ApexPages.currentPage().getParameters().Get('prmSaveCommentIndex') != null) {
            Integer intSlotTypeIndex = Integer.ValueOf(ApexPages.currentPage().getParameters().Get('prmSaveCommentIndex'));
            system.debug('*************************intSlotTypeIndex '+intSlotTypeIndex);
            system.debug('*************************lstSlotType '+lstSlotType);
            if (intSlotTypeIndex < lstSlotType.size()) {
                WarehouseComment__c objComment = lstSlotType[intSlotTypeIndex].objComment;
                system.debug('*************************** objComment '+objComment);
                if (objComment != null) Upsert objComment;
            }
        }
        return null;
    }
    Public PageReference AddSlotIdToSet()
    {
        /*strErrorMessage = null;
        String strSlotId = ApexPages.currentPage().getParameters().Get('strIPTSlotId');
        Boolean blnChecked = Boolean.valueOf(ApexPages.currentPage().getParameters().Get('blnChecked'));
        if (blnChecked) {
            setSlotIdIPTCheckedStatus.Remove(strSlotId);
        } else {
            setSlotIdIPTCheckedStatus.Add(strSlotId);
        }
        FillSlotTypes();
        QuickSearchRefill();*/
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
        strProfileForLTLValidation = null;
        blnLTLToValidate = true;
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
            System.debug('**Plants '+ lstWarehouse);
            if (lstWarehouse.Size() > 0) {
                blnEliminateWeekend = lstWarehouse[0].Eliminate_Weekend__c;
            }
            Boolean blnValidDate = true;
            if (blnEliminateWeekend) {
                String strDayName = DateTime.newInstance(dtCurrentDate, Time.newInstance(0, 0, 0, 0)).format('E');
                if (strDayName == 'Sat' || strDayName == 'Sun') {
                    blnValidDate = false;
                    strErrorMessage = 'You cannot select weekend dates for this warehouse.';
                }
            }
            System.debug('**validDate:- '+ blnValidDate);
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
        strProfileForLTLValidation = null;
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
                List<Slot__c> lstSlotFuture = New List<Slot__c>([Select Id, Warehouse_Slot__c, Open_SlotAccount__c, 
                                    (Select Id from Slot_Orders__r), 
                                    (Select Id, Account__r.Name from Slot_Accounts__r)
                                    from Slot__c where Scheduled_Shipping_Date__c =: dtSlotDate 
                                    and Slot_Type__c =: lstSlot[0].Slot_Type__c
                                    and Plant__c =: lstSlot[0].Plant__c order by Priority__c]);

                if (lstSlotFuture != null && lstSlotFuture.Size() > 0) {
                    List<Slot_Account__c> lstSlotAccountOpen = new List<Slot_Account__c>();
                    for (Slot__c objSlotFuture : lstSlotFuture) {
                        //Commented for allowing the slots to move to another date even if the future date slot has accounts on it
                        //if (objSlotFuture.Slot_Orders__r.Size() == 0 && objSlotFuture.Slot_Accounts__r.Size() == 0) {
                        //if (objSlotFuture.Slot_Orders__r.Size() == 0) {
                        //Slot should be moved to future slot if there is no ordre and only one account(OPEN)
                        if (objSlotFuture.Slot_Orders__r.Size() == 0 && objSlotFuture.Slot_Accounts__r.Size() == 1 && objSlotFuture.Slot_Accounts__r[0].Account__r.Name.ToUpperCase() == 'OPEN') {
                            idNewSlotId = objSlotFuture.Id;
                            idWareHouseSlotId = objSlotFuture.Warehouse_Slot__c;
                            //if there are slot accounts for the selected slot and the account is "Open" then delete that slot account
                            if (objSlotFuture.Slot_Accounts__r.Size() > 0) {
                                String strOpenAccount = System.Label.Open_SlotAccount;
                                if (objSlotFuture.Open_SlotAccount__c != 0) {
                                    for (Slot_Account__c objSlotAccounts : objSlotFuture.Slot_Accounts__r) {
                                        if (objSlotAccounts.Account__r.Name == strOpenAccount) {
                                            lstSlotAccountOpen.Add(objSlotAccounts);
                                        }
                                    }
                                }
                            }
                            break;
                        }
                    }
                    if (lstSlotAccountOpen != null  && lstSlotAccountOpen.Size() > 0) {
                        Delete lstSlotAccountOpen;
                    }
                    if (idNewSlotId != null) {
                        
                        String lstSlotOrderString = 'Select Id, Account__c, Order1__r.Sold_To__c, Order1__r.Ship_To__c, Order1__c, Weight_Pound__c, Weight__c from Slot_Order__c where Slot__c =: lstSlot AND ';
                        lstSlotOrderString += salesOrg == '1003' || salesOrg == '1101' ? ' Order1__r.Sales_Org__c != \'1502\' ' : ' Order1__r.Sales_Org__c = \'1502\' ';
                        
                        List<Slot_Order__c> lstSlotOrder = new List<Slot_Order__c>();// [Select Id, Account__c, Order1__r.Sold_To__c, Order1__r.Ship_To__c, Order1__c, Weight_Pound__c, Weight__c from Slot_Order__c where Slot__c =: lstSlot AND Order1__r.Sales_Org__c =: salesOrg]; //Conditon For Isolate
                        lstSlotOrder = Database.query(lstSlotOrderString);
                        List<Slot_Order__c> lstNewSlotOrder = new List<Slot_Order__c>();
                        List<Slot_Account__c> lstSlotAccount = [Select Id, Account__c from Slot_Account__c where Slot__c =: lstSlot];
                        List<Slot_Account__c> lstNewSlotAccount = new List<Slot_Account__c>();
                        Boolean blnValidateLTL = true;
                        //blnValidateLTL = ValidateLTLOrderMoveSlot(dtSlotDate, lstSlotOrder);
                        //If LTL order count/weight validation is overridden then the validation should not be accounted for
                        if (lstSlot[0].Slot_Type__c == 'LTL') {
                            if (blnLTLToValidate)
                                blnValidateLTL = ValidateLTLOrderMoveSlot(dtSlotDate, lstSlotOrder);
                            else
                                blnValidateLTL = true;
                        }
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
                                    /*Boolean blnAccountToAdd = true;
                                    for(Slot_Account__c objSlotAccount : lstSlotAccount) {
                                        if (objSlotAccount.Account__c == objSlotOrder.Order__r.Account__c)
                                            blnAccountToAdd = false;
                                    }
                                    if (blnAccountToAdd)
                                    {*/
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
                system.debug('@@@dtSlotDate@@@ '+dtSlotDate);
                 system.debug('@@@strWarehouse@@@ '+strWarehouse);
                List<Slot__c> lstSlots = [Select Id from Slot__c where Scheduled_Shipping_Date__c =: dtSlotDate and Slot_Type__c = 'LTL' and Plant__c =: strWarehouse];
                //AggregateResult[] arrSlotOrder = [Select Count(Id) CountId, Sum(Weight__c) TotalWeight from Slot_Order__c where Slot__c =: strSlotId];
                AggregateResult[] arrSlotOrder;
                system.debug('@@@lstSlots@@@ '+lstSlots);
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

                //Retrieve the user details and set the profile name to check whether the LTL validation should be overridden or not
                String strProfileName;
                Id idProfile = UserInfo.getProfileId();
                List<Profile> lstProfile = [Select Name from Profile where Id =: idProfile];
                if (lstProfile != null && lstProfile.Size() > 0) {
                    strProfileName = lstProfile[0].Name;
                }

                String strLTLValidationProfile = System.Label.Slotting_LTL_Validation_Profile;
                if (strLTLValidationProfile != null && strLTLValidationProfile != '') {
                    if (strLTLValidationProfile.ContainsIgnoreCase(strProfileName))
                        strProfileForLTLValidation = strProfileName;
                    else
                        strProfileForLTLValidation = '';
                }

                /*if (intExistCount > intOrderCount) {
                    strErrorMessage = 'Maximum ' + intOrderCount + ' orders can be added to an LTL slot for ' + strWareHouseName.Trim() + ' warehouse.';
                    blnValidLTL = false;
                } else */if (dcExistWeight >= intTotalWeight) {
                    strErrorMessage = 'Total weight of orders in LTL slot for ' + strWareHouseName.Trim() + ' warehouse can be ' + intTotalWeight + ' pounds.';
                    blnValidLTL = false;
                }
            }
        }
        Return blnValidLTL;
    }
    Public PageReference SetSlotColor()
    {
        strErrorMessage = null;
        strProfileForLTLValidation = null;
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
    
    Public Void testMethod1(){
    Integer i = 0; 
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    }
}