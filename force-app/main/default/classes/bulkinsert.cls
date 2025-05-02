public class bulkinsert {
    public void bulkrecordinsert(integer nooffrecord){
        integer start = 0;
        integer i;  
        
        
        list<candidate__c> lstcan = new list<candidate__c>() ;
        list<positions__c> lstpos = new list<positions__c>() ;
        list<job_application__c> lstjob = new list<job_application__c>() ;
        
        for(i = start ; i<=nooffrecord ; i++){
            candidate__c can = getcandidate(i);
            lstcan.add(can);
            positions__c pos = getposition(i);
            lstpos.add(pos);
            
        }
        insert lstcan;
        insert lstpos;
        
        for(Integer index = start; index <= nooffrecord; index++ ) {
            job_application__c Job = new job_application__c();
            job.Name = 'new application for job';
            job.Name = 'adminjob';
            
            Job.candidate__c = lstcan[index].Id;
            Job.position__c = lstpos[index].Id;
            lstJob.add(Job);
        }
        
        insert lstJob;
    }     
    public positions__c getposition(integer index){
        positions__c pos = new positions__c();
        pos.Name = 'developer position';
        pos.Name = 'first position';
        return pos;
    }      
    public candidate__c getcandidate  (integer index){
        candidate__c can = new candidate__c();
        can.Name = getname(index);
        return can;            
    } 
    public string getname(integer index){
        list<string> objname = new list<string>();
        objname.add('rushikesh gitte');
        objname.add('sameer shaikh');
        objname.add('nitesh shahapure');
        objname.add('omkar bainwad');
        //objname.add('velocity carporation');
        return objname[index];
        
    }
    /*public job_application__c getjobapplication(positions__c pos, candidate__c can){		//getJobapplication for postion

job_application__c Job = new job_application__c();
Job.positions__c = pos.Id;
Job.candidate__c = can.Id;
return Job;       


}*/
}