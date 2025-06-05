// ==================================================================================
//     Name: BapController 
//     Company: SalesOptimizer
//     Author: Nagendra 
//     Comments: BapController
// ==================================================================================
//     Changes: 2012-12-27 Initial version.
//History:
//* - VERSION  DEVELOPER NAME                  DATE            DETAIL FEATURES/CSR/TTP
//    1.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
// ==================================================================================

public class BapController
{
    /*
    public SEP__c sep { get; set; }
    public SEP__c sep1 { get; set; }
    public Id sepId { get; set; }
   // public boolean iserror{ get; set; }
    public String certainTeedName { get; set; }
    public String currentYear { get; set; }
    public String previousYear { get; set; }
    public String currYear { get; set; }
    public String prevYear { get; set; }
    public String nextYear { get; set; }
    public String next2Year { get; set; }
    public String accountId { get; set; }
    //public map<String,String> mapProdClass2{ get; set; }
    public list<StratumModelClass> modelList { get; set; }    
    //public SEP_Goal__c sepGoal { get; set; }
    public list<GoalClass> goalModelList { get; set; }
    public Boolean isNew { get; set; }
    public string sepAccountId { get; set; }
    public list<BapObjectiveModel> BapObjectiveModelList { get; set; }
    public list<BapObjectiveModel> BapObjectiveModelList1 { get; set; }
    public list<BapObjectiveModel> BapObjectiveModelList2 { get; set; }
    public list<BapObjectiveModel> BapObjectiveModelList3 { get; set; }
    private set<String> goalId;
    public map<String,integer> indexMAP { get; set; }
    public map<integer,String> indexIdMAP { get; set; }
    public map<Integer,String> indexNameMAP { get; set; }
    public list<BapObjectiveModel> Q1 { get; set; }
    public list<BapObjectiveModel> Q2 { get; set; }
    public list<BapObjectiveModel> Q3 { get; set; }
    public list<BapObjectiveModel> Q4 { get; set; }    
    public list<BapObjectiveModel> pdfQ1 { get; set; }
    public list<BapObjectiveModel> pdfQ2 { get; set; }
    public list<BapObjectiveModel> pdfQ3 { get; set; }
    public list<BapObjectiveModel> pdfQ4 { get; set; }
    //public list<SelectOption> goalNumberPickList { get; set; }    
    //public Boolean isNew1 { get; set; }
    private map<String,Stratum_Data__c> stratumDataMap;
    public list<Stratum_Data__c> existingSDList { get; set; }
    public Integer aggregateSize;
    public decimal totalValue1 { get; set; }
    public decimal totalValue2 { get; set; }
    public decimal totalValue3 { get; set; }
    public decimal totalValue4 { get; set; }
    public String p1 { get; set; }
    public String p2 { get; set; }
    public map<integer,SEP_Goal__c> indexIdGoalMAP { get; set; }
    public String getYear { get; set; }
    public map<integer,Event> commentsMap { get; set; }
    public list<GoalClass> goalModelListPDF { get; set; }
    public String checkPDF { get; set; }
    public SEP__c selectedSep { get; set; }
    public list<SEP_Goal__c> selectedGoals {get; set;} 
    public SEP_Goal__c selectedGoal { get; set; }
    public SEP_Goal__c oldGoal { get; set; }
    public list<Event> selectedEvents { get; set; }    
    public set<String> productClassSet;
    //public Static Boolean isTest = false;
    //public Static Boolean isTest1 = false;
    
    /*---------------
        Constructor
    -----------------    
    public BapController(ApexPages.StandardController controller)
    {
        //iserror = false;
        isNew = true;
        //isNew1 = true;      
        
        sep = (SEP__c)controller.getRecord(); //Get BAP Record
        totalValue1 = 0;
        totalValue2 = 0;
        totalValue3 = 0;
        totalValue4 = 0;
        
        /*goalNumberPickList = new list<SelectOption>();
        goalNumberPickList.add(new SelectOption('','-None-'));    
        goalNumberPickList.add(new SelectOption('1','1'));
        goalNumberPickList.add(new SelectOption('2','2'));
        goalNumberPickList.add(new SelectOption('3','3'));
        goalNumberPickList.add(new SelectOption('4','4'));
        goalNumberPickList.add(new SelectOption('5','5'));
        goalNumberPickList.add(new SelectOption('6','6'));
        goalNumberPickList.add(new SelectOption('7','7'));
        goalNumberPickList.add(new SelectOption('8','8'));
        goalNumberPickList.add(new SelectOption('9','9'));
        goalNumberPickList.add(new SelectOption('10','10'));
        
        //Check-point for existing Bap
        if(sep.Id != null)
        {
            isNew = false;
            
            sep1 = 
                [Select Id,
                        Name,
                        Account__c,
                        Account__r.OwnerId,
                        Account__r.Owner.Name,
                        Account_Name__c,
                        Description__c, 
                        Year__c,
                        Stage__c,
                        Start_Date__c,
                        Notes__c,
                        End_Date__c,
                        Report_Year__c 
                   From SEP__c 
                  Where Id = :sep.Id];
            certainTeedName = sep1.Account__r.Owner.Name;
            
            list<SEP_Goal__c> SepGoalList = 
                [Select Id,
                        Name,
                        SEP__c,
                        Goal_Number__c,
                        Strategy__c 
                   From SEP_Goal__c 
                  Where SEP__c = :sep1.Id Order by Goal_Number__c ASC];
            
            goalId = new set<String>();
            goalModelList = new list<GoalClass>();
            goalModelListPDF = new list<GoalClass>();
            system.debug('@@ BAP Gaol list ::::'+SepGoalList);
            
            integer i = 0;
            integer r = 1;
            indexMAP = new map<String,integer>();
            indexIdMAP = new map<Integer,String>();
            indexIdGoalMAP = new map<Integer,SEP_Goal__c>();
            indexNameMAP = new map<Integer,String>();
            map<String,SEP_Goal__c> SepGaolEventMap = new map<String,SEP_Goal__c>();
            
            //For-Each loop on Bap Goal's
            for(SEP_Goal__c goal:SepGoalList){
                goalId.add(goal.Id);
                SepGaolEventMap.put(goal.Id,goal);
                integer index =  r++;
                
                if(goalModelList.size() < 10){
                    system.debug('@@ BAP Gaol Model list ::::'+goalModelList);
                    goalModelList.add(new GoalClass(++i,goal));    
                    if(goalModelListPDF.size() > 0)
                        goalModelListPDF.clear();
                        
                    goalModelListPDF.addAll(goalModelList);
                } else break;
            }                       
            for(GoalClass gc:goalModelList){            
                indexMAP.put(gc.sepGoal.Id,gc.indexNo);
                indexIdMAP.put(gc.indexNo,gc.sepGoal.Id);
                indexIdGoalMAP.put(gc.indexNo,gc.sepGoal);
                indexNameMAP.put(gc.indexNo,gc.sepGoal.Name);
            }
            
            //=================For Blank Space====================
                        
            if(goalModelList.size() < 10){
                integer j = goalModelList.size();
                integer val = goalModelList.size();
                integer diff = 10 - val;
                for(integer k=1; k <= diff; k++){                    
                    SEP_Goal__c goal = new SEP_Goal__c(); 
                    goalModelList.add(new GoalClass(++j,goal));    
                }
            }            
            //goalModelList = sortByGoalNumber1(goalModelList);
            
            BapObjectiveModelList = new list<BapObjectiveModel>(); //Model List Contains Objective & Events
            set<String> objectiveId = new set<String>(); //This Set collecting the Objective Id and used in event.
            map<String,list<Event>> eventMap = new map<String,list<Event>>(); //Right now not used
            //list<Event> tempEvent;     //Decelaration of List of events.
            
            
            //Query on Bap Events
            list<Event> eventList =[SELECT AccountId,/*Goal_Number__c,Action_Plan__c,Id,Description,EndDateTime,RecordTypeId,Comments__c, Product_Code_Description__c,                                
                                   WhatId,SEP_activity__c,Subject,StartDateTime,/*Goal_Date__c, State__c, Status__c FROM Event where WhatId in:goalId /*And Goal_Date__c != null]; 
                                   
           //Initionilization of all 4 quater List for BAP 
            Q1=new list<BapObjectiveModel>();                      
            Q2=new list<BapObjectiveModel>();                      
            Q3=new list<BapObjectiveModel>();                      
            Q4=new list<BapObjectiveModel>();          
            
           //Initionilization of all 4 quater List for PDF 
            pdfQ1 = new list<BapObjectiveModel>();
            pdfQ2 = new list<BapObjectiveModel>();
            pdfQ3 = new list<BapObjectiveModel>();
            pdfQ4 = new list<BapObjectiveModel>();
            
            integer indQ1=0;                   
            integer indQ2=0;                   
            integer indQ3=0;                   
            integer indQ4=0;         
            commentsMap = new map<integer,Event>();          
            For(Event evnt :eventList){              
                //SEP_Objective__c obj1 = SepObjectiveMap.get(evnt.WhatId);
                SEP_Goal__c goal1 = SepGaolEventMap.get(evnt.WhatId);
                integer goalNo = indexMAP.get(evnt.WhatId);
                commentsMap.put(goalNo,evnt);
                
                integer val = eventList.size();
                            
                //if(evnt.Goal_Date__c.month() <= 3){
                   if(Q1.size() < 20)
                        Q1.add(new BapObjectiveModel(evnt,goalNo,++indQ1)); 
                        if(pdfQ1.size() > 0)
                            pdfQ1.clear();
                        pdfQ1.addAll(Q1);  
                                            
                //}
                //if(evnt.Goal_Date__c.month() > 3 && evnt.Goal_Date__c.month() <= 6){
                    if(Q2.size() < 20)
                        Q2.add(new BapObjectiveModel(evnt,goalNo,++indQ2));
                    
                    system.debug('$$$$ Quater 2 List'+Q2);
                    system.debug('$$$$ Quater 2 List'+Q2.size());
                        if(pdfQ2.size() > 0)
                            pdfQ2.clear();
                        pdfQ2.addAll(Q2);
                //}
                //if(evnt.Goal_Date__c.month()> 6 && evnt.Goal_Date__c.month()<=9){
                    if(Q3.size() < 20)
                        Q3.add(new BapObjectiveModel(evnt,goalNo,++indQ3));
                        if(pdfQ3.size() > 0)
                            pdfQ3.clear();
                        pdfQ3.addAll(Q3);
                //}
                //if(evnt.Goal_Date__c.month() > 9){
                    Q4.add(new BapObjectiveModel(evnt,goalNo,++indQ4));
                    if(pdfQ4.size() > 0)
                        pdfQ4.clear();
                    pdfQ4.addAll(Q4);
                //}
            }
            //Calling for ascending order in order of goal Number 
            Q1 = sortCustom2(Q1);   
            Q2 = sortCustom2(Q2);
            Q3 = sortCustom2(Q3);
            Q4 = sortCustom2(Q4);
            
            if(Q1.size() < 20){                
                //isNew1 = true;                
                integer val = Q1.size();  
                integer indexQ1 = Q1.size();    
                for(integer k = 0;k < 20-val; k++){
                    SEP_Objective__c obj2 = new SEP_Objective__c();
                    Event e = new Event();       
                    e.Status__c = 'Planning';             
                    Q1.add(new BapObjectiveModel(e,k,++indexQ1));
                }
            }
            
            if(Q2.size() < 20){                
                //isNew1 = true;                
                integer val = Q2.size(); 
                integer indexQ2 =  Q2.size();     
                for(integer k = 0;k < 20-val; k++){
                    SEP_Objective__c obj2 = new SEP_Objective__c();
                    Event e = new Event();       
                    e.Status__c = 'Planning';             
                    Q2.add(new BapObjectiveModel(e,k,++indexQ2));
                }
            }
            if(Q3.size() < 20){                
                //isNew1 = true;                
                integer val = Q3.size();  
                integer indexQ3 = Q3.size();    
                for(integer k = 0;k < 20-val; k++){
                    SEP_Objective__c obj2 = new SEP_Objective__c();
                    Event e = new Event();       
                    e.Status__c = 'Planning';             
                    Q3.add(new BapObjectiveModel(e,k,++indexQ3));
                }
            }
            if(Q4.size() < 20){                
                //isNew1 = true;                
                integer val = Q4.size();   
                integer indexQ4 = Q4.size();   
                for(integer k = 0;k < 20-val; k++){
                    SEP_Objective__c obj2 = new SEP_Objective__c();
                    Event e = new Event();       
                    e.Status__c = 'Planning';             
                    Q4.add(new BapObjectiveModel(e,k,++indexQ4));
                }
            }
           
            //Query for the Stratum Data records associated to the Account on the SEP and in the current year:-
            //Calling of Existing Stratum Data records.            
            getStratumDateRecords();                                                                                                                                                 
            
        }else{        
            isNew = true;
            //isNew1 = true; 
            
            sep1 = new SEP__c();                                                  
            String AccountId = apexPages.currentPage().getParameters().get('CF00NS0000000z2kO_lkid');    
            if(AccountId != null)
                sep1.Account__c = AccountId;     
                
            String accountOwnerName = apexPages.currentPage().getParameters().get('param1');
            if(accountOwnerName != '')
                certainTeedName = accountOwnerName;
                
            // Default the current and previous year. These values
            // will be overridden later.
            currentYear = String.valueOf(system.today().year());
            previousYear = String.valueOf(system.today().year() - 1);
            //prevYear = 'Actual' + 2011;
            //currYear = 'Goals ' + currentYear;
            //nextYear = 'Goals ' + String.valueOf(Integer.valueOf(currentYear) + 1);
            //next2Year = 'Goals ' + String.valueOf(Integer.valueOf(currentYear) + 2);
            
            //Set the variables to be used for labels in the VF page:-
            prevYear = '     Actuals';
            currYear = '     Goals';
            nextYear = '     1 Goals';
            next2Year ='     2 Goals';
            
            //========For Blank Space======
            goalModelList = new list<GoalClass>();
            if(goalModelList.size() == 0){
                integer j = goalModelList.size();
                integer val = goalModelList.size();
                for(integer k=1; k < 11; k++){                    
                    SEP_Goal__c goal = new SEP_Goal__c(); 
                    goalModelList.add(new GoalClass(k,goal));    
                }
            }
            
            //Calling init method for New mode of Stratum data records
            init();
            
             //=====For 20 Blank Space=====
            //=======For Quater 1=========
            Q1=new list<BapObjectiveModel>();            
            if(Q1.size() == 0){
              integer size1 = Q1.size();  
              for(integer k=1; k < 21; k++){ 
                  SEP_Objective__c objective = new SEP_Objective__c();
                  Event e = new Event();                                    
                  e.Status__c = 'Planning';                  
                  Q1.add(new BapObjectiveModel(e,0,k));
              }
            }system.debug('@@ Q1 New::'+Q1);
            
            //=======For Quater 2=========
            Q2=new list<BapObjectiveModel>();            
            if(Q2.size() == 0){
              integer size2 = Q2.size();  
              for(integer k=1; k < 21; k++){ 
                  SEP_Objective__c objective = new SEP_Objective__c();
                  Event e = new Event();                                    
                  e.Status__c = 'Planning';                  
                  Q2.add(new BapObjectiveModel(e,0,k));
              }
            }
            //=======For Quater 3=========
            Q3=new list<BapObjectiveModel>();            
            if(Q3.size() == 0){
              integer size1 = Q3.size();  
              for(integer k=1; k < 21; k++){ 
                  SEP_Objective__c objective = new SEP_Objective__c();
                  Event e = new Event();                                    
                  e.Status__c = 'Planning';                  
                  Q3.add(new BapObjectiveModel(e,0,k));
              }
            }
            
            //=======For Quater 4=========
            Q4=new list<BapObjectiveModel>();            
            if(Q4.size() == 0){
              integer size4 = Q4.size();  
              for(integer k=1; k < 21; k++){ 
                  SEP_Objective__c objective = new SEP_Objective__c();
                  Event e = new Event();                                    
                  e.Status__c = 'Planning';                  
                  Q4.add(new BapObjectiveModel(e,0,k));
              }
            }   
                     
        }//End Of Else Portion         
        
        if(isNew == false)
            checkPDF = 'pdf';
        else{
            checkPDF ='';
            //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Sorry, Their is no record exist for display'));
        }
        
    }//End Of Constructor    
    
    //For Stratum Data Records in New Mode
    public Void init(){  
        //modelList = new   
        if(modelList  == null){ 
            modelList = new list<StratumModelClass>();                 
            for(integer r=0; r < 4;r++){
                StratumModelClass temp = new StratumModelClass();
                if(r==0){
                    temp.label = 'FGBI'; 
                    temp.Value1 = 0;
                    temp.Value2 = 0; 
                    temp.Value3 = 0; 
                    temp.Value4 = 0; 
                    modelList.add(temp); 
                }else if(r==1){
                    temp.label = 'Foam';                    
                    temp.Value1 = 0;
                    temp.Value2 = 0; 
                    temp.Value3 = 0; 
                    temp.Value4 = 0;  
                    modelList.add(temp); 
                }else if(r==2){
                    temp.label = 'ISSP'; 
                    temp.Value1 = 0;
                    temp.Value2 = 0; 
                    temp.Value3 = 0; 
                    temp.Value4 = 0;  
                    modelList.add(temp); 
                }else if(r==3){
                    temp.label = 'Optima'; 
                    temp.Value1 = 0;
                    temp.Value2 = 0; 
                    temp.Value3 = 0; 
                    temp.Value4 = 0;  
                    modelList.add(temp); 
                }
            }
        }
        system.debug('@@model'+modelList); 
        aggregateSize = 0;
        system.debug('@@ SIZE INIT ::::'+ aggregateSize);
    }
    
    //Get All The Existing Records of Stratum Data
    public void getStratumDateRecords()
    {
        if (sep1.Year__c != null)
        {
            currentYear = sep1.Year__c;
            // Calculate the previous year to get the actuals from.
            previousYear = String.valueOf(Integer.valueOf(currentYear) - 1);
        }
        else 
        {
            currentYear = '';
            previousYear = '';
        }
        if (sep1.Account__c != null)    
            accountId = sep1.Account__c;      
        
        //Set the variables to be used for labels in the VF page:-
        if (sep1.Year__c != null && currentYear != '')
        {            
            prevYear = String.valueOf(Integer.valueOf(currentYear) - 1) + ' Actuals';
            currYear = currentYear+ ' Goals';
            nextYear = String.valueOf(Integer.valueOf(currentYear) + 1) + ' Goals';
            next2Year = String.valueOf(Integer.valueOf(currentYear) + 2) + ' Goals';  
        }
        else
        {   
            //Set the variables to be used for labels in the VF page:-
            prevYear = '     Actuals';
            currYear = '     Goals';
            nextYear = '     1 Goals';
            next2Year ='     2 Goals';
        }
        existingSDList = new list<Stratum_Data__c>();
        list<Stratum_Data__c> actualSDList = new list<Stratum_Data__c>();
        productClassSet = new set<String>();
        //for Existing stratum object record.
        // We cannot count on the Gross_Sales_LY__c field to contain
        // any meaningful data when we are creating forecasts for a new
        // plan year; therefore, we have to execute two queries, one
        // for the current plan year and one for the previous year.
        existingSDList = 
            [SELECT Id,
                    Gross_Sales_LY__c,
                    Gross_Sales_CY__c,
                    Account_Name__c, 
                    Product_Class__c, 
                    Actual_Pounds_LY__c,
                    User_Target_Pounds_2YO__c, 
                    User_Target_Pounds_CY__c, 
                    User_Target_Pounds_NY__c 
               FROM Stratum_Data__c 
              WHERE (Account_Name__c = :accountId AND Year__c = :currentYear) 
                AND (Product_Class__c IN ('78', '61', '64', '62'))];
/*
        actualSDList = 
            [SELECT Id,
                    Gross_Sales_CY__c,
                    Account_Name__c, 
                    Product_Class__c
               FROM Stratum_Data__c 
              WHERE (Account_Name__c = :accountId AND Year__c = :previousYear) 
                AND (Product_Class__c IN ('78', '61', '64', '62'))];
                                               
        stratumDataMap = new map<String, Stratum_Data__c>();
        
        for (Stratum_Data__c sd : existingSDList)
        {
            stratumDataMap.put(sd.Product_Class__c, sd);
        }
        if (!stratumDataMap.containsKey('78'))
            stratumDataMap.put('78', new Stratum_Data__c(Product_Class__c = '78', Account_Name__c = sep1.Account__c, 
            Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0)); 
        if (!stratumDataMap.containsKey('61'))
            stratumDataMap.put('61', new Stratum_Data__c(Product_Class__c = '61', Account_Name__c = sep1.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0)); 
        if (!stratumDataMap.containsKey('64'))
            stratumDataMap.put('64', new Stratum_Data__c(Product_Class__c = '64', Account_Name__c = sep1.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0)); 
        if (!stratumDataMap.containsKey('62'))
            stratumDataMap.put('62', new Stratum_Data__c(Product_Class__c = '62', Account_Name__c = sep1.Account__c, Gross_Sales_CY__c = 0, User_Target_Pounds_CY__c = 0, User_Target_Pounds_NY__c = 0, User_Target_Pounds_2YO__c=0)); 
            
        modelList =  new list<StratumModelClass>();
        
        //Aggregate Query on Stratum data object:-
        /* Nagendra Commented on 28th jan
        list<AggregateResult> aggList = 
            [SELECT Product_Class__c pc,
                    SUM(Gross_Sales_LY__c) ap ,
                    SUM(User_Target_Pounds_2YO__c)utp2Y, 
                    SUM(User_Target_Pounds_CY__c) utpCY, 
                    SUM(User_Target_Pounds_NY__c) utpNY 
               FROM Stratum_Data__c 
              WHERE(Account_Name__c = :accountId AND Year__c = :currentYear) 
                AND (Product_Class__c = '78' OR Product_Class__c = '61' OR Product_Class__c = '64' OR Product_Class__c = '62') 
              GROUP BY Product_Class__c 
              ORDER BY Product_Class__c];
              //Nagendra Commented on 28th jan
             
        list<AggregateResult> aggList =
            [SELECT Product_Class__c pc,
                    Year__c year,
                    SUM(Gross_Sales_CY__c) ap,
                    SUM(User_Target_Pounds_2YO__c) utp2Y,
                    SUM(User_Target_Pounds_CY__c) utpCY,
                    SUM(User_Target_Pounds_NY__c) utpNY
               FROM Stratum_Data__c
              WHERE Account_Name__c = :accountId AND Year__c IN (:currentYear, :previousYear)
                AND Product_Class__c IN ('78', '61', '64', '62')
              GROUP BY Product_Class__c, Year__c
              ORDER BY Product_Class__c];
            
        
        aggregateSize = aggList.size(); //Store the size of the aggregate result.
        system.debug('@@ SIZE getStratumDateRecords ::::'+ aggregateSize);
        system.debug('@@ AggregateResult ::::'+ aggList);
         system.debug('@@ prevYear ::::'+ previousYear);
         system.debug('@@ curr Year ::::'+ currentYear);
        integer i=0;
        Map<Integer, StratumModelClass> modelMap = new map<Integer, StratumModelClass>();
        //Map<Integer, StratumModelClass> modelMapPrev = new map<Integer, StratumModelClass>();
        system.debug('@@ Aggregart Before::'+aggList);
        aggList.sort();
        StratumModelClass temp;
        system.debug('@@ Aggregart After::'+aggList);
        
        modelMap.put(1,new StratumModelClass());
        modelMap.put(2,new StratumModelClass());
        modelMap.put(3,new StratumModelClass());
        modelMap.put(4,new StratumModelClass());
        
        //modelMapPrev.put(1,new StratumModelClass());
        //modelMapPrev.put(2,new StratumModelClass());
        //modelMapPrev.put(3,new StratumModelClass());
        //modelMapPrev.put(4,new StratumModelClass());
        
        Boolean previous78 = false;
        Boolean previous61 = false;
        Boolean previous64 = false;
        Boolean previous62 = false;
        
        for(AggregateResult ar:aggList){
            ++i;
            String prodClass = (String)ar.get('pc');
            String years = (String)ar.get('year');
            //StratumModelClass temp ;
            //String prodClass = (String)ar.get('pc');
            if(prodClass == '78' && years == previousYear)                
            {
                //StratumModelClass temp ;                
                temp = modelMap.get(1);
                //temp.productClass = '78';
                //temp.label = 'FGBI';
                temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                //temp.Model_year = previousYear;
                modelList.add(temp);
                modelMap.put(1,temp);
                previous78 = true;
            }
            if(prodClass == '78' && years == currentYear)                
            {
                //StratumModelClass temp;                
                temp = modelMap.get(1);
                temp.productClass = '78';
                temp.label = 'FGBI';
                //temp.Model_year = currentYear;
                temp.Value2 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                temp.Value3 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                temp.Value4 = (Integer)((decimal)ar.get('utp2Y') != null && ar.get('utp2Y') !=''? (decimal)ar.get('utp2Y') :0);
                modelList.add(temp);
                modelMap.put(1,temp);
            }           
            if(prodClass == '61' && years == previousYear)
            {       
                //StratumModelClass temp ;             
                temp = modelMap.get(2);
               // temp.productClass = '61';
                //temp.label = 'ISSP';   
                //temp.Model_year = previousYear;
                temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                modelList.add(temp);
                modelMap.put(2,temp);
                previous61 = true;
            }
            if(prodClass == '61' && years == currentYear)
            {
                //StratumModelClass temp ;             
                temp = modelMap.get(2);
                temp.productClass = '61';
                temp.label = 'ISSP';    
                //temp.Model_year = currentYear;
                temp.Value2 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                temp.Value3 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                temp.Value4 = (Integer)((decimal)ar.get('utp2Y') != null && ar.get('utp2Y')!= ''? (decimal)ar.get('utp2Y') :0);                
                modelList.add(temp);
                modelMap.put(2,temp);
            }
            if(prodClass == '64' && years == previousYear)
            {   
                //StratumModelClass temp ;                 
                temp = modelMap.get(3);
                //temp.productClass = '64';
                //temp.label = 'Optima'; 
                //temp.Model_year = previousYear;              
                temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != '' ? (decimal)ar.get('ap') : 0);
                modelList.add(temp);
                modelMap.put(3,temp);
                previous64 = true;
            }
            if(prodClass == '64' && years == currentYear)
            {
                //StratumModelClass temp ;                 
                temp = modelMap.get(3);
                temp.productClass = '64';
                temp.label = 'Optima';
                //temp.Model_year =  currentYear; 
                temp.Value2 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                temp.Value3 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                temp.Value4 = (Integer)((decimal)ar.get('utp2Y') != null && ar.get('utp2Y')!= ''? (decimal)ar.get('utp2Y') :0);
                modelList.add(temp);
                modelMap.put(3,temp);
            }
            if(prodClass == '62' && years == previousYear)
            {     
                //StratumModelClass temp ;               
                temp = modelMap.get(4);
                //temp.productClass = '62';
                //temp.label = 'Foam'; 
                //temp.Model_year = previousYear;               
                temp.Value1 = (Integer)((decimal)ar.get('ap') != null && ar.get('ap') != ''? (decimal)ar.get('ap') : 0);
                modelList.add(temp);
                modelMap.put(4,temp);
                previous62 = true;
            } 
            if(prodClass == '62' && years == currentYear)
            {
                //StratumModelClass temp ;               
                temp = modelMap.get(4);
                temp.productClass = '62';
                temp.label = 'Foam';  
                //temp.Model_year = currentYear;
                temp.Value2 = (Integer)((decimal)ar.get('utpCY') != null && ar.get('utpCY') != ''? (decimal)ar.get('utpCY') : 0);
                temp.Value3 = (Integer)((decimal)ar.get('utpNY')!= null  && ar.get('utpNY') != ''? (decimal)ar.get('utpNY') : 0);
                temp.Value4 = (Integer)((decimal)ar.get('utp2Y') != null && ar.get('utp2Y')!= ''? (decimal)ar.get('utp2Y') :0);
                modelList.add(temp);
                modelMap.put(4,temp);
            } 
        }//End Of For Loop
        
        System.debug('modelMap:::'+modelMap);
        if(modelMap.get(1).label == null || modelMap.get(1).label == '')
        {
            System.debug('Inside FGBI');            
            temp = modelMap.get(1);
            temp.label = 'FGBI'; 
            //temp.Model_year = currentYear;
            temp.productClass = '78'; 
            //temp.Value1 = (temp.Value1 != null ? temp.Value1 : 0);
            temp.Value2 = 0; 
            temp.Value3 = 0; 
            temp.Value4 = 0;
            modelList.add(temp);
            modelMap.put(1,temp);
        }
        if(modelMap.get(2).label == null || modelMap.get(2).label == '')
        {
            System.debug('Inside ISSP');
            temp = modelMap.get(2);
            temp.label = 'ISSP'; 
            //temp.Model_year = currentYear;
            temp.productClass = '61'; 
            //temp.Value1 = (temp.Value1 != null ? temp.Value1 : 0);
            temp.Value2 = 0; 
            temp.Value3 = 0; 
            temp.Value4 = 0;
            modelList.add(temp);
            modelMap.put(2,temp);
        }
        if(modelMap.get(3).label == null || modelMap.get(3).label == '')
        {
            System.debug('Inside Optima');
            temp = modelMap.get(3);
            temp.label = 'Optima'; 
            //temp.Model_year = currentYear;
            temp.productClass = '64'; 
            //temp.Value1 = (temp.Value1 != null ? temp.Value1 : 0);
            temp.Value2 = 0; 
            temp.Value3 = 0; 
            temp.Value4 = 0;
            modelList.add(temp);
            modelMap.put(3,temp);
        }
        if(modelMap.get(4).label == null || modelMap.get(4).label == '')
        {
            System.debug('Inside Foam');
            temp = modelMap.get(4);
            temp.label = 'Foam'; 
            //temp.Model_year = currentYear;
            temp.productClass = '62'; 
            //temp.Value1 = (temp.Value1 != null ? temp.Value1 : 0);
            temp.Value2 = 0; 
            temp.Value3 = 0; 
            temp.Value4 = 0;
            modelList.add(temp);
            modelMap.put(4,temp);
        }
        if(!previous78)
        {
            temp = modelMap.get(1);
            temp.Value1 = 0;
            modelList.add(temp);
            modelMap.put(1,temp);
        }
        if(!previous61)
        {
            temp = modelMap.get(2);
            temp.Value1 = 0;
            modelList.add(temp);
            modelMap.put(2,temp);
        }
        if(!previous64)
        {
            temp = modelMap.get(3);
            temp.Value1 = 0;
            modelList.add(temp);
            modelMap.put(3,temp);
        }
        if(!previous62)
        {
            temp = modelMap.get(4);
            temp.Value1 = 0;
            modelList.add(temp);
            modelMap.put(4,temp);
        }
        system.debug('@@ Prev Model List'+modelList);
        system.debug('@@ Prev Model Map'+modelMap);
        /*list<StratumModelClass> tempModelList = new list<StratumModelClass>();
        if(modelList.size() > 0){
            integer listSize = modelList.size();
            for(integer r=0; r < listSize; r++){
                if(r == 0){
                   temp  = modelList[3];
                   tempModelList.add(temp);
                }else if(r == 1){
                    temp  = modelList[1]; 
                    tempModelList.add(temp);   
                }else if(r == 2){
                    temp  = modelList[0]; 
                    tempModelList.add(temp);   
                }else if(r == 3){
                     temp  = modelList[2]; 
                     tempModelList.add(temp);   
                }          
            }
        }
        
        //tempModelList.sort();
        system.debug('@@ Sort Temp List ::'+tempModelList);
        if(tempModelList.size() > 0){
            modelList = new list<StratumModelClass>();    
            modelList=tempModelList;
            system.debug('@@ Sort Model List ::'+modelList);
        }
        //modelList = modelMap.values();
        //modelList =  new list<StratumModelClass>();        
        
    // Sort it!
    system.debug('HERE: modelList=' + modelList);
        modelList = sortByProductClass(modelList);
    system.debug('HERE: modelList=' + modelList);
        
        //calling of total method:-
        total(modelList);
    }
    //Clonning Process
    public pageReference cloneBap() {
        system.debug('CLONE METHOD IN');
        if(sep1.Id != null) {
            list<SEP__c> sepList = [Select s.Year__c, s.Start_Date__c, 
                                        s.Stage__c, s.OwnerId, s.Notes__c, 
                                        s.Name, s.Map_Funds__c, s.Estimated_Fund_For_CY__c, s.Id, 
                                        s.End_Date__c, s.Description__c, 
                                        s.Account__c 
                                    From SEP__c s Where Id =: sep1.Id];
            if(sepList.size() > 0) {
                system.debug('BAP Record'+sepList[0].Id);
                selectedSep = new SEP__c();
                selectedSep.Stage__c = sepList[0].Stage__c;
                selectedSep.Start_Date__c = sepList[0].Start_Date__c.addYears(1);
                selectedSep.End_Date__c = sepList[0].End_Date__c.addYears(1);
                selectedSep.Description__c = sepList[0].Description__c;
                selectedSep.Account__c = sepList[0].Account__c;
                selectedSep.Year__c = String.valueOf(Integer.valueOf(sepList[0].Year__c) + 1);
                selectedSep.Map_Funds__c = sepList[0].Map_Funds__c;
                selectedSep.Notes__c = sepList[0].Notes__c;
           }     
            try{
                system.debug('BAP Record Before ::'+selectedSep);
                upsert selectedSep; //DML on Bap Record.
                
                system.debug('BAP Record After'+selectedSep);
            }catch(Exception ex){
               // iserror = false;
                system.debug('!!!!!!! Bap ::'+ ex.getMessage());                
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, ex.getMessage())); 
                return null;   
                
            }
            selectedGoals = new list<SEP_Goal__c>();
            list<SEP_Goal__c> oldGoals = [Select Id,Name,SEP__c,Goal_Number__c,Strategy__c,Start_Date__c,End_Date__c,Stage__c From SEP_Goal__c Where SEP__c =:sep1.Id];
            
            set<String> goalId = new set<String>(); // This Set contains the Goal Ids.
            map<String,String> goalIdMap = new map<String,String>();
            if(oldGoals != null && oldGoals.size() > 0){
                system.debug('Old Goal List ::'+oldGoals);
                for(SEP_Goal__c oldGoal:oldGoals){
                    selectedGoal = new SEP_Goal__c();
                    selectedGoal.Name = oldGoal.Name;
                    selectedGoal.Goal_Number__c = oldGoal.Goal_Number__c;
                    selectedGoal.Old_Gaol_Id__c = oldGoal.Id;
                    selectedGoal.SEP__c = selectedSep.Id;
                    selectedGoal.Strategy__c = oldGoal.Strategy__c;
                    selectedGoal.Start_Date__c = selectedSep.Start_Date__c;  //Set Bap Start date
                    selectedGoal.End_Date__c = selectedSep.End_Date__c;      //Set Bap End date
                    selectedGoal.Stage__c = oldGoal.Stage__c;
                    selectedGoals.add(selectedGoal);
                    goalId.add(oldGoal.Id);
                }
            }
            try{
                system.debug('New Goal List Before::'+selectedGoals);
                upsert selectedGoals;
                
                for(SEP_Goal__c newGoal:selectedGoals){
                    goalIdMap.put(newGoal.Old_Gaol_Id__c , newGoal.Id);  //This MAp Contains Old Gaol ID and New Goal ID.
                }
                system.debug('New Goal List After::'+selectedGoals);
            }catch(Exception e){
                //iserror = false;
                system.debug('!!!!!!! GoalList ::'+e.getMessage());
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, e.getMessage()));   
                return null;     
            }            
            
            selectedEvents = new list<Event>();
            if(!goalId.isEmpty()){
                list<Event> oldEventList =[SELECT AccountId,/*Goal_Number__c,Action_Plan__c,Id,Description,EndDateTime,
                                           RecordTypeId,Comments__c,WhatId,SEP_activity__c,                                 
                                           Subject,StartDateTime,/*Goal_Date__c, State__c, Status__c 
                                      FROM Event where WhatId in:goalId /*And Goal_Date__c != null];
                                       
                for(Event oldEvent :oldEventList){
                    Event newEvent = new Event();
                    //newEvent.Goal_Number__c =  oldEvent.Goal_Number__c;
                    newEvent.Action_Plan__c = oldEvent.Action_Plan__c;
                    newEvent.Description = oldEvent.Description;
                    
                    //integer year = oldEvent.Goal_Date__c.year()+1;
                    //integer month = oldEvent.Goal_Date__c.month();
                    //integer day = oldEvent.Goal_Date__c.day();
                    //newEvent.Goal_Date__c = date.valueOf(year + '-'+ month +'-'+ day +' 00:00:00'); 
                    //newEvent.StartDateTime = newEvent.Goal_Date__c;
                    //newEvent.EndDateTime = newEvent.Goal_Date__c;
                    
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
                system.debug('@@ selectedEvents Before::'+selectedEvents);
            try{
                if(selectedEvents.size() > 0)
                    upsert selectedEvents;
                
                system.debug('@@ selectedEvents After::'+selectedEvents);
            }Catch(Exception e){
                //iserror = false;
                system.debug('!!!!!!! EventList ::'+e.getMessage());
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, e.getMessage()));   
                return null;         
            }
        }
        pageReference pg = new pageReference('/apex/manageBap?id='+selectedSep.Id);
        pg.setRedirect(true);
        return pg;
        
    }//end of Clone Method
    
    /*-----------------------------------------------
    Sort the objective model list for decending order
    -------------------------------------------------    
    public list<BapObjectiveModel> sortCustom(list<BapObjectiveModel> QuaterList)
    {
        map<integer, BapObjectiveModel> sortMap = new map<integer, BapObjectiveModel>();
        list<BapObjectiveModel> resultList = new list<BapObjectiveModel>();
        for(BapObjectiveModel m : QuaterList)
        {                    
            sortMap.put(m.indexNo, m);                   
            
        }
        list<integer> keys = new list<integer>(sortMap.keySet());
        keys.sort();
        //for (Integer i = 20; i < keys.size(); i++)
        for (Integer i = keys.size() - 1; i >= 0; i--)                
        {
            resultList.add(sortMap.get(keys[i]));
        }
        return resultList;
    }
    
    /*-----------------------------------------------
    Sort the objective model list for ascending order
    -------------------------------------------------  
    public list<BapObjectiveModel> sortCustom1(list<BapObjectiveModel> QuaterList)
    {
        map<integer, BapObjectiveModel> sortMap = new map<integer, BapObjectiveModel>();
        list<BapObjectiveModel> resultList = new list<BapObjectiveModel>();
        for(BapObjectiveModel m : QuaterList)
        {                    
            sortMap.put(m.indexNo, m);                    
            
        }
        list<integer> keys = new list<integer>(sortMap.keySet());
        keys.sort();        
                 
        for (Integer i = 0; i < keys.size(); i++)        
        {
            resultList.add(sortMap.get(keys[i]));
        }
        return resultList;
    }
    
    /*-----------------------------------------------
    Sort the objective model list for ascending order for GoalIndexNo
    -------------------------------------------------   
    public list<BapObjectiveModel> sortCustom2(list<BapObjectiveModel> QuaterList)
    {
        map<integer, BapObjectiveModel> sortMap = new map<integer, BapObjectiveModel>();
        list<BapObjectiveModel> resultList = new list<BapObjectiveModel>();
        for(BapObjectiveModel m : QuaterList)
        {                    
            sortMap.put(m.GoalIndexNo, m);                    
            
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

    public list<GoalClass> sortByGoalNumber(list<GoalClass> goals)
    {
        map<String, GoalClass> sortMap = new map<String, GoalClass>();
        list<GoalClass> resultList = new list<GoalClass>();
        for (goalClass g : goals)
        {                    
            sortMap.put(g.sepGoal.Goal_Number__c, g);                 
        }
        list<String> keys = new list<String>(sortMap.keySet());
        keys.sort();
        for (Integer i = 0; i < keys.size(); i++)        
        {
            resultList.add(sortMap.get(keys[i]));
        }
        return resultList;
    }
        
    
    /*-------------------------------------------------------------------------------
    This Function Set the headings of Stratum data Table when user insert Plan Year:
    ---------------------------------------------------------------------------------
    
    public void setHeadingsAccordingToYear(){
        system.debug('@@YEAR ::'+getYear);
        if(getYear != null && getYear.trim().length() == 4){
            prevYear = String.valueOf(Integer.valueOf(getYear) - 1)+ ' Actuals';
            currYear = getYear+ ' Goals';
            nextYear = String.valueOf(Integer.valueOf(getYear) + 1)+ ' Goals';
            next2Year = String.valueOf(Integer.valueOf(getYear) + 2)+' Goals'; 
        }else{
            prevYear = '     Actuals';
            currYear = '     Goals';
            nextYear = '     1 Goals';
            next2Year ='     2 Goals';
        }
        //Validate that there is only one BAP for an Account and Year.
        if(sep1.Year__c != null && sep1.Year__c.trim().length() < 4){
                //iserror = true;
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Please Enter a Valid Year in Plan Year.'));    
        }
        if(sep1.Account__c != null && sep1.Year__c != null){
            system.debug('***********************');
            if(sep1.Year__c.trim().length() < 4){
                system.debug('&&&&&&&&&&&&&&&&'+sep1.Year__c);
                //iserror = true;
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Please enter a valid Year in Plan Year.'));    
            }
            list<SEP__c> sepList = [Select Id, Year__c, Account__c, Name From SEP__c Where Account__c =:sep1.Account__c];            
            if(sepList != null && sepList.size() > 0){
                for(SEP__c sep : sepList) {
                    if(sep1.Year__c == sep.Year__c){
                        //iserror = true;
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Sorry, but an BAP for the selected Account and Year already exists.'));
                        certainTeedName = '';                        
                        //break;
                    }                    
                    else{     
                        if(sep1.Year__c == null){
                            //iserror = true;
                            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Required Field Missing: Plan Year'));            
                        }
                        else{                   
                            //iserror = false;
                            Account acc = [Select id ,name,OwnerId,Owner.Name From Account  Where Id =:sep1.Account__c];
                            certainTeedName = acc.Owner.Name; 
                            //getStratumDateRecords();
                            //init();
                        }
                    }
                }
            }
            getStratumDateRecords();
        }else if(sep1.Account__c == null){
            init();
        }
    }//End of Set Headings method
    
    /*-------------------------------------------------------------------
    Method to Set CertainTeedName on the behalf of Account Owner Name.
    ---------------------------------------------------------------------
    
    public void getcertainTeedName(){        
        certainTeedName = '';        
        if(sep1.Account__c != null){
            Account acc = [Select id ,name,OwnerId,Owner.Name From Account  Where Id =:sep1.Account__c]; 
            system.debug('@@AccountRecord==>'+acc);
            certainTeedName += acc.Owner.Name;  
        }else{ 
            certainTeedName = '';
            //init();
            getStratumDateRecords();
        }
        //Validate that there is only one BAP for an Account and Year.
        if(sep1.Account__c != null && sep1.Year__c != null){
            getStratumDateRecords();
            list<SEP__c> sepList = [Select Id, Year__c, Account__c, Name From SEP__c Where Account__c =:sep1.Account__c];            
            if(sepList != null && sepList.size() > 0){
                for(SEP__c sep : sepList) {
                    if(sep1.Year__c == sep.Year__c){
                        //iserror = true;
                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Sorry, but an BAP for the selected Account and Year already exists.'));
                        certainTeedName = '';                        
                        break;
                    }
                }
            }
        }
    }//End of Set CertainTeedName method    
    
    
    
    /*----------------------------------------
    Method for finally save all the records
    -----------------------------------------   
    public pageReference save(){ 
        
        try{
            if(sep1.Account__c == null){
                //iserror = true;
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Account must be present.'));
                return null;
            }
            if(sep1.Year__c == ''){
                //iserror = true;
                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Plan Year must be present.'));
                return null;
            }
            else{
                //iserror = false;
                
                sep1.Start_Date__c = date.valueOf(sep1.Year__c + '-1-1 00:00:00');
                sep1.End_Date__c = date.valueOf(sep1.Year__c + '-12-31 11:59:59');
                
                if(sep1 != null)
                    upsert sep1;
                SEP__c sepObj = [Select id from SEP__c where Id =:sep1.Id];
                system.debug('@@ SEP'+sepObj.Id); 
                //For loop for stratum data model class
                list<Stratum_Data__c> sdList;
                list<Stratum_Data__c> sdList1;
                list<Stratum_Data__c> sdList2;
                list<Stratum_Data__c> sdList3;
                list<Stratum_Data__c> sdList4;
                map<Id,String> sdMap1 = new map<Id,String>();
                map<Id,String> sdMap2 = new map<Id,String>();
                map<Id,String> sdMap3 = new map<Id,String>();
                map<Id,String> sdMap4 = new map<Id,String>();
                
                //Getting a values from page.
                String cy1 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:0:v1');
                String cy2 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:1:v1');
                String cy3 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:2:v1');
                String cy4 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:3:v1');
                String ny1 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:0:v2');
                String ny2 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:1:v2');
                String ny3 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:2:v2');
                String ny4 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:3:v2');
                String yo1 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:0:v3');
                String yo2 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:1:v3');
                String yo3 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:2:v3');
                String yo4 = ApexPages.CurrentPage().getParameters().get('pg:frm:pb1:rpt:3:v3');
                System.debug('cy1:::'+cy1);
                System.debug('cy2:::'+cy2);
                System.debug('cy3:::'+cy3);
                System.debug('cy4:::'+cy4);
                System.debug('ny1:::'+ny1);
                System.debug('ny2:::'+ny2);
                System.debug('ny3:::'+ny3);
                System.debug('ny4:::'+ny4);
                System.debug('yo1:::'+yo1);
                System.debug('yo2:::'+yo2);
                System.debug('yo3:::'+yo3);
                System.debug('yo4:::'+yo4);
                
                Boolean isExisting;
                //Checking of Existing Stratum data records.
                If(aggregateSize != 0){
                    isExisting = true;
                    sdList1 = new list<Stratum_Data__c>();
                    sdList2 = new list<Stratum_Data__c>();
                    sdList3 = new list<Stratum_Data__c>();
                    sdList4 = new list<Stratum_Data__c>();
                    System.debug('modelList:::'+modelList);
                    System.debug('stratumDataMap:::'+stratumDataMap);
                    if (sep1.Year__c != null)
                    {
                        currentYear = sep1.Year__c;                       
                        previousYear = String.valueOf(Integer.valueOf(currentYear) - 1);
                    }
                    system.debug('MODEL CLASS ::::'+modelList);
                    for(StratumModelClass sdModel : modelList){                        
                        if(sdModel.productClass == '78' && sdModel.label == 'FGBI'){
                             Stratum_Data__c sd = stratumDataMap.get('78');   
                             sd.Product_Class__c = '78';
                             //sd.Account_Name__c = sep1.Account__c;
                             sd.Year__c  = sep1.Year__c;
                             //sd.Gross_Sales_CY__c = (sdModel.Value1 == null ? 0 : sdModel.Value1);
                             sd.User_Target_Pounds_CY__c = (sdModel.Value2 == null ? 0 : sdModel.Value2);
                             sd.User_Target_Pounds_NY__c = (sdModel.Value3 == null ? 0 : sdModel.Value3);
                             sd.User_Target_Pounds_2YO__c= (sdModel.Value4 == null ? 0 : sdModel.Value4);
                             sdList1.add(sd);   
                             system.debug('Product Class1st :: 78'+sdList1);      
                             If(sdList1 != null && sdList1.size() > 0)
                                 sdMap1.put(sdList1[0].Id,sdList1[0].Product_Class__c); 
                                 system.debug('MAP :: 78'+sdMap1);                                                           
                            
                        }else if(sdModel.productClass == '62' && sdModel.label == 'Foam'){
                             Stratum_Data__c sd = stratumDataMap.get('62');   
                             sd.Product_Class__c = '62';
                             //sd.Account_Name__c = sep1.Account__c;
                             sd.Year__c  = sep1.Year__c;
                             //sd.Gross_Sales_CY__c = (sdModel.Value1 == null ? 0 : sdModel.Value1);
                             sd.User_Target_Pounds_CY__c = (sdModel.Value2 == null ? 0 : sdModel.Value2);
                             sd.User_Target_Pounds_NY__c = (sdModel.Value3 == null ? 0 : sdModel.Value3);
                             sd.User_Target_Pounds_2YO__c= (sdModel.Value4 == null ? 0 : sdModel.Value4);
                             sdList2.add(sd); 
                             system.debug('Product Class1st :: 62'+sdList2);           
                             if(sdList2 != null && sdList2.size() > 0)
                                 sdMap2.put(sdList2[0].Id,sdList2[0].Product_Class__c);   
                                 system.debug('MAP :: 62'+sdMap2);      
                                                     
                        }else if(sdModel.productClass == '61' && sdModel.label == 'ISSP'){
                             Stratum_Data__c sd = stratumDataMap.get('61');  
                             sd.Product_Class__c = '61';
                             //sd.Account_Name__c = sep1.Account__c;
                             sd.Year__c  = sep1.Year__c;
                             //sd.Gross_Sales_CY__c = (sdModel.Value1 == null ? 0 : sdModel.Value1); 
                             sd.User_Target_Pounds_CY__c = (sdModel.Value2 == null ? 0 : sdModel.Value2);
                             sd.User_Target_Pounds_NY__c = (sdModel.Value3 == null ? 0 : sdModel.Value3);
                             sd.User_Target_Pounds_2YO__c= (sdModel.Value4 == null ? 0 : sdModel.Value4);
                             sdList3.add(sd);  
                             system.debug('Product Class1st :: 61'+sdList3);          
                             if(sdList3 != null && sdList3.size() > 0)
                                 sdMap3.put(sdList3[0].Id,sdList3[0].Product_Class__c);      
                                 system.debug('MAP :: 61'+sdMap3);     
                                               
                        }else if(sdModel.productClass == '64' && sdModel.label == 'Optima'){
                             Stratum_Data__c sd = stratumDataMap.get('64');   
                             sd.Product_Class__c = '64';
                             //sd.Account_Name__c = sep1.Account__c;
                             sd.Year__c  = sep1.Year__c;
                             //sd.Gross_Sales_CY__c = (sdModel.Value1 == null ? 0 : sdModel.Value1);
                             sd.User_Target_Pounds_CY__c = (sdModel.Value2 == null ? 0 : sdModel.Value2);
                             sd.User_Target_Pounds_NY__c = (sdModel.Value3 == null ? 0 : sdModel.Value3);
                             sd.User_Target_Pounds_2YO__c= (sdModel.Value4 == null ? 0 : sdModel.Value4);
                             sdList4.add(sd);      
                             system.debug('Product Class1st ::64'+sdList4);      
                             if(sdList4 != null && sdList4.size() > 0)
                                 sdMap4.put(sdList4[0].Id,sdList4[0].Product_Class__c);     
                                 system.debug('MAP :: 64'+sdMap4);                                                   
                        } 
                    }
                    //For loop for existing list of stratum data.                    
                    for(Stratum_Data__c sd1 : existingSDList){                        
                        if(sd1.Product_Class__c == '78'){
                            if(!sdMap1.containsKey(sd1.Id)){
                                 //sd1.Gross_Sales_LY__c = 0;
                                 sd1.User_Target_Pounds_CY__c = 0;
                                 sd1.User_Target_Pounds_NY__c = 0;
                                 sd1.User_Target_Pounds_2YO__c = 0;                                  
                                 sdList1.add(sd1);  
                                 system.debug('Product Class :: 78'+sdList1);
                             }    
                        }else if(sd1.Product_Class__c == '61'){
                             if(!sdMap3.containsKey(sd1.Id)){
                                 //sd1.Gross_Sales_LY__c = 0;
                                 sd1.User_Target_Pounds_CY__c = 0;
                                 sd1.User_Target_Pounds_NY__c = 0;
                                 sd1.User_Target_Pounds_2YO__c = 0;                                  
                                 sdList3.add(sd1); 
                                 system.debug('Product Class :: 61'+sdList3); 
                             }      
                        }else if(sd1.Product_Class__c == '64'){
                            if(!sdMap4.containsKey(sd1.Id)){
                                 //sd1.Gross_Sales_LY__c = 0;
                                 sd1.User_Target_Pounds_CY__c = 0;
                                 sd1.User_Target_Pounds_NY__c = 0;
                                 sd1.User_Target_Pounds_2YO__c = 0;                                  
                                 sdList4.add(sd1);
                                 system.debug('Product Class :: 64'+sdList4);  
                             }          
                        }else if(sd1.Product_Class__c == '62'){
                             if(!sdMap2.containsKey(sd1.Id)){
                                 //sd1.Gross_Sales_LY__c = 0;
                                 sd1.User_Target_Pounds_CY__c = 0;
                                 sd1.User_Target_Pounds_NY__c = 0;
                                 sd1.User_Target_Pounds_2YO__c = 0;                                  
                                 sdList2.add(sd1);  
                                 system.debug('Product Class :: 62'+sdList2);   
                             }         
                        }                        
                    }//end of for loop of stratum data list.
                }else{
                    isExisting = false;
                    //fillModelClassSD();                    
                    
                    system.debug('@@Val1 :'+cy1+'@@Val2 :'+ny1);
                    
                    system.debug('@@ New SD Model List'+modelList);
                    sdList = new list<Stratum_Data__c>();
                    for(StratumModelClass sdModel :modelList){
                        Stratum_Data__c sd;
                        if(sdModel.label == 'FGBI'){  
                        
                            sd = new Stratum_Data__c();
                            sd.Product_Class__c = '78';
                            sd.Account_Name__c = sep1.Account__c;
                            //if(sd.Year__c == '')
                                sd.Year__c  = sep1.Year__c;
                                
                            //sd.Gross_Sales_CY__c = sdModel.Value1;
                            
                            cy1=(cy1 == '' ? '0':cy1);
                            sd.User_Target_Pounds_CY__c = (cy1 != null ||cy1 !=''? decimal.valueOf(cy1) :0);
                            ny1=(ny1 == '' ? '0':ny1);
                            sd.User_Target_Pounds_NY__c = (ny1 != null ||ny1 !=''? decimal.valueOf(ny1) :0);
                            yo1=(yo1 == '' ? '0':yo1);
                            sd.User_Target_Pounds_2YO__c= (yo1 != null ||yo1 !=''? decimal.valueOf(yo1) :0);
                            sdList.add(sd);
                            
                        }else if(sdModel.label == 'Foam'){ 
                        
                            sd = new Stratum_Data__c();
                            sd.Product_Class__c = '62';
                            sd.Account_Name__c = sep1.Account__c;
                            
                            //if(sd.Year__c == '')
                                sd.Year__c  = sep1.Year__c;
                                
                            //sd.Gross_Sales_CY__c = sdModel.Value1;                            
                            cy2=(cy2 == '' ? '0':cy2);
                            sd.User_Target_Pounds_CY__c = (cy2!= null ||cy2!=''? decimal.valueOf(cy2) :0);
                            ny2=(ny2 == '' ? '0':ny2);
                            sd.User_Target_Pounds_NY__c = (ny2!= null ||ny2!=''? decimal.valueOf(ny2) :0);
                            yo2=(yo2 == '' ? '0':yo2);
                            sd.User_Target_Pounds_2YO__c= (yo2!= null ||yo2!=''? decimal.valueOf(yo2) :0); 
                            sdList.add(sd);
                            
                        }else if(sdModel.label == 'ISSP'){ 
                        
                            sd = new Stratum_Data__c();
                            sd.Product_Class__c = '61';
                            sd.Account_Name__c = sep1.Account__c;
                            
                            //if(sd.Year__c == '')
                                sd.Year__c  = sep1.Year__c;
                                
                            //sd.Gross_Sales_CY__c = sdModel.Value1;
                            
                            cy3=(cy3 == '' ? '0':cy3);
                            sd.User_Target_Pounds_CY__c = (cy3!= null ||cy3!=''?decimal.valueOf(cy3):0);
                            ny3=(ny3 == '' ? '0':ny3);
                            sd.User_Target_Pounds_NY__c = (ny3!= null ||ny3!=''?decimal.valueOf(ny3):0);
                            yo3=(yo3 == '' ? '0':yo3);
                            sd.User_Target_Pounds_2YO__c= (yo3!= null ||yo3!=''?decimal.valueOf(yo3):0);
                            sdList.add(sd);
                            
                        }else if(sdModel.label == 'Optima'){  
                        
                            sd = new Stratum_Data__c();
                            sd.Product_Class__c = '64';
                            sd.Account_Name__c = sep1.Account__c;
                            
                           // if(sd.Year__c == '')
                                sd.Year__c  = sep1.Year__c;
                                
                            //sd.Gross_Sales_LY__c = sdModel.Value1;
                            cy4=(cy4 == '' ? '0':cy4);
                            sd.User_Target_Pounds_CY__c = (cy4!= null ||cy4!=''? decimal.valueOf(cy4):0);
                            ny4=(ny4 == '' ? '0':ny4);
                            sd.User_Target_Pounds_NY__c = (ny4!= null ||ny4!=''? decimal.valueOf(ny4):0);
                            yo4=(yo4 == '' ? '0':yo4);
                            sd.User_Target_Pounds_2YO__c= (yo4!= null ||yo4!=''? decimal.valueOf(yo4):0); 
                            sdList.add(sd);
                        }                        
                    }    
                    system.debug('@@@@stratum data save point1'+sdList);
                }
                
                //DML for Stratum Data
                list<Stratum_Data__c> tempSdList1 = new list<Stratum_Data__c>();
                if(sdList1 != null && sdList1.size() > 0)
                    tempSdList1.addAll(sdList1);
                if(sdList2 != null && sdList2.size() > 0)
                    tempSdList1.addAll(sdList2);
                if(sdList3 != null && sdList3.size() > 0)
                    tempSdList1.addAll(sdList3);
                if(sdList4 != null && sdList4.size() > 0)
                    tempSdList1.addAll(sdList4);
                if(sdList != null && sdList.size() > 0)
                    tempSdList1.addAll(sdList); 
                
                //Upsert
                if(tempSdList1.size() > 0)
                    upsert tempSdList1;
                    
                
                //Calling of total Method:-
                total(modelList);
                
                /*For loop on Goal Model class
                // Iinitialize a new local list of goals.
                list<SEP_Goal__c> goalList = new list<SEP_Goal__c>();
                // Re-initialize a public map of goals by Goal Number.    
                indexIdGoalMAP = new map<Integer, SEP_Goal__c>();            
                // Loop over all Goals.
                // This list may contain a mix of existing and new records;
                // it is guaranteed to be exactly 10 elements long.
                // In order to guarantee that we are processing these
                // goals in the correct order, we'll sort the list first.
//                goalModelList = sortByGoalNumber(goalModelList);
                for (GoalClass goalModel : goalModelList)
                {
                    // If the goal is set, process it.
                    // We have 10 elements in the list, and blank elements
                    // are not saved.
                    if (goalModel.sepGoal.Name != null && goalModel.sepGoal.Name.trim().length() > 0)
                    {
                        // If the goal hasn't been saved yet,
                        if (goalModel.sepGoal.Id == null)
                        {                    
                            //goalModel.sepGoal.Name = String.valueOf(goalModel.indexNo);
                            goalModel.sepGoal.Goal_Number__c = String.valueOf(goalModel.indexNo);
                            goalModel.sepGoal.Start_Date__c = sep1.Start_Date__c;
                            goalModel.sepGoal.End_Date__c  =  sep1.End_Date__c;                     
                            goalModel.sepGoal.Stage__c = 'Planning';                        
                            goalModel.sepGoal.SEP__c = sep1.Id;
                            goalList.add(goalModel.sepGoal);
                            indexIdGoalMAP.put(goalModel.indexNo,goalModel.sepGoal);
                            system.debug('@@ indexIdGoalMAP If::'+ indexIdGoalMAP);
                        }else{
                            goalModel.sepGoal.Goal_Number__c = String.valueOf(goalModel.indexNo);
                            goalModel.sepGoal.Start_Date__c = sep1.Start_Date__c;
                            goalModel.sepGoal.End_Date__c  =  sep1.End_Date__c;
                            goalList.add(goalModel.sepGoal); 
                            indexIdGoalMAP.put(goalModel.indexNo,goalModel.sepGoal);       
                            system.debug('@@ indexIdGoalMAP Else::'+ indexIdGoalMAP);
                        }
                                                
                    }
                }//End of for loop of goal Model class.
                
                //DML on Bap_Goal type Map.
                if(indexIdGoalMAP != null && !indexIdGoalMAP.isEmpty()){
                    system.debug('@@ indexIdGoalMAP Before::'+ indexIdGoalMAP);
                    upsert indexIdGoalMAP.values();
                    system.debug('@@ indexIdGoalMAP After::'+ indexIdGoalMAP);
                }
                //DML for Goal List
                //if(goalList.size() > 0){
                    //upsert goalList;                    
                //}               
                 
                //Commented by Nagendra
                map<String,String> rtMap = new map<String,String>();
                list<RecordType> rtList = [Select Id,Name From RecordType where SObjectType='Event'];
                
                    for(RecordType rt:rtList)
                        rtMap.put(rt.Name,rt.Id);
                        
                list<SEP_Objective__c> objList = new list<SEP_Objective__c>();
                map<Integer, SEP_Objective__c> objListMap = new map<Integer, SEP_Objective__c>();
                list<Event> eventList = new list<Event>();
                list<BapObjectiveModel> blankListQ1 =  new list<BapObjectiveModel>();
                
               //=============For Quater 1==============   
                Q1 = sortCustom(Q1);   //Sort Quater1 List In Descending Order.
                
                for(BapObjectiveModel objModel:Q1){
                    System.debug('objModel.evnt::' + objModel.evnt);
                    if(objModel.evnt.whatId == null){                        
                        //if(objModel.evnt.Goal_Number__c == null && (objModel.evnt.Goal_Date__c != null || objModel.evnt.Action_Plan__c != null)){
                            //iserror = true;
                            /*Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Required Field Missing: Goal Number'));    
                            return null;*/
                        /*}else*/ //if(objModel.evnt.Goal_Number__c != null){
                            //if(objModel.evnt.Goal_Date__c == null){ 
                               // iserror = true;
                                /*Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Required Field Missing: Goal Date'));    
                                return null;
                            //}
                            if(objModel.evnt.Action_Plan__c == null){
                                //iserror = true;
                                Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Required Field Missing: Action Step'));
                                return null;
                            }else{   
                                if(objModel.evnt.Comments__c !=null){
                                    //system.debug('indexIdGoalMAP.containsKey(integer.valueOf(objModel.evnt.Goal_Number__c))' + indexIdGoalMAP.containsKey(integer.valueOf(objModel.evnt.Goal_Number__c)));
                                    system.debug('');
                                    //if(indexIdGoalMAP.containsKey(integer.valueOf(objModel.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(objModel.evnt.Goal_Number__c)).Id != null){
                                        system.debug('@@ Nagendra'+indexIdGoalMAP);
                                        //objModel.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(objModel.evnt.Goal_Number__c)).Id; 
                                        /*if(objModel.GoalIndexNo == 0){
                                            if(!indexMAP.isEmpty() && indexMAP.containsKey(objModel.evnt.WhatId)){
                                                system.debug('@@Goal number 0 ::');
                                                objModel.GoalIndexNo =  indexMAP.get(objModel.evnt.WhatId);
                                                objModel.evnt.Goal_Number__c = String.valueOf(objModel.GoalIndexNo);
                                                system.debug('@@Goal number Actuall ::'+objModel.GoalIndexNo);
                                            }                                            
                                        }
                                        //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                            //iserror = true;
                                            //Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.   
                                            //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date must lie within the BAP year: '+sep1.Year__c));
                                            //return null;
                                        //}
                                    //}else{
                                       // iserror = true;
                                        //Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                                        //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal mismatch Error: Selected Goal in the Objective does not exists. Please select a valid Goal Number.'));
                                        //return null;
                                    //}
                                    //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                       // iserror = true;
                                        //Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                                        //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date must lie within the BAP year:  '+sep1.Year__c));
                                        //return null;
                                    //}
                                    //if(objModel.evnt.Goal_Date__c.month() > 3){
                                        //Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                                        //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Goal date must fall within the first quarter.'));
                                        //return null;    
                                    //}
                                    if(!rtMap.isEmpty())
                                        objModel.evnt.RecordTypeId = rtMap.get('BAP Event');
                                        
                                    //objModel.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                                    objModel.evnt.Subject = objModel.evnt.Action_Plan__c;
                                    //objModel.evnt.EndDateTime = objModel.evnt.Goal_Date__c;                                    
                                    eventList.add(objModel.evnt);
                                    
                                    if(blankListQ1.size() > 0){                                        
                                        for(BapObjectiveModel mod : blankListQ1){                                            
                                            //if(indexIdGoalMAP.containsKey(integer.valueOf(mod.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id != null){
                                                //mod.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id; 
                                            //}else{
                                               // iserror = true;
                                                Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal mismatch Error: Selected Goal in the Objective does not exists. Please select a valid Goal Number.'));
                                                return null;
                                            //}  
                                            
                                            /*mod.evnt.RecordTypeId = objModel.evnt.RecordTypeId;   
                                            mod.evnt.Comments__c = objModel.evnt.Comments__c;  
                                            mod.evnt.Subject = mod.evnt.Action_Plan__c;
                                            //mod.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                                            //mod.evnt.EndDateTime = objModel.evnt.Goal_Date__c; 
                                            eventList.add(mod.evnt);                                           
                                        }                                        
                                        blankListQ1.clear();
                                    }
                                }else if(objModel.evnt.Comments__c == null){
                                    blankListQ1.add(objModel);
                                }                                 
                            }    
                        //}
                    }else{   //For Existing Records
                        if(objModel.evnt.Comments__c !=null){
                            //system.debug('***** Validation on DAte for Existing ::'+objModel.evnt.Goal_Date__c);
                            //Validation To Check Goal Date is not Blank
                            //if(objModel.evnt.Goal_Date__c == null){ 
                                //system.debug('**** Validation on DAte for Existing IF::'+objModel.evnt.Goal_Date__c);
                                //iserror = true;
                                //Q1 = sortCustom1(Q1);
                                //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Date must be present.'));  
                                //return null; 
                            //}
                            //Validation for Year 
                            //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                //iserror = true;
                                //Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                               //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                               // return null;
                            //}
                            //Validation for Quater Wise Date
                            //if(objModel.evnt.Goal_Date__c.month() > 3){
                                //Q1 = sortCustom1(Q1);  //Sort Quater1 List In Ascending Order.
                                //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 1: Goal date must fall within the first quarter.'));
                                //return null;    
                            //}
                            //Validation To Check Action Step i.e Action_Plan__c is not Blank
                            if(objModel.evnt.Action_Plan__c == null){
                                //iserror = true;
                                Q1 = sortCustom1(Q1);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Action Step must be present.'));
                                return null;
                            }
                            //else eventList.add(objModel.evnt);   //Add Events in Event Type List.
                            if(!rtMap.isEmpty())
                                objModel.evnt.RecordTypeId = rtMap.get('BAP Event');
                                        
                            //objModel.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                            objModel.evnt.Subject = objModel.evnt.Action_Plan__c;
                            //objModel.evnt.EndDateTime = objModel.evnt.Goal_Date__c;                                    
                            eventList.add(objModel.evnt);         //Add Events in Event Type List.
                            
                            if(blankListQ1.size() > 0){                   
                                for(BapObjectiveModel mod : blankListQ1){
                                    system.debug('@@ indexIdGoalMAP IF::'+indexIdGoalMAP);
                                    //if(indexIdGoalMAP.containsKey(integer.valueOf(mod.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id != null){
                                       /// mod.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id; 
                                    //}else{
                                       // iserror = true;
                                        Q1 = sortCustom1(Q1);
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                        return null;
                                    //}
                                    /*mod.evnt.RecordTypeId = objModel.evnt.RecordTypeId;  
                                    mod.evnt.Subject = mod.evnt.Action_Plan__c;   
                                    mod.evnt.Comments__c = objModel.evnt.Comments__c;  
                                    //mod.evnt.EndDateTime = objModel.evnt.Goal_Date__c;  
                                    //mod.evnt.StartDateTime = objModel.evnt.Goal_Date__c; 
                                    eventList.add(mod.evnt);
                                    system.debug('@@ eventList ELSE::'+eventList);
                                }                                        
                                blankListQ1.clear();
                            }     
                        }else if(objModel.evnt.Comments__c == null){
                            blankListQ1.add(objModel);
                        }                                  
                    }
                }        
                if(blankListQ1.size() > 0){
                   // iserror = true;
                    Q1 = sortCustom1(Q1);
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarterly Objectives must be enter at the first index.'));    
                    return null;    
                }        
                Q1 = sortCustom1(Q1); //Again sort the Q1 List in ascending order
                
                //=============For Quater 2==============   
                list<BapObjectiveModel> blankListQ2 =  new list<BapObjectiveModel>();
                Q2 = sortCustom(Q2);   //Sort Quater2 List In Descending Order.
                system.debug('@@@ Before Quater2List ::'+Q2);
                for(BapObjectiveModel objModel:Q2){
                    system.debug('@@@ Quater2List ::'+Q2);
                    //system.debug('!!!!!!!!!! Goal Date ::'+objModel.evnt.Goal_Date__c);
                    if(objModel.evnt.whatId == null){                        
                        //if((objModel.evnt.Goal_Number__c == null && (objModel.evnt.Goal_Date__c != null || objModel.evnt.Action_Plan__c != null))){
                           // iserror = true;
                            //Q2 = sortCustom1(Q2);  //Sort Quater2 List In Ascending Order.
                            //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Number must be selected.'));    
                            //return null;
                        //}else 
                        //if(objModel.evnt.Goal_Number__c != null){
                            //if(objModel.evnt.Goal_Date__c == null){ 
                               // iserror = true;
                                //Q2 = sortCustom1(Q2);  //Sort Quater2 List In Ascending Order.
                                //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Date must be present.'));    
                                //return null;
                            //}
                            if(objModel.evnt.Action_Plan__c == null){
                                //iserror = true;
                                Q2 = sortCustom1(Q2);  //Sort Quater2 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Action Step must be present.'));
                                return null;
                            }else{   
                                if(objModel.evnt.Comments__c !=null){
                                    //if(indexIdGoalMAP.containsKey(integer.valueOf(objModel.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(objModel.evnt.Goal_Number__c)).Id != null){
                                        //objModel.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(objModel.evnt.Goal_Number__c)).Id; 
                                        /*if(objModel.GoalIndexNo == 0){
                                            if(!indexMAP.isEmpty() && indexMAP.containsKey(objModel.evnt.WhatId)){
                                                system.debug('@@Goal number 0 ::');
                                                objModel.GoalIndexNo =  indexMAP.get(objModel.evnt.WhatId);
                                                objModel.evnt.Goal_Number__c = String.valueOf(objModel.GoalIndexNo);
                                                system.debug('@@Goal number Actuall ::'+objModel.GoalIndexNo);
                                            }                                            
                                        }
                                        //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                           // iserror = true;
                                            //Q2 = sortCustom1(Q2);  //Sort Quater2 List In Ascending Order.   
                                            //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                            //return null;
                                        //}
                                    //}else{
                                        //iserror = true;
                                        //Q2 = sortCustom1(Q2);  //Sort Quater2 List In Ascending Order.
                                        //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                        //return null;
                                    //}
                                    //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                       // iserror = true;
                                        //Q2 = sortCustom1(Q2);  //Sort Quater2 List In Ascending Order.
                                        //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                        //return null;
                                    //}if(!(objModel.evnt.Goal_Date__c.month() > 3 && objModel.evnt.Goal_Date__c.month() < 7)){
                                        //Q2 = sortCustom1(Q2);  //Sort Quater1 List In Ascending Order.
                                        //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Goal date must fall within the second quarter.'));
                                        //return null;    
                                    //}
                                    if(!rtMap.isEmpty())
                                        objModel.evnt.RecordTypeId = rtMap.get('BAP Event');
                                        
                                    //objModel.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                                    objModel.evnt.Subject = objModel.evnt.Action_Plan__c;
                                    //objModel.evnt.EndDateTime = objModel.evnt.Goal_Date__c;                                    
                                    eventList.add(objModel.evnt);
                                    system.debug('@@@ objModel eventList ::'+eventList);
                                     
                                    if(blankListQ2.size() > 0){   
                                        system.debug('@@ BlankList new IF ::'+blankListQ2);                                     
                                        for(BapObjectiveModel mod : blankListQ2){                                            
                                            //if(indexIdGoalMAP.containsKey(integer.valueOf(mod.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id != null){
                                             //   mod.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id; 
                                            //}else{
                                                //iserror = true;
                                                Q2 = sortCustom1(Q2);  //Sort Quater2 List In Ascending Order.
                                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                                return null;
                                            //}  
                                            
                                            /*mod.evnt.RecordTypeId = objModel.evnt.RecordTypeId;
                                            mod.evnt.Comments__c = objModel.evnt.Comments__c;  
                                            mod.evnt.Subject = mod.evnt.Action_Plan__c;
                                            //mod.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                                            //mod.evnt.EndDateTime = objModel.evnt.Goal_Date__c; 
                                            eventList.add(mod.evnt);       
                                            system.debug('@@@ MOD eventList ::'+eventList);                                     
                                        }                                        
                                        blankListQ2.clear();
                                    }
                                }else if(objModel.evnt.Comments__c == null){
                                    blankListQ2.add(objModel);
                                    system.debug('@@ BlankList new ::'+blankListQ2);
                                }                                 
                            }    
                        //}
                    }else{   //For Existing Records
                        system.debug('$$$$$$$$');
                        if(objModel.evnt.Comments__c !=null){
                            //system.debug('***** Validation on DAte for Existing ::'+objModel.evnt.Goal_Date__c);
                            //Validation To Check Goal Date is not Blank
                            //if(objModel.evnt.Goal_Date__c == null){ 
                                //system.debug('**** Validation on DAte for Existing IF::'+objModel.evnt.Goal_Date__c);
                                //iserror = true;
                                /*Q2 = sortCustom1(Q2);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Date must be present.'));  
                                return null; 
                            //}
                            //Validation for Year 
                            //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                ///iserror = true;
                                /*Q2 = sortCustom1(Q2);  //Sort Quater1 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                return null;*/
                            //}
                            //Validation for Quater Wise 
                            //if(!(objModel.evnt.Goal_Date__c.month() > 3 && objModel.evnt.Goal_Date__c.month() < 7)){
                                /*Q2 = sortCustom1(Q2);  //Sort Quater1 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 2: Goal date must fall within the second quarter.'));
                                return null;    
                            //}
                            //Validation To Check Action Step i.e Action_Plan__c is not Blank
                            if(objModel.evnt.Action_Plan__c == null){
                                //iserror = true;
                                Q2 = sortCustom1(Q2);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Action Step must be present.'));
                                return null;
                            }
                            //else eventList.add(objModel.evnt);   //Add Events in Event Type List.
                            if(!rtMap.isEmpty())
                                objModel.evnt.RecordTypeId = rtMap.get('BAP Event');
                                
                            //objModel.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                            //objModel.evnt.EndDateTime = objModel.evnt.Goal_Date__c;                                    
                            eventList.add(objModel.evnt);        //Add Events in Event Type List.
                            system.debug('$$$$$$$$ ::1'+eventList);
                            
                            if(blankListQ2.size() > 0){   
                                system.debug('$$$$$$$$ IF'+blankListQ2);                             
                                for(BapObjectiveModel mod : blankListQ2){
                                    system.debug('@@ indexIdGoalMAP IF::'+indexIdGoalMAP);
                                    //if(indexIdGoalMAP.containsKey(integer.valueOf(mod.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id != null){
                                        //mod.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id; 
                                    //}else{
                                        //iserror = true;
                                        Q2 = sortCustom1(Q2);
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                        return null;
                                    //}    
                                    /*mod.evnt.RecordTypeId = objModel.evnt.RecordTypeId; 
                                    mod.evnt.Subject = mod.evnt.Action_Plan__c;
                                    mod.evnt.Comments__c = objModel.evnt.Comments__c;  
                                    //mod.evnt.EndDateTime = objModel.evnt.Goal_Date__c;  
                                    //mod.evnt.StartDateTime = objModel.evnt.Goal_Date__c; 
                                    eventList.add(mod.evnt);
                                    system.debug('@@ eventList ELSE::'+eventList);
                                }                                        
                                blankListQ2.clear();
                            }     
                        }else if(objModel.evnt.Comments__c == null){                            
                            blankListQ2.add(objModel);
                            system.debug('$$$$$$$$ 2'+blankListQ2);
                        }                                  
                    }
                }        
                if(blankListQ2.size() > 0){
                    //iserror = true;
                    Q2 = sortCustom1(Q2);
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarterly Objectives must be enter at the first index.'));    
                    return null;    
                }        
                Q2 = sortCustom1(Q2); //Again sort the Q2 List in ascending order
               
                //===============For Quater 3================
                list<BapObjectiveModel> blankListQ3 =  new list<BapObjectiveModel>();
                
                Q3 = sortCustom(Q3); //sort Q3 List in descending order.
                
                for(BapObjectiveModel objModel:Q3){
                    if(objModel.evnt.whatId == null){
                        //if(objModel.evnt.Goal_Number__c == null && (/*objModel.evnt.Goal_Date__c != null || objModel.evnt.Action_Plan__c != null)){
                            //iserror = true;
                            /*Q3 = sortCustom1(Q3);
                            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Number must be selected.'));    
                            return null;*/
                        //}else if(objModel.evnt.Goal_Number__c != null){
                            //if(objModel.evnt.Goal_Date__c == null){ 
                               // iserror = true;
                                /*Q3 = sortCustom1(Q3);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Date must be present.'));    
                                return null;
                            //}
                            if(objModel.evnt.Action_Plan__c == null){
                               // iserror = true;
                                /*Q3 = sortCustom1(Q3);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Action Step must be present.'));
                                return null;
                            }else{   
                                if(objModel.evnt.Comments__c !=null){
                                    //if(indexIdGoalMAP.containsKey(integer.valueOf(objModel.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(objModel.evnt.Goal_Number__c)).Id != null){
                                        //objModel.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(objModel.evnt.Goal_Number__c)).Id;        
                                        /*if(objModel.GoalIndexNo == 0){
                                            if(!indexMAP.isEmpty() && indexMAP.containsKey(objModel.evnt.WhatId)){
                                                system.debug('@@Goal number 0 ::');
                                                objModel.GoalIndexNo =  indexMAP.get(objModel.evnt.WhatId);
                                                objModel.evnt.Goal_Number__c = String.valueOf(objModel.GoalIndexNo);
                                                system.debug('@@Goal number Actuall ::'+objModel.GoalIndexNo);
                                            }                                            
                                        }*/
                                        //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                           // iserror = true;
                                            /*Q3 = sortCustom1(Q3);  //Sort Quater3 List In Ascending Order.
                                            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                            return null;*/
                                        //}
                                    //}else{
                                       // iserror = true;
                                        /*Q3 = sortCustom1(Q3);
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                        return null;*/
                                   //}
                                    //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                        //iserror = true;
                                        /*Q3 = sortCustom1(Q3);  //Sort Quater3 List In Ascending Order.
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                        return null;*/
                                    //}
                                    //if(!(objModel.evnt.Goal_Date__c.month() > 6 && objModel.evnt.Goal_Date__c.month() < 10)){
                                        /*Q3 = sortCustom1(Q3);  //Sort Quater1 List In Ascending Order.
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Goal date must fall within the third quarter.'));
                                        return null;    
                                    //}
                                    if(!rtMap.isEmpty())
                                        objModel.evnt.RecordTypeId = rtMap.get('BAP Event');
                                    //objModel.evnt.StartDateTime =objModel.evnt.Goal_Date__c;
                                    objModel.evnt.Subject = objModel.evnt.Action_Plan__c;
                                    //objModel.evnt.EndDateTime = objModel.evnt.Goal_Date__c;
                                    eventList.add(objModel.evnt);
                                    system.debug('@@ event List IF Part::'+eventList);
                                    
                                    if(blankListQ3.size() > 0){                                        
                                        for(BapObjectiveModel mod : blankListQ3){                                            
                                            //if(indexIdGoalMAP.containsKey(integer.valueOf(mod.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id != null){
                                                //mod.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id; 
                                            //}else{
                                                //iserror = true;
                                                Q3 = sortCustom1(Q3);
                                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                                return null;
                                            //} 
                                            /*mod.evnt.RecordTypeId =  objModel.evnt.RecordTypeId;
                                            mod.evnt.Comments__c = objModel.evnt.Comments__c;  
                                            mod.evnt.Subject = mod.evnt.Action_Plan__c;
                                            //mod.evnt.StartDateTime =objModel.evnt.Goal_Date__c;
                                            //mod.evnt.EndDateTime = objModel.evnt.Goal_Date__c;  
                                            eventList.add(mod.evnt);
                                            system.debug('@@ eventList ELSE::'+eventList);
                                        }                                        
                                        blankListQ3.clear();
                                    }
                                }else if(objModel.evnt.Comments__c == null){
                                    blankListQ3.add(objModel);
                                }                                 
                            }    
                        //}
                    }else{   //For Qauter 3 Existing  Records                            
                        if(objModel.evnt.Comments__c !=null){
                                                   
                            //Validation to Check Goal Date is not Blank
                            //if(objModel.evnt.Goal_Date__c == null){ 
                                //iserror = true;
                                /*Q3 = sortCustom1(Q3);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Date must be present.'));  
                                return null;  */
                            //}
                            //Validation for Year 
                            //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                //iserror = true;
                                /*Q3 = sortCustom1(Q3);  //Sort Quater3 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                return null;*/
                            //}
                            //Validation for Quater Wise
                            //if(!(objModel.evnt.Goal_Date__c.month() > 6 && objModel.evnt.Goal_Date__c.month() < 10)){
                               /* Q3 = sortCustom1(Q3);  //Sort Quater1 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 3: Goal date must fall within the third quarter.'));
                                return null;    
                            //}
                            //Validation to Check Action Step i.e Subject is not Blank
                            if(objModel.evnt.Action_Plan__c == null){
                                //iserror = true;
                                Q3 = sortCustom1(Q3);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Action Step must be present.'));
                                return null;
                            }
                            //else eventList.add(objModel.evnt);   //Add Events in Event Type List.
                            if(!rtMap.isEmpty())
                                objModel.evnt.RecordTypeId = rtMap.get('BAP Event');
                            //objModel.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                            //objModel.evnt.EndDateTime = objModel.evnt.Goal_Date__c;  
                            objModel.evnt.Subject = objModel.evnt.Action_Plan__c;                                  
                            eventList.add(objModel.evnt);        //Add Events in Event Type List.
                            
                            if(blankListQ3.size() > 0){                            
                                for(BapObjectiveModel mod : blankListQ3){                                
                                    //if(indexIdGoalMAP.containsKey(integer.valueOf(mod.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id != null){
                                      //  mod.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id; 
                                    //}else{
                                       // iserror = true;
                                        Q3 = sortCustom1(Q3);
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                        return null;
                                    //}     
                                    /*mod.evnt.RecordTypeId = objModel.evnt.RecordTypeId;
                                    mod.evnt.Subject = mod.evnt.Action_Plan__c;
                                    mod.evnt.Comments__c = objModel.evnt.Comments__c;  
                                    //mod.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                                    //mod.evnt.EndDateTime = objModel.evnt.Goal_Date__c;  
                                    eventList.add(mod.evnt);
                                    system.debug('@@ eventList ELSE::'+eventList);
                                }                                        
                                blankListQ3.clear();
                            }
                        }else if(objModel.evnt.Comments__c == null){
                            blankListQ3.add(objModel);
                        }               
                    }
                }
                if(blankListQ3.size() > 0){
                   // iserror = true;
                    Q3 = sortCustom1(Q3);
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarterly Objectives must be enter at the first index.'));    
                    return null;    
                } 
                Q3 = sortCustom1(Q3);  //sort in asceding order.
                
                //=============For Quater 4==============
                list<BapObjectiveModel> blankListQ4 =  new list<BapObjectiveModel>();
                
                Q4 = sortCustom(Q4);  //Sort in descending order.
                
                //For loop on 4th Quater List that is "Q4"
                for(BapObjectiveModel objModel:Q4){
                    if(objModel.evnt.whatId == null){
                        //if(objModel.evnt.Goal_Number__c == null && (/*objModel.evnt.Goal_Date__c != null || objModel.evnt.Action_Plan__c != null)){
                           // iserror = true;
                           /* Q4 = sortCustom1(Q4);
                            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Number must be selected.'));
                            return null; */   
                        //}else if(objModel.evnt.Goal_Number__c != null){
                            //if(objModel.evnt.Goal_Date__c == null){ 
                                //iserror = true;
                                /*Q4 = sortCustom1(Q4);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Date must be present.'));  
                                return null; 
                            //}
                            if(objModel.evnt.Action_Plan__c == null){
                               // iserror = true;
                                /*Q4 = sortCustom1(Q4);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Action Step must be present.'));
                                return null;
                            }else{   
                                if(objModel.evnt.Comments__c !=null){
                                    //if(indexIdGoalMAP.containsKey(integer.valueOf(objModel.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(objModel.evnt.Goal_Number__c)).Id != null){
                                        //objModel.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(objModel.evnt.Goal_Number__c)).Id;        
                                        /*if(objModel.GoalIndexNo == 0){
                                            if(!indexMAP.isEmpty() && indexMAP.containsKey(objModel.evnt.WhatId)){
                                                system.debug('@@Goal number 0 ::');
                                                objModel.GoalIndexNo =  indexMAP.get(objModel.evnt.WhatId);
                                                objModel.evnt.Goal_Number__c = String.valueOf(objModel.GoalIndexNo);
                                                system.debug('@@Goal number Actuall ::'+objModel.GoalIndexNo);
                                            }                                            
                                        }*/
                                        //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c ){
                                           // iserror = true;
                                            /*Q4 = sortCustom1(Q4);  //Sort Quater4 List In Ascending Order.
                                            Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                            return null;*/
                                        //}
                                    //}else{
                                       // iserror = true;
                                        /*Q4 = sortCustom1(Q4);
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                        return null;*/
                                    //}
                                    //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c ){
                                       // iserror = true;
                                        /*Q4 = sortCustom1(Q4);  //Sort Quater4 List In Ascending Order.
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                        return null;*/
                                    //}if(!(objModel.evnt.Goal_Date__c.month() > 9)){
                                        /*Q4 = sortCustom1(Q4);  //Sort Quater1 List In Ascending Order.
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Goal date must fall within the fourth quarter.'));
                                        return null;   
                                    //}
                                    if(!rtMap.isEmpty())
                                        objModel.evnt.RecordTypeId = rtMap.get('BAP Event');
                                        
                                    //objModel.evnt.StartDateTime =objModel.evnt.Goal_Date__c;
                                    //objModel.evnt.EndDateTime = objModel.evnt.Goal_Date__c;
                                    objModel.evnt.Subject = objModel.evnt.Action_Plan__c;
                                    eventList.add(objModel.evnt);
                                    
                                    if(blankListQ4.size() > 0){
                                        
                                        for(BapObjectiveModel mod : blankListQ4){
                                            
                                            //if(indexIdGoalMAP.containsKey(integer.valueOf(mod.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id != null){
                                                //mod.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id; 
                                            //}else{
                                               // iserror = true;
                                                Q4 = sortCustom1(Q4);
                                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                                return null;
                                            //}     
                                            /*mod.evnt.RecordTypeId = objModel.evnt.RecordTypeId;
                                            mod.evnt.Comments__c = objModel.evnt.Comments__c;  
                                            mod.evnt.Subject = mod.evnt.Action_Plan__c;
                                            //mod.evnt.StartDateTime =objModel.evnt.Goal_Date__c;
                                            //mod.evnt.EndDateTime = objModel.evnt.Goal_Date__c;  
                                            eventList.add(mod.evnt);                                            
                                        }                                        
                                        blankListQ4.clear();
                                    }
                                }else if(objModel.evnt.Comments__c == null){
                                    blankListQ4.add(objModel);                                    
                                }                                 
                            }    
                        //}
                    }else{   //For Existing Records.
                        if(objModel.evnt.Comments__c !=null){
                            
                            //Validation to Check Goal Date is not Blank
                            //if(objModel.evnt.Goal_Date__c == null){ 
                                //iserror = true;
                               /* Q4 = sortCustom1(Q4);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Goal Date must be present.'));  
                                return null;  */
                            //}
                            //Validation for Year 
                            //if(String.valueOf(objModel.evnt.Goal_Date__c.year()) != sep1.Year__c){
                                //iserror = true;
                                /*Q4 = sortCustom1(Q4);  //Sort Quater4 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal Date Year must be equal to '+sep1.Year__c));
                                return null;*/
                            //}
                            //Validation For Quater wise
                            //if(!(objModel.evnt.Goal_Date__c.month() > 9)){
                                /*Q4 = sortCustom1(Q4);  //Sort Quater1 List In Ascending Order.
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarter 4: Goal date must fall within the fourth quarter.'));
                                return null;    
                            //}
                            //Validation to Check Action Step i.e Subject is not Blank
                            if(objModel.evnt.Action_Plan__c == null){
                               // iserror = true;
                                /*Q4 = sortCustom1(Q4);
                                Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'The Action Step must be present.'));
                                return null;
                            }
                            //else eventList.add(objModel.evnt);    //Add Events in Event Type List.
                            if(!rtMap.isEmpty())
                                objModel.evnt.RecordTypeId = rtMap.get('BAP Event');
                            //objModel.evnt.StartDateTime = objModel.evnt.Goal_Date__c;
                            //objModel.evnt.EndDateTime = objModel.evnt.Goal_Date__c;    
                            objModel.evnt.Subject = objModel.evnt.Action_Plan__c;                                
                            eventList.add(objModel.evnt);        //Add Events in Event Type List.
                            
                            if(blankListQ4.size() > 0){
                                
                                for(BapObjectiveModel mod : blankListQ4){
                                    
                                    //if(indexIdGoalMAP.containsKey(integer.valueOf(mod.evnt.Goal_Number__c)) && indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id != null){
                                       // mod.evnt.WhatId = indexIdGoalMAP.get(integer.valueOf(mod.evnt.Goal_Number__c)).Id; 
                                    //}else{
                                      //  iserror =true;
                                        Q4 = sortCustom1(Q4);
                                        Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Goal is not exist, in accordance of selected goal number'));
                                        return null;
                                    //}     
                                    /*mod.evnt.RecordTypeId = objModel.evnt.RecordTypeId;
                                    mod.evnt.Comments__c = objModel.evnt.Comments__c; 
                                    mod.evnt.Subject = mod.evnt.Action_Plan__c;
                                    //mod.evnt.StartDateTime =objModel.evnt.Goal_Date__c; 
                                    //mod.evnt.EndDateTime = objModel.evnt.Goal_Date__c;  
                                    eventList.add(mod.evnt);
                                    system.debug('@@ eventList ELSE::'+eventList);
                                }                                        
                                blankListQ4.clear();
                            }  
                        }else if(objModel.evnt.Comments__c == null){
                            blankListQ4.add(objModel);                                    
                        }                                      
                    }
                }
                if(blankListQ4.size() > 0){
                   // iserror = true;
                    Q4 = sortCustom1(Q4);
                    Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, 'Quarterly Objectives must be enter at the first index.'));    
                    return null;    
                } 
                Q4 = sortCustom1(Q4);  //Sort in ascending order.
                
                //DML on Event List
                system.debug('$$$$ Before'+eventList);
                if(eventList != null && eventList.Size() > 0)
                    upsert eventList;             
                    
                system.debug('$$$$ After'+eventList);          
                
                //If everything is fine then redirect on self.
                pageReference pg = new pageReference('/apex/manageBap?id='+sep1.Id);
                pg.setRedirect(true);
                return pg;               
            }
        }catch(exception e){            
            system.debug('####'+e.getMessage());
            //Apexpages.addMessage(new Apexpages.Message(ApexPages.Severity.Error, e.getMessage()));            
            return null; 
        } 
    }//End of Save function.
    
    //Total of all the values of Stratum data table:-
    private void total(list<StratumModelClass> modelList){
        system.debug('@@TOTAL ::'+modelList);
        totalValue1 = 0;
        totalValue2 = 0;
        totalValue3 = 0;
        totalValue4 = 0;
        for(StratumModelClass model:modelList){
            totalValue1 = totalValue1 + (model.Value1 != null ? model.Value1 : 0);
            totalValue2 = totalValue2 + (model.Value2 != null ? model.Value2 : 0);
            totalValue3 = totalValue3 + (model.Value3 != null ? model.Value3 : 0);
            totalValue4 = totalValue4 + (model.Value4 != null ? model.Value4 : 0);
        }        
    }
    
    //======Method for Close and redirect to the Bap tap=====
    public pageReference closeProcess()
    {  
        String bapPrefix = Schema.getGlobalDescribe().get('SEP__c').getDescribe().getKeyPrefix();     
// jw 2012-01-21 Commented out this code because the View page has been overridden.
//        if(sep1.Id != null)
//            return new pageReference('/'+sep1.Id);
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
    
    //=====Model Class For SEP Goal Table======
    public class GoalClass{    
        public SEP_Goal__c sepGoal { get; set; }
        public Integer indexNo { get; set; }
        
        public GoalClass(Integer indexNo,SEP_Goal__c sepGoal){        
            this.sepGoal = sepGoal;
            this.indexNo = indexNo;
        }
    }
    
    //=====Model Class For Stratum Table=====
    public class StratumModelClass{
        public String productClass { get; set; }
        public String label { get; set; }
        public Integer rowIndex { get; set; }
        public Integer Value1 { get; set; }      
        public Integer Value2 { get; set; }      
        public Integer Value3 { get; set; }      
        public Integer Value4 { get; set; }     
       // public String Model_year { get; set; }   
    }
    
    //Model class for bap objective and also contains events.
    public class BapObjectiveModel{        
        public Event evnt{ get; set; }              
        //public list<SelectOption> goalNumberPickList { get; set; }
        public Integer GoalIndexNo{ get; set; } 
        public Integer indexNo { get; set; }
       
       //public BapObjectiveModel(Event evnt,list<SelectOption> goalNumberPickList,Integer GoalIndexNo,Integer indexNo){
       public BapObjectiveModel(Event evnt,Integer GoalIndexNo,Integer indexNo){
            this.evnt = evnt;
            this.GoalIndexNo= GoalIndexNo;   
            this.indexNo = indexNo;         
        }
    }  */
}