@isTest(SeeAllData=True)
public class SupplyChain_ApprovalComment_Handler_Test {
  static testMethod void run()
    {  
        //List<Supply_Chain__c> SCs = [Select sc.Id, sc.Copy_Approval_Comments__c, sc.Approval_Comments__c, (Select Comments From ProcessSteps where Comments <> '' and Comments <> null) From Supply_Chain__c sc where Status__c = 'Forward to Plant for Shipping Process' limit 20];                     
         List<Supply_Chain__c> SCsToUpdate = new List<Supply_Chain__c>(); //stores records to be updated
        Account acc = new Account();
        acc.Name = 'acc';
        Insert acc;
        // Updated by jasvinder for Case Number 00203178 START
        List<Supply_Chain__c> SClist = new List<Supply_Chain__c>(); 
        Supply_Chain__c scReq = new  Supply_Chain__c(); 
        scReq.Copy_Approval_Comments__c = false;
        scReq.Account__c = acc.Id;
        SClist.add(scReq);
        insert SClist ;
        
          
        set<id> SCIds = new set<id>();
        List<User> submitter = [SELECT FirstName,lastname,Email,id,Isactive FROM User WHERE IsActive = true and email != '' and FirstName!='' and lastname != ''];/*[SELECT Id FROM User WHERE IsActive = true LIMIT 1];*/
             
        if (SClist.size()>0){
            for(Supply_Chain__c sc: SClist){                    
                    sc.Copy_Approval_Comments__c = True;
                    sc.Approval_Comments__c = '';
                    SCsToUpdate.add(sc);
                    SCIds.add(sc.Id);
                    sc.SBU_Group__c ='Technical';
                    sc.MTO_Type__c ='Repeat';
                    sc.Pricing_Admin__c =submitter[0].Id;
                    sc.Same_Customer__c = true;
                    sc.Plant_Controller__c =submitter[0].Id;
                    sc.Product_Manager__c =submitter[0].Id;
                   // System.runAs(submitter) {
                      // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    //req1.setComments('Submitting request for approval.');
                    req1.setObjectId(sc.id);
                    // Submit on behalf of a specific submitter
                    //req1.setSubmitterId(user1.Id); 
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('SAMPLE_REQUEST_PROCESS_FOR_APPROVALS');
                    req1.setSkipEntryCriteria(true);
        
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                  //  }
                }
             }
      
       if( SCsToUpdate.size()> 0 ){
            Update SCsToUpdate;

  }  
      SupplyChain_ApprovalComment_Handler.updateSupplyChainComment(SCIds);
      SupplyChainTriggerHandler.updateRepeatMTO(SClist,null,true);
 }
  static testMethod void run1()
    {  
        //List<Supply_Chain__c> SCs = [Select sc.Id, sc.Copy_Approval_Comments__c, sc.Approval_Comments__c, (Select Comments From ProcessSteps where Comments <> '' and Comments <> null) From Supply_Chain__c sc where Status__c = 'Forward to Plant for Shipping Process' limit 20];                     
         List<Supply_Chain__c> SCsToUpdate = new List<Supply_Chain__c>(); //stores records to be updated
        Account acc = new Account();
        acc.Name = 'acc';
        Insert acc;
        // Updated by jasvinder for Case Number 00203178 START
        List<Supply_Chain__c> SClist = new List<Supply_Chain__c>(); 
        Supply_Chain__c scReq = new  Supply_Chain__c(); 
        scReq.Copy_Approval_Comments__c = false;
        scReq.Account__c = acc.Id;
        SClist.add(scReq);
        insert SClist ;
        
          
        set<id> SCIds = new set<id>();
        List<User> submitter = [SELECT FirstName,lastname,Email,id,Isactive FROM User WHERE IsActive = true and email != '' and FirstName!='' and lastname != ''];/*[SELECT Id FROM User WHERE IsActive = true LIMIT 1];*/
             
        if (SClist.size()>0){
            for(Supply_Chain__c sc: SClist){                    
                    sc.Copy_Approval_Comments__c = True;
                    sc.Approval_Comments__c = '';
                    SCsToUpdate.add(sc);
                    SCIds.add(sc.Id);
                    sc.SBU_Group__c ='Residential';
                    sc.MTO_Type__c ='In-Spec';
                    sc.Pricing_Admin__c =submitter[0].Id;
                    sc.Same_Customer__c = true;
                    sc.Plant_Controller__c =submitter[0].Id;
                    sc.Product_Manager__c =submitter[0].Id;
                   // System.runAs(submitter) {
                      // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    //req1.setComments('Submitting request for approval.');
                    req1.setObjectId(sc.id);
                    // Submit on behalf of a specific submitter
                    //req1.setSubmitterId(user1.Id); 
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('SAMPLE_REQUEST_PROCESS_FOR_APPROVALS');
                    req1.setSkipEntryCriteria(true);
        
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                  //  }
                }
             }
      
       if( SCsToUpdate.size()> 0 ){
            Update SCsToUpdate;

  }  
      SupplyChain_ApprovalComment_Handler.updateSupplyChainComment(SCIds);
      SupplyChainTriggerHandler.updateRepeatMTO(SClist,null,true);
 }
   static testMethod void run2()
    {  
        //List<Supply_Chain__c> SCs = [Select sc.Id, sc.Copy_Approval_Comments__c, sc.Approval_Comments__c, (Select Comments From ProcessSteps where Comments <> '' and Comments <> null) From Supply_Chain__c sc where Status__c = 'Forward to Plant for Shipping Process' limit 20];                     
         List<Supply_Chain__c> SCsToUpdate = new List<Supply_Chain__c>(); //stores records to be updated
        Account acc = new Account();
        acc.Name = 'acc';
        Insert acc;
        // Updated by jasvinder for Case Number 00203178 START
        List<Supply_Chain__c> SClist = new List<Supply_Chain__c>(); 
        Supply_Chain__c scReq = new  Supply_Chain__c(); 
        scReq.Copy_Approval_Comments__c = false;
        scReq.Account__c = acc.Id;
        SClist.add(scReq);
        insert SClist ;
        
          
        set<id> SCIds = new set<id>();
        List<User> submitter = [SELECT FirstName,lastname,Email,id,Isactive FROM User WHERE IsActive = true and email != '' and FirstName!='' and lastname != ''];/*[SELECT Id FROM User WHERE IsActive = true LIMIT 1];*/
             
        if (SClist.size()>0){
            for(Supply_Chain__c sc: SClist){                    
                    sc.Copy_Approval_Comments__c = True;
                    sc.Approval_Comments__c = '';
                    SCsToUpdate.add(sc);
                    SCIds.add(sc.Id);
                    sc.SBU_Group__c ='Canadian Residential';
                    sc.MTO_Type__c ='In-Spec';
                    sc.Pricing_Admin__c =submitter[0].Id;
                    sc.Same_Customer__c = true;
                    sc.Plant_Controller__c =submitter[0].Id;
                    sc.Product_Manager__c =submitter[0].Id;
                   // System.runAs(submitter) {
                      // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    //req1.setComments('Submitting request for approval.');
                    req1.setObjectId(sc.id);
                    // Submit on behalf of a specific submitter
                    //req1.setSubmitterId(user1.Id); 
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('SAMPLE_REQUEST_PROCESS_FOR_APPROVALS');
                    req1.setSkipEntryCriteria(true);
        
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                  //  }
                }
             }
      
       if( SCsToUpdate.size()> 0 ){
            Update SCsToUpdate;

  }  
      SupplyChain_ApprovalComment_Handler.updateSupplyChainComment(SCIds);
      SupplyChainTriggerHandler.updateRepeatMTO(SClist,null,true);
 }
   static testMethod void run3()
    {  
        //List<Supply_Chain__c> SCs = [Select sc.Id, sc.Copy_Approval_Comments__c, sc.Approval_Comments__c, (Select Comments From ProcessSteps where Comments <> '' and Comments <> null) From Supply_Chain__c sc where Status__c = 'Forward to Plant for Shipping Process' limit 20];                     
         List<Supply_Chain__c> SCsToUpdate = new List<Supply_Chain__c>(); //stores records to be updated
        Account acc = new Account();
        acc.Name = 'acc';
        Insert acc;
        // Updated by jasvinder for Case Number 00203178 START
        List<Supply_Chain__c> SClist = new List<Supply_Chain__c>(); 
        Supply_Chain__c scReq = new  Supply_Chain__c(); 
        scReq.Copy_Approval_Comments__c = false;
        scReq.Account__c = acc.Id;
        SClist.add(scReq);
        insert SClist ;
        
          
        set<id> SCIds = new set<id>();
        List<User> submitter = [SELECT FirstName,lastname,Email,id,Isactive FROM User WHERE IsActive = true and email != '' and FirstName!='' and lastname != ''];/*[SELECT Id FROM User WHERE IsActive = true LIMIT 1];*/
             
        if (SClist.size()>0){
            for(Supply_Chain__c sc: SClist){                    
                    sc.Copy_Approval_Comments__c = True;
                    sc.Approval_Comments__c = '';
                    SCsToUpdate.add(sc);
                    SCIds.add(sc.Id);
                    sc.SBU_Group__c ='Canadian Technical';
                    sc.MTO_Type__c ='In-Spec';
                    sc.Pricing_Admin__c =submitter[0].Id;
                    sc.Same_Customer__c = true;
                    sc.Plant_Controller__c =submitter[0].Id;
                    sc.Product_Manager__c =submitter[0].Id;
                   // System.runAs(submitter) {
                      // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    //req1.setComments('Submitting request for approval.');
                    req1.setObjectId(sc.id);
                    // Submit on behalf of a specific submitter
                    //req1.setSubmitterId(user1.Id); 
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('SAMPLE_REQUEST_PROCESS_FOR_APPROVALS');
                    req1.setSkipEntryCriteria(true);
        
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                  //  }
                }
             }
      
       if( SCsToUpdate.size()> 0 ){
            Update SCsToUpdate;

  }  
      SupplyChain_ApprovalComment_Handler.updateSupplyChainComment(SCIds);
      SupplyChainTriggerHandler.updateRepeatMTO(SClist,null,true);
 }
   static testMethod void run4()
    {  
        //List<Supply_Chain__c> SCs = [Select sc.Id, sc.Copy_Approval_Comments__c, sc.Approval_Comments__c, (Select Comments From ProcessSteps where Comments <> '' and Comments <> null) From Supply_Chain__c sc where Status__c = 'Forward to Plant for Shipping Process' limit 20];                     
         List<Supply_Chain__c> SCsToUpdate = new List<Supply_Chain__c>(); //stores records to be updated
        Account acc = new Account();
        acc.Name = 'acc';
        Insert acc;
        // Updated by jasvinder for Case Number 00203178 START
        List<Supply_Chain__c> SClist = new List<Supply_Chain__c>(); 
        Supply_Chain__c scReq = new  Supply_Chain__c(); 
        scReq.Copy_Approval_Comments__c = false;
        scReq.Account__c = acc.Id;
        SClist.add(scReq);
        insert SClist ;
        
          
        set<id> SCIds = new set<id>();
        List<User> submitter = [SELECT FirstName,lastname,Email,id,Isactive FROM User WHERE IsActive = true and email != '' and FirstName!='' and lastname != ''];/*[SELECT Id FROM User WHERE IsActive = true LIMIT 1];*/
             
        if (SClist.size()>0){
            for(Supply_Chain__c sc: SClist){                    
                    sc.Copy_Approval_Comments__c = True;
                    sc.Approval_Comments__c = '';
                    SCsToUpdate.add(sc);
                    SCIds.add(sc.Id);
                    sc.SBU_Group__c ='Duct Wrap';
                    sc.MTO_Type__c ='In-Spec';
                    sc.Pricing_Admin__c =submitter[0].Id;
                    sc.Same_Customer__c = true;
                    sc.Plant_Controller__c =submitter[0].Id;
                    sc.Product_Manager__c =submitter[0].Id;
                   // System.runAs(submitter) {
                      // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    //req1.setComments('Submitting request for approval.');
                    req1.setObjectId(sc.id);
                    // Submit on behalf of a specific submitter
                    //req1.setSubmitterId(user1.Id); 
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('SAMPLE_REQUEST_PROCESS_FOR_APPROVALS');
                    req1.setSkipEntryCriteria(true);
        
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                  //  }
                }
             }
      
       if( SCsToUpdate.size()> 0 ){
            Update SCsToUpdate;

  }  
      SupplyChain_ApprovalComment_Handler.updateSupplyChainComment(SCIds);
      SupplyChainTriggerHandler.updateRepeatMTO(SClist,null,true);
 }
   static testMethod void run5()
    {  
        //List<Supply_Chain__c> SCs = [Select sc.Id, sc.Copy_Approval_Comments__c, sc.Approval_Comments__c, (Select Comments From ProcessSteps where Comments <> '' and Comments <> null) From Supply_Chain__c sc where Status__c = 'Forward to Plant for Shipping Process' limit 20];                     
         List<Supply_Chain__c> SCsToUpdate = new List<Supply_Chain__c>(); //stores records to be updated
        Account acc = new Account();
        acc.Name = 'acc';
        Insert acc;
        // Updated by jasvinder for Case Number 00203178 START
        List<Supply_Chain__c> SClist = new List<Supply_Chain__c>(); 
        Supply_Chain__c scReq = new  Supply_Chain__c(); 
        scReq.Copy_Approval_Comments__c = false;
        scReq.Account__c = acc.Id;
        SClist.add(scReq);
        insert SClist ;
        
          
        set<id> SCIds = new set<id>();
        List<User> submitter = [SELECT FirstName,lastname,Email,id,Isactive FROM User WHERE IsActive = true and email != '' and FirstName!='' and lastname != ''];/*[SELECT Id FROM User WHERE IsActive = true LIMIT 1];*/
             
        if (SClist.size()>0){
            for(Supply_Chain__c sc: SClist){                    
                    sc.Copy_Approval_Comments__c = True;
                    sc.Approval_Comments__c = '';
                    SCsToUpdate.add(sc);
                    SCIds.add(sc.Id);
                    sc.SBU_Group__c ='Loosefill';
                    sc.MTO_Type__c ='In-Spec';
                    sc.Pricing_Admin__c =submitter[0].Id;
                    sc.Same_Customer__c = true;
                    sc.Plant_Controller__c =submitter[0].Id;
                    sc.Product_Manager__c =submitter[0].Id;
                   // System.runAs(submitter) {
                      // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    //req1.setComments('Submitting request for approval.');
                    req1.setObjectId(sc.id);
                    // Submit on behalf of a specific submitter
                    //req1.setSubmitterId(user1.Id); 
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('SAMPLE_REQUEST_PROCESS_FOR_APPROVALS');
                    req1.setSkipEntryCriteria(true);
        
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                  //  }
                }
             }
      
       if( SCsToUpdate.size()> 0 ){
            Update SCsToUpdate;

  }  
      SupplyChain_ApprovalComment_Handler.updateSupplyChainComment(SCIds);
      SupplyChainTriggerHandler.updateRepeatMTO(SClist,null,true);
 }
  static testMethod void run6()
    {  
        //List<Supply_Chain__c> SCs = [Select sc.Id, sc.Copy_Approval_Comments__c, sc.Approval_Comments__c, (Select Comments From ProcessSteps where Comments <> '' and Comments <> null) From Supply_Chain__c sc where Status__c = 'Forward to Plant for Shipping Process' limit 20];                     
         List<Supply_Chain__c> SCsToUpdate = new List<Supply_Chain__c>(); //stores records to be updated
        Account acc = new Account();
        acc.Name = 'acc';
        Insert acc;
        // Updated by jasvinder for Case Number 00203178 START
        List<Supply_Chain__c> SClist = new List<Supply_Chain__c>(); 
        Supply_Chain__c scReq = new  Supply_Chain__c(); 
        scReq.Copy_Approval_Comments__c = false;
        scReq.Account__c = acc.Id;
        SClist.add(scReq);
        insert SClist ;
        
          
        set<id> SCIds = new set<id>();
        List<User> submitter = [SELECT FirstName,lastname,Email,id,Isactive FROM User WHERE IsActive = true and email != '' and FirstName!='' and lastname != ''];/*[SELECT Id FROM User WHERE IsActive = true LIMIT 1];*/
             
        if (SClist.size()>0){
            for(Supply_Chain__c sc: SClist){                    
                    sc.Copy_Approval_Comments__c = True;
                    sc.Approval_Comments__c = '';
                    SCsToUpdate.add(sc);
                    SCIds.add(sc.Id);
                    sc.SBU_Group__c ='MBI';
                    sc.MTO_Type__c ='In-Spec';
                    sc.Pricing_Admin__c =submitter[0].Id;
                    sc.Same_Customer__c = true;
                    sc.Plant_Controller__c =submitter[0].Id;
                    sc.Product_Manager__c =submitter[0].Id;
                   // System.runAs(submitter) {
                      // Create an approval request for the account
                    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
                    //req1.setComments('Submitting request for approval.');
                    req1.setObjectId(sc.id);
                    // Submit on behalf of a specific submitter
                    //req1.setSubmitterId(user1.Id); 
                    // Submit the record to specific process and skip the criteria evaluation
                    req1.setProcessDefinitionNameOrId('SAMPLE_REQUEST_PROCESS_FOR_APPROVALS');
                    req1.setSkipEntryCriteria(true);
        
                    // Submit the approval request for the account
                    Approval.ProcessResult result = Approval.process(req1);
                  //  }
                }
             }
      
       if( SCsToUpdate.size()> 0 ){
            Update SCsToUpdate;

  }  
      SupplyChain_ApprovalComment_Handler.updateSupplyChainComment(SCIds);
      SupplyChainTriggerHandler.updateRepeatMTO(SClist,null,true);
 }
}