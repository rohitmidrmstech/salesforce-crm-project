/**************************************************************************************************
* Controller Class: BusinessPlan
* Created by Arpit Vashishtha(Navivo), DateCreated: 11/04/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - The page is used to create and maintain Business Plan annualy, Business Plans of all the
    Accounts are managed according to the particular user will be managed.
  - Also allows users to submit and update the Business Plan.
---------------------------------------------------------------------------------------------------
* Unit Test: TestBusinessPlan
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME                 DATE            DETAIL FEATURES
    1.0      Arpit Vashishtha (Navivo)      11/04/2014      INITIAL DEVELOPMENT
    2.0      Arpit Vashishtha (Navivo)      02/09/2015      Method which is called to fetch all the records when manager selects the user.
    3.0      Shakti pravesh                 10/26/2015      Added a logic to show year textfield on page if user is USA user.
    4.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.
**************************************************************************************************/

public with sharing class BusinessPlan {
    /*
    public Integer bpYear{get;set;}
    public Boolean isUSAProfile{get;set;}
    public String budget{get;set;}
    public String planned{get;set;}
    public String q1{get;set;}
    public String q2{get;set;}
    public String q3{get;set;}
    public String q4{get;set;}
    public String totalYTD{get;set;}
    public String previousYearActual{get;set;}
    public String ytdActualPercentToBudget{get;set;}
    public ApexPages.StandardSetController sc{get;set;}
    public List<Wrapper> wrapper{get;set;}
    public List<Business_Plan__c> bPlanData{get;set;}
    public Business_Plan__c bp{get;set;}
    public Account acc{get;set;}
    private Set<Id> setAccId {get;set;}
    public Boolean visibilityPreviousYear{get;set;}
    public Date systemDate {get;set;}
    public Date firstDate{get;set;}
    public Date lastDate {get;set;}
    public Decimal budgetAllBoards{get;set;}
    public Boolean abc{get;set;}
    public Business_Plan_Others__c bpo{get;set;}
    public Integer bpSize {get;set;}
    public Boolean showManagerPanel {get;set;}
    public String userId{get;set;}
    public User u {get;set;}
    public list<selectoption> userOption {get;set;}
    public String userSelected {get;set;}
    public String userName{get;set;}
    public String userCode{get;set;}
    public Boolean showTMUser {get;set;}
    
    private String checkPage = '';
    private String newBPAccID = '';
    private String lastYearPlan = '';
    private String returnId = '';
    public String deleteId {get;set;}
    private Set<Id> bPlanIdsToDelete = new Set<Id>();
    private Map<Id, Business_Plan__c> perviousYearActualsMap = new Map<Id, Business_Plan__c>();
    private Map<Id, User> userMap = new Map<Id, User>();
    private Map<String, Business_Plan__c> mapBusinessPlan = new Map<String, Business_Plan__c>();
    private Integer bpLastYear;
    private List<Account> accData;
    
    public String accountID{get;set;}
    public Set<ID> hierarchyAccIds{get;set;}
    public Boolean tmUser{get;set;}
    //----------------------------------------------------------constructor-----------------------------------------
    public BusinessPlan(ApexPages.StandardSetController sc){
        System.debug('Constructor working');
        try{
            acc = new Account();
            isUSAProfile = false;
            userSelected = UserInfo.getUserId();
            bpSize = 0;
            showTMUser = false;
            //logic to show 1st time previous year Actual text box
            systemDate = System.today();
            //Mohan - changing the IF condition
            Date firstYearEndDate = Date.newInstance(2015,10,30);
            if(systemDate <= firstYearEndDate) {
                visibilityPreviousYear = false;
            }else{
                visibilityPreviousYear = true;
            }
            //logic to display year
            if(System.today().month()<11){
                bpYear = System.today().year();
            }else if(System.today().month()>= 11){
                bpYear = System.today().year() + 1;
            }
            //Shakti - Nov 18, 2015 for add business plan for privous year.
            if(ApexPages.currentPage().getParameters().get('LastYear')=='Yes'){
                bpYear = bpYear-1;
                lastYearPlan = 'Yes';
            }
            bpLastYear = bpYear - 1;
            System.Debug('In the constructor'+bpYear);
            
            //Arpit 02/09/2015 : Added a logic to show picklist of user on page if the current user is manager.
            userId = UserInfo.getUserId();
            //Arpit 06/10/2015 : Adding a field userRole.Name in the query.
            u = [select id, Name, ManagerId, User_Territory_Code__c, Profile.Name, userRole.Name from user where id = :userId];
            //Shakti 10/26/2015 : Added a logic to show year textfield on page if user is USA user.
            if(u.Profile.Name.contains('USA RSM User') || u.Profile.Name.contains('USA TM User') || u.Profile.Name.contains('System Administrator')){
                isUSAProfile = true;
            }
            system.debug('UserDetailIs'+u);
            system.debug('userId////'+userId);
            system.debug('userRole.Name////'+u.userRole.Name);
            //Arpit 06-10-2015 : adding a logic to check that if userRole,Name contains TM then is should be seen as outputField.
            //CF S-490560 Start Adding null check for code coverage
            if((u.userRole != null && u.userRole.Name != null && String.valueOf(u.userRole.Name).contains('TM')) || u.Profile.Name.contains('System Administrator')) {
            //CF S-490560 End
                showTMUser = true; 
                system.debug('showTMUser////'+showTMUser);
            }
            List<User> managerUsers = [Select id, Name, ManagerId, User_Territory_Code__c from user where ManagerId =: userId and isActive = true];
            system.debug('managerUsers'+managerUsers);
            if(managerUsers.size() > 0) {
                showManagerPanel = true;
                userMap = new Map<Id, User>(managerUsers);
                userMap.put(u.Id, u);
                userOption = new list<selectoption>();
                //userOption.add(new selectoption('', '--Select TM--'));
                userOption.add(new selectoption(u.Id, u.Name));
                for(User usr : managerUsers){
                    userOption.add(new selectoption(usr.id , usr.Name));
                }
            } 
            //*****************************Arpit 02/09/2015 : Changes Ends Here*******************************************
            
            
            bp = new Business_Plan__c();
            acc = new Account();
            ///check from url if bp has new it is Account detail page...
            checkPage = ApexPages.currentPage().getParameters().get('bp');
            System.debug('Finally123'+checkPage);
            
            if(checkPage == 'new'){
                System.debug('Finally'+checkPage);
                String aId = ApexPages.currentPage().getParameters().get('aid');
                System.debug('Id::::::'+aId);
                setAccId = new Set<Id>();
                //Arpit 22-September-2015: adding a condition to check that if JDE_Account_Number__c on account object is not null.
                List<Account> listAccount = [Select Id, JDE_Account_Number__c from Account where Id =: aId];
                //Shakti 29-Oct-2015: remove condition to check that if JDE_Account_Number__c on account object is not null.
                if(listAccount.size() > 0/* && listAccount[0].JDE_Account_Number__c != null && listAccount[0].JDE_Account_Number__c != '') { 
                    setAccId.add(aId);
                    newBPAccID = aId;
                    setAccId = fetchRelatedAccountIds(setAccId);
                    wrapper = new List<Wrapper>();
                    //run a query on Acc obj.
                    accData = [Select a.Name,a.BillingState, a.BillingCity, a.Top_Most_Parent_Account__c From Account a where a.id IN :setAccId order By a.CreatedDate ASC];
                    System.debug('Test::::'+accData);
                    //run a query on list<Businessplan> 
                    bPlanData = [Select b.Previous_Year_Actual_Finishing__c,b.Previous_Year_Actual_All_Boards__c,b.Previous_Year_Actual_Tape__c,b.Previous_Year_Actual_VAP__c , b.Budget_VAP_of_Boards__c, b.Actual_VAP_of_Boards__c,b.VAP_Actual_to_Budget__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.All_Board_Actual_to_Budget__c,b.Total_YTD_Finishing__c,b.Q4_Finishing__c, b.Q3_Finishing__c, b.Q2_Finishing__c,b.Q1_Finishing__c,b.Budget_Finishing__c,b.Total_YTD_Tape__c,b.Q4_Tape__c,b.Q3_Tape__c,b.Q2_Tape__c,b.Q1_Tape__c,b.Budget_Tape__c,b.Total_YTD_VAP__c,b.Q4_VAP__c, b.Q3_VAP__c, b.Q2_VAP__c,b.Q1_VAP__c,b.Budget_VAP__c,b.Total_YTD_All_Board__c,b.Q4_All_Boards__c,b.Q3_All_Boards__c,b.Q2_All_Boards__c,b.Q1_All_Boards__c,b.Planned_All_Boards__c,b.Account__c,b.Budget_All_Boards__c from Business_Plan__c b where b.Account__c IN :setAccId and Year__c =: String.valueOf(bpYear) and b.User_Id__c =: UserInfo.getUserId()];
                    System.debug('After'+mapBusinessPlan);
                    for(Business_Plan__c bpObj : bPlanData){
                        mapBusinessPlan.put(bpObj.Account__c,bpObj);
                        returnId = bpObj.Account__c;
                        System.debug('in the Loop new::::'+mapBusinessPlan);
                    }
                    
                    System.debug('Map:::::'+mapBusinessPlan);
                }
            } else if(checkPage == 'edit'){
                //url from edit business plan page
                String id = ApexPages.currentPage().getParameters().get('id');
                String aId = ApexPages.currentPage().getParameters().get('aid');
                System.debug('edit Id::::::'+id);
                setAccId = new Set<Id>();
                setAccId.add(aId);
                setAccId = fetchRelatedAccountIds(setAccId);
                //Business_Plan__c bPlanRec = [Select Id, Account__c From Business_Plan__c Where Id =: id];
                //String aId = bPlanRec.Account__c;
                
                wrapper = new List<Wrapper>();
                //run a query on Acc obj.
                accData = [Select a.Name,a.BillingState, a.BillingCity, a.Top_Most_Parent_Account__c From Account a where a.id IN :setAccId order By a.CreatedDate ASC];
                System.debug('Test::::'+accData);
                //run a query on list<Businessplan> 
                bPlanData = [Select b.Previous_Year_Actual_Finishing__c, b.Previous_Year_Actual_All_Boards__c, b.Previous_Year_Actual_Tape__c, b.Previous_Year_Actual_VAP__c, b.Budget_VAP_of_Boards__c, b.Actual_VAP_of_Boards__c,b.VAP_Actual_to_Budget__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.All_Board_Actual_to_Budget__c,b.Total_YTD_Finishing__c,b.Q4_Finishing__c, b.Q3_Finishing__c, b.Q2_Finishing__c,b.Q1_Finishing__c,b.Budget_Finishing__c,b.Total_YTD_Tape__c,b.Q4_Tape__c,b.Q3_Tape__c,b.Q2_Tape__c,b.Q1_Tape__c,b.Budget_Tape__c,b.Total_YTD_VAP__c,b.Q4_VAP__c, b.Q3_VAP__c, b.Q2_VAP__c,b.Q1_VAP__c,b.Budget_VAP__c,b.Total_YTD_All_Board__c,b.Q4_All_Boards__c,b.Q3_All_Boards__c,b.Q2_All_Boards__c,b.Q1_All_Boards__c,b.Planned_All_Boards__c,b.Account__c,b.Budget_All_Boards__c from Business_Plan__c b where b.Account__c IN :setAccId and Id =: id and b.User_Id__c =: UserInfo.getUserId()];
                System.debug('After'+mapBusinessPlan);
                for(Business_Plan__c bpObj : bPlanData){
                    mapBusinessPlan.put(bpObj.Account__c,bpObj);
                    returnId = bpObj.Account__c;
                    System.debug('in the Loop new::::'+mapBusinessPlan);
                }
            } else {
                //// in case of edit bp edit BP page.....
                System.debug('QQ!!!');
                wrapper = new List<Wrapper>();
                setAccId = new Set<Id>();
                List<Account> accSelected = (List<Account>)sc.getSelected();
                System.debug('List'+accSelected);
                //Arpit 22-09-2015 : adding a logic to add condition if JDE should be filled.
                Set<Id> setAcnt = new Set<Id>();
                if(accSelected.size() > 0) {
                    for(Account acnt : accSelected) {
                        setAcnt.add(acnt.Id);
                    }
                    //Shakti 29-10-2015 : Remove logic to JDE should be filled.
                    /*List<Account> accJde = [Select Id, JDE_Account_Number__c from Account where Id IN :setAcnt];
                    if(accJde.size() > 0){
                        for(Account a : accJde) {
                            if(a.JDE_Account_Number__c == null || a.JDE_Account_Number__c == '') {
                                setAcnt.remove(a.Id);
                            } 
                        }
                    }
                }
                /*for(Account a: accSelected){
                    setAccId.add(a.id);
                }
                for(Id i : setAcnt) {
                    setAccId.add(i);
                }
                    
                System.debug('Text::::'+setAccId);
                setAccId = fetchRelatedAccountIds(setAccId);
                
                //run a query on Acc obj.
                accData = [Select a.Name,a.BillingState, a.BillingCity, a.Top_Most_Parent_Account__c From Account a where a.id IN :setAccId order By a.CreatedDate ASC];
                System.debug('Test::::'+accData);
                System.debug('Valu of Year..'+String.valueOf(bpYear));
                System.debug('UserInfo:::'+ UserInfo.getUserId());
                //run a query on list<Businessplan> 
                bPlanData = [Select b.Previous_Year_Actual_Finishing__c,b.Previous_Year_Actual_All_Boards__c,b.Previous_Year_Actual_Tape__c,b.Previous_Year_Actual_VAP__c,b.Budget_VAP_of_Boards__c, b.Actual_VAP_of_Boards__c,b.VAP_Actual_to_Budget__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.All_Board_Actual_to_Budget__c,b.Total_YTD_Finishing__c,b.Q4_Finishing__c, b.Q3_Finishing__c, b.Q2_Finishing__c,b.Q1_Finishing__c,b.Budget_Finishing__c,b.Total_YTD_Tape__c,b.Q4_Tape__c,b.Q3_Tape__c,b.Q2_Tape__c,b.Q1_Tape__c,b.Budget_Tape__c,b.Total_YTD_VAP__c,b.Q4_VAP__c, b.Q3_VAP__c, b.Q2_VAP__c,b.Q1_VAP__c,b.Budget_VAP__c,b.Total_YTD_All_Board__c,b.Q4_All_Boards__c,b.Q3_All_Boards__c,b.Q2_All_Boards__c,b.Q1_All_Boards__c,b.Planned_All_Boards__c,b.Account__c,b.Budget_All_Boards__c from Business_Plan__c b where b.Account__c IN :setAccId and Year__c =: String.valueOf(bpYear) and b.User_Id__c =: UserInfo.getUserId()];
                
                // loop in  list<Businessplan>, create a MAP variable with acc id as Key value, and Bp as Value.    
                //(mapBusinessPlan.put(Acc id, bp))     
                System.debug('Obj::::'+bPlanData);
                
                System.debug('After'+mapBusinessPlan);
                for(Business_Plan__c bpObj : bPlanData){
                    mapBusinessPlan.put(bpObj.Account__c,bpObj);
                    System.debug('in the Loop::::'+mapBusinessPlan);
                }
                
                System.debug('Map:::::'+mapBusinessPlan);
            }
            
            if(setAccId.size() > 0) {
                List<Business_Plan__c> bpPlanLastYear = [Select Id, Account__c, Total_YTD_Finishing__c, Total_YTD_All_Board__c, Total_YTD_Tape__c, Total_YTD_VAP__c 
                  from Business_Plan__c b where b.Account__c IN :setAccId and Year__c =: String.valueOf(bpLastYear) and b.User_Id__c =: UserInfo.getUserId()];
   
                for(Business_Plan__c bpLast : bpPlanLastYear) {
                    perviousYearActualsMap.put(bpLast.Account__c, bpLast);
                }
                Map<ID,List<Wrapper>> accIDLstMap = new Map<ID,List<Wrapper>>();
                //next loop on acc list, instance of wrapper class and add it to the list.
                for(Account a : accData){
                    //Shakti - Nov 18, 2015 to control to display selected account on add to business plan screen.
                    if((lastYearPlan!='Yes' && checkPage=='New' && ApexPages.currentPage().getParameters().get('aid')==a.Id) || (checkPage=='New' && lastYearPlan=='Yes') || (checkPage!='New' && lastYearPlan!='Yes')){
                        Wrapper wrap = new Wrapper();
                        wrap.viewAccHierarchy = false;
                        wrap.acc = a;
                        if(a.BillingState != null && a.BillingCity != null){
                            wrap.location = a.BillingCity +', '+ a.BillingState;
                        }else if(a.BillingState != null){
                            wrap.location = a.BillingState;
                        }else if(a.BillingCity != null){
                            wrap.location = a.BillingCity;
                        }
                        if(mapBusinessPlan != null && mapBusinessPlan.containsKey(a.id)){
                            wrap.bPlan = mapBusinessPlan.get(a.id);
                            //performHeaderCalculations(wrap);
        ////////////////////////////////////////Add function by Arpit on 19-11-2014////////////////////////////////////////
                            System.debug('123::::'+wrap);
                            performRowCalculation(wrap);
                            performHeaderCalculations(wrap);
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        }else{
                            wrap.bPlan = new Business_Plan__c();
                            wrap.bPlan.Account__c = a.Id;// after that bPlan,Name = Account Name + year
                            wrap.bPlan.User_Id__c = UserInfo.getUserId();
                            //System.debug('UserId::--'+wrap.bPlan.User_Id__c);
                            wrap.bPlan.Name = a.Name+'-'+bpYear;
                            wrap.bPlan.Year__c = String.valueOf(bpYear);
                            Business_Plan__c bpLast = perviousYearActualsMap.get(a.Id);
                            if(bpLast != null) {
                                wrap.bPlan.Previous_Year_Actual_All_Boards__c = bpLast.Total_YTD_All_Board__c;
                                wrap.bPlan.Previous_Year_Actual_VAP__c = bpLast.Total_YTD_VAP__c;
                                wrap.bPlan.Previous_Year_Actual_Tape__c = bpLast.Total_YTD_Tape__c;
                                wrap.bPlan.Previous_Year_Actual_Finishing__c = bpLast.Total_YTD_Finishing__c;
                            }
                        }
                        wrapper.add(wrap);
                        if(!accIDLstMap.containsKey(a.Top_Most_Parent_Account__c)){
                            accIDLstMap.put(a.Top_Most_Parent_Account__c,new List<wrapper>());
                        }
                        accIDLstMap.get(a.Top_Most_Parent_Account__c).add(wrap);
                    }
                }
                if(accIDLstMap.size()>0){
                    wrapper = new List<Wrapper>();
                    String trColor = '#eeeeee';
                    for(String a : accIDLstMap.keySet()){
                        if(trColor == '#eeeeee'){trColor = '#aeaeae';}else{trColor = '#eeeeee';}
                        List<Wrapper> tempWrapper = new List<Wrapper>();
                        for(Wrapper wp : accIDLstMap.get(a)){
                            wp.color = trColor;
                            tempWrapper.add(wp);
                        }
                        tempWrapper.sort();
                        wrapper.addAll(tempWrapper);
                    }
                }
                bpSize = wrapper.size();
                System.debug('Map::::'+mapBusinessPlan);
                if(bpo != null) {
                    performHeaderCalculations(); 
                }
                List<User> u = [select id, Name, ManagerId, User_Territory_Code__c, Profile.Name, userRole.Name from user where id = :UserInfo.getUserId()];
                if(u.size()>0 && (u.get(0).Profile.Name.contains('USA TM User') || u.get(0).Profile.Name.contains('System Administrator'))){
                    tmUser = true;
                }else{
                    tmUser = false;
                }
            } else {
                
            }
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,e.getMessage()));
        }
        
    }
    
    
    //Get User detail on change select List
    public void userDetail(){
        system.debug('userDetailIdIs'+userId);
        if(userSelected != null && userSelected != ''){
            User uRec = userMap.get(userSelected);
            if(uRec != null) {
                userId = uRec.Id;
                userCode = uRec.User_Territory_Code__c; 
                system.debug('userDetailIdIs1'+userId);
            }
        }
    }
    
    
    //-------------------------------------------Calculate Business Plan Values in wrapper class----------------------------
    private Wrapper calculateBPValues(Wrapper w) {
        w.bPlan.Total_YTD_All_Board__c = BusinessPlanUtil.calculateTotals(w.bPlan.Q1_All_Boards__c, w.bPlan.Q2_All_Boards__c, w.bPlan.Q3_All_Boards__c, w.bPlan.Q4_All_Boards__c);
        w.bPlan.Total_YTD_Finishing__c = BusinessPlanUtil.calculateTotals(w.bPlan.Q1_Finishing__c, w.bPlan.Q2_Finishing__c, w.bPlan.Q3_Finishing__c, w.bPlan.Q4_Finishing__c);
        w.bPlan.Total_YTD_Tape__c = BusinessPlanUtil.calculateTotals(w.bPlan.Q1_Tape__c, w.bPlan.Q2_Tape__c, w.bPlan.Q3_Tape__c, w.bPlan.Q4_Tape__c);
        w.bPlan.Total_YTD_VAP__c = BusinessPlanUtil.calculateTotals(w.bPlan.Q1_VAP__c, w.bPlan.Q2_VAP__c, w.bPlan.Q3_VAP__c, w.bPlan.Q4_VAP__c);
        w.bPlan.All_Board_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(w.bPlan.Total_YTD_All_Board__c, w.bPlan.Planned_All_Boards__c);
        w.bPlan.VAP_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(w.bPlan.Total_YTD_VAP__c, w.bPlan.Planned_VAP__c);
        w.bPlan.Tape_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(w.bPlan.Total_YTD_Tape__c, w.bPlan.Planned_Tape__c);
        w.bPlan.Finishing_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(w.bPlan.Total_YTD_Finishing__c,w.bPlan.Planned_Finishing__c);
        w.bPlan.Actual_VAP_of_Boards__c = BusinessPlanUtil.calculatePercent(w.bPlan.Total_YTD_VAP__c,w.bPlan.Total_YTD_All_Board__c);
        w.bPlan.Budget_VAP_of_Boards__c = BusinessPlanUtil.calculatePercent(w.bPlan.Planned_VAP__c,w.bPlan.Planned_All_Boards__c);
        //b.Name = w.acc.Name
        return w;
    }
    
    
    
    private Business_Plan_Others__c calculateBPOValues(Business_Plan_Others__c b) {
        b.Total_YTD_All_Board__c = BusinessPlanUtil.calculateTotals(b.Q1_All_Boards__c, b.Q2_All_Boards__c, b.Q3_All_Boards__c, b.Q4_All_Boards__c);
        b.Total_YTD_Finishing__c = BusinessPlanUtil.calculateTotals(b.Q1_Finishing__c, b.Q2_Finishing__c, b.Q3_Finishing__c, b.Q4_Finishing__c);
        b.Total_YTD_Tape__c = BusinessPlanUtil.calculateTotals(b.Q1_Tape__c, b.Q2_Tape__c, b.Q3_Tape__c, b.Q4_Tape__c);
        b.Total_YTD_VAP__c = BusinessPlanUtil.calculateTotals(b.Q1_VAP__c, b.Q2_VAP__c, b.Q3_VAP__c, b.Q4_VAP__c);
        b.All_Board_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(b.Total_YTD_All_Board__c, b.Planned_All_Boards__c);
        b.VAP_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(b.Total_YTD_VAP__c, b.Planned_VAP__c);
        b.Tape_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(b.Total_YTD_Tape__c, b.Planned_Tape__c);
        b.Finishing_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(b.Total_YTD_Finishing__c,b.Planned_Finishing__c);
        b.Actual_VAP_of_Boards__c = BusinessPlanUtil.calculatePercent(b.Total_YTD_VAP__c,b.Total_YTD_All_Board__c);
        b.Budget_VAP_of_Boards__c = BusinessPlanUtil.calculatePercent(b.Planned_VAP__c,b.Planned_All_Boards__c);
        return b;
    }
    
    //-------------------------------------------------submit method code---------------------------------------
    public Boolean saveButton(){
        //Pagereference pr;
        try{
            List<Account> accountUpdate = new List<Account>();
            List<Business_Plan__c> businessPlanUpdate = new List<Business_Plan__c>();
            List<Account> accId = new List<Account>();
            System.debug('I the save button');
            for(Wrapper w: wrapper){
                if(!visibilityPreviousYear) {
                    accountUpdate.add(w.acc);
                }
                w = calculateBPValues(w);
                businessPlanUpdate.add(w.bPlan);
                System.Debug('YYY:::'+businessPlanUpdate);
            } 
            System.Debug('PPP:::'+accountUpdate);
            //if(accountUpdate.size() > 0) upsert accountUpdate;
            if(businessPlanUpdate.size() > 0){
                BusinessPlanUtil.processCalculation = false;
                //upsert businessPlanUpdate;
                BusinessPlanUtil.saveBpUtil(businessPlanUpdate);
                BusinessPlanUtil.processCalculation = true;
            }
            if(bPlanIdsToDelete.size() > 0){
                //delete [Select Id From Business_Plan__c Where Id IN :bPlanIdsToDelete];
                BusinessPlanUtil.deleteBpUtil(bPlanIdsToDelete);
            }
            if(bpo != null){
                bpo = calculateBPOValues(bpo);
                upsert bpo;
            }
            System.Debug('PPPbpo:::'+bpo);
            return true;
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage())); 
        }
        return false;
    }
    
    public void saveCalling(){
        if(saveButton()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Your changes are saved successfully.')); 
        } /*else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Saved'));  
        }*/
    }
    
    /*
    //------------------------------------Save And close-------------------------------
    public pagereference saveAndClose() {
        Pagereference pr;
        System.debug('retURl:---');
         if(saveButton()) {
            if(checkPage == 'new' || checkPage == 'edit') pr = new Pagereference('/' + returnId);
            else {
                String retURL = Apexpages.currentPage().getParameters().get('retURL');
                System.debug('retURl:---'+retURL);
                if(retURL != null && retURL != '') {
                    pr = new Pagereference(retURL);
                }
                else pr = new Pagereference('/001/o');
            }
         }
         System.debug('pr:---'+pr);
         return pr;
    } */
    
