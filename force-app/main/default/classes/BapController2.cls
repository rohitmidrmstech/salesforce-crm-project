// ==================================================================================
//    Name: BapController2
//    Company: SalesOptimizer
//    Author: Mukesh Bhardwaj 
//    Comments: Controller for manageBap and pdfBap pages. The original object was
//           called SEP and was subsequently renamed BAP but the client; this is
//           why the objects are all named "SEP" but the pages are called "BAP".
//           SEP = Strategic Execution Plan
//           BAP = Business Action Plan
// ==================================================================================
//  Changes: 2012-2-18 Initial version. Re-used whatever code could be from previous version
//           2013-05-06 Mohan Kumar: updated the code to display new structure such as
//                                   Actuals LY, Actuals CY, Forecast CY, Forecast NY.
//           2013-10-08 Mohan Kumar: show 5th column Current Plan Year’s ProRated for Mechanical accounts
// ==================================================================================
// Version History
// Gopi Ravoori Modified date March 02 2017
// CHG0438619/INC0373378 Goal date is in Date data type ,startdate/enddate in event object is DateTime date due to datatype mismatch calender is messup.It is fixed
// Earlier Event End date is Goladate+2 days,right now even enddate and goal date are same CHG0438619.

public class BapController2
{ 

    //Current BAP in question. Set to current record if existing otherwise created new.
    public SEP__c sep { get; set; }

    //Owner Name
    public String certainTeedName { get; set; }
    
    //Labels
    public String currentYearActualsLabel { get; set; }
    public String previousYearActualsLabel { get; set; }
    public String currentYearGoalsLabel { get; set; }
    public String nextYearGoalsLabel { get; set; }
    public String currentYearProrated {get;set;}
    
    //Display for Stratum Data records
    public List<StratumModelClass> stratumDataModelList {get;set;}
    private Map<Integer, StratumModelClass> stratumDataModelMap;
    private Map<String,Stratum_Data__c> stratumDataMap;
    
    private String recordTypeId; //for BAP Events

    //Display for Goals
    public List<GoalClass> goalModelList { get; set; }
    public List<GoalClass> goalModelListPdf { get; set; }
    
    //Identifies if it is a new mode or edit, Some fields are to be made read only if editing
    public Boolean isNew { get; set; }
    
    public list<BapObjectiveModel> quarterOneEvents { get; set; }
    public list<BapObjectiveModel> quarterTwoEvents { get; set; }
    public list<BapObjectiveModel> quarterThreeEvents { get; set; }
    public list<BapObjectiveModel> quarterFourEvents { get; set; }    
    
    public list<BapObjectiveModel> pdfQ1 { get; set; }
    public list<BapObjectiveModel> pdfQ2 { get; set; }
    public list<BapObjectiveModel> pdfQ3 { get; set; }
    public list<BapObjectiveModel> pdfQ4 { get; set; }
    public decimal totalValue1 { get; set; }
    public decimal totalValue2 { get; set; }
    public decimal totalValue3 { get; set; }
    public decimal totalValue4 { get; set; }
    public decimal totalValue5 { get; set; }
    public Boolean isMechanical {get;set;} 

    private Map<Integer, GoalClass> goalNumberMap = new Map<Integer, GoalClass>();
    private Map<Id, SEP_Goal__c> goalIdMap = new Map<Id, SEP_Goal__c>();
    private List<SEP_Goal__c> goalList = new List<SEP_Goal__c>();
    
    public Integer rIndex{get;set;}
    
    //Indicates whether the User has Read or Edit permission
    public Boolean isEditable { get; set; }
    public String retURL {get;set;}
    
    private String bpcsAccountID = '';
    
    public BapController2(ApexPages.StandardController controller)
    {
        Schema.DescribeSObjectResult accntSobj = Account.sObjectType.getDescribe();
        System.debug('SEP__c updateable: ' + accntSobj.isUpdateable());
        System.debug('SEP__c updateable: ' + accntSobj.isCreateable());
        Schema.DescribeSObjectResult bapSobj = SEP__c.sObjectType.getDescribe();
        System.debug('SEP__c updateable: ' + bapSobj.isUpdateable());
        System.debug('SEP__c updateable: ' + bapSobj.isCreateable());
        recordTypeId = [Select Id, Name From RecordType where SObjectType='Event' AND DeveloperName = 'SEP_Event'].Id;
        sep = (SEP__c)controller.getRecord();
        isEditable = false;
        isMechanical = false;
        
        if(sep.Id == null)
        {   
            isNew = true;
            sep = new SEP__c();                                                  
            String AccountId = apexPages.currentPage().getParameters().get('CF00NS0000000z2kO_lkid');    
            if(AccountId != null)
                sep.Account__c = AccountId; 
            String accountOwnerName = apexPages.currentPage().getParameters().get('param1');
            if(accountOwnerName != '')
                certainTeedName = accountOwnerName;
        }
        else 
        {
            isNew = false;
            sep = 
                [Select Id,
                        Name,
                        Account__c,
                        Account__r.OwnerId,
                        Account__r.Owner.Name,
                        Account__r.SAP_ACCOUNT__c, 
                        Account_Name__c,
                        Description__c, 
                        Year__c,
                        Stage__c,
                        Start_Date__c,
                        Notes__c,
                        End_Date__c,
                        Report_Year__c,
                        Territory_Mech_Resi__c, 
                        Account__r.Mechanical_Territory_User__r.Name 
                   From SEP__c 
                  Where Id = :sep.Id];
            certainTeedName = sep.Account__r.Owner.Name;
            if(sep.Territory_Mech_Resi__c == 'Mechanical'){
                certainTeedName = sep.Account__r.Mechanical_Territory_User__r.Name;
            }
            bpcsAccountID = sep.Account__r.SAP_ACCOUNT__c;
            
            System.debug('Old Record'+sep);
        }
        
        //query on account to identify the account is of a Mechanical type
        List<Account> accountRecord = [Select Id, Market_Class_Desc__c, SAP_ACCOUNT__c From Account Where Id =: sep.Account__c];
        
        if(accountRecord.size() > 0) {
            bpcsAccountID = accountRecord[0].SAP_ACCOUNT__c;
            if(accountRecord[0].Market_Class_Desc__c == 'MECH') isMechanical = true;
        }
        
        
        goalModelList = new List<GoalClass>();
        goalModelListPDF = new List<GoalClass>();
        
        if(!isNew)
            goalList = [Select Goal_Number1__c, Id, Name, SEP__c, Strategy__c, SepName__c From SEP_Goal__c Where SEP__c = :sep.Id Order by Goal_Number1__c ASC];
        
        for(SEP_Goal__c g : goalList)
        {
            goalIdMap.put(g.Id, g);
            GoalClass temp = new GoalClass();
            temp.rowIndex = (g.Goal_Number1__c == null ? 0 : (Integer)g.Goal_Number1__c) - 1;
            temp.sepGoal = g;
            goalNumberMap.put((g.Goal_Number1__c == null ? 0 : (Integer)g.Goal_Number1__c), temp);
            goalModelListPdf.add(temp);
        }
    
        GoalClass tempGClass;
        SEP_Goal__c sgTemp;
        for(Integer k = 1; k<=10 ; k++)
        {
            tempGClass = new GoalClass();
            if(goalNumberMap.containsKey(k))
                sgTemp = goalNumberMap.get(k).sepGoal;
            else
                sgTemp = new SEP_Goal__c(Goal_Number1__c=k, SepName__c='');
            tempGClass.rowIndex = goalModelList.size();
            tempGClass.sepGoal = sgTemp;
            goalModelList.add(tempGClass);
            goalNumberMap.put(k, tempGClass);
        }
        
        List<Event> goalEventsList = new List<Event>();
        //Query on Bap Events if existing BAP
        if(!isNew)
            goalEventsList = [SELECT Goal_Number__c, Action_Plan__c, Id, Description, RecordTypeId, Comments__c, WhatId, Subject, Goal_Date__c, Status__c FROM Event where WhatId in :goalIdMap.keySet() And Goal_Date__c != null ORDER BY Goal_Number__c ASC]; 
                               
       //Initionilization of all 4 quarters lists for Goal Events
        quarterOneEvents = new List<BapObjectiveModel>();                      
        quarterTwoEvents = new List<BapObjectiveModel>();                      
        quarterThreeEvents = new List<BapObjectiveModel>();                      
        quarterFourEvents = new List<BapObjectiveModel>();          
        BapObjectiveModel tempBAPObj ;
       //Initialization of all 4 quarter List for PDF 
        pdfQ1 = new list<BapObjectiveModel>();
        pdfQ2 = new list<BapObjectiveModel>();
        pdfQ3 = new list<BapObjectiveModel>();
        pdfQ4 = new list<BapObjectiveModel>();
        
        for(Event e : goalEventsList){
            if(e.Goal_Date__c.month() <= 3){
                tempBAPObj = new BapObjectiveModel();
                tempBAPObj.rowIndex = quarterOneEvents.size();
                tempBAPObj.evnt = e;
                quarterOneEvents.add(tempBAPObj);
            }
            if(e.Goal_Date__c.month() > 3 && e.Goal_Date__c.month() <= 6){
                tempBAPObj = new BapObjectiveModel();
                tempBAPObj.rowIndex = quarterTwoEvents.size();
                tempBAPObj.evnt = e;
                quarterTwoEvents.add(tempBAPObj);
            }
            if(e.Goal_Date__c.month() > 6 && e.Goal_Date__c.month() <= 9){
                tempBAPObj = new BapObjectiveModel();
                tempBAPObj.rowIndex = quarterThreeEvents.size();
                tempBAPObj.evnt = e;
                quarterThreeEvents.add(tempBAPObj);
            }
            if(e.Goal_Date__c.month() > 9){
                tempBAPObj = new BapObjectiveModel();
                tempBAPObj.rowIndex = quarterFourEvents.size();
                tempBAPObj.evnt = e;
                quarterFourEvents.add(tempBAPObj);
            }
        }
        
        System.debug('quarterOneEvents.size:::'+quarterOneEvents.size());
        System.debug('quarterTwoEvents.size:::'+quarterTwoEvents.size());
        System.debug('quarterThreeEvents.size:::'+quarterThreeEvents.size());
        System.debug('quarterFourEvents.size:::'+quarterFourEvents.size());
        
        pdfQ1.addAll(quarterOneEvents);
        pdfQ2.addAll(quarterTwoEvents);
        pdfQ3.addAll(quarterThreeEvents);
        pdfQ4.addAll(quarterFourEvents);
        
        //Display the 20 rows
        if(quarterOneEvents.size() < 20){
            for(integer k=0; k<20-quarterOneEvents.size(); k++){
                Event tempEvent = new Event(Status__c = 'Planning');       
                BapObjectiveModel bo = new BapObjectiveModel();
                bo.evnt = tempEvent;
                bo.rowIndex = quarterOneEvents.size();
                quarterOneEvents.add(bo);
            }
        }
        
        if(quarterTwoEvents.size() < 20){
            for(integer k=0; k<20-quarterTwoEvents.size(); k++){
                Event tempEvent = new Event(Status__c = 'Planning');       
                BapObjectiveModel bo = new BapObjectiveModel();
                bo.evnt = tempEvent;
                bo.rowIndex = quarterTwoEvents.size();
                quarterTwoEvents.add(bo);
            }
        }
        
        if(quarterThreeEvents.size() < 20){
            for(integer k=0; k<20-quarterThreeEvents.size(); k++){
                Event tempEvent = new Event(Status__c = 'Planning');       
                BapObjectiveModel bo = new BapObjectiveModel();
                bo.evnt = tempEvent;
                bo.rowIndex = quarterThreeEvents.size();
                quarterThreeEvents.add(bo);
            }
        }
        
        if(quarterFourEvents.size() < 20){
            for(integer k=0; k<20-quarterFourEvents.size(); k++){
                Event tempEvent = new Event(Status__c = 'Planning');       
                BapObjectiveModel bo = new BapObjectiveModel();
                bo.evnt = tempEvent;
                bo.rowIndex = quarterFourEvents.size();
                quarterFourEvents.add(bo);
            }
        }
        //Query for the Stratum Data records associated to the Account on the SEP and in the current year:-
        //Calling Stratum Data records function.            
        getStratumDataRecords();
    }//End Of Constructor    
    
