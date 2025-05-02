public class LeadQueable implements Queueable {
    public void Execute(QueueableContext context){
        List<Lead> LeadRecord = [SELECT Id ,LeadSource FROM Lead];
        for(Lead Leads :LeadRecord ){
            Leads.LeadSource= 'Web';
        }
        update LeadRecord;
    }
}