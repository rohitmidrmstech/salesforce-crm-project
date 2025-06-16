/*
Version History
1.Change Request - CHG0335300 Modified by Gopi Ravoori on 04/27/2016
*/
 

Global Class SlottingReadOnlyQuickSearchController
{

    @RemoteAction
    Global Static List<Order> SearchOrders(String strSearchText, String strWareHouseId, String strOrderStartDate, String strOrderEndDate)
    {
        Date dtScheduledShippingDate = System.Today().AddDays(-14);
        Date dtOrderStartDate;
        Date dtOrderEndDate;
        String[] arrDate = new String[]{};
        arrDate = strOrderStartDate.Split('/');
         if (arrDate != null && arrDate.Size() == 3) {
            dtOrderStartDate = Date.newInstance(Integer.valueOf(arrDate[2]), Integer.valueOf(arrDate[0]), Integer.valueOf(arrDate[1]));
        }
        arrDate = strOrderEndDate.Split('/');
        if (arrDate != null && arrDate.Size() == 3) {
            dtOrderEndDate = Date.newInstance(Integer.valueOf(arrDate[2]), Integer.valueOf(arrDate[0]), Integer.valueOf(arrDate[1]));
        }

        if (strSearchText.Length() > 1)
        {
            strSearchText = strSearchText.endsWith('%') ? strSearchText : strSearchText + '%';
        }
        //SOQL operation to retrieve records of the Orders Object.
        String strQuery = 'Select Order_Num__c, OrderNumber,BPCS_Order__c, Pallet_Count__c, Gross_Weight__c, Means__c, Name, ' +
                        'Account.Name, Account.AccountNumber, Warehouse__c, Planned_Ship_Date__c from Order where Warehouse__c =: strWareHouseId';
        if (strSearchText.Length() > 1)
        {
            strQuery += ' And (Account.Name Like \'' + strSearchText + '\' Or Order_Num__c Like \'' + strSearchText + '\' )';
        }
        if (dtOrderStartDate != null) {
            strQuery += ' And Planned_Ship_Date__c  >=: dtOrderStartDate';
        }
        if (dtOrderEndDate != null) {
            strQuery += ' And Planned_Ship_Date__c <=: dtOrderEndDate';
        }
        strQuery += ' And Status = \'Open\' And Id Not In (Select Order1__c From Slot_Order__c Where Slot__r.plant__c =: strWareHouseId)';
       //strQuery += ' And Means__c != \'NOX\' And Means__c != \'SPS\' and Type != \'7\'';
       //CR-CHG0335300
        strQuery += ' And Means__c != \'NOX\' And Means__c != \'SPS\' and Means__c!=\'ZCZ8\' and Means__c!=\'ZBZ8\' and Type not in ';
        strQuery +='  ( \'ZCR\',\'ZCR1\',\'ZCR2\',\'ZDR\',\'ZIN\',\'ZRK\',\'ZRL\',\'7\')';
        strQuery += ' order By Planned_Ship_Date__c desc LIMIT 1000';
        System.Debug('@@@@@     strQuery     ' + strQuery);
        List<Order> lstOrders = Database.Query(strQuery);
        System.Debug('@@@@@     strQuery     ' + strQuery);
        Return lstOrders;
    }
    /*Global Static List<Order> SearchOrders(String strSearchText, String strWareHouseId)
    {
        Date dtScheduledShippingDate = System.Today().AddDays(-14);
        if (strSearchText.Length() > 1)
        {
            strSearchText = strSearchText.endsWith('%') ? strSearchText : strSearchText + '%';
        }
        //SOQL operation to retrieve records of the Orders Object.
        String strQuery = 'Select Order_No__c, BPCS_Order_ID__c, Pallet_Count__c, Weight__c, Means__c, Name, ' +
                        'Account__r.Name, Account__r.AccountNumber, Warehouse__c, Scheduled_Ship_Date__c from Order where Warehouse1__c =: strWareHouseId ' ;
        if (strSearchText.Length() > 1)
        {
            strQuery += ' And (Account__r.Name Like \'' + strSearchText + '\' Or Order_No__c Like \'' + strSearchText + '\' )';
        }
        strQuery += ' And Status__c = \'Open\' And Id Not In (Select Order__c From Slot_Order__c Where Slot__r.Warehouse__c =: strWareHouseId) ';
        strQuery += 'And Scheduled_Ship_Date__c >=: dtScheduledShippingDate and Means__c != \'NOX\' and Means__c != \'SPS\'';
        strQuery += 'Order By Scheduled_Ship_Date__c desc LIMIT 1000';
        List<Order> lstOrders = Database.Query(strQuery);
        System.Debug('@@@@@     strQuery     ' + strQuery);
        Return lstOrders;
    }*/
    
    @RemoteAction
    Global Static List<Account> SearchAccount(String strSearchText, String strWareHouseId)
    {
        if (strSearchText.Length() > 1)
        {
            strSearchText = strSearchText.endsWith('%') ? strSearchText : strSearchText + '%';
        }
        //SOQL operation to retrieve records of the Orders Object.
        String strQuery = 'Select Id, Name from Account ' ;
        string whereCondition = '';
        whereCondition  = 'where Default_Plant__c =: strWareHouseId ';
        if (strSearchText.Length() > 1)
        {
            if(whereCondition != '')
                whereCondition += ' And (Name Like \'' + strSearchText + '\' )';
            else
                whereCondition += ' Where (Name Like \'' + strSearchText + '\' )';
            
        }
        if(whereCondition != '')
            whereCondition += ' And Fixed_Account__c = true ';
        else
            whereCondition += ' Where Fixed_Account__c = true ';
        
        if(whereCondition != '')
            strQuery += whereCondition ;
        
        strQuery += ' Order By Name desc  LIMIT 1000';
        List<Account> lstAccount = Database.Query(strQuery);
        Return lstAccount ;
    }
    /* Constructor */
    Public SlottingReadOnlyQuickSearchController(SlottingReadOnlyController controller)
    {
    }
    Public SlottingReadOnlyQuickSearchController()
    {
    }
}