// ==================================================================================
//   Object: AccountPlanReportCorp
//  Company: CT-SPG
//   Author: Mohan Kumar (TCS)
// Comments: 
// ==================================================================================
//  Changes: 2014-09-25 Initial version.
//           2015-02-26 Arpit Vashishtha (Huron)
//              Validating the Account Plan Year will only get incremented by one after reaching October 1 of current year
// ==================================================================================

public with sharing class AccountPlanReportCorp
{
    // ==============================================================================
    // CONSTANTS
    // ==============================================================================
    public static final String TYPE_BPCS = 'BPCS%';
    public static final String TYPE_BILLTO = 'Bill-To';
    public static final String TYPE_SHIPTO = 'Ship-To';
    public static final String TYPE_CORP = 'Corporate';
    
    public String accountCorp {get;set;}
    public List<Selectoption> accountCorpOptions {get;set;}
    public String accountRecordType {get;set;}
    public List<Selectoption> accountRecordTypeOptions {get;set;}
    public List<Account_Plan__c> apcorpresults{get;set;}
  
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
    
    Set<String> productLines = new Set<String>();
    Set<Id> accIds = new Set<Id>();
    
    // ==============================================================================
    // CONSTRUCTORS 
    // ==============================================================================
    public AccountPlanReportCorp(ApexPages.standardController stdCon)
    {
        // Hang on to the standard controller.
        controller = stdCon;
        currentAccount = new Account();
        accountRecordTypeOptions = new List<Selectoption>();
        accountCorpOptions = new List<Selectoption>();
        List<String> accNames = new List<String>();
        List<string> accNumbers = new List<string>();
        accountRecordTypeOptions.add(new Selectoption('', '--Select--'));
        accountCorpOptions.add(new Selectoption('', '--Select--'));
        
        accNumbers.add('000004');
        accNumbers.add('000006');
        accNumbers.add('000008');
        accNumbers.add('000039');
        accNumbers.add('000060');
        accNumbers.add('000078');
        accNumbers.add('000091');
        accNumbers.add('000146');
        accNumbers.add('000152');
        accNumbers.add('000209');
        accNumbers.add('000210');
        accNumbers.add('000217');
        accNumbers.add('000220');
        accNumbers.add('000226');
        accNumbers.add('000233');
        accNumbers.add('000236');
        accNumbers.add('000264');
        accNumbers.add('000286');
        accNumbers.add('000291');
        accNumbers.add('000296');
        accNumbers.add('000297');
        accNumbers.add('000307');
        accNumbers.add('000309');
        accNumbers.add('000649');
        accNumbers.add('000851');
        accNumbers.add('000867');
        accNumbers.add('000869');
        accNumbers.add('000880');
        accNumbers.add('000888');
        accNumbers.add('002840');
        accNumbers.add('002913');
        accNumbers.add('003552');
        accNumbers.add('003605');
        accNumbers.add('003615');
        accNumbers.add('003620');
        accNumbers.add('003622');
        accNumbers.add('003647');
        accNumbers.add('003673');
        accNumbers.add('003685');
        accNumbers.add('003699');
        accNumbers.add('003703');
        accNumbers.add('003714');
        accNumbers.add('019003');
        accNumbers.add('019006');
        accNumbers.add('019051');
        accNumbers.add('019064');
        accNumbers.add('019072');
        accNumbers.add('019167');
        accNumbers.add('019168');
        
        //remove since the names are causing issue with the TRIM
        //accNames.add('LYF-TYM BLDG PROD CO INC');
        //accNames.add('HOWARD BUILDING SUPPLY');
        
        List<Account> accountCorpList = [Select a.Id, a.Name, a.SAP_ACCOUNT__c From Account a where a.SAP_ACCOUNT__c IN :accNumbers];
        for(Account a : accountCorpList) {
            accountCorpOptions.add(new Selectoption(a.Id, a.Name));
        }
        
        //accountRecordType = Apexpages.currentPage().getParameters().get('rt');
        //if(accountRecordType != null && accountRecordType != '') performSearch();
        
        accountCorp = Apexpages.currentPage().getParameters().get('pid');
        if(accountCorp != null) performSearch();
    }
    
    public void performSearch() {
        
        try
        {
            if(accountCorp == null) {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.Error, 'Please select a Account');
                return;
            }
            // Set defaults.
            initialError = false;
            pageTitle = 'New Account Plan';
            pageSubtitle = 'Error';
            isInsert = true;
            nextYearTotalAmount = 0;
            thisYearTotalAmount = 0;
            lastYearTotalAmount = 0;
            prevYearTotalAmount = 0;
            dummy = '';
            
            nextYear = getNextYear();
            
            List<Account> aList = [Select Id, PRICE_GROUP__c, Product_Line_Lookup__c From Account Where ParentId =: accountCorp and Product_Line_Lookup__c != null and Type = 'Ship-To'];

            for(Account a : aList) {
                accIds.add(a.Id);
                productLines.add(a.Product_Line_Lookup__c);
            }
            
            
            // Calculate the previous two years.
            thisYear = String.valueOf(Integer.valueOf(nextYear) - 1);
            lastYear = String.valueOf(Integer.valueOf(nextYear) - 2);
            prevYear = String.valueOf(Integer.valueOf(nextYear) - 3);
            // Look up the Market Families for this Product Line.
            familyList =  
                [SELECT Id, Name, Product_Market_Family__c, Order_By__c, Market_Segment__c, Brand__c
                   FROM Market_Family__c
                  WHERE Product_Line__c IN :productLines 
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
                for (Market_Family__c mf : familyList)
                {
                    dataRecord = new Market_Family_Plan__c(Market_Family__c = mf.Id, Amount__c = 0.0, Volume__c = 0);
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
            loadActualsByYear(thisYear, 1);
            loadActualsByYear(lastYear, 2);
            loadActualsByYear(nextYear, 3);
        }
        catch (customException cex) { initialError = true; showCustomError(cex); }
        catch (Exception ex) { initialError = true; showError(ex); }    
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
    //Arpit 26/02/2015: commenting this line to add a logic for next year condition.
    //String nextYear = String.valueOf(system.today().year() + 1);
    
    //Arpit - 26/02/2015 - Adding a logic to set date standard as october.
    //logic to display year
    String currentYear = '';
    if(System.today().month()<10){
        currentYear = String.valueOf(System.today().year());
    }else if(System.today().month()>= 10){
        currentYear = String.valueOf(System.today().year() + 1);
    }
    String nextYear = currentYear;
    
    return nextYear;
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
            if(level == 1 || level == 2) {
                list<AggregateResult> results = 
                    [SELECT Market_Family__c, SUM(Squares__c)
                       FROM Invoice_Line_Item__c
                      WHERE Invoice__r.Ship_To_Lookup__c IN :accIds AND (NOT Invoice__r.PO_Number__c like 'TPE%') 
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
                                w.nextYearAmount += (amount == null ? 0 : amount);
                                nextYearTotalAmount += w.nextYearAmount;
                            }
                        }
                    }
                }
            } else if(level == 3) {
                List<AggregateResult> results = [Select Market_Family__r.Name, Sum(Volume__c) From Market_Family_Plan__c m Where Year__c =: year and Account_Plan__r.Account__c IN :accIds GROUP BY Market_Family__r.Name];
                for (AggregateResult ar : results) {
                    // See if we have a Market Family string.
                    family = (String)ar.get('Name');
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
                            if (level == 3)
                            {
                                w.nextYearAmount += (amount == null ? 0 : amount);
                                nextYearTotalAmount += w.nextYearAmount;
                            }
                        }
                    }
                }
                apcorpresults = [Select a.Id, a.Account__c, a.Account__r.Name,a.Plan_Year__c, a.Total_Volume__c, a.Notes__c, a.Name From Account_Plan__c a Where Plan_Year__c =:year and Account__c IN:accIds ];
                 system.debug( 'acountplanCorp'+apcorpresults );
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
        public Decimal nextYearAmount { get; set; }
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
            this.nextYearAmount = 0;
            this.marketSegment = null;
            this.brand = null;
            this.dataRecord = mfp;
        }
    }
}