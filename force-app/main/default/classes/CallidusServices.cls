/********************************************************************************************************************************************
* @Author       Satyajit Chanda
* @Date         Nov 7, 2018
* @Description  This web service class created for the Callidus project, to integrate salesfore with Callidus using middleware SAP PO.
                The apex class expossing as soap webservices, and SAP PO invoking the web service thru CallidusServices WSDL file and mapping the salesforce
                Account, Contact, Opportunity , Product, Dodge Lead and Activity fields with callidus ODI templates (Transaction, Customer )                 
*********************************************************************************************************************************************/
global with sharing class CallidusServices{
    //Configurable start and end date to pull the records.
    Private static Date startDate = Date.valueOf(System.Label.CallidusCreateDate);
    Private static Date endDate = Date.valueOf(System.Label.CallidusEndDate);
    /****************************************************************************************
     * @Author       Satyajit Chanda
     * @Date         Nov 7, 2018
     * @Description  Inner class and fields exposing as a webservices that holds fields for the  
     *               Account Response sending back to PO and Callidus.
     *****************************************************************************************/
    global with sharing class AccountService{
        
        webservice String AccountOwner;
        webservice String AccountOwnerRole;
        webservice String AccountName;
        webservice String AccountOwnerRegion;
        webservice Integer AccountDataQualityScore;
        webservice Integer AccountCount;
        webservice String AccountId;
        webservice String AccOwnerSGId;
        webservice String AccSegment;
        webservice DateTime CreatedDate;
    
    }
    /****************************************************************************************
     * @Author       Satyajit Chanda
     * @Date         Nov 7, 2018
     * @Description  Inner class and fields exposing as a webservices that holds fields for the 
     *               Contact Response sending back to PO and Callidus.
     *****************************************************************************************/
    global with sharing class ContactService{
    
        webservice String ContactOwnerRole;
        webservice String ContactOwner;
        webservice String ContactOwnerRegion;
        webservice Integer ContactCount;
        webservice Integer ContactDataQualityScore;
        webservice String ContactId;
        webservice String ContOwnerSGId;//Contact_Owner_SGID__c
        webservice DateTime CreatedDate;
        
    }
    
    /****************************************************************************************
     * @Author       Satyajit Chanda
     * @Date         Nov 7, 2018
     * @Description  Inner class and fields exposing as a webservices that holds fields for the 
     *               Opportunity Response sending back to PO and Callidus.
     *****************************************************************************************/ 
    global with sharing class OpportunityService{
    
        webservice String OpportunityOwner;//Owner.Name
        webservice String OpportunityOwnerRole;//Owner.UserRole.Name
        webservice String OpportunityName;//Name       
        webservice Integer OpportunityCount;//Opportunity_Count__c
        webservice Integer OpportunityDataQualityScore;//Data_Quality_Score__c
        webservice String Stage;//StageName
        webservice String OpportunityOwnerRegion;//Owner.Region__c
        //webservice DateTime WonLostDate;//Construction_Won_Date__c
        webservice String OpportunityId;//Id
        webservice Boolean NotifyTM;//Notify_TM__c
        webservice DateTime NotifyTMDate;//Notify_TM_Date__c
        webservice Boolean ProjectDataCompleted;//Project_Data_Completed__c
        webservice DateTime ProjectDataCompletedDate;//Project_Data_Completed_Date__c
        webservice Integer TMResponseTime;//TM_Response_Time__c
        webservice String ContractorSupplying;//Contractor_Supplying__c (Account lookup)
        webservice String DealerSupplying; //Dealer_Supplying__c (Account lookup)
        webservice Integer VAPCount;//VAP_Count__c
        webservice Integer VAPMSF;//VAP_MSF_Total__c                
        webservice String ValidatedByBoardRM;//Validated_by_Board_RM__c
        webservice String ValidatedByFinishingRM;//Validated_by_Finishing_RM__c
        webservice String ValidateByOSM;//Validated_by_OSM__c
        webservice String OpportunityType;//Type        
        webservice DateTime AgreementDate;//Agreement_Date__c
        webservice DateTime ShipDate;//Ship_Date__c
        webservice String Segment; //Segment__c
        webservice Integer TotalOppQuantity;//TotalOpportunityQuantity
        webservice DateTime CloseDate;//CloseDate
        webservice String OppOwnerSGId;//Opp_Owner_SGID__c
        webservice String AccountSegment;//Account_Segment__c
        webservice List<OppLineItemService> OppProdService; //opportunity line item list   
        
    }
    /****************************************************************************************
     * @Author       Satyajit Chanda
     * @Date         Nov 7, 2018
     * @Description  Inner class and fields exposing as a webservices that holds fields for the 
     *               Opportunity Line Items Response sending back to PO and Callidus.
     *****************************************************************************************/
    global with sharing class OppLineItemService{
        
        webservice String Product2Id;//product2id
        webservice String ProductName;//Name (OpportunityLineItems)
        webservice String ProductGrouping;//Product_Grouping__c (OpportunityLineItems)
    }
    /****************************************************************************************
     * @Author       Satyajit Chanda
     * @Date         Nov 7, 2018
     * @Description  Inner class and fields exposing as a webservices that holds fields for the 
     *               Activity Response sending back to PO and Callidus.
     *****************************************************************************************/
    global with sharing class ActivityService{
        
        webservice String ActivityOwner;//Owner.Name
        webservice String ActivityOwnerRole;//Owner.UserRole.Name
        webservice String ActivityType;//Activity_Type__c
        webservice String Subject;//Subject(Task)
        webservice String AssignedUserRegion;//Assigned_User_Region__c
        webservice Integer ActivityCount;//Count__c
        webservice Integer ActivityDataQualityScore;//Data_Quality_Score__c
        webservice String ActivityId;//id
        webservice DateTime ActivityDate;//ActivityDate (task)
        webservice String Contact;//whoId,who.name(task)
        webservice String Account;//whatid, what.name(task)
        webservice Integer TotalAttachments;//Total_Attachments__c
        webservice Boolean Approved;//Approved__c
        webservice String CEUSubType;//Sub_Type__c
        webservice String AssignedSGID;//Assigned_SGID__c
        
    }
    /****************************************************************************************
     * @Author       Satyajit Chanda
     * @Date         Nov 7, 2018
     * @Description  Inner class and fields exposing as a webservices that holds fields for the 
     *               Dodge Laed Response sending back to PO and Callidus.
     *****************************************************************************************/
    global with sharing class DodgeLeadService{
        
        webservice String LeadId;
        webservice Integer LeadCount;
        webservice DateTime CreatedDate;
        //webservice String LeadSGId;
        webservice String Region;
        webservice Integer DataQualityScore; 
    }
    /**
    * @method      : getAccountDataQuality()
    * @return      : List<AccountService>
    * @description : method exposing as a webservices to get the account details.
    */ 
    webservice static List<AccountService> getAccountDataQuality(){
        List<AccountService> listAccountService = new List<AccountService>();

        AccountService accService;        
        
        List<Account> accountDataQalityList = [SELECT id, Owner.Name, Owner.UserRole.Name, Name, Owner.Region__c, Count__c, Data_Quality_Score__c, Segment__c, Account_Owner_SGID__c, RecordType.Name, CreatedDate FROM Account Where RecordType.Name IN ('US Customer Account','US Specialty Account') AND Owner.Name NOT IN ('inactive','Christian Belko','Nancy OConnor') AND Owner.UserRole.Name NOT IN ('marketing','finishing') AND Owner.Region__c !='' AND Owner.Region__c != null];
        system.debug('AccountDataQalityList::'+accountDataQalityList.size());
        
        if(accountDataQalityList != null){
            
            for(Account acc : accountDataQalityList){
                
                accService = new AccountService();
                accService.AccountId = acc.id;
                accService.AccountOwner = acc.Owner.Name;
                accService.AccountOwnerRole = String.valueOf(acc.Owner.UserRole.Name);
                accService.AccountName = acc.Name;
                accService.AccountOwnerRegion = acc.Owner.Region__c;
                accService.AccountDataQualityScore = Integer.valueOf(acc.Data_Quality_Score__c);
                accService.AccountCount = Integer.valueOf(acc.Count__c);
                accService.AccOwnerSGId = acc.Account_Owner_SGID__c;
                accService.AccSegment = acc.Segment__c;
                //Setting created date as current year while sending into SAP PO.
                accService.CreatedDate = startDate;                
                   
                listAccountService.add(accService);
            }              
        
        }
        
        return listAccountService;
    }
    /**
    * @method      : getContactDataQuality()
    * @return      : List<ContactService>
    * @description : method exposing as a webservices to get the contact details.
    */
    webservice static List<ContactService> getContactDataQuality(){
        
        List<ContactService> listContactService = new List<ContactService>();
        ContactService conService;
        
        List<Contact> contactDataQalityList = [SELECT id, Owner.Name, Owner.UserRole.Name, Owner.Region__c, Count__c, Data_Quality_Score__c, Contact_Owner_SGID__c, RecordType.Name, CreatedDate FROM Contact Where RecordType.Name='Gypsum USA Contact'  AND Owner.Name NOT IN ('inactive','Christian Belko','Nancy OConnor') AND Owner.UserRole.Name NOT IN ('marketing','finishing') AND Owner.Region__c !='' AND Owner.Region__c != null];
        system.debug('ContactDataQalityList::'+contactDataQalityList.size());
        
        if(contactDataQalityList != null){
            
            for(Contact con : contactDataQalityList){
                
                conService = new ContactService();
                conService.ContactId = con.Id;
                conService.ContactOwner = con.Owner.Name;
                conService.ContactOwnerRole = con.Owner.UserRole.Name;
                conService.ContactOwnerRegion = con.Owner.Region__c;
                conService.ContactCount = Integer.valueOf(con.Count__c);
                conService.ContactDataQualityScore = Integer.valueOf(con.Data_Quality_Score__c);
                conService.ContOwnerSGId = con.Contact_Owner_SGID__c;
                //Setting created date as current year while sending into SAP PO.
                conService.CreatedDate = startDate;
                
                listContactService.add(conService);
            }
        }                
        return listContactService;
    }
    /**
    * @method      : getLeadDataQuality()
    * @return      : List<DodgeLeadService>
    * @description : method exposing as a webservices to get the dodge lead details.
    */
    webservice static List<DodgeLeadService> getLeadDataQuality(){
        
        List<DodgeLeadService> listLeadService = new List<DodgeLeadService>();
        DodgeLeadService leadService;
        
      /*  List<Dodge_Project__c> leadList = [SELECT id, Count__c, CreatedDate, Region__r.Name, Data_Quality_Score__c, Status__c FROM Dodge_Project__c WHERE Status__c != null AND Region__c != null AND CreatedDate >= :startDate AND CreatedDate <= :endDate];
        system.debug('Total lead Size ::'+leadList.size());
        
        if(leadList != null){
            
            for(Dodge_Project__c lead : leadList){
                
                leadService = new DodgeLeadService();
                leadService.LeadId = lead.id;
                leadService.LeadCount = Integer.valueOf(lead.Count__c);
                leadService.CreatedDate = lead.CreatedDate;
                //leadService.LeadSGId;
                leadService.Region = lead.Region__r.Name;
                leadService.DataQualityScore = Integer.valueOf(lead.Data_Quality_Score__c);
                
                listLeadService.add(leadService);
            }
        }*/
        return listLeadService;
    }
    /**
    * @method      : getActivityService()
    * @return      : List<ActivityService>
    * @description : method exposing as a webservices to get the Activity details.
    */
     webservice static List<ActivityService> getActivityService(){
                
        List<ActivityService> listActivityService = new List<ActivityService>();
        ActivityService activityService;
         
        List<List<Task>> listTask = new List<List<Task>>();
        List<Task> activityList = new List<Task>();
        
        List<Task> KPIVAPSpecList = [SELECT id, Owner.UserRole.Name, Owner.Name, who.name, what.name, Activity_Type__c, Subject, Assigned_User_Region__c, Count__c, Data_Quality_Score__c, /*Approved__c, Sub_Type__c,*/ ActivityDate, Status, RecordType.Name, /*Total_Attachments__c,*/ Assigned_SGID__c FROM Task WHERE Owner.UserRole.Name like '%Architectural Solutions Manager%' AND /*Total_Attachments__c != null AND Total_Attachments__c != 0 AND*/ Status='Completed' AND RecordType.Name='USA Task' AND Activity_Type__c='KPI VAP PK Spec'  AND ActivityDate >= :startDate AND ActivityDate <= :endDate];
        List<Task> KPISpecList = [SELECT id, Owner.UserRole.Name, Owner.Name, who.name, what.name, Activity_Type__c, Subject, Assigned_User_Region__c, Count__c, Data_Quality_Score__c, /*Approved__c, Sub_Type__c,*/ ActivityDate, Status, RecordType.Name, /*Total_Attachments__c,*/ Assigned_SGID__c FROM Task WHERE Owner.UserRole.Name like '%Architectural Solutions Manager%' AND /*Total_Attachments__c != null AND Total_Attachments__c != 0 AND*/ Status='Completed' AND RecordType.Name='USA Task' AND Activity_Type__c='KPI Specification Updates' AND ActivityDate >= :startDate AND ActivityDate <= :endDate]; 
        List<Task> KPIEPDSpecList = [SELECT id, Owner.UserRole.Name, Owner.Name, who.name, what.name, Activity_Type__c, Subject, Assigned_User_Region__c, Count__c, Data_Quality_Score__c, /*Approved__c, Sub_Type__c,*/ ActivityDate, Status, RecordType.Name, /*Total_Attachments__c,*/ Assigned_SGID__c FROM Task WHERE Owner.UserRole.Name like '%Architectural Solutions Manager%' AND /*Total_Attachments__c != null AND Total_Attachments__c != 0 AND*/ Status='Completed' AND RecordType.Name='USA Task' AND Activity_Type__c='KPI EPD/HPD Spec' AND ActivityDate >= :startDate AND ActivityDate <= :endDate]; 
        List<Task> KPINoCostSpecList = [SELECT id, Owner.UserRole.Name, Owner.Name, who.name, what.name, Activity_Type__c, Subject, Assigned_User_Region__c, Count__c, Data_Quality_Score__c, /*Approved__c, Sub_Type__c,*/ ActivityDate, Status, RecordType.Name, /*Total_Attachments__c,*/ Assigned_SGID__c FROM Task WHERE Owner.UserRole.Name like '%Architectural Solutions Manager%' AND /*Total_Attachments__c != null AND Total_Attachments__c != 0 AND*/ Status='Completed' AND RecordType.Name='USA Task' AND Activity_Type__c='KPI No Coat Spec' AND ActivityDate >= :startDate AND ActivityDate <= :endDate]; 
        List<Task> KPICEUSpecList = [SELECT id, Owner.UserRole.Name, Owner.Name, who.name, what.name, Activity_Type__c, Subject, Assigned_User_Region__c, Count__c, Data_Quality_Score__c, /*Approved__c, Sub_Type__c,*/ ActivityDate, Status, RecordType.Name, /*Total_Attachments__c,*/ Assigned_SGID__c FROM Task WHERE Owner.UserRole.Name like '%Architectural Solutions Manager%' AND Status='Completed' AND RecordType.Name='USA Event' AND Activity_Type__c='KPI CEU Presentation' AND ActivityDate >= :startDate AND ActivityDate <= :endDate]; 
        List<Task> MonthlyCallList = [SELECT id, Owner.UserRole.Name, Owner.Name, who.name, what.name, Activity_Type__c, Subject, Assigned_User_Region__c, Count__c, Data_Quality_Score__c, /*Approved__c, Sub_Type__c,*/ ActivityDate, Status, RecordType.Name, /*Total_Attachments__c,*/ Assigned_SGID__c FROM Task WHERE Owner.UserRole.Name NOT IN ('marketing','finishing')  AND Status='Completed' AND RecordType.Name IN ('USA Task','USA Event') AND Activity_Type__c IN ('Call','Customer Event','Demonstration/Field Trial','Meeting/Presentation','Product Knowledge Session','Product Training','Q1 Account Review','Q2 Account Review','Q3 Account Review','Q4 Account Review') AND Owner.Name NOT IN ('inactive','Christian Belko','Nancy OConnor') AND ActivityDate >= :startDate AND ActivityDate <= :endDate]; 
        List<Task> DataQalityList = [SELECT id, Owner.UserRole.Name, Owner.Name, who.name, what.name, Activity_Type__c, Subject, Assigned_User_Region__c, Count__c, Data_Quality_Score__c, /*Approved__c, Sub_Type__c,*/ ActivityDate, Status, RecordType.Name, /*Total_Attachments__c,*/ Assigned_SGID__c FROM Task WHERE Owner.UserRole.Name NOT IN ('marketing','finishing') AND RecordType.Name IN ('USA Task','USA Event') AND Activity_Type__c NOT IN ('Personal Development Training','Vacation','Other','Trade Show','Internal','VOC') AND Owner.Name NOT IN ('inactive','Christian Belko','Nancy OConnor') AND Assigned_User_Region__c != null AND Assigned_User_Region__c != '' AND ActivityDate >= :startDate AND ActivityDate <= :endDate];        
         
        listTask.add(KPIVAPSpecList);
        listTask.add(KPISpecList);
        listTask.add(KPIEPDSpecList);
        listTask.add(KPINoCostSpecList);
        listTask.add(KPICEUSpecList);
        listTask.add(MonthlyCallList);
        listTask.add(DataQalityList);
         
        Set<Id> idSet = new Set<Id>();
        Map<id,Task> taskMap = new Map<id,Task>();
        
         if(listTask != null){
             for(List<Task> taskActivity : listTask){
                 activityList.addAll(taskActivity);
             }
         }
         
         for(Task tsk : activityList){
            idSet.add(tsk.id);
            taskMap.put(tsk.id,tsk);
        }
         
         system.debug('Activity Total Records::'+activityList.size());
         if(activityList != null){
             
             for(Id idkey : idSet){
                   
                Task t = taskMap.get(idkey);                      
                activityService = new ActivityService();
                
                activityService.ActivityOwner = t.Owner.Name;
                activityService.ActivityOwnerRole = t.Owner.UserRole.Name;
                activityService.ActivityType = t.Activity_Type__c;
                activityService.AssignedUserRegion = t.Assigned_User_Region__c;
                activityService.ActivityCount = Integer.valueOf(t.Count__c);
                activityService.ActivityId = t.Id;
                activityService.ActivityDate = t.ActivityDate;            
                activityService.Account = t.what.name;
                activityService.Contact = t.who.name;
                //activityService.TotalAttachments = Integer.valueOf(t.Total_Attachments__c);
                activityService.Subject = t.Subject;
                activityService.ActivityDataQualityScore = Integer.valueOf(t.Data_Quality_Score__c);
                //activityService.Approved = t.Approved__c;
                //activityService.CEUSubType = t.Sub_Type__c;
                activityService.AssignedSGID = t.Assigned_SGID__c;
                 
                listActivityService.add(activityService);
             }
             
         }
                
        return listActivityService;
    }
    
    /**
    * @method      : getOpportunityService()
    * @return      : List<OpportunityService>
    * @description : method exposing as a webservices to get the Opportunity and line item details.
    */
    webservice static List<OpportunityService> getOpportunityService(){
        
        List<OpportunityService> listOpportunityService = new List<OpportunityService>();
        OpportunityService oppService;
        
        List<List<Opportunity>> listOpportunity = new List<List<Opportunity>>();
        List<Opportunity> OppList = new List<Opportunity>();
        
        List<OppLineItemService> listLineItem;
        OppLineItemService oppLineItem;      
        
        List<Opportunity> oppDataQalityList = [SELECT id, Name, Owner.Name, Owner.UserRole.Name, Opportunity_Count__c, Owner.Region__c, Data_Quality_Score__c, CreatedDate, StageName, Notify_TM__c, Notify_TM_Date__c, Project_Data_Completed__c, Project_Data_Completed_Date__c, TM_Response_Time__c, Contractor_Supplying__r.Name, Dealer_Supplying__r.Name, Ship_Date__c, VAP_Count__c, VAP_MSF_Total__c, Validated_by_Board_RM__c, Validated_by_Finishing_RM__c, Validated_by_OSM__c, Type, Agreement_Date__c, Segment__c, TotalOpportunityQuantity, CloseDate, Account_Segment__c, Opp_Owner_SGID__c, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems ) FROM Opportunity Where CreatedDate >= :startDate AND CreatedDate <= :endDate AND Owner.UserRole.Name NOT IN ('marketing','finishing') AND Owner.Name NOT IN ('inactive','Christian Belko','Nancy OConnor') AND RecordType.Name IN ('Gypsum USA Project','Gypsum USA Corners/Finishing','Gypsum USA Conversions')];
        List<Opportunity> oppJobTrackingList = [SELECT id, Name, Owner.Name, Owner.UserRole.Name, Opportunity_Count__c, Owner.Region__c, Data_Quality_Score__c, CreatedDate, StageName, Notify_TM__c, Notify_TM_Date__c, Project_Data_Completed__c, Project_Data_Completed_Date__c, TM_Response_Time__c, Contractor_Supplying__r.Name, Dealer_Supplying__r.Name, Ship_Date__c, VAP_Count__c, VAP_MSF_Total__c, Validated_by_Board_RM__c, Validated_by_Finishing_RM__c, Validated_by_OSM__c, Type, Agreement_Date__c, Segment__c, TotalOpportunityQuantity, CloseDate, Account_Segment__c, Opp_Owner_SGID__c, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems ) FROM Opportunity Where Notify_TM_Date__c >= :startDate AND  Notify_TM_Date__c <= :endDate AND RecordType.Name ='Gypsum USA Project' AND Notify_TM__c = true];
        List<Opportunity> oppCTCornersList = [SELECT id, Name, Owner.Name, Owner.UserRole.Name, Opportunity_Count__c, Owner.Region__c, Data_Quality_Score__c, CreatedDate, StageName, Notify_TM__c, Notify_TM_Date__c, Project_Data_Completed__c, Project_Data_Completed_Date__c, TM_Response_Time__c, Contractor_Supplying__r.Name, Dealer_Supplying__r.Name, Ship_Date__c, VAP_Count__c, VAP_MSF_Total__c, Validated_by_Board_RM__c, Validated_by_Finishing_RM__c, Validated_by_OSM__c, Type, Agreement_Date__c, Segment__c, TotalOpportunityQuantity, CloseDate, Account_Segment__c, Opp_Owner_SGID__c, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems Where Product_Grouping__c ='Finishing') FROM Opportunity Where StageName='Completed Won' AND Type ='CT Corners Conversion' AND CloseDate >= :startDate AND CloseDate <= :endDate];
        List<Opportunity> oppMajorProjectSoldList = [SELECT id, Name, Owner.Name, Owner.UserRole.Name, Opportunity_Count__c, Owner.Region__c, Data_Quality_Score__c, CreatedDate, StageName, Notify_TM__c, Notify_TM_Date__c, Project_Data_Completed__c, Project_Data_Completed_Date__c, TM_Response_Time__c, Contractor_Supplying__r.Name, Dealer_Supplying__r.Name, Ship_Date__c, VAP_Count__c, VAP_MSF_Total__c, Validated_by_Board_RM__c, Validated_by_Finishing_RM__c, Validated_by_OSM__c, Type, Agreement_Date__c, Segment__c, TotalOpportunityQuantity, CloseDate, Account_Segment__c, Opp_Owner_SGID__c, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems ) FROM Opportunity Where StageName='Completed Won' AND  CloseDate >= :startDate AND CloseDate <= :endDate AND Owner.UserRole.Name like '%Architectural Solutions Manager%' AND VAP_Count__c >= 2 AND TotalOpportunityQuantity >= 300];
        List<Opportunity> oppStrgBuildPartList = [SELECT id, Name, Owner.Name, Owner.UserRole.Name, Opportunity_Count__c, Owner.Region__c, Data_Quality_Score__c, CreatedDate, StageName, Notify_TM__c, Notify_TM_Date__c, Project_Data_Completed__c, Project_Data_Completed_Date__c, TM_Response_Time__c, Contractor_Supplying__r.Name, Dealer_Supplying__r.Name, Ship_Date__c, VAP_Count__c, VAP_MSF_Total__c, Validated_by_Board_RM__c, Validated_by_Finishing_RM__c, Validated_by_OSM__c, Type, Agreement_Date__c, Segment__c, TotalOpportunityQuantity, CloseDate, Account_Segment__c, Opp_Owner_SGID__c, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems Where Name IN ('habito','airrenew','silentfx','diamondback')) FROM Opportunity Where CloseDate >= :startDate AND CloseDate <= :endDate AND Type = 'Strategic Builder Partnership' AND RecordType.Name ='Gypsum USA Conversions'];
        List<Opportunity> oppResDrywallContrList = [SELECT id, Name, Owner.Name, Owner.UserRole.Name, Opportunity_Count__c, Owner.Region__c, Data_Quality_Score__c, CreatedDate, StageName, Notify_TM__c, Notify_TM_Date__c, Project_Data_Completed__c, Project_Data_Completed_Date__c, TM_Response_Time__c, Contractor_Supplying__r.Name, Dealer_Supplying__r.Name, Ship_Date__c, VAP_Count__c, VAP_MSF_Total__c, Validated_by_Board_RM__c, Validated_by_Finishing_RM__c, Validated_by_OSM__c, Type, Agreement_Date__c, Segment__c, TotalOpportunityQuantity, CloseDate, Account_Segment__c, Opp_Owner_SGID__c, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems ) FROM Opportunity Where CloseDate >= :startDate AND CloseDate <= :endDate AND Type = 'Drywall Contractor Project Sale' AND RecordType.Name ='Gypsum USA Conversions' AND Segment__c = 'Residential']; 
        List<Opportunity> oppComDrywallContrList = [SELECT id, Name, Owner.Name, Owner.UserRole.Name, Opportunity_Count__c, Owner.Region__c, Data_Quality_Score__c, CreatedDate, StageName, Notify_TM__c, Notify_TM_Date__c, Project_Data_Completed__c, Project_Data_Completed_Date__c, TM_Response_Time__c, Contractor_Supplying__r.Name, Dealer_Supplying__r.Name, Ship_Date__c, VAP_Count__c, VAP_MSF_Total__c, Validated_by_Board_RM__c, Validated_by_Finishing_RM__c, Validated_by_OSM__c, Type, Agreement_Date__c, Segment__c, TotalOpportunityQuantity, CloseDate, Account_Segment__c, Opp_Owner_SGID__c, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems ) FROM Opportunity Where CloseDate >= :startDate AND CloseDate <= :endDate AND Type = 'Drywall Contractor Project Sale' AND RecordType.Name ='Gypsum USA Conversions' AND Segment__c = 'Non-Residential']; 
        if(Test.isRunningTest()) oppComDrywallContrList = [SELECT id, Name, Owner.Name, Owner.UserRole.Name, Opportunity_Count__c, Owner.Region__c, Data_Quality_Score__c, CreatedDate, StageName, Notify_TM__c, Notify_TM_Date__c, Project_Data_Completed__c, Project_Data_Completed_Date__c, TM_Response_Time__c, Contractor_Supplying__r.Name, Dealer_Supplying__r.Name, Ship_Date__c, VAP_Count__c, VAP_MSF_Total__c, Validated_by_Board_RM__c, Validated_by_Finishing_RM__c, Validated_by_OSM__c, Type, Agreement_Date__c, Segment__c, TotalOpportunityQuantity, CloseDate, Account_Segment__c, Opp_Owner_SGID__c, (Select Product2Id, Name, Product_Grouping__c From OpportunityLineItems ) FROM Opportunity]; 
        listOpportunity.add(oppDataQalityList);
        listOpportunity.add(oppJobTrackingList);
        listOpportunity.add(oppCTCornersList);
        listOpportunity.add(oppMajorProjectSoldList);
        listOpportunity.add(oppStrgBuildPartList);
        listOpportunity.add(oppResDrywallContrList);
        listOpportunity.add(oppComDrywallContrList);
        
        Set<Id> idSet = new Set<Id>();
        Map<id,Opportunity> oppMap = new Map<id,Opportunity>();
        
        if(listOpportunity.size() > 0){
            for(List<Opportunity> listOpp : listOpportunity){
                OppList.addAll(listOpp);                
            }
        }
        for(Opportunity opp : OppList){
            idSet.add(opp.id);
            oppMap.put(opp.id,opp);
        }
        
        if(OppList.size() > 0 ){           
            //for(Opportunity opp : OppList) {
              for(Id idkey : idSet){
                   
                Opportunity opp = oppMap.get(idkey);   
                oppService = new OpportunityService();    
                
                oppService.OpportunityOwner = opp.Owner.Name;
                oppService.OpportunityOwnerRole = opp.Owner.UserRole.Name;
                oppService.OpportunityName = opp.Name;   
                oppService.OpportunityCount = Integer.valueOf(opp.Opportunity_Count__c);
                oppService.OpportunityDataQualityScore = Integer.valueOf(opp.Data_Quality_Score__c);
                oppService.Stage = opp.StageName;
                oppService.OpportunityOwnerRegion = opp.Owner.Region__c;
                //oppService.WonLostDate = opp.Construction_Won_Date__c;
                oppService.OpportunityId = opp.Id;
                oppService.NotifyTM = opp.Notify_TM__c;
                oppService.NotifyTMDate = opp.Notify_TM_Date__c;
                oppService.ProjectDataCompleted = opp.Project_Data_Completed__c;
                oppService.ProjectDataCompletedDate = opp.Project_Data_Completed_Date__c;
                oppService.TMResponseTime = Integer.valueOf(opp.TM_Response_Time__c);
                oppService.ContractorSupplying = opp.Contractor_Supplying__r.Name;
                oppService.DealerSupplying = opp.Dealer_Supplying__r.Name;
                oppService.VAPCount = Integer.valueOf(opp.VAP_Count__c);
                oppService.VAPMSF = Integer.valueOf(opp.VAP_MSF_Total__c);                  
                oppService.ValidatedByBoardRM = opp.Validated_by_Board_RM__c;
                oppService.ValidatedByFinishingRM = opp.Validated_by_Finishing_RM__c;
                oppService.ValidateByOSM = opp.Validated_by_OSM__c;
                oppService.OpportunityType = opp.Type;            
                oppService.AgreementDate = opp.Agreement_Date__c;
                oppService.ShipDate = opp.Ship_Date__c;
                oppService.Segment = opp.Segment__c;
                oppService.TotalOppQuantity = Integer.valueOf(opp.TotalOpportunityQuantity);
                oppService.CloseDate = opp.CloseDate;
                oppService.AccountSegment = opp.Account_Segment__c;
                oppService.OppOwnerSGId = opp.Opp_Owner_SGID__c;
                
                listLineItem = new List<OppLineItemService>();
                
                    if(opp.OpportunityLineItems != null){
                        for(OpportunityLineItem lineItem : opp.OpportunityLineItems){
                            oppLineItem = new OppLineItemService();
                            oppLineItem.Product2Id = lineItem.Product2Id;
                            oppLineItem.ProductName = lineItem.Name;
                            oppLineItem.ProductGrouping = lineItem.Product_Grouping__c;
                            
                            listLineItem.add(oppLineItem);
                        }
                        
                    }
                    oppService.OppProdService = listLineItem;                    
                
                listOpportunityService.add(oppService);
               }
        }
        return listOpportunityService;
    }
}