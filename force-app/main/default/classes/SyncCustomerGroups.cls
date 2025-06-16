/**
 * SyncCustomerGroups
 * @author Daniel Llewellyn dllewellyn@liquidhub.com
 * @date 12/28/15
 * @description This batch class looks at accounts that have been updated today and then updated the Customer Group
 * and the Customer Group Customer object accordingly.
 *
 * Fields that matter for this batch class are :
 *     Buying group name / Buying Group Code
 *     Customer District / Customer District Code (aka Pricing Group)
 *
 * Revision History
 *  08/25/15    Liquidhub       Modified the code to limit Pricing Groups to only Sold To's
 *                              added code to bring in Associated Payer data to the Customer group record
 */
global class SyncCustomerGroups implements Database.Batchable < sObject >, Schedulable, Database.Stateful {
    public DateTime fromDate;
    public string query;

    //if the class is constructed with no query param then just set a default query. The invoker can override it by setting the query param after class construction.
    public SyncCustomerGroups() {
        // lets always overlap a day
        fromDate = DateTime.newInstance(Date.today().addDays(-1), Time.newInstance(0,0,0,0));

        if (query == null) {
            query = 'select PRICE_GROUP__c,  '+
                'SAP_ACCOUNT__c, Type, RecordTypeId, RecordType.Name, ParentId, Id '+
                'from Account '+
                'where LastModifiedDate >= :fromDate ';//+
                //'(Customer_District__c != null or PRICE_GROUP__c !=null or '+        // Need To Set Customer_District__c to PRICE_GROUP__c
                //' ( Buying_Group_Name__c !=null or Buying_Group_Code__c != null)';
        }
    }


    // Schedulable interface ------------------------------------------------------------------------
    global void execute(SchedulableContext ctx)
    {
        SyncCustomerGroups thisBatch = new SyncCustomerGroups();
        Database.executeBatch(thisBatch, 200);
    }
        
    // batchable interface --------------------------------------------------------------------------
    // Start Method
    global Database.QueryLocator start(Database.BatchableContext BC) {
        return Database.getQueryLocator(query);
    }

    // Execute Logic
    global void execute(Database.BatchableContext BC, List < Account > scope) {
        //Create customer group records from found districts  
        map < string, list < account >> pricingGroupToAccountsMap = new map < string, list < account >> ();

        // turn off this integration as Buying Groups should now exist as Accounts of the Buying Group record type
        // map < string, list < account >> buyingGroupToAccountsMap = new map < string, list < account >> ();
        list < Price_Group__c > customerGroups = new list < Price_Group__c > ();
        //list < Customer_Group_Customer__c > customerGroupMembers = new list < Customer_Group_Customer__c > ();

        //create the map of codes and the related accounts from the list of accounts.
        for (Account thisAccount: scope) {
            // pricing groups are only for sold tos
            if( (String.isNotEmpty(thisAccount.PRICE_GROUP__c) || String.isNotEmpty(thisAccount.PRICE_GROUP__c)) &&
                (String.isNotEmpty(thisAccount.SAP_ACCOUNT__c) && thisAccount.SAP_ACCOUNT__c.startsWith('100') && 
                    thisAccount.Type == 'Sold-To' && thisAccount.RecordType.Name == 'Sold-To' ) ){
                String key = thisAccount.PRICE_GROUP__c;
                if (String.isEmpty(key)) key = thisAccount.PRICE_GROUP__c;

                //add this account to the proper buying group map entry
                list < account > pricingAccounts = pricingGroupToAccountsMap.containsKey(key) ? 
                    pricingGroupToAccountsMap.get(key) : new list < account > ();
                pricingAccounts.add(thisAccount);
                pricingGroupToAccountsMap.put(key, pricingAccounts);
            }
            
            // buying groups are only for payers

            // turn off this integration as Buying Groups should now exist as Accounts of the Buying Group record type
            //if(String.isNotEmpty(thisAccount.Buying_Group_Name__c) || String.isNotEmpty(thisAccount.Buying_Group_Code__c) &&
            //    (String.isNotEmpty(thisAccount.Account_Number__c) && thisAccount.Account_Number__c.startsWith('300') && 
            //        thisAccount.Type == 'Payer' && thisAccount.RecordType.Name == 'Payer' ) ){

            //    String key = thisAccount.Buying_Group_Code__c;
            //    if (String.isEmpty(key)) key = thisAccount.Buying_Group_Name__c;

            //    //add this account to the proper pricing group map entry
            //    list < account > buyingAccounts = buyingGroupToAccountsMap.containsKey(key) ? 
            //        buyingGroupToAccountsMap.get(key) : new list < account > ();
            //    buyingAccounts.add(thisAccount);
            //    buyingGroupToAccountsMap.put(key, buyingAccounts);            
            //}
        }

        system.debug('\n\n\n\n------------------- MAPS CREATED!');
        system.debug(pricingGroupToAccountsMap);
        //system.debug(buyingGroupToAccountsMap);

        //iterate over each key in the pricing group map created above. For each key create a customer group object.
        for (String thisGroupKey: pricingGroupToAccountsMap.keySet()) {
            Price_Group__c newGroup = new Price_Group__c();
            newGroup.Price_Group_Code__c = thisGroupKey;
            newGroup.Type__c = 'Pricing Group';

            customerGroups.add(newGroup);

            //add the accounts for this pricing group by creating related customer group customer records
            for (Account thisAccount: pricingGroupToAccountsMap.get(thisGroupKey)) {
                // update the new group name
                if (String.isEmpty(newGroup.Name)) newGroup.Name = thisAccount.PRICE_GROUP__c;

                // setup the member records
                //Customer_Group_Customer__c thisMember = new Customer_Group_Customer__c();

                //thisMember.Customer_Group__r = new Price_Group__c(Price_Group_Code__c = thisGroupKey);
                //thisMember.Customer__c = thisAccount.Id;

                //create a unique ID that we can perform upsert against to prevent creating duplicate records.
                // NOTE this key will only allow an account to be part of 1 Price Group (which is the current understanding)
                //thisMember.UniqueId__c = thisAccount.Id + '-PG'; 
                //customerGroupMembers.add(thisMember);

                if (String.isEmpty(newGroup.Name)) newGroup.Name = thisAccount.PRICE_GROUP__c==null ? thisAccount.PRICE_GROUP__c : thisAccount.PRICE_GROUP__c;
               // if (newGroup.Associated_Payer__c==null) newGroup.Associated_Payer__c = thisAccount.ParentId;
            }
        }
        
       
        //iterate over each key in the buying group map created above. For each key create a customer group object.

        // turn off this integration as Buying Groups should now exist as Accounts of the Buying Group record type
        //
        //for (String thisGroupKey: buyingGroupToAccountsMap.keySet()) {
        //    Price_Group__c newGroup = new Price_Group__c();
        //    newGroup.Price_Group_Code__c = thisGroupKey;
        //    newGroup.Type__c = 'Buying Group';
            
        //    customerGroups.add(newGroup);

        //    //add the accounts for this buying group by creating related customer group customer records
        //    for (Account thisAccount: buyingGroupToAccountsMap.get(thisGroupKey)) {
        //        // update the new group name
        //        if (String.isEmpty(newGroup.Name)) newGroup.Name = thisAccount.Buying_Group_Name__c;

        //        // setup the member records
        //        Customer_Group_Customer__c thisMember = new Customer_Group_Customer__c();

        //        thisMember.Customer_Group__r = new Customer_Group__c(Price_Group_Code__c = thisGroupKey);
        //        thisMember.Customer__c = thisAccount.Id;

        //        //create a unique ID that we can perform upsert against to prevent creating duplicate records.
        //        thisMember.UniqueId__c = thisAccount.Id + '-BG';
        //        customerGroupMembers.add(thisMember);

        //        if (String.isEmpty(newGroup.Name)) newGroup.Name = thisAccount.Buying_Group_Name__c==null ? thisAccount.Buying_Group_Code__c : thisAccount.Buying_Group_Name__c;
        //        if (newGroup.Associated_Payer__c==null) newGroup.Associated_Payer__c = thisAccount.Id;
        //    }
        //}

        system.debug('\n\n\n\n--------------------- LISTS TO INSERT CREATED!');
        system.debug(customerGroups);
        //system.debug(customerGroupMembers);
                
        //first perform upsert of customer groups based on the Customer Group Code external Id.
        
        // dont insert groups that already exist - query the database
        list<Price_Group__c> custGroup = [select id, name, Price_Group_Code__c from Price_Group__c
            where Price_Group_Code__c in :pricingGroupToAccountsMap.keySet()];
        Set<String> existingGroupCodes = new Set<String>();
        for (Price_Group__c currGroup : custGroup){
            existingGroupCodes.add(currGroup.Price_Group_Code__c);
        }

        // dont insert groups that already exist - remove existing
        list < Price_Group__c > newCustomerGroups = new List<Price_Group__c>();
        for (Price_Group__c currGroup : customerGroups){
            if ( existingGroupCodes.contains(currGroup.Price_Group_Code__c)==false ) newCustomerGroups.add(currGroup);
        }

        upsert newCustomerGroups Price_Group_Code__c;

        //then insert the customer group member records. Use upsert based on the generated unique id which is a combination of the account name and the group its in.
        //upsert customerGroupMembers UniqueId__c;
    }

    global void finish(Database.BatchableContext BC) {
        //delete any empty groups
       // list < Price_Group__c > emptyGroups = [select id from Price_Group__c where Number_of_Members__c = 0 limit 1000];
       // delete emptyGroups;
    }
}