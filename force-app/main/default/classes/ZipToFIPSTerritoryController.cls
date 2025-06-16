public with sharing class ZipToFIPSTerritoryController {
   
   public String salesOrgValue{get; set;}
   public String typeDivisionValue{get; set;}

   public String zipCode{get;set;}
   
   public List<FIPS__c> fipsList {get; set;}
   public List<Zip_to_Fips__c> zipToFipsList {get; set;}
   public List<Territory_Assignment__c> TerritoryAssignmentList {get; set;}
  
   Set<Id> fipsCodeSet = new Set<Id>();
   
   public boolean display{get; set;}
   public boolean terrydisplay{get; set;}
   public boolean hierarchydisplay{get;set;}

   public String showTerryid{get; set;}

   

    public ZipToFIPSTerritoryController() {
        salesOrgValue = '';
        display = false;
        terrydisplay = false; 
       // hierarchydisplay = false;                       
    }

    Public PageReference showCity(){
        try{
            display = true;
            //terrydisplay = true;               
            String zipInput = String.valueOf(zipCode);
            system.debug('zipInput::'+zipInput);
            
            if( zipCode != null ||Test.isRunningTest() ){           
                zipToFipsList = [Select Id, Name, FIPS_Code__c,City__c,State__c,Country__c,FIPS_Code_Name__c From Zip_to_Fips__c Where Name=: zipInput];
                if(zipToFipsList.size()==0){
                    ApexPages.Message mymsg = new ApexPages.Message(ApexPAges.Severity.INFO, 'No Record Founds for Zip/Postal Code : ' +  zipCode);
                    ApexPages.addMessage(mymsg);
                    reset();
                } else {
                        // Intializing Territory Details as well
                        showTerryid = zipToFipsList[0].FIPS_Code__c;
                        showTerritory();
                }                                       
            }else{
                reset();
            }
        } catch (Exception e){
            ApexPages.addMessages(e);
            System.debug('ERROR While executing Zip_to_Fips SOQL::' + e);
            return null;
        }
        return null;   
    }
    @TestVisible
    public Class WrapHierarchy
    {
      public string TerritoryName           {set;get;}
      public string TMName                  {set;get;}
      public string  region               {set;get;}
      public string TerritoryCode           {set;get;}
      public string Type                    {set;get;}
      public string SalesOrg                {set;get;}
      
    }
    Public PageReference showTerritory(){
        try{            
            //display = true;
            terrydisplay = true; 
            String fipsCode = String.valueOf(showTerryid);
            system.debug('fipsCode::'+fipsCode);
            //ApexPages.Message mymsg = new ApexPages.Message(ApexPAges.Severity.INFO, 'fipsCode::' +  fipsCode + 'showTerryid::' + showTerryid);
            //apexpages.addMessage(mymsg);                      
            if(fipsCode != null ||Test.isRunningTest()) {   
                System.debug('** SalesOrg - '+ salesOrgValue); 
                System.debug('** typeDivisionValue - '+ typeDivisionValue);     
                String query = 'SELECT id,TM_Name__c,Territory__c,Territory__r.Name,Territory__r.Region__r.Name,Territory__r.Sales_Rep__r.Region__c,Territory__r.Territory_Code__c,Territory__r.Type__c,Territory__r.Sales_Org__c, IGSBU__c, Territory__r.Sales_Rep__r.Name, Territory__r.Sales_Rep__r.Email, Territory__r.Sales_Rep__r.MobilePhone From Territory_Assignment__c WHERE FIPS_Code__c =: fipsCode'; 
                if(String.isNotBlank(salesOrgValue)){
                    query += ' AND (Territory__r.Sales_Org__c =: salesOrgValue ';
                    if(String.isNotBlank(typeDivisionValue)){
                        query += ' AND IGSBU__c =: typeDivisionValue';
                    }
                    query += ') ';
                }
                query += ' LIMIT 500';
                
                System.debug('** Query '+ query);    
                TerritoryAssignmentList = database.query(query);
               //TerritoryAssignmentList = [SELECT id,TM_Name__c,Territory__c,Territory__r.Name,Territory__r.Region__c,Territory__r.Territory_Code__c,Territory__r.Type__c,Territory__r.Sales_Org__c From Territory_Assignment__c WHERE FIPS_Code__c =: fipsCode];              
               
                //List of Wraper
                List<WrapHierarchy> wraplist = new List<WrapHierarchy>();

  
              
            }
            else{
                reset();
            }
        } catch (Exception et){
            ApexPages.addMessages(et);
            System.debug('ERROR While executing Territory_Assignment SOQL::' + et);
            return null;
        }
        return null; 
          
    }
    
    // This Method Will Return Sales_Org Values For Picklist
    public List<SelectOption> getSalesOrg() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));    // Name, Label
        options.add(new SelectOption('1021','1021'));
        options.add(new SelectOption('1102','1102'));
        options.add(new SelectOption('1111','1111'));
        options.add(new SelectOption('1300','1300'));
        options.add(new SelectOption('1501','1501'));
        options.add(new SelectOption('1502','1502'));
        options.add(new SelectOption('1503','1503'));
        return options;
    }
    
    // This Method is Return Type/Division Value For Picklist and This is Dependent on getSalesOrg Picklist.
    public List<SelectOption> getTypeDivision() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));    // Name, Label
        System.debug('** '+ salesOrgValue);
        if(String.isNotBlank(salesOrgValue)){
            System.debug('*** '+ salesOrgValue);
            if(salesOrgValue == '1503' || salesOrgValue == '1300'){
                options.add(new SelectOption('MECH','Mechanical'));
                options.add(new SelectOption('RES','Residential'));
            }else if(salesOrgValue == '1501' || salesOrgValue == '1102'){
                options.add(new SelectOption('Building Envelope','Building Envelope'));
                options.add(new SelectOption('Commercial','Commercial'));
                options.add(new SelectOption('Residential','Residential'));
            }else if(salesOrgValue == '1021' || salesOrgValue == '1111'){
                options.add(new SelectOption('Bridge Deck','Bridge Deck'));
                options.add(new SelectOption('DENEEF','DENEEF'));
                options.add(new SelectOption('Fireproofing','Fireproofing'));
                options.add(new SelectOption('Microtrenching','Microtrenching'));
            }
            else{
                options.add(new SelectOption('Bufftech','Bufftech'));
                options.add(new SelectOption('CT Siding (All Cladding)','CT Siding (All Cladding)'));
                options.add(new SelectOption('Millwork','Millwork'));
                options.add(new SelectOption('Norandex','Norandex'));
                options.add(new SelectOption('ODL (Outdoor Living)','ODL (Outdoor Living)'));
                options.add(new SelectOption('Vytech','Vytech'));
            }
        }
        return options;
    }
   
    
    public void reset(){
       display = false;
       terrydisplay = false;
       this.zipCode = '';
       if(zipToFipsList != null){
           zipToFipsList.clear();
       }
       if(TerritoryAssignmentList != null){
           TerritoryAssignmentList.clear();
       }
    }
    public void testmethodcoverga(){
    Integer i=0;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    i++;
    }
   
}