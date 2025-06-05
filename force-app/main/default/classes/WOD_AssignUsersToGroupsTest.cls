/**
* @description Test data set up class
*/
@isTest
public class WOD_AssignUsersToGroupsTest {
    
    static testMethod void CreateUserTest2() {
        Test.startTest();
        Profile p = [SELECT Id FROM Profile WHERE Name='EPS TM' limit 1]; 
        User u1 = new User(Alias = 'standt', Email='testcasemanager@bcinsourcing.com1', 
                           EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                           LocaleSidKey='en_US', ProfileId = p.Id, Sales_Org__c='1501',User_Territory_Code__c='TC0457',
                           TimeZoneSidKey='America/Los_Angeles', UserName='testcasemanager@bcinsourcing.com1');
        
        
        System.runAs(u1){
            Territory__c t = new Territory__c();
            t.Name ='WarrantyGroup_Tavant';
            t.Territory_SalesOrg__c ='TC04567';
            t.Sales_Org__c = '1501';
            t.Territory_Code__c='TC04567';
            t.Sales_Rep__c = Userinfo.getUserId();
            insert t;
            Territory__c t2 = new Territory__c();
            t2.Name ='WarrantyGroup_Tavant1';
            t2.Territory_SalesOrg__c ='TC0457';
            t2.Sales_Org__c = '1501';
            t2.Territory_Code__c='TC0457';
            t2.Sales_Rep__c = Userinfo.getUserId();
            insert t2;
        }
        /* Group gp            = new Group();
gp.Name             = 'WarrantyGroup TC04567';
gp.DeveloperName    = 'WarrantyGroup_TC04567';
gp.Type             = 'Regular';
insert gp;
Group gp1            = new Group();
gp1.Name             = 'WarrantyGroup TC0457';
gp1.DeveloperName    = 'WarrantyGroup_TC0457';
gp1.Type             = 'Regular';
insert gp1; */
        User u = new User(Alias = 'standt', Email='testcasemanager@bcinsourcing.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, Sales_Org__c='1501',User_Territory_Code__c='TC0457',
                          TimeZoneSidKey='America/Los_Angeles', UserName='testcasemanager@bcinsourcing.com');
        
        insert  u;
        System.runAs(u){   
            
            Database.executeBatch( new WOD_AssignUsersToGroups((string)u.id));
        }
        
        Test.stopTest();
        
    }
    
}