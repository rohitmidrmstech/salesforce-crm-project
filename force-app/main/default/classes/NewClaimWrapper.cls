public with sharing class NewClaimWrapper {
    @AuraEnabled
    public String year { get; set; }
    @AuraEnabled
    public String program { get; set; }
      @AuraEnabled
    public String selectedProgram { get; set; }
}