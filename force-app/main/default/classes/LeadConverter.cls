public virtual class LeadConverter{

	/***************************************************************
	* Custom Lead Class
	****************************************************************/	
	
	//Custom Lead Class
	public class c_Lead{
		
		//Attributes
		private Lead theLead;
		private Account theAccount;
		private List<Account> dupAccounts;
		private String AccountId = null;
		
		private Map<String,c_ContactLead> RelatedContacts;
		private List<c_ContactLead> RelatedContactValues;

		//Constructor
		public c_Lead(Lead l){
			
			this.theLead = l;
			this.theAccount = null;
			dupAccounts = new List<Account>();
			RelatedContacts =  new Map<String,c_ContactLead>();
			RelatedContactValues = new List<c_ContactLead>();
			
			String sPhone = getPhone(l);
			
			//Start Filling RelatedContacts List
			RelatedContacts.put(sPhone,new c_ContactLead(l));
		}

		//Getters & Setters
		public Lead getLead(){
			return this.theLead;	
		}
		
		public void setLead(Lead l){
			this.theLead = l;	
		}

		public Map<String,c_ContactLead> getRelatedContacts(){
			return this.RelatedContacts;				
		}

		public void setRelatedContacts(Map<String,c_ContactLead> rcs){
			this.RelatedContacts = rcs;				
		}

		//Fill array with Custom Contact Lead Objects
		public void addRelatedContacts(Lead l){

			String sPhone= getPhone(l);
			
			if(!RelatedContacts.containsKey(sPhone)){			
				RelatedContacts.put(sPhone,new c_ContactLead(l));	
			}else{
				RelatedContacts.get(sPhone).addRelatedLeads(l);
			}

		}
						
		public List<c_ContactLead> getRelatedContactValues(){
			return RelatedContacts.values();
		}

		public void setRelatedContactValues(List<c_ContactLead> x){
				this.RelatedContactValues = x;
		}


		//This leads are displayed in the select Account Screen, as Related Leads
		public List<Lead> getRelatedContactLeads(){
		
			List<lead> tempLeads = new List<Lead>();
			
			for(c_ContactLead c: RelatedContacts.values()){

				tempLeads.addAll(c.getRelatedLeads());	
			}
			return tempLeads;
		}

		public Account getAccount(){
			return this.theAccount;	
		}

		public void setAccount(Account a){
			
			//Now that we have set the account, look for Duplicate Contacts.
						
			for(Contact c: a.contacts){
			
				String sPhone = getPhone(c);
				if(sPhone != null){	
					if(RelatedContacts.containsKey(sPhone)){	
						RelatedContacts.get(sPhone).addDupContacts(c);	
					}
				}
			}
			this.theAccount = a;
		}

		public String getAccountId(){
			return this.AccountId;	
		}

		//Method used by the Select List to set Account Id, and to set theAccount object
		public void setAccountId(String s){
		
			if(s != 'newEntry'){
				this.AccountId = s;
				
				for(Account a: DupAccounts){
					if(a.id == s){
						this.setAccount(a);
					}	
				}
			}
		}

		
		public List<Account> getDupAccounts(){
			return this.dupAccounts;	
		}

		//Add duplicate Accounts to the Account List
		public void addDupAccounts(Account a){
			
			this.DupAccounts.add(a);
		}
								
		//Method that returns the select options to merge Accounts
		public List<SelectOption> getAccounts(){

			List<SelectOption> options = new List<SelectOption>();
				
			for(Account a: dupAccounts){
			
				String sAddress = a.BillingStreet==null?' ':' ['+a.BillingStreet+']';
				
				options.add(new SelectOption(a.id,'Merge to ['+a.name+'] '+sAddress+' Account'));
			}
				options.add(new SelectOption('newEntry','Create ['+theLead.company+'] Account'));
				
			return options;
		}				
					
		//Method used to know if an Account merge operation is available 
		public Boolean getHasMultipleAccounts(){
		
			if(this.DupAccounts.size() > 0)
				return true;
			else
				return false;	
		}

		//Method used to know if a Contact merge operation is available
		public Boolean getHasMultipleContacts(){
		
			Boolean hasMC = false;
			
			for(c_ContactLead x: RelatedContacts.values()){
				
				if(x.getDupContacts().size() > 0)
					hasMC = true;
			}
			
			return hasMC;
		}


		//Obtain available phone for a Lead			
		public String getPhone(Lead l){
			
			String sPhone= null;
			
			//Select a Phone from the lead to enter to the Map
			if(l.phone != null){
				sPhone = l.phone;
			}else if(l.fax!= null){
				sPhone = l.fax;
			}else if(l.mobilephone != null){
				sPhone = l.mobilephone;
			}else{
				//No phone was found
				//sPhone = l.id;
				sPhone='noPhone';	
			}
			
			return sPhone;		
		}
		
		//Obtain available phone for a Contact
		public String getPhone(Contact c){
			
			String sPhone= null;
			
			//Select a Phone from the Contact to enter to the Map
			if(c.phone != null){
				sPhone = c.phone;
			}else if(c.mobilephone != null){
				sPhone = c.mobilephone;
			}else if(c.homephone != null){
				sPhone = c.homephone;
			}else if(c.fax != null){
				sPhone = c.fax;
			}else if(c.otherphone != null){
				sPhone = c.otherphone;
			}
			
			return sPhone;			
		}

	}
	
	
	/***************************************************************
	* Custom Contact Lead Class
	****************************************************************/	
	
	//Inner class that encapsulates contacts
	public class c_ContactLead{
			
		//Attributes
		private List<Contact> dupContacts;
		private List<Lead> relatedLeads;
		private Lead theLead;
		private String ContactId = null;
		private Contact theContact;
		private Boolean leadProcessed;
		
		//Constructor
		public c_ContactLead(Lead l){

			this.theContact = null;	
			leadProcessed = false;	
			dupContacts = new List<Contact>();
			relatedLeads = new List<Lead>();
			theLead = l;
			
			//Start Filling relatedLeads List
			relatedLeads.add(l);

		}
		
		//Getters & Setters
		public Lead getLead(){
			return this.theLead;	
		}

		public void setLead(Lead l){
			this.theLead = l;
		}
				
		//Method used during conversion to treat entries that have the same values
		public Boolean getLeadProcessed(){
			return this.leadProcessed;	
		}
		
		public void setLeadProcessed(Boolean b){
			this.leadProcessed = b;	
		}
	
		
		public List<Contact> getDupContacts(){
			return this.dupContacts;	
		}

		public void setDupContacts(List<Contact> cs){
			this.dupContacts = cs;	
		}

		public void addDupContacts(Contact c){	
			dupContacts.add(c);
		}	
							
		public List<Lead> getRelatedLeads(){	
			return this.relatedLeads;	
		}
			
		public void setRelatedLeads(List<Lead> ls){		
			this.relatedLeads = ls;	
		}

		public void addRelatedLeads(Lead l){			
			relatedLeads.add(l);
		}

		public String getContactId(){
			return this.ContactId;	
		}

		public Contact getContact(){
			return this.theContact;	
		}

		public void setContact(Contact c){
			this.theContact = c;	
		}
							
				
		//Other Methods
		public Boolean getHasMultipleContacts(){	
			if(DupContacts.size()>0 )
				return true;
			else
				return false;		
		}

		//Method that returns the select options to merge Contacts	
		public List<SelectOption> getContacts(){

			List<SelectOption> options  = new List<SelectOption>();
			
			for(Contact con: DupContacts){
				
				options.add(new SelectOption(con.id,'Merge to ['+con.name+'] Contact'));
			}
			
			options.add(new SelectOption('newEntry','Create Contact(s)'));
			
			return options;
		}

		//Method used by the Select List to set Contact Id, and to set theContact object
		public void setContactId(String s){
   				
			if(s != 'newEntry'){				
				this.ContactId = s;
	
				for(Contact c: dupContacts){
					
					if(c.id == s){
						this.setContact(c);
					}	
				}
			}	
		}

	}
	
	/***************************************************************
	* Other Methods
	****************************************************************/
	
	public Boolean getAccountSelRedirect(List<c_Lead> cleads){
		
			for(c_Lead x: cleads){
				
				if(x.getHasMultipleAccounts())
					return true;
			}

		return false;
	}

	public Boolean getContactSelRedirect(List<c_Lead> cleads){
		
			for(c_Lead x: cleads){
				
				if(x.getHasMultipleContacts())
					return true;
			}
		
		return false;
	}
	
	//This method, first dedups the provided array, then looks for similar Entries in the system
	public List<c_Lead> CreateCustomLeadswAccounts(List<lead> leads){
		
		Map<String,c_Lead> cleads = new Map<String,c_Lead>();
		
		try{

			//Local Account DeDup
			cleads = AccountsLocalDeDup(leads);
			//Fill Duplicate Accounts
			cleads = getDupAccounts(cleads);
			
				
			return cleads.values();
		
		}catch(Exception e){

			ApexPages.addMessages(e);
			return null;
		}

	}
	
	private Map<String,c_Lead> AccountsLocalDeDup(List<lead> leads){

			Map<String,c_Lead> leadCompanies = new Map<String,c_Lead>();
			
			//Accounts Local Dedup
			for(lead l:leads){			
				if(!leadCompanies.containsKey((l.company).toLowerCase())){
					leadCompanies.put((l.company).toLowerCase(),new c_lead(l));
				}else{		
					//Other leads that have the same Account name, add them as related leads
					//NOTE: these leads might have different phone #s, therefore they must be treated differently
					//when creating the Custom Leads with contacts structure
					c_Lead tempCLead = leadCompanies.get((l.company).toLowerCase());
					tempCLead.addRelatedContacts(l);
					leadCompanies.put((l.company).toLowerCase(),tempCLead);		
				}
			}
			
			return leadCompanies;
					
	}

	private Map<String,c_Lead> getDupAccounts(Map<String,c_Lead> cleads){

		//Obtain match between Lead Company Name and a Account name in the system
		for(Account a:[select id,name,BillingStreet,(select id,name,phone,otherPhone,mobilephone,homephone,fax from Contacts limit 300)from Account where name in :cleads.KeySet() limit 300]){							
			c_Lead cL = cleads.get((a.name).toLowerCase());
			//Add options to merge
			cL.addDupAccounts(a);
			cleads.put((a.name).toLowerCase(),cL);						
		}

		return cleads;
	}
	
	public Boolean startConversion(List<c_Lead> cleads){

		//Create a savepoint to do a rollback if necessary
		Savepoint sp = Database.setSavepoint(); 
				
		try{
			
			//Initialize Variables		
			LeadStatus convertStatus = [select id,MasterLabel from LeadStatus where IsConverted = true limit 1];
			List<Database.LeadConvert> leadsToConvert = new List<Database.LeadConvert>();
			List<Database.LeadConvertResult> lConvertResults;
			List<Database.LeadConvertResult> lConvertResults2;
			List<Database.LeadConvert> leadsToConvertOther = new List<Database.LeadConvert>();
	
			Map<String,List<Lead>> tempLeads = new Map<String,List<Lead>>();

			
			Boolean bConversionSuccess = true;
									
				for(c_lead l : cleads){		
    		
					for(c_ContactLead x: l.getRelatedContactValues()){
						
						List<lead> tmp = new List<lead>();
								
						for(Lead z: x.getRelatedLeads()){
							
							Boolean skipAssignment = false;
							
							Database.LeadConvert lc = new database.LeadConvert();
							lc.setLeadId(z.id);
			
							//Set Account if there was a merge option specified by the user
							if(l.getAccount() != null){
								
								lc.setAccountId(l.getAccount().id);
								
								//Set Contact if there was a merge option specified by the user
								if(x.getContact() != null){
									lc.setContactId(x.getContact().id);
								}
								
								if(x.getRelatedLeads().size() > 1){
								
									if(!x.getLeadProcessed()){
										//Turn On Flag for first pass
										x.setLeadProcessed(true);

									}else{
										//Add Other Contacts to Map
										skipAssignment = true;										
									}
										tmp.add(z);
										tempLeads.put(x.getLead().id,tmp);
								}	
								
							}	
							//Will create new Account, we need to check if this Custom Lead has more than 1 Contacts
							else{
							
								if(x.getRelatedLeads().size() > 1){
								
									if(!x.getLeadProcessed()){
										//Turn On Flag for first pass
										x.setLeadProcessed(true);

									}else{
										//Add Other Contacts to Map
										skipAssignment = true;										
									}
										tmp.add(z);
										tempLeads.put(x.getLead().id,tmp);
										
								}	
								
							}

							if(!skipAssignment){
															
								//Set status as converted
								lc.setConvertedStatus(convertStatus.MasterLabel);
								
								//Create Project/Job depending on the type of lead.
								
								if(z.Lead_Source_Record_Type__c == 'Dodge Lead' || z.LeadSource == 'Dodge')
									lc.setDoNotCreateOpportunity(false);
								else
									lc.setDoNotCreateOpportunity(true);
								
								//Add LeadConvert to the List of LeadConverts
								leadsToConvert.add(lc);
								
							}
						
						}
						
						
					}
					
				}
			
			//Start Conversion
			lConvertResults = Database.convertLead(leadsToConvert);
			
	    	for(Database.LeadConvertResult lcr : lConvertResults){
	    		
				if(!lcr.isSuccess()){
					bConversionSuccess = false;
					Database.rollback(sp);
				}
	    	}
	    	
	    	//If first leads were converted successfully continue with other leads
	    	if(bConversionSuccess){

		    	for(Database.LeadConvertResult lcr : lConvertResults){
		    		
		    		if(tempLeads.containsKey(lcr.getLeadId())){
		    		
		    			Boolean skipFirst = true;
		    			Lead firstConvertedLead = new Lead();
		    			
						for(Lead x: tempLeads.get(lcr.getLeadId())){
						
							if(!skipFirst){
								
								Database.LeadConvert lc2 = new database.LeadConvert();
								lc2.setLeadId(x.id);
								lc2.setAccountId(lcr.getAccountId());
								
									//Handle duplicates that come from the same Data 
									if(x.name == firstConvertedLead.name && (x.phone == firstConvertedLead.phone || x.fax == firstConvertedLead.fax || x.mobilephone == firstConvertedLead.mobilephone)){
									
										lc2.setContactId(lcr.getContactId());
									}
									
								//Set status as converted
								lc2.setConvertedStatus(convertStatus.MasterLabel);
										
								//Create Project/Job depending on the type of lead.
										
								if(x.Lead_Source_Record_Type__c == 'Dodge Lead' || x.LeadSource == 'Dodge')
									lc2.setDoNotCreateOpportunity(false);
								else
									lc2.setDoNotCreateOpportunity(true);
									
								leadsToConvertOther.add(lc2);
								
							}else{
								skipFirst = false;
								firstConvertedLead = x;
							}
							
						}
						

		    		}
		    	}
		    	
			    //Continue Conversion
				lConvertResults2 = Database.convertLead(leadsToConvertOther);
				
		    	for(Database.LeadConvertResult lcr : lConvertResults2){
		    		
					if(!lcr.isSuccess()){
						bConversionSuccess = false;
						Database.rollback(sp);
					}
		    	} 		
	    	}
	    	
	    	return bConversionSuccess;
    							
		}catch(Exception e){
			
			Database.rollback(sp);
			ApexPages.addMessages(e);
			return false;
		}			

	}

}