public class listtoset {
    public void insertlisttoset(){                                      
        list<country__c> lstcountry = new list<country__c>();              
        
        Map<string , list<contact>> mapaccbycountry  = new Map<string , list<contact>>(); 
        list<contact> lstcon = new list<contact>();
        for(Account objacc : [SELECT ID ,(SELECT ID,MailingCountry FROM contacts) FROM Account]){
            mapaccbycountry  = new Map<string , list<contact>>();
            for(contact con : objacc.contacts){
                Boolean contains = mapaccbycountry.containskey(con.MailingCountry) ;
                // contains key is used to check whether the key is present in amp  or not 
                // the important method for map is put(key, value)
                // containskey(key)
                // keyset() keyvalue()
                
                if(contains){
                    /*list<Account> lstacc =  mapaccbycountry.get(objacc.BillingCountry);
lstacc.add(objacc);
mapaccbycountry.put(objacc.BillingCountry , lstacc);*/
                    //or method 
                    mapaccbycountry.get(con.MailingCountry).add(con);                                 
                    
                }
                else {
                    list<contact>  lstacc = new list<contact>();
                    lstacc.add(con);
                    mapaccbycountry.put(con.MailingCountry ,lstacc);
                    //or method
                    //  mapaccbycountry.put(con.MailingCountry,new list<contact> {con});                                                        
                }            
            } 
            for(string country : mapaccbycountry.keySet()){
                country__c objcon = getcountrycountobjget(country,mapaccbycountry.get(country).size(),objacc.id);
                lstcountry.add(objcon);
                
                
            }
        }
        insert lstcountry;
        system.debug('country = ' + lstcountry);
        
        // account objacc loop enda here
        
        
    }
    public country__c  getcountrycountobjget(string country ,integer size, id objaccid){
        country__c con = new country__c();
        con.Name = country;
        con.record_count__c = size;
        con.Account__c = objaccid;
        
        return con;
    }
    
    public void insertlist(){
        list<contact> lstacc = new list<contact>();
        list<Account> lstaccount = [select id ,Name,(select id ,Name FROM contacts)FROM Account];
        for(Account objacc : lstaccount){
            contact con = new contact(LastName = 'test', AccountId=objacc.Id);
            lstacc.add(con);
        }
        if(!lstacc.isEmpty()){
            insert lstacc;
        }
    }
    
    
    public void insertbulkrecord( integer nooffrecord){
        list<Account> lstaccount = new list<Account>();
        integer start = 0;
        integer i;
        for(i = start; i<=nooffrecord ; i++){
            Account objacc = new Account();
            objacc.Name = getname(i);
            objacc.AccountNumber = '343434';
            objacc.AnnualRevenue =4344.45;
            lstaccount.add(objacc);
            
        }
        insert lstaccount;
        
    }
    
    public string getname(integer index){
        list<string> lststr = new list<string>() ;
        lststr.add('trailhead');
        lststr.add('for developer');
        lststr.add('for admin');
        lststr.add('trailhead');
        string name = lststr[index];
        return name;      
    } 
    public void contactrecord(Account objacc){
        contact con = new contact() ;
        con.FirstName = objacc.Name + 'Account fetch';
        con.LastName = 'chormalle';
        con.AccountId =objacc.Id;
        insert con;                
    }
    
    
    public void Deletefromcon(){
        list<Account> lstacc = new list<Account>();
        for(Account con :[select id ,Name  FROM Account Where Name like 'kat']) {
            lstacc.add(con);
        }  
        delete lstacc;
        
    }
}