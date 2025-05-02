public class LeadbatchApex implements Database.Batchable<Sobject> {
    public database.QueryLocator start(Database.BatchableContext Bc){
        //string query ='SELECT ID ,LeadSource FROM Lead';
        return database.getQueryLocator('SELECT ID ,LeadSource FROM Lead');       
    }
    public void execute(database.BatchableContext BC , List<lead> LstLead){
        //List<Lead> ListLeadord= new List<Lead>();
        for(Lead LeadRecords : LstLead){
            LeadRecords.LeadSource = 'Web'; 
            //ListLeadord.add(LeadRecords);
        }
        update LstLead;
    }
    public void finish(database.BatchableContext BC){
                System.debug('Batch finished');

    }
    
}