/**************************************************************************************************
* Controller Class: BusinessPlanReport
* Created by Yogesh Kumar(Navivo), DateCreated: 11/27/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - The page is used to create  Business Plan Report.
---------------------------------------------------------------------------------------------------
* Unit Test: 
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME                 DATE            DETAIL FEATURES
    1.0      Yogesh Kumar(Navivo)      		11/27/2014      INITIAL DEVELOPMENT
    2.0		 Arpit Vashishtha (Navivo)		09/02/2015		Added a code to show table displaying Total Budget and Planned value on page.
    3.0      Hithesh Ravuri                  15/04/2025      Commenting out the component as part of the legacy API. Component version is less and no one has claimed it assuming no one is using it.    
**************************************************************************************************/
public with sharing class BusinessPlanReport {
    /*
    public String userName{get;set;}
    public String userCode{get;set;}
    public Integer year{get;set;}
    public Set<Id> accIdSet{get;set;}
    public Business_Plan_Others__c bpo{get;set;}
    public List<Business_Plan__c> bPlanData{get;set;}
    public List<CTG_Strategy__c> CtgStrategy{get;set;}
    public List<Customer_Strategy__c> customerStrategy{get;set;}
    public List<Wrapper> wrapper{get;set;}
    public boolean showUserPanel{get;set;}
    public boolean showManagerPanel{get;set;}
    public list<User> userList {get;set;}
    public String userSelected {get;set;}
    public list<selectoption> userOption {get;set;}
    public String userId{get;set;}
    public List<Account> accList{get;set;}
    public String tmName {get;set;}
    public String tmCode {get;set;}
    public User u {get;set;}
    public Wrapper w{get;set;}
    public Business_Plan__c bp{get;set;}
    
    private Map<Id, User> userMap = new Map<Id, User>();
    
    public BusinessPlanReport(){
        String userIdParam = apexpages.currentpage().getparameters().get('uId');
        String userYearParam = apexpages.currentpage().getparameters().get('year');
        String tmGetName = apexpages.currentpage().getparameters().get('tmName');
        String tmGetCode = apexpages.currentpage().getparameters().get('tmCode');
        String tmGetUserName = apexpages.currentpage().getparameters().get('tmUserName');
        showUserPanel = false;
        showManagerPanel = false;
        accIdSet = new Set<Id>();
        wrapper = new List<Wrapper>();
        accList = new List<Account>();
        bp = new Business_Plan__c();
        if(System.today().month()<11){
            year = System.today().year();
        }else if(System.today().month()>= 11){
            year = System.today().year() + 1;
        }
        bpo = new Business_Plan_Others__c();
        try{
            if(userIdParam != null && userIdParam != '' && userYearParam != null && userYearParam != ''){
                userId = userIdParam;
                system.debug('UIdIs'+userId);
                year = Integer.valueOf(userYearParam);
                system.debug('tmGetUserName'+tmGetUserName);
                if(tmGetUserName != null && tmGetUserName != ''){
                    tmName = tmGetUserName;
                    system.debug('tmName'+tmName);
                } else if(tmGetName != null && tmGetName != ''){
                    u = [select id, Name, ManagerId, User_Territory_Code__c from user where id = :tmGetName];
                    tmName = u.Name;
                }
                tmCode = tmGetCode; 
                searchReport();
            } 
            else{
                userId = UserInfo.getUserId();
                u = [select id, Name, ManagerId, User_Territory_Code__c from user where id = :userId];
                system.debug('UserDetailIs'+u);
                system.debug('userId////'+userId);
                List<User> managerUsers = [Select id, Name, ManagerId, User_Territory_Code__c from user where ManagerId =: userId];
                system.debug('managerUsers'+managerUsers);
                if(managerUsers.size() > 0) {
                    showUserPanel = false;
                    showManagerPanel = true;
                    userMap = new Map<Id, User>(managerUsers);
                    userMap.put(u.Id, u);
                    userOption = new list<selectoption>();
                    userOption.add(new selectoption('', '--Select TM--'));
                    userOption.add(new selectoption(u.Id, u.Name));
                    for(User usr : managerUsers){
                        userOption.add(new selectoption(usr.id , usr.Name));
                    }
                    fetchAccountId();
                } 
                else {
                    if(u.name != null)userName = u.Name;
                    if(u.User_Territory_Code__c != null)userCode =  u.User_Territory_Code__c;
                    showUserPanel = true;
                    showManagerPanel = false;
                    fetchAccountId();
                    system.debug('idSet'+accIdSet);
                    searchReport();
                }
            }
        }
        catch(exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage())); 
        }
    }
    //Get AccountIds based on user
    public void fetchAccountId(){
        accIdSet = new Set<Id>();
        List<Business_Plan_Others__c> relatedId = new List<Business_Plan_Others__c>();
        system.debug('YearIs'+year);
        relatedId = [Select b.Account_Id__c, b.Budget_All_Boards__c, b.Budget_VAP__c, b.Budget_Tape__c, b.Budget_Finishing__c From Business_Plan_Others__c b where b.Name =: userId and Year__c =: String.valueOf(year)];
        if(relatedId.size() > 0){
            bpo = relatedId[0];
            if(bpo.Account_Id__c != null){
                List<String> accIdsLst = bpo.Account_Id__c.split(',');
                System.debug('AccIdsLst::::'+accIdsLst);
                for(String s : accIdsLst){
                    accIdSet.add(s);
                }
                System.debug('AccIdsSet::::'+accIdSet);
            }
        }
    }
    //Search Record From Account Based on AccountIds.
    public void searchReport(){
        //wrapper = new List<Wrapper>();
        wrapper.clear();
        bp = new Business_Plan__c();
        bp.Planned_All_Boards__c = 0;
        bp.Planned_VAP__c = 0;
        bp.Planned_Tape__c = 0;
        bp.Planned_Finishing__c = 0;
        try{
            fetchAccountId();
            system.debug('idSet'+accIdSet);
            if(accIdSet.size() > 0){
                accList = [Select id, Name, BillingState, BillingCity, (Select b.Previous_Year_Actual_Finishing__c,b.Previous_Year_Actual_All_Boards__c,b.Previous_Year_Actual_Tape__c,b.Previous_Year_Actual_VAP__c,b.Budget_VAP_of_Boards__c, b.Actual_VAP_of_Boards__c,b.VAP_Actual_to_Budget__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.All_Board_Actual_to_Budget__c,b.Total_YTD_Finishing__c,b.Q4_Finishing__c, b.Q3_Finishing__c, b.Q2_Finishing__c,b.Q1_Finishing__c,b.Budget_Finishing__c,b.Total_YTD_Tape__c,b.Q4_Tape__c,b.Q3_Tape__c,b.Q2_Tape__c,b.Q1_Tape__c,b.Budget_Tape__c,b.Total_YTD_VAP__c,b.Q4_VAP__c, b.Q3_VAP__c, b.Q2_VAP__c,b.Q1_VAP__c,b.Budget_VAP__c,b.Total_YTD_All_Board__c,b.Q4_All_Boards__c,b.Q3_All_Boards__c,b.Q2_All_Boards__c,b.Q1_All_Boards__c,b.Planned_All_Boards__c,b.Account__c,b.Budget_All_Boards__c from Business_Plans__r b where Year__c =: String.valueOf(year) and User_Id__c =: userId),(Select c.Name, c.Id, c.CreatedById, c.Action_Item__c, Due_Date__c, c.Account__c From CTG_Strategies__r c order by Item__c),(Select Due_Date__c, CreatedById, Action_Item__c, Account__c From Customer_Strategies__r order by Item__c) From Account a where a.id IN :accIdSet order By a.Name ASC];
                system.debug('AccountList'+accList);
                List<Business_Plan__c> bpListShow = [Select b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Planned_All_Boards__c From Business_Plan__c b where Year__c =: String.valueOf(year) and User_Id__c =: userId];
                for(Account a : accList){
                    System.debug('start'+a);
                    Wrapper wrap = new Wrapper();
                    wrap.acc = a;
                    if(a.BillingState != null && a.BillingCity != null){
                        wrap.location = a.BillingCity +', '+ a.BillingState;
                    }else if(a.BillingState != null){
                        wrap.location = a.BillingState;
                    }else if(a.BillingCity != null){
                        wrap.location = a.BillingCity;
                    }
                    //if(a.Business_Plans__r.size() > 0)wrap.bPlan = a.Business_Plans__r[0];
                    if(a.Business_Plans__r.size() > 0){
                        wrap.bPlan = a.Business_Plans__r[0];
                    }
                    else wrap.bPlan = new Business_Plan__c();
                    if(a.CTG_Strategies__r.size() > 0) wrap.listCtgStrategy = a.CTG_Strategies__r;
                    else wrap.listCtgStrategy = new List<CTG_Strategy__c>();
                    if(a.Customer_Strategies__r.size() > 0) wrap.listCustomerStrategy = a.Customer_Strategies__r;
                    else wrap.listCustomerStrategy = new List<Customer_Strategy__c>();
                    wrapper.add(wrap);
                }system.debug('wrapperIs'+wrapper);
                for(Business_Plan__c b : bpListShow){
                    if(b.Planned_All_Boards__c != null)bp.Planned_All_Boards__c += b.Planned_All_Boards__c;
                    if(b.Planned_VAP__c != null)bp.Planned_VAP__c += b.Planned_VAP__c;
                    if(b.Planned_Tape__c != null)bp.Planned_Tape__c += b.Planned_Tape__c;
                    if(b.Planned_Finishing__c != null)bp.Planned_Finishing__c += b.Planned_Finishing__c;
                }system.debug('Business_Plan__cValues'+bp.Planned_All_Boards__c);
            }
            system.debug('WrapperListIs'+wrapper);
        }
        
        catch(exception ex){
            
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
    
    //--------------method to set Header value of all the records when page loads----------------------------
    private Decimal setPlannedValue(Decimal x, Decimal y) {
        if(x == null) x = y;
        else x += y;
        return x;
    }
    
    //Wrapper Class 
    public class Wrapper{
        public Account acc {get;set;}
        public Business_Plan__c bPlan {get;set;}
        public List<CTG_Strategy__c> listCtgStrategy {get;set;}
        public List<Customer_Strategy__c> listCustomerStrategy {get;set;}
        public String location {get;set;}
        
        public Wrapper() {
            acc = new Account();
            bPlan = new Business_Plan__c();
        }
    }
*/
}