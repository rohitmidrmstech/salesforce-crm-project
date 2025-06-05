public with sharing class NewEventController {

    public ProDialogue_Input__c VE{get;set;}
    public Event__c evt{get;set;}
    public List<Wrapper> wrapList{get;set;}
    public String cId {get;set;}
    public List<Wrapper> wrapListToDelete = new List<Wrapper>();
    public integer rIndex{get;set;}
    
    public NewEventController(ApexPages.StandardController sc)
    {      
        cId = ApexPages.currentPage().getParameters().get('Id');   
        Integer rowCount = 0;
        wrapList = new List<Wrapper>();
        Wrapper w = new Wrapper();
        w.rowIndex = wrapList.size();
        wrapList.add(w);
        if(cId != null && cId != ''){
            evt = new Event__c(Id=cId);
            evt = [Select c.Name, c.Audience__c, c.Priority__c, c.Country__c, 
                            c.State__c, c.OwnerId, c.City__c, c.Source__c, c.Meeting_Date__c, 
                            c.Meeting_Time__c, c.Id, c.Number_of_Contractors__c, c.Facilitator__c,
                            c.Number_of_Companies__c, c.Number_of_Hosts__c, c.Territory_Manager__c, c.Outside_Facilitator__c, c.Host_Distributor__c, c.Other_CT_Participants__c, c.CT_Sales_Personnel1__c, c.CT_Senior_Staff1__c, c.CT_Plant_Personnel1__c, c.Notes__c, (Select Id, Priority__c , Event__c, Category__c, Sub_Category__c,Notes__c From Voice_of_Customer__r) From Event__c c where Id=:cId];
        }else{
            evt = new Event__c();
             }
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
        
      try{         
        upsert evt;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Saved.'));
        if(wraplist != null && wraplist.size() > 0){   
        
        for(Wrapper w : wraplist)
        {    
           if(w.VDE.Priority__c != null || w.VDE.Category__c != null || w.VDE.Sub_Category__c != null || w.VDE.Notes__c != null){
           w.VDE.Event__c = evt.Id;
           Vlist.add(w.VDE);
          }
          
        }
        
            if(Vlist.size() > 0)
            {
                upsert Vlist;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Saved.'));
            }
           
          }
        }catch(System.Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
        }
        
       PageReference pageRef = new PageReference('/'+evt.Id);
        return pageRef;
    }
    
    public PageReference saveAllAndClose()
    {
        
        
        List<ProDialogue_Input__c> Vlist = new List<ProDialogue_Input__c>();
        
      try{         
        upsert evt;
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Saved.'));
        if(wraplist != null && wraplist.size() > 0){   
        
        for(Wrapper w : wraplist)
        {    
           if(w.VDE.Priority__c != null || w.VDE.Category__c != null || w.VDE.Sub_Category__c != null || w.VDE.Notes__c != null){
           w.VDE.Event__c = evt.Id;
           Vlist.add(w.VDE);
          }
          
        }
        
            if(Vlist.size() > 0)
            {
                upsert Vlist;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Saved.'));
            }
           
          }
        }catch(System.Exception e)
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
            return null;
       
        }
       
        PageReference pageRef = new PageReference('/apex/EventAttendee?id='+evt.Id);
        return pageRef;
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
   
}