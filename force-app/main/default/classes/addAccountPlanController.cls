// ==================================================================================
//   Object: addAccountPlanController
//  Company: CT-SPG
//   Author: John Westenhaver (Sales Optimizer)
// Comments: Controller for addAccountPlan page. This page is accessible from the
//           New Account Plan button on the Account Plan related list on the BPCS
//           Account page layouts, plus it overrides the Edit link on that same
//           related list.
// ==================================================================================
//  Changes: 2012-10-01 Initial version.
//           2014-08-24 Mohan Kumar (TCS)
//                      Updated logic to change the Amount__c referernce to Volume__c
//                      and aggregate query to reference Amount__c to Squares__c
//           2014-09-24 Mohan Kumar (TCS)
//                      Ignore all the Invoices whose Customer PO# starts with "TPE"
//           2015-02-03 Arpit Vashishtha (Huron)
//                      Validating the Account Plan Year will only get incremented by one after reaching October 1 of current year
// ==================================================================================

public with sharing class addAccountPlanController
{
    // ==============================================================================
    // CONSTANTS
    // ==============================================================================
    public static final String TYPE_BPCS = 'BPCS%';
    public static final String TYPE_BILLTO = 'Bill-To';
    public static final String TYPE_SHIPTO = 'Ship-To';
    public static final String TYPE_CORP = 'Corporate';
  
    // ==============================================================================
    // PUBLIC ATTRIBUTES
    // ==============================================================================
    // Controls section header attributes.
    public String pageTitle { get; set; }
    public String pageSubtitle { get; set; }
    // Current Plan being updated or new Plan to be inserted.
    public Account_Plan__c currentPlan { get; set; }
    // Public list of wrappers being manipulated.
    public list<Wrapper> marketPlans { get; set; }
    // Current parent Account for this Plan.
    public Account currentAccount { get; set; }
    // Flag controlling how fatal errors are shown. 
    public Boolean initialError { get; set; }
    // Year labels.
    public string nextYear { get; set; }  // forecast
    public String thisYear { get; set; }  // actuals
    public String lastYear { get; set; }  // actuals
    public String prevYear { get; set; }  // actuals
    // Running totals.
    public Decimal nextYearTotalAmount { get; set; }
    public Decimal thisYearTotalAmount { get; set; }
    public Decimal lastYearTotalAmount { get; set; }
    public Decimal prevYearTotalAmount { get; set; }
    // Flag controlling whether Clone button is shown;
    // also controls whether this is an insert or update.
    // Set based on arguments in querystring.
    public Boolean isInsert { get; set; }
    public String dummy { get; set; }

    // ==============================================================================
    // PUBLIC ATTRIBUTES
    // ==============================================================================
    public ApexPages.StandardController controller { get; set; }
    public ID accountId { get; set; }
    public ID planID { get; set; }
    public list<Market_Family__c> familyList { get; set; }
    public map<Id, Market_Family__c> familyMap { get; set; }
    public map<String, Wrapper> wrapperMap { get; set; }
  
    // ==============================================================================
    // CONSTRUCTORS 
    // ==============================================================================
    public addAccountPlanController(ApexPages.standardController stdCon)
    {
        try
        {
            // Set defaults.
            initialError = false;
            pageTitle = 'New Account Plan';
            pageSubtitle = 'Error';
            isInsert = false;
            nextYearTotalAmount = 0;
            thisYearTotalAmount = 0;
            lastYearTotalAmount = 0;
            prevYearTotalAmount = 0;
            dummy = '';
            //Arpit 03-02-2015: Initialize the Account obj 
            currentAccount = new Account();
            // Hang on to the standard controller.
            controller = stdCon;
            // Get the ID for this page.
            // If there is an Account ID, then this is an insert,
            // which was called from the Account Plan related list
            // on the Account page layout; otherwise this is an update.
            accountId = ApexPages.currentPage().getParameters().get('accountId');
            if (accountId != null && String.valueOf(accountId).substring(0, 3).equals('001'))
            {
                isInsert = true;
            } 
            else
            {
                planId = ApexPages.currentPage().getParameters().get('id');
                pageTitle = 'Modify Account Plan';
            }
            // Get the current Plan if this is an update,
            // and figure out the current Account ID.
            if (!isInsert && planId != null)
            {
                currentPlan = getCurrentPlan(planId);
            }
            // Get the current Account.
            if (accountId == null) throw new customException('No Account ID provided or found');
            list<Account> x = 
                [SELECT Id,  
                        Name, 
                        Planning_Account__c,
                        OwnerId, 
                        Owner.Name,
                        Type, 
                        Short_Name__c,
                        Product_Line__c,
                        Product_Line_Lookup__c,
                        Product_Line_Lookup__r.Is_Used_For_Planning__c,
                        RecordTypeId,
                        RecordType.Name,
                        Owner.ManagerId,
                        Owner.Manager.Name,
                        Planning_Level__c,
                        ParentId,
                        Parent.Name,
                        Parent.RecordTypeId,
                        Parent.RecordType.Name
                   FROM Account
                  WHERE Id = :accountId];
            if (x.size() > 0)
            {
                currentAccount = x[0];
            }
            else
            {
                throw new customException('Cannot find Account for ID ' + accountID);
            }
            // If the Account doesn't have a Product Line, bail.
            String verb = (isInsert ? 'create' : 'update');
            if (currentAccount.Product_Line__c == null || currentAccount.Product_Line_Lookup__c == null)
            {
                throw new customException(' Sorry, but you cannot ' + verb + ' an Account Plan for an Account that doesn\'t have a Planning Product Line assigned to it.');
            }
            // If the Account's Product Line isn't configured for planning, bail.
            if (!currentAccount.Product_Line_Lookup__r.Is_Used_For_Planning__c)
            {
                throw new customException(' Sorry, but you cannot ' + verb + ' an Account Plan for an Account that has a Planning Product Line assigned to it (' + currentAccount.Product_Line__c + ') that is not configured for planning.');
            }
            // Figure out if we can plan for this Account.
            String errMsg = canPlan(currentAccount, verb);
            if (errMsg != null)
            {
                throw new customException(errMsg);
            }
            // Get a list of existing Account Plans for this Account.
            // We want this mainly to default the new Account Plan
            // appropriately; you cannot have two Account Plans for the
            // same Account for the same Year. 
            if (isInsert)
            {
                nextYear = getNextYear();
            }
            else
            {
                // If this is an update, this is just a lookup;
                nextYear = currentPlan.Plan_Year__c;
            }
            // Calculate the previous two years.
            thisYear = String.valueOf(Integer.valueOf(nextYear) - 1);
            lastYear = String.valueOf(Integer.valueOf(nextYear) - 2);
            prevYear = String.valueOf(Integer.valueOf(nextYear) - 3);
            // Look up the Market Families for this Product Line.
            familyList =  
                [SELECT Id, Name, Product_Market_Family__c, Order_By__c, Market_Segment__c, Brand__c
                   FROM Market_Family__c
                  WHERE Product_Line__c = :currentAccount.Product_Line_Lookup__c
                    AND Is_Used_For_Planning__c = TRUE
                  ORDER BY Order_By__c ASC, Name ASC];
            // Map these Market Families by ID.
            familyMap = new map<Id, Market_Family__c>();
            for (Market_Family__c mf : familyList)
            {
                familyMap.put(mf.Id, mf);
            }
            // Either set up the new record(s) or retrieve the existing records. 
            Wrapper wrap;
            wrapperMap = new map<String, Wrapper>();
            Market_Family_Plan__c dataRecord;
            marketPlans = new list<Wrapper>();
            if (isInsert)
            {
                // Create a new Account Plan.
                // Note that this is not inserted yet.
                currentPlan = createAccountPlan(currentAccount, nextYear, '');
                // Generate a list of Market Family Plans for these Market Families.
                // If this is a new Account Plan, we will create one Market Family Plan
                // record for every Market Family. If this is an existing Account Plan,
                // we will look up all existing Market Families and fill in any blanks.
                for (Market_Family__c mf : familyList)
                {
                    dataRecord = new Market_Family_Plan__c(Market_Family__c = mf.Id, Amount__c = 0.0, Volume__c = 0);
                    wrap = new Wrapper(mf.Name, mf.Id, dataRecord);
                    marketPlans.add(wrap);
                }
            }
            else
            {
                // Look up all of the information necessary to update the existing Account Plan.
                pageSubtitle = currentPlan.Name;
                // Get a list of all existing Market Family Plans.
                list<Market_Family_Plan__c> planList = 
                    [SELECT Id, Name, Account_Plan__c, Market_Family__c, Amount__c, Volume__c 
                       FROM Market_Family_Plan__c
                      WHERE Account_Plan__c = :planId];
                // Map these by Market Family.
                map<ID, Market_Family_Plan__c> planMap = new map<Id, Market_Family_Plan__c>();
                for (Market_Family_Plan__c mfp : planList)
                {
                    planMap.put(mfp.Market_Family__c, mfp);
                }
                Market_Family_Plan__c mfp;
                for (Market_Family__c mf : familyList)
                {
                    mfp = planMap.get(mf.Id);
                    if (mfp == null)
                    {
                        dataRecord = new Market_Family_Plan__c(Market_Family__c = mf.Id, Amount__c = 0.0, Volume__c = 0);
                    }
                    else
                    {
                        dataRecord = new Market_Family_Plan__c(
                            Id = mfp.Id,
                            Account_Plan__c = mfp.Account_Plan__c,
                            Market_Family__c = mf.Id,
                            Amount__c = (mfp.Amount__c == null ? 0.0 : mfp.Amount__c),
                            Volume__c = (mfp.Volume__c == null ? 0 : mfp.Volume__c));
                        //nextYearTotalAmount += dataRecord.Amount__c;
                        nextYearTotalAmount += dataRecord.Volume__c;
                    }  
                    wrap = new Wrapper(mf.Name, mf.Id, dataRecord);
                    marketPlans.add(wrap);
                }
            }

            // At this point we have a list of Wrappers.
            Market_Family__c mf;
            for (Wrapper w : marketPlans)
            {
                mf = familyMap.get(w.marketFamilyId);
                if (mf != null)
                {
                    w.marketSegment = mf.Market_Segment__c;
                    w.brand = mf.Brand__c;
                    wrapperMap.put(mf.Name, w);
                }
            }
            
            //Mohan 09/28/2014: load the actuals using separate functions to avoid Too Many SOQL rows and for print page pull history for only this and last year
            String curPage = Apexpages.currentPage().getUrl();
            if(curPage != null && (curPage.contains('printAccountPlan') || curPage.contains('printaccountplan'))) { 
                loadActualsByYear(thisYear, 1);
                loadActualsByYear(lastYear, 2);
                //loadActualsByYear(prevYear, 3);
            }
        }
        catch (customException cex) { initialError = true; showCustomError(cex); }
        catch (Exception ex) { initialError = true; showError(ex); }    
    }
    
    public void loadThisYearHistory() {
        loadActualsByYear(thisYear, 1);
    }
    
    public void loadLastYearHistory() {
        loadActualsByYear(lastYear, 2);
    }
    
    public void loadPrevYearHistory() {
        loadActualsByYear(prevYear, 3);
    }
    
    public Pagereference redirectBack() {
        Pagereference pr = new Pagereference('/apex/addAccountPlan?id=' + currentPlan.Id);
        pr.setRedirect(true);
        return pr;
    }
  // ==============================================================================
  // PUBLIC METHODS
  // ==============================================================================
  
  // Save all changes and put up a confirmation message.
  public PageReference customSave()
  {
    try
    {
      Boolean retVal = save('Save');
    }
    catch (Exception ex) { showError(ex); return null; }
        return null;
  }

  // Save all changes and return to the calling page.
  public PageReference customSaveClose()
  {
    Boolean retVal = false;
    try
    {
      // Save all changes.
      // No confirmation message will show up because the page has closed, 
      // so the verb is fairly pointless; however, it is a required argument.
      retVal = save('');
    }
    catch (Exception ex) { showError(ex); return null; }
    // Close the page and return to the calling page.
    if (retVal) 
      return controller.cancel();
    else
      return null;
  }
  
  // Clone this Account Plan and all of its Market Family Plans.
  public pageReference customClone()
  {
    Boolean retVal = save('');
    if (retVal)
    {
      try
      {
        // Calculate the next year.
        String nextYear = getNextYear();
        // Create a new Account Plan based on this Account Plan.
        String defaultName = (currentAccount.Short_Name__c == null ? currentAccount.Name : currentAccount.Short_Name__c) + 
          '-' + currentAccount.Product_Line__c + '-' + nextYear;
        Account_Plan__c plan = createAccountPlan(currentAccount, nextYear, currentPlan.Notes__c);
        insert plan;
        planId = plan.Id;
        currentPlan = getCurrentPlan(planId);
        // All of the Market Family information is currently in marketPlans.
        // We have successfully saved these records or else we didn't get this far.
        // So all we have to do it extract a list of these records from the
        // wrapper, change the parent IDs, and re-save.
        Market_Family_Plan__c mfp;
        nextYearTotalAmount = 0;
        for (Wrapper wrap : marketPlans)
        {
          mfp = wrap.dataRecord;
          // Change the Account Plan ID.
          wrap.dataRecord = new Market_Family_Plan__c(
            Account_Plan__c = plan.Id,
            Market_Family__c = mfp.Market_Family__c,
            Amount__c = mfp.Amount__c,
            Volume__c = mfp.Volume__c);
          //nextYearTotalAmount += mfp.Amount__c;
          nextYearTotalAmount += mfp.Volume__c;
        }
        // Now re-save these only with the verb "clone".
        retVal = save('Clone');
        // Reload the actuals for the new plan.
        loadActualsByYear(thisYear, 1);
        loadActualsByYear(lastYear, 2);
        loadActualsByYear(prevYear, 3);
      }
            catch (DMLException dex) { handleDmlException(dex, 'Error while cloning Account Plan'); }
            catch (Exception ex) { showError(ex); return null; }
        }
        return null;
    }

  // ==============================================================================
  // PUBLIC METHODS
  // ==============================================================================

  // Create a new Account Plan.
  // As a side-effect, update the section header subtitle.
  public Account_Plan__c createAccountPlan(Account acct, String year, String notes)
  {
    Account_Plan__c plan;
    String defaultName = (acct.Short_Name__c == null ? acct.Name : acct.Short_Name__c) + 
      '-' + acct.Product_Line__c + '-' + year;
    plan = new Account_Plan__c(
      Account__c = acct.Id,
      Plan_Year__c = year,
      Notes__c = notes);
    pageSubtitle = defaultName;
    return plan;
  }
  
  public Account_Plan__c getCurrentPlan(ID planId)
  {
    list<Account_Plan__c> plans = 
      [SELECT Id, Name, Account__c, Plan_Year__c, Notes__c
         FROM Account_Plan__c
        WHERE Id = :planId];
    if (plans.size() > 0)
    {
      // currentPlan is public.
      currentPlan = plans[0];
    }
    else
    {
      throw new customException('Cannot find Account Plan for ID ' + planId);
    }
    // accountId is public, too.
    accountId = currentPlan.Account__c;
    return currentPlan;
  }

  public Boolean save(String verb)
  {
    Boolean retVal = false;
    list<Market_Family_Plan__c> plans = new list<Market_Family_Plan__c>();
    try
    {
      Integer recordCount = 0;
      nextYearTotalAmount = 0;
      // Save the Plan itself.
      // This will fail if there is already a Plan for this Account and Year.
      upsert currentPlan;
      // Loop over all wrapper records,
      for (Wrapper wrap : marketPlans)
      {
        // For new records, add the Account Plan.
        if (wrap.dataRecord.Account_Plan__c == null) wrap.dataRecord.Account_Plan__c = currentPlan.Id;
        // Assemble a list of Market Family Plan records to upsert.
        // We save EVERY record EVERY time.
        plans.add(wrap.dataRecord);
        // Count how many records have a value.
        //if (wrap.dataRecord.Amount__c > 0) recordCount++;
        if (wrap.dataRecord.Volume__c > 0) recordCount++;
        //nextYearTotalAmount += (wrap.dataRecord.Amount__c == null ? 0 : wrap.dataRecord.Amount__c);
        nextYearTotalAmount += (wrap.dataRecord.Volume__c == null ? 0 : wrap.dataRecord.Volume__c);
      }
      upsert plans;
      isInsert = false;
      if (verb != null && verb != '')
      {
        showConfirm(verb + 'd ' + plans.size().format() + ' Market Family Plan records for ' + 
          currentAccount.Name + ' and ' + currentAccount.Product_Line__c + ', of which ' + 
          recordCount.format() + ' currently have plans for ' + currentPlan.Plan_Year__c + '.');
      }
      retVal = true;
    }
        catch (DMLException dex) { handleDmlException(dex, 'Error while upserting Market Family Plans'); }
        catch (Exception ex) { showError(ex); }
        return retVal;
    }

    // Process DML Exception in a separate function to improve test class coverage.
    public void handleDmlException(DMLException dex, String msg)
    {
        for (Integer i = 0; i < dex.getNumDml(); i++)
        {
            Id id = dex.getDmlId(i);
            if (id == null) continue;
            showError(dex, msg);
        }
    }

    public String showCustomError(Exception ex)
    {
        String errMsg = ex.getMessage();
        showDebug('CUSTOM', errMsg);
        ApexPages.Message msg = 
            new ApexPages.Message(ApexPages.Severity.Error, errMsg);
        ApexPages.addMessage(msg);
        return errMsg;
    }

  public String showDebug(String lbl, String dbg)
  {
    String s = 'FROM ' + userInfo.getUserName() + ': ' + lbl + '=' + dbg;
    system.debug(s);
    return s;
  }

  public String showError(Exception ex)
  {
    return showError(ex, '');
  }
  public String showError(Exception ex, String err)
  {
    String errMsg = 
      (err == null || err == '' ? '' : err + ': ') + 
      ex.getMessage() + ' at line ' + 
      ex.getLineNumber().format();
      showDebug('FATAL', errMsg);
    ApexPages.Message msg = 
      new ApexPages.Message(ApexPages.Severity.Error, errMsg);
    ApexPages.addMessage(msg);
    return errMsg;
  }

   public String showConfirm(String conf)
   {
      showDebug('CONFIRM', conf);
      ApexPages.Message msg = 
         new ApexPages.Message(ApexPages.Severity.Confirm, conf);
      ApexPages.addMessage(msg);
      return conf;
   }

   public String showInfo(String info)
   {
      showDebug('INFO', info);
      ApexPages.Message msg = 
         new ApexPages.Message(ApexPages.Severity.Info, info);
      ApexPages.addMessage(msg);
      return info;
   }

  // Get the next available Plan year.
  public String getNextYear()
  {
    //Arpit - 03/02/2015 - Adding a logic to set date standard as october.
    //logic to display year
    String currentYear = '';
    if(System.today().month()<10){
        currentYear = String.valueOf(System.today().year());
    }else if(System.today().month()>= 10){
        currentYear = String.valueOf(System.today().year() + 1);
    }
    String nextYear = currentYear;
    //String nextYear = String.valueOf(system.today().year() + 1);
    list<Account_Plan__c> existingPlans =
      [SELECT Id, Name, Account__c, Plan_Year__c, Notes__c
         FROM Account_Plan__c
        WHERE Account__c = :accountId
        ORDER BY Plan_Year__c DESC];
    // Calculate the logical next year.
    // There is a trigger in place to prevent duplicates.
    if (existingPlans.size() > 0)
    {
      Account_Plan__c plan = existingPlans[0];
      if (plan.Plan_Year__c != null)
      {
        nextYear = plan.Plan_Year__c;
        if (nextYear.isNumeric())
        {
            //Arpit 03/02/2015: Validating the Account Plan Year will only get incremented by one after reaching October 1 of current year
            if(currentYear == nextYear){
                isInsert= false;
                planId = plan.Id;
                currentPlan = plan;
                pageTitle = 'Modify Account Plan';
                currentPlan = getCurrentPlan(planId);
                String verb = (isInsert ? 'create' : 'update');
            } else{
                nextYear = String.valueOf(Integer.valueOf(nextYear) + 1);
            }
        }
      }
    }
    return nextYear;
  }
  
    // Encapsulate the logic to figure out if we can actually do planning for this Account.
    // The default condition is that you do planning for BPCS Bill-To Accounts.
    // We determine at what LEVEL we are going to plan based on the top-level Account
    // in the Account hierarchy. There are at most three levels: Corporate, Bill-To, and Ship-To.
    // Account planning is NOT managed by Product Line. 
    // Ship-To Accounts can roll up directly to Corporate Accounts.
    public String canPlan(Account currentAccount, String verb)
    {
        Account parentAccount;
        Account grandParentAccount;
        string errMsg = null;
        Boolean retVal = true;
        
        
        // The default planning level is TYPE_BILLTO; if nothing is defined, use this.
        //String planningLevel = TYPE_BILLTO;
        // Does the current Account have a parent?
        //if (currentAccount.ParentId != null)
        //{
            //parentAccount = 
                //[SELECT Id, Name, ParentId, Planning_Level__c FROM Account WHERE Id = :currentAccount.ParentId];
        //  if (parentAccount != null && planningLevel != null)
            //{
            //  planningLevel = parentAccount.Planning_Level__c;
            //}
        //}
        // Does the current Account's parent Account have a parent?
        //if (parentAccount != null && parentAccount.ParentId != null)
        //{
            //grandParentAccount =
                //[SELECT Id, Name, Planning_Level__c FROM Account WHERE Id = :parentAccount.ParentId];
            //if (grandParentAccount != null && grandParentAccount.Planning_Level__c != null)
        //  {
        //      planningLevel = grandParentAccount.Planning_Level__c;
        //  }
    //  }
    //  if (planningLevel != null)
    //  {
            // Now compare the current Account's record type to the planning level,
            // and only allow Account Planning when they match. This means, first,
            // that Corporate Accounts cannot plan. Why? 
            // Is this a Ship-To Account?
    //      if (((currentAccount.RecordType.Name.containsIgnoreCase(TYPE_SHIPTO) &&
     //         !planningLevel.containsIgnoreCase(TYPE_SHIPTO)) ||
     //         (currentAccount.RecordType.Name.containsIgnoreCase(TYPE_BILLTO) &&
     //         !planningLevel.containsIgnoreCase(TYPE_BILLTO)) ||
     //         (currentAccount.RecordType.Name.containsIgnoreCase(TYPE_CORP) &&
     //         !planningLevel.containsIgnoreCase(TYPE_CORP)))) 
    //      {
    //          return ' Sorry, but you cannot ' + verb + ' an Account Plan for this ' + 
    //              currentAccount.RecordType.Name + 
    //              ' Account when the Planning Level for this Account is "' + 
    //              planningLevel + '".';
    //       }
    //  }
    //  else
    //  {
    //      return ' Sorry, but you cannot ' + verb + ' an Account Plan when the Planning Level has not yet been defined.';
    //  }
        
        
        if(currentAccount.Planning_Account__c != 'Yes'){
            return ' Sorry, but you cannot ' + verb + ' an Account Plan for this Account. Please select Planning Account at Account level.';
        }
        
        return errMsg;
    }
  
    // For the year and Account passed in, calculate the actuals 
    // and copy these into the mapped Wrappers. currentAccount and wrapperMap are public.
    public Boolean loadActualsByYear(String year, Integer level)
    {
        Wrapper w;
        String family = '';
        Decimal amount = 0;
        try
        {
            //Mohan- changing the SUM(Amount__c) to SUM(Squares__c)
            list<AggregateResult> results = 
                [SELECT Market_Family__c, SUM(Squares__c)
                   FROM Invoice_Line_Item__c
                  WHERE Invoice__r.Ship_To_Lookup__c = :currentAccount.Id AND (NOT Invoice__r.PO_Number__c like 'TPE%') 
                    AND Year__c = :year
                  GROUP BY Market_Family__c];
            for (AggregateResult ar : results)
            {
                // See if we have a Market Family string.
                family = (String)ar.get('Market_Family__c');
                amount = (Decimal)ar.get('expr0');
                if (family != null && family != '')
                {
                    // We have one. See if there is a matching Wrapper.
                    // There won't in a lot of cases - there are a LOT
                    // more Market Family values on the Product.Market_Family__c
                    // picklist than there are records in the Market_Family__c
                    // object.
                    w = wrapperMap.get(family);
                    if (w != null)
                    {
                        // Update the wrapper to accumulate the Amount field.
                        if (level == 1)
                        {
                            w.thisYearAmount += (amount == null ? 0 : amount);
                            thisYearTotalAmount += w.thisYearAmount;
                        }
                        else if (level == 2)
                        {
                            w.lastYearAmount += (amount == null ? 0 : amount);
                            lastYearTotalAmount += w.lastYearAmount;
                        }
                        else if (level == 3)
                        {
                            w.prevYearAmount += (amount == null ? 0 : amount);
                            prevYearTotalAmount += w.prevYearAmount;
                        }
                    }
                }
            }
            return true;
        }
        catch (Exception ex) { initialError = true; showError(ex); }
        return false;    
    }

    // ==============================================================================
    // PUBLIC CLASSES
    // ==============================================================================
    public class customException extends Exception {}

    public class Wrapper
    {
        // Attributes.
        public String marketFamilyName { get; set; }
        public String marketFamilyId { get; set; }
        public Decimal prevYearAmount { get; set; }
        public Decimal lastYearAmount { get; set; }
        public Decimal thisYearAmount { get; set; }
        public String marketSegment { get; set; }
        public String brand { get; set; }
        public Market_Family_Plan__c dataRecord { get; set; }
        // Constructors.
        public Wrapper(String theName, ID theID,  
            Decimal prevAmount, Decimal lastAmount, Decimal thisAmount, 
            String marketSegment, String brand, Market_Family_Plan__c mfp)
        {
            this.marketFamilyName = theName;
            this.marketFamilyId = theId;
            this.prevYearAmount = prevAmount;
            this.lastYearAmount = lastAmount;
            this.thisYearAmount = thisAmount;
            this.marketSegment = marketSegment;
            this.brand = brand;
            this.dataRecord = mfp;
        }
        public Wrapper(String theName, ID theID, Market_Family_Plan__c mfp)
        {
            this.marketFamilyName = theName;
            this.marketFamilyId = theId;
            this.prevYearAmount = 0;
            this.lastYearAmount = 0;
            this.thisYearAmount = 0;
            this.marketSegment = null;
            this.brand = null;
            this.dataRecord = mfp;
        }
    }
}