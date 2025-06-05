public with sharing class GetListOfLeadsForCommHome {

    @AuraEnabled(cacheable=true)
    public static List<Lead> getLeadList(){
        List<Lead> fetchedLeads = new List<Lead>();
        List<Group> commQueueLst = [select Id from Group where  Type = 'Queue' AND NAME = 'Community Queue'];
        try {
            if(commQueueLst != NULL && commQueueLst.size()>0){
                //Lou Bui 04-30-2023 Added Address field to select statement.
                fetchedLeads = [SELECT ID, Name, Address,Status,CreatedDate FROM Lead WHERE OwnerId IN : commQueueLst AND IsConverted = false AND View_on_Community__c = true AND Status != 'Won' AND Status != 'Lost' ORDER BY CreatedDate DESC];
                //fetchedLeads = [SELECT Name, Company, State, Email, toLabel(Status), CreatedDate, Owner.NameOrAlias, IsUnreadByOwner, Id, RecordTypeId, LastModifiedDate, SystemModstamp, Owner.Id, OwnerId,Address FROM Lead WHERE OwnerId IN : commQueueLst AND IsConverted = false AND View_on_Community__c = true AND Status != 'Won' AND Status != 'Lost' ORDER BY CreatedDate DESC];
                //fetchedLeads = [Select Name,Company,Email,View_on_Community__c FROM Lead];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        return fetchedLeads;
    }

    @AuraEnabled
    public static String acceptLead(String recId){
        String resp;
        List<Lead> ldList = new List<Lead>();
        ldList = [Select Id,Name,OwnerId from Lead Where Id = : recId];
        if(ldList != NULL && ldList.size()>0){
            ldList[0].OwnerId = UserInfo.getUserId();
            try{
                update ldList;
                resp = 'Success';
            }catch (Exception e) {
                throw new AuraHandledException(e.getMessage());
            }
        }
        return resp;
    }

}