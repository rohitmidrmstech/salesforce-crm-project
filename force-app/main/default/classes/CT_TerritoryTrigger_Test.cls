@isTest
public class CT_TerritoryTrigger_Test {

    @isTest
    public static void unitTest1() {
        Test.startTest();
        Territory__c territory = new Territory__c();
        insert territory;
        
        String RTID_SoldTo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sold-To').getRecordTypeId();
        String RTID_ShipTo = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Ship-To').getRecordTypeId();
        
        Account soldTo = new Account(Name = 'SoldTo', RecordTypeId = RTID_SoldTo, Territory__c = territory.id, Mechanical_Territory__c = territory.id,
                                    Finishing_Territory__c = territory.id, Z3_Partner__c = territory.id);
        insert soldTo;
        
        
        Account shipTo = new Account(Name = 'shipTo', RecordTypeId = RTID_ShipTo, Territory__c = territory.id, Mechanical_Territory__c = territory.id,
                                    Finishing_Territory__c = territory.id, Z3_Partner__c = territory.id);
        insert shipTo;
        Territory_User__c territoryUser = new Territory_User__c();
        territoryUser.Territory__c = territory.Id;
        territoryUser.User__c = UserInfo.getUserId();
        insert territoryUser;
        
        territory.Sales_Rep__c = UserInfo.getUserId();
        territory.Sales_Org__c = '1300';
        update territory;
        Test.stopTest();
    }
}