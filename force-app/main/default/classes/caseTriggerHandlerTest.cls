/* Kondal # 1/18/2019 # FieldApi has been updated */
@isTest
public class caseTriggerHandlerTest {         
    @testsetup static void createPortalandServiceCases(){
        //List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Case' and isActive=true and (Name = 'Service' OR Name = 'General Call')];  
        Id serviceRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Service').getRecordTypeId();
        Id generalCallRTId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('General Call').getRecordTypeId();
        
        //Map<String,String> rTypMap = new Map<String,String>{};
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User usr = new User();
        usr.Alias = 'standt';
        usr.Email='teststandarduser2@testorg.com';
        usr.EmailEncodingKey='UTF-8';
        usr.LastName='Testing';
        usr.LanguageLocaleKey='en_US';
        usr.LocaleSidKey='en_US';
        usr.ProfileId = p.Id;
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.UserName='teststandarduser2@testorg.com';      
        insert usr;
        
        Plants__c testplant = new Plants__c();
        testplant.Name='testing plant';
        testplant.Plant_Manager__c = usr.id;
        testplant.SAP_Plant__c = '1234567890';
        insert testplant;
        
        //String strRecordTypeId = [Select Id From RecordType Where SobjectType = 'Product2' and Name = 'New Products'].Id;
        Id NewProductsProductRTId = Schema.SObjectType.Product2.getRecordTypeInfosByName().get('New Products').getRecordTypeId();
        Product2 prod = new Product2();       
        prod.Name = 'Test Product';
        prod.ProductCode = '123456';
        prod.Stocking_to_Selling_Conversion_Factor__c = 0.50;
        prod.Sales_Org__c = '1003';
        prod.RecordTypeId = NewProductsProductRTId;
        prod.Owner__c=usr.id;
       prod.Plant_Manager__c = usr.id;
        prod.ApprovingPlant__c =testplant.id;
        insert prod;
                           
        Region__c region = new Region__c ();
        region.Name = 'Test Region';
        region.Regional_Sales_Manager__c = usr.Id;
        region.Pricing_Coordinator__c = usr.Id;
        insert region;
        
        //Generate Territory
        Territory__c terr = new Territory__c();
        terr.Name = 'Test Territory';
        terr.Region__c= region.Id;
        insert terr;
        
        Plants__c whouse = new Plants__c();
        whouse.Name = 'Meridian';
        whouse.SAP_Plant__c = '0813';
        insert whouse;
        
        Plants__c pl = new Plants__c();
        pl.Name='testing Plant';
        pl.SAP_Plant__c = '0123456789';
        pl.Logistics_Coordinator__c = usr.Id;
        pl.Dispatch_Email__c = 'test@test.com';
        insert pl;
        
        Account a = new account();
        a.Name ='Test';
        a.Email__c ='test@cap.com';
        insert a;
        
        //Generate the JDE_Order__c
       // Order order = (Order )SKELETONTestFactory.createSObject(new Order());
        Order order = new Order();
        order.TM__c = usr.Id;
        order.Territory_ref__c= terr.Id;
        order.Sales_Org__c = '1003';
        order.Manufacturing_Plant__c= pl.id;
        order.AccountId = a.id;
        order.EffectiveDate = date.today();
        order.EndDate =date.today()+5;
        order.Status ='ORDER CREATED';
        order.Region_rpg__c = region.Id;
         insert order ;
         
         Invoice__c inv= new Invoice__c();
         inv.Order__c=order.id;
         insert inv;
        
        Account a1 = new account();
        a1.Name ='Test';
        a1.Email__c ='test@cap.com';
        insert a1;
       // Order order1 = (Order)SKELETONTestFactory.createSObject(new Order());
        Order order1 = new Order();
        order1.TM__c = usr.Id;
        order1.Territory_ref__c= terr.Id;
        order1.Sales_Org__c = '1003'; 
        order1.AccountId =a1.Id;
        order1.EffectiveDate = date.today();
        order1.Status ='ORDER CREATED';
        order1.EndDate =date.today()+5;
        order1.Manufacturing_Plant__c = pl.Id;
        order1.Region_rpg__c = region.Id;
          insert order1 ;
          
          Invoice__c inv1= new Invoice__c();
         inv1.Order__c=order1.id;
         insert inv1;
        
        //Create Service Case Assignment RUles
        Service_Case_Assignment_Rule__c scAssignment = new Service_Case_Assignment_Rule__c();
        scAssignment.Issue_Category__c = 'Documentation';
        scAssignment.Issue_Problem__c = 'No Quote Provided';
        scAssignment.Case_Field_API_Name__c = 'RSM__c';
        scAssignment.Plant__c = whouse.id;
        insert scAssignment;
        
        scAssignment = new Service_Case_Assignment_Rule__c();
        scAssignment.Issue_Category__c = 'Documentation';
        scAssignment.Issue_Problem__c = 'Brokerage Fees';
        scAssignment.Manager__c = usr.id;
        scAssignment.Plant__c = whouse.id;
        insert scAssignment;
        
        scAssignment = new Service_Case_Assignment_Rule__c();      
        scAssignment.Issue_Category__c = null;
        scAssignment.Issue_Problem__c = null;
        scAssignment.Manager__c = usr.id;
        scAssignment.Plant__c =  null;
        insert scAssignment;
        /*for(RecordType rt: rtypes){
             rTypMap.put(rt.Name,rt.Id);
        }*/
        
        List<Case> lstCases = new List<Case>();  
        Case objCase;
        for(Integer i = 0 ; i<15 ; i++) {
            objCase = new Case();
            if(i>10){
                objCase.Issue_Category__c = 'Documentation';
                objCase.Issue_Problem__c = 'No Quote Provided';
                //objCase.Order__c = order.id;
                objCase.Invoice__c=inv.id;
                //if(rTypMap.containsKey('Service')){
                   objCase.RecordTypeId = serviceRTId; //rTypMap.get('Service'); 
                //}
            }
            else if(i==10){
                objCase.Issue_Category__c = 'Documentation';
                objCase.Issue_Problem__c = 'Brokerage Fees';
                //objCase.Order__c = order.id;
                 objCase.Invoice__c=inv.id;
            }
            else if(i==9){
                objCase.Issue_Category__c = 'Documentation';
                objCase.Issue_Problem__c = 'Brokerage Fees';
                objCase.Order__c = order1.id;
                 objCase.Invoice__c=inv1.id;
            }
            else if(i==8){
                objCase.Issue_Category__c = 'Documentation';
                objCase.Issue_Problem__c = 'Brokerage Fees';
                //if(rTypMap.containsKey('General Call')){
                   objCase.RecordTypeId = generalCallRTId; //rTypMap.get('General Call');
                //}               
            }
            else{
                
               //objCase.RecordTypeId = rTypMap.get('Portal');    
                objCase.PortalCaseId__c = 'TestPortalCaseId' + i;
            }
            objCase.Category__c = 'test';
            objCase.Sub_Category__c = 'test';
            objCase.Comments__c = 'test';
            
            objCase.Campaign__c = 'MECH';
            objCase.Type = 'General Call';
            
            
            objCase.Subject = 'Test Subject' + i;
            objCase.Description = 'Test Description' + i;
            objCase.Status = 'Success';
            if(i==2){
                objCase.Documents__c= '';     
            }
            else if(i==3){
                objCase.Documents__c= 'https://cer-d-www.ms.ycs.io/medias/SFDC2.txt';     
            }
            else if(i==4){
                objCase.Documents__c= 'Test';      
            }
            else{
                objCase.Documents__c= 'https://cer-d-www.ms.ycs.io/medias/SFDC2.txt?context=bWFzdGVyfHJvb3R8MzV8dGV4dC9wbGFpbnxoOWIvaDliLzg4MTk0OTMxNzUzMjYudHh0fDQ0NDA4YjZiMjY4NTZlODlkOTAzOGE3OWEzYjkwMjMwYTEwMGJiNDVlMmRjOGNkOTVhNmQyNDVkYTFmNWQyNGU';         
            }
            
            lstCases.add(objCase);
        } 
        if(lstCases.size() > 0){
          insert lstCases;  
        }      
    }     
    public static testMethod void testCaseTrigger(){
        List<Case> lstCases = [SELECT ID,RecordTypeId,PortalCaseId__c,Subject,Description,Status,Documents__c,Manufacturing_Plant__c FROM Case LIMIT 5];
        List<Case> updlstCases = new List<Case>();
         Test.startTest(); 
         for(Case objCase : lstCases){
             objCase.Documents__c= 'https://cer-d-www.ms.ycs.io1/medias/SFDC2.txt?context=bWFzdGVyfHJvb3R8MzV8dGV4dC9wbGFpbnxoOWIvaDliLzg4MTk0OTMxNzUzMjYudHh0fDQ0NDA4YjZiMjY4NTZlODlkOTAzOGE3OWEzYjkwMjMwYTEwMGJiNDVlMmRjOGNkOTVhNmQyNDVkYTFmNWQyNGU,https://cer-d-www.ms.ycs.io2/medias/SFDC2.txt?context=bWFzdGVyfHJvb3R8MzV8dGV4dC9wbGFpbnxoOWIvaDliLzg4MTk0OTMxNzUzMjYudHh0fDQ0NDA4YjZiMjY4NTZlODlkOTAzOGE3OWEzYjkwMjMwYTEwMGJiNDVlMmRjOGNkOTVhNmQyNDVkYTFmNWQyNGU';     
             updlstCases.add(objCase);
         }        
         Database.update( updlstCases, false);
         Test.stopTest();        
    }
    
