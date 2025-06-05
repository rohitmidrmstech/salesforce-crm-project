public class OMContactController { 

    public boolean test = false;
    public String strURL = '';
    public String getLink(){
        
        String s = '';  
            if ( test )
                s = strURL;
            else
                s = ApexPages.currentPage().getHeaders().get('Host');
                
            String instance = 'cs0';
            if( s.contains('cs0')) { instance= 'cs0';}
            else if ( s.contains('cs1')) { instance= 'cs1';}
            else if ( s.contains('cs2')) { instance= 'cs2';}
            else if ( s.contains('cs3')) { instance= 'cs3';}
            else if ( s.contains('na0')) { instance= 'na0';}
            else if ( s.contains('na1')) { instance= 'na1';}
            else if ( s.contains('na2')) { instance= 'na2';}
            else if ( s.contains('na3')) { instance= 'na3';}
            else if ( s.contains('na4')) { instance= 'na4';}
            else if ( s.contains('na5')) { instance= 'na5';}
            else if ( s.contains('na6')) { instance= 'na6';}
        
        return instance;
    }

    public String searchText { get; set; }
    
   
    public List<ContactAcc> cAcct {
        get; set;   
    }

    public PageReference doSearchit() {
       return null;
    }
 
   public List<ContactAcc> getContactAcc() {
        if(searchText==null) searchText='Enter Name';
        String text = '%'+searchText+'%';
        List<ContactAcc> AllContacts = new List<ContactAcc>();
 
        for(Contact c:[ Select Contact.id,Contact.Title, Contact.Name, Contact.Function__c,Contact.Account.Name,
                        Contact.Account.phone ,Contact.Account.id,Contact.Account.BillingCity,Contact.Account.BillingState,
                        Contact.Account.BillingPostalCode, Contact.Account.BillingStreet,Contact.Account.Status__c  From Contact 
                        where function__c includes ('OM Contact','telemar') and Status__c = 'Active'
                        and Contact.Account.Status__c= 'Active' 
                        and Contact.Account.JDE_Hierarchy_Level__c in('4-Order For','5-Ship To') and Name like :text limit 999 ])
            {
            AllContacts.add(new ContactAcc(c));
            }
        return AllContacts;
    }
    
    public class ContactAcc {
        public Account account { get; private set; }
        public Contact contact { get; private set; }

        public ContactAcc(Contact a) {
            contact = a;
            account = new Account();
        }
    } 

}