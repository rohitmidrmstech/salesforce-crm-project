// ==================================================================================
//   Object: showTradeAreaMarketController
//  Company: CT-SPG
//   Author: John Westenhaver (Sales Optimizer)
// Comments: Controller for showTradeAreaMarketShare page. This page is accessible 
//           from the Show Market Share button on the Trade Area page layout.
//           Keep in mind that each Trade Area belongs to a SINGLE Product Line.
// ==================================================================================
//  Changes: 2012-10-03 Initial version.
// ==================================================================================

public with sharing class showTradeAreaMarketController
{
    // ==============================================================================
    // CONSTANTS
    // ==============================================================================
    public static final String PRODUCT_LINE = 'Siding';
    
    // ==============================================================================
    // PUBLIC ATTRIBUTES
    // ==============================================================================
    // Flag controlling how fatal errors are shown. 
    public Boolean initialError { get; set; }
    // Controls section header attributes.
    public String pageTitle { get; set; }
    public String pageSubtitle { get; set; }
    // Current Trade Area.
    //public Trade_Area__c currentArea { get; set; }
    // Grab the Product Line for each use.
    public String productLine { get; set; }
    // Year labels.
    public String thisYear { get; set; }    // actuals
    public String lastYear { get; set; }    // actuals
    // Demand values.
    public Decimal thisYearDemandAmount { get; set; }
    public Decimal lastYearDemandAmount { get; set; }
    // Current forecast for this year.
    public Decimal currentForecast { get; set; }
    // Actual sales for last year.
    public Decimal actualSalesLastYear { get; set; }
    // Running totals.
    public Decimal thisYearTotalAmount { get; set; }
    public Decimal lastYearTotalAmount { get; set; }
    public String dummy { get; set; }
    // List of all Accounts in a accountWrapper.
    public list<accountWrapper> accountList { get; set; }
    // List of Trade Area in a tradeWrapper list,
    // engineered just to let us use a pageBlockTable.
    public list<tradeWrapper> tradeList { get; set; }
    public Boolean fromArea { get; set; }
    public String tmId { get; set; }

    // ==============================================================================
    // PRIVATE ATTRIBUTES
    // ==============================================================================
    private ApexPages.StandardController controller { get; set; }
    private ID areaID { get; set; }
    private map<Id, accountWrapper> wrapperMap { get; set; }
    private set<Id> accountIds = new set<Id>();
    
    // ==============================================================================
    // CONSTRUCTORS 
    // ==============================================================================
    public showTradeAreaMarketController()
    {
        try
        {
            // Set defaults.
            initialError = false;
            pageTitle = 'Show Market Share';
            pageSubtitle = 'Page Error';
            dummy = '';
            thisYearTotalAmount = 0;
            lastYearTotalAmount = 0;
            tradeList = new list<tradeWrapper>();
            tradeList.add(new tradeWrapper());
            fromArea = false;
            // Hang on to the standard set controller.
            //controller = stdCon;
            // Get the ID for this page.
            areaId = ApexPages.currentPage().getParameters().get('id');
            // Get the current Trade Area.
        /*  list<Trade_Area__c> areas = 
                [SELECT Id, Name, Product_Line__c, Trade_Area_Code__c
                  FROM Trade_Area__c
                  WHERE Id = :areaId];
            if (areas.size() > 0)
            {
                currentArea = areas[0];
                pageSubtitle = currentArea.Name;
                // Capture the Product Line for easy of use.
                productLine = currentArea.Product_Line__c;
            }
            else
            {
                throw new customException('Cannot find Trade Area for ID ' + areaId);
            }*/
            // Look for a special flag on the querystring and, if present, change navigation.
            if (ApexPages.currentPage().getParameters().get('source') != null)
            {
                fromArea = true;
                tmId = ApexPages.currentPage().getParameters().get('tmId');
            }
            // Calculate dates. Many, many dates.
            thisYear = String.valueOf(system.today().year());
            lastYear = String.valueOf(system.today().year() - 1);
            Date startLastYear = Date.newInstance(system.today().year() - 1, 1, 1);
            Date endLastYear = Date.newInstance(system.today().year() - 1, 12, 31);
            Date startThisYear = Date.newInstance(system.today().year(), 1, 1);
            Date endThisYear = Date.newInstance(system.today().year(), 12, 31);
            // Declare a map of accountWrappers so we can lookup any accountWrapper by Account ID.
            wrapperMap = new map<Id, accountWrapper>();
            // We are going to find all of the Accounts for this Trade Area and
            // Product Line first, then create the wrappers and accountWrapperMap, then 
            // accumulate all of the values for each Account.
            accountWrapper w;
            accountList = new list<accountWrapper>();
            
            double lastYearTotal = 0;
            
            /*list<Account> accounts = 
                [SELECT Id, Name ,Volume_Last_Year__c
                   FROM Account 
                  WHERE RecordType.Name LIKE 'BPCS%' AND Trade_Area__c = :areaId 
                    AND Product_Line__c = :productLine
                  ORDER BY Name];
            for (Account a : accounts)
            {   
                double salesLastYear = 0;
                if(a.Volume_Last_Year__c != null){
                    salesLastYear = a.Volume_Last_Year__c;
                }
                
                lastYearTotal = lastYearTotal + salesLastYear;
                
                w = new accountWrapper(a.Name, a.Id, 0, 0, salesLastYear);
                accountList.add(w);
                wrapperMap.put(a.Id, w);
                // Remember the ID so we don't have to run this query again.
                accountIds.add(a.Id);
            }*/
            // Now look up the six values are are trade-area-specific.
            // This is actually six different queries.
            // First Look up the market demand last year and this year.
            // Default to zero as needed.
            thisYearDemandAmount = 0;
            lastYearDemandAmount = 0;
           /* list<Trade_Area_Demand__c> demandList; 
            demandList = 
                [SELECT Id, Demand_Volume__c 
                   FROM Trade_Area_Demand__c
                  WHERE Trade_Area__c = :areaId
                    AND Year__c = :thisYear];
            if (demandList.size() > 0)
            {
                thisYearDemandAmount = demandList[0].Demand_Volume__c;
            }
            demandList = 
                [SELECT Id, Demand_Volume__c 
                   FROM Trade_Area_Demand__c
                  WHERE Trade_Area__c = :areaId
                    AND Year__c = :lastYear];
            if (demandList.size() > 0)
            {
                lastYearDemandAmount = demandList[0].Demand_Volume__c;
            }*/
            // Look up the current forecast for this year, for all customers
            // associated with this Trade Area and Product Line.
            currentForecast = 0;
            list<AggregateResult> sum =
                [SELECT SUM(Total_Amount__c) 
                   FROM Account_Plan__c 
                  WHERE Plan_Year__c = :thisYear 
                    AND Account__c IN :accountIds];
            for (AggregateResult ar : sum)
            {
                if ((Decimal)ar.get('expr0') != null)
                {
                    currentForecast = (Decimal)ar.get('expr0');
                    break;
                }
            }  
            if (currentForecast == null) currentForecast = 0;
            // Look up the actual sales for this year, for all customers
            // associated with this Trade Area.
             
            actualSalesLastYear = 0;
            
            /*
            sum = 
                [SELECT SUM(Invoice_Total__c)
                   FROM Invoice__c
                  WHERE Account__r.Trade_Area__c = :areaId
                    AND Invoice__r.Billing_Date__c >= :startLastYear
                    AND Invoice__r.Billing_Date__c <= :endLastYear];
            for (AggregateResult ar : sum)
            {
                actualSalesLastYear = (Decimal)ar.get('expr0');
                break;
            }  
            */
            
            actualSalesLastYear = lastYearTotal;
            
            if (actualSalesLastYear == null) actualSalesLastYear = 0;
             
            // Populate the tradeList[0] values so we can use pageBlockTable.
            tradeList[0].actualsLastYear = actualSalesLastYear;
            tradeList[0].forecastThisYear = currentForecast;
            tradeList[0].demandLastYear = lastYearDemandAmount;
            tradeList[0].demandThisYear = thisYearDemandAmount;
            // Calculate the Change Points.
            Decimal actualMarketShareLastYear = 0;
            Decimal forecastMarketShareThisYear = 0;
            if (tradeList[0].demandLastYear > 0)
            {
                actualMarketShareLastYear = tradeList[0].actualsLastYear / tradeList[0].demandLastYear;
            }
            if (tradeList[0].demandThisYear > 0)
            {
                forecastMarketShareThisYear = tradeList[0].forecastThisYear / tradeList[0].demandThisYear;
            }
            Integer changePoints = Integer.valueOf((forecastMarketShareThisYear - actualMarketShareLastYear) * 100);
            // Make this a negative if the actuals are more than the forecast.
            if (actualMarketShareLastYear > forecastMarketShareThisYear) 
                tradeList[0].changePoints = '(' + changePoints.format() + ')';
            else
                tradeList[0].changePoints = ' ' + changePoints + ' ';
            // Set the TM ID if known.
            if (tmId != null && tmId != '') tradeList[0].tmId = tmId; 
            // Look up the Accounts that share this Trade Area and Product Line, and
            
            list<AggregateResult> results;
            String accountName;
            String accountId;
            Decimal amt;
            
            // calculate the aggregates for last year.
            /* 
            results = 
                [SELECT Invoice__r.Account__c accountId, Invoice__r.Account__r.Name accountName, SUM(Amount__c)
                   FROM Invoice_Line_Item__c
                  WHERE Invoice__r.Account__r.Trade_Area__c = :areaId
                    AND Invoice__r.Billing_Date__c >= :startLastYear
                    AND Invoice__r.Billing_Date__c <= :endLastYear
                  GROUP BY Invoice__r.Account__c, Invoice__r.Account__r.Name
                  ORDER BY Invoice__r.Account__r.Name];
            // Process these results. 
            for (AggregateResult ar : results)
            {
                accountId = (String)ar.get('accountId');
                w = wrapperMap.get(accountId);
                if (w != null)
                {
                    amt = (Decimal)ar.get('expr0');
                    if (amt != null)
                    {
                        w.lastYearAmount = amt;
                    }
                    wrapperMap.put(accountId, w);
                }
            }
            */
            
            // Look up the Accounts that share this Trade Area and Product Line, and
            // calculate the aggregates for this year.
            results = 
                [SELECT Invoice__r.Ship_To_Lookup__c accountId, Invoice__r.Ship_To_Lookup__r.Name accountName, SUM(Amount__c)
                   FROM Invoice_Line_Item__c
                  WHERE /*Invoice__r.Ship_To_Lookup__r.Trade_Area__c = :areaId
                    AND */Invoice__r.Billing_Date__c >= :startThisYear
                    AND Invoice__r.Billing_Date__c <= :endThisYear
                  GROUP BY Invoice__r.Ship_To_Lookup__c, Invoice__r.Ship_To_Lookup__r.Name
                  ORDER BY Invoice__r.Ship_To_Lookup__r.Name];
            for (AggregateResult ar : results) 
            {
                accountId = (String)ar.get('accountId');
                w = wrapperMap.get(accountId);
                if (w != null)
                {
                    amt = (Decimal)ar.get('expr0');
                    if (amt != null)
                    {
                        w.thisYearAmount = amt;
                    }
                    wrapperMap.put(accountId, w);
                }
            }
            // Look up the forecast values for next year.
            // We have a handy rollup summary on Account Plan, so it's a simple query
            // instead of an aggregate.
            list<Account_Plan__c> plans =
                [SELECT Id, Account__c, Total_Amount__c
                   FROM Account_Plan__c
                  WHERE Account__c IN :accountIds
                    AND Plan_Year__c = :thisYear];
            for (Account_Plan__c ap : plans)
            {
                w = wrapperMap.get(ap.Account__c);
                if (w != null)
                {
                    w.nextYearAmount = ap.Total_Amount__c;
                }
            }
        }
        catch (customException cex) { initialError = true; showCustomError(cex); }
        catch (Exception ex) { initialError = true; showError(ex); }        
    }

    // ==============================================================================
    // PUBLIC METHODS
    // ==============================================================================

    public PageReference doCancel()
    {
        PageReference p;
        if (fromArea)
        {
            p = new PageReference('/apex/showAreaMarketShare?tmId=' + tmId);
        }
        else
        {
            p = new PageReference('/' + areaId);
        }
        p.setRedirect(true);
        return p;
    }

    // ==============================================================================
    // PRIVATE METHODS
    // ==============================================================================

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

    public String showInfo(String info)
    {
        showDebug('INFO', info);
        ApexPages.Message msg = 
            new ApexPages.Message(ApexPages.Severity.Info, info);
        ApexPages.addMessage(msg);
        return info;
    }
    
    // ==============================================================================
    // PUBLIC CLASSES
    // ==============================================================================
    public class customException extends Exception {}

    public class accountWrapper
    {
        // Attributes.
        public String accountName { get; set; }
        public String accountId { get; set; }
        public Decimal nextYearAmount { get; set; }
        public Decimal thisYearAmount { get; set; }
        public Decimal lastYearAmount { get; set; }
        // Constructors.
        public accountWrapper(String theName, ID theID,  
            Decimal nextAmount, Decimal thisAmount, Decimal lastAmount)
        {
            this.accountName = theName;
            this.accountId = theId;
            this.nextYearAmount = nextAmount;   // forecasts
            this.thisYearAmount = thisAmount;   // actuals
            this.lastYearAmount = lastAmount;   // actuals
        }
    }
    
    public class tradeWrapper
    {
        public Decimal demandThisYear { get; set; }
        public Decimal demandLastYear { get; set; }
        public Decimal forecastthisYear { get; set; }
        public Decimal actualsLastYear { get; set; }
        public String changePoints { get; set; }
        public String tmId { get; set; }
    }
}