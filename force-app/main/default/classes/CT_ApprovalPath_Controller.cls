public class CT_ApprovalPath_Controller {   
    //public static Boolean isFirstTime = true;     
    @AuraEnabled    
    public static Case getCaseData(String caseId){  
        Case c = [SELECT Id,RecordTypeId, RecordType.Name, Status, TM__c, RSM__c, Country__c, IsClosed, Supplier_Approver_Id__c,ZRE_Order_Number__c,Return_Date__c,   
                  Plant_Quality_Manager_Id__c, Plant_Manager_Id__c, Supplier__c, Manufacturing_Plant__c, Sales_Rep__c,Issue_Problem__c,Investigator__c,Logistics_Agree_Disagree__c,    
                  Settlement_Recommendation__c,Total_Case_Value__c, Settle_Action__c,Total_Credits__c,Total_Rebills__c,Warehouse__c,Pre_Approver_1b_Pricing__c,Comments_Plant_Manager__c,
                   Pre_Approver_1b_Agree_Disagree__c,Confidential__c, Comments_Logistics__c,VP__c, Corrective_Action__c, Owner.name,Planner__c,Plant_Manager__c,Plant_Manager_Agree_Disagree__c ,Secondary_Issue_Category__c,Third_Issue_Category__c,
                  CreatedBy.name, VP_Approved_Via_Email__c, Order_Type_Picklist__c,OwnerId,createdbyid FROM Case WHERE Id=:caseId]; 
                 
                   
        return c;   
    }   
        
  @AuraEnabled  
  public static string getIssueData(String caseId) 
    {   
        string csStatus;
        
        List<Issues__c>  issueList = new List<Issues__c> ();
        issueList = [select id,Category__c, Problem__c from Issues__c where Case__c =:caseId  and Category__c!='' and Problem__c!='' ];
        List<Case> salesorgList =[select id, Sales_Org__c from Case where id =:caseId];
        system.debug('issueList'+issueList);
         system.debug('salesorgList'+salesorgList);
        if(issueList!=null && !issueList.isEmpty()) {
          
         List<CT_Issues_Problem_Code__c> csissueList  =[select Status__c, Category__c, Problem__c, Business_Unit__c, Sales_Org__c from CT_Issues_Problem_Code__c 
                          where Status__c !='' and Problem__c=:issueList[0].Problem__c and Category__c =: issueList[0].Category__c and Sales_Org__c=:salesorgList[0].Sales_Org__c ];
          if(csissueList.size() > 0)    csStatus =csissueList[0].Status__c;
        }
        system.debug('csStatus'+csStatus);
         return csStatus;  
        
    }
    
   @AuraEnabled   
    public static List<CaseApprovalPath_Config__c> getApprovalPathData(String recordTypeId, String country,string OwnerId,string CreatedById,string caseId,string SecondaryIssueCategory){  
        List<CaseApprovalPath_Config__c> retList = new List<CaseApprovalPath_Config__c>();  
        List<CaseApprovalPath_Config__c> rList = new List<CaseApprovalPath_Config__c>();    
        string recordTypeName = Schema.SObjectType.Case.getRecordTypeInfosById().get(recordTypeId).getname();   
        //add for MWB   
        Case c = [SELECT Id,RecordTypeId, RecordType.Name, Status, TM__c, RSM__c, Country__c, IsClosed, Supplier_Approver_Id__c,ZRE_Order_Number__c,Return_Date__c,Logistics_Agree_Disagree__c,    
                  Plant_Quality_Manager_Id__c, Plant_Manager_Id__c, Supplier__c,Comments_Logistics__c, Manufacturing_Plant__c, Sales_Rep__c,Issue_Problem__c,Investigator__c,Comments_Plant_Manager__c,  
                  Settlement_Recommendation__c, Planner__c,Plant_Manager__c,Secondary_Issue_Category__c,Third_Issue_Category__c,Total_Credits__c,Total_Rebills__c,  
                  Confidential__c, VP__c,Plant_Manager_Agree_Disagree__c, Corrective_Action__c,Warehouse__c,Pre_Approver_1b_Pricing__c,
                  Pre_Approver_1b_Agree_Disagree__c,VP_Approved_Via_Email__c, Order_Type_Picklist__c,OwnerId,(Select Category__c,Reporting_Index_Type__c, Problem__c FROM Issues__r), createdbyid 
                  FROM Case WHERE Id=:caseId];  
                  
        system.debug('======Caseid=========='+ c.id +c.Issue_Problem__c);   
        if(String.isNotEmpty(recordTypeId) && String.isNotEmpty(country)&& country == 'Canada' ){   
            retList = [SELECT Id, AssigneeType__c, Field__c, Next_Status__c, Status__c, Status_Label__c, Value__c   
                       FROM CaseApprovalPath_Config__c WHERE RecordTypeId__c =:recordTypeId AND Country__c = :country ORDER BY Sort_Order__c ASC];     
                       //AND Country__c = :country AND Sort_Order__c NOT IN (207,208) ORDER BY Sort_Order__c ASC];//UPdating logic as per new Project IPG one Click form MWB    
                       
            system.debug('retList after else'+retList);     
        }   
        // INC0722458 Added by Sandip Patel         
        else if(String.isNotEmpty(recordTypeId) && String.isNotEmpty(country)){     
            retList = [SELECT Id, AssigneeType__c, Field__c, Next_Status__c, Status__c, Status_Label__c, Value__c       
                       FROM CaseApprovalPath_Config__c WHERE RecordTypeId__c =:recordTypeId AND Country__c = 'USA' ORDER BY Sort_Order__c ASC];  
        }   
            
        Map<string,List<CaseApprovalPath_Config__c>> issueMap= new Map<string,List<CaseApprovalPath_Config__c>>();  
        for(CaseApprovalPath_Config__c cc:[SELECT Id,Sort_Order__c , AssigneeType__c, Field__c, Next_Status__c,Status__c, Status_Label__c, Value__c 
                                           FROM CaseApprovalPath_Config__c WHERE RecordTypeId__c =:recordTypeId AND Country__c = :country ORDER BY Sort_Order__c ASC])   
        {   
            if(!issueMap.containsKey(country)){ 
                issueMap.put(country, new List<CaseApprovalPath_Config__c>{cc});    
            }else{  
                issueMap.get(country).add(cc);  
            }   
                
        }   
            
        List<Issues__c> issueList = [select id,Problem__c from Issues__c where Case__c =:caseId limit 5];   
        if(issueList.size() > 0){   
            system.debug('caseid '+caseId); 
            for(Issues__c issue: issueList) 
            {   
                if( String.isNotEmpty(issue.Problem__c) && issue.Problem__c =='Service Charter Product Failure' &&  
                   String.isNotEmpty(recordTypeId) && String.isNotEmpty(country) && country =='Canada') 
                {   
                        
                    retList= issueMap.get(country); 
                        
                }   
                    
            }       
            //system.debug('issueMap.get(country)'+issueMap.get(country));  
        }   
            
        system.debug('======retList=========='+ retList);   
        return retList; 
            
    }
    @AuraEnabled
    public static boolean updateCase(String caseId, String status, String ownerId){
         System.Debug('=============== Owner ID2 ==================' + ownerID);    
        String profileId = ((String)UserInfo.getProfileId()).left(15);  
        CT_Common_Settings__c common = CT_Common_Settings__c.getInstance(); 
           
        Group FreightDepartment  =[SELECT Id, Name, DeveloperName, Email, Type FROM Group where Type='Queue' And Name ='Freight Department Queue' limit 1];
        Group closure =[SELECT Id, Name, DeveloperName, Email, Type FROM Group where Type='Queue' And Name ='Canada Closer' limit 1];
        Group rmaID =[SELECT Id, Name, DeveloperName, Email, Type FROM Group where Type='Queue' And Name ='CSR Queue' limit 1];
        
        Group csmID =[SELECT Id, Name, DeveloperName, Email, Type FROM Group where Type='Queue' And Name ='Canada Service Investigator CSM' limit 1];
        CT_Issues_Problem_Code__c ctIssue =CT_Issues_Problem_Code__c.getInstance();
        Case currCase = [SELECT id,Status, OwnerId, CreatedById, RecordType.Name, Country__c, Warehouse__c,ZRE_Order_Number__c,Return_Date__c,Manufacturing_Plant__c, 
                         Total_Case_Value__c,Issue_Category__c,Issue_Problem__c,Total_Credits__c,Total_Rebills__c,Logistics_Agree_Disagree__c,Pre_Approver_1b_Pricing__c,
                         Pre_Approver_1b_Agree_Disagree__c,Settlement_Recommendation__c, Comments_Planning__c,Comments_Logistics__c, Planner__c,Plant_Manager__c,Secondary_Issue_Category__c,Third_Issue_Category__c, 
                         Plant_Manager_Agree_Disagree__c,Comments_Plant_Manager__c,Agree_Disagree__c, Investigator__c, Settle_Action__c,    
                         Order_Type_Picklist__c, RSM__c, Sales_Org__c, (Select Category__c,Reporting_Index_Type__c, Problem__c FROM Issues__r) FROM Case  WHERE Id = :caseId];    
                         
        System.debug('====================Case in upadte======================'+currCase.Secondary_Issue_Category__c+currCase.Third_Issue_Category__c+currCase.status +status);
       //to populate value in Manufacturing Plant(Manufacturing_Plant__c
        system.debug('currCase.Warehouse__c@Shipping Plant '+currCase.Warehouse__c);
        system.debug('currCase.Manufacturing_Plant__c@BeforeManufacturing Plant '+currCase.Manufacturing_Plant__c);
        if(currCase.Warehouse__c != null && currCase.Warehouse__c !='' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case' && currCase.Issue_Category__c !='Service Incomplete'&& currCase.Issue_Problem__c !='Service Charter Product Failure')
        {
            //&& currCase.Manufacturing_Plant__c== null && currCase.Manufacturing_Plant__c =='' 
           
            /*working Code
           List<Plants__c> plantList =[select id,Name from Plants__c where name=:currCase.Warehouse__c Limit 1];
            System.debug('Plant id'+plantList[0].id+'name'+plantList[0].Name);
            currCase.Manufacturing_Plant__c = plantList[0].id;
            system.debug('currCase.Manufacturing_Plant__c@AfterManufacturing Plant '+currCase.Manufacturing_Plant__c); */
           //if(currCase.Sales_Org__c =='1300')
           if(currCase.Sales_Org__c == System.Label.SalesOrg1300)
           {
           system.debug('System.Label.SalesOrg1300'+System.Label.SalesOrg1300);
           system.debug('currCase.Sales_Org__c==>'+ currCase.Sales_Org__c);
           List<Plants__c> plantList =[select id,Name,SAP_Plant_Name__c from Plants__c where SAP_Plant_Name__c=:currCase.Warehouse__c Limit 1];
           
           System.debug('Plant id'+plantList[0].id+'name'+plantList[0].SAP_Plant_Name__c );
           currCase.Manufacturing_Plant__c = plantList[0].id;
           system.debug('currCase.Manufacturing_Plant__c@AfterManufacturing Plant '+currCase.Manufacturing_Plant__c);
           }
           //if(currCase.Sales_Org__c !='1300')
           if(currCase.Sales_Org__c != System.Label.SalesOrg1300)
           {
           system.debug('currCase.Sales_Org__c==>'+ currCase.Sales_Org__c);
           List<Plants__c> plantList =[select id,Name from Plants__c where name=:currCase.Warehouse__c Limit 1];
           System.debug('Plant id'+plantList[0].id+'name'+plantList[0].Name);
           currCase.Manufacturing_Plant__c = plantList[0].id;
           system.debug('currCase.Manufacturing_Plant__c@AfterManufacturing Plant '+currCase.Manufacturing_Plant__c);
           }
        }
        
        // Added by Amit for CHG0632450
        if (status == 'Pending Admin' && String.isBlank(ownerId)) {
            Profile prfl = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId() LIMIT 1];
            
            if (prfl.Name != 'System Administrator') {
              ownerId = common.QueueId_Admin_Queue__c;
            }
        }
        // Added by Amit for CHG0590152
        if (status == 'Pending RSM' && currCase.Order_Type_Picklist__c != 'Marketing' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Sales Adjustment No Charge') {
          ownerId = currCase.RSM__c;
        }
        if (currCase.Order_Type_Picklist__c == 'Marketing' && currCase.Agree_Disagree__c == 'Disagree' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Sales Adjustment No Charge') {
          status = 'Draft';
          ownerId = currCase.CreatedById;
        }
        // Added by Amit for CHG0647608
        if (status == 'Pending Closer' && (currCase.RecordType.Name == 'Sales Adjustment Area Price US' || currCase.RecordType.Name == 'Sales Adjustment Rebates US'|| currCase.RecordType.Name == 'Sales Adjustment Price Exception')) {
             ownerId = common.QueueId_US_Closer__c;
        }
        
        if (status == 'Pending Closer' && currCase.RecordType.Name == 'Sales Adjustment Specials'){// INC0736669 - Added by Shashi 12/02/2019
            if(currCase.Country__c == 'Canada'){ //INC0757784 - Added by Sandip (separated if from above and added condition to assign owner queue based on Country) - 01272020 
                ownerId = common.QueueId_Can_Closer__c;
            }
            else{
                ownerId = common.QueueId_US_Closer__c;
            }
        }
        
        //system.debug('currCase.RecordType.Name'+currCase.RecordType.Name);    
        // IPG one Click MWB Service Case   
        /*if(currCase.Status =='Draft' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case'&& String.isBlank(currCase.Investigator__c)  
           && currCase.Issue_Category__c !='Service Incomplete'&& currCase.Issue_Problem__c !='Service Charter Product Failure')   
        {   
          currCase.Investigator__c = currCase.CreatedById;  
        }  */ 
        
        system.debug('currCase.Status'+currCase.Status);  
        system.debug('Status'+Status); 
        
        //Canada MWB - Quality Case - Start // Added by Sandip        
        
        if ((currCase.RecordType.Name == 'Quality Case' || currCase.RecordType.Name == 'Manual Quality Entry Case') && currCase.Country__c == 'Canada'){            
            List<String>selectedSettlements = new List<String>();
            if (currCase.Settle_Action__c != null) {
                selectedSettlements = currCase.Settle_Action__c.split(';');                               
                if (selectedSettlements.contains('Return Material')) {                 
                    if(Status == 'Pending RMA'){
                        ownerId = common.QueueId_CSR_Queue__c;
                    }               
                    else if(Status == 'Pending Pre Approver Closer'){
                        ownerId = common.QueueId_Can_Closer__c;
                    }
                    
                }
            }
        }
        if(Status =='Pending Pre-Settlement Closer' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case' && currCase.Issue_Category__c !='Service Incomplete' && currCase.Issue_Problem__c !='Service Charter Product Failure')   
        {   
          system.debug('closure inside Pending Pre-Settlement Closer'+closure);  
          ownerId =closure.id;    
          system.debug('ownerId'+ownerId);
           
           
        } 
        if(Status =='Pending Plant' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case' && currCase.Issue_Category__c !='Service Incomplete' && currCase.Issue_Problem__c !='Service Charter Product Failure')   
        {   
          system.debug('closure'+closure);  
          ownerId = currCase.Plant_Manager__c;    
          system.debug('ownerId'+ownerId);    
        } 
        if(Status =='Pending RMA' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case' && currCase.Issue_Category__c !='Service Incomplete' && currCase.Issue_Problem__c !='Service Charter Product Failure')   
        {   
          system.debug('rmaID'+rmaID);  
          ownerId = rmaID.id;    
          system.debug('ownerId'+ownerId);    
        } 
        if(Status =='Pending Logistics' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case' && currCase.Issue_Category__c !='Service Incomplete' && currCase.Issue_Problem__c !='Service Charter Product Failure')   
        {   
          system.debug('Freight'+FreightDepartment);  
          ownerId =FreightDepartment.id;    
          system.debug('ownerId'+ownerId);    
        } 
        if(Status =='Pending CSM' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case' && currCase.Issue_Category__c !='Service Incomplete' && currCase.Issue_Problem__c !='Service Charter Product Failure')   
        {   
          system.debug('csmID'+csmID);  
          ownerId =csmID.id;    
          system.debug('ownerId'+ownerId);    
        } 
        if(Status =='Pending RSM' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case' && currCase.Issue_Category__c !='Service Incomplete' && currCase.Issue_Problem__c !='Service Charter Product Failure')   
        {   
          //ownerId 
            ownerId = currCase.RSM__c;  
        } 
         if(Status =='Pending Closer' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case'&& currCase.Issue_Category__c !='Service Incomplete' && currCase.Issue_Problem__c !='Service Charter Product Failure')   
        {   
          system.debug('To be as closed'+status); 
          ownerId = common.QueueId_Can_Closer__c ;    
        } 
        if(Status =='Pending VP' && currCase.Country__c == 'Canada' && currCase.RecordType.Name == 'Service Case' && currCase.Issue_Category__c !='Service Incomplete' && currCase.Issue_Problem__c !='Service Charter Product Failure')       
        {       
          system.debug('To be as closed'+status);  
          ownerId = currCase.VP__c ;     
        }
        

     
            //&& currCase.Issue_Category__c =='Service Incomplete'
        if (currCase.RecordType.Name == 'Service Case' && currCase.Country__c == 'Canada'&& currCase.Issue_Problem__c =='Service Charter Product Failure'){// MWB 
                if(status == 'Pending Planner' && String.isBlank(currCase.Comments_Planning__c) ){  
                    system.debug('To be as planning Queue');    
                    ownerId = common.QueueId_Planning_Queue__c; 
                }   
                //&& currCase.Issue_Category__c =='Service Incomplete' 
                if(currCase.RecordType.Name == 'Service Case' && status == 'Pending Planner' && String.isNotBlank(currCase.Comments_Planning__c) && currCase.Issue_Problem__c =='Service Charter Product Failure'){   
                       system.debug('To be as planner from plant to Planner');  
                       ownerId = currCase.Planner__c;   
                   }    
            }   
        // && currCase.Issue_Category__c =='Service Incomplete' 
        if (currCase.RecordType.Name == 'Service Case' && currCase.Country__c == 'Canada' && currCase.Issue_Problem__c =='Service Charter Product Failure'){// MWB 
                if (status == 'Pending Plant' ){// MWB  
                    system.debug('To be aspending plant'+status);   
                    ownerId = currCase.Plant_Manager__c;    
                }   
            }
        //CHG1135263 Deepak 
           if (currCase.RecordType.Name == 'Service Case' && currCase.Country__c == 'Canada' && (currCase.Status == 'Pending Pre-Settlement Closer' || currCase.Status == 'Pending Investigator') )
           {
              If(currCase.Warehouse__c == 'GYP Albany, NY Reload' || currCase.Warehouse__c == 'GYP Apex Plant' || currCase.Warehouse__c == 'GYP Bend Corners Plant' || currCase.Warehouse__c == 'GYP Black Rock Mine' || currCase.Warehouse__c == 'CT Gypsum Buchanan' ||currCase.Warehouse__c == 'GYP Carrollton Board Plant' || currCase.Warehouse__c == 'GYP Cody Board Plant & Mine' || currCase.Warehouse__c == 'GYP DSG WHSE MVILLE IND PK' || currCase.Warehouse__c == 'GYP Edison Reload' || currCase.Warehouse__c == 'GYP Fort Dodge Board & Mine' || currCase.Warehouse__c == 'GYP Hopedale Reload' || currCase.Warehouse__c == 'GYP Indianapolis WHS(for TPC)' || currCase.Warehouse__c == 'GYP Junction City Tape Plant' || currCase.Warehouse__c == 'GYP Kent,WA Finishing Plant' || currCase.Warehouse__c == 'GYP Las Vegas Board' || currCase.Warehouse__c == 'GYP Las Vegas Finishing Plant' || currCase.Warehouse__c == 'GYP Malvern' || currCase.Warehouse__c == 'GYP Malvern Virtual WHSE' ||  currCase.Warehouse__c == 'GYP Moundsville Board Plant' ||  currCase.Warehouse__c == 'GYP Napa, CA Tape Plant' ||  currCase.Warehouse__c == 'GYP Nashville Board & mine' ||  currCase.Warehouse__c == 'CT Gypsum Palatka' ||  currCase.Warehouse__c == 'GYP Portland Reload' ||  currCase.Warehouse__c == 'GYP Portland Temp Warehouse' ||  currCase.Warehouse__c == 'GYP Rancho Cucamonga Reload' ||  currCase.Warehouse__c == 'GYP Roxboro Board Plant' ||  currCase.Warehouse__c == 'GYP Seattle Board Plant' ||  currCase.Warehouse__c == 'GYP Sierra Reload' ||  currCase.Warehouse__c == 'CT Gypsum Silver Grove' ||  currCase.Warehouse__c == 'GYP SOCIAL CIRCLE FINISHING' ||  currCase.Warehouse__c == 'GYP Todd Reload' ||  currCase.Warehouse__c == 'GYP US WHSE LETART WV' ||  currCase.Warehouse__c == 'GYP Winder Finishing' ||  currCase.Warehouse__c == 'CEIL Lanse' ||  currCase.Warehouse__c == 'CEIL Plymouth' ||  currCase.Warehouse__c == 'CEIL Vaughan' ||  currCase.Warehouse__c == 'IG Redcliff Certainteed Corp' ||  currCase.Warehouse__c == 'IG VIB Certainteed Corp')
               //If(currCase.Warehouse__c == system.Label.Shipping_plant)
               {
                 Status = 'Pending CSM';
            //  ownerId = currCase.CreatedById;
                  ownerId =csmID.id;
                   //ownerId = currCase.RSM__c;
                }
               if (currCase.Status == 'Pending CSM' ){
                    status = 'pending VP';
                    ownerId = currCase.VP__c ;     
                }
                } 
         
        //&& currCase.Issue_Category__c =='Service Incomplete'
        if (currCase.RecordType.Name == 'Service Case' && currCase.Country__c == 'Canada'&& currCase.Issue_Problem__c =='Service Charter Product Failure'){// MWB 
                if (status == 'Closed' ){// MWB 
                    system.debug('To be as closed'+status); 
                    ownerId = common.QueueId_Can_Closer__c ;    
                }   
            }       
        system.debug('currCase.Country__c'+currCase.Country__c);
        if( currCase.RecordType.Name == 'Service Case' && currCase.Country__c == 'Canada'   ){
            for(Issues__c issue : currCase.Issues__r){
              if (issue.Problem__c == 'Detention Fee' && currCase.Total_Case_Value__c == 0){
                    system.debug('i am in Detention Fee ');
                    Status ='closed';
                    ownerId = currCase.CreatedById;
                    break; 
              }
              
                system.debug('issue.Problem__c'+issue.Problem__c);
                system.debug('issue.Category__c'+issue.Category__c);
                system.debug('currCase.Total_Case_Value__c'+currCase.Total_Case_Value__c);
               
                if ( (issue.Category__c == 'Documentation') && (issue.Problem__c =='Dunnage/Scrap') )
                {
                    if( currCase.Total_Case_Value__c == 0 )
                    {
                        system.debug('Value equal to Zero');
                        system.debug('issue.Problem__c'+issue.Problem__c);
                        system.debug('issue.Category__c'+issue.Category__c);
                        system.debug('currCase.Total_Case_Value__c'+currCase.Total_Case_Value__c);
                        Status ='closed';
                        ownerId = currCase.CreatedById;
                        break;
                    }else
                    {
                        System.Debug('======THE STATUS: ' + status);
                        if(status != 'Closed'){  //INC1013676 - Sandip - 14/03/2022 - added If Else conditions 
                            system.debug('Value Less than OR greater than to Zero');
                            system.debug('issue.Problem__c'+issue.Problem__c);
                            system.debug('issue.Category__c'+issue.Category__c);
                            system.debug('currCase.Total_Case_Value__c'+currCase.Total_Case_Value__c);
                            Status ='Pending Closer';
                            ownerId = common.QueueId_Can_Closer__c;
                            break;
                        }
                        else{ 
                            ownerId = currCase.OwnerId;
                            break;
                        }
                    }
                }
              
                if (issue.Problem__c == 'Pallet Return' &&  currCase.status =='Pending Investigator'    
                    && currCase.Settlement_Recommendation__c =='Invoice Correction' 
                    && currCase.Issue_Problem__c !='Service Charter Product Failure' ){ 
                    system.debug('i am in Pallet Return andPending Pre-Settlement Closer'+issue.Problem__c +currCase.status);   
                    Status ='Pending Closer';   
                    //ownerId = currCase.Pre_Approver_1b_Pricing__c;    
                    ownerId = common.QueueId_Can_Closer__c ;    
                    break;  
                }   
                if (issue.Problem__c == 'Pallet Return' &&  currCase.status =='Pending Pre-Settlement Closer'   
                    && currCase.Issue_Problem__c !='Service Charter Product Failure' ){ 
                    system.debug('i am in Pallet Return andPending Pre-Settlement Closer'+issue.Problem__c +currCase.status);   
                    Status ='closed';   
                    ownerId = currCase.Pre_Approver_1b_Pricing__c;  
                    //ownerId = common.QueueId_Can_Closer__c ;  
                    break;  
                }
                /*if (issue.Problem__c == 'Pallet Return'){
                    system.debug('i am in Pallet Return ');
                    Status ='Pending Closer';
                    ownerId = common.QueueId_Can_Closer__c ;
                    break;
                }
                */
                
               
           //} 
            }
        }
        
        String allowedProfile = common.CaseApprovalPath_OverridingProfileIds__c;
        Set<String> allowedProfileSet = new Set<String>();
        if (String.isNotEmpty(allowedProfile)){
            String[] profileList = allowedProfile.split(',');
            for (String currProfile : profileList){
                allowedProfileSet.add(currProfile.left(15));
            }
        }

        if (currCase.OwnerId != UserInfo.getUserId() && allowedProfileSet.contains(profileId)==false){           
            AuraHandledException ahEx = new AuraHandledException('You are not the current owner of the Case.  You cannot advance the Status of the Case.');
            ahEx.setMessage('You are not the current owner of the Case.  You cannot advance the Status of the Case.');
            throw ahEx;   
        }
       currCase.Status = status;
        if (String.isNotEmpty(ownerId)) currCase.OwnerId = ownerId; 
        update currCase; 
        return true; 
    }
    // get custom setting data //04/09/21    
    @AuraEnabled    
    public static Decimal getCustomSetting(String caseId){  
        case casObj = [select id,Sales_Org__c, RecordTypeId from case where id =: caseId];            
        List<Sales_Org_value__c> salesOrg = [select id,Value__c,Name from Sales_Org_value__c where Sales_Org__c =: casObj.Sales_Org__c AND Record_Type_Id__c =: casObj.RecordTypeId];  
        if(salesOrg.size() > 0){
            System.debug('Value from CS:::' + salesOrg[0].Value__c);
            return salesOrg[0].Value__c;   
        }
        else{
            return 0;
        }                
    }   
    
    /* edited by katrina during EPS consolidation to delete PELI object
    
    //Added by Sandip to validate PriceExceptionLine Item - 10/10/2018
    @AuraEnabled
  public static List<PriceExceptionLineItem> getPriceExceptionLineData(String caseId){

    // PriceExceptionLineItem wrapper class to objectify Price_Exception_Line_Item__c 
    List<PriceExceptionLineItem> listOfPriceExpItms = new List<PriceExceptionLineItem>();    
    for(Price_Exception_Line_Item__c priceLineItem : [SELECT Id, Case__c, Division__c, IDC_Code__c, Product_Group_Code__c, Product_Group__c, Order_UOM__c, 
                              Price_UOM__c, Current_Price__c, Exception_Price__c, Remove__c, New__c, IDC_Description__c, Name 
                              FROM Price_Exception_Line_Item__c WHERE Case__c = :caseId]){
                                
    listOfPriceExpItms.add(new PriceExceptionLineItem(priceLineItem));
    }    
    return listOfPriceExpItms;
  }
  
   
    
    
    public class PriceExceptionLineItem {

        @AuraEnabled public String recId;
        @AuraEnabled public String idcDescription;
        @AuraEnabled public String idcCode;
        @AuraEnabled public String productGroupCode;
        @AuraEnabled public String orderUOM;
        @AuraEnabled public String priceUOM;
        @AuraEnabled public String division;
        @AuraEnabled public Decimal currentPrice;
        @AuraEnabled public Decimal exceptionPrice;
        @AuraEnabled public Boolean removeItem;
        @AuraEnabled public Boolean newItem;
        @AuraEnabled public Boolean isEdit;
        
        public PriceExceptionLineItem(Price_Exception_Line_Item__c priceExpLineItm){
            this.recId = priceExpLineItm.Id;
            this.idcDescription = priceExpLineItm.IDC_Description__c;
            this.idcCode = priceExpLineItm.IDC_Code__c;
            this.productGroupCode = priceExpLineItm.Product_Group_Code__c;
            this.orderUOM = priceExpLineItm.Order_UOM__c;
            this.priceUOM = priceExpLineItm.Price_UOM__c;
            this.division = priceExpLineItm.Division__c;
            this.currentPrice = priceExpLineItm.Current_Price__c;
            this.exceptionPrice = priceExpLineItm.Exception_Price__c;
            this.removeItem = priceExpLineItm.Remove__c;
            this.newItem = priceExpLineItm.New__c;
            this.isEdit = false;
        }
    }
    //End here
*/

}