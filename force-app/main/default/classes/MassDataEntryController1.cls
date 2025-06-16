// ==================================================================================
//   Object: MassDataEntryController1 
//   Company: Certainteed
//   Author: Mukesh Bhardwaj (Sales Optimizer)
//   Comments: Controller for the Mass Data Entry VF page
//
// ==================================================================================
//  Changes: 2012-06-08 Initial version.
//  Changes: 
//  Changes: 
// ==================================================================================
public with sharing class MassDataEntryController1 {


    public boolean showLead{get;set;}
    public boolean showContact{get;set;}
    public boolean showAccount{get;set;}  
    public List<Wrapper> wrapList{get;set;}
    public List<Wrapper> wrapListToDelete = new List<Wrapper>();
    public integer rIndex{get;set;}
    
    public MassDataEntryController1(ApexPages.StandardController sc)
    {      
        Integer rowCount = 0;
        wrapList = new List<Wrapper>();
        Wrapper w = new Wrapper();
        w.rowIndex = wrapList.size();
        wrapList.add(w);
    }

    public class Wrapper
    {
        public String selectedType{get;set;}
        public ProDialogue_Input__c VDE {get;set;}
        public Integer rowIndex {get;set;}
        public Boolean selected {get; set;}
     
        public Wrapper()
        {   
            VDE = new ProDialogue_Input__c();
            selected = false;
            selectedType = 'Existing';
        }
    }
    public void addRow()
    {
        Wrapper uw = new Wrapper();
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
            uw.VDE = wrapList.get(rIndex).VDE.clone(false,true,false,false);
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
                upsert Vlist;
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
                upsert Vlist;
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
       
        PageReference pageRef = new PageReference('/a0l/o');
        return pageRef;
    }
    
    public void resetAll()
    {
        wrapList = new List<Wrapper>();
        Wrapper w = new Wrapper();
        w.rowIndex = wrapList.size();
        wrapList.add(w);
    }
    
    public void DeleteAll2()
    {
        Integer counter = 0;
        try
        {
            for(integer i = 0; i < wrapList.size(); i++)
            {
                if(wrapList.get(i).selected)
                {
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
                        wrapList.remove(i);
                    }
                }
            }
                       
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
   public PageReference cancelCustom()
    {         
        PageReference pref = new PageReference('/a0f/o');
        return pref;
    }

}