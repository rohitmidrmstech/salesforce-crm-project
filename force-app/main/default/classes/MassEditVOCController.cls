public class MassEditVOCController {
//3, 11, 40, 51, 65


    public List<Wrapper> wrapList{get;set;}
    public List<ProDialogue_Input__c> existingList{get;set;}
    public String parentId{get;set;}
    public String parentObject{get;set;}
    public class Wrapper
    {
        public ProDialogue_Input__c VDE {get;set;}
        public Boolean selected {get; set;}
    }
    public MassEditVOCController()
    {
        wrapList = new List<Wrapper>();
        parentId = ApexPages.currentPage().getParameters().get('pid');
        System.debug('parentId:::::'+parentId);
        String ids = ApexPages.currentPage().getParameters().get('ids');
        if(parentId != null && parentId != '')
        {
            if(parentId.startsWith('001'))
            {
                parentObject = 'Account';
            }
            else if(parentId.startsWith('003'))
            {
                parentObject = 'Contact';
            }
            else if(parentId.startsWith('a0g'))
            {
                parentObject = 'Event__c';
            }
            else if(parentId.startsWith('00Q'))
            {
                parentObject = 'Lead';
            }
        }
        List<String> idArray = ids.split(',');
        existingList = new List<ProDialogue_Input__c>();
        if(idArray.size() > 0)
            existingList = [Select Name, Summary__c, Event__r.Name, Account__c, Priority__c, Audience__c, Category__c, City__c, Contact__c, Meeting_Date__c, Country__c, Lead__c, Notes__c, Information_Source__c, State__c, Sub_Category__c from ProDialogue_Input__c where Id in :idArray];

    }
    public PageReference deleteAll2()
    {
        return null;
    }
    public PageReference saveAll()
    {
    
        if(existingList.size() > 0)
        {
            try
            {
               update existingList;
            }catch(System.Exception e)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
                return null;
            }
        }
        
        PageReference pref = null;
        if(parentId != null && parentId != '')
            pref = new PageReference('/'+parentId);
        
        else
        {
            pref = new PageReference('/a0f/o');
        }
        pref.setRedirect(true);
        return pref;
    }
    public PageReference saveAllAndClose()
    {
        return null;
    }
    public PageReference cancelCustom()
    {
        PageReference pref = null;
        System.debug('parentId>>>>'+parentId);
        if(parentId != null && parentId != '')
        {
            pref = new PageReference('/'+parentId);
            System.debug('pref:::::'+pref); 
        }   
        
        else
        {
            pref = new PageReference('/a0f/o');
        }
        pref.setRedirect(true);
        return pref;
    }

}