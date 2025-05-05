public class JOB1TriggerHandler {
    public static void createrecord(List<job1__c> lstjob){
        /*set<id> setjobid = new set<id>() ;
        for(job1__c jobs : lstjob){
            //if(!setjobid.isEmpty()) {
                setjobid.add(jobs.id);
                system.debug('set of id is '+setjobid );
            
        }       
        List<BOOK_CENTER__c> LstBook = new List<BOOK_CENTER__c>();
        for(job1__c jobs : [SELECT id ,Name,(SELECT id,Name FROM BOOK_CENTER__r)FROM job1__c WHERE Id IN :setjobid]){
            LstBook.add(new BOOK_CENTER__c(Name= jobs.Name ,job1__c = jobs.Id ) );
            system.debug('List of Book is '+LstBook );
            
            
        }
        insert LstBook;
*/
// New Comment on JobHandler.
    }
}