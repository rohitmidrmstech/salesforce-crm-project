public class SearchAll
{
/*
History:
* - VERSION  DEVELOPER NAME                  DATE            DETAIL FEATURES/CSR/TTP
    1.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
    public SearchAll(ApexPages.StandardController controller) {
        showLeads = false;
        showContacts = false;
        showAccounts = false;
        showEvents = false;
        resultLeadSet = new List<Lead>();
        resultContactSet = new List<Contact>();
        resultAccountSet = new List<Account>();
        resultEventSet = new List<Event__c>();
        searchString= '';
    }


    public String selectedRecord {get;set;}
    
    public void selectRecord()
    {
        System.debug('Calling selectRecord :::');
        //selectedRecord = System.currentPagereference().getParameters().get('conid');
        System.debug('selectedRecord :::'+System.currentPagereference().getParameters().get('conid'));
    }
    public PageReference doSearch() {
        try
        {
            if(searchString== '' || searchString== null)
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter the search string.','Please enter the search string.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            String temp = searchString+'*';
            List<List<sObject>> resultList = [FIND :temp IN ALL FIELDS RETURNING Lead(Id, FirstName, LastName, Company, Email, Country), Contact(Id, FirstName, LastName, Email, Account.Name, MailingCountry), Account(Id, Name, AccountNumber, AnnualRevenue, BillingStreet, BillingCity, BillingState, BillingCountry,   Account_Relationship_Level__c, Account_Type__c, Account_Sub_Type__c, SAP_ACCOUNT__c), Event__c(Id, Name, Audience__c, City__c, Country__c, Notes__c, State__c, Source__c, Meeting_Date__c)];
            resultLeadSet = resultList.get(0);
            resultContactSet = resultList.get(1);
            resultAccountSet = resultList.get(2);
            resultEventSet = resultList.get(3);
            
            if(resultLeadSet.size() == 0 && resultContactSet.size() == 0 && resultAccountSet.size() == 0 && resultEventSet.size() == 0 )
            {
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.Info, 'No matching Accounts, Contacts, Leads or Events found!!. If you want to create a new Lead, click the Quick Create button below.');
                ApexPages.addMessage(myMsg);
            }
            if(resultLeadSet.size() > 0)
                showLeads = true;
            if(resultContactSet.size() > 0)
                showContacts = true;
            if(resultAccountSet.size() > 0)
                showAccounts = true;
            if(resultEventSet.size() > 0)
                showEvents = true;
            showQuickCreate = true;
            showCreateVOC = true;
            return null;
        }catch(System.Exception e)
        {
            System.debug('Exception in Code:::'+e.getMessage());
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
    }


    public PageReference save() {
        //String selId = System.currentPagereference().getParameters().get('conid');
        String selId = ApexPages.CurrentPage().getParameters().get('conid');
        //String selId = selectedRecord;
        System.debug('selId:::'+selId);
        if(selectedRecord == '' || selectedRecord == null)
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select the record for which you would like to do the VOC Data Entry for.');
            ApexPages.addMessage(myMsg);
            return null;
        }
        PageReference pref = new PageReference('/apex/AllVOCDataEntry?pid='+selectedRecord);
        return pref.setRedirect(true);
    }


    public String objectName { get; set; }

    public String searchString{get;set;}
    public List<Lead> resultLeadSet{get;set;}
    public List<Contact> resultContactSet{get;set;}
    public List<Account> resultAccountSet{get;set;}
    public List<Event__c> resultEventSet{get;set;}
    public Boolean showCreateVOC {get;set;}
    public Boolean showAddAttendees {get;set;}
    public Boolean showLeads {get;set;}
    public Boolean showContacts {get;set;}
    public Boolean showAccounts {get;set;}
    public Boolean showEvents {get;set;}
    public Boolean showQuickCreate {get;set;}
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
            PageReference pref = new PageReference('/apex/AllVOCDataEntry?pid='+quickCreatedLead.Id);
            return pref.setRedirect(true);
        }catch(System.Exception e){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage(),e.getMessage());
            ApexPages.addMessage(myMsg);
            return null;
        }
        //return null;
    }
    
    public PageReference cancelPopup() {
        displayPopup = false;
        return null;
    } 
    
    public void showPopup() {   
        quickCreatedLead = new Lead();
        displayPopup = true;    
    }
     public PageReference newVoc()
    
    {
     PageReference pageRef = new PageReference('/apex/MassDataEntry2');
        return pageRef;
    }
    
*/
}