    public void autoRun() {
        isEditable = false;
        List<UserRecordAccess> userAccess = [Select u.RecordId, u.MaxAccessLevel, u.HasReadAccess, u.HasEditAccess 
                                                From UserRecordAccess u 
                                                Where UserId = :Userinfo.getUserId() and RecordId =: sep.Account__c];
        System.debug('userAccess: '+userAccess);
        System.debug('isNew: '+isNew);
        if(userAccess.size() > 0) {
            if(isNew) {
                if(userAccess[0].HasReadAccess && userAccess[0].HasEditAccess) isEditable = true;
            } else {
                isEditable = userAccess[0].HasEditAccess;
            }
        } else isEditable = true;
        if(!isEditable) retURL = apexPages.currentPage().getParameters().get('retURL');
        System.debug('isEditable: '+isEditable);
    }

    //Get All The Existing Records of Stratum Data or create blank for new
    public void getStratumDataRecords()
    {
        String currentYear = '';
        String previousYear = '';
        String nextYear = '';
        //String next2Year = '';
        
        if (sep.Year__c != null)
        {
            currentYear = sep.Year__c;
            previousYear = String.valueOf(Integer.valueOf(currentYear) - 1);
            nextYear = String.valueOf(Integer.valueOf(currentYear) + 1);
            //next2Year = String.valueOf(Integer.valueOf(currentYear) + 2);
        }
        
        //Set the variables to be used for labels in the VF page:-
        previousYearActualsLabel = previousYear + ' Actuals';
        currentYearActualsLabel = currentYear + ' Actuals';
        currentYearGoalsLabel = currentYear + ' Goals';
        nextYearGoalsLabel = nextYear + ' Goals';  
        currentYearProrated = currentYear + ' Pro rated';

        List<Stratum_Data__c> existingSDList = new List<Stratum_Data__c>();
        List<AggregateResult> aggListStratumData = new List<AggregateResult>();
        
            
        
        stratumDataModelList =  new List<StratumModelClass>();
        stratumDataModelMap = new map<Integer, StratumModelClass>();
        StratumModelClass temp;
        StratumModelClass temp1;
        String prodClass = '';
        String year = '';
            
        if(isMechanical) {
            if(sep.Account__c != null && sep.Year__c != null)
            {
                aggListStratumData = [SELECT Product_Class__c pc, Year__c year, SUM(Gross_Sales_CY__c) ap, SUM(User_Target_Pounds_2YO__c) utp2Y,
                                        SUM(User_Target_Pounds_CY__c) utpCY, SUM(User_Target_Pounds_NY__c) utpNY FROM Stratum_Data__c
                                        WHERE Account_Name__c = :sep.Account__c AND Year__c IN (:currentYear, :previousYear) 
                                        GROUP BY Product_Class__c, Year__c ORDER BY Product_Class__c];
            }
            temp1 = new StratumModelClass(true);
            temp1.productClass = '11';
            temp1.label = 'TGT';
            stratumDataModelMap.put(1, temp1);
            
            temp1 = new StratumModelClass(true);
            temp1.productClass = '06';
            temp1.label = 'TGR';
            stratumDataModelMap.put(2, temp1);
            
            temp1 = new StratumModelClass(true);
            temp1.productClass = '74';
            temp1.label = 'SDW';
            stratumDataModelMap.put(3, temp1);
            
            temp1 = new StratumModelClass(true);
            temp1.productClass = '87';
            temp1.label = 'COM BD';
            stratumDataModelMap.put(4, temp1);
            
            temp1 = new StratumModelClass(true);
            temp1.productClass = '56';
            temp1.label = 'Ultra Duct Duct BD';
            stratumDataModelMap.put(5, temp1);
            
            temp1 = new StratumModelClass(true);
            temp1.productClass = '84';
            temp1.label = 'MBI';
            stratumDataModelMap.put(6, temp1);
            
            temp1 = new StratumModelClass(true);
            temp1.productClass = '86';
            temp1.label = 'CBI';
            stratumDataModelMap.put(7, temp1);
            
            temp1 = new StratumModelClass(true);
            temp1.productClass = '70';
            temp1.label = 'Univ. Blanket';
            stratumDataModelMap.put(8, temp1);
            
            temp1 = new StratumModelClass(true);
            temp1.productClass = 'Other';
            temp1.label = 'All Other';
            stratumDataModelMap.put(9, temp1);
            
            for(AggregateResult ar:aggListStratumData){
                prodClass = (String)ar.get('pc');
                year = (String)ar.get('year');
                if(prodClass == '11')                
                {
                    temp = stratumDataModelMap.get(1);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                    }
                    stratumDataModelMap.put(1,temp);
                } else if(prodClass == '06') {
                    temp = stratumDataModelMap.get(2);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                    }
                    stratumDataModelMap.put(2,temp);
                } else if(prodClass == '74') {
                    temp = stratumDataModelMap.get(3);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                    }
                    stratumDataModelMap.put(3,temp);
                } else if(prodClass == '87') {
                    temp = stratumDataModelMap.get(4);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                    }
                    stratumDataModelMap.put(4,temp);
                } else if(prodClass == '56') {
                    temp = stratumDataModelMap.get(5);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                    }
                    stratumDataModelMap.put(5,temp);
                } else if(prodClass == '84') {
                    temp = stratumDataModelMap.get(6);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                    }
                    stratumDataModelMap.put(6,temp);
                } else if(prodClass == '86') {
                    temp = stratumDataModelMap.get(7);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                    }
                    stratumDataModelMap.put(7,temp);
                } else if(prodClass == '70') {
                    temp = stratumDataModelMap.get(8);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                    }
                    stratumDataModelMap.put(8,temp);
                } else if(prodClass == '18' || prodClass == '51' || prodClass == '57' || prodClass == '66' || prodClass == '67' || prodClass == '69') {
                    temp = stratumDataModelMap.get(9);
                    if(year == previousYear)
                    {
                        Integer val1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value1 += val1;
                    }
                    else if(year == currentYear)
                    {
                        Integer val = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value2 += val;
                        val = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value3 += val;
                        if(prodClass != '18') temp.otherValue1 += val;
                        val = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                        temp.Value4 += val;
                        if(prodClass != '18') temp.otherValue2 += val;
                    }
                    stratumDataModelMap.put(9,temp);
                }
            }
        } else {
            if(sep.Account__c != null && sep.Year__c != null)
            {
                aggListStratumData = [SELECT Product_Class__c pc, Year__c year, SUM(Gross_Sales_CY__c) ap, SUM(User_Target_Pounds_2YO__c) utp2Y,
                                        SUM(User_Target_Pounds_CY__c) utpCY, SUM(User_Target_Pounds_NY__c) utpNY FROM Stratum_Data__c
                                        WHERE Account_Name__c = :sep.Account__c AND Year__c IN (:currentYear, :previousYear) 
                                        AND Product_Class__c IN ('78', '61', '64', '62') GROUP BY Product_Class__c, Year__c ORDER BY Product_Class__c];
            }
            temp1 = new StratumModelClass();
            temp1.productClass = '78';
            temp1.label = 'FGBI';
            stratumDataModelMap.put(1, temp1);
            
            temp1 = new StratumModelClass();
            temp1.productClass = '61';
            temp1.label = 'ISSP';
            stratumDataModelMap.put(2, temp1);
            
            temp1 = new StratumModelClass();
            temp1.productClass = '64';
            temp1.label = 'Optima';
            stratumDataModelMap.put(3, temp1);
            
            temp1 = new StratumModelClass();
            temp1.productClass = '62';
            temp1.label = 'Foam';
            stratumDataModelMap.put(4, temp1);
            
            //Set to true if previous years rcords are found
            Boolean previous78 = false;
            Boolean previous61 = false;
            Boolean previous64 = false;
            Boolean previous62 = false;
            
            //Set to true if current years rcords are found
            Boolean current78 = false;
            Boolean current61 = false;
            Boolean current64 = false;
            Boolean current62 = false;
            
            //Poulate the Stratum Model Map by checking for curent year and previous years, There may be a case when we have
            //previous years records but not current years records and vice versa
            // This condition is handled later in te code below
            for(AggregateResult ar:aggListStratumData){
                prodClass = (String)ar.get('pc');
                year = (String)ar.get('year');
                if(prodClass == '78')                
                {
                    temp = stratumDataModelMap.get(1);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        previous78 = true;
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                        //temp.Value4 = (Integer)((decimal)ar.get('utp2Y') != null && ar.get('utp2Y') !=''? (decimal)ar.get('utp2Y') :0);
                        current78 = true;
                    }
                    stratumDataModelMap.put(1,temp);
                }
            
                if(prodClass == '61')
                {
                    temp = stratumDataModelMap.get(2);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        previous61 = true;
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                        //temp.Value4 = (Integer)((decimal)ar.get('utp2Y') != null && ar.get('utp2Y')!= ''? (decimal)ar.get('utp2Y') :0);
                        current61 = true;
                    }
                    stratumDataModelMap.put(2,temp);
                }
                if(prodClass == '64')
                {
                    temp = stratumDataModelMap.get(3);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != '' ? (decimal)ar.get('ap') : 0);
                        previous64 = true;
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != '' ? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                        //temp.Value4 = (Integer)((decimal)ar.get('utp2Y') != null && ar.get('utp2Y')!= ''? (decimal)ar.get('utp2Y') :0);
                        current64 = true;
                    }
                    stratumDataModelMap.put(3,temp);
                }
                if(prodClass == '62')
                {
                    temp = stratumDataModelMap.get(4);
                    if(year == previousYear)
                    {
                        temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);previous62 = true;
                    }
                    else if(year == currentYear)
                    {
                        temp.Value2 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                        temp.Value3 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                        temp.Value4 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                        //temp.Value4 = (Integer)((decimal)ar.get('utp2Y') != null && ar.get('utp2Y')!= ''? (decimal)ar.get('utp2Y') :0);
                        current62 = true;
                    }
                    stratumDataModelMap.put(4,temp);
                } 
            }//End Of For Loop
            
            // There may be a case when we have previous years records but not current years records
            if(!current78) //Check if current year FGBI is missing, Add 0 if missing
            {
                temp = stratumDataModelMap.get(1);
                temp.Value2 = 0; 
                temp.Value3 = 0; 
                temp.Value4 = 0;
                stratumDataModelMap.put(1,temp);
            }
            if(!current61) //Check if current year ISSP is missing, Add 0 if missing
            {
                temp = stratumDataModelMap.get(2);
                temp.Value2 = 0; 
                temp.Value3 = 0; 
                temp.Value4 = 0;
                stratumDataModelMap.put(2,temp);
            }
            if(!current64) //Check if current year Optima is missing, Add 0 if missing
            {
                temp = stratumDataModelMap.get(3);
                temp.Value2 = 0; 
                temp.Value3 = 0; 
                temp.Value4 = 0;
                stratumDataModelMap.put(3,temp);
            }
            if(!current62) //Check if current year Foam is missing, Add 0 if missing
            {
                temp = stratumDataModelMap.get(4);
                temp.Value2 = 0; 
                temp.Value3 = 0; 
                temp.Value4 = 0;
                stratumDataModelMap.put(4,temp);
            }
            if(!previous78) //Check if previous year FGBI is missing, Add 0 if missing
            {
                temp = stratumDataModelMap.get(1);
                temp.Value1 = 0;
                stratumDataModelMap.put(1,temp);
            }
            if(!previous61) //Check if previous year ISSP is missing, Add 0 if missing
            {
                temp = stratumDataModelMap.get(2);
                temp.Value1 = 0;
                stratumDataModelMap.put(2,temp);
            }
            if(!previous64) //Check if previous year Optima is missing, Add 0 if missing
            {
                temp = stratumDataModelMap.get(3);
                temp.Value1 = 0;
                stratumDataModelMap.put(3,temp);
            }
            if(!previous62) //Check if previous year Foam is missing, Add 0 if missing
            {
                temp = stratumDataModelMap.get(4);
                temp.Value1 = 0;
                stratumDataModelMap.put(4,temp);
            }
        }
        //Populate the list from the Stratum data model map 
        stratumDataModelList = stratumDataModelMap.values();
        
        // Sort it!
        if(!isMechanical) stratumDataModelList = sortByProductClass(stratumDataModelList);
        
        //Calculate Totals
        calculateTotals(stratumDataModelList);
    }
    //Cloning Process
    public pageReference cloneBap() {
        SEP__c selectedSep;        
        if(sep.Id != null) {
            list<SEP__c> sepList = [Select s.Year__c, s.Start_Date__c, 
                                        s.Stage__c, s.Notes__c, 
                                        s.Name, s.Map_Funds__c, s.Estimated_Fund_For_CY__c, s.Id, 
                                        s.End_Date__c, s.Description__c, 
                                        s.Account__c, s.Territory_Mech_Resi__c 
                                        From SEP__c s Where Id =: sep.Id];
            if(sepList.size() > 0) {
                selectedSep = new SEP__c();
                selectedSep.Stage__c = sepList[0].Stage__c;
                selectedSep.Start_Date__c = sepList[0].Start_Date__c.addYears(1);
                selectedSep.End_Date__c = sepList[0].End_Date__c.addYears(1);
                selectedSep.Description__c = sepList[0].Description__c;
                selectedSep.Account__c = sepList[0].Account__c;
                selectedSep.Year__c = String.valueOf(Integer.valueOf(sepList[0].Year__c) + 1);
                selectedSep.Map_Funds__c = sepList[0].Map_Funds__c;
                selectedSep.Notes__c = sepList[0].Notes__c;
                selectedSep.Territory_Mech_Resi__c = sepList[0].Territory_Mech_Resi__c ;
            }     
            try{
                upsert selectedSep; //DML on Bap Record.
                stratumDataPreparation(true);
            }catch(Exception ex){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error inserting BAP: '+ex.getMessage())); 
                return null;   
            }
            List<SEP_Goal__c> selectedGoals = new List<SEP_Goal__c>();
            List<SEP_Goal__c> oldGoals = new List<SEP_Goal__c>();
            oldGoals = [Select Id, SepName__c, Name, SEP__c, Goal_Number1__c, Strategy__c,Start_Date__c,End_Date__c,Stage__c From SEP_Goal__c Where SEP__c = :sep.Id];
            Set<String> goalId = new Set<String>(); // This Set contains the Goal Ids.
            Map<String, String> goalIdMap = new map<String,String>();
            SEP_Goal__c selectedGoal;
            for(SEP_Goal__c oldGoal:oldGoals){
                selectedGoal = new SEP_Goal__c();
                selectedGoal.Name = oldGoal.SepName__c;
                selectedGoal.SepName__c = oldGoal.SepName__c;
                //selectedGoal.Goal_Number__c = oldGoal.Goal_Number__c;
                selectedGoal.Goal_Number1__c = oldGoal.Goal_Number1__c;
                selectedGoal.Old_Gaol_Id__c = oldGoal.Id;
                selectedGoal.SEP__c = selectedSep.Id;
                selectedGoal.Strategy__c = oldGoal.Strategy__c;
                selectedGoal.Start_Date__c = selectedSep.Start_Date__c;  //Set Bap Start date
                selectedGoal.End_Date__c = selectedSep.End_Date__c;      //Set Bap End date
                selectedGoal.Stage__c = oldGoal.Stage__c;
                selectedGoals.add(selectedGoal);
                goalId.add(oldGoal.Id);
            }
            try{
                upsert selectedGoals;
                for(SEP_Goal__c newGoal:selectedGoals){
                    goalIdMap.put(newGoal.Old_Gaol_Id__c , newGoal.Id);  //This MAp Contains Old Gaol ID and New Goal ID.
                }
            }catch(Exception e){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error inserting Goals: '+e.getMessage()));   
                return null;     
            }            

            List<Event> selectedEvents = new List<Event>();
            List<Event> oldEventList = new List<Event>();
            
            if(!goalId.isEmpty()){
                oldEventList =[SELECT AccountId,Goal_Number__c,Action_Plan__c,Id,Description,EndDateTime,
                                RecordTypeId,Comments__c,WhatId,SEP_activity__c,                                 
                                Subject,StartDateTime,Goal_Date__c, State__c, Status__c 
                                FROM Event where WhatId in:goalId And Goal_Date__c != null];

                for(Event oldEvent :oldEventList){
                    Event newEvent = new Event();
                    newEvent.Goal_Number__c =  oldEvent.Goal_Number__c;
                    newEvent.Action_Plan__c = oldEvent.Action_Plan__c;
                    newEvent.Description = oldEvent.Description;
                    newEvent.Goal_Date__c = oldEvent.Goal_Date__c.addYears(1);
                    newEvent.StartDateTime = newEvent.Goal_Date__c.addYears(1);
                    newEvent.EndDateTime = newEvent.Goal_Date__c.addYears(1);
                    newEvent.Subject = oldEvent.Subject;     
                    newEvent.Action_Plan__c = oldEvent.Action_Plan__c;              
                    newEvent.State__c = oldEvent.State__c;
                    newEvent.Status__c = oldEvent.Status__c;
                    newEvent.Comments__c = oldEvent.Comments__c;

                    if(goalIdMap.containsKey(oldEvent.WhatId))
                        newEvent.WhatId  = goalIdMap.get(oldEvent.WhatId);
                    selectedEvents.add(newEvent);         
                }                       
            }
            try{
                if(selectedEvents.size() > 0)
                    upsert selectedEvents;
            }Catch(Exception e){
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error inserting Objectives: '+e.getMessage()));   
                return null;         
            }
        }
        pageReference pg = new pageReference('/apex/manageBap2?id='+selectedSep.Id);
        pg.setRedirect(true);
        return pg;
    }//end of Clone Method
    

    public list<BapObjectiveModel> sortCustomDesc(list<BapObjectiveModel> QuaterList)
    {
        map<integer, BapObjectiveModel> sortMap = new map<integer, BapObjectiveModel>();
        list<BapObjectiveModel> resultList = new list<BapObjectiveModel>();
        for(BapObjectiveModel m : QuaterList)
        {                    
            sortMap.put(m.rowIndex, m);                   
            
        }
        list<integer> keys = new list<integer>(sortMap.keySet());
        keys.sort();
        for (Integer i = keys.size() - 1; i >= 0; i--)                
        {
            resultList.add(sortMap.get(keys[i]));
        }
        return resultList;
    }
    
  
    public list<BapObjectiveModel> sortCustomAsc(list<BapObjectiveModel> QuaterList)
    {
        map<integer, BapObjectiveModel> sortMap = new map<integer, BapObjectiveModel>();
        list<BapObjectiveModel> resultList = new list<BapObjectiveModel>();
        for(BapObjectiveModel m : QuaterList)
        {                    
            sortMap.put(m.rowIndex, m);                    
            
        }
        list<integer> keys = new list<integer>(sortMap.keySet());
        keys.sort();        
                 
        for (Integer i = 0; i < keys.size(); i++)        
        {
            resultList.add(sortMap.get(keys[i]));
        }
        return resultList;
    }
    
    
    // Sort the product class list consistently.
    public list<StratumModelClass> sortByProductClass(list<StratumModelClass> classes)
    {
        map<String, StratumModelClass> sortMap = new map<String, StratumModelClass>();
        list<StratumModelClass> resultList = new list<StratumModelClass>();
        for (StratumModelClass m : classes)
        {                    
            sortMap.put(m.label, m);                 
        }
        list<String> keys = new list<String>(sortMap.keySet());
        keys.sort();
        for (Integer i = 0; i < keys.size(); i++)        
        {
            resultList.add(sortMap.get(keys[i]));
        }
        return resultList;
    }
        
   
    public void setHeadingsAccordingToYear(){}
    
    public PageReference setHeadingsAccordingToYear2(){
        if(sep.Account__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Please select an account'));
            return null;
        }
        //as soon as the user selected the Account check if the user has write permission on the selected account allow the him/her to add new BAP
        autoRun();
        if(isNew && !isEditable) return null;
        
        if(sep.Year__c == null || sep.Year__c == ''){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Please enter a Plan Year'));
            return null;
        }
        if(sep.Year__c.trim().length() < 4 || sep.Year__c.trim().length() > 4){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Please enter a valid 4-digit Plan Year (e.g. 2012)'));
            return null;
        }
        
        
        //Set labels
        previousYearActualsLabel = String.valueOf(Integer.valueOf(sep.Year__c) - 1) + ' Actuals';
        currentYearActualsLabel = sep.Year__c + ' Actuals';
        currentYearGoalsLabel = sep.Year__c + ' Goals';
        nextYearGoalsLabel = String.valueOf(Integer.valueOf(sep.Year__c) + 1) +' Goals'; 
        currentYearProrated = sep.Year__c + ' Pro rated';

        //Validate that there is only one BAP for an Account and Year.
        List<SEP__c> sepList = new List<SEP__c>();
        sepList = [Select Id, Year__c, Account__c, Name, Territory_Mech_Resi__c From SEP__c Where Account__c = :sep.Account__c AND Year__c =: sep.Year__c];
        if(sepList.size() > 0){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Sorry, but an BAP for the selected Account and Year already exists.'));
            return null;
        }
        if(isMechanical) isMechanical = false;
        Account acc = [Select id ,name,OwnerId,Owner.Name, Market_Class_Desc__c, SAP_ACCOUNT__c, Mechanical_Territory_User__r.Name From Account  Where Id =:sep.Account__c];
        if(acc.Market_Class_Desc__c == 'MECH') isMechanical = true;
        certainTeedName = acc.Owner.Name; 
        if(sep.Territory_Mech_Resi__c == 'Mechanical'){
            certainTeedName = acc.Mechanical_Territory_User__r.Name;
        }
        bpcsAccountID = acc.SAP_ACCOUNT__c;
        getStratumDataRecords();
        return null;
    }//End of Set Headings method
    
    public PageReference getTMnamefromTerritory(){
        if(sep.Account__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Please select an account'));
            return null;
        }
        //as soon as the user selected the Account check if the user has write permission on the selected account allow the him/her to add new BAP
        autoRun();
        if(isNew && !isEditable) return null;
        
        if(sep.Year__c == null || sep.Year__c == ''){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Info, 'Please enter a Plan Year'));
            return null;
        }
        if(sep.Year__c.trim().length() < 4 || sep.Year__c.trim().length() > 4){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Please enter a valid 4-digit Plan Year (e.g. 2012)'));
            return null;
        }
        
        
        //Set labels
        previousYearActualsLabel = String.valueOf(Integer.valueOf(sep.Year__c) - 1) + ' Actuals';
        currentYearActualsLabel = sep.Year__c + ' Actuals';
        currentYearGoalsLabel = sep.Year__c + ' Goals';
        nextYearGoalsLabel = String.valueOf(Integer.valueOf(sep.Year__c) + 1) +' Goals'; 
        currentYearProrated = sep.Year__c + ' Pro rated';

        //Validate that there is only one BAP for an Account and Year.
        List<SEP__c> sepList = new List<SEP__c>();
        sepList = [Select Id, Year__c, Account__c, Name, Territory_Mech_Resi__c From SEP__c Where Account__c = :sep.Account__c AND Year__c =: sep.Year__c];
        //if(sepList.size() > 0){
            //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Sorry, but an BAP for the selected Account and Year already exists.'));
            //return null;
        //}
        if(isMechanical) isMechanical = false;
        Account acc = [Select id ,name,OwnerId,Owner.Name, Market_Class_Desc__c, SAP_ACCOUNT__c, Mechanical_Territory_User__r.Name From Account  Where Id =:sep.Account__c];
        if(acc.Market_Class_Desc__c == 'MECH') isMechanical = true;
        certainTeedName = acc.Owner.Name; 
        if(sep.Territory_Mech_Resi__c == 'Mechanical'){
            certainTeedName = acc.Mechanical_Territory_User__r.Name;
        }
        bpcsAccountID = acc.SAP_ACCOUNT__c;
        getStratumDataRecords();
        return null;
    }//End of method
    
    public void getcertainTeedName(){        
        certainTeedName = '';    
        bpcsAccountID = '';    
        if(sep.Account__c != null){
            Account acc = [Select id ,name,OwnerId,Owner.Name, SAP_ACCOUNT__c, Mechanical_Territory_User__r.Name From Account Where Id =:sep.Account__c]; 
            system.debug('@@AccountRecord==>'+acc);
            certainTeedName = acc.Owner.Name;
            if(sep.Territory_Mech_Resi__c == 'Mechanical'){
                certainTeedName = acc.Mechanical_Territory_User__r.Name;
            }
            bpcsAccountID = acc.SAP_ACCOUNT__c;
        }else{ 
            certainTeedName = '';
            bpcsAccountID = '';
            getStratumDataRecords();
        }
        //Validate that there is only one BAP for an Account and Year.
        if(sep.Account__c != null && sep.Year__c != null){
            getStratumDataRecords();
            list<SEP__c> sepList = [Select Id, Year__c, Account__c, Name, Territory_Mech_Resi__c From SEP__c Where Account__c =:sep.Account__c];            
            if(sepList != null && sepList.size() > 0){
                for(SEP__c sep : sepList) {
                    if(sep.Year__c == sep.Year__c){
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Sorry, but an BAP for the selected Account and Year already exists.'));
                        certainTeedName = '';                        
                        bpcsAccountID = '';
                        break;
                    }
                }
            }
        }
    }//End of Set CertainTeedName method    
    
    private void stratumDataPreparation(Boolean isClone) {
        List<Stratum_Data__c> stratumDataToUpsert = new List<Stratum_Data__c>();
        stratumDataMap = new Map<String, Stratum_Data__c>();
        String[] productClasses;
        if(isMechanical) {
            productClasses = new String[]{'11', '06', '74', '87', '56', '84', '86', '70', '18'};
        } else {
            productClasses = new String[]{'78', '61', '64', '62'};
        }
        String planYear = sep.Year__c;
        if(isClone) {
            planYear = String.valueOf(Integer.valueOf(sep.Year__c) + 1);
        }
        for(Stratum_Data__c s : [SELECT Id, Product_Class__c, User_Target_Pounds_2YO__c, User_Target_Pounds_CY__c, User_Target_Pounds_NY__c FROM Stratum_Data__c WHERE (Account_Name__c = :sep.Account__c AND Year__c = :planYear) AND (Product_Class__c IN: productClasses )])
        {
            s.User_Target_Pounds_2YO__c = 0;
            s.User_Target_Pounds_CY__c = 0;
            s.User_Target_Pounds_NY__c = 0;
            stratumDataMap.put(s.Product_Class__c, s);
            stratumDataToUpsert.add(s);
        }
        if(stratumDataToUpsert.size() > 0)
            update stratumDataToUpsert;
        
        //Will reuse the same list for inserting
        stratumDataToUpsert.clear();
        
        if(isMechanical) {
            if (!stratumDataMap.containsKey('11'))
                stratumDataMap.put('11', new Stratum_Data__c(Product_Class__c = '11', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID  + '-' + planYear + '-11')); 
            if (!stratumDataMap.containsKey('06'))
                stratumDataMap.put('06', new Stratum_Data__c(Product_Class__c = '06', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-06')); 
            if (!stratumDataMap.containsKey('74'))
                stratumDataMap.put('74', new Stratum_Data__c(Product_Class__c = '74', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-74')); 
            if (!stratumDataMap.containsKey('87'))
                stratumDataMap.put('87', new Stratum_Data__c(Product_Class__c = '87', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-87'));
            if (!stratumDataMap.containsKey('56'))
                stratumDataMap.put('56', new Stratum_Data__c(Product_Class__c = '56', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-56')); 
            if (!stratumDataMap.containsKey('84'))
                stratumDataMap.put('84', new Stratum_Data__c(Product_Class__c = '84', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-84')); 
            if (!stratumDataMap.containsKey('86'))
                stratumDataMap.put('86', new Stratum_Data__c(Product_Class__c = '86', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-86')); 
            if (!stratumDataMap.containsKey('70'))
                stratumDataMap.put('70', new Stratum_Data__c(Product_Class__c = '70', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-70'));
            if (!stratumDataMap.containsKey('18'))
                stratumDataMap.put('18', new Stratum_Data__c(Product_Class__c = '18', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-18'));
        } else {
            //Create new Stratum Data records which are missing based on the Product classes
            if (!stratumDataMap.containsKey('78'))
                stratumDataMap.put('78', new Stratum_Data__c(Product_Class__c = '78', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-78')); 
            if (!stratumDataMap.containsKey('61'))
                stratumDataMap.put('61', new Stratum_Data__c(Product_Class__c = '61', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-61')); 
            if (!stratumDataMap.containsKey('64'))
                stratumDataMap.put('64', new Stratum_Data__c(Product_Class__c = '64', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-64')); 
            if (!stratumDataMap.containsKey('62'))
                stratumDataMap.put('62', new Stratum_Data__c(Product_Class__c = '62', Year__c = planYear, Account_Name__c = sep.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0, External_Record_ID__c = bpcsAccountID + '-' + planYear + '-62')); 
        }
        
        if(isClone) {
            System.debug('stratumDataMap.values(): '+stratumDataMap.values());
            upsert stratumDataMap.values();
        }
    }
    

    public pageReference save(){ 
        if(sep.Account__c == null){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Required Field Missing: Account'));
            return null;
        }
        if(sep.Year__c == ''){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Required Field Missing: Plan Year'));
            return null;
        }
        try{
            sep.Start_Date__c = date.valueOf(sep.Year__c + '-1-1 00:00:00');
            System.debug('Save Start_Date__c'+sep.Start_Date__c);
            sep.End_Date__c = date.valueOf(sep.Year__c + '-12-31 11:59:59');
            System.debug('sep.End_Date__c'+sep.End_Date__c);
            //Upsert SEP
            if(sep != null)
                upsert sep;
            
            //Upsert Stratum Data
            //First Set existing User Target Pound to 0
            stratumDataPreparation(false);
            List<Stratum_Data__c> stratumDataToUpsert = new List<Stratum_Data__c>();
            
            StratumModelClass tempModel;
            Stratum_Data__c tempStratum;
            for(StratumModelClass s : stratumDataModelList)
            {
                if(s.productClass == 'Other') {
                    tempStratum = stratumDataMap.get('18');
                    tempStratum.User_Target_Pounds_CY__c = s.Value3 - s.otherValue1;
                    tempStratum.User_Target_Pounds_NY__c = s.Value4 - s.otherValue2;
                    System.debug('tempStratum: '+tempStratum);
                    stratumDataToUpsert.add(tempStratum);
                }
                else {
                    tempStratum = stratumDataMap.get(s.productClass);
                    tempStratum.User_Target_Pounds_CY__c = s.Value3;
                    tempStratum.User_Target_Pounds_NY__c = s.Value4;
                    //tempStratum.User_Target_Pounds_2YO__c = s.Value4;
                    stratumDataToUpsert.add(tempStratum);
                }
                
            }
            //The User Targets have been updated in the list. Now upsert the stratum data list
            if(stratumDataToUpsert.size() > 0)
                upsert stratumDataToUpsert;
                
            //End of updating/inserting the stratum data records
            
            //Upsert Goals
            List<SEP_Goal__c> goalListToUpsert = new List<SEP_Goal__c>();
            for (GoalClass gc : goalModelList)
            {
                if(gc.sepGoal.SepName__c != '' && gc.sepGoal.SepName__c != null)
                {
                    if(gc.sepGoal.SEP__c == null)
                        gc.sepGoal.SEP__c = sep.Id;
                    gc.sepGoal.Name = gc.sepGoal.SepName__c;
                    gc.sepGoal.Goal_Number1__c = gc.rowIndex+1;
                    gc.sepGoal.Start_Date__c = date.valueOf(sep.Year__c + '-1-1 00:00:00');
                    System.debug('Start Date======================================================='+ gc.sepGoal.Start_Date__c);
                    gc.sepGoal.End_Date__c = date.valueOf(sep.Year__c + '-12-31 11:59:59');
                    System.debug('End_Date__c======================================================='+ gc.sepGoal.End_Date__c);
                    goalListToUpsert.add(gc.sepGoal);
                }
            }
            
            if(goalListToUpsert.size() > 0)
                upsert goalListToUpsert;
            
            //Repopulate number and Id maps
            goalList.clear();
            goalIdMap.clear();
            goalNumberMap.clear();
            
            goalList = [Select Goal_Number1__c, Id, Name, SEP__c, Strategy__c, SepName__c From SEP_Goal__c Where SEP__c = :sep.Id Order by Goal_Number1__c ASC];
            
            for(SEP_Goal__c g : goalList)
            {
                goalIdMap.put(g.Id, g);
                GoalClass temp = new GoalClass();
                temp.rowIndex = (Integer)g.Goal_Number1__c - 1;
                temp.sepGoal = g;
                goalNumberMap.put((Integer)g.Goal_Number1__c, temp);
            }
            //End of saving Goals

            List<Event> eventListToUpsert = new List<Event>();
            List<BapObjectiveModel> blankList =  new List<BapObjectiveModel>();

            ////////////////Start of Quarter One Events Processing
            //This is to achieve the functionality where we need to populate the Objective from the row above if it is blank. 
            //So, we are checking from bottom up and storing the records where the Objective is blank in a separate list.
            //if there is an error, we need to sort the list back in right order so it displays properly.

            quarterOneEvents = sortCustomDesc(quarterOneEvents);  //Sort Quarter1 List In Descending Order of Index
            System.debug('quarterOneEvents after sort DESC:::'+quarterOneEvents);
            
            for(BapObjectiveModel b : quarterOneEvents)
            {
                //GO further if one of the fields is populated
                if(b.evnt.Goal_Number__c != null || b.evnt.Goal_Date__c != null || b.evnt.Action_Plan__c != null || b.evnt.Description != null || b.evnt.Comments__c != null)
                {
                    //Check for Required Fields/Error Conditions
                    if(b.evnt.Goal_Number__c == null && (b.evnt.Goal_Date__c != null || b.evnt.Action_Plan__c != null)){
                        quarterOneEvents = sortCustomAsc(quarterOneEvents);  //Sort Quarter1 List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Required Field Missing: Goal Number'));  
                        return null;
                    }
                    if(b.evnt.Goal_Date__c == null && (b.evnt.Goal_Number__c != null || b.evnt.Action_Plan__c != null)){
                        quarterOneEvents = sortCustomAsc(quarterOneEvents);  //Sort Quarter1 List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Required Field Missing: Goal Date'));    
                        return null;
                    }
                    if(b.evnt.Action_Plan__c == null && (b.evnt.Goal_Date__c != null || b.evnt.Goal_Number__c != null)){
                        quarterOneEvents = sortCustomAsc(quarterOneEvents);  //Sort Quarter1 List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Required Field Missing: Action Step'));
                        return null;
                    }
                    if(String.valueOf(b.evnt.Goal_Date__c.year()) != sep.Year__c){
                        quarterOneEvents = sortCustomAsc(quarterOneEvents);  //Sort Quarter1 List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Goal Date must lie within the BAP year: '+sep.Year__c));
                        return null;
                    }
                    if(!goalNumberMap.containsKey(Integer.valueOf(b.evnt.Goal_Number__c)))
                    {
                        quarterOneEvents = sortCustomAsc(quarterOneEvents);  //Sort Quarter1 List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Goal mismatch Error: Selected Goal in the Objective does not exists. Please select a valid Goal Number.'));
                        return null;
                    }
                    if(b.evnt.Goal_Date__c.month() > 3){
                        quarterOneEvents = sortCustomAsc(quarterOneEvents);  //Sort Quarter1 List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Goal date must fall within the first quarter.'));
                        return null;    
                    }
                    //End Check for Required Fields

                    if(b.evnt.Comments__c != null)
                    {
                        if(goalNumberMap.containsKey(Integer.valueOf(b.evnt.Goal_Number__c)))
                        {
                            b.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id;
                            b.evnt.RecordTypeId = recordTypeId;
                            b.evnt.Subject = b.evnt.Action_Plan__c;
                            // CHG0438619/INC0373378
                            Date gDate=b.evnt.Goal_Date__c;
                            // b.evnt.StartDateTime = b.evnt.Goal_Date__c;
                            b.evnt.StartDateTime=datetime.newInstance(gDate.year(), gDate.month(),gDate.day(),0,0,0);
                            //b.evnt.EndDateTime = b.evnt.Goal_Date__c.addDays(2);
                            DateTime dtgoalDate=datetime.newInstance(gDate.year(), gDate.month(),gDate.day(),23,59,59);
                            b.evnt.EndDateTime=dtgoalDate;
                            eventListToUpsert.add(b.evnt);
                            System.debug('********* Event***' +b);
                            System.debug('********* StartDateTime***' +b.evnt.StartDateTime);
                             System.debug('********* EndDateTime***' +b.evnt.EndDateTime);
                            if(blankList.size() > 0)
                            {
                                for(BapObjectiveModel mod : blankList){
                                    mod.evnt.Comments__c = b.evnt.Comments__c;  
                                    eventListToUpsert.add(mod.evnt);                                            
                                }
                                blankList.clear();
                            }
                        }
                    }
                    else if(b.evnt.Comments__c == null)
                    {
                        b.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id; 
                        b.evnt.RecordTypeId = recordTypeId;   
                        // CHG0438619/INC0373378 
                        //b.evnt.StartDateTime = b.evnt.Goal_Date__c;
                        Date g1Date=b.evnt.Goal_Date__c;
                        b.evnt.StartDateTime=datetime.newInstance(g1Date.year(), g1Date.month(),g1Date.day(),0,0,0);
                        //DateTime newGoalDate=datetime.newInstance(g1Date.year(), g1Date.month(),g1Date.day()+(1),23,59,59);
                        DateTime newGoalDate=datetime.newInstance(g1Date.year(), g1Date.month(),g1Date.day(),23,59,59);
                        //b.evnt.StartDateTime=newGoalDate.addDays(2).addHours(22);
                        b.evnt.StartDateTime=newGoalDate;
                        blankList.add(b);
                    }
                }
            }
            if(blankList.size() > 0){
                quarterOneEvents = sortCustomAsc(quarterOneEvents);
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Error: You must enter a Quarterly Objectives in the first row.'));    
                return null;    
            }
            //Sort them ascending for display
            quarterOneEvents = sortCustomAsc(quarterOneEvents);
            ////////////////End of Quarter One Events Processing
            
            ////////////////Start of Quarter TWO Events Processing
            quarterTwoEvents = sortCustomDesc(quarterTwoEvents);  //Sort List In Descending Order
            for(BapObjectiveModel b : quarterTwoEvents)
            {
                //Go further if one of the fields is populated
                if(b.evnt.Goal_Number__c != null || b.evnt.Goal_Date__c != null || b.evnt.Action_Plan__c != null || b.evnt.Description != null || b.evnt.Comments__c != null)
                {
                    //Check for Required Fields/Error Conditions
                    if(b.evnt.Goal_Number__c == null && (b.evnt.Goal_Date__c != null || b.evnt.Action_Plan__c != null)){
                        quarterTwoEvents = sortCustomAsc(quarterTwoEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Required Field Missing: Goal Number'));  
                        return null;
                    }
                    if(b.evnt.Goal_Date__c == null && (b.evnt.Goal_Number__c != null || b.evnt.Action_Plan__c != null)){
                        quarterTwoEvents = sortCustomAsc(quarterTwoEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Required Field Missing: Goal Date'));    
                        return null;
                    }
                    if(b.evnt.Action_Plan__c == null && (b.evnt.Goal_Date__c != null || b.evnt.Goal_Number__c != null)){
                        quarterTwoEvents = sortCustomAsc(quarterTwoEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Required Field Missing: Action Step'));
                        return null;
                    }
                    if(String.valueOf(b.evnt.Goal_Date__c.year()) != sep.Year__c){
                        quarterTwoEvents = sortCustomAsc(quarterTwoEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Goal Date must lie within the BAP year: '+sep.Year__c));
                        return null;
                    }
                    if(!goalNumberMap.containsKey(Integer.valueOf(b.evnt.Goal_Number__c)))
                    {
                        quarterTwoEvents = sortCustomAsc(quarterTwoEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Goal mismatch Error: Selected Goal in the Objective does not exists. Please select a valid Goal Number.'));
                        return null;
                    }
                    if(!(b.evnt.Goal_Date__c.month() > 3 && b.evnt.Goal_Date__c.month() < 7)){
                        quarterTwoEvents = sortCustomAsc(quarterTwoEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Goal date must fall within the second quarter.'));
                        return null;    
                    }
                    //End Check for Required Fields

                    if(b.evnt.Comments__c != null)
                    {
                        if(goalNumberMap.containsKey(Integer.valueOf(b.evnt.Goal_Number__c)))
                        {
                            b.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id;
                           // CHG0438619/INC0373378 
                            b.evnt.RecordTypeId = recordTypeId;
                            Date sDate=b.evnt.Goal_Date__c;
                            //b.evnt.StartDateTime = b.evnt.Goal_Date__c;
                            b.evnt.StartDateTime=datetime.newInstance(sDate.year(), sDate.month(),sDate.day(),0,0,0);
                            b.evnt.Subject = b.evnt.Action_Plan__c;
                            //b.evnt.EndDateTime = b.evnt.Goal_Date__c.addDays(2);
                            //b.evnt.EndDateTime=datetime.newInstance(sDate.year(), sDate.month(),sDate.day()+(1),23,59,59);
                             b.evnt.EndDateTime=datetime.newInstance(sDate.year(), sDate.month(),sDate.day(),23,59,59);
                            eventListToUpsert.add(b.evnt);
                            if(blankList.size() > 0)
                            {
                                for(BapObjectiveModel mod : blankList){
                                    mod.evnt.Comments__c = b.evnt.Comments__c;  
                                    eventListToUpsert.add(mod.evnt);                                            
                                }
                                blankList.clear();
                            }
                        }
                    }
                    else if(b.evnt.Comments__c == null)
                    {
                        b.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id; 
                        b.evnt.RecordTypeId = recordTypeId; 
                       // CHG0438619/INC0373378 
                        Date g2Date=b.evnt.Goal_Date__c;
                        b.evnt.StartDateTime =datetime.newInstance(g2Date.year(), g2Date.month(),g2Date.day(),0,0,0); 
                        //DateTime g2DateTime=datetime.newInstance(g2Date.year(), g2Date.month(),g2Date.day());
                        //b.evnt.EndDateTime = b.evnt.Goal_Date__c.addDays(2);
                        //b.evnt.EndDateTime = datetime.newInstance(g2Date.year(), g2Date.month(),g2Date.day()+(1),23,59,59);
                        b.evnt.EndDateTime = datetime.newInstance(g2Date.year(), g2Date.month(),g2Date.day(),23,59,59);
                        blankList.add(b);
                    }
                }
            }
            if(blankList.size() > 0){
                quarterTwoEvents = sortCustomAsc(quarterTwoEvents);
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Error: You must enter a Quarterly Objectives in the first row.'));    
                return null;    
            }
            //Sort them ascending for display
            quarterTwoEvents = sortCustomAsc(quarterTwoEvents);
            ////////////////End of Quarter TWO Events Processing
            
            ////////////////Start of Quarter THREE Events Processing
            quarterThreeEvents = sortCustomDesc(quarterThreeEvents);  //Sort List In Descending Order
            for(BapObjectiveModel b : quarterThreeEvents)
            {
                //Check if the event is a new record
                if(b.evnt.Goal_Number__c != null || b.evnt.Goal_Date__c != null || b.evnt.Action_Plan__c != null || b.evnt.Description != null || b.evnt.Comments__c != null)
                {
                    //Check for Required Fields/Error Conditions
                    if(b.evnt.Goal_Number__c == null && (b.evnt.Goal_Date__c != null || b.evnt.Action_Plan__c != null)){
                        quarterThreeEvents = sortCustomAsc(quarterThreeEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Required Field Missing: Goal Number'));  
                        return null;
                    }
                    if(b.evnt.Goal_Date__c == null && (b.evnt.Goal_Number__c != null || b.evnt.Action_Plan__c != null)){
                        quarterThreeEvents = sortCustomAsc(quarterThreeEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Required Field Missing: Goal Date'));    
                        return null;
                    }
                    if(b.evnt.Action_Plan__c == null && (b.evnt.Goal_Date__c != null || b.evnt.Goal_Number__c != null)){
                        quarterThreeEvents = sortCustomAsc(quarterThreeEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Required Field Missing: Action Step'));
                        return null;
                    }
                    if(String.valueOf(b.evnt.Goal_Date__c.year()) != sep.Year__c){
                        quarterThreeEvents = sortCustomAsc(quarterThreeEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Goal Date must lie within the BAP year: '+sep.Year__c));
                        return null;
                    }
                    if(!goalNumberMap.containsKey(Integer.valueOf(b.evnt.Goal_Number__c)))
                    {
                        quarterThreeEvents = sortCustomAsc(quarterThreeEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Goal mismatch Error: Selected Goal in the Objective does not exists. Please select a valid Goal Number.'));
                        return null;
                    }
                    if(!(b.evnt.Goal_Date__c.month() >= 7 && b.evnt.Goal_Date__c.month() <= 9)){
                        quarterThreeEvents = sortCustomAsc(quarterThreeEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Goal date must fall within the third quarter.'));
                        return null;    
                    }
                    //End Check for Required Fields

                    if(b.evnt.Comments__c != null)
                    {
                        if(goalNumberMap.containsKey(Integer.valueOf(b.evnt.Goal_Number__c)))
                        {
                            b.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id;
                            b.evnt.RecordTypeId = recordTypeId;
                           // CHG0438619/INC0373378 
                            Date g3Date=b.evnt.Goal_Date__c;
                           //b.evnt.StartDateTime = b.evnt.Goal_Date__c;
                            b.evnt.StartDateTime = datetime.newInstance(g3Date.year(), g3Date.month(),g3Date.day(),0,0,0);
                            b.evnt.Subject = b.evnt.Action_Plan__c;
                           //b.evnt.EndDateTime = b.evnt.Goal_Date__c.addDays(2);
                           //b.evnt.EndDateTime = datetime.newInstance(g3Date.year(), g3Date.month(),g3Date.day()+(1),23,59,59);
                            b.evnt.EndDateTime = datetime.newInstance(g3Date.year(), g3Date.month(),g3Date.day(),23,59,59);
                            eventListToUpsert.add(b.evnt);
                            if(blankList.size() > 0)
                            {
                                for(BapObjectiveModel mod : blankList){
                                    mod.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id; 
                                    mod.evnt.RecordTypeId = recordTypeId;   
                                    mod.evnt.Comments__c = b.evnt.Comments__c;  
                                    eventListToUpsert.add(mod.evnt);                                            
                                }
                                blankList.clear();
                            }
                        }
                    }
                    else if(b.evnt.Comments__c == null)
                    {
                         b.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id; 
                         b.evnt.RecordTypeId = recordTypeId;  
                        // CHG0438619/INC0373378
                         Date g4Date = b.evnt.Goal_Date__c;
                       // b.evnt.StartDateTime = b.evnt.Goal_Date__c;
                         b.evnt.StartDateTime=datetime.newInstance(g4Date.year(), g4Date.month(),g4Date.day(),0,0,0);
                       //b.evnt.EndDateTime = datetime.newInstance(g4Date.year(), g4Date.month(),g4Date.day()+(1),23,59,59);
                         b.evnt.EndDateTime = datetime.newInstance(g4Date.year(), g4Date.month(),g4Date.day(),23,59,59);
                         blankList.add(b);
                    }
                }
            }
            if(blankList.size() > 0){
                quarterThreeEvents = sortCustomAsc(quarterThreeEvents);
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Error: You must enter a Quarterly Objectives in the first row.'));    
                return null;    
            }
            //Sort them ascending for display
            quarterThreeEvents = sortCustomAsc(quarterThreeEvents);
            ////////////////End of Quarter THREE Events Processing
            
            
            ////////////////Start of Quarter FOUR Events Processing
            quarterFourEvents = sortCustomDesc(quarterFourEvents);  //Sort List In Descending Order
            for(BapObjectiveModel b : quarterFourEvents)
            {
                if(b.evnt.Goal_Number__c != null || b.evnt.Goal_Date__c != null || b.evnt.Action_Plan__c != null || b.evnt.Description != null || b.evnt.Comments__c != null)
                {
                    //Check for Required Fields/Error Conditions
                    if(b.evnt.Goal_Number__c == null && (b.evnt.Goal_Date__c != null || b.evnt.Action_Plan__c != null)){
                        quarterFourEvents = sortCustomAsc(quarterFourEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Required Field Missing: Goal Number'));  
                        return null;
                    }
                    if(b.evnt.Goal_Date__c == null && (b.evnt.Goal_Number__c != null || b.evnt.Action_Plan__c != null)){
                        quarterFourEvents = sortCustomAsc(quarterFourEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Required Field Missing: Goal Date'));    
                        return null;
                    }
                    if(b.evnt.Action_Plan__c == null && (b.evnt.Goal_Date__c != null || b.evnt.Goal_Number__c != null)){
                        quarterFourEvents = sortCustomAsc(quarterFourEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Required Field Missing: Action Step'));
                        return null;
                    }
                    if(String.valueOf(b.evnt.Goal_Date__c.year()) != sep.Year__c){
                        quarterFourEvents = sortCustomAsc(quarterFourEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Goal Date must lie within the BAP year: '+sep.Year__c));
                        return null;
                    }
                    if(!goalNumberMap.containsKey(Integer.valueOf(b.evnt.Goal_Number__c)))
                    {
                        quarterFourEvents = sortCustomAsc(quarterFourEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Goal mismatch Error: Selected Goal in the Objective does not exists. Please select a valid Goal Number.'));
                        return null;
                    }
                    if(!(b.evnt.Goal_Date__c.month() > 9)){
                        quarterFourEvents = sortCustomAsc(quarterFourEvents);  //Sort List In Ascending Order for display.
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Goal date must fall within the fourth quarter.'));
                        return null;    
                    }
                    //End Check for Required Fields

                    if(b.evnt.Comments__c != null)
                    {
                        if(goalNumberMap.containsKey(Integer.valueOf(b.evnt.Goal_Number__c)))
                        {
                            b.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id;
                            b.evnt.RecordTypeId = recordTypeId;
                           //CHG0438619/INC0373378
                            b.evnt.Subject = b.evnt.Action_Plan__c;
                            //b.evnt.StartDateTime = b.evnt.Goal_Date__c;
                            Date g5Date=b.evnt.Goal_Date__c;
                            b.evnt.StartDateTime=datetime.newInstance(g5Date.year(), g5Date.month(),g5Date.day(),0,0,0);
                            //b.evnt.EndDateTime = datetime.newInstance(g5Date.year(), g5Date.month(),g5Date.day()+(1),23,59,59);
                             b.evnt.EndDateTime = datetime.newInstance(g5Date.year(), g5Date.month(),g5Date.day(),23,59,59);
                            eventListToUpsert.add(b.evnt);
                            if(blankList.size() > 0)
                            {
                                for(BapObjectiveModel mod : blankList){
                                    mod.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id; 
                                    mod.evnt.RecordTypeId = recordTypeId;   
                                    mod.evnt.Comments__c = b.evnt.Comments__c;  
                                    eventListToUpsert.add(mod.evnt);                                            
                                }
                                blankList.clear();
                            }
                        }
                    }
                    else if(b.evnt.Comments__c == null)
                    {
                        b.evnt.WhatId = goalNumberMap.get(integer.valueOf(b.evnt.Goal_Number__c)).sepGoal.Id; 
                        b.evnt.RecordTypeId = recordTypeId;   
                        // CHG0438619/INC0373378 
                        //b.evnt.StartDateTime = b.evnt.Goal_Date__c;
                        Date g6Date=b.evnt.Goal_Date__c;
                        b.evnt.StartDateTime=datetime.newInstance(g6Date.year(), g6Date.month(),g6Date.day(),0,0,0);
                        //b.evnt.EndDateTime = datetime.newInstance(g6Date.year(), g6Date.month(),g6Date.day()+(1),23,59,59);
                        b.evnt.EndDateTime = datetime.newInstance(g6Date.year(), g6Date.month(),g6Date.day(),23,59,59);
                        blankList.add(b);
                    }
                }
            }
            if(blankList.size() > 0){
                quarterFourEvents = sortCustomAsc(quarterFourEvents);
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Error: You must enter a Quarterly Objectives in the first row.'));    
                return null;    
            }
            //Sort them ascending for display
            quarterFourEvents = sortCustomAsc(quarterFourEvents);
            ////////////////End of Quarter FOUR Events Processing
            
            //Upsert Events
            if(eventListToUpsert.size() > 0)
                System.debug('eventListToUpsert'+eventListToUpsert);
                upsert eventListToUpsert;
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Exception in update: '+e.getMessage()));    
            return null;
        }
        
        //system.debug('$$$$ After'+eventListToUpsert);          
            
        pageReference pg = new pageReference('/apex/manageBap2?id='+sep.Id);
        return pg.setRedirect(true);
    }//End of Save function.
    
    //Total of all the values of Stratum data table:-
    private void calculateTotals(list<StratumModelClass> modelList){
        system.debug('@@TOTAL ::'+modelList);
        totalValue1 = 0;
        totalValue2 = 0;
        totalValue3 = 0;
        totalValue4 = 0;
        totalValue5 = 0;
        
        if(isMechanical) {
            Integer noOfDays = 0;
            if(sep.Year__c != null) {
                Date startDate = Date.newInstance(Integer.valueOf(sep.Year__c), 1, 1);
                Date endDate = Date.today().addDays(-1);
                noOfDays = startDate.daysBetween(endDate);
                for(StratumModelClass m : modelList) {
                    m.Value5 = (m.Value2/noOfDays) * 365;
                }
            }
        }
        
        for(StratumModelClass m : modelList){
            totalValue1 = totalValue1 + m.Value1;
            totalValue2 = totalValue2 + m.Value2;
            totalValue3 = totalValue3 + m.Value3;
            totalValue4 = totalValue4 + m.Value4;
            if(isMechanical) totalValue5 = totalValue5 + m.Value5;
        }        
    }
    
    //======Method for Close and redirect to the Bap tap=====
    public pageReference closeProcess()
    {  
        String bapPrefix = Schema.getGlobalDescribe().get('SEP__c').getDescribe().getKeyPrefix();     
// jw 2012-01-21 Commented out this code because the View page has been overridden.
//        if(sep.Id != null)
//            return new pageReference('/'+sep.Id);
//        else
            return new pageReference('/'+bapPrefix);
        
    }
    
    //Save and Close method
     public pageReference saveAndClose()
    {       
        save();
        String bapPrefix = Schema.getGlobalDescribe().get('SEP__c').getDescribe().getKeyPrefix();
        return new pageReference('/'+bapPrefix);
    }
    
    public pageReference deleteEventQ1()
    {
        System.debug('rIndex:::'+rIndex);
        if(rIndex == null)
        {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'rIndex:::'+rIndex));
            return null;
        }
        Event evtTBD = quarterOneEvents.get(rIndex).evnt;
        quarterOneEvents.remove(rIndex);
        try{
            if(evtTBD.Id != null)
                delete evtTBD;
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error Deleting Objective:::'+e.getMessage()));
            return null;
        }
        return null;
    }
    public pageReference deleteEventQ2()
    {
        System.debug('rIndex:::'+rIndex);
        if(rIndex == null)
        {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'rIndex:::'+rIndex));
            return null;
        }
        Event evtTBD = quarterTwoEvents.get(rIndex).evnt;
        quarterTwoEvents.remove(rIndex);
        try{
            if(evtTBD.Id != null)
                delete evtTBD;
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error Deleting Objective:::'+e.getMessage()));
            return null;
        }
        return null;
    }
    public pageReference deleteEventQ3()
    {
        System.debug('rIndex:::'+rIndex);
        if(rIndex == null)
        {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'rIndex:::'+rIndex));
            return null;
        }
        Event evtTBD = quarterThreeEvents.get(rIndex).evnt;
        quarterThreeEvents.remove(rIndex);
        try{
            if(evtTBD.Id != null)
                delete evtTBD;
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error Deleting Objective:::'+e.getMessage()));
            return null;
        }
        return null;
    }
    public pageReference deleteEventQ4()
    {
        System.debug('rIndex:::'+rIndex);
        if(rIndex == null)
        {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'rIndex:::'+rIndex));
            return null;
        }
        Event evtTBD = quarterFourEvents.get(rIndex).evnt;
        quarterFourEvents.remove(rIndex);
        try{
            if(evtTBD.Id != null)
                delete evtTBD;
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error Deleting Objective:::'+e.getMessage()));
            return null;
        }
        return null;
    }
    
    public pageReference deleteGoal()
    {
        System.debug('rIndex:::'+rIndex);
        if(rIndex == null)
        {
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'rIndex:::'+rIndex));
            return null;
        }
        //Pull the goal to be deleted
        SEP_Goal__c sepGoalTBD = goalModelList.get(rIndex).sepGoal;
        System.debug('sepGoalTBD:::'+sepGoalTBD);
        //Remove the element from te model list
        goalModelList.remove(rIndex);

        //Delete the Goal, which will also delete related Events
        try{
            if(sepGoalTBD.Id != null)
                delete sepGoalTBD;
            
        }catch(Exception e){
            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Error Deleting Goal:::'+e.getMessage()));
            return null;
        }
        
        //Add a blank row at the deleted location to preserve the gap
        GoalClass gc = new GoalClass();
        gc.rowIndex = rIndex;
        gc.sepGoal = new SEP_Goal__c(Goal_Number1__c=rIndex+1, SepName__c='');
        goalModelList.add(rIndex, gc);
        goalNumberMap.put(rIndex+1, gc);
        PageReference pg = new PageReference('/apex/manageBap2?id='+sep.Id);
        return pg.setRedirect(true);
    }
    
    //=====Model Class For SEP Goal Table======
    public class GoalClass{    
        public SEP_Goal__c sepGoal { get; set; }
        public Integer rowIndex { get; set; }
    }
    
    //=====Model Class For Stratum Table=====
    public class StratumModelClass{
        public String productClass { get; set; }
        public String label { get; set; }
        public Integer Value1 { get; set; } 
        public Integer Value2 { get; set; }      
        public Integer Value3 { get; set; }      
        public Integer Value4 { get; set; }
        public Integer Value5 { get; set; }   
        public Integer otherValue1 { get; set; }
        public Integer otherValue2 { get; set; }
        
        public StratumModelClass(Boolean initialize) {
            Value1 = 0;
            Value2 = 0;
            Value3 = 0;
            Value4 = 0;
            Value5 = 0;
            otherValue1 = 0;
            otherValue2 = 0;
        }
        
        public StratumModelClass() {}
    }
    
    //Model class for bap objective and also contains events.
    public class BapObjectiveModel{        
        public Event evnt{ get; set; }
        public Integer rowIndex{ get; set; }
    }  

}