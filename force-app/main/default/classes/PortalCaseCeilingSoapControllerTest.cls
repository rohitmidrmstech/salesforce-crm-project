/* Kondal # 1/18/2019 # FieldApi has been updated */

@isTest (SeeAllData = false)
public class PortalCaseCeilingSoapControllerTest{

        public static testMethod void testgetPortalCases1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Integration User'];
        
        User userObj = new User(Alias = 'standt3',Country='United State',Email='demo3@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo3@camfed.org');
        INSERT userObj;
        
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Case' and isActive=true];       
        Map<String,String> rTypMap = new Map<String,String>{};
        
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }      
          
        Contact conObj = new Contact(FirstName='test',LastName='TestLast',Phone='12345',Email='test@test.com',MailingCity='TestCity',MailingState = 'CA', MailingStreet = 'Mailing Street',MailingPostalCode ='119199',MailingCountry ='US');
        INSERT conObj; 
               
        Account accObj = new Account(Name='Test Account',LOB__c='1003',JDE_Customer_Number__c='345345',RecordTypeId = SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());    //Modified by Purnima for Story S-562343;
        INSERT accObj;        
             
        Plants__c ware = new Plants__c();
        ware.name='Hagerstown';
        ware.SAP_Plant__c='0402';
        ware.Maximum_LTL_Orders_Per_Day_Rep__c=12.00;
        ware.Maximum_LTL_Orders_Per_day_Lead__c=1.00;
        ware.Maximum_LTL_Weight_Per_Day_Rep__c=1.00;
        ware.Maximum_LTL_Weight_Per_Day_Lead__c=1.00;
        ware.Maximum_Slots_Per_Day__c=1.00;        
        INSERT ware;
        
        Region__c region = new Region__c ();
        region.Name = 'Test Region';
        region.Regional_Sales_Manager__c = userObj.Id;
        INSERT region;
                
        Territory__c terr = new Territory__c();
        terr.Name = 'Test Territory';
        terr.Region__c = region.Id;
        INSERT terr;
        
        Order ord = new Order();
        ord.status='shipped';
        ord.Accountid=accObj.id;
        ord.EffectiveDate=system.today();
        Insert ord;
        
        Invoice__c Inv = new Invoice__c();
        Inv.name='testing invoice';
        inv.Order__c= ord.id;
        Insert Inv;
        
         Plants__c objplant= new Plants__c();
         objplant.Name='testing';
        objplant.SAP_Plant__c = 'TW';
         insert objplant;
        system.debug('@@@@'+objplant);
       
        Order orObj = new Order();
        orObj.Name='TestOrder';
        orObj.TM__c = userObj.Id;
        orObj.Accountid=accObj.id;
        orObj.Sold_To__c = accObj.id;
        orObj.Ship_To__c = accObj.id;
        orObj.Territory_ref__c= terr.Id;        
        orObj.Manufacturing_Plant__c= objplant.id;
        orObj.PONumber = '1260001';
        orObj.EffectiveDate =date.today();
         orObj.Status ='ORDER CREATED';
        orObj.Invoice__c = Inv.id;
        orObj.Order_Num__c = '607034';
        INSERT orObj;
        
        Case cObj = new Case(RecordTypeId=rTypMap.get('Portal'), ContactId=conObj.id);
        cObj.PortalCaseId__c = 'TestPortalCaseId';        
        cObj.SuppliedName= 'Testname';
        cObj.SuppliedEmail= 'abc@cde.com';
        cObj.SuppliedPhone= '(999) 924-5712';       
        cObj.Type= 'Order Change';
        cObj.Subject= 'Test Soap';               
        cObj.Description= 'test Sucessfull';        
        cObj.Order_Line_Items__c = 'Test Comment 1';
        cObj.Documents__c= 'http://certainteedcustomerportal/maptest'; 
        //cObj.Order__c = orObj.id;    
        cObj.Status = 'Success';
        cObj.Origin='Portal';
        cObj.Priority='Medium';          
        INSERT cObj;
        
        list <CaseComment> listComment = new list <CaseComment>();       
        CaseComment comment = new CaseComment();
        comment.IsPublished = true;
        comment.CommentBody='Test';
        comment.ParentId = cObj.id;
        listComment.add(comment);
            
        CaseComment comment1 = new CaseComment();
        comment1.IsPublished = true;
        comment1.CommentBody='Test1';
        comment1.ParentId = cObj.id;
        listComment.add(comment1);    
        INSERT listComment;

        System.runAs(userObj){       
           Test.startTest();        
           PortalCaseCeilingSoapController.getPortalCases();        
           Test.stopTest();
        }     
    }
    
}