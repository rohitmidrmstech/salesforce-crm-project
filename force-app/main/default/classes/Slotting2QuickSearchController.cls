/*
Version History
1.Change Request - CHG0335300 Modified by Gopi Ravoori on 04/27/2016
*/


global Class Slotting2QuickSearchController{

    @RemoteAction
    global Static List<Order> SearchOrders(String strSearchText, String strWareHouseId, String strOrderStartDate, String strOrderEndDate, String sOrg)
    {
        
        String salesOrg = String.isNotBlank(sOrg) ? sOrg : Slotting2Controller.fetchSalesOrg();
        System.debug('++++Slotting2QuickSearchController.Selected salesOrg '+ salesOrg);
        System.Debug('++++Slotting2QuickSearchController.Entering into the function   SearchOrders   ' + strWareHouseId);
        system.debug('+++++ strOrderStartDate: ' + strOrderStartDate);
        system.debug('+++++ strOrderEndDate: ' + strOrderEndDate);
        String strEcophonMeridianId = System.Label.EcophonMeridianId;
        String strMeidianID= System.label.MeridianId;
        
        Set<String> wareHouseIdsSet = new Set<String>();
        wareHouseIdsSet.add(strWareHouseId.substring(0,15));
         System.Debug('wareHouseIdsSet' + strWareHouseId.substring(0,15));
       
            if (strWareHouseId == 'a283F00000075ExQAI') // a0h610000020Ae7AAE changed by kondal 
        {
            wareHouseIdsSet.add('a283F00000075Ex'); //a0h610000020AeR Changed by kondal
        }
        Date dtScheduledShippingDate = System.Today().AddDays(-14);
        Date dtOrderStartDate;
        Date dtOrderEndDate;
        List<String> lstStatus = new List<String>{'Shipped', 'Closed', 'ORDER CREATED', 'CREDIT HOLD', 'INCOMPLETE', 'DELIVERY BLOCK', 'DELIVERY CREATED', 'PICKING COMPLETED', 'INVOICED', 'STO COMPLETE', 'SHIPMENT CREATED'};
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
        String strQuery = 'Select OrderNumber, BPCS_Order__c, Means__c, Ship_Date__c, Ship_Condition__c, order_num__c, Pallet_Count__c, Gross_Weight__c, Created_By_Name__c, Name, ' +
                        'Account.Name, Ship_To__r.Name, Sold_To__r.Name, Account.AccountNumber, Plant__c, Warehouse__c,Manufacturing_Plant__c ,Planned_Ship_Date__c, Doc_Type__c from Order';
        if(salesOrg == '1003' || salesOrg == '1101'){
            //strQuery += ' where Manufacturing_Plant__c in :wareHouseIdsSet And Sales_Org__c != \'1502\'';
            strQuery += ' where Manufacturing_Plant__c in :wareHouseIdsSet And Sales_Org__c =: salesOrg';
            if (strSearchText.Length() > 1){
               strQuery += ' And (Account.Name Like \'' + strSearchText + '\' Or Order_Num__c Like \'' + strSearchText + '\' )';
            }
            if (dtOrderStartDate != null) {
               strQuery += ' And Ship_Date__c >= :dtOrderStartDate';
            }
            if (dtOrderEndDate != null) {
               strQuery += ' And Ship_Date__c <= :dtOrderEndDate';
            }
            strQuery += ' And (NOT Account.Name like \'MENARD%\')';   //INC0921160
            strQuery += ' And status in (\'ORDER CREATED\',\'DELIVERY CREATED\',\'CREDIT HOLD\',\'INCOMPLETE\', \'SHIPMENT CREATED\') And Id Not In (Select Order1__c From Slot_Order__c Where Slot__r.plant__c in  :wareHouseIdsSet)';
            strQuery += ' and Doc_Type__c in (\'ZEX\',\'ZFC\',\'ZFS\',\'ZFW\',\'ZOR\',\'NBC3\',\'NBC4\',\'NBC5\')';
            
            strQuery += ' order By Ship_Date__c desc LIMIT 1000';
            System.Debug('@@@@@     strQuery     ' + strQuery);
        }else if(salesOrg == '1502'){
            // If the plant is "Social circle" then show the orders for both "Social circle" and "SP Kaytec Social Circle" -- KUSP-22
            if(strWareHouseId == 'a283w000009FP9RAAW' || Test.IsRunningTest()){     //a283w000009FP9RAAW - Social circle plant id 
              List<Plants__c> plantList = [select Id,SAP_Plant_Name__c from Plants__c where SAP_Plant_Name__c = 'SP KAYTEC SOCIAL CIRCLE, GA'];
              Id kaytecSocialCircleId;
              if(plantList.size() > 0){
                kaytecSocialCircleId = plantList[0].Id;
                strQuery += ' where ( Manufacturing_Plant__c =: strWareHouseId OR Manufacturing_Plant__c =: kaytecSocialCircleId) AND (Sales_Org__c =: salesOrg OR Sales_Org__c = \'1018\')'; //a28VZ0000000zBZYAY -- Kaytec Social circle plant id
              }else{
                strQuery += ' where Manufacturing_Plant__c =: strWareHouseId AND (Sales_Org__c =: salesOrg OR Sales_Org__c = \'1018\')'; //a28VZ0000000zBZYAY -- Kaytec Social circle plant id
              }
            }
            else{
                //strQuery += ' where Manufacturing_Plant__c =: strWareHouseId AND Sales_Org__c =: salesOrg';
            	strQuery += ' where Manufacturing_Plant__c =: strWareHouseId AND (Sales_Org__c =: salesOrg OR Sales_Org__c = \'1020\' OR Sales_Org__c = \'1019\' OR Sales_Org__c = \'1018\')'; // usp-21
            }
            if (strSearchText.Length() > 1)
            {
                 strQuery += ' And (Account.Name Like \'' + strSearchText + '\' Or Order_Num__c Like \'' + strSearchText + '\' )';
            }
            if (dtOrderStartDate != null) {
                strQuery += ' And Planned_Ship_Date__c >= :dtOrderStartDate';
            }
            if (dtOrderEndDate != null) {
                strQuery += ' And Planned_Ship_Date__c <= :dtOrderEndDate';
            }
            strQuery += ' And (NOT Account.Name like \'MENARD%\')';   //INC0921160
            strQuery += ' And Status In :lstStatus And Id Not In (Select Order1__c From Slot_Order__c Where Slot__r.Plant__c =: strWareHouseId)';
            //strQuery += ' And Status__c = \'Open\' And Id Not In (Select Order__c From Slot_Order__c Where Slot__r.Warehouse__c =: strWareHouseId)';
            //strQuery += ' And Means__c != \'NOX\' And Means__c != \'SPS\' and Order_Type__c != \'7\'';
            //CR-CHG0335300
            //Todo
            // strQuery += ' And Means__c != \'NOX\' And Means__c != \'SPS\' and Means__c!=\'ZCZ8\' and Means__c != \'ZBZ8\' and Doc_Type__c not in ';
            //Todo
            // strQuery +='  ( \'ZCR\',\'ZCR1\',\'ZCR2\',\'ZDR\',\'ZIN\',\'ZRK\',\'ZRL\',\'7\')';
            strQuery += ' And Means__c != \'NOX\' And Means__c != \'SPS\' and Means__c!=\'ZCZ8\' and Means__c!=\'ZBZ8\' and Doc_Type__c not in ';
            strQuery +='  ( \'ZCR\',\'ZCR1\',\'ZCR2\',\'ZDR\',\'ZIN\',\'ZRK\',\'ZRL\',\'7\')';
            strQuery += ' order By Planned_Ship_Date__c desc LIMIT 1000';
            
        }
            System.Debug('+++++     strQuery     ' + strQuery);
        if(String.isBlank(salesOrg)){
            strQuery += ' order By Ship_Date__c desc LIMIT 1000';
        }
        List<Order> lstOrders = Database.Query(strQuery);
         System.Debug('+++++     strQuery     ' + strQuery);
         System.debug('+++++Orders list lstOrders'+lstOrders);
        System.debug('+++++Orders list lstOrders size'+lstOrders.size());
        System.debug('+++++dtOrderStartDate= '+ dtOrderStartDate + ' ,dtOrderEndDate= '+ dtOrderEndDate + ' ,salesOrg= '+ salesOrg);
        System.debug('+++++wareHouseIdsSet= '+ wareHouseIdsSet);
        return lstOrders; 
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
        if(strWareHouseId == 'a283w000009FP9RAAW'  || Test.IsRunningTest())
        {
            List<Plants__c> plantList = [select Id,SAP_Plant_Name__c from Plants__c where SAP_Plant_Name__c = 'SP KAYTEC SOCIAL CIRCLE, GA'];
            Id kaytecSocialCircleId;
            if(plantList.size() > 0){
                kaytecSocialCircleId = plantList[0].Id;
                whereCondition  = 'where (Default_Plant__c =: strWareHouseId OR Default_Plant__c =: kaytecSocialCircleId) ';
            }
            else{
                 whereCondition  = 'where Default_Plant__c =: strWareHouseId ';
            }
            //whereCondition  = 'where (Default_Plant__c =: strWareHouseId OR Default_Plant__c = \'a28VZ0000000zBZYAY\') ';
		}
        else
        {
              whereCondition  = 'where Default_Plant__c =: strWareHouseId ';
        }
        //whereCondition  = 'where Default_Plant__c =: strWareHouseId ';
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
        System.debug('**Account '+ strQuery);
        Return lstAccount ;
    }
    /* Constructor */
    Public Slotting2QuickSearchController(Slotting2Controller controller)
    {
    }
    Public Slotting2QuickSearchController()
    {
    }
}