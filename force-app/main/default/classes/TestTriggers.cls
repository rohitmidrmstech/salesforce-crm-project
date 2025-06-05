//   Object: TestTriggers
//  Company: SalesOptimizer
//   Author: Nagendra 
// Comments: This test class covered the code of Bap and Gaol Triggers.
// ==================================================================================
//  Changes: 2012-07-25 Initial version.
// ==================================================================================

@isTest (seeAllData=true)
private class TestTriggers 
{    
    //Method for Bap Trigger
    static testMethod void myUnitTestBap() 
    {
        List<RecordType> rtList = [Select Id,Name From RecordType Where SObjectType='Account'];
        Map<String,Id> rtMap = new Map<String,Id>();
        
        for(RecordType rt : rtList)
            rtMap.put(rt.Name,rt.Id);
        
        //Creating an Account For BAP.    
        Account acc = new Account(Name='Test',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc;
        
        //Creating an Account For BAP.    
        Account acc1 = new Account(Name='Test 1',Status__c= 'Active', Account_Type__c='Prospect',RecordTypeId=rtMap.get('New Prospect, Target, Customer'),Information_Date__c=system.today()); 
        insert acc1;
        
        //Creating BAP Record                                                                                   //date.valueOf(sep1.Year__c + '-1-1 00:00:00');
        SEP__c sep = new SEP__c(Account__c=acc.Id,Year__c='2012',Stage__c='Completed',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep;   
        
        SEP__c sep1 = new SEP__c(Account__c=acc.Id,Year__c='2013',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep1;
        
        SEP__c sep2 = new SEP__c(Account__c=acc1.Id,Year__c='2014',Stage__c='Planning',Start_Date__c=system.today(),End_Date__c=system.today().addDays(1));
        insert sep2; 
        
        //Bap Goals :-
        SEP_Goal__c goal1 = new SEP_Goal__c(Name='Goal 1', Goal_Number__c='1', Start_Date__c=System.today(),End_Date__c=system.today().addDays(1),SEP__c=sep.Id,Stage__c='Planning',Priority__c='B1',Strategy__c='Goal1');
        insert goal1;
        delete goal1;
    }

}