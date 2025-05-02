public class customobjectrecords {
    public void dmlsoql(){
        decimal count;
        list<positions__c>  canlist = new list<positions__c>();
        for(positions__c can :[SELECT Id, Name ,(SELECT Id, Name, amount__c FROM job_application__r) FROM positions__c]){
            count = 0; 
            for(job_application__c job : can.job_application__r ){
                count = count +job.amount__c;                                
            }
            can.sum__c= count;
            canlist.add(can);
            system.debug('total amount is =' + canlist.size());
        }
        update canlist;    
    }
}