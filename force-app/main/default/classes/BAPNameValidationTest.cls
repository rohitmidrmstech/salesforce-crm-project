@isTest
private class BAPNameValidationTest {
    @testSetup static void dataMethod(){
        
        Account accountRecord = new Account();
        accountRecord.Name = 'TestAccount';
        insert accountRecord;

        Account accountRecord1 = new Account();
        accountRecord1.Name = 'Test Account1';
        insert accountRecord1;
        
        Account accountRecord2 = new Account();
        accountRecord2.Name = 'Test Account2';
        insert accountRecord2; 
        
        Insert new SEP__c(Name ='Test1',Account__c = accountRecord2.id,Year__c = '2020');
    }
    
    @isTest static void bAPNameValidationMethod(){
        List<SEP__c> sepRecordList = new List<SEP__c>();
        List<Account> accountRecordList = [SELECT id From Account limit 1 ];
        sepRecordList = [SELECT ID , Account__c, Name, Year__c From Sep__c limit 1];
        system.debug('@@@sepRecordList'+accountRecordList);
        List<SEP__c> sepRecordList1 = new List<SEP__c>();
        sepRecordList1.add(sepRecordList[0]);
        sepRecordList1.add(new SEP__c(Name ='Test2',Account__c = accountRecordList[0].id,Year__c = '2020'));
        upsert sepRecordList1;
        try{
             Insert new SEP__c(Name ='Test2',Account__c = accountRecordList[0].id,Year__c = '2020');
        }catch(Exception ex){
            
        }
       
       /* List<SEP__c> sepRecordList = new List<SEP__c>();
        sepRecordList.add(new SEP__c(Name ='Test1',Account__c = accountRecord.id,Year__c = '2020')); 
       // sepRecordList.add(new SEP__c(Name ='Test2',Account__c = accountRecord1.id,Year__c = '2020'));
       //sepRecordList.add(new SEP__c(Name ='Test1',Account__c = accountRecord.id,Year__c = '2020'));
        Insert sepRecordList; 
        Insert new SEP__c(Name ='Test1',Account__c = accountRecord2.id,Year__c = '2020');
       //  sepList = [Select Id, Year__c, Account__c, Name From SEP__c Where Account__c in :sepAcIds and Year__c in :sepYears AND Id NOT IN: sepRecordList[0].id
        /*system.debug('@@@@sepRecordList@@'+sepRecordList);
        sepRecordList[0].Name = 'Test3';
        sepRecordList[0].Year__c = '2021';
        sepRecordList[0].Account__c = accountRecord2.id;
        sepRecordList[1].Name = 'Test4';
       // sepRecordList[1].Year__c = '2022';
       // sepRecordList[1].Account__c = accountRecord2.id;
        update sepRecordList;*/
        /* sepRecordList.add(new SEP__c(Name ='Test3',Account__c = accountRecord.id,Year__c = '2020'));
upsert sepRecordList;
sepRecordList[0].Year__c = '2021';
update sepRecordList;*/
        //system.debug('@@@@update sepRecordList@@@@'+sepRecordList);
    }

}