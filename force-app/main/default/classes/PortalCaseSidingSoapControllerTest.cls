@isTest (SeeAllData = false)
public class PortalCaseSidingSoapControllerTest{

        public static testMethod void testgetPortalCases1(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Integration User'];
        
        User u1 = new User(Alias = 'standt3',Country='United State',Email='demo3@randomdemodomain.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo3@camfed.org');
        insert u1;
        
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Case' and isActive=true];       
        Map<String,String> rTypMap = new Map<String,String>{};
        
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }      
          
        Contact conObj = new Contact(FirstName='test',LastName='TestLast',Phone='12345',Email='test@test.com',MailingCity='TestCity',MailingState = 'CA', MailingStreet = 'Mailing Street');
        insert conObj; 
               
        Account acc = new Account(Name='ABC 045-ORLANDO,FL',SAP_ACCOUNT__c='1001774', AccountNumber='1001774');
        insert acc;
        
        Account acc1 = new Account(Name='SRS DISTRIBUTION, INC',SAP_ACCOUNT__c='3001201', AccountNumber='3001201');
        insert acc1;
        
        //Account acc2 = new Account(Name='CERTAINTEED WARRANTY CLAIMS',Account_Number__c='1006403', AccountNumber='1006403');
        //insert acc2;
             
        Plants__c ware1 = new Plants__c();
        ware1.name='Hagerstown';
        ware1.SAP_Plant__c='0402';
        ware1.Maximum_LTL_Orders_Per_Day_Rep__c=12.00;
        ware1.Maximum_LTL_Orders_Per_day_Lead__c=1.00;
        ware1.Maximum_LTL_Weight_Per_Day_Rep__c=1.00;
        //ware1.CurrencyIsoCode='';
        ware1.Lead_Time_Days__c=1.00;
        ware1.Maximum_LTL_Weight_Per_Day_Lead__c=1.00;
        ware1.Maximum_Slots_Per_Day__c=1.00;
        
        insert ware1;
              
       
        Order orObj = new Order();
        orObj.Sold_To__c=acc1.id;
        //orObj.Ship_To_No__c=acc.Account_Number__c;
        //orObj.Bill_To_No__c=acc.Account_Number__c;
        orObj.PONumber='01489828';
        orObj.Order_Num__c='Test';
        orObj.Plant__c = ware1.id;
        orObj.AccountId = acc.Id;
        orObj.Status = 'CREDIT HOLD';
        orObj.EffectiveDate = System.today();
        insert orObj;
        
        Case cObj = new Case(RecordTypeId=rTypMap.get('Portal'),Order__c= orObj.id,ContactId=conObj.id);
        cObj.PortalCaseId__c = 'TestPortalCaseId';
        cObj.SuppliedName= 'Testname';
        cObj.SuppliedEmail= 'abc@cde.com';
        cObj.SuppliedPhone= '(999) 924-5712';
        //cObj.Resolution__c= 'General Case';
        cObj.Type= 'Order Change';
        cObj.Subject= 'Test Soap';               
        cObj.Description= 'test Sucessfull';        
        cObj.Order_Line_Items__c = 'Test Comment 1';
        cObj.Documents__c= 'http://certainteedcustomerportal/maptest'; 
        cObj.Order__c= orObj.id;    
        cObj.Status = 'Sucess';
        cObj.Location__c =orObj.Plant__c;
        //cObj.OwnerId='test';
        cObj.Origin='Portal';
        cObj.Priority='Medium';
        cObj.Invoice_Number__c='2345';
        //cObj.Account='testAccount';
          
        insert cObj;
        
               
        CaseComment obj_Comments = new CaseComment();
        obj_Comments.IsPublished = true;
        obj_Comments.CommentBody='Test';
        obj_Comments.ParentId = cObj.id;
        insert obj_Comments;
              

      System.runAs(u1){
       
        Test.startTest();
        PortalCaseSidingSoapController.getPortalCases();
        Test.stopTest();
     }     
}

}