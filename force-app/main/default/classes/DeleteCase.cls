global class DeleteCase implements Database.Batchable<sObject>
{
    global List<case> start(Database.BatchableContext BC)
    {
        List<case> clist = new List<case>();
        Group gp = [select Id, Name from Group where Type = 'Queue' and Name = 'Record Deletion'];
        //system.debug('===========gp==========='+ gp);
        List<case> tickets = [SELECT Id, OwnerId FROM Case where OwnerId =: gp.Id AND (RecordType.DeveloperName = 'SEMS_Service' OR RecordType.DeveloperName = 'SEMS_Quality' OR RecordType.DeveloperName = 'SEMS_Pricing' OR RecordType.DeveloperName = 'Manual_Quality_Entry_Case')];
        //system.debug('===========tickets==========='+ tickets);
        return tickets;
    }
    
    global void execute(Database.BatchableContext BC, List<Case> scope)
    {
        if(!scope.isEmpty()){
            delete scope;
        }
        
    }  
    global void finish(Database.BatchableContext BC)
    {
    }
}