@isTest
public class Contract_Approval_Comment_HandlerTest {
    
    @isTest(seealldata = true)
    private static void testMethod1(){
        Profile p = [select id from Profile where profile.name='System Administrator' limit 1];
        // Create common test accounts
        User user12 = new User(ProfileId = p.Id,LastName = 'Test', FirstName = 'Test' ,Username ='test7778@gmail.com', Alias='test',Email='test7778@gmail.com', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        Insert user12;
       User user22 = new User( ProfileId = p.Id,LastName = 'Test2',IsActive = true, FirstName = 'Test2', Username ='test27778@gmail.com', Alias='test',Email='test27778@gmail.com', TimeZoneSidKey='America/Los_Angeles', LocaleSidKey='en_US', EmailEncodingKey='UTF-8', LanguageLocaleKey='en_US');
        Insert user22;  
        User user1 = [Select Id,FirstName,Username,Email from User Where Email='test7778@gmail.com' Limit 1];
        User user2 = [Select Id,Managerid,FirstName,Username,Email from User where profileId IN (SELECT id FROM Profile WHERE Name = 'System Administrator') AND isActive = TRUE AND Email='test27778@gmail.com'  LIMIT 1];
        
        List<Account> accountsList = new List<Account>();
        Account accRec = new Account(Name = 'test Acc'); 
        //accRec.Coporate_Account__c = '147852';
        accountsList.add(accRec);
        insert accountsList;
        //=========================================
        Contract contractRec = new Contract(Status = 'Draft', Copy_Approval_Comments__c = true, AccountId = accountsList[0].Id, Estimated_Turns_per_Month__c = '3',Traffic_Contact__c = user2.Id,Salesperson__c = user1.Id, ownerid=user1.id);
        System.runAs(user1) {Insert contractRec;}
        //=========================================
        //Step 1:  Instantiate the new ProcessWorkitemRequest object and populate it
        Approval.ProcessWorkitemRequest req1 =  new Approval.ProcessWorkitemRequest();
        req1.setComments('Approving request.');
        req1.setAction('Approve');
        
        //Step 2 : To check the next process after approval being submitted/approved etc.(basically next stage)  
        /*
        ProcessInstanceWorkitem pItem = [Select Id from ProcessInstanceWorkitem  where ProcessInstance.TargetObjectId =: contractRec.id];
        
        // Use the ID from the newly created item to specify the item to be worked
        req1.setWorkitemId(pItem.Id);
        
        //Step 3 : result of process
        Approval.ProcessResult result1 = Approval.process(req1);
        */
        //=========================================
                
    }
}