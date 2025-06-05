@isTest
public class GetListOfLeadsForCommHomeTest {
    static testmethod void testAcceptLead(){
        Lead leadObj = new Lead();
        leadObj.lastName = 'Test Lead';
        leadObj.company = 'Test';
        leadObj.Status = 'Open - Not Contacted';
        leadObj.phone = 'phone';
       
        leadObj.Fax = '7897893933';
        insert leadObj;
        Test.startTest();
        String str = GetListOfLeadsForCommHome.acceptLead(leadObj.Id);
        Test.stopTest();
        system.assertEquals(str, 'Success');
    }
    static testmethod void testGetLeadList(){
        Group g1 = new Group(Name='Community Queue', type='Queue');
        insert g1;
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');
        insert q1;
        UserRole userrole = [Select Id, DeveloperName From UserRole Where DeveloperName = 'CRM_Administrator' Limit 1];
        Id profileId = [Select Id From Profile Where Name ='System Administrator'].Id;
        User u = createUser(userrole.Id,profileId,'Sudarshana','Dey');
        User usr;
        System.runAs( u ){
            Id profileId1 = [Select Id From Profile Where Name ='Partner Community Contractor User'].Id;
            Account acc = createAccount('Test Account');
            insert acc;
            Contact con = createContact('test','Contact','test@gmail.com',acc.Id);
            insert con;
            usr = createCommunityUser(con.Id,profileId1,'Amit','Singh');
            Lead leadObj = new Lead();
            leadObj.lastName = 'Test Lead';
            leadObj.company = 'Test';
            leadObj.Status = 'Open - Not Contacted';
            leadObj.phone = 'phone';       
            leadObj.Fax = '7897893933';
            insert leadObj;
            leadObj.OwnerId = q1.QueueId;
            leadObj.Community_User__c = usr.Id;
            update leadObj;
        }
        List<Lead> ldList = new List<Lead>();
        System.runAs( usr ){
            Test.startTest();
            ldList = GetListOfLeadsForCommHome.getLeadList();
            Test.stopTest();
        }
    }
    
    public static User createUser(String roleId, String profId, String firstName, String lastName){
        User tempUser = prepareUser(roleId, profId, firstName, lastName);
        return tempUser;
    }

    private static User prepareUser(String roleId, String profId, String firstName, String lastName) {  

        String orgId = UserInfo.getOrganizationId();  
        String dateString =   
        String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt;  
        User tempUser = new User(  
            FirstName = firstName,  
            LastName = lastName,  
            email = uniqueName + '@sfdc' + orgId + '.org',  
            Username = uniqueName + '@sfdc' + orgId + '.org',  
            EmailEncodingKey = 'ISO-8859-1',  
            Alias = uniqueName.substring(18, 23),  
            TimeZoneSidKey = 'America/Los_Angeles',  
            LocaleSidKey = 'en_US',  
            LanguageLocaleKey = 'en_US',  
            ProfileId = profId
        );    
        if( String.isBlank(roleId) == false ){
            tempUser.UserRoleId = roleId;
        }
        return tempUser;  
    }

    public static User createCommunityUser(String contactId, String profId, String firstName, String lastName) {
        User tempUser = prepareUser('', profId, firstName, lastName);
        tempUser.ContactId = contactId;
        return tempUser;
    }

    public static Account createAccount(String Name){
        Account portalAccount = new Account(name = Name );
        return portalAccount;
    }
    public static Contact createContact(String firstName, String lastName, String email, String accountId){
        Contact portalContact = new contact(
            FirstName = firstName, 
            LastName = lastName, 
            Email = email, 
            AccountId = accountId
        );
        return portalContact;
    }
}