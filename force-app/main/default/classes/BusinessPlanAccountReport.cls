/**************************************************************************************************
* Controller Class: BusinessPlanAccountReport
* Created by Yogesh Kumar(Navivo), DateCreated: 11/27/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - The page is used to list the Business Plan and account strategies.
---------------------------------------------------------------------------------------------------
* Unit Test: 
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME              DATE            DETAIL FEATURES
    1.0      Yogesh Kumar(Navivo)          11/27/2014      INITIAL DEVELOPMENT
    2.0     Mohan Kumar(Huron)        01/17/2015    RSM user will see all the TM users in a picklist and show BP
                                number according the TM User selected.
                                Send email of the print preview for the selected contact
    3.0     Arpit Vashishtha        04/30/2015    Added a logic to add chk box to show reports of hierarchy on businessPlanAccountReport on account detail page.
                                So that When CheckBox is checked user can see The cumulative report of all the Accounts unser that User including himself. 
**************************************************************************************************/
public with sharing class BusinessPlanAccountReport {
  public Business_Plan__c bPlan {get;set;}
  public List<CTG_Strategy__c> listCtgStrategy {get;set;}
  public List<Customer_Strategy__c> listCustomerStrategy {get;set;}
  public Integer year{get;set;}
  public String accountName {get;set;}
  public String location {get;set;}
  public String userId {get;set;}
  public String userSelected {get;set;}
  public List<Selectoption> userOptions {get;set;}
  public String contSelected {get;set;}
  public List<Selectoption> contOptions {get;set;}
  public Boolean isRSM {get;set;}
  public Boolean isTM{get;set;}
  public Boolean viewHierarchyChk {get;set;}
  public String comment {get;set;}
  private String accountRecId;
  private String userIdParam;
  private String userYearParam;
  private String userSelectedParam;
  private String urlHierarchy;
  private Boolean sendEmailProcess = false;
  private Set<Id> hierarchyAccIds = new Set<Id>();
  
  public BusinessPlanAccountReport(apexpages.standardcontroller sc) {
    userId = sc.getId();
    System.debug('StandardControllerEntryPoint:::::'+userId);
    init();
  }
  
  public BusinessPlanAccountReport() {
    userId = apexPages.currentPage().getParameters().get('id');
    System.debug('BusinessPlanAccountReport: '+userId);
    init();
  }
  
  public String getAccountRecId() {
        return accountRecId;
    }
    
    public void setAccountRecId(String aId) {
    accountRecId = aId;
    userId = accountRecId;
    System.debug('accountRecId: '+userId);
    sendEmailProcess = true;
    init();
  }
  
  private void init() {
    userIdParam = apexpages.currentpage().getparameters().get('uId');
    userYearParam = apexpages.currentpage().getparameters().get('year');
    userSelectedParam = apexpages.currentpage().getparameters().get('uSel');
    urlHierarchy = apexPages.currentPage().getParameters().get('hierarchy');
    isTM = false;
    isRSM = false;
    viewHierarchyChk = false;
    bPlan = new Business_Plan__c();
    userOptions = new List<Selectoption>();
    contOptions = new List<Selectoption>();
    
    System.debug('chk::::'+userId);
    listCtgStrategy = new List<CTG_Strategy__c>();
    listCustomerStrategy = new List<Customer_Strategy__c>();
    
    year = System.today().month()<11 ? System.today().year() : System.today().year() + 1;
   
    
    if(urlHierarchy != null && urlHierarchy != '' && urlHierarchy == 'yes') {
      userId = userIdParam;
      viewHierarchyChk = true;
    } 
    
    String userRoleId = userinfo.getUserRoleId();
    userSelected = userinfo.getUserId();
    if(sendEmailProcess || Test.isRunningTest()) {
      if(BusinessPlanUtil.hierarchyVariable) viewHierarchyChk = BusinessPlanUtil.hierarchyVariable;
      if(BusinessPlanUtil.year!=null) year = BusinessPlanUtil.year;
      userSelected = BusinessPlanUtil.userSelectedOnSendEmail;
      comment = BusinessPlanUtil.mailComment;
    }
    if(userRoleId != null) {
      UserRole uRole = [Select Id, Name From UserRole Where Id =: userRoleId];
      if(uRole.Name.contains('RSM')) {
        isRSM = true;
      }
    }
    if(isRSM) {
      //List<Business_Plan_Others__c> bpoList = [Select Name From Business_Plan_Others__c b where Year__c =: String.valueOf(year)];
      List<Business_Plan__c> bpList = [Select User_Id__c From Business_Plan__c b where Year__c =: String.valueOf(year) and User_Id__c != null];
      Set<String> userIds = new Set<String>();
      for(Business_Plan__c bp : bpList) {
        userIds.add(bp.User_Id__c);
      }
      userIds.add(userSelected);
      
      List<User> userList = [Select Id, Name From User Where Id IN :userIds order by Name];
      for(User u : userList) {
        userOptions.add(new Selectoption(u.Id, u.Name));
      }
    }
    //Shakti 10/27/2015 : Added a logic to show View Hierarchy Business Plan checkbox on page if user is USA user.
    if(!isRSM){
        User u = [select id, Name, ManagerId, User_Territory_Code__c, Profile.Name, userRole.Name from user where id = :UserInfo.getUserId()];
        isTM = false;
        if(u.Profile.Name.contains('USA TM User')){ isTM = true;      }
    }
    //prepare contact list to send email
    if(userId != null && userId != '') {
      List<Contact> cList = [Select Id, Name, Email From Contact Where AccountId =: userId and Email != null];
      contOptions.add(new Selectoption('', '--Select Contact--'));
      for(Contact c : cList) {
        contOptions.add(new Selectoption(c.Id, c.Name + '(' + c.Email + ')'));
      }
    }
    
    if(viewHierarchyChk) viewHierarchy();
    else fetchBPDetails();
  }
  
  public void fetchBPDetails() {
    try{
      viewHierarchyChk = false;
      if(userIdParam != null && userIdParam != '' && userYearParam != null && userYearParam != ''){
        userId = userIdParam;
        system.debug('UIdIs'+userId);
        year = Integer.valueOf(userYearParam);
        userSelected = userSelectedParam;
        List<Account> accList = [Select id, Name, BillingState, BillingCity, (Select b.Previous_Year_Actual_Finishing__c,b.Previous_Year_Actual_All_Boards__c,b.Previous_Year_Actual_Tape__c,b.Previous_Year_Actual_VAP__c,b.Budget_VAP_of_Boards__c, b.Actual_VAP_of_Boards__c,b.VAP_Actual_to_Budget__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.All_Board_Actual_to_Budget__c,b.Total_YTD_Finishing__c,b.Q4_Finishing__c, b.Q3_Finishing__c, b.Q2_Finishing__c,b.Q1_Finishing__c,b.Budget_Finishing__c,b.Total_YTD_Tape__c,b.Q4_Tape__c,b.Q3_Tape__c,b.Q2_Tape__c,b.Q1_Tape__c,b.Budget_Tape__c,b.Total_YTD_VAP__c,b.Q4_VAP__c, b.Q3_VAP__c, b.Q2_VAP__c,b.Q1_VAP__c,b.Budget_VAP__c,b.Total_YTD_All_Board__c,b.Q4_All_Boards__c,b.Q3_All_Boards__c,b.Q2_All_Boards__c,b.Q1_All_Boards__c,b.Planned_All_Boards__c,b.Account__c,b.Budget_All_Boards__c from Business_Plans__r b where Year__c =: String.valueOf(year) and User_Id__c =: userSelected),(Select c.Name, c.Id, c.CreatedById, c.Action_Item__c, Due_Date__c, c.Account__c From CTG_Strategies__r c order by Item__c),(Select Due_Date__c, CreatedById, Action_Item__c, Account__c From Customer_Strategies__r order by Item__c) From Account a where a.id =: userId];
        System.debug('accList::::'+accList);
        searchDetail(accList);
      } else {
        List<Account> accList = [Select id, Name, BillingState, BillingCity, (Select b.Previous_Year_Actual_Finishing__c,b.Previous_Year_Actual_All_Boards__c,b.Previous_Year_Actual_Tape__c,b.Previous_Year_Actual_VAP__c,b.Budget_VAP_of_Boards__c, b.Actual_VAP_of_Boards__c,b.VAP_Actual_to_Budget__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.All_Board_Actual_to_Budget__c,b.Total_YTD_Finishing__c,b.Q4_Finishing__c, b.Q3_Finishing__c, b.Q2_Finishing__c,b.Q1_Finishing__c,b.Budget_Finishing__c,b.Total_YTD_Tape__c,b.Q4_Tape__c,b.Q3_Tape__c,b.Q2_Tape__c,b.Q1_Tape__c,b.Budget_Tape__c,b.Total_YTD_VAP__c,b.Q4_VAP__c, b.Q3_VAP__c, b.Q2_VAP__c,b.Q1_VAP__c,b.Budget_VAP__c,b.Total_YTD_All_Board__c,b.Q4_All_Boards__c,b.Q3_All_Boards__c,b.Q2_All_Boards__c,b.Q1_All_Boards__c,b.Planned_All_Boards__c,b.Account__c,b.Budget_All_Boards__c from Business_Plans__r b where Year__c =: String.valueOf(year) and User_Id__c =: userSelected),(Select c.Name, c.Id, c.CreatedById, c.Action_Item__c, Due_Date__c, c.Account__c From CTG_Strategies__r c order by Item__c),(Select Due_Date__c, CreatedById, Action_Item__c, Account__c From Customer_Strategies__r order by Item__c) From Account a where a.id =: userId];
        System.debug('accList::::'+accList);
        searchDetail(accList);
      }
    }catch(Exception e){      ApexPages.addMessages(e);    }
  }
  
  public void sendEmail() {
    if(contSelected == null || contSelected == '') {
      ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Error, 'Please select Contact'));
      return;
    }
    List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
      List<EmailTemplate> eTemplate = [SELECT id from emailtemplate where developername ='Business_Plan_Account_Report']; 
    
      if(eTemplate.size() > 0){
        if(viewHierarchyChk) {          BusinessPlanUtil.hierarchyVariable = true;        }
        BusinessPlanUtil.year = year;
        if(comment != null || comment != '') BusinessPlanUtil.mailComment = comment;
        BusinessPlanUtil.userSelectedOnSendEmail = userSelected;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();  
          mail.setSaveAsActivity(false); 
        mail.setTargetObjectId(contSelected);
        mail.setTemplateId(eTemplate[0].Id); 
          mail.setWhatId(userId);
          mails.add(mail);  
     }
      if(!Test.isRunningTest())      Messaging.sendEmail(mails);
      BusinessPlanUtil.userSelectedOnSendEmail = null; 
      BusinessPlanUtil.mailComment = null;
      comment = '';
      contSelected = '';
      ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.Confirm, 'Email sent successfully'));
  }
  
  private void searchDetail(List<Account> accList){
    for(Account a : accList){
      accountName = a.Name;
      location = a.BillingCity + ', ' + a.BillingState;
      if(a.Business_Plans__r.size() > 0) bPlan = a.Business_Plans__r[0];
      else bPlan = new Business_Plan__c();
        
      listCtgStrategy = a.CTG_Strategies__r.size() > 0 ? a.CTG_Strategies__r : new List<CTG_Strategy__c>();
      //if(a.CTG_Strategies__r.size() > 0) listCtgStrategy = a.CTG_Strategies__r;	      else listCtgStrategy = new List<CTG_Strategy__c>();
      listCustomerStrategy = a.Customer_Strategies__r.size() > 0 ? a.Customer_Strategies__r : new List<Customer_Strategy__c>();
      //if(a.Customer_Strategies__r.size() > 0) listCustomerStrategy = a.Customer_Strategies__r;
      //else listCustomerStrategy = new List<Customer_Strategy__c>();
    }
  }
  
  //Arpit 2015-04-30: Adding logic to add chk box to show reports of hierarchy on businessPlanAccountReport on account detail page 
  public void viewHierarchy() {
    try {
      if(viewHierarchyChk) {
        Set<Id> setCurrentId = new Set<Id>{userId};
        hierarchyAccIds = new Set<Id>();
        hierarchyAccIds = setCurrentId;
        List<User> u = new List<User>();
        if(userSelected!=null && userSelected!=''){
            u = [select id, Name, ManagerId, User_Territory_Code__c, Profile.Name, userRole.Name from user where id = :userSelected];
        }
        if(u.size()>0 && u.get(0).Profile.Name.contains('USA RSM User')){
            NotShared ns = new NotShared();
            hierarchyAccIds = ns.getAccountID(setCurrentId);
        }else{
            Set<Id> newAccIds = queryOnAccounts(setCurrentId);
            while(newAccIds.size() > 0) {              newAccIds = queryOnAccounts(newAccIds);            }
        }
        
        /*
        List<Account> accList = [Select id, Name, BillingState, BillingCity, (Select b.Previous_Year_Actual_Finishing__c,b.Previous_Year_Actual_All_Boards__c,b.Previous_Year_Actual_Tape__c,b.Previous_Year_Actual_VAP__c,b.Budget_VAP_of_Boards__c, b.Actual_VAP_of_Boards__c,b.VAP_Actual_to_Budget__c, b.Planned_VAP__c, b.Planned_Tape__c, b.Planned_Finishing__c, b.Tape_Actual_to_Budget__c, b.Finishing_Actual_to_Budget__c, b.All_Board_Actual_to_Budget__c,b.Total_YTD_Finishing__c,b.Q4_Finishing__c, b.Q3_Finishing__c, b.Q2_Finishing__c,b.Q1_Finishing__c,b.Budget_Finishing__c,b.Total_YTD_Tape__c,b.Q4_Tape__c,b.Q3_Tape__c,b.Q2_Tape__c,b.Q1_Tape__c,b.Budget_Tape__c,b.Total_YTD_VAP__c,b.Q4_VAP__c, b.Q3_VAP__c, b.Q2_VAP__c,b.Q1_VAP__c,b.Budget_VAP__c,b.Total_YTD_All_Board__c,b.Q4_All_Boards__c,b.Q3_All_Boards__c,b.Q2_All_Boards__c,b.Q1_All_Boards__c,b.Planned_All_Boards__c,b.Account__c,b.Budget_All_Boards__c from Business_Plans__r b where Year__c =: String.valueOf(year)),(Select c.Name, c.Id, c.CreatedById, c.Action_Item__c, Due_Date__c, c.Account__c From CTG_Strategies__r c order by Item__c),(Select Due_Date__c, CreatedById, Action_Item__c, Account__c From Customer_Strategies__r order by Item__c) From Account a where a.id IN :hierarchyAccIds];*/
        //Shakti - 11/27/2015, add a business plan rollup for TM users - Should rollup only data for current user’s plan - regardless of how many other plans are on accounts or sub accounts.  Roll up within account hierarchy
        String queryAcc = 'Select id, Name, BillingState, BillingCity, (Select Previous_Year_Actual_Finishing__c,Previous_Year_Actual_All_Boards__c,Previous_Year_Actual_Tape__c,Previous_Year_Actual_VAP__c,Budget_VAP_of_Boards__c, Actual_VAP_of_Boards__c,VAP_Actual_to_Budget__c, Planned_VAP__c, Planned_Tape__c, Planned_Finishing__c, Tape_Actual_to_Budget__c, Finishing_Actual_to_Budget__c, All_Board_Actual_to_Budget__c,Total_YTD_Finishing__c,Q4_Finishing__c, Q3_Finishing__c, Q2_Finishing__c,Q1_Finishing__c,Budget_Finishing__c,Total_YTD_Tape__c,Q4_Tape__c,Q3_Tape__c,Q2_Tape__c,Q1_Tape__c,Budget_Tape__c,Total_YTD_VAP__c,Q4_VAP__c, Q3_VAP__c, Q2_VAP__c,Q1_VAP__c,Budget_VAP__c,Total_YTD_All_Board__c,Q4_All_Boards__c,Q3_All_Boards__c,Q2_All_Boards__c,Q1_All_Boards__c,Planned_All_Boards__c,Account__c,Budget_All_Boards__c from Business_Plans__r where Year__c =\''+String.valueOf(year)+'\'';
        if(isTM && !isRSM){            queryAcc += ' and User_Id__c =\''+userSelected+'\'';       }
          else if(u.size()>0 && u.get(0).Profile.Name.contains('USA TM User')){            queryAcc += ' and User_Id__c =\''+userSelected+'\'';        }
        queryAcc += '),(Select Name, Id, CreatedById, Action_Item__c, Due_Date__c, Account__c From CTG_Strategies__r order by Item__c),(Select Due_Date__c, CreatedById, Action_Item__c, Account__c From Customer_Strategies__r order by Item__c) From Account';
        List<Account> accList = new List<Account>();
        if(u.size()>0 && u.get(0).Profile.Name.contains('USA RSM User')){
            NotShared ns = new NotShared();
            accList = ns.getAccount(queryAcc,hierarchyAccIds);
        }else{
            queryAcc += ' where Id IN :hierarchyAccIds';
            accList = Database.query(queryAcc);
        }
        System.debug('hierarchyAccIds: '+hierarchyAccIds);
        if(accList.size() > 0) searchHierarchyDetail(accList);
      } else {
        fetchBPDetails();
      }
    } catch(Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
    }
  }
  
  public without sharing class NotShared
  {
    public List<Account> getAccount(String queryAcc,Set<ID> accIDs){
        queryAcc += ' where Id IN :accIDs';
        List<Account> accList = Database.query(queryAcc);
        return accList;
    }
    public Set<Id> hierarchyAccIds{get;set;}
    
    public Set<ID> getAccountID(Set<Id> setCurrentId){
        hierarchyAccIds = new Set<Id>();
        hierarchyAccIds = setCurrentId;
        Set<Id> newAccIds = queryOnAccounts(setCurrentId);
        while(newAccIds.size() > 0) {
          newAccIds = queryOnAccounts(newAccIds);
        }
        return hierarchyAccIds;
    }
    
    public Set<ID> queryOnAccounts(Set<Id> setId) {
        try {
          List<Account> listAcc = [Select Id from Account where ParentId IN :setId];
          System.debug('listAcc==================='+listAcc.size());
          Set<Id> newAccIds = new Set<Id>();
          for(Account ac : listAcc) {
            System.debug('ac==============::::'+ac.Id);
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
  }
  
  private Set<Id> queryOnAccounts(Set<Id> setId) {
    try {
      List<Account> listAcc = [Select Id from Account where ParentId IN :setId];
      System.debug('listAcc==================='+listAcc.size());
      Set<Id> newAccIds = new Set<Id>();
      for(Account ac : listAcc) {
        System.debug('ac==============::::'+ac.Id);
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
  
  // this will take out the list of accounts having Business Plan for the year.
  private void searchHierarchyDetail(List<Account> accList) {
    try {
      bPlan = new Business_Plan__c();
      bPlan.Planned_All_Boards__c = 0;
      bPlan.Q1_All_Boards__c = 0;
      bPlan.Q2_All_Boards__c = 0;
      bPlan.Q3_All_Boards__c = 0;
      bPlan.Q4_All_Boards__c = 0;
      bPlan.Planned_VAP__c = 0;
      bPlan.Q1_VAP__c = 0;
      bPlan.Q2_VAP__c = 0;
      bPlan.Q3_VAP__c = 0;
      bPlan.Q4_VAP__c = 0;
      bPlan.Planned_Tape__c = 0;
      bPlan.Q1_Tape__c = 0;
      bPlan.Q2_Tape__c = 0;
      bPlan.Q3_Tape__c = 0;
      bPlan.Q4_Tape__c = 0;
      bPlan.Planned_Finishing__c = 0;
      bPlan.Q1_Finishing__c = 0;
      bPlan.Q2_Finishing__c = 0;
      bPlan.Q3_Finishing__c = 0;
      bPlan.Q4_Finishing__c = 0;
      bPlan.Total_YTD_All_Board__c = 0;
      bPlan.Total_YTD_VAP__c = 0;
      bPlan.Total_YTD_Tape__c = 0;
      bPlan.Total_YTD_Finishing__c = 0;
      bPlan.All_Board_Actual_to_Budget__c = 0;
      bPlan.VAP_Actual_to_Budget__c = 0;
      bPlan.Tape_Actual_to_Budget__c = 0;
      bPlan.Finishing_Actual_to_Budget__c = 0;
      bPlan.Actual_VAP_of_Boards__c = 0;
      bPlan.Budget_VAP_of_Boards__c = 0;
      
      for(Account a : accList) { 
        System.debug('a.Business_Plans__r.size()========= '+a.Business_Plans__r.size());
        if(a.Business_Plans__r.size() > 0) {
          bPlan = calculateHierarchy(a.Business_Plans__r);
        }
        if(a.Id == userId) {
          if(a.CTG_Strategies__r.size() > 0) listCtgStrategy = a.CTG_Strategies__r;
          else listCtgStrategy = new List<CTG_Strategy__c>();
          if(a.Customer_Strategies__r.size() > 0) listCustomerStrategy = a.Customer_Strategies__r;
          else listCustomerStrategy = new List<Customer_Strategy__c>();
        } 
      }
    } catch(Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
    }
  }
  
  // it will calculate all the business Plan with respect to per account.
  private Business_Plan__c calculateHierarchy(List<Business_Plan__c> listBPlan) {
    try {System.debug('listBPlan:::==='+listBPlan);
      for(Business_Plan__c b : listBPlan) {
        if(b.Planned_All_Boards__c != null) bPlan.Planned_All_Boards__c += b.Planned_All_Boards__c;
        if(b.Q1_All_Boards__c != null) bPlan.Q1_All_Boards__c += b.Q1_All_Boards__c;
        if(b.Q2_All_Boards__c != null) bPlan.Q2_All_Boards__c += b.Q2_All_Boards__c;
        if(b.Q3_All_Boards__c != null) bPlan.Q3_All_Boards__c += b.Q3_All_Boards__c;
        if(b.Q4_All_Boards__c != null) bPlan.Q4_All_Boards__c += b.Q4_All_Boards__c;
        if(b.Total_YTD_All_Board__c != null) bPlan.Total_YTD_All_Board__c += b.Total_YTD_All_Board__c;
        if(b.All_Board_Actual_to_Budget__c != null) bPlan.All_Board_Actual_to_Budget__c += b.All_Board_Actual_to_Budget__c;
        if(b.Planned_VAP__c != null) bPlan.Planned_VAP__c += b.Planned_VAP__c;
        if(b.Q1_VAP__c != null) bPlan.Q1_VAP__c += b.Q1_VAP__c;
        if(b.Q2_VAP__c != null) bPlan.Q2_VAP__c += b.Q2_VAP__c;
        if(b.Q3_VAP__c != null) bPlan.Q3_VAP__c += b.Q3_VAP__c;
        if(b.Q4_VAP__c != null) bPlan.Q4_VAP__c += b.Q4_VAP__c;
        if(b.Total_YTD_VAP__c != null) bPlan.Total_YTD_VAP__c += b.Total_YTD_VAP__c;
        if(b.VAP_Actual_to_Budget__c != null) bPlan.VAP_Actual_to_Budget__c += b.VAP_Actual_to_Budget__c;
        if(b.Actual_VAP_of_Boards__c != null) bPlan.Actual_VAP_of_Boards__c += b.Actual_VAP_of_Boards__c; 
        if(b.Budget_VAP_of_Boards__c != null) bPlan.Budget_VAP_of_Boards__c += b.Budget_VAP_of_Boards__c;
        if(b.Planned_Tape__c != null) bPlan.Planned_Tape__c += b.Planned_Tape__c;
        if(b.Q1_Tape__c != null) bPlan.Q1_Tape__c += b.Q1_Tape__c;
        if(b.Q2_Tape__c != null) bPlan.Q2_Tape__c += b.Q2_Tape__c;
        if(b.Q3_Tape__c != null) bPlan.Q3_Tape__c += b.Q3_Tape__c;
        if(b.Q4_Tape__c != null) bPlan.Q4_Tape__c += b.Q4_Tape__c;
        if(b.Total_YTD_Tape__c != null) bPlan.Total_YTD_Tape__c += b.Total_YTD_Tape__c;
        if(b.Tape_Actual_to_Budget__c != null) bPlan.Tape_Actual_to_Budget__c += b.Tape_Actual_to_Budget__c;
        if(b.Planned_Finishing__c != null) bPlan.Planned_Finishing__c += b.Planned_Finishing__c;
        if(b.Q1_Finishing__c != null) bPlan.Q1_Finishing__c += b.Q1_Finishing__c;
        if(b.Q2_Finishing__c != null) bPlan.Q2_Finishing__c += b.Q2_Finishing__c;
        if(b.Q3_Finishing__c != null) bPlan.Q3_Finishing__c += b.Q3_Finishing__c;
        if(b.Q4_Finishing__c != null) bPlan.Q4_Finishing__c += b.Q4_Finishing__c;
        if(b.Total_YTD_Finishing__c != null) bPlan.Total_YTD_Finishing__c += b.Total_YTD_Finishing__c;
        if(b.Finishing_Actual_to_Budget__c != null) bPlan.Finishing_Actual_to_Budget__c += b.Finishing_Actual_to_Budget__c;
      }
      System.debug('bPlan====================='+bPlan);
      return bPlan;
    } catch(Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getMessage()));
      ApexPages.addMessage(new ApexPages.Message(ApexPages.SEVERITY.ERROR, e.getStackTraceString()));
      return null;
    }
  } 
  //--------------------------End of Arpit 2015-04-30------------------------------------------------
}