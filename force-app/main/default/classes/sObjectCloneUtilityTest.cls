@isTest
public class sObjectCloneUtilityTest {
    public static testmethod void testCaseCloneWithId(){
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GeneralCall').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = rtId;
        cs.Campaign__c = 'MECH';
        insert cs;
        Test.startTest();
        sObjectCloneUtility cloner = new sObjectCloneUtility(
                cs.Id,
                new Set<String>{
                    'Case_Order_Items__r',
                    'Sales_Adjustment_Rebates_Accounts__r'
                },
                true
            );
        	Case beforeClone = (Case) cloner.clone;
            beforeClone.ClosedDate=NULL;
            beforeClone.ParentId = cs.Id;
            beforeClone.Status = 'Draft';
            beforeClone.OwnerId = UserInfo.getUserId();
            cloner.save(); 
        Test.stopTest();
    }
    
    public static testmethod void testCaseCloneWithsObject(){
        Id rtId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GeneralCall').getRecordTypeId();
        Case cs = new Case();
        cs.RecordTypeId = rtId;
        cs.Campaign__c = 'MECH';
        cs.Status='Open';
        insert cs;
        Test.startTest();
        sObjectCloneUtility cloner = new sObjectCloneUtility(
                cs,
                new Set<String>{
                    'Case_Order_Items__r',
                    'Sales_Adjustment_Rebates_Accounts__r'
                },
                true
            );
        	Case beforeClone = (Case) cloner.clone;
        	beforeClone.Id=NULL;
            beforeClone.ParentId = cs.Id;
            beforeClone.Status = 'Draft';
            beforeClone.OwnerId = UserInfo.getUserId();
            cloner.save(); 
        Test.stopTest();
    }
}