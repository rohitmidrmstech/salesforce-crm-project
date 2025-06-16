// CHG0360422 - Steve Arnold - 7/1/2016 - Fix Accounts Picklist when creating a Fixed Slot

Public With Sharing Class FixedSlots
{
    String strRecordTypeId {get; set;}
    Public Recordtype rtRecordType {get; set;}
    Public String strAccount {get; set;}
    Public String strFixedAccount {get; set;}
    Public String strSelectAccount {get; set;}
    Public String strWarehouse {get; set;}
    Public String strWarehouseName {get; set;}
    Public Map<String,String> mapWarehouseIdName;
    Public Order objOrder {get; set;}
    String[] arrDayOfWeek = new String[]{};
    //Search Variables
    Public String strLeftSearch {get; set;}
    Public String strRightSearch {get; set;}
    Public Integer intNoOfSlots {get; set;}
    Public Warehouse_Slot__c objWarehouseSlotValues {get; set;}
    //List<selectOption> lstDayOfWeek{get;set;}
    Boolean blnEliminateWeekend;
    Public List<Warehouse_Slot__c> lstWarehouseSlot {get; set;}
    Warehouse_Slot__c objSelectedWarehouseSlot;
    Public String strWarehouseNameForLookup {get; set;}
    Public String strSlotType {get; set;}

    Public FixedSlots(ApexPages.StandardController controller) {
        //Manage override new button function for create new warehouseslot
        strRecordTypeId = ApexPages.currentPage().getParameters().get('RecordType');
        if (strRecordTypeId != '') {
            List<Recordtype> lstRecordType = [Select Id, Name, DeveloperName from Recordtype where Id =: strRecordTypeId];
            if (lstRecordType.Size() > 0) {
                rtRecordType = lstRecordType[0];
            }
        }

        if (ApexPages.currentPage().getParameters().get(System.Label.Warehouse_Field_Id + '_lkid') != null && 
                ApexPages.currentPage().getParameters().get('CF01I61000001OXIZ_lkid') != '') {
            String strWarehouseId = ApexPages.currentPage().getParameters().get(System.Label.Warehouse_Field_Id + '_lkid');
            List<Plants__c> lstWarehouseForLookup = New List<Plants__c>([Select Id, Name from Plants__c where Id =: strWarehouseId]);
            if (lstWarehouseForLookup.Size() > 0) {
                strWarehouseNameForLookup = lstWarehouseForLookup[0].Name;
            }
        }

        objSelectedWarehouseSlot = (Warehouse_Slot__c)controller.getRecord();
        strWarehouse = objSelectedWarehouseSlot.Plant__c;

        List<Plants__c> lstWarehouse = New List<Plants__c>([Select Id, Name, Eliminate_Weekend__c from Plants__c
                                                        where Id =: strWarehouse limit 1]);

        if (lstWarehouse.Size() > 0) {
            strWarehouseName = lstWarehouse[0].Name;
            blnEliminateWeekend = lstWarehouse[0].Eliminate_Weekend__c;
        }

        strLeftSearch = '';
        strRightSearch = '';
        objOrder = new Order();
        intNoOfSlots = 1;
        objWarehouseSlotValues = new Warehouse_Slot__c();
    }

    //---------------------------------------------------------------------------------------------------
    //getDayOfWeek Function
    //- Called on page load to bind the Select Day picklist
    //- Retrieves the list of all accounts to be displayed in the Select Day picklist
    // --------------------------------------------------------------------------------------------------
    Public List<selectOption> getDayOfWeek() {
        List<selectOption> lstDayOfWeek = new List<selectOption>();

        if (blnEliminateWeekend == false) 
            lstDayOfWeek.Add(new SelectOption('Sunday', 'Sunday'));
        lstDayOfWeek.Add(new SelectOption('Monday', 'Monday'));
        lstDayOfWeek.Add(new SelectOption('Tuesday', 'Tuesday'));
        lstDayOfWeek.Add(new SelectOption('Wednesday', 'Wednesday'));
        lstDayOfWeek.Add(new SelectOption('Thursday', 'Thursday'));
        lstDayOfWeek.Add(new SelectOption('Friday', 'Friday'));
        if (blnEliminateWeekend == false) 
            lstDayOfWeek.Add(new SelectOption('Saturday', 'Saturday'));

        lstDayOfWeek.Add(new SelectOption('All', 'All Days'));
        return lstDayOfWeek;
    }

    Public String[] getarrDayOfWeek() {
        return arrDayOfWeek;
    }

    Public Void setarrDayOfWeek(String[] arrDayOfWeek) {
        this.arrDayOfWeek = arrDayOfWeek;
    }

    //---------------------------------------------------------------------------------------------------
    //getAccountList Function
    //- Called on page load to bind the account picklist
    //- Retrieves the list of all accounts to be displayed in the accounts picklist
    // --------------------------------------------------------------------------------------------------
    Public List<SelectOption> getAccountList() {
        List<SelectOption> lstAccountOptions = new List<SelectOption>();
        List<Account> lstAccount = new List<Account>();

        if (strLeftSearch != '')
        {
            /*lstAccount = [Select Id, Name, Account_Number__c from Account 
                            where Status__c = 'Active' and Fixed_Account__c = false and (Name Like : strLeftSearch or Name Like : '%' + strLeftSearch + '%')
                            order by Name asc limit 1000];*/
            lstAccount = [Select Id, Name, JDE_Customer_Number__c from Account 
                            where Status__c= 'Active' and Fixed_Account__c = false and Default_Plant__c =: strWarehouse and
                            (Name Like : strLeftSearch or Name Like : '%' + strLeftSearch + '%' or 
                            JDE_Customer_Number__c Like : strLeftSearch or JDE_Customer_Number__c Like : '%' + strLeftSearch + '%')
                            and (RecordType.Name = 'Sales'        // CHG0360422 - Changed from RecordType.Name like :'%BPCS%Siding%' 
                            or  RecordType.Name = 'Customer')
                            //and (NOT Account_Number__c like '%-%')  // CHG0360422 - Line added
                            order by Name asc limit 1000];
        }
        else
        {
            /*lstAccount = [Select Id, Name, Account_Number__c from Account where Status__c = 'Active' and Fixed_Account__c = false 
                    order by Name asc limit 1000];*/
            lstAccount = [Select Id, Name, JDE_Customer_Number__c from Account 
                            where Status__c= 'Active' and Fixed_Account__c = false and Default_Plant__c =: strWarehouse 
                            and (RecordType.Name = 'Sales'        // CHG0360422 - Changed from RecordType.Name like :'%BPCS%Siding%' 
                            or  RecordType.Name = 'Customer')
                            //and (NOT Account_Number__c like '%-%')  // CHG0360422 - Line added
                            order by Name asc limit 1000];
        }
        

        for (Account objAccount : lstAccount)
        {
            if (objAccount.JDE_Customer_Number__c != null && objAccount.JDE_Customer_Number__c != '')
                lstAccountOptions.Add(new SelectOption(objAccount.Id, objAccount.JDE_Customer_Number__c + ' - ' + objAccount.Name));
            else
                lstAccountOptions.Add(new SelectOption(objAccount.Id, objAccount.Name));
        }
        return lstAccountOptions;
    }

    //---------------------------------------------------------------------------------------------------
    //getFixedAccountList Function
    //- Called on page load to bind the fixed account picklist
    //- Retrieves the list of all fixed accounts to be displayed in the fixed accounts picklist
    // --------------------------------------------------------------------------------------------------
    Public List<SelectOption> getFixedAccountList()
    {
        List<SelectOption> lstFixedAccountOptions = new List<SelectOption>();
        List<Account> lstFixedAccount = new List<Account>();
        
        if (strRightSearch != '')
        {
            /*lstFixedAccount = [Select Id, Name from Account 
                            where Status__c = 'Active' and Fixed_Account__c = true and (Name Like : strRightSearch or Name Like : '%' + strRightSearch + '%')
                            order by Name asc limit 1000];*/
            lstFixedAccount = [Select Id, Name, JDE_Customer_Number__c from Account 
                                where Status__c= 'Active' and Fixed_Account__c = true and Default_Plant__c =: strWarehouse and 
                                (Name Like : strRightSearch or Name Like : '%' + strRightSearch + '%' or 
                                JDE_Customer_Number__c Like : strRightSearch or JDE_Customer_Number__c Like : '%' + strRightSearch + '%')
                               and (RecordType.Name = 'Sales'        // CHG0360422 - Changed from RecordType.Name like :'%BPCS%Siding%' 
                                 or  RecordType.Name = 'Customer')                          
                                //and (NOT Account_Number__c like '%-%')  // CHG0360422 - Line added
                                order by Name asc limit 1000];
        }
        else
        {
            /*lstFixedAccount = [Select Id, Name from Account where Status__c = 'Active' and Fixed_Account__c = true 
                    order by Name asc limit 1000];*/
            lstFixedAccount = [Select Id, Name, JDE_Customer_Number__c from Account 
                                where Status__c= 'Active'  and Fixed_Account__c = true and Default_Plant__c =: strWarehouse 
                                and (RecordType.Name = 'Sales'        // CHG0360422 - Changed from RecordType.Name like :'%BPCS%Siding%' 
                                or  RecordType.Name = 'Customer')
                                //and (NOT Account_Number__c like '%-%')  // CHG0360422 - Line added
                                order by Name asc limit 1000];
        }
        for (Account objFixedAccount : lstFixedAccount)
        {
            if (objFixedAccount.JDE_Customer_Number__c != null && objFixedAccount.JDE_Customer_Number__c != '')
                lstFixedAccountOptions.Add(new SelectOption(objFixedAccount.Id, objFixedAccount.JDE_Customer_Number__c + ' - ' + objFixedAccount.Name));
            else
                lstFixedAccountOptions.Add(new SelectOption(objFixedAccount.Id, objFixedAccount.Name));
        }
        return lstFixedAccountOptions;
    }

    Public PageReference FillWarehouseAccount()
    {
        getSelectAccountList();
        if (String.IsBlank(strWarehouse) == false) {
            String strFixedWHAccount = System.Label.Fixed_Warehouse_Slot;
            List<RecordType> lstRTFixedWHAccount = New List<RecordType>([SELECT ID FROM RecordType
                                                    WHERE SobjectType = 'Warehouse_Slot__c' AND DeveloperName =: strFixedWHAccount LIMIT 1]);
            if (lstRTFixedWHAccount != null && lstRTFixedWHAccount.Size() > 0)
                lstWarehouseSlot = [Select Id, Name, Account__c, Delivers_DOW__c, No_Of_Slots__c  from Warehouse_Slot__c where Plant__c=: strWarehouse and RecordTypeId =: lstRTFixedWHAccount[0].Id];
        }
        return null;
    }

    //---------------------------------------------------------------------------------------------------
    //getSelectAccountList Function
    //- Called on page load to bind the select account picklist
    //- Retrieves the list of all fixed accounts to be displayed in the select accounts picklist
    // --------------------------------------------------------------------------------------------------
    Public List<SelectOption> getSelectAccountList()
    {
        List<SelectOption> lstFixedAccountOptions = new List<SelectOption>();
        lstFixedAccountOptions.Add(new SelectOption('', 'Select Accounts'));
        if (String.IsBlank(strWarehouse) == false) {
            List<Account> lstFixedAccount = new List<Account>();
            lstFixedAccount = [Select Id, Name from Account where Status__c= 'Active' and Fixed_Account__c = true 
                                and (RecordType.Name = 'Sales'          // CHG0360422 - Changed from RecordType.Name like :'%BPCS%Siding%' 
                                or  RecordType.Name = 'Customer') 
                                                                                    //and (NOT Account_Number__c like '%-%')    // CHG0360422 - Line added
                                and Default_Plant__c =: strWarehouse order by Name asc];   
System.debug('lstFixedAccount'+lstFixedAccount.size()); 
  System.debug('lstFixedAccount'+lstFixedAccount);           
            for (Account objFixedAccount : lstFixedAccount) {
                lstFixedAccountOptions.Add(new SelectOption(objFixedAccount.Id, objFixedAccount.Name));
            }
        } else {
            strSelectAccount = '';
        }
        System.debug('lstFixedAccountOptions'+lstFixedAccountOptions);
        System.debug('lstFixedAccountOptions'+lstFixedAccountOptions.size());
        return lstFixedAccountOptions;
    }

    //---------------------------------------------------------------------------------------------------
    //goLeftSearch Function
    //- Called on Go Button click for Left Account Search
    //- Retrieves the list of all accounts to be displayed in the accounts picklist
    // --------------------------------------------------------------------------------------------------
    Public PageReference goLeftSearch()
    {
        getSelectAccountList();
        return null;
    }
    
    //---------------------------------------------------------------------------------------------------
    //goRightSearch Function
    //- Called on Go Button click for Right Account Search
    //- Retrieves the list of all accounts to be displayed in the selected accounts picklist
    // --------------------------------------------------------------------------------------------------
    Public PageReference goRightSearch()
    {
        getFixedAccountList();
        return null;
    }

    //---------------------------------------------------------------------------------------------------
    //Add Function
    //- Called on click of ">" button
    //- Move the list of Account to fixed accounts list.
    // --------------------------------------------------------------------------------------------------
    Public PageReference AddFixedAccount()
    {
        List<String> lstAccountId = new List<String>();
        Set<String> setAccountId = new Set<String>();
        
        if (strAccount != '' && strAccount != null)
        {
            strAccount = strAccount.replace('[','');
            strAccount = strAccount.replace(']','');
            lstAccountId = strAccount.split(',');
        }
        for (String strAccountId : lstAccountId)
        {
            strAccountId = strAccountId.Trim();
            setAccountId.Add(strAccountId);
        }

        List<Account> lstSelAccount = new List<Account>();
        lstSelAccount = [Select Id, Name, Fixed_Account__c from Account where Id in : setAccountId];

        for (Account objAccount : lstSelAccount) {
            objAccount.Fixed_Account__c = true;
        }
        Update lstSelAccount;

        return null;
    }

    //---------------------------------------------------------------------------------------------------
    //Remove Function
    //- Called on click of "<" button
    //- Move the list of Fixed account to Accounts list.
    // --------------------------------------------------------------------------------------------------
    Public PageReference RemoveFixedAccount()
    {
        List<String> lstAccountId = new List<String>();
        Set<String> setAccountId = new Set<String>();

        if (strFixedAccount != '' && strFixedAccount != null) {
            strFixedAccount = strFixedAccount.replace('[','');
            strFixedAccount = strFixedAccount.replace(']','');
            lstAccountId = strFixedAccount.split(',');
        }
        for(String strAccountId : lstAccountId) {
            strAccountId = strAccountId.Trim();
            setAccountId.Add(strAccountId);
        }

        List<Account> lstSelAccount = new List<Account>();
        lstSelAccount = [Select Id, Name, Fixed_Account__c from Account where Id in : setAccountId];

        for (Account objAccount : lstSelAccount) {
            objAccount.Fixed_Account__c = false;
        }
        Update lstSelAccount;
        return null;
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
        return lstWarehouseOptions;
    }

    Public PageReference CreateSlots()
    {
        if (strWarehouse == '' || String.IsBlank(strWarehouse)) {
            ApexPages.Message msgWarehouse = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select warehouse.');
            ApexPages.AddMessage(msgWarehouse);
            return null;
        }
        if (strSelectAccount == '' || String.IsBlank(strSelectAccount)) {
            ApexPages.Message msgAccount = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select account.');
            ApexPages.AddMessage(msgAccount);
            return null;
        }
        if (arrDayOfWeek == null || arrDayOfWeek.size() == 0) {
            ApexPages.Message msgDay = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select day.');
            ApexPages.AddMessage(msgDay);
            return null;
        }

        if (!String.IsBlank(strWarehouse) && !String.IsBlank(strSelectAccount)
                && arrDayOfWeek != null && arrDayOfWeek.Size() > 0) {
            if (intNoOfSlots == null || intNoOfSlots <= 0) {
                ApexPages.Message msgNoOfSlots = new ApexPages.Message(ApexPages.Severity.ERROR, 'Number of slots must be greater than 0.');
                ApexPages.AddMessage(msgNoOfSlots);
                return null;
            } else {
                String strFixedWHAccount = System.Label.Fixed_Warehouse_Slot;
                List<RecordType> lstRTFixedWHAccount = New List<RecordType>([Select Id from RecordType
                                                        where SobjectType = 'Warehouse_Slot__c' and DeveloperName =: strFixedWHAccount limit 1]);
                List<Warehouse_Slot__c> lstWarehouseSlot = New List<Warehouse_Slot__c>();
                for (String strDay : arrDayOfWeek) {
                    if (strDay != 'All') {
                        Warehouse_Slot__c objWarehouseSlot = New Warehouse_Slot__c();

                        objWarehouseSlot.Plant__c= strWarehouse;
                        objWarehouseSlot.Account__c = strSelectAccount;
                        objWarehouseSlot.Slot_DOW__c = strDay;
                        objWarehouseSlot.Delivers_DOW__c = strDay;
                        objWarehouseSlot.Slot_Type__c = 'TL';
                        if (!String.IsBlank(strSlotType)) {
                            objWarehouseSlot.Slot_Type__c = strSlotType;
                        } else {
                            objWarehouseSlot.Slot_Type__c = 'Van';
                        }
                        objWarehouseSlot.Status__c = 'Active';
                        objWarehouseSlot.No_Of_Slots__c = intNoOfSlots;
                        objWarehouseSlot.Start_Date__c = objWarehouseSlotValues.Start_Date__c;
                        objWarehouseSlot.Comment__c = objWarehouseSlotValues.Comment__c;

                        if (lstRTFixedWHAccount.Size() > 0) {
                            objWarehouseSlot.RecordTypeId = lstRTFixedWHAccount[0].Id;
                        }

                        lstWarehouseSlot.Add(objWarehouseSlot);
                    }
                }

                if (lstWarehouseSlot.Size() > 0) {
                    Insert lstWarehouseSlot;
                    system.debug('@@@'+lstWarehouseSlot);
                    List<Slot__c> lstSlots = New List<Slot__c> ([Select Id from Slot__c
                                                                where Warehouse_Slot__c in : lstWarehouseSlot]);
                    List<Slot_Account__c> lstSlotAccounts = new List<Slot_Account__c>();
                    for (Slot__c objSlot : lstSlots) {
                        lstSlotAccounts.Add(new Slot_Account__c (Slot__c = objSlot.Id, Account__c = strSelectAccount));
                    }
                    if (lstSlotAccounts.Size() > 0) {
                        Insert lstSlotAccounts;
                    }
                }
            }
        }
        PageReference objPage = New PageReference('/' + strWarehouse);
        objPage.SetRedirect(True);
        Return objPage;
    }

    Public Static String DateToString(Date ParDate)
    {
        String strFinal = null;
        if (ParDate != null)
        {
            String YY = String.ValueOf(ParDate.Year());
            String MM = ('0' + ParDate.Month()).Right(2);
            String DD = ('0' + ParDate.Day()).Right(2);
            strFinal = YY + '-' + MM + '-' +DD;
        }
        return strFinal;
    }

    Public PageReference redirectToWarehouse() {
        if (strWarehouse != '') { 
            PageReference objPage = New PageReference('/'+strWarehouse);
            objPage.SetRedirect(True);
            Return objPage;
        } else {
            Return null;
        }
    }
}