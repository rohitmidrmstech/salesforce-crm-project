public class ProgressBar {
    @AuraEnabled()
    public static Void getPickListvalues(){
       HelpCenter__c  pickval=[Select status__c from HelpCenter__c];
    }

}