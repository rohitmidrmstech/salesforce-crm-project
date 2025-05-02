/****************************************************************************************************************************************
*    @description     : The AimsIntegrationResult class manages the results of the integration process, including both upsert(Opportunity) and Insert(Account) operations. 
It provides methods to add individual results, add lists of results, and retrieve integration logs
*    @ date           : 06-OCT-2023
*    @ Created By     : Sujata p. Galinde
*****************************************************************************************************************************************/
global class AimsIntegrationResult {
    public List<UpsertResult> res;
    public List<SaveResult> saveResultRes;
    
    public AimsIntegrationResult(){
        res = new List<UpsertResult> ();
        saveResultRes = new List<SaveResult> ();
        
    }
    public void addIndividualResult(UpsertResult indRes){
        res.add(indRes);
    }
    public void addIndividualResult(SaveResult indRes){
        saveResultRes.add(indRes);
    }
    
    public void addResults(List<UpsertResult> lstRes){
        res.addAll(lstRes);
    }
    public void addResults(List<SaveResult> lstRes){
        saveResultRes.addAll(lstRes);
    }
    
    public List<AIMSIntegrationLog__c> getIntegrationLogs(){
        List<AIMSIntegrationLog__c> lstLogs = new List<AIMSIntegrationLog__c>();
        for(UpsertResult r : res){
            lstLogs.add(r.getIntegrationLog());
        }
        return lstLogs;
    }
    public List<AIMSIntegrationLog__c> getIntegrationLogss(){
        List<AIMSIntegrationLog__c> lstSaveResultLogs = new List<AIMSIntegrationLog__c>();
        for(SaveResult re : saveResultRes){
            lstSaveResultLogs.add(re.getIntegrationLogs());
        }
        return lstSaveResultLogs;
    }
    
    global class UpsertResult{
        String custcode;
        String quoteNumber;
        boolean isSuccess;
        String errorMessage;
        String salesforceId;
        String name;
        public UpsertResult(String name ,String quoteNumber, String custcode, boolean isSuccess, String errorMessage, String salesforceId){
            this.name = name ;
            this.quoteNumber = quoteNumber;
            this.custcode = custcode;
            this.isSuccess = isSuccess;
            this.errorMessage = errorMessage;
            this.salesforceId = salesforceId;
        }
        public UpsertResult(String quoteNumber, String name,  Database.UpsertResult res){
            this.quoteNumber= quoteNumber;
            this.name= name;
            isSuccess = res.isSuccess();
            salesforceId = res.getId();
            String errorMesasge = '';
            for (Database.Error error : res.getErrors()) {
                errorMesasge = errorMesasge + error.getMessage();
                
            }
            this.errorMessage = errorMesasge;
        }
        public String getname() {
            return name;
        }
        public String getQuoteNumber() {
            return quoteNumber;
        }
        public Boolean getisSuccess() {
            return isSuccess;
        }
        public String geterrorMessage() {
            return errorMessage;
        }
        
        public AIMSIntegrationLog__c getIntegrationLog(){
            return new AIMSIntegrationLog__c(Name = name  ,Quote_Number__c=quoteNumber,Customer_Number__c=custcode, Success__c=isSuccess, Error_Details__c=errorMessage, SalesforceId__c=salesforceId);
        }
    }
    global class SaveResult{
        String custcode {get;set;}      
        String name {get;set;} 
        boolean isSuccess {get;set;}
        String errorMessage{get;set;}
        String salesforceId {get;set;}
        public SaveResult(String custcode, String name, boolean isSuccess, String errorMessage, String salesforceId){
            this.custcode = custcode;
            this.name= name;
            this.isSuccess = isSuccess;
            this.errorMessage = errorMessage;
            this.salesforceId = salesforceId;
  
        }
        
        public SaveResult(String custcode, String name, Database.SaveResult saveResultRes){
            this.custcode= custcode;
            this.name = name;
            isSuccess = saveResultRes.isSuccess();
            salesforceId = saveResultRes.getId();
            String errorMesasge = '';
            for (Database.Error error : saveResultRes.getErrors()) {
                errorMesasge = errorMesasge + error.getMessage();
                
            }
            this.errorMessage = errorMesasge;
        }
        public String getCustcode() {
            return custcode;
        }
        public Boolean getisSuccess() {
            return isSuccess;
        }
        public String geterrorMessage() {
            return errorMessage;
        }
         public String getname() {
            return name;
        }
        
        public AIMSIntegrationLog__c getIntegrationLogs(){
            return new AIMSIntegrationLog__c(Name =name ,Customer_Number__c=custcode, Success__c=isSuccess, Error_Details__c=errorMessage, SalesforceId__c=salesforceId);
        }
    }
    
    
}