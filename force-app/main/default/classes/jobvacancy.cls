public class jobvacancy {
    public tatabirla__c jobdetail(){
        tatabirla__c tata = new tatabirla__c ();
        tata.name = 'tata birla';
        tata.country__c = 'uk';
        insert tata;
        return tata;
    }
    public void role (tatabirla__c tata){
        namedmlobject__c dml = new namedmlobject__c();
        dml.name ='system management';
        dml.field__c = 'it';
        dml.tatabirla__c = tata.Id;
        insert dml;
        system.debug('the role is higher');
        
        
        
    }    
    
}