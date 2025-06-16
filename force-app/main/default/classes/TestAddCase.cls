/**************************************************************************************************
* Controller Class: AddCase
* Created by Yogesh Kumar, Navivo Technology Solution, DateCreated: 29/10/2014
---------------------------------------------------------------------------------------------------
* Purpose/Methods:
* - Auto create new case 
---------------------------------------------------------------------------------------------------
* Unit Test: TestAddCase
---------------------------------------------------------------------------------------------------
* History:
* - VERSION  DEVELOPER NAME             DATE            DETAIL  FEATURES
    1.0      Yogesh Kumar             29/10/2014        INITIAL DEVELOPMENT
**************************************************************************************************/
@isTest
private class TestAddCase {

    public static TestMethod void unitTest1(){
        Decimal Amount = 10;
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Case' and isActive=true];
        List<RecordType> acccountRtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        try{
            Account acc = new Account(Name = 'TestAcc',RecordTypeId = acccountRtypes[0].Id, Status__c ='Active', SAP_ACCOUNT__c = '123456');
            insert acc;
            
            Contact conObj = new Contact(LastName='TestLast', AccountId = acc.Id);
            insert conObj;
            
            Order  orObj = new Order  (Ship_To__c = acc.id, BPCS_Order__c = '12345', AccountId = acc.id, Status = 'ORDER CREATED', EffectiveDate = System.today());
            insert orObj;
            
            Plants__c wObj = new Plants__c(Name='11',SAP_Plant__c = 'Test12');
            insert wObj;
            
            Case cObj = new Case(RecordTypeId=rTypMap.get('Credit Request'), AccountId = acc.Id, Location__c = wObj.Id, Reason = 'Product Quality', Credit_Amount__c = Amount, Status = 'In Progress', Origin = 'Email');
            insert cObj;
            
            ApexPages.currentPage().getParameters().put('on',orObj.BPCS_Order__c);
            ApexPages.currentPage().getParameters().put('cpo','2');
            ApexPages.currentPage().getParameters().put('ot','C');
            ApexPages.currentPage().getParameters().put('sti','123456');
            ApexPages.currentPage().getParameters().put('wh',wObj.SAP_Plant__c);
            ApexPages.currentPage().getParameters().put('tot','10');
            
            AddCase addCaseObj = new AddCase();
            addCaseObj.saveCaseRec();
        }
        catch(Exception ex){
            system.debug(ex.getMessage());
        }
    }
     public static TestMethod void unitTest2(){
        Decimal Amount = 10;
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Case' and isActive=true];
        List<RecordType> acccountRtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name = 'TestAcc',RecordTypeId = acccountRtypes[0].Id, Status__c ='Active', SAP_ACCOUNT__c = '123456');
        insert acc;
        
        Contact conObj = new Contact(LastName='TestLast', AccountId = acc.Id);
        insert conObj;
        
        Order  orObj = new Order  (Ship_To__c = acc.id, BPCS_Order__c = '12345', AccountId = acc.id, Status = 'ORDER CREATED', EffectiveDate = System.today());
        insert orObj;
        
        Plants__c wObj = new Plants__c(Name='11',SAP_Plant__c = 'Test12');
        insert wObj;
         
         Invoice__c Inv = new Invoice__c();
        Inv.Name = 'dsds33';
        Inv.Order__c = orObj.id;
        //Inv.CurrencyIsoCode = 'USD';
        Inv.Ship_To_Lookup__c = acc.id;
        Inv.Billing_Date__c =Date.Today();
        Inv.Invoice_Number__c = 'dsds33';
        insert Inv;
        
        Case cObj = new Case(RecordTypeId=rTypMap.get('RMA'), Invoice__c = Inv.Id, AccountId = acc.Id, Location__c = wObj.Id, Reason = 'Product Quality', Credit_Amount__c = Amount, Status = 'In Progress', Origin = 'Email');
        insert cObj;
        
        ApexPages.currentPage().getParameters().put('on',orObj.BPCS_Order__c);
        ApexPages.currentPage().getParameters().put('cpo','2');
        ApexPages.currentPage().getParameters().put('ot','R');
        ApexPages.currentPage().getParameters().put('sti','123456');
        ApexPages.currentPage().getParameters().put('wh',wObj.SAP_Plant__c);
        ApexPages.currentPage().getParameters().put('tot','10');
        
