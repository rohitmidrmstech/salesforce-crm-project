public class EventReportController 
{  
//    public List<Wrapper> wrapList{get;set;}
//    public List<Wrapper> wrapListToDelete = new List<Wrapper>();
//    public integer rIndex{get;set;}
//    public string conVal{get;set;}
//    public string leadVal{get;set;}
    public String searchItemAttendee{get;set;}
    public List<Lead> resultLeadSet{get;set;}
    public List<Contact> resultContactSet{get;set;}
    public Boolean showAddAttendees {get;set;}
    public Boolean showLeads {get;set;}
    public Boolean showContacts {get;set;}
    public Boolean showQuickCreate {get;set;}
    public List<leadWrapper> ldList {get;set;}
    public List<contactWrapper> conList {get;set;}
    public Lead quickCreatedLead {get;set;}
    public Event__c evt{get;set;}
    public List<Event_Attendee__c> addedAttendees{get;set;}
    public String eventId {get;set;}
    ApexPages.StandardController GstdController;
    public Set<Id> existingAttendeeIdSet {get;set;}
    public boolean displayPopup {get; set;}
    public Boolean showAddedAttendees{get; set;}
    public String eventBackMsg {get; set;}
    public PageReference closePopup() {
        displayPopup = false;
        try{
            insert quickCreatedLead;
            Event_Attendee__c temp = new Event_Attendee__c();
            temp.Name = quickCreatedLead.LastName+', '+ quickCreatedLead.FirstName;
            temp.Event__c = evt.Id;
            temp.Lead__c = quickCreatedLead.Id;
            insert temp;
            addedAttendees.add(temp);
            showAddedAttendees = true;
            showContacts = false;
            showLeads = false;
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Lead Created and saved as Attendee!','Lead Created and saved as Attendee!');
            ApexPages.addMessage(myMsg);
        }catch(System.Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
    }
    
    public PageReference cancelPopup() {
        displayPopup = false;
        //if(quickCreatedLead != null)
           // delete quickCreatedLead;
        return null;
    } 
    
    public void showPopup() {   
        quickCreatedLead = new Lead();
        displayPopup = true;    
    }
    
    public EventReportController(ApexPages.StandardController controller) 
    {
        addedAttendees = new List<Event_Attendee__c>();
        existingAttendeeIdSet = new Set<Id>();
        showAddedAttendees = false;
        eventId = ApexPages.CurrentPage().getParameters().get('id');
        eventBackMsg = '';

        if(eventId != '' && eventId != null)
        {
            Event__c t = [Select id, name from Event__c where Id =:eventId];
            if(t!=null)
                eventBackMsg = '<< Back to Event: '+t.Name;
            addedAttendees = [Select Id, Name, Account__r.Name, Contact__c, Contact__r.Name, Event__r.Name, Lead__c, Lead__r.Name from Event_Attendee__c where Event__c =: eventId];
        }
        
        System.debug('addedAttendees here1:::'+addedAttendees);
        
        for(Event_Attendee__c e: addedAttendees)
        {
            if(e.Contact__c != null)
                existingAttendeeIdSet.add(e.Contact__c);
            if(e.Lead__c != null)
                existingAttendeeIdSet.add(e.Lead__c);
        }
        if(existingAttendeeIdSet.size() > 0)
            showAddedAttendees = true;
        System.debug('In const existingAttendeeIdSet:::'+existingAttendeeIdSet);
        GstdController = controller;
        this.evt = (Event__c)GstdController.getRecord();
        showAddAttendees = false;
        showLeads = false;
        showContacts = false;
        resultLeadSet = new List<Lead>();
        resultContactSet = new List<Contact>();
        System.debug('resultLeadSet  ::>>'+resultLeadSet );
        System.debug('resultContactSet  ::>>'+resultContactSet );
        
        searchItemAttendee = '';
        //wrapList = new List<Wrapper>();
        //Wrapper w = new Wrapper();
        //w.rowIndex = wrapList.size();
        //wrapList.add(w);
    }
   /* public void changeContactInfo()
    {
        System.debug('conVal:::::::'+conVal);
        System.debug('rIndex:::::::'+rIndex);
        if(conVal != null)
        {
            List<Contact> lstCon = [Select Id, FirstName, LastName, Email from Contact where Id=:conVal];
            System.debug('contactList>>>>>'+lstCon);
            if(lstCon != null && lstCon.size() > 0)
            {
                system.debug('a:::'+wrapList.get(rIndex).currentContact);
                wrapList.get(rIndex).currentContact = lstCon.get(0);
            }
        }
        else
            wrapList.get(rIndex).currentContact = new Contact();
    }
    public void changeLeadInfo()
    {
        System.debug('leadVal:::::::'+leadVal);
        if(leadVal != null)
        {
            List<Lead> lstLead = [Select Id, FirstName, LastName, Email from Lead where Id =: leadVal];
            System.debug('leadList>>>>>>'+lstLead);
            if(lstLead != null && lstLead.size() > 0)
            {
                wrapList.get(rIndex).currentLead = lstLead.get(0);
            }
        }
        else
            wrapList.get(rIndex).currentLead = new Lead();
    }
    
    public void addAttendee()
    { 
        try
        {
            System.debug('wrapList.size:::'+wrapList.size());
            Wrapper uw = new Wrapper();
            uw.rowIndex = wrapList.size();
            wrapList.add(uw);   
        }
        catch(System.Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
        }
    }
    
    public void copyAttendee()
    {    
        Wrapper uw = new Wrapper();
        uw.rowIndex = wrapList.size();
        for(integer i = 0; i < wrapList.size(); i++)
        {
            if(i == rIndex)
            {
                uw = wrapList.get(i);
            }
        }
        wrapList.add(uw);    
    }
    
    public void removeAttendee()
    {
        for(integer i = 0; i < wrapList.size(); i++)
        {
            Wrapper uw = wrapList.get(i);
            System.debug('index::>>'+rIndex);
            if(uw.rowIndex == rIndex)
            {
                wrapListToDelete.add(wrapList.get(i));
                wrapList.remove(i);
                break;
            }
        }
    }
    
    public List<SelectOption> getitems()
    {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Add New Lead','Add New Lead'));
        options.add(new SelectOption('Add New Contact','Add New Contact'));
        options.add(new SelectOption('Add Existing Lead','Add Existing Lead'));
        options.add(new SelectOption('Add Existing Contact','Add Existing Contact'));
        return options;
    }
    
    public PageReference saveAll()
    {
        PageReference pr = GstdController.save();
        showAddAttendees = true;
        return null;
    }
    
    public PageReference saveClose()
    {
        PageReference pr = GstdController.save();
        return pr;
    }*/
    
    public PageReference searchAttendees()
    {
        
        ldList = new List<leadWrapper>();
        conList = new List<contactWrapper>();
        try
        {
            if(searchItemAttendee == '' || searchItemAttendee == null)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the search string.','Please enter the search string.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            String temp = searchItemAttendee+'*';
            List<List<sObject>> resultList = [FIND :temp IN ALL FIELDS RETURNING Lead(Id, FirstName, LastName, Company, Email, Country), Contact(Id, FirstName, LastName, Email, Account.Name, MailingCountry)];
            resultLeadSet = resultList.get(0);
            System.debug('resultLeadSet  ::::>>'+resultLeadSet );
            resultContactSet = resultList.get(1);
            
            if(resultLeadSet.size() == 0 && resultContactSet.size() == 0)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'No matching contacts or Leads found!!. If you want to create a new Lead, click the Quick Create button below.');
                ApexPages.addMessage(myMsg);
                showQuickCreate = true;
                showAddedAttendees = true;
                return null;
            }
            if(resultLeadSet.size() > 0)
            {
                showLeads = true;
                for(Lead l: resultLeadSet)
                {
                    if(!existingAttendeeIdSet.contains(l.Id))
                    {
                        leadWrapper lw = new leadWrapper();
                        lw.isChecked = false;
                        lw.ld = l;
                        lw.rIndex = ldList.size();
                        ldList.add(lw);
                    }
                }
            }
            else
            {
                showLeads = false;
            }
            if(resultContactSet.size() > 0)
            {
                showContacts = true;
                for(Contact c: resultContactSet)
                {
                    if(!existingAttendeeIdSet.contains(c.Id))
                    {
                        contactWrapper cw = new contactWrapper();
                        cw.isChecked = false;
                        cw.con = c;
                        cw.rIndex = conList.size();
                        conList.add(cw);
                    }
                }
            }
            else
            {
                showContacts = false;
            }
            showAddedAttendees = false;
            showQuickCreate = true;
            return null;
        }catch(System.Exception e)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }
    public PageReference addSelectedAsAttendees()
    {
        Event_Attendee__c temp;
        List<Event_Attendee__c> listToInsert = new List<Event_Attendee__c>();
        System.debug('In add method existingAttendeeIdSet:::'+existingAttendeeIdSet);
        System.debug('listToInsert:::'+listToInsert);
        
        if(ldList.size() > 0)
        {
            for(leadWrapper l: ldList)
            {
                if(l.isChecked && !existingAttendeeIdSet.contains(l.ld.Id))
                {
                    temp = new Event_Attendee__c();
                    temp.Name = l.ld.LastName +', '+ l.ld.FirstName;
                    temp.Lead__c = l.ld.Id;
                    temp.Event__c = evt.Id;
                    listToInsert.add(temp);
                    existingAttendeeIdSet.add(l.ld.Id);
                }
            }
        }
        if(conList.size() > 0)
        {
            for(contactWrapper c: conList)
            {
                if(c.isChecked && !existingAttendeeIdSet.contains(c.con.Id))
                {
                    temp = new Event_Attendee__c();
                    temp.Name = c.con.LastName +', '+ c.con.FirstName;
                    temp.Contact__c = c.con.Id;
                    temp.Account__c = c.con.AccountId;
                    temp.Event__c = evt.Id;
                    listToInsert.add(temp);
                    existingAttendeeIdSet.add(c.con.Id);
                }
            }
        }
        if(listToInsert.size() == 0)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info,'Either the selection is blank or selection is already added as attendee. Please select at least one new attendee to add.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        else try{
            if(listToInsert.size() > 0)
            {
                insert listToInsert;
                System.debug('listToInsert:::'+listToInsert);
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Attendees Saved!','Attendees Saved!');
                ApexPages.addMessage(myMsg);
            }
        }catch(System.Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        addedAttendees = [Select Id, Name, Account__r.Name, Contact__c, Contact__r.Name, Event__r.Name, Lead__c, Lead__r.Name from Event_Attendee__c where Event__c =: evt.Id];
        System.debug('addedAttendees:::'+addedAttendees);
        for(Event_Attendee__c e: addedAttendees)
        {
            if(e.Contact__c != null)
                existingAttendeeIdSet.add(e.Contact__c);
            if(e.Lead__c != null)
                existingAttendeeIdSet.add(e.Lead__c);
        }
        showAddedAttendees = true;
        return null;
    }
    /*public class Wrapper
    {
        public String selectedType{get;set;}
        public Event_Attendee__c attendee{get;set;}
        //public Account account{get;set;}
        public Contact currentContact {get;set;}
        public Lead currentLead {get;set;}
        public Integer rowIndex{get;set;}
        Wrapper()
        {
            attendee = new Event_Attendee__c();
            selectedType = 'Add New Lead';
        }
    }*/
    
    public class leadWrapper
    {
        public Lead ld {get;set;}
        public Boolean isChecked {get;set;}
        public Integer rIndex{get;set;}
    }
    
    public PageReference deleteAllExistingAttendees()
    {
        try{
            if(addedAttendees.size() > 0)
                delete addedAttendees;
        }catch(System.Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        return null;
    }
    
    public class contactWrapper
    {
        public Contact con {get;set;}
        public Boolean isChecked {get;set;}
        public Integer rIndex{get;set;}
    }
}