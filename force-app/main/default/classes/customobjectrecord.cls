public class customobjectrecord {
    public void dmlsoql(){
        list<positions__c> poslist =[SELECT id,Name,total_sum__c, (Select id , name FROM job_application__r)FROM positions__c];
        list<job_application__c> joblist = new list<job_application__c>();
        for(positions__c pos : poslist){
            pos.total_sum__c = pos.job_application__r.size();
            
                } 
        update poslist;
        system.debug('size off can =' +poslist.size());
    }
}