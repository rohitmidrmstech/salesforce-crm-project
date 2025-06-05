Global Class doSlottingQuickSearchController
{
    @RemoteAction
    Global Static List<Order> SearchOrders(String strSearchText, String strWareHouseId)
    {
        if (strSearchText.Length() > 1)
        {
            strSearchText = strSearchText.endsWith('%') ? strSearchText : strSearchText + '%';
        }
        //SOQL operation to retrieve records of the Orders Object.
        String strQuery = 'Select Order_Num__c, BPCS_Order__c, Pallet_Count__c, Gross_Weight__c, Means__c, Name, ' +
                        'Account.Name, Account.AccountNumber, Warehouse__c, Planned_Ship_Date__c from Order where Warehouse__c =: strWareHouseId ' ;
        if (strSearchText.Length() > 1)
        {
            strQuery += ' And (Account.Name Like \'' + strSearchText + '\' Or Order_Num__c Like \'' + strSearchText + '\' )';
        }
        strQuery += ' And Status = \'Open\' And Id Not In (Select Order1__c From Slot_Order__c Where Slot__r.Plant__c =: strWareHouseId) ';
        strQuery += ' Order By Planned_Ship_Date__c desc LIMIT 1000';
        List<Order> lstOrders = Database.Query(strQuery);
        Return lstOrders;
    }
    
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
    Public doSlottingQuickSearchController(doSlottingController controller)
    {
    }
    Public doSlottingQuickSearchController()
    {
    }
}