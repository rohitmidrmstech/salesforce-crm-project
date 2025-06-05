public class ConvertLeads_Controller extends LeadConverter{

    //Attributes
    public ApexPages.StandardSetController setConLeads{get;set;}
            
    public Lead controllerLead;
    
    public List<Lead> AllSetLeads{get;set;} 
    public List<Lead> selleads;
    
    //Leads used for Group Actions
    public List<Lead> GALeads{get;set;} 
        
    public List<c_Lead> cLeads = new List<c_Lead>();
    public Boolean bConversionSuccess{get;set;}

    //Constructor
            
    public ConvertLeads_Controller(ApexPages.StandardSetController controller) {
 
        try{
        
            //Obtain Leads selected from the previous step
            selleads = (List<Lead>) controller.getSelected();
            
            //Lead object associated to the standard controller
            controllerLead = (Lead)controller.getRecord();
            
            refreshSetCollections();
        
            
        }catch(Exception e){        
            ApexPages.addMessages(e);
        }                
    }
    
    
    //----- Getters and Setters ------- 
    
    public void refreshSetCollections(){

            //Obtain different SetController for the different types of leads...
            setConLeads = new ApexPages.StandardSetController(Database.getQueryLocator(
            [select id,name,fax,mobilephone,FirstName,LastName,Duplicate_Lead__c,company,leadsource,Territory_Manager__c,Notes__c,phone,Lead_Source_Record_Type__c from lead where id in :selleads order by leadsource]
            ));
            
    }

    public List<lead> getAllLeads(ApexPages.StandardSetController l){
        
        AllSetLeads = new List<lead>();
        
        //Go to first page
        l.first();
        AllSetLeads.addAll((List<lead>)l.getRecords());
        
        //Continue adding records of the next sets
        while(l.getHasNext()){
            l.next();
            AllSetLeads.addAll((List<lead>)l.getRecords()); 
        }
        
        return AllSetLeads;
    }  
        
    public List<c_Lead> getCLeads(){
    
            return cLeads;
    }

    public void setCLeads(List<c_Lead> cls){
    
            cLeads = cls;
    }
 
     public List<lead> getSCLeads(){
    
            return (List<lead>)setConLeads.getRecords();
    }
          
    //Method that displays an Informational message for the select accounts page
    public void getAccountsMessage(){
    
        ApexPages.Message myMsg = new ApexPages.Message(
        ApexPages.severity.INFO,'<b>'+cLeads.size()+'</b> Accounts will be processed.<br>To avoid duplicate Accounts in the system, please verify if a <b>merge</b> operation is possible for the following entries.'
        );
        ApexPages.addMessage(myMsg);
    }
    
    //Method that displays an Informational message for the select contacts page
    public void getContactsMessage(){
    
        ApexPages.Message myMsg = new ApexPages.Message(
        ApexPages.severity.INFO,'To avoid duplicate Contacts in the system, please verify if a <b>merge</b> operation is possible for the following entries.'
        );
        ApexPages.addMessage(myMsg);
    }
    
    //Methods
    
    //----- Navigation Methods -------
    
    //Redirect to Dodge GA
    
    public pageReference GAPage(){
        GALeads = getAllLeads(setConLeads);
        return null;//Page.Marketing_Results_GA;
    }
       
    //Redirect to SelectLeads Page, setRedirect is set to TRUE to clear the context state
    public pageReference step0(){
    
        PageReference ref;// = Page.Marketing_Results_selectLeads;
        ref.setRedirect(true);
        return ref; 
    } 
    
    //Redirect to Summary Page
    public pageReference step1(){
        return null;//Page.Marketing_Results_convertLeads_summary; 
    } 
    
    //Redirect to Confirmation Page
    public PageReference continueFromSelectContacts(){
        return null;//Page.Marketing_Results_Start_Conversion;
    }
    
    //Redirect to Continue with the addition of Contacts to the Accounts,
    //Corresponding redirection takes place if no contacts will be merged
    public PageReference continueFromSelectAccounts(){
 
        try{

            //Redirect to the corresponding page (depends on whether the user need to specify a merge action)       
            if(getContactSelRedirect(cLeads)){
                return null;//Page.Marketing_Results_selectContacts;   
            }else{
                return null;//Page.Marketing_Results_Start_Conversion; 
            }
            
        }catch(Exception e){        
            ApexPages.addMessages(e);
            return null;
        }  
    }   

    //Start conversion process, this will take to the first step
    public PageReference startConversion(){

        try{

            List<lead> ALLConversionLeads = new List<lead>();
            
            ALLConversionLeads = [select id,name,fax,mobilephone,FirstName,LastName,Duplicate_Lead__c,company,leadsource,Territory_Manager__c,Notes__c,phone,Lead_Source_Record_Type__c from lead where id in :selleads];
            
            if(ALLConversionLeads.size() == 0){

                ApexPages.Message myMsg = new ApexPages.Message(
                ApexPages.severity.WARNING,'There are no Leads to Convert, please make a selection.');
                ApexPages.addMessage(myMsg);
                return null;            
                
            }else if(ALLConversionLeads.size() > 50){

                ApexPages.Message myMsg = new ApexPages.Message(
                ApexPages.severity.ERROR,'Only 50 Records can be processed in each Mass Conversion, please limit your selection.');
                ApexPages.addMessage(myMsg);                
                return null;
                                
            }else{
                
                Boolean bHasDuplicateLeads = false;
                for(Lead l : ALLConversionLeads){
                    
                    if(l.Duplicate_Lead__c){
                        bHasDuplicateLeads = true;
                        break;
                    }
                    
                }
        
                if(!bHasDuplicateLeads){
    
                    //Create a Custom Leads object map
                    cLeads = CreateCustomLeadswAccounts(ALLConversionLeads);
                    
                    //Redirect to the corresponding page (depends on whether the user need to specify a merge action)
                    
                    if(getAccountSelRedirect(cLeads)){
                        return null;// Page.Marketing_Results_selectAccounts;
                    }else{
                        return continueFromSelectAccounts();
                    }
                    
                }else{
                    ApexPages.Message myMsg = new ApexPages.Message(
                    ApexPages.severity.ERROR,'The current selection contains Leads marked as duplicates, please remove these leads from your selection.');
                    ApexPages.addMessage(myMsg);                
                    return null;                    
                }
            }
            
        }catch(Exception e){        
            ApexPages.addMessages(e);
            return null;
        }  
    }
    
    
    public PageReference convertLeads(){
    
        bConversionSuccess = startConversion(cLeads);
        return null;//Page.Marketing_Results_Conversion_Results;
        
    }
    
    //----- GROUP ACTION METHODS -------
        
 
     public PageReference saveGALeads(){
        
        try{    
            List<lead> leads = GALeads;
            
            for(lead l : leads){
            
                l.Territory_Manager__c = controllerLead.Territory_Manager__c;
                l.Notes__c = controllerLead.Notes__c;    
            }
            update leads;
            
            //Refresh Collections  because it will contain modified rows.
            refreshSetCollections();
            
            return null;//Page.Marketing_Results_convertLeads_summary;
        
        }catch(Exception e){        
            ApexPages.addMessages(e);
            return null;
        }       
    }
    
}