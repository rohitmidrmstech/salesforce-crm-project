/****************************************************************************************************************************************
*    @description     : The Aims_Quote Wrapper  class that handles the conversion of Quote data received from a Java SQL server into Salesforce Opportunity objects.
                        It encapsulates both the data and the logic for creating Salesforce records based on that data
*    @ date           : 06-OCT-2023
*    @ Created By     : Sujata p. Galinde
*****************************************************************************************************************************************/

global class Aims_Quote {   
    
    public List<Map<String, Object>> quotes;
    global Aims_Quote(){
        quotes = new List< Map<String, Object>> ();
    } 
   /* public String branchId;
    public String branch ;
    public String custcode;
    public String address1;
    public String address2;
    public String address3;
    public String postcode;
    public String quoteNumber;
    public String quoteDate;
    public String opportunityName;
    public String closeDate;
    public String stage;
    public decimal totalValue;
    public decimal mfgAmount;
    public String manufacturingRequired;
    public String leadSource;
    public String forecastCategory;
    public String lostOrWondate;
    public String order;
    public String newQuoteStatus;
    public String lostReason;
    public String accountName;
    private String slsName;

    global Aims_Quote ( String branchId,
                       String branch,
                       String custcode ,
                       String address1,
                       String address2,
                       String address3,
                       String postcode,
                       String quoteNumber, 
                       String quoteDate,
                       String opportunityName,
                       String closeDate,
                       String stage,
                       decimal totalValue,
                       decimal mfgAmount,
                       String manufacturingRequired,
                       String leadSource,
                       String forecastCategory,
                           String lostOrWondate,
                           String order,
                           String newQuoteStatus,
                           String lostReason,
                          String accountName,
                       String slsName
                       ) {
                           this.branch =branch;       
                           this.custcode = custcode;
                           this.address1= address1;
                           this.address2 = address2;
                           this.address3 = address3;
                           this.postcode =postcode;
                           this.quoteNumber = quoteNumber;
                           this.quoteDate = quoteDate;
                           this.opportunityName =opportunityName;
                           this.closeDate =closeDate;
                           this.stage =stage;
                           this.totalValue = totalValue;
                           this.mfgAmount  = mfgAmount;
                           this.manufacturingRequired = manufacturingRequired;
                           this.leadSource = leadSource;
                           this.forecastCategory =forecastCategory;
                           this.lostOrWondate = lostOrWondate;
                           this.order = order;
                           this.newQuoteStatus =newQuoteStatus;
                           this.lostReason = lostReason;
                           this.accountName= accountName;
                           
                       } 
    
    global Opportunity getOpportunity(){
        String pattern = '[0-9]+$';
        Opportunity opp = new Opportunity();  
        Branch__c branchReference = branch != null ? new Branch__c(Branch_Code__c = branch) : null;
        opp.Branch__r = branchReference;
        opp.Name = opportunityName?.replaceAll(pattern, '').trim();  
        opp.Quote_Number__c = quoteNumber;
       opp.Mailing_Street__c =  (address1 != null ? address1+' ' : '') +
                                (address2 != null ? address2+' ' : '') +
                                (address3 != null ? address3+' ' : '') +
                                (postcode != null ? postcode : '');
        opp.QuoteDate__c = quoteDate != null ? Date.valueOf(quoteDate) : null;
        opp.CloseDate = closeDate != null ? Date.valueOf(closeDate) : null;
        opp.Amount = totalValue;
        opp.StageName = stage;
        opp.Manufacturing_Amount__c = mfgAmount;
        opp.Manufacturing_Required__c = manufacturingRequired;
        opp.LeadSource = leadSource;
        opp.ForecastCategoryName = forecastCategory;
        opp.Lost_Reason__c =lostReason;
        Account accountReference = custcode != null ? new Account(AIMS_Customer__c = custcode) : null;
        opp.Account = accountReference;
        opp.Account_Name_Description__c=accountName;
        return opp;
    }*/
}