/*  private Decimal calculateTotals(Decimal q1, Decimal q2, Decimal q3, Decimal q4) {
        Decimal ttl = 0;
        if(q1 != null) ttl += q1;
        if(q2 != null) ttl += q2;
        if(q3 != null) ttl += q3;
        if(q4 != null) ttl += q4;
        return ttl;
    }*/
    /*
    private void performHeaderCalculations(Wrapper w) {
        calculateHeaderValue(w.bPlan.Planned_All_Boards__c, 'AllBoard', 'Planned');
        calculateHeaderValue(w.bPlan.Planned_VAP__c, 'VAP', 'Planned');
        calculateHeaderValue(w.bPlan.Planned_Tape__c, 'Tape', 'Planned');
        calculateHeaderValue(w.bPlan.Planned_Finishing__c, 'Finishing', 'Planned');
        calculateHeaderValue(w.bPlan.Q1_All_Boards__c, 'AllBoard', 'Q1');
        calculateHeaderValue(w.bPlan.Q1_VAP__c, 'VAP', 'Q1');
        calculateHeaderValue(w.bPlan.Q1_Tape__c, 'Tape', 'Q1');
        calculateHeaderValue(w.bPlan.Q1_Finishing__c, 'Finishing', 'Q1');
        calculateHeaderValue(w.bPlan.Q2_All_Boards__c, 'AllBoard', 'Q2');
        calculateHeaderValue(w.bPlan.Q2_VAP__c, 'VAP', 'Q2');
        calculateHeaderValue(w.bPlan.Q2_Tape__c, 'Tape', 'Q2');
        calculateHeaderValue(w.bPlan.Q2_Finishing__c, 'Finishing', 'Q2');
        calculateHeaderValue(w.bPlan.Q3_All_Boards__c, 'AllBoard', 'Q3');
        calculateHeaderValue(w.bPlan.Q3_VAP__c, 'VAP', 'Q3');
        calculateHeaderValue(w.bPlan.Q3_Tape__c, 'Tape', 'Q3');
        calculateHeaderValue(w.bPlan.Q3_Finishing__c, 'Finishing', 'Q3');
        calculateHeaderValue(w.bPlan.Q4_All_Boards__c, 'AllBoard', 'Q4');
        calculateHeaderValue(w.bPlan.Q4_VAP__c, 'VAP', 'Q4');
        calculateHeaderValue(w.bPlan.Q4_Tape__c, 'Tape', 'Q4');
        calculateHeaderValue(w.bPlan.Q4_Finishing__c, 'Finishing', 'Q4');
        calculateHeaderValue(w.bPlan.Total_YTD_All_Board__c, 'AllBoard', 'TotalYTD');
        calculateHeaderValue(w.bPlan.Total_YTD_VAP__c, 'VAP', 'TotalYTD');
        calculateHeaderValue(w.bPlan.Total_YTD_Tape__c, 'Tape', 'TotalYTD');
        calculateHeaderValue(w.bPlan.Total_YTD_Finishing__c, 'Finishing', 'TotalYTD');
        calculateHeaderValue(w.bPlan.Previous_Year_Actual_All_Boards__c, 'AllBoard', 'PreviousYear');
        calculateHeaderValue(w.bPlan.Previous_Year_Actual_VAP__c, 'VAP', 'PreviousYear');
        calculateHeaderValue(w.bPlan.Previous_Year_Actual_Tape__c, 'Tape', 'PreviousYear');
        calculateHeaderValue(w.bPlan.Previous_Year_Actual_Finishing__c, 'Finishing', 'PreviousYear');
        calculateHeaderValue(w.bPlan.All_Board_Actual_to_Budget__c, 'AllBoard', 'ActualToBudget');
        calculateHeaderValue(w.bPlan.VAP_Actual_to_Budget__c, 'VAP', 'ActualToBudget');
        calculateHeaderValue(w.bPlan.Tape_Actual_to_Budget__c, 'Tape', 'ActualToBudget');
        calculateHeaderValue(w.bPlan.Finishing_Actual_to_Budget__c, 'Finishing', 'ActualToBudget');
        calculateHeaderValue(w.bPlan.Actual_VAP_of_Boards__c, 'VAP', 'ActualVAPofBoard');
        calculateHeaderValue(w.bPlan.Budget_VAP_of_Boards__c, 'VAP', 'BudgetVAPofBoard');
    }
    
    private void performHeaderCalculations() {
        calculateHeaderValue(bpo.Planned_All_Boards__c, 'AllBoard', 'Planned');
        calculateHeaderValue(bpo.Planned_VAP__c, 'VAP', 'Planned');
        calculateHeaderValue(bpo.Planned_Tape__c, 'Tape', 'Planned');
        calculateHeaderValue(bpo.Planned_Finishing__c, 'Finishing', 'Planned');
        calculateHeaderValue(bpo.Q1_All_Boards__c, 'AllBoard', 'Q1');
        calculateHeaderValue(bpo.Q1_VAP__c, 'VAP', 'Q1');
        calculateHeaderValue(bpo.Q1_Tape__c, 'Tape', 'Q1');
        calculateHeaderValue(bpo.Q1_Finishing__c, 'Finishing', 'Q1');
        calculateHeaderValue(bpo.Q2_All_Boards__c, 'AllBoard', 'Q2');
        calculateHeaderValue(bpo.Q2_VAP__c, 'VAP', 'Q2');
        calculateHeaderValue(bpo.Q2_Tape__c, 'Tape', 'Q2');
        calculateHeaderValue(bpo.Q2_Finishing__c, 'Finishing', 'Q2');
        calculateHeaderValue(bpo.Q3_All_Boards__c, 'AllBoard', 'Q3');
        calculateHeaderValue(bpo.Q3_VAP__c, 'VAP', 'Q3');
        calculateHeaderValue(bpo.Q3_Tape__c, 'Tape', 'Q3');
        calculateHeaderValue(bpo.Q3_Finishing__c, 'Finishing', 'Q3');
        calculateHeaderValue(bpo.Q4_All_Boards__c, 'AllBoard', 'Q4');
        calculateHeaderValue(bpo.Q4_VAP__c, 'VAP', 'Q4');
        calculateHeaderValue(bpo.Q4_Tape__c, 'Tape', 'Q4');
        calculateHeaderValue(bpo.Q4_Finishing__c, 'Finishing', 'Q4');
        calculateHeaderValue(bpo.Total_YTD_All_Board__c, 'AllBoard', 'TotalYTD');
        calculateHeaderValue(bpo.Total_YTD_VAP__c, 'VAP', 'TotalYTD');
        calculateHeaderValue(bpo.Total_YTD_Tape__c, 'Tape', 'TotalYTD');
        calculateHeaderValue(bpo.Total_YTD_Finishing__c, 'Finishing', 'TotalYTD');
        calculateHeaderValue(bpo.Previous_Year_Actual_All_Boards__c, 'AllBoard', 'PreviousYear');
        calculateHeaderValue(bpo.Previous_Year_Actual_VAP__c, 'VAP', 'PreviousYear');
        calculateHeaderValue(bpo.Previous_Year_Actual_Tape__c, 'Tape', 'PreviousYear');
        calculateHeaderValue(bpo.Previous_Year_Actual_Finishing__c, 'Finishing', 'PreviousYear');
        calculateHeaderValue(bpo.All_Board_Actual_to_Budget__c, 'AllBoard', 'ActualToBudget');
        calculateHeaderValue(bpo.VAP_Actual_to_Budget__c, 'VAP', 'ActualToBudget');
        calculateHeaderValue(bpo.Tape_Actual_to_Budget__c, 'Tape', 'ActualToBudget');
        calculateHeaderValue(bpo.Finishing_Actual_to_Budget__c, 'Finishing', 'ActualToBudget');
        calculateHeaderValue(bpo.Actual_VAP_of_Boards__c, 'VAP', 'ActualVAPofBoard');
        calculateHeaderValue(bpo.Budget_VAP_of_Boards__c, 'VAP', 'BudgetVAPofBoard');
        calculateHeaderValue(bpo.All_Board_Actual_to_Budget__c, 'AllBoard', 'Actual % to Budget');
        calculateHeaderValue(bpo.VAP_Actual_to_Budget__c, 'VAP', 'Actual % to Budget');
        calculateHeaderValue(bpo.Tape_Actual_to_Budget__c, 'Tape', 'Actual % to Budget');
        calculateHeaderValue(bpo.Finishing_Actual_to_Budget__c, 'Finishing', 'Actual % to Budget');
    }
    
    private void calculateHeaderValue(Decimal nVal, String pType, String colName) {
        if(nVal != null) {
            if(colName == 'Planned') {
                if(pType == 'AllBoard') bp.Planned_All_Boards__c = setColHeaderValue(bp.Planned_All_Boards__c, nVal);
                if(pType == 'VAP') bp.Planned_VAP__c = setColHeaderValue(bp.Planned_VAP__c, nVal);
                if(pType == 'Tape') bp.Planned_Tape__c = setColHeaderValue(bp.Planned_Tape__c, nVal);
                if(pType == 'Finishing') bp.Planned_Finishing__c = setColHeaderValue(bp.Planned_Finishing__c, nVal);
            } else if(colName == 'Q1') {
                if(pType == 'AllBoard') bp.Q1_All_Boards__c = setColHeaderValue(bp.Q1_All_Boards__c, nVal);
                if(pType == 'VAP') bp.Q1_VAP__c = setColHeaderValue(bp.Q1_VAP__c, nVal);
                if(pType == 'Tape') bp.Q1_Tape__c = setColHeaderValue(bp.Q1_Tape__c, nVal);
                if(pType == 'Finishing') bp.Q1_Finishing__c = setColHeaderValue(bp.Q1_Finishing__c, nVal);
            } else if(colName == 'Q2') {
                if(pType == 'AllBoard') bp.Q2_All_Boards__c = setColHeaderValue(bp.Q2_All_Boards__c, nVal);
                if(pType == 'VAP') bp.Q2_VAP__c = setColHeaderValue(bp.Q2_VAP__c, nVal);
                if(pType == 'Tape') bp.Q2_Tape__c = setColHeaderValue(bp.Q2_Tape__c, nVal);
                if(pType == 'Finishing') bp.Q2_Finishing__c = setColHeaderValue(bp.Q2_Finishing__c, nVal);
            } else if(colName == 'Q3') {
                if(pType == 'AllBoard') bp.Q3_All_Boards__c = setColHeaderValue(bp.Q3_All_Boards__c, nVal);
                if(pType == 'VAP') bp.Q3_VAP__c = setColHeaderValue(bp.Q3_VAP__c, nVal);
                if(pType == 'Tape') bp.Q3_Tape__c = setColHeaderValue(bp.Q3_Tape__c, nVal);
                if(pType == 'Finishing') bp.Q3_Finishing__c = setColHeaderValue(bp.Q3_Finishing__c, nVal);
            } else if(colName == 'Q4') {
                if(pType == 'AllBoard') bp.Q4_All_Boards__c = setColHeaderValue(bp.Q4_All_Boards__c, nVal);
                if(pType == 'VAP') bp.Q4_VAP__c = setColHeaderValue(bp.Q4_VAP__c, nVal);
                if(pType == 'Tape') bp.Q4_Tape__c = setColHeaderValue(bp.Q4_Tape__c, nVal);
                if(pType == 'Finishing') bp.Q4_Finishing__c = setColHeaderValue(bp.Q4_Finishing__c, nVal);
            } else if(colName == 'TotalYTD') {
                if(pType == 'AllBoard') bp.Total_YTD_All_Board__c = setColHeaderValue(bp.Total_YTD_All_Board__c, nVal);
                if(pType == 'VAP') bp.Total_YTD_VAP__c = setColHeaderValue(bp.Total_YTD_VAP__c, nVal);
                if(pType == 'Tape') bp.Total_YTD_Tape__c = setColHeaderValue(bp.Total_YTD_Tape__c, nVal);
                if(pType == 'Finishing') bp.Total_YTD_Finishing__c = setColHeaderValue(bp.Total_YTD_Finishing__c, nVal);
            } else if(colName == 'PreviousYear') {
                if(pType == 'AllBoard') bp.Previous_Year_Actual_All_Boards__c = setColHeaderValue(bp.Previous_Year_Actual_All_Boards__c, nVal);
                if(pType == 'VAP') bp.Previous_Year_Actual_VAP__c = setColHeaderValue(bp.Previous_Year_Actual_VAP__c, nVal);
                if(pType == 'Tape') bp.Previous_Year_Actual_Tape__c = setColHeaderValue(bp.Previous_Year_Actual_Tape__c, nVal);
                if(pType == 'Finishing') bp.Previous_Year_Actual_Finishing__c = setColHeaderValue(bp.Previous_Year_Actual_Finishing__c, nVal);
            } else if(colName == 'ActualVAPofBoard') {
                if(pType == 'VAP') {
                    //Arpit 18-May-2015 : commenting this line with respect to change in formulae as pes new Vap Calculations mailed by client.
                    //bp.Actual_VAP_of_Boards__c = setColHeaderValue(bp.Actual_VAP_of_Boards__c, nVal);
                    bp.Actual_VAP_of_Boards__c = BusinessPlanUtil.calculatePercent(bp.Total_YTD_VAP__c, bp.Total_YTD_All_Board__c);
                }
            } else if(colName == 'BudgetVAPofBoard') { 
                if(pType == 'VAP') {
                    //Arpit 18-May-2015 : commenting this line with respect to change in formulae as pes new Vap Calculations mailed by client.
                    //bp.Budget_VAP_of_Boards__c = setColHeaderValue(bp.Budget_VAP_of_Boards__c, nVal);
                    bp.Budget_VAP_of_Boards__c = BusinessPlanUtil.calculatePercent(bpo.Budget_VAP__c, bpo.Budget_All_Boards__c);
                }
            } else if(colName == 'Actual % to Budget'){
                if(pType == 'AllBoard')bp.All_Board_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(bp.Total_YTD_All_Board__c,bp.Planned_All_Boards__c);
                if(pType == 'VAP') bp.VAP_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(bp.Total_YTD_VAP__c,bp.Planned_VAP__c);
                if(pType == 'Tape') bp.Tape_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(bp.Total_YTD_Tape__c,bp.Planned_Tape__c);
                if(pType == 'Finishing') bp.Finishing_Actual_to_Budget__c = BusinessPlanUtil.calculatePercent(bp.Total_YTD_Finishing__c,bp.Planned_Finishing__c);
            }else if(colName == 'ActualToBudget') {
                if(pType == 'AllBoard')bp.All_Board_Actual_to_Budget__c = setColHeaderValue(bp.All_Board_Actual_to_Budget__c, nVal);
                if(pType == 'VAP') bp.VAP_Actual_to_Budget__c = setColHeaderValue(bp.VAP_Actual_to_Budget__c, nVal);
                if(pType == 'Tape') bp.Tape_Actual_to_Budget__c = setColHeaderValue(bp.Tape_Actual_to_Budget__c, nVal);
                if(pType == 'Finishing') bp.Finishing_Actual_to_Budget__c = setColHeaderValue(bp.Finishing_Actual_to_Budget__c, nVal);
            }
        } 
    }
    
    
    //------------Arpit adding logic for row calculation totals on 19-11-2014---------------------------------------------
    //CF Commenting out function - no longer called anywhere
    //private void performRowCalculation(){
    //    bpo.Total_YTD_All_Board__c = bpo.Q1_All_Boards__c + bpo.Q2_All_Boards__c + bpo.Q3_All_Boards__c + bpo.Q4_All_Boards__c;
    //    bpo.Total_YTD_VAP__c = bpo.Q1_VAP__c + bpo.Q2_VAP__c + bpo.Q3_VAP__c + bpo.Q4_VAP__c;
    //    bpo.Total_YTD_Tape__c = bpo.Q1_Tape__c + bpo.Q2_Tape__c + bpo.Q3_Tape__c + bpo.Q4_Tape__c;
    //    bpo.Total_YTD_Finishing__c = bpo.Q1_Finishing__c + bpo.Q2_Finishing__c + bpo.Q3_Finishing__c + bpo.Q4_Finishing__c;
    //}
    //CF End
    private void performRowCalculation(Wrapper w){
        Decimal ttlAllBoards = 0, ttlVAP =0, ttlTape = 0, ttlFinishing = 0;
        Decimal perAllBoards = 0,perVAP = 0,perTape = 0, perFinishing = 0;
        if(w.bPlan.Q1_All_Boards__c != null) ttlAllBoards += w.bPlan.Q1_All_Boards__c;
        if(w.bPlan.Q2_All_Boards__c != null) ttlAllBoards += w.bPlan.Q2_All_Boards__c;
        if(w.bPlan.Q3_All_Boards__c != null) ttlAllBoards += w.bPlan.Q3_All_Boards__c;
        if(w.bPlan.Q4_All_Boards__c != null) ttlAllBoards += w.bPlan.Q4_All_Boards__c;
        w.bPlan.Total_YTD_All_Board__c = ttlAllBoards;
        if(w.bPlan.Planned_All_Boards__c != null && w.bPlan.Total_YTD_All_Board__c != null && w.bPlan.Planned_All_Boards__c != 0){
            perAllBoards = ((w.bPlan.Total_YTD_All_Board__c/w.bPlan.Planned_All_Boards__c)*100);
            w.bPlan.All_Board_Actual_to_Budget__c = perAllBoards;
        }
        
        if(w.bPlan.Q1_VAP__c != null) ttlVAP += w.bPlan.Q1_VAP__c;
        if(w.bPlan.Q2_VAP__c != null) ttlVAP += w.bPlan.Q2_VAP__c;
        if(w.bPlan.Q3_VAP__c != null) ttlVAP += w.bPlan.Q3_VAP__c; 
        if(w.bPlan.Q4_VAP__c != null) ttlVAP += w.bPlan.Q4_VAP__c;
        w.bPlan.Total_YTD_VAP__c = ttlVAP;
        if(w.bPlan.Planned_VAP__c != null && w.bPlan.Total_YTD_VAP__c != null && w.bPlan.Planned_VAP__c != 0){
            perVAP = ((w.bPlan.Total_YTD_VAP__c/w.bPlan.Planned_VAP__c)*100);
            w.bPlan.VAP_Actual_to_Budget__c = perVAP;
        }
        
        if(w.bPlan.Q1_Tape__c != null) ttlTape += w.bPlan.Q1_Tape__c;
        if(w.bPlan.Q2_Tape__c != null) ttlTape += w.bPlan.Q2_Tape__c;
        if(w.bPlan.Q3_Tape__c != null) ttlTape += w.bPlan.Q3_Tape__c;
        if(w.bPlan.Q4_Tape__c != null) ttlTape += w.bPlan.Q4_Tape__c;
        w.bPlan.Total_YTD_Tape__c = ttlTape;
        if(w.bPlan.Planned_Tape__c != null && w.bPlan.Total_YTD_Tape__c != null && w.bPlan.Planned_Tape__c != 0){
            perTape = ((w.bPlan.Total_YTD_Tape__c/w.bPlan.Planned_Tape__c)*100);
            w.bPlan.Tape_Actual_to_Budget__c = perTape;
        }
         
        if(w.bPlan.Q1_Finishing__c != null) ttlFinishing += w.bPlan.Q1_Finishing__c;
        if(w.bPlan.Q1_Finishing__c != null) ttlFinishing += w.bPlan.Q1_Finishing__c;
        if(w.bPlan.Q1_Finishing__c != null) ttlFinishing += w.bPlan.Q1_Finishing__c;
        if(w.bPlan.Q1_Finishing__c != null) ttlFinishing += w.bPlan.Q1_Finishing__c;
        w.bPlan.Total_YTD_Finishing__c = ttlFinishing;
        if(w.bPlan.Planned_Finishing__c != null && w.bPlan.Total_YTD_Finishing__c != null && w.bPlan.Planned_Finishing__c != 0){
            perFinishing = ((w.bPlan.Total_YTD_Finishing__c/w.bPlan.Planned_Finishing__c)*100);
            w.bPlan.Finishing_Actual_to_Budget__c = perFinishing;
        }
    }
    
    
    //----------------------End of Arpit Changes on 19-11-2014----------------------------------------------
    
    
    //--------------method to set Header value of all the records when page loads----------------------------
    private Decimal setColHeaderValue(Decimal x, Decimal y) {
        if(x == null) x = y;
        else x += y;
        return x;
    }
    
    
    
/*  //---------------------method to set % age value when page loads-----------------------------------------
    private Decimal calculatePercent(Decimal d1, Decimal d2){
        Decimal percent = 0;
        System.debug('colNameincalper:::'+d1+'--'+d2);
        if(d1 != null && d2 != null && d2 != 0 && d1 != 0){
            percent = Math.floor((d1/d2)*100);
            return percent;
        }else{
            percent = 0;
            return percent;
        }
    }*/
    
    /*
    private Business_Plan_Others__c updateAccountIds(Business_Plan_Others__c bpoParam, Set<Id> setAcc){
        String accIds = '';
        for(Id accObj : setAcc){
            if(accIds == '') accIds += accObj;
            else accIds += ',' + accObj;
        }
        bpoParam.Account_Id__c = accIds; 
        return bpoParam;
    }
    
    public void searchBusinessPlan(){
        try{
            List<User> u = new List<User>();
            if(userSelected!=null && userSelected!=''){
                u = [select id, Name, ManagerId, User_Territory_Code__c, Profile.Name, userRole.Name from user where id = :userSelected];
            }
            if(u.size()>0 && (u.get(0).Profile.Name.contains('USA TM User') || u.get(0).Profile.Name.contains('System Administrator'))){
                tmUser = true;
            }else{
                tmUser = false;
            }
            fetchBP();
        } catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage())); 
        }
    }
    
    
    //Arpit 09/02/2015 : Method which is called to fetch all the records when manager selects the user.
    private void fetchBP(){
        try{
            wrapper = new List<Wrapper>();
            bPlanData = new List<Business_Plan__c>();
            bp = new Business_Plan__c();
            System.debug('QQ!!!'+userSelected);
            //run a query on list<Businessplan> 
            
            bPlanData = [Select b.Previous_Year_Actual_Finishing__c,b.Previous_Year_Actual_All_Boards__c,b.Previous_Year_Actual_Tape__c,b.Previous_Year_Actual_VAP__c,b.Budget_VAP_of_Boards__c, b.Actual_VAP_of_Boards__c,b.VAP_Actual_to_Budget__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.All_Board_Actual_to_Budget__c,b.Total_YTD_Finishing__c,b.Q4_Finishing__c, b.Q3_Finishing__c, b.Q2_Finishing__c,b.Q1_Finishing__c,b.Budget_Finishing__c,b.Total_YTD_Tape__c,b.Q4_Tape__c,b.Q3_Tape__c,b.Q2_Tape__c,b.Q1_Tape__c,b.Budget_Tape__c,b.Total_YTD_VAP__c,b.Q4_VAP__c, b.Q3_VAP__c, b.Q2_VAP__c,b.Q1_VAP__c,b.Budget_VAP__c,b.Total_YTD_All_Board__c,b.Q4_All_Boards__c,b.Q3_All_Boards__c,b.Q2_All_Boards__c,b.Q1_All_Boards__c,b.Planned_All_Boards__c,b.Account__c,b.Budget_All_Boards__c from Business_Plan__c b where Year__c =: String.valueOf(bpYear) and b.User_Id__c =: userSelected];
            
            // loop in  list<Businessplan>, create a MAP variable with acc id as Key value, and Bp as Value.    
            //(mapBusinessPlan.put(Acc id, bp))     
            System.debug('Obj::::'+bPlanData);
            
            // take Account Id in a set Variable
            setAccId = new Set<Id>();
            for(Business_Plan__c b : bPlanData){
                setAccId.add(b.Account__c);
            }
            
            setAccId = fetchRelatedAccountIds(setAccId);
            
            //run a query on Acc obj.
            accData = [Select a.Name,a.BillingState, a.BillingCity, a.Top_Most_Parent_Account__c From Account a where a.id IN :setAccId order By a.CreatedDate ASC];
            System.debug('Test::::'+accData);
            
            System.debug('After'+mapBusinessPlan);
            for(Business_Plan__c bpObj : bPlanData){
                mapBusinessPlan.put(bpObj.Account__c,bpObj);
                System.debug('in the Loop::::'+mapBusinessPlan);
            }
            
            System.debug('Map:::::'+mapBusinessPlan);
            
            List<Business_Plan__c> bpPlanLastYear = [Select Id, Account__c, Total_YTD_Finishing__c, Total_YTD_All_Board__c, Total_YTD_Tape__c, Total_YTD_VAP__c 
                  from Business_Plan__c b where b.Account__c IN :setAccId and Year__c =: String.valueOf(bpLastYear) and b.User_Id__c =: userSelected];
   
            for(Business_Plan__c bpLast : bpPlanLastYear) {
                perviousYearActualsMap.put(bpLast.Account__c, bpLast);
            }
            Map<ID,List<Wrapper>> accIDLstMap = new Map<ID,List<Wrapper>>();
            //next loop on acc list, instance of wrapper class and add it to the list.
            for(Account a : accData){
                //Shakti - Nov 18, 2015 to control to display selected account on add to business plan screen.
                if((lastYearPlan!='Yes' && checkPage=='New' && newBPAccID==a.Id) || (checkPage=='New' && lastYearPlan=='Yes') || (checkPage!='New' && lastYearPlan!='Yes')){
                    Wrapper wrap = new Wrapper();
                    wrap.acc = a;
                    wrap.viewAccHierarchy = false;
                    if(a.BillingState != null && a.BillingCity != null){
                        wrap.location = a.BillingCity +', '+ a.BillingState;
                    }else if(a.BillingState != null){
                        wrap.location = a.BillingState;
                    }else if(a.BillingCity != null){
                        wrap.location = a.BillingCity;
                    }
                    if(mapBusinessPlan != null && mapBusinessPlan.containsKey(a.id)){
                        wrap.bPlan = mapBusinessPlan.get(a.id);
                        //performHeaderCalculations(wrap);
    ////////////////////////////////////////Add function by Arpit on 19-11-2014////////////////////////////////////////
                        System.debug('123::::'+wrap);
                        performRowCalculation(wrap);
                        performHeaderCalculations(wrap);
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    }else{
                        wrap.bPlan = new Business_Plan__c();
                        wrap.bPlan.Account__c = a.Id;// after that bPlan,Name = Account Name + year
                        wrap.bPlan.User_Id__c = userSelected;
                        //System.debug('UserId::--'+wrap.bPlan.User_Id__c);
                        wrap.bPlan.Name = a.Name+'-'+bpYear;
                        wrap.bPlan.Year__c = String.valueOf(bpYear);
                        Business_Plan__c bpLast = perviousYearActualsMap.get(a.Id);
                        if(bpLast != null) {
                            wrap.bPlan.Previous_Year_Actual_All_Boards__c = bpLast.Total_YTD_All_Board__c;
                            wrap.bPlan.Previous_Year_Actual_VAP__c = bpLast.Total_YTD_VAP__c;
                            wrap.bPlan.Previous_Year_Actual_Tape__c = bpLast.Total_YTD_Tape__c;
                            wrap.bPlan.Previous_Year_Actual_Finishing__c = bpLast.Total_YTD_Finishing__c;
                        }
                    }
                    wrapper.add(wrap);
                    if(!accIDLstMap.containsKey(a.Top_Most_Parent_Account__c)){
                        accIDLstMap.put(a.Top_Most_Parent_Account__c,new List<wrapper>());
                    }
                    accIDLstMap.get(a.Top_Most_Parent_Account__c).add(wrap);
                }
            }
            if(accIDLstMap.size()>0){
                wrapper = new List<Wrapper>();
                String trColor = '#eeeeee';
                for(String a : accIDLstMap.keySet()){
                    if(trColor == '#eeeeee'){trColor = '#aeaeae';}else{trColor = '#eeeeee';}
                    List<Wrapper> tempWrapper = new List<Wrapper>();
                    for(Wrapper wp : accIDLstMap.get(a)){
                        wp.color = trColor;
                        tempWrapper.add(wp);
                    }
                    tempWrapper.sort();
                    wrapper.addAll(tempWrapper);
                }
            }
            bpSize = wrapper.size();
            System.debug('Map::::'+mapBusinessPlan);
            if(bpo != null) {
                performHeaderCalculations();
            }
        } catch (Exception e) {
            
        }
    }
    
    //---------------------------------------method to show List of accounts which have already business plan 
    private Set<Id> fetchRelatedAccountIds(Set<Id> setAcc){
        Set<Id> accountIds = new Set<Id>();
        System.debug('fetchAccId::::'+setAcc);
        List<Account> accountList = [Select a.Id From Account a where a.Id =: setAcc];
        System.debug('fetchAccId'+accountList);
        List<Business_Plan_Others__c> relatedId = new List<Business_Plan_Others__c>();
        List<Business_Plan_Others__c> relatedIdLastYear = new List<Business_Plan_Others__c>();
        if(visibilityPreviousYear){
            // similar query for previous yesr related id 2 
            relatedIdLastYear = [Select b.Account_Id__c, b.Total_YTD_VAP__c, b.Total_YTD_Tape__c, b.Total_YTD_Finishing__c, b.Total_YTD_All_Board__c From Business_Plan_Others__c b where b.Name =: userSelected and Year__c =: String.valueOf(bpLastYear)];        
        } 
        relatedId = [Select b.Account_Id__c,b.VAP_Actual_to_Budget__c, b.Total_YTD_VAP__c, b.Total_YTD_Tape__c, b.Total_YTD_Finishing__c, b.Total_YTD_All_Board__c, b.Tape_Actual_to_Budget__c, b.Q4_VAP__c, b.Q4_Tape__c, b.Q4_Finishing__c, b.Q4_All_Boards__c, b.Q3_VAP__c, b.Q3_Tape__c, b.Q3_Finishing__c, b.Q3_All_Boards__c, b.Q2_VAP__c, b.Q2_Tape__c, b.Q2_Finishing__c, b.Q2_All_Boards__c, b.Q1_VAP__c, b.Q1_Tape__c, b.Q1_Finishing__c, b.Q1_All_Boards__c, b.Previous_Year_Actual_VAP__c, b.Previous_Year_Actual_Tape__c, b.Previous_Year_Actual_Finishing__c, b.Previous_Year_Actual_All_Boards__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Planned_All_Boards__c, b.Finishing_Actual_to_Budget__c, b.Budget_VAP_of_Boards__c, b.Budget_VAP__c, b.Budget_Tape__c, b.Budget_Finishing__c, b.Budget_All_Boards__c, b.All_Board_Actual_to_Budget__c, b.Actual_VAP_of_Boards__c From Business_Plan_Others__c b where b.Name =: userSelected and Year__c =: String.valueOf(bpYear)];
        
        System.debug('fetchbpoId'+relatedId);
        
        
        if(relatedId.size() > 0){
            bpo = relatedId[0];
            System.debug('Return BPO123bpo'+bpo);
            if(bpo.Account_Id__c != null){
                System.debug('bpo.Account_Id__c::::'+bpo.Account_Id__c);
                List<String> accIdsLst = bpo.Account_Id__c.split(',');
                System.debug('AccIdsLst::::'+accIdsLst);
                for(String s : accIdsLst){
                    accountIds.add(s);
                }
                for(Id accObj : setAcc){
                    if(!accountIds.contains(accObj)){
                        accountIds.add(accObj);
                        if(bpo.Account_Id__c == '') bpo.Account_Id__c += accObj;
                        else bpo.Account_Id__c += ',' + accObj;
                    }
                }
            } else {
                accountIds = setAcc;
                bpo = updateAccountIds(bpo, setAcc);
            }
        } else {
            bpo = new Business_Plan_Others__c();
            bpo.Name = userSelected;
            bpo.Year__c = String.valueOf(bpYear);
            System.debug('Return BPO123');
            
            if(visibilityPreviousYear && relatedIdLastYear.size() > 0){
                bpo.Previous_Year_Actual_All_Boards__c = relatedIdLastYear[0].Total_YTD_All_Board__c;
                bpo.Previous_Year_Actual_VAP__c = relatedIdLastYear[0].Total_YTD_VAP__c;
                bpo.Previous_Year_Actual_Tape__c = relatedIdLastYear[0].Total_YTD_Tape__c;
                bpo.Previous_Year_Actual_Finishing__c = relatedIdLastYear[0].Total_YTD_Finishing__c;
            }
            accountIds = setAcc;
            bpo = updateAccountIds(bpo, setAcc);
            System.debug('Return BPO'+bpo);
        }
        System.debug('ReturnAcc:::'+accountIds);
        return accountIds;
         
    }
    
    //this method saves the recent Accounts that are selected to add to Plan
    public void addAccountToPlan() {
        if(bpo != null) upsert bpo;
    }
    
    //------------------------------------method for delete record-------------------------------
    public void deleteRecord(){
        try{
            System.debug('deleteId: '+deleteId);
            if(deleteId != null && deleteId != '') {
                String updatedAccIds = '';
                if(bpo.Account_Id__c != null) {
                    List<String> accDeleteId = bpo.Account_Id__c.split(',');
                    for(String accD : accDeleteId){
                        if(accD == deleteId) continue;
                        if(updatedAccIds == '') updatedAccIds += accD;
                        else updatedAccIds += ',' + accD;
                    }
                    bpo.Account_Id__c = updatedAccIds; 
                }
                Integer delIndex = 0;
                String bpIdToDel = '';
                for(Wrapper w : wrapper){
                    if(w.acc.Id == deleteId) {
                        if(w.bPlan.Id != null) bpIdToDel = w.bPlan.Id;
                        break;
                    }
                    delIndex++;
                }
                wrapper.remove(delIndex);
                //if(bpIdToDel != '') delete [Select Id From Business_Plan__c Where Id =: bpIdToDel];
                if(bpIdToDel != '') bPlanIdsToDelete.add(bpIdToDel);
                
                bp = new Business_Plan__c();
                acc = new Account();
                for(Wrapper w : wrapper){
                    w = calculateBPValues(w);
                    performHeaderCalculations(w);
                }
                bpSize = wrapper.size();
                System.debug('New bpSize'+bpSize);
                if(bpo != null){
                    bpo = calculateBPOValues(bpo);
                    performHeaderCalculations();
                }
                
            }
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage() + deleteId)); 
        }
    }
    
    public void viewHierarchy() {
        if(accountID!=null && accountID!='' && wrapper!=null){
            for(Wrapper w : wrapper){
                if(w.acc!=null && w.acc.Id!=null && w.acc.Id==accountID){
                    if(w.viewAccHierarchy==true){
                        w.bPlanTEMP = new Business_Plan__c();
                        Set<Id> setCurrentId = new Set<Id>{w.acc.Id};
                        hierarchyAccIds = new Set<Id>();
                        hierarchyAccIds = setCurrentId;
                        
                        if(userSelected!=null && userSelected!=''){
                            List<User> u = [select id, Name, ManagerId, User_Territory_Code__c, Profile.Name, userRole.Name from user where id = :userSelected];                        
                            if(u.get(0).Profile.Name.contains('USA TM User') || u.get(0).Profile.Name.contains('System Administrator')){
                                Set<Id> newAccIds = queryOnAccounts(setCurrentId);
                                while(newAccIds.size() > 0) {
                                  newAccIds = queryOnAccounts(newAccIds);
                                }
                                
                                String queryAcc = 'Select id, Name, BillingState, BillingCity, (Select Previous_Year_Actual_Finishing__c,Previous_Year_Actual_All_Boards__c,Previous_Year_Actual_Tape__c,Previous_Year_Actual_VAP__c,Budget_VAP_of_Boards__c, Actual_VAP_of_Boards__c,VAP_Actual_to_Budget__c, Planned_VAP__c, Planned_Tape__c, Planned_Finishing__c, Tape_Actual_to_Budget__c, Finishing_Actual_to_Budget__c, All_Board_Actual_to_Budget__c,Total_YTD_Finishing__c,Q4_Finishing__c, Q3_Finishing__c, Q2_Finishing__c,Q1_Finishing__c,Budget_Finishing__c,Total_YTD_Tape__c,Q4_Tape__c,Q3_Tape__c,Q2_Tape__c,Q1_Tape__c,Budget_Tape__c,Total_YTD_VAP__c,Q4_VAP__c, Q3_VAP__c, Q2_VAP__c,Q1_VAP__c,Budget_VAP__c,Total_YTD_All_Board__c,Q4_All_Boards__c,Q3_All_Boards__c,Q2_All_Boards__c,Q1_All_Boards__c,Planned_All_Boards__c,Account__c,Budget_All_Boards__c from Business_Plans__r where Year__c =\''+String.valueOf(bpYear)+'\'';
                                queryAcc += ' and User_Id__c =\''+userSelected+'\'';
                                queryAcc += '),(Select Name, Id, CreatedById, Action_Item__c, Due_Date__c, Account__c From CTG_Strategies__r order by Item__c),(Select Due_Date__c, CreatedById, Action_Item__c, Account__c From Customer_Strategies__r order by Item__c) From Account';
                                queryAcc += ' where Id IN :hierarchyAccIds';
                                List<Account> accList = Database.query(queryAcc);
                                w.bPlanTEMP = searchHierarchyDetail(accList);
                            }
                        }
                    }else{
                        w.bPlanTEMP = new Business_Plan__c();
                    }
                }
            }
        }
    }
    
    // this will take out the list of accounts having Business Plan for the year.
  private Business_Plan__c searchHierarchyDetail(List<Account> accList) {
    Business_Plan__c bPlanTemp = new Business_Plan__c();
    try {
      bPlanTemp.Planned_All_Boards__c = 0;
      bPlanTemp.Q1_All_Boards__c = 0;
      bPlanTemp.Q2_All_Boards__c = 0;
      bPlanTemp.Q3_All_Boards__c = 0;
      bPlanTemp.Q4_All_Boards__c = 0;
      bPlanTemp.Planned_VAP__c = 0;
      bPlanTemp.Q1_VAP__c = 0;
      bPlanTemp.Q2_VAP__c = 0;
      bPlanTemp.Q3_VAP__c = 0;
      bPlanTemp.Q4_VAP__c = 0;
      bPlanTemp.Planned_Tape__c = 0;
      bPlanTemp.Q1_Tape__c = 0;
      bPlanTemp.Q2_Tape__c = 0;
      bPlanTemp.Q3_Tape__c = 0;
      bPlanTemp.Q4_Tape__c = 0;
      bPlanTemp.Planned_Finishing__c = 0;
      bPlanTemp.Q1_Finishing__c = 0;
      bPlanTemp.Q2_Finishing__c = 0;
      bPlanTemp.Q3_Finishing__c = 0;
      bPlanTemp.Q4_Finishing__c = 0;
      bPlanTemp.Total_YTD_All_Board__c = 0;
      bPlanTemp.Total_YTD_VAP__c = 0;
      bPlanTemp.Total_YTD_Tape__c = 0;
      bPlanTemp.Total_YTD_Finishing__c = 0;
      bPlanTemp.All_Board_Actual_to_Budget__c = 0;
      bPlanTemp.VAP_Actual_to_Budget__c = 0;
      bPlanTemp.Tape_Actual_to_Budget__c = 0;
      bPlanTemp.Finishing_Actual_to_Budget__c = 0;
      bPlanTemp.Actual_VAP_of_Boards__c = 0;
      bPlanTemp.Budget_VAP_of_Boards__c = 0;
      
      for(Account a : accList) { 
        //System.debug('a.Business_Plans__r.size()========= '+a.Business_Plans__r.size());
        if(a.Business_Plans__r.size() > 0) {
          bPlanTemp = calculateHierarchy(a.Business_Plans__r,bPlanTemp);
        }
      }
    } catch(Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
    }
    return bPlanTemp;
  }
  
  // it will calculate all the business Plan with respect to per account.
  private Business_Plan__c calculateHierarchy(List<Business_Plan__c> listBPlan,Business_Plan__c bPlanTemp) {
    try {
      //System.debug('listBPlan:::==='+listBPlan);
      for(Business_Plan__c b : listBPlan) {
        if(b.Planned_All_Boards__c != null) bPlanTemp.Planned_All_Boards__c += b.Planned_All_Boards__c;
        if(b.Q1_All_Boards__c != null) bPlanTemp.Q1_All_Boards__c += b.Q1_All_Boards__c;
        if(b.Q2_All_Boards__c != null) bPlanTemp.Q2_All_Boards__c += b.Q2_All_Boards__c;
        if(b.Q3_All_Boards__c != null) bPlanTemp.Q3_All_Boards__c += b.Q3_All_Boards__c;
        if(b.Q4_All_Boards__c != null) bPlanTemp.Q4_All_Boards__c += b.Q4_All_Boards__c;
        if(b.Total_YTD_All_Board__c != null) bPlanTemp.Total_YTD_All_Board__c += b.Total_YTD_All_Board__c;
        if(b.All_Board_Actual_to_Budget__c != null) bPlanTemp.All_Board_Actual_to_Budget__c += b.All_Board_Actual_to_Budget__c;
        if(b.Planned_VAP__c != null) bPlanTemp.Planned_VAP__c += b.Planned_VAP__c;
        if(b.Q1_VAP__c != null) bPlanTemp.Q1_VAP__c += b.Q1_VAP__c;
        if(b.Q2_VAP__c != null) bPlanTemp.Q2_VAP__c += b.Q2_VAP__c;
        if(b.Q3_VAP__c != null) bPlanTemp.Q3_VAP__c += b.Q3_VAP__c;
        if(b.Q4_VAP__c != null) bPlanTemp.Q4_VAP__c += b.Q4_VAP__c;
        if(b.Total_YTD_VAP__c != null) bPlanTemp.Total_YTD_VAP__c += b.Total_YTD_VAP__c;
        if(b.VAP_Actual_to_Budget__c != null) bPlanTemp.VAP_Actual_to_Budget__c += b.VAP_Actual_to_Budget__c;
        if(b.Actual_VAP_of_Boards__c != null) bPlanTemp.Actual_VAP_of_Boards__c += b.Actual_VAP_of_Boards__c; 
        if(b.Budget_VAP_of_Boards__c != null) bPlanTemp.Budget_VAP_of_Boards__c += b.Budget_VAP_of_Boards__c;
        if(b.Planned_Tape__c != null) bPlanTemp.Planned_Tape__c += b.Planned_Tape__c;
        if(b.Q1_Tape__c != null) bPlanTemp.Q1_Tape__c += b.Q1_Tape__c;
        if(b.Q2_Tape__c != null) bPlanTemp.Q2_Tape__c += b.Q2_Tape__c;
        if(b.Q3_Tape__c != null) bPlanTemp.Q3_Tape__c += b.Q3_Tape__c;
        if(b.Q4_Tape__c != null) bPlanTemp.Q4_Tape__c += b.Q4_Tape__c;
        if(b.Total_YTD_Tape__c != null) bPlanTemp.Total_YTD_Tape__c += b.Total_YTD_Tape__c;
        if(b.Tape_Actual_to_Budget__c != null) bPlanTemp.Tape_Actual_to_Budget__c += b.Tape_Actual_to_Budget__c;
        if(b.Planned_Finishing__c != null) bPlanTemp.Planned_Finishing__c += b.Planned_Finishing__c;
        if(b.Q1_Finishing__c != null) bPlanTemp.Q1_Finishing__c += b.Q1_Finishing__c;
        if(b.Q2_Finishing__c != null) bPlanTemp.Q2_Finishing__c += b.Q2_Finishing__c;
        if(b.Q3_Finishing__c != null) bPlanTemp.Q3_Finishing__c += b.Q3_Finishing__c;
        if(b.Q4_Finishing__c != null) bPlanTemp.Q4_Finishing__c += b.Q4_Finishing__c;
        if(b.Total_YTD_Finishing__c != null) bPlanTemp.Total_YTD_Finishing__c += b.Total_YTD_Finishing__c;
        if(b.Finishing_Actual_to_Budget__c != null) bPlanTemp.Finishing_Actual_to_Budget__c += b.Finishing_Actual_to_Budget__c;
      }
      //System.debug('bPlanTemp====================='+bPlanTemp);
      return bPlanTemp;
    } catch(Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
      return null;
    }
  }
    
    public Set<ID> queryOnAccounts(Set<Id> setId) {
        try {
          List<Account> listAcc = [Select Id from Account where ParentId IN :setId];
          //System.debug('listAcc==================='+listAcc.size());
          Set<Id> newAccIds = new Set<Id>();
          for(Account ac : listAcc) {
            //System.debug('ac==============::::'+ac.Id);
            newAccIds.add(ac.Id);
            hierarchyAccIds.add(ac.Id);
          }
          return newAccIds;
        } catch(Exception e) {
          ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
          ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
          return null;
        }
    }
    
    //--------------------------------------------Wrapper class-----------------------------------
    public class Wrapper implements Comparable{
        public Account acc{get;set;}
        public String color{get;set;}
        public Business_Plan__c bPlan{get;set;}
        public String location{get;set;}
        public Boolean viewAccHierarchy{get;set;}
        public Business_Plan__c bPlanTEMP{get;set;}
        
        public Integer compareTo(Object ObjToCompare) {
            return acc.Name.CompareTo(((Wrapper)ObjToCompare).acc.Name);
        }
    }
} */