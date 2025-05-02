public class jBookCenterHandler {
    public static void countoffBook(List<BOOK_CENTER__c> lstBook,map<id,BOOK_CENTER__c> oldmap,Boolean isupdate){
        set<id> bookid = new set<id>() ;
        system.debug('lstbook ' + lstBook);
        for(BOOK_CENTER__c B1 : lstBook){
            if(isupdate){
                string oldid = oldmap.get(B1.Id).job1__c;            
                bookid.add(oldid) ;
                bookid.add(B1.job1__c); 
                system.debug('bookid is ' + oldid + ' ' + B1.job1__c);
                
            } else {
                bookid.add(B1.job1__c); 
                
            }
            
            
        }
        
        system.debug('setoff book id --->' + bookid );
        List<job1__c>Lstjob = new List<job1__c>();
        for(job1__c job : [SELECT id ,(SELECT id FROM BOOK_CENTER__r ) FROM job1__c WHERE Id IN :bookid]){
            
            job.Count_off_Book__c = job.BOOK_CENTER__r.size();  
            Lstjob.add(job);
            system.debug('Lstid  is ' +Lstjob );
            
            
        }
        if(!Lstjob.isempty()){
            update Lstjob;
            
        }
    }
}