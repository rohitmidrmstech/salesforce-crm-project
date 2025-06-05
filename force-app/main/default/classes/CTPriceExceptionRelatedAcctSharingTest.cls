/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* Test class for CT_PriceExceptionRelatedAcctSharingCtrl lightning component. 
* ─────────────────────────────────────────────────────────────────────────────────────────────────
* @author	    Raja Jaswani
* @created		2020-02-10
*/
 @isTest       
public class CTPriceExceptionRelatedAcctSharingTest {
   @TestSetup 
    static void testSetup (){ 
        Account acc = new account(name='Test Account');
        insert acc;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User usr = new User(Alias = 'newUser1', Email='newuser@testorg.com',
                            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                            LocaleSidKey='en_US', ProfileId = p.Id,
                            TimeZoneSidKey='America/Los_Angeles', UserName='newuser345345@testorg.com'); 
        insert usr;
        Contact con = new contact(lastname='Test contact');
        Con.MailingCountry='ggg';
        Con.MailingStreet = 'Test1';
        Con.MailingCity = 'Newyork';
        Con.MailingState = 'rajasthan';
        Con.otherphone='12345';
        Con.MailingPostalCode = '987654321a';
        Con.Phone = '1234567890';
        insert con;        
        case caseObj = new case(AccountId=acc.id,ContactId=con.id,Campaign__c='MECH',Type = 'General Call');
        insert caseObj; 
        
        CaseShare CaseObjShare = new CaseShare(CaseId =caseObj.id,UserOrGroupId=usr.id,CaseAccessLevel='Read');
        insert CaseObjShare;
     
       
    }
    
    
    static testmethod void Test(){ 
        test.startTest();
        user uObj = [select id from user limit 1];
        case csObj = [select id from case limit 1];
        list<account>listOfAccount = new list<account>();
        list<CaseShare>listOfCaseShare = new list<CaseShare>();
        listOfAccount = [select id, name,OwnerId from account limit 1];
        listOfCaseShare =[SELECT Id, CaseId, CaseAccessLevel FROM CaseShare];
        /*CT_PriceExceptionRelatedAcctSharingCtrl CtObj = new CT_PriceExceptionRelatedAcctSharingCtrl();
        CtObj.manualShareRead(csObj.id, listOfAccount); 
        CT_PriceExceptionRelatedAcctSharingCtrl.createReadManualShare(JSON.serialize(listOfCaseShare));*/
        test.stopTest();
       
    }
    
}