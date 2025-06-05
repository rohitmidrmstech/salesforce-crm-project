global class SendMassEmailBatchClass implements Database.Batchable<sObject>, Database.AllowsCallouts{
    String query;
    List<id> conIds = new List<id>();
    global SendMassEmailBatchClass(List<id> conIdsl)  {
        conIds = new List<id>();
        conIds.addAll(conIdsl);
        query = 'SELECT Id,Survey_Email_Sent__c,Survey_Sent_Date__c FROM Contact Where Id IN : conIds';
        system.debug('==========scope========'+conIds.size());
        system.debug('==========scope========'+query);
    }
    global Database.QueryLocator start(Database.BatchableContext BC){
        system.debug('==========scope========'+Database.getQueryLocator(query));
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext BC, List<Contact> scope){
        List<Contact> conList = new List<Contact>();
        system.debug('==========scope========'+scope);
        if(scope.size() > 0){
            for(Contact con : scope){
                con.Survey_Email_Sent__c = TRUE;
                con.Survey_Sent_Date__c = System.Today();  
                conList.add(con);
            }
            update conList;
        }
    }
    global void finish(Database.BatchableContext BC) {
    }
}