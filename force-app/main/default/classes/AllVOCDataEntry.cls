public class AllVOCDataEntry{

/*
History:
* - VERSION  DEVELOPER NAME                  DATE            DETAIL FEATURES/CSR/TTP
    1.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
//11, 89, 105, 121, 172, 193, 239, 283 (300 - check against prod)

    public boolean showLead{get;set;}
    public boolean showContact{get;set;}
    public boolean showAccount{get;set;}  
    public List<Wrapper> wrapList{get;set;}
    public List<Wrapper> wrapListToDelete = new List<Wrapper>();
    public integer rIndex{get;set;}
    public List<ProDialogue_Input__c> existingVDEList{get;set;}
    public String parentName {get;set;}
    public String parentObject {get;set;}
    public String parentObjectName {get;set;}
    public String parentAccountId{get;set;}
    public String parentAccountName{get;set;}
    public String parentId{get;set;}
    public Account parentAccount{get;set;}
    public Contact parentContact{get;set;}
    public Lead parentLead{get;set;}
    public Event__c parentEvent{get;set;}
    
    public AllVOCDataEntry(ApexPages.StandardController sc)
    {     
        parentId = ApexPages.currentPage().getParameters().get('pid');
        
        String fieldName = '';
        if(parentId.startsWith('001'))
        {
            fieldName = 'Account__c';
            parentObject = 'Account';
            parentObjectName = 'Account';
        }
        else if(parentId.startsWith('003'))
        {
            fieldName = 'Contact__c';
            parentObject = 'Contact';
            parentObjectName = 'Contact';
        }
        else if(parentId.startsWith('a0k'))
        {
            fieldName = 'Event__c'; 
            parentObject = 'Event__c';
            parentObjectName = 'Event';
        }
        else if(parentId.startsWith('00Q'))
        {
            fieldName = 'Lead__c';  
            parentObject = 'Lead';
            parentObjectName = 'Lead';
        }
        String searchParent='';
    
        if(parentObject == 'Contact')
            searchParent = 'SELECT Name, Account.Name, MailingCountry, MailingState, MailingCity, AccountId, Id from '+parentObject+' WHERE Id=\''+parentId+'\' LIMIT 1';
        else if(parentObject == 'Event__c')
            searchParent = 'SELECT Name, Id, Information_Source__c, Country__c, State__c, Priority__c, City__c from '+parentObject+' WHERE Id=\''+parentId+'\' LIMIT 1';
                
        else if(parentObject == 'Lead')
            searchParent = 'SELECT id, Name, Country, State, City from '+parentObject+' WHERE Id=\''+parentId+'\' LIMIT 1';         
        else if(parentObject == 'Account')
            searchParent = 'SELECT id, Name, BillingCountry, BillingState, BillingCity from '+parentObject+' WHERE Id=\''+parentId+'\' LIMIT 1';
            
        if(parentObject=='Account')
        {
            parentAccount = Database.query(searchParent);
            parentName = parentAccount.Name;
        }
        else if(parentObject=='Contact')
        {
            parentContact = Database.query(searchParent);
            parentName = parentContact.Name;
            parentAccountName = parentContact.Account.Name;
            parentAccountId = parentContact.AccountId;
        }
        else if(parentObject=='Event__c')
        {
            parentEvent = Database.query(searchParent);
            parentName = parentEvent.Name;
        }
        else if(parentObject=='Lead')
        {
            parentLead = Database.query(searchParent);
            parentName = parentLead.Name;
        }
        
        System.debug('parentName :::'+parentName);
        String searchExpr;
        if(fieldName != null && fieldName != '')
        {
            //searchExpr = 'select Name, Summary__c, Event__r.Name, Account__c, Audience__c, Priority__c, Category__c, City__c, Contact__c, Meeting_Date__c, Country__c, Lead__c, Notes__c, Information_Source__c, State__c, Sub_Category__c from ProDialogue_Input__c where '+fieldName+'=\''+parentId+'\'';
            searchExpr = 'select Name, Summary__c, Event__r.Name, Account__c, Audience__c, Priority__c, Category__c, City__c, Contact__c, Meeting_Date__c, Country__c, Lead__c, Information_Source__c, State__c, Sub_Category__c from ProDialogue_Input__c where '+fieldName+'=\''+parentId+'\'';
            System.debug('searchExpr:::'+searchExpr);
            existingVDEList = Database.Query(searchExpr);
        }
       else
            existingVDEList = new List<ProDialogue_Input__c>();
        System.debug('existingVDEList :::'+existingVDEList );
        Integer rowCount = 0;
        wrapList = new List<Wrapper>();
    }

    public class Wrapper
    {
        public String selectedType{get;set;}
        public ProDialogue_Input__c VDE {get;set;}
        public Integer rowIndex {get;set;}
        public Boolean selected {get; set;}
    }
    
    public PageReference cancelCustom()
    {
        PageReference pref = null;
        if(parentId != null && parentId != '')
            pref = new PageReference('/a0f/o');
        
        return pref;
    }
    
    public void addRow()  
    {
    
        Wrapper uw = new Wrapper();
        if(parentObject=='Account')
        {
            uw.VDE = new ProDialogue_Input__c();
            uw.VDE.Account__c = parentId;
            uw.VDE.Country__c = parentAccount.BillingCountry;
            uw.VDE.State__c = parentAccount.BillingState;
            uw.VDE.City__c = parentAccount.BillingCity;
            uw.selectedType = 'Existing';
            uw.VDE.Meeting_Date__c = System.Today();
        }
        else if(parentObject=='Contact')
        {
            uw.VDE = new ProDialogue_Input__c();
            uw.VDE.Contact__c = parentId;
            uw.VDE.Account__c = parentAccountId;
            uw.VDE.Country__c = parentContact.MailingCountry;
            uw.VDE.State__c = parentContact.MailingState;
            uw.VDE.City__c = parentContact.MailingCity;
            uw.selectedType = 'Existing';
            uw.VDE.Meeting_Date__c = System.Today();
        }
        else if(parentObject=='Event__c')
        {
            uw.VDE = new ProDialogue_Input__c();
            uw.VDE.Event__c = parentId;
            uw.VDE.Country__c = parentEvent.Country__c;
            uw.VDE.State__c = parentEvent.State__c;
            uw.VDE.City__c = parentEvent.City__c;
            uw.VDE.Information_Source__c = parentEvent.Source__c;
            uw.VDE.Priority__c=parentEvent.Priority__c;
            uw.selectedType = 'Existing';
            uw.VDE.Meeting_Date__c = System.Today();
        }
        else if(parentObject=='Lead')
        {
            uw.VDE = new ProDialogue_Input__c();
            uw.VDE.Lead__c = parentId;
            uw.VDE.Country__c = parentLead.Country;
            uw.VDE.State__c = parentLead.State;
            uw.VDE.City__c = parentLead.City;
            uw.selectedType = 'Existing';
            uw.VDE.Meeting_Date__c = System.Today();
        }
        uw.rowIndex = wrapList.size();
        wrapList.add(uw);
    }

    public void copyRow()
    {
    
        System.debug('rIndex:::'+rIndex);
        try
        {
            Wrapper uw = new Wrapper();
            uw.selectedType = wrapList.get(rIndex).selectedType;
            uw.rowIndex = wrapList.size();
            uw.VDE = wrapList.get(rIndex).VDE.clone();
            uw.selected = false;
            wrapList.add(uw);
        }
        catch(System.Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
        }
        
    }
          
    public PageReference saveAll()
    {
    
        
        List<ProDialogue_Input__c> Vlist = new List<ProDialogue_Input__c>();
        
        for(Wrapper w : wraplist)
        {
            
            if (w.VDE.Meeting_Date__c == null) 
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Required Field Missing: Date Heard'));
                return null;
            }
            /*
            if((w.VDE.Notes__c == '' || w.VDE.Notes__c == null))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Notes in order to save the record.'));
                return null;
            }
            
            Vlist.add(w.VDE);
            */
        }
        /*
        try
        {
            if(Vlist.size() > 0)
            {
                insert Vlist;
                for(ProDialogue_Input__c v: Vlist)
                    existingVDEList.add(v);
                wrapList.clear();
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Saved.'));
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No records to Save.'));
            }
        }catch(System.Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        
        return null;
        //PageReference pageRef = new PageReference('/a0f/o');
        //return pageRef;
    }
    
    public PageReference saveAllAndClose()
    {
        
        List<ProDialogue_Input__c> Vlist = new List<ProDialogue_Input__c>();
        
        for(Wrapper w : wraplist)
        {
            
            if (w.VDE.Meeting_Date__c == null) 
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Required Field Missing: Date Heard'));
                return null;
            }
            /*
            if((w.VDE.Notes__c == '' || w.VDE.Notes__c == null))
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please enter Notes in order to save the record.'));
                return null;
            }
            
            Vlist.add(w.VDE);
        }
       
        try
        {
            if(Vlist.size() > 0)
            {
                insert Vlist;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Saved.'));
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'No records to Save.'));
                return null;
            }
        }catch(System.Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
       
        PageReference pref = null;
        if(parentId != null && parentId != ''){
            pref = new PageReference('/a0l/o');
        
            return pref;
        }
 
    return null;
    }
     */
    /*
    public void resetAll()
    {
        wrapList.clear();
        wrapList = new List<Wrapper>();
        Wrapper w = new Wrapper();
        w.rowIndex = wrapList.size();
        wrapList.add(w);
    }
    public PageReference resetAll2()
    {
        return(new PageReference('/apex/AllVOCDataEntry?pid='+parentId));
    }
    
    public void DeleteAll2()
    {
        //List<ProDialogue_Input__c> VlistToDelete = new List<ProDialogue_Input__c>();
        Integer counter = 0;
        try
        {
            for(integer i = 0; i < wrapList.size(); i++)
            {
                if(wrapList.get(i).selected)
                {
                    //VlistToDelete.add(wrapList.get(i).VDE);
                    //wrapList.remove(i);
                    counter = counter + 1;
                }
            }
            if(counter == 0)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select at least one row to remove.');
                ApexPages.addMessage(myMsg);
            }
            else
            {
                for(integer i = 0; i < wrapList.size(); i++)
                {
                    if(wrapList.get(i).selected)
                    {
                        //VlistToDelete.add(wrapList.get(i).VDE);
                        wrapList.remove(i);
                    }
                }
            }
            //if(VlistToDelete.size() > 0)
                //delete VlistToDelete;            
        }
        catch(System.Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }   

    public List<SelectOption> getSelectedTypeOptions() 
    {  
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('N/A','N/A'));
        options.add(new SelectOption('New','New'));
        options.add(new SelectOption('Existing','Existing'));
        return options;
    }

} */