        AddCase addCaseObj = new AddCase();
        addCaseObj.saveCaseRec();
        addCaseObj.unEscapeUrl('');
    }
     public static TestMethod void unitTest3(){
        Decimal Amount = 10;
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Case' and isActive=true];
        List<RecordType> acccountRtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name = 'TestAcc',RecordTypeId = acccountRtypes[0].Id, Status__c ='Active', SAP_ACCOUNT__c = '123456');
        insert acc;
        
        Contact conObj = new Contact(LastName='TestLast', AccountId = acc.Id);
        insert conObj;
        
        Order  orObj = new Order  (Ship_To__c = acc.id, BPCS_Order__c = '12345', AccountId = acc.id, Status = 'ORDER CREATED', EffectiveDate = System.today());
        insert orObj;
        
        Plants__c wObj = new Plants__c(Name='11',SAP_Plant__c = 'Test12');
        insert wObj;
        
         
         Invoice__c Inv = new Invoice__c();
        Inv.Name = 'dsds33';
        Inv.Order__c = orObj.id;
        //Inv.CurrencyIsoCode = 'USD';
        Inv.Ship_To_Lookup__c = acc.id;
        Inv.Billing_Date__c =Date.Today();
        Inv.Invoice_Number__c = 'dsds33';
        insert Inv;
         
        Case cObj = new Case(RecordTypeId=rTypMap.get('RMA'), Invoice__c = Inv.Id, AccountId = acc.Id, Location__c = wObj.Id, Reason = 'Product Quality', Credit_Amount__c = Amount, Status = 'In Progress', Origin = 'Email');
        insert cObj;
        
        AddCase addCaseObj = new AddCase();
    }
     public static TestMethod void unitTest4(){
         Decimal Amount = 10;
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='Case' and isActive=true];
        List<RecordType> acccountRtypes = [Select Name, Id From RecordType where sObjectType='Account' and isActive=true];
        Map<String,String> rTypMap = new Map<String,String>{};
        for(RecordType rt: rtypes){
           rTypMap.put(rt.Name,rt.Id);
        }  
        
        Account acc = new Account(Name = 'TestAcc',RecordTypeId = acccountRtypes[0].Id, Status__c ='Active', SAP_ACCOUNT__c = '123456');
        insert acc;
        
        Contact conObj = new Contact(LastName='TestLast', AccountId = acc.Id);
        insert conObj;
        
        Order  orObj = new Order  (Ship_To__c = acc.id, BPCS_Order__c = '12345', AccountId = acc.id, Status = 'ORDER CREATED', EffectiveDate = System.today());
        //insert orObj;
        
        Plants__c wObj = new Plants__c(Name='11',SAP_Plant__c = 'Test12');
        insert wObj;
         
         Invoice__c Inv = new Invoice__c();
        Inv.Name = 'dsds33';
        Inv.Order__c = orObj.id;
        //Inv.CurrencyIsoCode = 'USD';
        Inv.Ship_To_Lookup__c = acc.id;
        Inv.Billing_Date__c =Date.Today();
        Inv.Invoice_Number__c = 'dsds33';
        //insert Inv;
        
        Case cObj = new Case(RecordTypeId=rTypMap.get('RMA'), Invoice__c = Inv.Id, AccountId = acc.Id, Location__c = wObj.Id, Reason = 'Product Quality', Credit_Amount__c = Amount, Status = 'In Progress', Origin = 'Email');
        insert cObj;
        
        ApexPages.currentPage().getParameters().put('on',orObj.BPCS_Order__c);
        ApexPages.currentPage().getParameters().put('cpo','2');
        ApexPages.currentPage().getParameters().put('ot','R');
        ApexPages.currentPage().getParameters().put('sti','123456');
        ApexPages.currentPage().getParameters().put('wh',wObj.SAP_Plant__c);
        ApexPages.currentPage().getParameters().put('tot','10');
        
        AddCase addCaseObj = new AddCase();
        addCaseObj.saveCaseRec();
        addCaseObj.unEscapeUrl('');
     }

}