    public static testMethod void testCaseTriggerHandler_rpg(){
        Id customerMasterRequestId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('Customer Master Request').getRecordTypeId();
        List<Case> lstCases = [SELECT ID,RecordTypeId,PortalCaseId__c,Subject,Description,Status,Documents__c,Manufacturing_Plant__c FROM Case LIMIT 5];
        List<Case> updlstCases = new List<Case>();
        
        Order orderRecord = [SELECT Id FROM Order LIMIT 1];
        
        Test.startTest(); 
        
        for(Case objCase : lstCases){
             objCase.Documents__c= 'https://cer-d-www.ms.ycs.io1/medias/SFDC2.txt?context=bWFzdGVyfHJvb3R8MzV8dGV4dC9wbGFpbnxoOWIvaDliLzg4MTk0OTMxNzUzMjYudHh0fDQ0NDA4YjZiMjY4NTZlODlkOTAzOGE3OWEzYjkwMjMwYTEwMGJiNDVlMmRjOGNkOTVhNmQyNDVkYTFmNWQyNGU,https://cer-d-www.ms.ycs.io2/medias/SFDC2.txt?context=bWFzdGVyfHJvb3R8MzV8dGV4dC9wbGFpbnxoOWIvaDliLzg4MTk0OTMxNzUzMjYudHh0fDQ0NDA4YjZiMjY4NTZlODlkOTAzOGE3OWEzYjkwMjMwYTEwMGJiNDVlMmRjOGNkOTVhNmQyNDVkYTFmNWQyNGU';     
             objCase.Sales_Org__c = '1102';
             objCase.RecordTypeId = customerMasterRequestId; 
             objCase.Order__c = orderRecord.Id;
             updlstCases.add(objCase);
         } 
         Database.update(updlstCases, false);
         
         Case objCase = new Case();
         objCase.Issue_Category__c = 'Documentation';
         objCase.Issue_Problem__c = 'No Quote Provided';
         objCase.Documents__c= 'https://cer-d-www.ms.ycs.io1/medias/SFDC2.txt?context=bWFzdGVyfHJvb3R8MzV8dGV4dC9wbGFpbnxoOWIvaDliLzg4MTk0OTMxNzUzMjYudHh0fDQ0NDA4YjZiMjY4NTZlODlkOTAzOGE3OWEzYjkwMjMwYTEwMGJiNDVlMmRjOGNkOTVhNmQyNDVkYTFmNWQyNGU,https://cer-d-www.ms.ycs.io2/medias/SFDC2.txt?context=bWFzdGVyfHJvb3R8MzV8dGV4dC9wbGFpbnxoOWIvaDliLzg4MTk0OTMxNzUzMjYudHh0fDQ0NDA4YjZiMjY4NTZlODlkOTAzOGE3OWEzYjkwMjMwYTEwMGJiNDVlMmRjOGNkOTVhNmQyNDVkYTFmNWQyNGU';     
         objCase.Sales_Org__c = '1102';
         objCase.RecordTypeId = customerMasterRequestId; 
         objCase.Order__c = orderRecord.Id;
         Insert objCase;
         
         Test.stopTest(); 
    }
    
}