public with sharing class Lead_Maintenance_Controller {

	//Public Attributes
	public ApexPages.StandardSetController setConLeads{get;set;}
	public Lead dummyLead{get;set;}
	public List<SelectOption> options{get; private set;}
	public String inputType{get;private set;}
	public String selop{get;set;}
	public Boolean bHasEntries{get;private set;}
	public Boolean bNoFieldSelected{get;private set;}
	public Boolean bSuccessUpdate{get;private set;}
	
	//Private Attributes
	private List<Lead> selleads;
	private String sCurrentSelectionLabel;
					
    //Constructor
    public Lead_Maintenance_Controller(ApexPages.StandardSetController controller) {
 
      	try{
   		
   			//Initialize Variables
   			inputType = 'None';
   			selop = 'None';
   			sCurrentSelectionLabel = '';
   			bNoFieldSelected = true;
   			bSuccessUpdate = false;
   			dummyLead = new Lead();
   			options = new List<SelectOption>();
   			selleads = new List<Lead>();
   			
	    	//Obtain selected leads from the previous step
	    	if(controller.getSelected().size() > 0){
	    		selleads = (List<Lead>)controller.getSelected();
	    	}
	    	
	 		//Get Fields
			initializeFieldOptions();
			
			//Verify if we have selected records
			if(selleads.size() > 0){
				bHasEntries = true;
				initializeSetCollections();
			}else{
				bHasEntries = false;
    		}
								
		}catch(Exception e){  		
			ApexPages.addMessages(e);
    	} 				 
    }

	//Initialize Standard Set Controller, new fields will need to be added here first
	public void initializeSetCollections(){

 			setConLeads = new ApexPages.StandardSetController(Database.getQueryLocator(
			[select id,
					name,
					fax,
					mobilephone,
					FirstName,
					LastName,
					company,
					leadsource,
					Territory_Manager__c,
					Notes__c,
					phone,
					Group__c,
					Group_Lead__c,
					Lead_Source_Record_Type__c,
					CreatedById
					from lead where id in :selleads order by leadsource,company,name]
			));
			
			//Set Standard Controller Set Size
			setConLeads.setPageSize(15);
			
	} 
	
	//Get a list of the selected leads	
    public List<lead> getSelectedLeads(){
    	
    	if(setConLeads != null)
    		return (List<lead>)setConLeads.getRecords();
    	else
    		return null;
    }
    
    
    //Initialize Field Optionos
    public void initializeFieldOptions(){

 		options.add(new SelectOption('None','-- None --'));	    	
 		options.add(new SelectOption('Group__c','Group'));
 		options.add(new SelectOption('Group_Lead__c','Group Lead')); 	
 		options.add(new SelectOption('Territory_Manager__c','Territory Manager'));	
 		options.add(new SelectOption('Notes__c','Notes'));
    }

	
	//This method is called when the SelectList has changed
	public void changeField(){

		//Reset InputType
		inputType = 'None';
		
		//Define which type of input will show in Page
		if(selop != 'None'){
			
			for(SelectOption selectedOpt:options){
				
				if(selop == selectedOpt.getValue()){
					sCurrentSelectionLabel = selectedOpt.getLabel();
					inputType = selectedOpt.getValue();
					bNoFieldSelected = false;
				}
			}

		}else{
			bNoFieldSelected = true;
		}
	}
	
	//Delete Records method
	public PageReference deleteRecords(){
		
		Savepoint sp = Database.setSavepoint();
		 
		try{
			
			if(selleads.size() > 0){
				delete selleads;
			}
			
			return new PageReference('/00Q/o');
		
		}catch(Exception e){
			
			Database.rollback(sp);
			ApexPages.addMessages(e);
			return null;
		}
	}
	
	//Update Records method
	public PageReference updateRecords(){

		Savepoint sp = Database.setSavepoint();
		bSuccessUpdate = false;
		
		try{
			
			if(selop != 'None'){
	
				List<Lead> lUpdateLeads = new List<Lead>();
					
				for(List<Lead> selLeads : [select id from Lead where id in :selleads]){
					lUpdateLeads.addAll(selLeads);
				}
				
				for(Lead l : lUpdateLeads){
					
					for(SelectOption selectedOpt:options){
						
						if(selop == selectedOpt.getValue()){
							if(dummyLead.get(selop)!=null){
								l.put(selop,dummyLead.get(selop));
							}else{
								l.put(selop,null);
							}
						}
					}
				}
				
				if(lUpdateLeads.size() > 0){
					update lUpdateLeads;
				}
				
				bSuccessUpdate = true;
				initializeSetCollections();
		    	ApexPages.Message successMsg = new ApexPages.Message(
		    	ApexPages.severity.CONFIRM,''+sCurrentSelectionLabel+' field has been updated for '+lUpdateLeads.size()+' selected records.');
		    	ApexPages.addMessage(successMsg);
    	
			}
			
			return null;
					
		}catch(Exception e){
			Database.rollback(sp);
			ApexPages.addMessages(e);
			return null;			
		}
	}
	
	//Dummy method used to avoid Refresh
    public void avoidRefresh(){}
}